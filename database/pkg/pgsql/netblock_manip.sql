-- Copyright (c) 2014-2020 Matthew Ragan
-- Copyright (c) 2019-2023 Todd M. Kover
-- All rights reserved.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--       http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

DO $$
DECLARE
        _tal INTEGER;
BEGIN
        select count(*)
        from pg_catalog.pg_namespace
        into _tal
        where nspname = 'netblock_manip';
        IF _tal = 0 THEN
                DROP SCHEMA IF EXISTS netblock_manip;
                CREATE SCHEMA netblock_manip AUTHORIZATION jazzhands;
		REVOKE USAGE ON SCHEMA netblock_manip FROM public;
		COMMENT ON SCHEMA netblock_manip IS 'part of jazzhands';
        END IF;
END;
$$;

CREATE OR REPLACE FUNCTION netblock_manip.delete_netblock(
	netblock_id	jazzhands.netblock.netblock_id%type
) RETURNS VOID AS $$
DECLARE
	par_nbid	jazzhands.netblock.netblock_id%type;
BEGIN
	/*
	 * Update netblocks that use this as a parent to point to my parent
	 */
	SELECT
		netblock_id INTO par_nbid
	FROM
		jazzhands.netblock n
	WHERE
		n.netblock_id = delete_netblock.netblock_id;

	UPDATE
		jazzhands.netblock n
	SET
		parent_netblock_id = par_nbid
	WHERE
		n.parent_netblock_id = delete_netblock.netblock_id;

	/*
	 * Now delete the record
	 */
	DELETE FROM jazzhands.netblock WHERE netblock_id = delete_netblock.netblock_id;
END;
$$ LANGUAGE plpgsql SET search_path = jazzhands;

CREATE OR REPLACE FUNCTION netblock_manip.recalculate_parentage(
	netblock_id	jazzhands.netblock.netblock_id%type
) RETURNS INTEGER AS $$
DECLARE
	nbrec		RECORD;
	childrec	RECORD;
	nbid		jazzhands.netblock.netblock_id%type;
	ipaddr		inet;

BEGIN
	SELECT * INTO nbrec FROM jazzhands.netblock WHERE
		netblock_id = recalculate_parentage.netblock_id;

	nbid := netblock_utils.find_best_parent_netblock_id(netblock_id);

	UPDATE jazzhands.netblock SET parent_netblock_id = nbid
		WHERE netblock_id = recalculate_parentage.netblock_id;

	FOR childrec IN SELECT *
		FROM jazzhands.netblock  p
		WHERE p.parent_netblock_id = nbid
		AND p.netblock_id != recalculate_parentage.netblock_id
	LOOP
		IF (childrec.ip_address <<= nbrec.ip_address) THEN
			UPDATE jazzhands.netblock  n
				SET parent_netblock_id = recalculate_parentage.netblock_id
				WHERE n.netblock_id = childrec.netblock_id;
		END IF;
	END LOOP;
	RETURN nbid;
END;
$$ LANGUAGE plpgsql SET search_path = jazzhands;

CREATE OR REPLACE FUNCTION netblock_manip.allocate_netblock(
	parent_netblock_id		jazzhands.netblock.netblock_id%TYPE,
	netmask_bits			integer DEFAULT NULL,
	address_type			text DEFAULT 'netblock',
	-- alternatives: 'single', 'loopback'
	can_subnet				boolean DEFAULT true,
	allocation_method		text DEFAULT NULL,
	-- alternatives: 'top', 'bottom', 'random',
	rnd_masklen_threshold	integer DEFAULT 110,
	rnd_max_count			integer DEFAULT 1024,
	ip_address				jazzhands.netblock.ip_address%TYPE DEFAULT NULL,
	description				jazzhands.netblock.description%TYPE DEFAULT NULL,
	netblock_status			jazzhands.netblock.netblock_status%TYPE
								DEFAULT 'Allocated'
) RETURNS SETOF jazzhands.netblock AS $$
DECLARE
	netblock_rec	RECORD;
BEGIN
	RETURN QUERY
		SELECT * into netblock_rec FROM netblock_manip.allocate_netblock(
		parent_netblock_list := ARRAY[parent_netblock_id],
		netmask_bits := netmask_bits,
		address_type := address_type,
		can_subnet := can_subnet,
		description := description,
		allocation_method := allocation_method,
		ip_address := ip_address,
		rnd_masklen_threshold := rnd_masklen_threshold,
		rnd_max_count := rnd_max_count,
		netblock_status := netblock_status
	);
END;
$$ LANGUAGE plpgsql
SET search_path = jazzhands
SECURITY DEFINER;

CREATE OR REPLACE FUNCTION netblock_manip.allocate_netblock(
	parent_netblock_list	integer[],
	netmask_bits			integer DEFAULT NULL,
	address_type			text DEFAULT 'netblock',
	-- alternatives: 'single', 'loopback'
	can_subnet				boolean DEFAULT true,
	allocation_method		text DEFAULT NULL,
	-- alternatives: 'top', 'bottom', 'random',
	rnd_masklen_threshold	integer DEFAULT 110,
	rnd_max_count			integer DEFAULT 1024,
	ip_address				jazzhands.netblock.ip_address%TYPE DEFAULT NULL,
	description				jazzhands.netblock.description%TYPE DEFAULT NULL,
	netblock_status			jazzhands.netblock.netblock_status%TYPE
								DEFAULT 'Allocated'
) RETURNS SETOF jazzhands.netblock AS $$
DECLARE
	parent_rec		RECORD;
	netblock_rec	RECORD;
	inet_rec		RECORD;
	loopback_bits	integer;
	inet_family		integer;
	ip_addr			ALIAS FOR ip_address;
	dns_enabled		boolean;
BEGIN
	IF parent_netblock_list IS NULL THEN
		RAISE 'parent_netblock_list must be specified'
		USING ERRCODE = 'null_value_not_allowed';
	END IF;

	IF address_type NOT IN ('netblock', 'single', 'loopback') THEN
		RAISE 'address_type must be one of netblock, single, or loopback'
		USING ERRCODE = 'invalid_parameter_value';
	END IF;

	IF netmask_bits IS NULL AND address_type = 'netblock' THEN
		RAISE EXCEPTION
			'You must specify a netmask when address_type is netblock'
			USING ERRCODE = 'invalid_parameter_value';
	END IF;

	IF ip_address IS NOT NULL THEN
		SELECT
			array_agg(netblock_id)
		INTO
			parent_netblock_list
		FROM
			netblock n
		WHERE
			ip_addr <<= n.ip_address AND
			netblock_id = ANY(parent_netblock_list);

		IF parent_netblock_list IS NULL THEN
			RETURN;
		END IF;
	END IF;

	SELECT
		COALESCE(property_value_boolean, true)
	INTO
		dns_enabled
	FROM
		property p
	WHERE
		(property_name, property_type) = ('_enable_automated_dns', 'Defaults');

	-- Lock the parent row, which should keep parallel processes from
	-- trying to obtain the same address

	FOR parent_rec IN SELECT * FROM jazzhands.netblock WHERE netblock_id =
			ANY(allocate_netblock.parent_netblock_list) ORDER BY netblock_id
			FOR UPDATE LOOP

		IF parent_rec.is_single_address = true THEN
			RAISE EXCEPTION 'parent_netblock_id refers to a single_address netblock'
				USING ERRCODE = 'invalid_parameter_value';
		END IF;

		IF inet_family IS NULL THEN
			inet_family := family(parent_rec.ip_address);
		ELSIF inet_family != family(parent_rec.ip_address)
				AND ip_address IS NULL THEN
			RAISE EXCEPTION 'Allocation may not mix IPv4 and IPv6 addresses'
			USING ERRCODE = 'JH10F';
		END IF;

		IF address_type = 'loopback' THEN
			loopback_bits :=
				CASE WHEN
					family(parent_rec.ip_address) = 4 THEN 32 ELSE 128 END;

			IF parent_rec.can_subnet = false THEN
				RAISE EXCEPTION 'parent subnet must have can_subnet set to Y'
					USING ERRCODE = 'JH10B';
			END IF;
		ELSIF address_type = 'single' THEN
			IF parent_rec.can_subnet = true THEN
				RAISE EXCEPTION
					'parent subnet for single address must have can_subnet set to N'
					USING ERRCODE = 'JH10B';
			END IF;
		ELSIF address_type = 'netblock' THEN
			IF parent_rec.can_subnet = false THEN
				RAISE EXCEPTION 'parent subnet must have can_subnet set to Y'
					USING ERRCODE = 'JH10B';
			END IF;
		END IF;
	END LOOP;

 	IF NOT FOUND THEN
 		RETURN;
 	END IF;

	IF address_type = 'loopback' THEN
		-- If we're allocating a loopback address, then we need to create
		-- a new parent to hold the single loopback address

		SELECT * INTO inet_rec FROM netblock_utils.find_free_netblocks(
			parent_netblock_list := parent_netblock_list,
			netmask_bits := loopback_bits,
			single_address := false,
			allocation_method := allocation_method,
			desired_ip_address := ip_address,
			max_addresses := 1
			);

		IF NOT FOUND THEN
			RETURN;
		END IF;

		INSERT INTO jazzhands.netblock (
			ip_address,
			netblock_type,
			is_single_address,
			can_subnet,
			ip_universe_id,
			description,
			netblock_status
		) VALUES (
			inet_rec.ip_address,
			inet_rec.netblock_type,
			false,
			false,
			inet_rec.ip_universe_id,
			allocate_netblock.description,
			allocate_netblock.netblock_status
		) RETURNING * INTO parent_rec;

		INSERT INTO jazzhands.netblock (
			ip_address,
			netblock_type,
			is_single_address,
			can_subnet,
			ip_universe_id,
			description,
			netblock_status
		) VALUES (
			inet_rec.ip_address,
			parent_rec.netblock_type,
			true,
			false,
			inet_rec.ip_universe_id,
			allocate_netblock.description,
			allocate_netblock.netblock_status
		) RETURNING * INTO netblock_rec;

		IF dns_enabled THEN
			PERFORM dns_utils.add_domains_from_netblock(
				netblock_id := netblock_rec.netblock_id);
		END IF;

		RETURN NEXT netblock_rec;
		RETURN;
	END IF;

	IF address_type = 'single' THEN
		SELECT * INTO inet_rec FROM netblock_utils.find_free_netblocks(
			parent_netblock_list := parent_netblock_list,
			single_address := true,
			allocation_method := allocation_method,
			desired_ip_address := ip_address,
			rnd_masklen_threshold := rnd_masklen_threshold,
			rnd_max_count := rnd_max_count,
			max_addresses := 1
			);

		IF NOT FOUND THEN
			RETURN;
		END IF;

		RAISE DEBUG 'ip_address is %', inet_rec.ip_address;

		INSERT INTO jazzhands.netblock (
			ip_address,
			netblock_type,
			is_single_address,
			can_subnet,
			ip_universe_id,
			description,
			netblock_status
		) VALUES (
			inet_rec.ip_address,
			inet_rec.netblock_type,
			true,
			false,
			inet_rec.ip_universe_id,
			allocate_netblock.description,
			allocate_netblock.netblock_status
		) RETURNING * INTO netblock_rec;

		RETURN NEXT netblock_rec;
		RETURN;
	END IF;
	IF address_type = 'netblock' THEN
		SELECT * INTO inet_rec FROM netblock_utils.find_free_netblocks(
			parent_netblock_list := parent_netblock_list,
			netmask_bits := netmask_bits,
			single_address := false,
			allocation_method := allocation_method,
			desired_ip_address := ip_address,
			max_addresses := 1);

		IF NOT FOUND THEN
			RETURN;
		END IF;

		INSERT INTO jazzhands.netblock (
			ip_address,
			netblock_type,
			is_single_address,
			can_subnet,
			ip_universe_id,
			description,
			netblock_status
		) VALUES (
			inet_rec.ip_address,
			inet_rec.netblock_type,
			false,
			CASE WHEN can_subnet THEN true ELSE false END,
			inet_rec.ip_universe_id,
			allocate_netblock.description,
			allocate_netblock.netblock_status
		) RETURNING * INTO netblock_rec;

		RAISE DEBUG 'Allocated netblock_id % for %',
			netblock_rec.netblock_id,
			netblock_rec.ip_address;

		IF dns_enabled THEN
			PERFORM dns_utils.add_domains_from_netblock(
				netblock_id := netblock_rec.netblock_id);
		END IF;

		RETURN NEXT netblock_rec;
		RETURN;
	END IF;
END;
$$ LANGUAGE plpgsql
SET search_path = jazzhands
SECURITY DEFINER;


CREATE OR REPLACE FUNCTION netblock_manip.allocate_netblock_from_pool(
	netblock_allocation_pool	jazzhands.netblock_collection.netblock_collection_name%TYPE,
	site_code				jazzhands.site.site_code%TYPE DEFAULT NULL,
	address_family			integer DEFAULT 4,
	netmask_bits			integer DEFAULT NULL,
	address_type			text DEFAULT 'netblock',
	-- alternatives: 'single', 'loopback', 'uplink'
	can_subnet				boolean DEFAULT true,
	allocation_method		text DEFAULT NULL,
	-- alternatives: 'top', 'bottom', 'random',
	rnd_masklen_threshold	integer DEFAULT 110,
	rnd_max_count			integer DEFAULT 1024,
	ip_address				jazzhands.netblock.ip_address%TYPE DEFAULT NULL,
	description				jazzhands.netblock.description%TYPE DEFAULT NULL,
	netblock_status			jazzhands.netblock.netblock_status%TYPE
								DEFAULT 'Allocated'
) RETURNS SETOF jazzhands.netblock AS $$
DECLARE
	sc				ALIAS FOR site_code;
BEGIN
	RETURN QUERY
		SELECT * FROM netblock_manip.allocate_netblock(
		parent_netblock_list := ARRAY(
			SELECT
				netblock_id
			FROM
				netblock_collection nc JOIN
				netblock_collection_netblock ncn USING (netblock_collection_id) JOIN
				netblock n USING (netblock_id) JOIN
				v_site_netblock_expanded sne USING (netblock_id)
			WHERE
				netblock_collection_type = 'NetblockAllocationPool' AND
				netblock_collection_name = netblock_allocation_pool AND
				family(n.ip_address) = address_family AND
				(sc IS NULL OR sne.site_code = sc)
		),
		netmask_bits := netmask_bits,
		address_type := address_type,
		can_subnet := can_subnet,
		description := description,
		allocation_method := allocation_method,
		ip_address := ip_address,
		rnd_masklen_threshold := rnd_masklen_threshold,
		rnd_max_count := rnd_max_count,
		netblock_status := netblock_status
	);
END;
$$ LANGUAGE plpgsql
SET search_path = jazzhands
SECURITY DEFINER;

CREATE OR REPLACE FUNCTION netblock_manip.create_network_range(
	start_ip_address	inet,
	stop_ip_address		inet,
	network_range_type	jazzhands.val_network_range_type.network_range_type%TYPE,
	parent_netblock_id	jazzhands.netblock.netblock_id%TYPE DEFAULT NULL,
	description			jazzhands.network_range.description%TYPE DEFAULT NULL,
	allow_assigned		boolean DEFAULT false,
	dns_prefix			TEXT DEFAULT NULL,
	dns_domain_id		jazzhands.dns_domain.dns_domain_id%TYPE DEFAULT NULL,
	lease_time			jazzhands.network_range.lease_time%TYPE DEFAULT NULL
) RETURNS jazzhands.network_range AS $$
DECLARE
	nbcheck			RECORD;
	start_netblock	RECORD;
	stop_netblock	RECORD;
	netrange		RECORD;
	nrtype			ALIAS FOR network_range_type;
	pnbid			ALIAS FOR parent_netblock_id;
BEGIN
	--
	-- If the network range already exists, then just return it
	--
	SELECT
		nr.* INTO netrange
	FROM
		jazzhands.network_range nr JOIN
		jazzhands.netblock startnb ON (nr.start_netblock_id =
			startnb.netblock_id) JOIN
		jazzhands.netblock stopnb ON (nr.stop_netblock_id = stopnb.netblock_id)
	WHERE
		nr.network_range_type = nrtype AND
		host(startnb.ip_address) = host(start_ip_address) AND
		host(stopnb.ip_address) = host(stop_ip_address) AND
		CASE WHEN pnbid IS NOT NULL THEN
			(pnbid = nr.parent_netblock_id)
		ELSE
			true
		END;

	IF FOUND THEN
		RETURN netrange;
	END IF;

	--
	-- Validate things passed.  This will throw an exception if things aren't
	-- valid
	--

	SELECT * INTO nbcheck FROM netblock_manip.validate_network_range(
		network_range_type := nrtype,
		start_ip_address := start_ip_address,
		stop_ip_address := stop_ip_address,
		parent_netblock_id := parent_netblock_id
	);

	--
	-- Validate that there are not currently any addresses assigned in the
	-- range, unless allow_assigned is set
	--
	IF NOT allow_assigned THEN
		PERFORM
			*
		FROM
			jazzhands.netblock n
		WHERE
			n.parent_netblock_id = nbcheck.parent_netblock_id AND
			host(n.ip_address)::inet > host(start_ip_address)::inet AND
			host(n.ip_address)::inet < host(stop_ip_address)::inet;

		IF FOUND THEN
			RAISE 'create_network_range: netblocks are already present for parent netblock % betweeen % and %',
			nbcheck.parent_netblock_id,
			start_ip_address, stop_ip_address
			USING ERRCODE = 'check_violation';
		END IF;
	END IF;

	--
	-- We should be able to insert things now
	--

	SELECT
		*
	FROM
		jazzhands.netblock n
	INTO
		start_netblock
	WHERE
		host(n.ip_address)::inet = start_ip_address AND
		n.netblock_type = 'network_range' AND
		n.can_subnet = false AND
		n.is_single_address = true AND
		n.ip_universe_id = nbcheck.ip_universe_id;

	IF NOT FOUND THEN
		INSERT INTO netblock (
			ip_address,
			netblock_type,
			is_single_address,
			can_subnet,
			netblock_status,
			ip_universe_id
		) VALUES (
			host(start_ip_address)::inet,
			'network_range',
			true,
			false,
			'Allocated',
			nbcheck.ip_universe_id
		) RETURNING * INTO start_netblock;
	END IF;

	SELECT
		*
	FROM
		jazzhands.netblock n
	INTO
		stop_netblock
	WHERE
		host(n.ip_address)::inet = stop_ip_address AND
		n.netblock_type = 'network_range' AND
		n.can_subnet = false AND
		n.is_single_address = true AND
		n.ip_universe_id = nbcheck.ip_universe_id;

	IF NOT FOUND THEN
		INSERT INTO netblock (
			ip_address,
			netblock_type,
			is_single_address,
			can_subnet,
			netblock_status,
			ip_universe_id
		) VALUES (
			host(stop_ip_address)::inet,
			'network_range',
			true,
			false,
			'Allocated',
			nbcheck.ip_universe_id
		) RETURNING * INTO stop_netblock;
	END IF;

	INSERT INTO network_range (
		network_range_type,
		description,
		parent_netblock_id,
		start_netblock_id,
		stop_netblock_id,
		dns_prefix,
		dns_domain_id,
		lease_time
	) VALUES (
		nrtype,
		description,
		nbcheck.parent_netblock_id,
		start_netblock.netblock_id,
		stop_netblock.netblock_id,
		create_network_range.dns_prefix,
		create_network_range.dns_domain_id,
		create_network_range.lease_time
	) RETURNING * INTO netrange;

	RETURN netrange;

	RETURN NULL;
END;
$$ LANGUAGE plpgsql
SET search_path = jazzhands
SECURITY DEFINER;


CREATE OR REPLACE FUNCTION netblock_manip.update_network_range(
	network_range_id	jazzhands.network_range.network_range_id%TYPE,
	start_ip_address	inet DEFAULT NULL,
	stop_ip_address		inet DEFAULT NULL,
	parent_netblock_id	jazzhands.netblock.netblock_id%TYPE DEFAULT NULL,
	allow_assigned		boolean DEFAULT false,
	description			jazzhands.network_range.description%TYPE DEFAULT NULL,
	dns_prefix			TEXT DEFAULT NULL,
	dns_domain_id		jazzhands.dns_domain.dns_domain_id%TYPE DEFAULT NULL,
	lease_time			jazzhands.network_range.lease_time%TYPE DEFAULT NULL
) RETURNS boolean AS $$
DECLARE
	nbcheck					RECORD;
	start_netblock			RECORD;
	stop_netblock			RECORD;
	new_start_ip_address	inet;
	new_stop_ip_address		inet;
	new_parent_netblock_id	jazzhands.netblock.netblock_id%TYPE;
	netrange				RECORD;
	nrid					ALIAS FOR network_range_id;
	pnbid					ALIAS FOR parent_netblock_id;
BEGIN
	--
	-- Pull things about the network_range.  Fetch things out of the
	-- v_network_range_expanded view because it has everything we want in it.
	--
	SELECT
		nr.* INTO netrange
	FROM
		jazzhands.v_network_range_expanded nr
	WHERE
		nr.network_range_id = nrid;

	IF NOT FOUND THEN
		RAISE EXCEPTION
			'update_network_range: network_range %d does not exist',
			nrid
		USING ERRCODE = 'foreign_key_violation';
	END IF;

	--
	-- Validate things passed.  This will throw an exception if things aren't
	-- valid
	--

	--
	-- Check that the netblock_type for the {start,stop} netblock are
	-- valid if they are trying to be set.  If things are NULL, it's skipped.
	--
	IF
		host(start_ip_address) != host(netrange.start_ip_address) AND
		netrange.start_netblock_type != 'network_range'
	THEN
		RAISE EXCEPTION
			'Address changes of start_ip_address are only allowed if the netblock_type is "network_range"'
		USING ERRCODE = 'check_violation';
	END IF;

	IF
		host(stop_ip_address) != host(netrange.stop_ip_address) AND
		netrange.stop_netblock_type != 'network_range'
	THEN
		RAISE EXCEPTION
			'Address changes of stop_ip_address are only allowed if the netblock_type is "network_range"'
		USING ERRCODE = 'check_violation';
	END IF;

	new_start_ip_address := COALESCE(start_ip_address,
		netrange.start_ip_address);
	new_stop_ip_address := COALESCE(stop_ip_address,
		netrange.stop_ip_address);
	new_parent_netblock_id := COALESCE(parent_netblock_id,
		netrange.parent_netblock_id);

	SELECT * INTO nbcheck FROM netblock_manip.validate_network_range(
		network_range_id := nrid,
		network_range_type := netrange.network_range_type,
		start_ip_address := new_start_ip_address,
		stop_ip_address := new_stop_ip_address,
		parent_netblock_id := new_parent_netblock_id
	);

	--
	-- Validate that there are not currently any addresses assigned in the
	-- updated range, unless allow_assigned is set
	--
	IF NOT allow_assigned THEN
		PERFORM
			*
		FROM
			jazzhands.netblock n
		WHERE
			n.parent_netblock_id = nbcheck.parent_netblock_id AND
			host(n.ip_address)::inet > host(new_start_ip_address)::inet AND
			host(n.ip_address)::inet < host(new_stop_ip_address)::inet;

		IF FOUND THEN
			RAISE 'create_network_range: netblocks are already present for parent netblock % betweeen % and %',
				nbcheck.parent_netblock_id,
				new_start_ip_address,
				new_stop_ip_address
			USING ERRCODE = 'check_violation';
		END IF;
	END IF;

	--
	-- We should be able to update things now
	--

	IF
		host(start_ip_address) != host(netrange.start_ip_address)
	THEN
		UPDATE
			netblock n
		SET
			ip_address = (host(start_ip_address))::inet
		WHERE
			n.netblock_id = netrange.start_netblock_id;
	END IF;

	IF
		host(stop_ip_address) != host(netrange.stop_ip_address)
	THEN
		UPDATE
			netblock n
		SET
			ip_address = (host(stop_ip_address))::inet
		WHERE
			n.netblock_id = netrange.stop_netblock_id;
	END IF;

	IF
		description IS NOT NULL OR
		dns_prefix IS NOT NULL OR
		dns_domain_id IS NOT NULL OR
		lease_time IS NOT NULL
	THEN
		--
		-- This is a hack, but we shouldn't have empty descriptions anyways.
		-- Meh.
		--
		IF description = '' THEN
			description = NULL;
		END IF;

		UPDATE
			network_range nr
		SET
			description = update_network_range.description,
			dns_prefix = update_network_range.dns_prefix,
			dns_domain_id = update_network_range.dns_domain_id,
			lease_time = update_network_range.lease_time
		WHERE
			nr.network_range_id = nrid;
	END IF;

	RETURN true;
END;
$$ LANGUAGE plpgsql
SET search_path = jazzhands
SECURITY DEFINER;

CREATE OR REPLACE FUNCTION netblock_manip.remove_network_range(
	network_range_id jazzhands.network_range.network_range_id%TYPE,
	force	boolean	DEFAULT false
) RETURNS boolean AS $$
DECLARE
	nrrec		RECORD;

	nr_id		ALIAS FOR network_range_id;
BEGIN

	SELECT
		* INTO nrrec
	FROM
		network_range nr
	WHERE
		nr.network_range_id = nr_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'network_range % does not exist', nr_id;
	END IF;

	IF force THEN
		DELETE FROM property p WHERE p.network_range_id = nr_id;
	END IF;

	DELETE FROM network_range nr WHERE nr.network_range_id = nr_id;

	RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = jazzhands;

CREATE OR REPLACE FUNCTION netblock_manip.set_interface_addresses(
	network_interface_id
						jazzhands.layer3_interface.
							layer3_interface_id%TYPE DEFAULT NULL,
	device_id			jazzhands.device.device_id%TYPE DEFAULT NULL,
	network_interface_name
						text DEFAULT NULL,
	network_interface_type
						text DEFAULT 'broadcast',
	ip_address_hash		jsonb DEFAULT NULL,
	create_layer3_networks
						boolean DEFAULT false,
	move_addresses		text DEFAULT 'if_same_device',
	address_errors		text DEFAULT 'error'
) RETURNS boolean AS $$
BEGIN
	RETURN netblock_manip.set_layer3_interface_addresses(
		layer3_interface_id := network_interface_id,
		device_id := device_id,
		layer3_interface_name := network_interface_name,
		layer3_interface_type := network_interface_type,
		ip_address_hash := ip_address_hash,
		create_layer3_networks := create_layer3_networks,
		move_addresses := move_addresses,
		address_errors := address_errors
	);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = jazzhands;

CREATE OR REPLACE FUNCTION netblock_manip.set_layer3_interface_addresses(
	layer3_interface_id
						jazzhands.layer3_interface.
							layer3_interface_id%TYPE DEFAULT NULL,
	device_id			jazzhands.device.device_id%TYPE DEFAULT NULL,
	layer3_interface_name
						text DEFAULT NULL,
	layer3_interface_type
						text DEFAULT 'broadcast',
	ip_address_hash		jsonb DEFAULT NULL,
	create_layer3_networks
						boolean DEFAULT false,
	layer2_network_id	jazzhands.layer2_network.layer2_network_id%TYPE
						DEFAULT NULL,
	move_addresses		text DEFAULT 'if_same_device',
	address_errors		text DEFAULT 'error'
) RETURNS boolean AS $$
--
-- ip_address_hash consists of the following elements
--
--		"ip_addresses" : [ (inet | netblock) ... ]
--		"shared_ip_addresses" : [ (inet | netblock) ... ]
--
-- where inet is a text string that can be legally converted to type inet
-- and netblock is a JSON object with fields:
--		"ip_address" : inet
--		"ip_universe_id" : integer (default 0)
--		"netblock_type" : text (default 'default')
--		"protocol" : text (default 'VRRP')
--
-- If either "ip_addresses" or "shared_ip_addresses" does not exist, it
-- will not be processed.  If the key is present and is an empty array or
-- null, then all IP addresses of those types will be removed from the
-- interface
--
-- 'protocol' is only valid for shared addresses, which is how the address
-- is shared.  Valid values can be found in the val_shared_netblock_protocol
-- table
--
DECLARE
	l3i_id			ALIAS FOR layer3_interface_id;
	dev_id			ALIAS FOR device_id;
	l3i_name		ALIAS FOR layer3_interface_name;
	l3i_type		ALIAS FOR layer3_interface_type;

	addrs_ary		jsonb;
	ipaddr			inet;
	universe		integer;
	nb_type			text;
	protocol		text;

	c				integer;
	i				integer;

	error_rec		RECORD;
	nb_rec			RECORD;
	pnb_rec			RECORD;
	layer3_rec		RECORD;
	sn_rec			RECORD;
	l3i_rec			RECORD;
	l3in_rec		RECORD;
	nb_id			jazzhands.netblock.netblock_id%TYPE;
	nb_id_ary		integer[];
	l3i_id_ary		integer[];
	del_list		integer[];
BEGIN
	--
	-- Validate that we got enough information passed to do things
	--

	IF ip_address_hash IS NULL OR NOT
		(jsonb_typeof(ip_address_hash) = 'object')
	THEN
		RAISE 'Must pass ip_addresses to netblock_manip.set_interface_addresses';
	END IF;

	IF layer3_interface_id IS NULL THEN
		IF device_id IS NULL OR layer3_interface_name IS NULL THEN
			RAISE 'netblock_manip.assign_shared_netblock: must pass either layer3_interface_id or device_id and layer3_interface_name'
			USING ERRCODE = 'invalid_parameter_value';
		END IF;

		SELECT
			l3i.layer3_interface_id INTO l3i_id
		FROM
			layer3_interface l3i
		WHERE
			l3i.device_id = dev_id AND
			l3i.layer3_interface_name = l3i_name;

		IF NOT FOUND THEN
			INSERT INTO layer3_interface(
				device_id,
				layer3_interface_name,
				layer3_interface_type,
				should_monitor
			) VALUES (
				dev_id,
				l3i_name,
				l3i_type,
				false
			) RETURNING layer3_interface.layer3_interface_id INTO l3i_id;
		END IF;
	END IF;

	SELECT * INTO l3i_rec FROM layer3_interface l3i WHERE
		l3i.layer3_interface_id = l3i_id;

	--
	-- First, loop through ip_addresses passed and process those
	--

	IF ip_address_hash ? 'ip_addresses' AND
		jsonb_typeof(ip_address_hash->'ip_addresses') = 'array'
	THEN
		RAISE DEBUG 'Processing ip_addresses...';
		--
		-- Loop through each member of the ip_addresses array
		-- and process each address
		--
		addrs_ary := ip_address_hash->'ip_addresses';
		c := jsonb_array_length(addrs_ary);
		i := 0;
		nb_id_ary := NULL;
		WHILE (i < c) LOOP
			IF jsonb_typeof(addrs_ary->i) = 'string' THEN
				--
				-- If this is a string, use it as an inet with default
				-- universe and netblock_type
				--
				ipaddr := addrs_ary->>i;
				universe := netblock_utils.find_best_ip_universe(ipaddr);
				nb_type := 'default';
			ELSIF jsonb_typeof(addrs_ary->i) = 'object' THEN
				--
				-- If this is an object, require 'ip_address' key
				-- optionally use 'ip_universe_id' and 'netblock_type' keys
				-- to override the defaults
				--
				IF NOT addrs_ary->i ? 'ip_address' THEN
					RAISE E'Object in array element % of ip_addresses in ip_address_hash in netblock_manip.set_interface_addresses does not contain ip_address key:\n%',
						i, jsonb_pretty(addrs_ary->i);
				END IF;
				ipaddr := addrs_ary->i->>'ip_address';

				IF addrs_ary->i ? 'ip_universe_id' THEN
					universe := addrs_ary->i->'ip_universe_id';
				ELSE
					universe := netblock_utils.find_best_ip_universe(ipaddr);
				END IF;

				IF addrs_ary->i ? 'netblock_type' THEN
					nb_type := addrs_ary->i->>'netblock_type';
				ELSE
					nb_type := 'default';
				END IF;
			ELSE
				RAISE 'Invalid type in array element % of ip_addresses in ip_address_hash in netblock_manip.set_interface_addresses (%)',
					i, jsonb_typeof(addrs_ary->i);
			END IF;
			--
			-- We're done with the array, so increment the counter so
			-- we don't have to deal with it later
			--
			i := i + 1;

			RAISE DEBUG 'Address is %, universe is %, nb type is %',
				ipaddr, universe, nb_type;

			--
			-- This is a hack, because Juniper is really annoying about this.
			-- If masklen < 8, then ignore this netblock (we specifically
			-- want /8, because of 127/8 and 10/8, which someone could
			-- maybe want to not subnet.
			--
			-- This should probably be a configuration parameter, but it's not.
			--
			CONTINUE WHEN masklen(ipaddr) < 8;

			--
			-- Check to see if this is a netblock that we have been
			-- told to explicitly ignore
			--
			PERFORM
				ip_address
			FROM
				netblock n JOIN
				netblock_collection_netblock ncn USING (netblock_id) JOIN
				v_netblock_collection_expanded nce USING (netblock_collection_id)
					JOIN
				property p ON (
					property_name = 'IgnoreProbedNetblocks' AND
					property_type = 'DeviceInventory' AND
					property_value_netblock_collection_id =
						nce.root_netblock_collection_id
				)
			WHERE
				ipaddr <<= n.ip_address AND
				n.ip_universe_id = universe
			;

			--
			-- If we found this netblock in the ignore list, then just
			-- skip it
			--
			IF FOUND THEN
				RAISE DEBUG 'Skipping ignored address %', ipaddr;
				CONTINUE;
			END IF;

			--
			-- Look for an is_single_address=true, can_subnet=false netblock
			-- with the given ip_address
			--
			SELECT
				* INTO nb_rec
			FROM
				netblock n
			WHERE
				is_single_address = true AND
				can_subnet = false AND
				netblock_type = nb_type AND
				ip_universe_id = universe AND
				host(ip_address) = host(ipaddr);

			IF FOUND THEN
				RAISE DEBUG E'Located netblock:\n%',
					jsonb_pretty(to_jsonb(nb_rec));

				nb_id_ary := array_append(nb_id_ary, nb_rec.netblock_id);

				--
				-- Look to see if there's a layer3_network for the
				-- parent netblock
				--
				SELECT
					n.netblock_id,
					n.ip_address,
					layer3_network_id,
					default_gateway_netblock_id
				INTO layer3_rec
				FROM
					netblock n LEFT JOIN
					layer3_network l3 USING (netblock_id)
				WHERE
					n.netblock_id = nb_rec.parent_netblock_id;

				IF FOUND THEN
					RAISE DEBUG E'Located layer3_network:\n%',
						jsonb_pretty(to_jsonb(layer3_rec));
				ELSE
					--
					-- If we're told to create the layer3_network,
					-- then do that, otherwise go to the next address
					--
					CONTINUE WHEN NOT create_layer3_networks;
					INSERT INTO layer3_network(
						netblock_id, layer2_network_id
					) VALUES (
						layer3_rec.netblock_id, layer2_network_id
					) RETURNING layer3_network_id INTO
						layer3_rec.layer3_network_id;
				END IF;
			ELSE
				--
				-- If the parent netblock does not exist, then create it
				-- if we were passed the option to
				--
				SELECT
					n.netblock_id,
					n.ip_address,
					layer3_network_id,
					default_gateway_netblock_id
				INTO layer3_rec
				FROM
					netblock n LEFT JOIN
					layer3_network l3 USING (netblock_id)
				WHERE
					n.ip_universe_id = universe AND
					n.netblock_type = nb_type AND
					is_single_address = false AND
					can_subnet = false AND
					n.ip_address >>= ipaddr;

				IF NOT FOUND THEN
					RAISE DEBUG 'Parent netblock with ip_address %, netblock_type %, ip_universe_id % not found',
						network(ipaddr),
						nb_type,
						universe;
					CONTINUE WHEN NOT create_layer3_networks;
					--
					-- Check to see if the netblock exists, but is
					-- marked can_subnet=true.  If so, fix it
					--
					SELECT
						* INTO pnb_rec
					FROM
						netblock n
					WHERE
						n.ip_universe_id = universe AND
						n.netblock_type = nb_type AND
						n.is_single_address = false AND
						n.can_subnet = true AND
						n.ip_address = network(ipaddr);

					IF FOUND THEN
						UPDATE netblock n SET
							can_subnet = false
						WHERE
							n.netblock_id = pnb_rec.netblock_id;
						pnb_rec.can_subnet = false;
					ELSE
						INSERT INTO netblock (
							ip_address,
							netblock_type,
							is_single_address,
							can_subnet,
							ip_universe_id,
							netblock_status
						) VALUES (
							network(ipaddr),
							nb_type,
							false,
							false,
							universe,
							'Allocated'
						) RETURNING * INTO pnb_rec;
					END IF;

					WITH l3_ins AS (
						INSERT INTO layer3_network(
							netblock_id, layer2_network_id
						) VALUES (
							pnb_rec.netblock_id, layer2_network_id
						) RETURNING *
					)
					SELECT
						pnb_rec.netblock_id,
						pnb_rec.ip_address,
						l3_ins.layer3_network_id,
						l3_ins.layer2_network_Id,
						NULL::inet
					INTO layer3_rec
					FROM
						l3_ins;
				ELSIF layer3_rec.layer3_network_id IS NULL THEN
					--
					-- If we're told to create the layer3_network,
					-- then do that, otherwise go to the next address
					--

					RAISE DEBUG 'layer3_network for parent netblock % not found (ip_address %, netblock_type %, ip_universe_id %)',
						layer3_rec.netblock_id,
						network(ipaddr),
						nb_type,
						universe;
					CONTINUE WHEN NOT create_layer3_networks;
					INSERT INTO layer3_network(
						netblock_id, layer2_network_id
					) VALUES (
						layer3_rec.netblock_id, layer2_network_id
					) RETURNING layer3_network_id INTO
						layer3_rec.layer3_network_id;
				END IF;
				RAISE DEBUG E'Located layer3_network:\n%',
					jsonb_pretty(to_jsonb(layer3_rec));
				--
				-- Parents should be all set up now.  Insert the netblock
				--
				INSERT INTO netblock (
					ip_address,
					netblock_type,
					ip_universe_id,
					is_single_address,
					can_subnet,
					netblock_status
				) VALUES (
					ipaddr,
					nb_type,
					universe,
					true,
					false,
					'Allocated'
				) RETURNING * INTO nb_rec;
				nb_id_ary := array_append(nb_id_ary, nb_rec.netblock_id);
			END IF;
			--
			-- Now that we have the netblock and everything, check to see
			-- if this netblock is already assigned to this layer3_interface
			--
			PERFORM * FROM
				layer3_interface_netblock l3in
			WHERE
				l3in.netblock_id = nb_rec.netblock_id AND
				l3in.layer3_interface_id = l3i_id;

			IF FOUND THEN
				RAISE DEBUG 'Netblock % already found on layer3_interface',
					nb_rec.netblock_id;
				CONTINUE;
			END IF;

			--
			-- See if this netblock is on something else, and delete it
			-- if move_addresses is set, otherwise skip it
			--
			SELECT
				l3i.layer3_interface_id,
				l3i.layer3_interface_name,
				l3in.netblock_id,
				d.device_id,
				COALESCE(d.device_name, d.physical_label) AS device_name
			INTO l3in_rec
			FROM
				layer3_interface_netblock l3in JOIN
				layer3_interface l3i USING (layer3_interface_id) JOIN
				device d ON (l3in.device_id = d.device_id)
			WHERE
				l3in.netblock_id = nb_rec.netblock_id AND
				l3in.layer3_interface_id != l3i_id;

			IF FOUND THEN
				IF move_addresses = 'always' OR (
					move_addresses = 'if_same_device' AND
					l3in_rec.device_id = l3i_rec.device_id
				)
				THEN
					DELETE FROM
						layer3_interface_netblock
					WHERE
						netblock_id = nb_rec.netblock_id;
				ELSE
					IF address_errors = 'ignore' THEN
						RAISE DEBUG 'Netblock % is assigned to layer3_interface %',
							nb_rec.netblock_id, l3in_rec.layer3_interface_id;

						CONTINUE;
					ELSIF address_errors = 'warn' THEN
						RAISE NOTICE 'Netblock % (%) is assigned to layer3_interface % (%) on device % (%)',
							nb_rec.netblock_id,
							nb_rec.ip_address,
							l3in_rec.layer3_interface_id,
							l3in_rec.layer3_interface_name,
							l3in_rec.device_id,
							l3in_rec.device_name;

						CONTINUE;
					ELSE
						RAISE 'Netblock % (%) is assigned to layer3_interface %(%) on device % (%)',
							nb_rec.netblock_id,
							nb_rec.ip_address,
							l3in_rec.layer3_interface_id,
							l3in_rec.layer3_interface_name,
							l3in_rec.device_id,
							l3in_rec.device_name;
					END IF;
				END IF;
			END IF;

			--
			-- See if this netblock is on a shared_address somewhere, and
			-- move it only if move_addresses is 'always'
			--
			SELECT * FROM
				shared_netblock sn
			INTO sn_rec
			WHERE
				sn.netblock_id = nb_rec.netblock_id;

			IF FOUND THEN
				IF move_addresses IS NULL OR move_addresses != 'always' THEN
					IF address_errors = 'ignore' THEN
						RAISE DEBUG 'Netblock % is assigned to a shared_network %, but not forcing, so skipping',
							nb_rec.netblock_id, sn_rec.shared_netblock_id;
						CONTINUE;
					ELSIF address_errors = 'warn' THEN
						RAISE NOTICE 'Netblock % (%) is assigned to a shared_network %, but not forcing, so skipping',
							nb_rec.netblock_id, nb_rec.ip_address,
							sn_rec.shared_netblock_id;
						CONTINUE;
					ELSE
						RAISE 'Netblock % (%) is assigned to a shared_network %, but not forcing, so skipping',
							nb_rec.netblock_id, nb_rec.ip_address,
							sn_rec.shared_netblock_id;
						CONTINUE;
					END IF;
				END IF;

				DELETE FROM
					shared_netblock_layer3_interface snl3i
				WHERE
					snl3i.shared_netblock_id = sn_rec.shared_netblock_id;

				DELETE FROM
					shared_network sn
				WHERE
					sn.netblock_id = sn_rec.shared_netblock_id;
			END IF;

			--
			-- Insert the netblock onto the interface using the next
			-- rank
			--
			INSERT INTO layer3_interface_netblock (
				layer3_interface_id,
				netblock_id,
				layer3_interface_rank
			) SELECT
				l3i_id,
				nb_rec.netblock_id,
				COALESCE(MAX(layer3_interface_rank) + 1, 0)
			FROM
				layer3_interface_netblock l3in
			WHERE
				l3in.layer3_interface_id = l3i_id
			RETURNING * INTO l3in_rec;

			PERFORM dns_manip.set_dns_for_interface(
				netblock_id := nb_rec.netblock_id,
				layer3_interface_name := l3i_name,
				device_id := l3in_rec.device_id
			);

			RAISE DEBUG E'Inserted into:\n%',
				jsonb_pretty(to_jsonb(l3in_rec));
		END LOOP;
		--
		-- Remove any netblocks that are on the interface that are not
		-- supposed to be (and that aren't ignored).
		--

		FOR l3in_rec IN
			DELETE FROM
				layer3_interface_netblock l3in
			WHERE
				(l3in.layer3_interface_id, l3in.netblock_id) IN (
				SELECT
					l3in2.layer3_interface_id,
					l3in2.netblock_id
				FROM
					layer3_interface_netblock l3in2 JOIN
					netblock n USING (netblock_id)
				WHERE
					l3in2.layer3_interface_id = l3i_id AND NOT (
						l3in.netblock_id = ANY(nb_id_ary) OR
						n.ip_address <<= ANY ( ARRAY (
							SELECT
								n2.ip_address
							FROM
								netblock n2 JOIN
								netblock_collection_netblock ncn USING
									(netblock_id) JOIN
								v_netblock_collection_expanded nce USING
									(netblock_collection_id) JOIN
								property p ON (
									property_name = 'IgnoreProbedNetblocks' AND
									property_type = 'DeviceInventory' AND
									property_value_netblock_collection_id =
										nce.root_netblock_collection_id
								)
						))
					)
			)
			RETURNING *
		LOOP
			RAISE DEBUG 'Removed netblock % from layer3_interface %',
				l3in_rec.netblock_id,
				l3in_rec.layer3_interface_id;
			--
			-- Remove any DNS records and/or netblocks that aren't used
			--
			BEGIN
				DELETE FROM dns_record WHERE netblock_id = l3in_rec.netblock_id;
				DELETE FROM netblock_collection_netblock WHERE
					netblock_id = l3in_rec.netblock_id;
				DELETE FROM netblock WHERE netblock_id =
					l3in_rec.netblock_id;
			EXCEPTION
				WHEN foreign_key_violation THEN NULL;
			END;
		END LOOP;
	END IF;

	--
	-- Loop through shared_ip_addresses passed and process those
	--

	IF ip_address_hash ? 'shared_ip_addresses' AND
		jsonb_typeof(ip_address_hash->'shared_ip_addresses') = 'array'
	THEN
		RAISE DEBUG 'Processing shared_ip_addresses...';
		--
		-- Loop through each member of the shared_ip_addresses array
		-- and process each address
		--
		addrs_ary := ip_address_hash->'shared_ip_addresses';
		c := jsonb_array_length(addrs_ary);
		i := 0;
		nb_id_ary := NULL;
		WHILE (i < c) LOOP
			IF jsonb_typeof(addrs_ary->i) = 'string' THEN
				--
				-- If this is a string, use it as an inet with default
				-- universe and netblock_type
				--
				ipaddr := addrs_ary->>i;
				universe := netblock_utils.find_best_ip_universe(ipaddr);
				nb_type := 'default';
				protocol := 'VRRP';
			ELSIF jsonb_typeof(addrs_ary->i) = 'object' THEN
				--
				-- If this is an object, require 'ip_address' key
				-- optionally use 'ip_universe_id' and 'netblock_type' keys
				-- to override the defaults
				--
				IF NOT addrs_ary->i ? 'ip_address' THEN
					RAISE E'Object in array element % of shared_ip_addresses in ip_address_hash in netblock_manip.set_interface_addresses does not contain ip_address key:\n%',
						i, jsonb_pretty(addrs_ary->i);
				END IF;
				ipaddr := addrs_ary->i->>'ip_address';

				IF addrs_ary->i ? 'ip_universe_id' THEN
					universe := addrs_ary->i->'ip_universe_id';
				ELSE
					universe := netblock_utils.find_best_ip_universe(ipaddr);
				END IF;

				IF addrs_ary->i ? 'netblock_type' THEN
					nb_type := addrs_ary->i->>'netblock_type';
				ELSE
					nb_type := 'default';
				END IF;

				IF addrs_ary->i ? 'shared_netblock_protocol' THEN
					protocol := addrs_ary->i->>'shared_netblock_protocol';
				ELSIF addrs_ary->i ? 'protocol' THEN
					protocol := addrs_ary->i->>'protocol';
				ELSE
					protocol := 'VRRP';
				END IF;
			ELSE
				RAISE 'Invalid type in array element % of shared_ip_addresses in ip_address_hash in netblock_manip.set_interface_addresses (%)',
					i, jsonb_typeof(addrs_ary->i);
			END IF;
			--
			-- We're done with the array, so increment the counter so
			-- we don't have to deal with it later
			--
			i := i + 1;

			RAISE DEBUG 'Address is %, universe is %, nb type is %',
				ipaddr, universe, nb_type;

			--
			-- Check to see if this is a netblock that we have been
			-- told to explicitly ignore
			--
			PERFORM
				ip_address
			FROM
				netblock n JOIN
				netblock_collection_netblock ncn USING (netblock_id) JOIN
				v_netblock_collection_expanded nce USING (netblock_collection_id)
					JOIN
				property p ON (
					property_name = 'IgnoreProbedNetblocks' AND
					property_type = 'DeviceInventory' AND
					property_value_netblock_collection_id =
						nce.root_netblock_collection_id
				)
			WHERE
				ipaddr <<= n.ip_address AND
				n.ip_universe_id = universe AND
				n.netblock_type = nb_type;

			--
			-- If we found this netblock in the ignore list, then just
			-- skip it
			--
			IF FOUND THEN
				RAISE DEBUG 'Skipping ignored address %', ipaddr;
				CONTINUE;
			END IF;

			--
			-- Look for an is_single_address=true, can_subnet=false netblock
			-- with the given ip_address
			--
			SELECT
				* INTO nb_rec
			FROM
				netblock n
			WHERE
				is_single_address = true AND
				can_subnet = false AND
				netblock_type = nb_type AND
				ip_universe_id = universe AND
				host(ip_address) = host(ipaddr);

			IF FOUND THEN
				RAISE DEBUG E'Located netblock:\n%',
					jsonb_pretty(to_jsonb(nb_rec));

				nb_id_ary := array_append(nb_id_ary, nb_rec.netblock_id);

				--
				-- Look to see if there's a layer3_network for the
				-- parent netblock
				--
				SELECT
					n.netblock_id,
					n.ip_address,
					layer3_network_id,
					default_gateway_netblock_id
				INTO layer3_rec
				FROM
					netblock n LEFT JOIN
					layer3_network l3 USING (netblock_id)
				WHERE
					n.netblock_id = nb_rec.parent_netblock_id;

				IF FOUND THEN
					RAISE DEBUG E'Located layer3_network:\n%',
						jsonb_pretty(to_jsonb(layer3_rec));
				ELSE
					--
					-- If we're told to create the layer3_network,
					-- then do that, otherwise go to the next address
					--
					CONTINUE WHEN NOT create_layer3_networks;
					INSERT INTO layer3_network(
						netblock_id, layer2_network_id
					) VALUES (
						layer3_rec.netblock_id, layer2_network_id
					) RETURNING layer3_network_id INTO
						layer3_rec.layer3_network_id;
				END IF;
			ELSE
				--
				-- If the parent netblock does not exist, then create it
				-- if we were passed the option to
				--
				SELECT
					n.netblock_id,
					n.ip_address,
					layer3_network_id,
					default_gateway_netblock_id
				INTO layer3_rec
				FROM
					netblock n LEFT JOIN
					layer3_network l3 USING (netblock_id)
				WHERE
					n.ip_universe_id = universe AND
					n.netblock_type = nb_type AND
					is_single_address = false AND
					can_subnet = false AND
					n.ip_address >>= ipaddr;

				IF NOT FOUND THEN
					RAISE DEBUG 'Parent netblock with ip_address %, netblock_type %, ip_universe_id % not found',
						network(ipaddr),
						nb_type,
						universe;
					CONTINUE WHEN NOT create_layer3_networks;
					WITH nb_ins AS (
						INSERT INTO netblock (
							ip_address,
							netblock_type,
							is_single_address,
							can_subnet,
							ip_universe_id,
							netblock_status
						) VALUES (
							network(ipaddr),
							nb_type,
							false,
							false,
							universe,
							'Allocated'
						) RETURNING *
					), l3_ins AS (
						INSERT INTO layer3_network(
							netblock_id, layer2_network_id
						)
						SELECT
							netblock_id, layer2_network_id
						FROM
							nb_ins
						RETURNING *
					)
					SELECT
						nb_ins.netblock_id,
						nb_ins.ip_address,
						l3_ins.layer3_network_id,
						NULL
					INTO layer3_rec
					FROM
						nb_ins,
						l3_ins;
				ELSIF layer3_rec.layer3_network_id IS NULL THEN
					--
					-- If we're told to create the layer3_network,
					-- then do that, otherwise go to the next address
					--

					RAISE DEBUG 'layer3_network for parent netblock % not found (ip_address %, netblock_type %, ip_universe_id %)',
						layer3_rec.netblock_id,
						network(ipaddr),
						nb_type,
						universe;
					CONTINUE WHEN NOT create_layer3_networks;
					INSERT INTO layer3_network(
						netblock_id, layer2_network_id
					) VALUES (
						layer3_rec.netblock_id, layer2_network_id
					) RETURNING layer3_network_id INTO
						layer3_rec.layer3_network_id;
				END IF;
				RAISE DEBUG E'Located layer3_network:\n%',
					jsonb_pretty(to_jsonb(layer3_rec));
				--
				-- Parents should be all set up now.  Insert the netblock
				--
				INSERT INTO netblock (
					ip_address,
					netblock_type,
					ip_universe_id,
					is_single_address,
					can_subnet,
					netblock_status
				) VALUES (
					ipaddr,
					nb_type,
					universe,
					true,
					false,
					'Allocated'
				) RETURNING * INTO nb_rec;
				nb_id_ary := array_append(nb_id_ary, nb_rec.netblock_id);
			END IF;

			--
			-- See if this netblock is directly on any layer3_interface, and
			-- delete it if force is set, otherwise skip it
			--
			l3i_id_ary := ARRAY[]::integer[];

			SELECT
				l3in.netblock_id,
				l3i.layer3_interface_id,
				l3i.device_id
			INTO l3in_rec
			FROM
				layer3_interface_netblock l3in JOIN
				layer3_interface l3i USING (layer3_interface_id)
			WHERE
				l3in.netblock_id = nb_rec.netblock_id AND
				l3in.layer3_interface_id != l3i_id;

			IF FOUND THEN
				IF move_addresses = 'always' OR (
					move_addresses = 'if_same_device' AND
					l3in_rec.device_id = l3i_rec.device_id
				)
				THEN
					--
					-- Remove the netblocks from the layer3_interfaces,
					-- but save them for later so that we can migrate them
					-- after we make sure the shared_netblock exists.
					--
					-- Also, append the network_inteface_id that we
					-- specifically care about, and we'll add them all
					-- below
					--
					WITH z AS (
						DELETE FROM
							layer3_interface_netblock
						WHERE
							netblock_id = nb_rec.netblock_id
						RETURNING layer3_interface_id
					)
					SELECT array_agg(layer3_interface_id) FROM
						(SELECT layer3_interface_id FROM z) v
					INTO l3i_id_ary;
				ELSE
					IF address_errors = 'ignore' THEN
						RAISE DEBUG 'Netblock % is assigned to layer3_interface %',
							nb_rec.netblock_id, l3in_rec.layer3_interface_id;

						CONTINUE;
					ELSIF address_errors = 'warn' THEN
						RAISE NOTICE 'Netblock % is assigned to layer3_interface %',
							nb_rec.netblock_id, l3in_rec.layer3_interface_id;

						CONTINUE;
					ELSE
						RAISE 'Netblock % is assigned to layer3_interface %',
							nb_rec.netblock_id, l3in_rec.layer3_interface_id;
					END IF;
				END IF;

			END IF;

			IF NOT(l3i_id = ANY(l3i_id_ary)) THEN
				l3i_id_ary := array_append(l3i_id_ary, l3i_id);
			END IF;

			--
			-- See if this netblock already belongs to a shared_network
			--
			SELECT * FROM
				shared_netblock sn
			INTO sn_rec
			WHERE
				sn.netblock_id = nb_rec.netblock_id;

			IF FOUND THEN
				IF sn_rec.shared_netblock_protocol != protocol THEN
					RAISE 'Netblock % (%) is assigned to shared_network %, but the shared_network_protocol does not match (% vs. %)',
						nb_rec.netblock_id,
						nb_rec.ip_address,
						sn_rec.shared_netblock_id,
						sn_rec.shared_netblock_protocol,
						protocol;
				END IF;
			ELSE
				INSERT INTO shared_netblock (
					shared_netblock_protocol,
					netblock_id
				) VALUES (
					protocol,
					nb_rec.netblock_id
				) RETURNING * INTO sn_rec;
			END IF;

			--
			-- Add this to any interfaces that we found above that
			-- need this
			--

			INSERT INTO shared_netblock_layer3_interface (
				shared_netblock_id,
				layer3_interface_id,
				priority
			) SELECT
				sn_rec.shared_netblock_id,
				x.layer3_interface_id,
				0
			FROM
				unnest(l3i_id_ary) x(layer3_interface_id)
			ON CONFLICT ON CONSTRAINT pk_ip_group_network_interface DO NOTHING;

			RAISE DEBUG E'Inserted shared_netblock % onto interfaces:\n%',
				sn_rec.shared_netblock_id, jsonb_pretty(to_jsonb(l3i_id_ary));

			--
			-- If this shared netblock is VARP or VRRP, and we are to assume default gateway,
			-- update accordingly.
			--
			IF protocol IN ('VARP', 'VRRP') THEN
				UPDATE layer3_network
				SET default_gateway_netblock_id = sn_rec.netblock_id
				WHERE layer3_network_id = layer3_rec.layer3_network_id
				AND default_gateway_netblock_id IS DISTINCT FROM sn_rec.netblock_id;

				PERFORM dns_manip.set_dns_for_shared_routing_addresses(sn_rec.netblock_id);
			END IF;
		END LOOP;
		--
		-- Remove any shared_netblocks that are on the interface that are not
		-- supposed to be (and that aren't ignored).
		--

		FOR l3in_rec IN
			DELETE FROM
				shared_netblock_layer3_interface snl3i
			WHERE
				(snl3i.layer3_interface_id, snl3i.shared_netblock_id) IN (
				SELECT
					snl3i2.layer3_interface_id,
					snl3i2.shared_netblock_id
				FROM
					shared_netblock_layer3_interface snl3i2 JOIN
					shared_netblock sn USING (shared_netblock_id) JOIN
					netblock n USING (netblock_id)
				WHERE
					snl3i2.layer3_interface_id = l3i_id AND NOT (
						sn.netblock_id = ANY(nb_id_ary) OR
						n.ip_address <<= ANY ( ARRAY (
							SELECT
								n2.ip_address
							FROM
								netblock n2 JOIN
								netblock_collection_netblock ncn USING
									(netblock_id) JOIN
								v_netblock_collection_expanded nce USING
									(netblock_collection_id) JOIN
								property p ON (
									property_name = 'IgnoreProbedNetblocks' AND
									property_type = 'DeviceInventory' AND
									property_value_netblock_collection_id =
										nce.root_netblock_collection_id
								)
						))
					)
			)
			RETURNING *
		LOOP
			RAISE DEBUG 'Removed shared_netblock % from layer3_interface %',
				l3in_rec.shared_netblock_id,
				l3in_rec.layer3_interface_id;

			--
			-- Remove any DNS records, netblocks and shared_netblocks
			-- that aren't used
			--
			SELECT netblock_id INTO nb_id FROM shared_netblock sn WHERE
				sn.shared_netblock_id = l3in_rec.shared_netblock_id;
			BEGIN
				DELETE FROM dns_record WHERE netblock_id = nb_id;
				DELETE FROM netblock_collection_netblock ncn WHERE
					ncn.netblock_id = nb_id;
				DELETE FROM shared_netblock WHERE netblock_id = nb_id;
				DELETE FROM netblock WHERE netblock_id = nb_id;
			EXCEPTION
				WHEN foreign_key_violation THEN NULL;
			END;
		END LOOP;
	END IF;
	RETURN true;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER SET search_path = jazzhands;

CREATE OR REPLACE FUNCTION netblock_manip.validate_network_range(
	network_range_id	jazzhands.network_range.network_range_id%TYPE DEFAULT NULL,
	start_ip_address	inet DEFAULT NULL,
	stop_ip_address		inet DEFAULT NULL,
	network_range_type	jazzhands.val_network_range_type.network_range_type%TYPE DEFAULT NULL,
	parent_netblock_id	jazzhands.netblock.netblock_id%TYPE DEFAULT NULL
) RETURNS jazzhands.v_network_range_expanded AS $$
DECLARE
	proposed_range	jazzhands.v_network_range_expanded%ROWTYPE;
	current_range	jazzhands.v_network_range_expanded%ROWTYPE;
	par_netblock	RECORD;
	start_netblock	RECORD;
	stop_netblock	RECORD;
	nrt				RECORD;
	temprange		RECORD;

	nr_id			ALIAS FOR network_range_id;
	nr_type			ALIAS FOR network_range_type;
	nr_start_addr	ALIAS FOR start_ip_address;
	nr_stop_addr	ALIAS FOR stop_ip_address;
	pnbid			ALIAS FOR parent_netblock_id;
BEGIN
	--
	-- If network_range_id is passed, because we're modifying an existing
	-- one, pull it in, otherwise populate a new one
	--
	IF nr_id IS NOT NULL THEN
		SELECT
			* INTO current_range
		FROM
			v_network_range_expanded nr
		WHERE
			nr.network_range_id = nr_id;

		IF NOT FOUND THEN
			RAISE 'network_range with network_range_id % does not exist',
				nr_id
				USING ERRCODE = 'foreign_key_violation';
		END IF;
	END IF;
	--
	-- Make a copy of the current range if it exists.
	--
	proposed_range := current_range;

	--
	-- Don't allow network_range_type to be changed
	--
	IF
		nr_type != proposed_range.network_range_type
	THEN
		RAISE 'network_range_type may not be changed'
			USING ERRCODE = 'check_violation';
	END IF;

	--
	-- Set anything that's passed into the proposed network_range
	--
	proposed_range.network_range_type :=
		COALESCE(nr_type, proposed_range.network_range_type);

	SELECT
		* INTO nrt
	FROM
		val_network_range_type v
	WHERE
		v.network_range_type = proposed_range.network_range_type;

	IF NOT FOUND THEN
		RAISE 'invalid network_range_type'
			USING ERRCODE = 'check_violation';
	END IF;

	IF (start_ip_address IS DISTINCT FROM proposed_range.start_ip_address) THEN
		proposed_range.start_ip_address = start_ip_address;
		proposed_range.start_netblock_id = NULL;
		proposed_range.start_netblock_type = NULL;
		proposed_range.start_ip_universe_id = NULL;
	END IF;

	IF (stop_ip_address IS DISTINCT FROM proposed_range.stop_ip_address) THEN
		proposed_range.stop_ip_address = stop_ip_address;
		proposed_range.stop_netblock_id = NULL;
		proposed_range.stop_netblock_type = NULL;
		proposed_range.stop_ip_universe_id = NULL;
	END IF;

	IF parent_netblock_id IS NOT NULL AND
		parent_netblock_id IS DISTINCT FROM proposed_range.parent_netblock_id
	THEN
		proposed_range.parent_netblock_id = parent_netblock_id;
		proposed_range.ip_address = NULL;
		proposed_range.netblock_type = NULL;
		proposed_range.ip_universe_id = NULL;
	END IF;
	proposed_range.parent_netblock_id :=
		COALESCE(pnbid, proposed_range.parent_netblock_id);

	IF (
		proposed_range.start_ip_address IS NULL OR
		proposed_range.stop_ip_address IS NULL
	) THEN
		RAISE 'start_ip_address and stop_ip_address must both be set for a network_range'
			USING ERRCODE = 'check_violation';
	END IF;

	--
	-- If any other network ranges of this type exist that overlap this one,
	-- and the network_range_type doesn't allow that, then error.  This gets
	-- the situation where an address has changed or if it's a new range
	--
	IF NOT nrt.can_overlap AND
		(proposed_range.start_ip_address IS DISTINCT FROM
			current_range.start_ip_address) OR
		(proposed_range.stop_ip_address IS DISTINCT FROM
			current_range.stop_ip_address)
	THEN
		SELECT
			nr.network_range_id,
			startnb.ip_address as start_ip_address,
			stopnb.ip_address as stop_ip_address
		INTO temprange
		FROM
			jazzhands.network_range nr JOIN
			jazzhands.netblock startnb ON
				(nr.start_netblock_id = startnb.netblock_id) JOIN
			jazzhands.netblock stopnb ON (nr.stop_netblock_id = stopnb.netblock_id)
		WHERE
			nr.network_range_id IS DISTINCT FROM nr_id AND
			nr.network_range_type = proposed_range.network_range_type AND ((
				host(startnb.ip_address)::inet <=
					host(proposed_range.start_ip_address)::inet AND
				host(stopnb.ip_address)::inet >=
					host(proposed_range.start_ip_address)::inet
			) OR (
				host(startnb.ip_address)::inet <=
					host(proposed_range.stop_ip_address)::inet AND
				host(stopnb.ip_address)::inet >=
					host(proposed_range.stop_ip_address)::inet
			));

		IF FOUND THEN
			RAISE 'validate_network_range: network_range % of type % already exists that has addresses between % and % (% through %)',
				temprange.network_range_id,
				proposed_range.network_range_type,
				proposed_range.start_ip_address,
				proposed_range.stop_ip_address,
				temprange.start_ip_address,
				temprange.stop_ip_address
				USING ERRCODE = 'check_violation';
		END IF;
	END IF;

	IF parent_netblock_id IS NOT NULL THEN
		SELECT * INTO par_netblock FROM jazzhands.netblock WHERE
			netblock_id = pnbid;
		IF NOT FOUND THEN
			RAISE 'validate_network_range: parent_netblock_id % does not exist',
				parent_netblock_id USING ERRCODE = 'foreign_key_violation';
		END IF;
	ELSE
		SELECT * INTO par_netblock FROM jazzhands.netblock WHERE netblock_id = (
			SELECT
				*
			FROM
				netblock_utils.find_best_parent_netblock_id(
					ip_address := start_ip_address,
					is_single_address := true
				)
		);

		IF NOT FOUND THEN
			RAISE 'validate_network_range: valid parent netblock for start_ip_address % does not exist',
				start_ip_address USING ERRCODE = 'check_violation';
		END IF;
	END IF;

	IF par_netblock.can_subnet != false OR
			par_netblock.is_single_address != false THEN
		RAISE 'validate_network_range: parent netblock % must not be subnettable or a single address',
			par_netblock.netblock_id USING ERRCODE = 'check_violation';
	END IF;

	IF NOT (start_ip_address <<= par_netblock.ip_address) THEN
		RAISE 'validate_network_range: start_ip_address % is not contained by parent netblock % (%)',
			start_ip_address, par_netblock.ip_address,
			par_netblock.netblock_id USING ERRCODE = 'check_violation';
	END IF;

	IF NOT (stop_ip_address <<= par_netblock.ip_address) THEN
		RAISE 'validate_network_range: stop_ip_address % is not contained by parent netblock % (%)',
			stop_ip_address, par_netblock.ip_address,
			par_netblock.netblock_id USING ERRCODE = 'check_violation';
	END IF;

	IF NOT (start_ip_address <= stop_ip_address) THEN
		RAISE 'validate_network_range: start_ip_address % is not lower than stop_ip_address %',
			start_ip_address, stop_ip_address
			USING ERRCODE = 'check_violation';
	END IF;

	proposed_range.parent_netblock_id := par_netblock.netblock_id;
    proposed_range.ip_address := par_netblock.ip_address;
    proposed_range.netblock_type := par_netblock.netblock_type;
    proposed_range.ip_universe_id := par_netblock.ip_universe_id;
	RETURN proposed_range;
END;
$$ LANGUAGE plpgsql
SET search_path = jazzhands
SECURITY DEFINER;

SELECT schema_support.replay_saved_grants();

REVOKE USAGE ON SCHEMA netblock_manip FROM public;
REVOKE EXECUTE ON ALL FUNCTIONS IN SCHEMA netblock_manip FROM public;

GRANT USAGE ON SCHEMA netblock_manip TO iud_role;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA netblock_manip TO iud_role;
