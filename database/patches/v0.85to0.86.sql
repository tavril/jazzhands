--
-- Copyright (c) 2019 Todd Kover
-- All rights reserved.
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

/*
Invoked:

	--suffix=v86
	--postschema
	jazzhands_legacy
	--scan
	mlag_peering
	logical_port
*/

\set ON_ERROR_STOP
SELECT schema_support.begin_maintenance();
select timeofday(), now();
--
-- BEGIN: process_ancillary_schema(schema_support)
--
-- DONE: process_ancillary_schema(schema_support)
--
-- Process middle (non-trigger) schema jazzhands_cache
--
--
-- Process middle (non-trigger) schema jazzhands
--
--
-- Process middle (non-trigger) schema net_manip
--
--
-- Process middle (non-trigger) schema network_strings
--
--
-- Process middle (non-trigger) schema time_util
--
--
-- Process middle (non-trigger) schema dns_utils
--
--
-- Process middle (non-trigger) schema person_manip
--
--
-- Process middle (non-trigger) schema auto_ac_manip
--
--
-- Process middle (non-trigger) schema company_manip
--
--
-- Process middle (non-trigger) schema token_utils
--
--
-- Process middle (non-trigger) schema port_support
--
--
-- Process middle (non-trigger) schema port_utils
--
--
-- Process middle (non-trigger) schema device_utils
--
--
-- Process middle (non-trigger) schema netblock_utils
--
--
-- Process middle (non-trigger) schema property_utils
--
--
-- Process middle (non-trigger) schema netblock_manip
--
--
-- Process middle (non-trigger) schema physical_address_utils
--
--
-- Process middle (non-trigger) schema component_utils
--
--
-- Process middle (non-trigger) schema snapshot_manip
--
--
-- Process middle (non-trigger) schema lv_manip
--
--
-- Process middle (non-trigger) schema approval_utils
--
--
-- Process middle (non-trigger) schema account_collection_manip
--
--
-- Process middle (non-trigger) schema script_hooks
--
--
-- Process middle (non-trigger) schema backend_utils
--
--
-- Process middle (non-trigger) schema rack_utils
--
--
-- Process middle (non-trigger) schema layerx_network_manip
--
--
-- Process middle (non-trigger) schema component_connection_utils
--
--
-- Process middle (non-trigger) schema schema_support
--
-- Creating new sequences....


--------------------------------------------------------------------
-- DEALING WITH TABLE logical_port
-- Save grants for later reapplication
SELECT schema_support.save_grants_for_replay('jazzhands', 'logical_port', 'logical_port');

-- FOREIGN KEYS FROM
ALTER TABLE layer2_connection DROP CONSTRAINT IF EXISTS fk_l2_conn_l1port;
ALTER TABLE layer2_connection DROP CONSTRAINT IF EXISTS fk_l2_conn_l2port;
ALTER TABLE logical_port_slot DROP CONSTRAINT IF EXISTS fk_lgl_port_slot_lgl_port_id;
ALTER TABLE network_interface DROP CONSTRAINT IF EXISTS fk_net_int_lgl_port_id;

-- FOREIGN KEYS TO
ALTER TABLE jazzhands.logical_port DROP CONSTRAINT IF EXISTS fk_logical_port_lg_port_type;
ALTER TABLE jazzhands.logical_port DROP CONSTRAINT IF EXISTS fk_logical_port_parent_id;

-- EXTRA-SCHEMA constraints
SELECT schema_support.save_constraint_for_replay('jazzhands', 'logical_port');

-- PRIMARY and ALTERNATE KEYS
ALTER TABLE jazzhands.logical_port DROP CONSTRAINT IF EXISTS pk_logical_port;
-- INDEXES
DROP INDEX IF EXISTS "jazzhands"."xif_logical_port_lg_port_type";
DROP INDEX IF EXISTS "jazzhands"."xif_logical_port_parnet_id";
-- CHECK CONSTRAINTS, etc
-- TRIGGERS, etc
DROP TRIGGER IF EXISTS trig_userlog_logical_port ON jazzhands.logical_port;
DROP TRIGGER IF EXISTS trigger_audit_logical_port ON jazzhands.logical_port;
SELECT schema_support.save_dependent_objects_for_replay('jazzhands', 'logical_port');
---- BEGIN audit.logical_port TEARDOWN
-- Save grants for later reapplication
SELECT schema_support.save_grants_for_replay('audit', 'logical_port', 'logical_port');

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO

-- EXTRA-SCHEMA constraints
SELECT schema_support.save_constraint_for_replay('audit', 'logical_port');

-- PRIMARY and ALTERNATE KEYS
ALTER TABLE audit.logical_port DROP CONSTRAINT IF EXISTS logical_port_pkey;
-- INDEXES
DROP INDEX IF EXISTS "audit"."aud_logical_port_pk_logical_port";
DROP INDEX IF EXISTS "audit"."logical_port_aud#realtime_idx";
DROP INDEX IF EXISTS "audit"."logical_port_aud#timestamp_idx";
DROP INDEX IF EXISTS "audit"."logical_port_aud#txid_idx";
-- CHECK CONSTRAINTS, etc
-- TRIGGERS, etc
---- DONE audit.logical_port TEARDOWN


ALTER TABLE logical_port RENAME TO logical_port_v86;
ALTER TABLE audit.logical_port RENAME TO logical_port_v86;

CREATE TABLE jazzhands.logical_port
(
	logical_port_id	integer NOT NULL,
	logical_port_name	varchar(50) NOT NULL,
	logical_port_type	varchar(50)  NULL,
	device_id	integer  NULL,
	mlag_peering_id	integer  NULL,
	parent_logical_port_id	integer  NULL,
	mac_address	macaddr  NULL,
	data_ins_user	varchar(255)  NULL,
	data_ins_date	timestamp with time zone  NULL,
	data_upd_user	varchar(255)  NULL,
	data_upd_date	timestamp with time zone  NULL
);
SELECT schema_support.build_audit_table('audit', 'jazzhands', 'logical_port', false);
ALTER TABLE logical_port
	ALTER logical_port_id
	SET DEFAULT nextval('jazzhands.logical_port_logical_port_id_seq'::regclass);
INSERT INTO logical_port (
	logical_port_id,
	logical_port_name,
	logical_port_type,
	device_id,		-- new column (device_id)
	mlag_peering_id,		-- new column (mlag_peering_id)
	parent_logical_port_id,
	mac_address,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
) SELECT
	logical_port_id,
	logical_port_name,
	logical_port_type,
	NULL,		-- new column (device_id)
	NULL,		-- new column (mlag_peering_id)
	parent_logical_port_id,
	mac_address,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM logical_port_v86;

INSERT INTO audit.logical_port (
	logical_port_id,
	logical_port_name,
	logical_port_type,
	device_id,		-- new column (device_id)
	mlag_peering_id,		-- new column (mlag_peering_id)
	parent_logical_port_id,
	mac_address,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date,
	"aud#action",
	"aud#timestamp",
	"aud#realtime",
	"aud#txid",
	"aud#user",
	"aud#seq"
) SELECT
	logical_port_id,
	logical_port_name,
	logical_port_type,
	NULL,		-- new column (device_id)
	NULL,		-- new column (mlag_peering_id)
	parent_logical_port_id,
	mac_address,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date,
	"aud#action",
	"aud#timestamp",
	"aud#realtime",
	"aud#txid",
	"aud#user",
	"aud#seq"
FROM audit.logical_port_v86;

ALTER TABLE jazzhands.logical_port
	ALTER logical_port_id
	SET DEFAULT nextval('jazzhands.logical_port_logical_port_id_seq'::regclass);

-- PRIMARY AND ALTERNATE KEYS
ALTER TABLE jazzhands.logical_port ADD CONSTRAINT pk_logical_port PRIMARY KEY (logical_port_id);
ALTER TABLE jazzhands.logical_port ADD CONSTRAINT uq_device_id_logical_port_id UNIQUE (logical_port_id, device_id);

-- Table/Column Comments
-- INDEXES
CREATE INDEX xif3logical_port ON jazzhands.logical_port USING btree (device_id);
CREATE INDEX xif4logical_port ON jazzhands.logical_port USING btree (mlag_peering_id);
CREATE INDEX xif_logical_port_lg_port_type ON jazzhands.logical_port USING btree (logical_port_type);
CREATE INDEX xif_logical_port_parnet_id ON jazzhands.logical_port USING btree (parent_logical_port_id);

-- CHECK CONSTRAINTS

-- FOREIGN KEYS FROM
-- consider FK between logical_port and jazzhands.layer2_connection
ALTER TABLE jazzhands.layer2_connection
	ADD CONSTRAINT fk_l2_conn_l1port
	FOREIGN KEY (logical_port1_id) REFERENCES jazzhands.logical_port(logical_port_id);
-- consider FK between logical_port and jazzhands.layer2_connection
ALTER TABLE jazzhands.layer2_connection
	ADD CONSTRAINT fk_l2_conn_l2port
	FOREIGN KEY (logical_port2_id) REFERENCES jazzhands.logical_port(logical_port_id);
-- consider FK between logical_port and jazzhands.logical_port_slot
ALTER TABLE jazzhands.logical_port_slot
	ADD CONSTRAINT fk_lgl_port_slot_lgl_port_id
	FOREIGN KEY (logical_port_id) REFERENCES jazzhands.logical_port(logical_port_id);
-- consider FK between logical_port and jazzhands.network_interface
ALTER TABLE jazzhands.network_interface
	ADD CONSTRAINT fk_net_int_lgl_port_id
	FOREIGN KEY (logical_port_id, device_id) REFERENCES jazzhands.logical_port(logical_port_id, device_id);

-- FOREIGN KEYS TO
-- consider FK logical_port and val_logical_port_type
ALTER TABLE jazzhands.logical_port
	ADD CONSTRAINT fk_logical_port_lg_port_type
	FOREIGN KEY (logical_port_type) REFERENCES jazzhands.val_logical_port_type(logical_port_type);
-- consider FK logical_port and logical_port
ALTER TABLE jazzhands.logical_port
	ADD CONSTRAINT fk_logical_port_parent_id
	FOREIGN KEY (parent_logical_port_id) REFERENCES jazzhands.logical_port(logical_port_id);
-- consider FK logical_port and device
ALTER TABLE jazzhands.logical_port
	ADD CONSTRAINT r_820
	FOREIGN KEY (device_id) REFERENCES jazzhands.device(device_id);
-- consider FK logical_port and mlag_peering
--ALTER TABLE jazzhands.logical_port
--	ADD CONSTRAINT r_821
--	FOREIGN KEY (mlag_peering_id) REFERENCES jazzhands.mlag_peering(mlag_peering_id);

-- TRIGGERS
-- this used to be at the end...
-- SELECT schema_support.replay_object_recreates();
SELECT schema_support.rebuild_stamp_trigger('jazzhands', 'logical_port');
SELECT schema_support.build_audit_table_pkak_indexes('audit', 'jazzhands', 'logical_port');
SELECT schema_support.rebuild_audit_trigger('audit', 'jazzhands', 'logical_port');
ALTER SEQUENCE jazzhands.logical_port_logical_port_id_seq
	 OWNED BY logical_port.logical_port_id;
DROP TABLE IF EXISTS logical_port_v86;
DROP TABLE IF EXISTS audit.logical_port_v86;
-- DONE DEALING WITH TABLE logical_port (jazzhands)
--------------------------------------------------------------------
--------------------------------------------------------------------
-- DEALING WITH TABLE mlag_peering
-- Save grants for later reapplication
SELECT schema_support.save_grants_for_replay('jazzhands', 'mlag_peering', 'mlag_peering');

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO
ALTER TABLE jazzhands.mlag_peering DROP CONSTRAINT IF EXISTS fk_mlag_peering_devid1;
ALTER TABLE jazzhands.mlag_peering DROP CONSTRAINT IF EXISTS fk_mlag_peering_devid2;

-- EXTRA-SCHEMA constraints
SELECT schema_support.save_constraint_for_replay('jazzhands', 'mlag_peering');

-- PRIMARY and ALTERNATE KEYS
ALTER TABLE jazzhands.mlag_peering DROP CONSTRAINT IF EXISTS pk_mlag_peering;
-- INDEXES
DROP INDEX IF EXISTS "jazzhands"."xif_mlag_peering_devid1";
DROP INDEX IF EXISTS "jazzhands"."xif_mlag_peering_devid2";
-- CHECK CONSTRAINTS, etc
-- TRIGGERS, etc
DROP TRIGGER IF EXISTS trig_userlog_mlag_peering ON jazzhands.mlag_peering;
DROP TRIGGER IF EXISTS trigger_audit_mlag_peering ON jazzhands.mlag_peering;
SELECT schema_support.save_dependent_objects_for_replay('jazzhands', 'mlag_peering');
---- BEGIN audit.mlag_peering TEARDOWN
-- Save grants for later reapplication
SELECT schema_support.save_grants_for_replay('audit', 'mlag_peering', 'mlag_peering');

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO

-- EXTRA-SCHEMA constraints
SELECT schema_support.save_constraint_for_replay('audit', 'mlag_peering');

-- PRIMARY and ALTERNATE KEYS
ALTER TABLE audit.mlag_peering DROP CONSTRAINT IF EXISTS mlag_peering_pkey;
-- INDEXES
DROP INDEX IF EXISTS "audit"."aud_mlag_peering_pk_mlag_peering";
DROP INDEX IF EXISTS "audit"."mlag_peering_aud#realtime_idx";
DROP INDEX IF EXISTS "audit"."mlag_peering_aud#timestamp_idx";
DROP INDEX IF EXISTS "audit"."mlag_peering_aud#txid_idx";
-- CHECK CONSTRAINTS, etc
-- TRIGGERS, etc
---- DONE audit.mlag_peering TEARDOWN


ALTER TABLE mlag_peering RENAME TO mlag_peering_v86;
ALTER TABLE audit.mlag_peering RENAME TO mlag_peering_v86;

CREATE TABLE jazzhands.mlag_peering
(
	mlag_peering_id	integer NOT NULL,
	device1_id	integer  NULL,
	device2_id	integer  NULL,
	domain_id	varchar(50)  NULL,
	system_id	macaddr NOT NULL,
	data_ins_user	varchar(255)  NULL,
	data_ins_date	timestamp with time zone  NULL,
	data_upd_user	varchar(255)  NULL,
	data_upd_date	timestamp with time zone  NULL
);
SELECT schema_support.build_audit_table('audit', 'jazzhands', 'mlag_peering', false);
ALTER TABLE mlag_peering
	ALTER mlag_peering_id
	SET DEFAULT nextval('jazzhands.mlag_peering_mlag_peering_id_seq'::regclass);
INSERT INTO mlag_peering (
	mlag_peering_id,
	device1_id,
	device2_id,
	domain_id,		-- new column (domain_id)
	system_id,		-- new column (system_id)
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
) SELECT
	mlag_peering_id,
	device1_id,
	device2_id,
	NULL,		-- new column (domain_id)
	NULL,		-- new column (system_id)
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM mlag_peering_v86;

INSERT INTO audit.mlag_peering (
	mlag_peering_id,
	device1_id,
	device2_id,
	domain_id,		-- new column (domain_id)
	system_id,		-- new column (system_id)
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date,
	"aud#action",
	"aud#timestamp",
	"aud#realtime",
	"aud#txid",
	"aud#user",
	"aud#seq"
) SELECT
	mlag_peering_id,
	device1_id,
	device2_id,
	NULL,		-- new column (domain_id)
	NULL,		-- new column (system_id)
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date,
	"aud#action",
	"aud#timestamp",
	"aud#realtime",
	"aud#txid",
	"aud#user",
	"aud#seq"
FROM audit.mlag_peering_v86;

ALTER TABLE jazzhands.mlag_peering
	ALTER mlag_peering_id
	SET DEFAULT nextval('jazzhands.mlag_peering_mlag_peering_id_seq'::regclass);

-- PRIMARY AND ALTERNATE KEYS
ALTER TABLE jazzhands.mlag_peering ADD CONSTRAINT pk_mlag_peering PRIMARY KEY (mlag_peering_id);

-- Table/Column Comments
-- INDEXES
CREATE INDEX xif_mlag_peering_devid1 ON jazzhands.mlag_peering USING btree (device1_id);
CREATE INDEX xif_mlag_peering_devid2 ON jazzhands.mlag_peering USING btree (device2_id);

-- CHECK CONSTRAINTS

-- FOREIGN KEYS FROM
-- consider FK between mlag_peering and jazzhands.logical_port
ALTER TABLE jazzhands.logical_port
	ADD CONSTRAINT r_821
	FOREIGN KEY (mlag_peering_id) REFERENCES jazzhands.mlag_peering(mlag_peering_id);

-- FOREIGN KEYS TO
-- consider FK mlag_peering and device
ALTER TABLE jazzhands.mlag_peering
	ADD CONSTRAINT fk_mlag_peering_devid1
	FOREIGN KEY (device1_id) REFERENCES jazzhands.device(device_id);
-- consider FK mlag_peering and device
ALTER TABLE jazzhands.mlag_peering
	ADD CONSTRAINT fk_mlag_peering_devid2
	FOREIGN KEY (device2_id) REFERENCES jazzhands.device(device_id);

-- TRIGGERS
-- this used to be at the end...
-- SELECT schema_support.replay_object_recreates();
SELECT schema_support.rebuild_stamp_trigger('jazzhands', 'mlag_peering');
SELECT schema_support.build_audit_table_pkak_indexes('audit', 'jazzhands', 'mlag_peering');
SELECT schema_support.rebuild_audit_trigger('audit', 'jazzhands', 'mlag_peering');
ALTER SEQUENCE jazzhands.mlag_peering_mlag_peering_id_seq
	 OWNED BY mlag_peering.mlag_peering_id;
DROP TABLE IF EXISTS mlag_peering_v86;
DROP TABLE IF EXISTS audit.mlag_peering_v86;
-- DONE DEALING WITH TABLE mlag_peering (jazzhands)
--------------------------------------------------------------------
--
-- BEGIN: process_ancillary_schema(jazzhands_cache)
--
-- DONE: process_ancillary_schema(jazzhands_cache)
--------------------------------------------------------------------
-- DEALING WITH NEW TABLE v_site_netblock_expanded_assigned (jazzhands)
SELECT schema_support.save_dependent_objects_for_replay('jazzhands', 'v_site_netblock_expanded_assigned');
DROP VIEW IF EXISTS jazzhands.v_site_netblock_expanded_assigned;
CREATE VIEW jazzhands.v_site_netblock_expanded_assigned AS
 SELECT meat.site_code,
    meat.netblock_id
   FROM ( SELECT p.site_code,
            n.netblock_id,
            rank() OVER (PARTITION BY n.netblock_id ORDER BY (array_length(hc.path, 1)), (array_length(n.path, 1))) AS tier
           FROM jazzhands.property p
             JOIN jazzhands.netblock_collection nc USING (netblock_collection_id)
             JOIN jazzhands_cache.ct_netblock_collection_hier_from_ancestor hc USING (netblock_collection_id)
             JOIN jazzhands.netblock_collection_netblock ncn USING (netblock_collection_id)
             JOIN jazzhands_cache.ct_netblock_hier n ON ncn.netblock_id = n.root_netblock_id
          WHERE p.property_name::text = 'per-site-netblock_collection'::text AND p.property_type::text = 'automated'::text) meat
  WHERE meat.tier = 1;

DO $$

			BEGIN
				DELETE FROM __recreate WHERE schema = 'jazzhands' AND type = 'view' AND object = 'v_site_netblock_expanded_assigned';
			EXCEPTION WHEN undefined_table THEN
				RAISE NOTICE 'Drop of v_site_netblock_expanded_assigned failed but that is ok';
				NULL;
			END;
$$;


-- PRIMARY AND ALTERNATE KEYS

-- Table/Column Comments
-- INDEXES

-- CHECK CONSTRAINTS

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO

-- TRIGGERS
-- this used to be at the end...
-- SELECT schema_support.replay_object_recreates();
-- DONE DEALING WITH TABLE v_site_netblock_expanded_assigned (jazzhands)
--------------------------------------------------------------------
--------------------------------------------------------------------
-- DEALING WITH NEW TABLE v_netblock_hier_expanded (jazzhands)
SELECT schema_support.save_dependent_objects_for_replay('jazzhands', 'v_netblock_hier_expanded');
DROP VIEW IF EXISTS jazzhands.v_netblock_hier_expanded;
CREATE VIEW jazzhands.v_netblock_hier_expanded AS
 SELECT array_length(ct_netblock_hier.path, 1) AS netblock_level,
    ct_netblock_hier.root_netblock_id,
    v_site_netblock_expanded.site_code,
    ct_netblock_hier.path,
    nb.netblock_id,
    nb.ip_address,
    nb.netblock_type,
    nb.is_single_address,
    nb.can_subnet,
    nb.parent_netblock_id,
    nb.netblock_status,
    nb.ip_universe_id,
    nb.description,
    nb.external_id,
    nb.data_ins_user,
    nb.data_ins_date,
    nb.data_upd_user,
    nb.data_upd_date
   FROM jazzhands_cache.ct_netblock_hier
     JOIN jazzhands.netblock nb USING (netblock_id)
     LEFT JOIN jazzhands.v_site_netblock_expanded USING (netblock_id);

DO $$

			BEGIN
				DELETE FROM __recreate WHERE schema = 'jazzhands' AND type = 'view' AND object = 'v_netblock_hier_expanded';
			EXCEPTION WHEN undefined_table THEN
				RAISE NOTICE 'Drop of v_netblock_hier_expanded failed but that is ok';
				NULL;
			END;
$$;


-- PRIMARY AND ALTERNATE KEYS

-- Table/Column Comments
-- INDEXES

-- CHECK CONSTRAINTS

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO

-- TRIGGERS
-- this used to be at the end...
-- SELECT schema_support.replay_object_recreates();
-- DONE DEALING WITH TABLE v_netblock_hier_expanded (jazzhands)
--------------------------------------------------------------------
--
-- Process drops in jazzhands_cache
--
-- Changed function
SELECT schema_support.save_grants_for_replay('jazzhands_cache', 'cache_netblock_hier_handler');
CREATE OR REPLACE FUNCTION jazzhands_cache.cache_netblock_hier_handler()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'jazzhands'
AS $function$
DECLARE
	_cnt	INTEGER;
	_r		RECORD;
BEGIN
	IF TG_OP IN ('UPDATE','INSERT') AND NEW.is_single_address = 'Y' THEN
		RETURN NULL;
	END IF;
	--
	-- Delete any rows that are invalidated due to a parent change.
	--
	IF TG_OP = 'DELETE' THEN
		FOR _r IN
		DELETE FROM jazzhands_cache.ct_netblock_hier
		WHERE	OLD.netblock_id = ANY(path)
		RETURNING *
		LOOP
			RAISE DEBUG '-> rm/DEL %', to_json(_r);
		END LOOP;
		get diagnostics _cnt = row_count;
		RAISE DEBUG 'Deleting upstream references to netblock % from cache == %',
			OLD.netblock_id, _cnt;
	ELSIF TG_OP = 'UPDATE' AND OLD.parent_netblock_id IS NOT NULL THEN
		FOR _r IN
		DELETE FROM jazzhands_cache.ct_netblock_hier
		WHERE	OLD.parent_netblock_id IS NOT NULL
					AND		OLD.parent_netblock_id = ANY (path)
					AND		OLD.netblock_id = ANY (path)
					AND		netblock_id = OLD.netblock_id
		RETURNING *
		LOOP
			RAISE DEBUG '-> rm/upd %', to_json(_r);
		END LOOP;
		get diagnostics _cnt = row_count;
		RAISE DEBUG 'Deleting upstream references to netblock %/% from cache == %',
			OLD.netblock_id, OLD.parent_netblock_id, _cnt;
	END IF;

	--
	-- Insert any new rows to correspond with a new parent
	--


	IF TG_OP IN ('INSERT') THEN
		RAISE DEBUG 'Inserting reference for new netblock % into cache [%]',
			NEW.netblock_id, NEW.parent_netblock_id;

		FOR _r IN
		WITH RECURSIVE tier (
			root_netblock_id,
			intermediate_netblock_id,
			netblock_id,
			path
		)AS (
			SELECT parent_netblock_id,
				parent_netblock_id,
				netblock_id,
				ARRAY[netblock_id, parent_netblock_id]
			FROM netblock WHERE netblock_id = NEW.netblock_id
			AND parent_netblock_id IS NOT NULL
		UNION ALL
			SELECT n.parent_netblock_id,
				tier.intermediate_netblock_id,
				tier.netblock_id,
				array_append(tier.path, n.parent_netblock_id)
			FROM tier
				JOIN netblock n ON n.netblock_id = tier.root_netblock_id
			WHERE n.parent_netblock_id IS NOT NULL
		), combo AS (
			 SELECT * FROM tier
			UNION ALL
			SELECT netblock_id, netblock_id, netblock_id, ARRAY[netblock_id]
			FROM netblock WHERE netblock_id = NEW.netblock_id
		) SELECT * FROM combo
		LOOP
			RAISE DEBUG 'nb/ins up %', to_json(_r);
			INSERT INTO jazzhands_cache.ct_netblock_hier (
				root_netblock_id, intermediate_netblock_id, 
				netblock_id, path
			) VALUES (
				_r.root_netblock_id, _r.intermediate_netblock_id, 
				_r.netblock_id, _r.path
			);
		END LOOP;

	ELSIF (TG_OP = 'UPDATE' AND NEW.parent_netblock_id IS NOT NULL) THEN

		FOR _r IN
		WITH base AS (
			SELECT *
			FROM jazzhands_cache.ct_netblock_hier
			WHERE NEW.netblock_id = ANY (path)
			AND array_length(path, 1) > 2

		), inew AS (
			INSERT INTO jazzhands_cache.ct_netblock_hier (
				root_netblock_id,
				intermediate_netblock_id,
				netblock_id,
				path
			)  SELECT
				base.root_netblock_id,
				NEW.parent_netblock_id,
				netblock_id,
				array_cat(
					array_cat(
						path[: (array_position(path, NEW.netblock_id)-1)],
						ARRAY[NEW.netblock_id, NEW.parent_netblock_id]
					),
					path[(array_position(path, NEW.netblock_id)+1) :]
				)
				FROM base
				RETURNING *
		), uold AS (
			UPDATE jazzhands_cache.ct_netblock_hier n
			SET root_netblock_id = base.root_netblock_id,
				intermediate_netblock_id = NEW.parent_netblock_id,
			path = array_replace(base.path, base.root_netblock_id, NEW.parent_netblock_id)
			FROM base
			WHERE n.path = base.path
				RETURNING n.*
		) SELECT 'ins' as "what", * FROM inew
			UNION
			SELECT 'upd' as "what", * FROM uold

		LOOP
			RAISE DEBUG 'down:%', to_json(_r);
		END LOOP;

		get diagnostics _cnt = row_count;
		RAISE DEBUG 'Inserting upstream references down for updated netblock %/% into cache == %',
			NEW.netblock_id, NEW.parent_netblock_id, _cnt;

		-- walk up and install rows for all the things above due to change
		FOR _r IN
		WITH RECURSIVE tier (
			root_netblock_id,
			intermediate_netblock_id,
			netblock_id,
			path,
			cycle
		)AS (
			SELECT parent_netblock_id,
                parent_netblock_id,
                netblock_id,
                ARRAY[netblock_id, parent_netblock_id],
                false
            FROM netblock WHERE netblock_id = NEW.netblock_id
        UNION ALL
            SELECT n.parent_netblock_id,
                n.netblock_Id,
                tier.netblock_id,
                array_append(tier.path, n.parent_netblock_id),
                n.parent_netblock_id = ANY(path)
            FROM tier
                JOIN netblock n ON n.netblock_id = tier.root_netblock_id
            WHERE n.parent_netblock_id IS NOT NULL
			AND NOT cycle
        ) SELECT * FROM tier
		LOOP
			IF _r.cycle THEN
				RAISE EXCEPTION 'Insert Created a netblock loop.'
					USING ERRCODE = 'JH101';
			END IF;
			INSERT INTO jazzhands_cache.ct_netblock_hier (
				root_netblock_id, intermediate_netblock_id, netblock_id, path
			) VALUES (
				_r.root_netblock_id, _r.intermediate_netblock_id, _r.netblock_id, _r.path
			);

			RAISE DEBUG 'nb/upd up %', to_json(_r);
		END LOOP;
		get diagnostics _cnt = row_count;
		RAISE DEBUG 'Inserting upstream references up for updated netblock %/% into cache == %',
			NEW.netblock_id, NEW.parent_netblock_id, _cnt;
	END IF;
	RETURN NULL;
END
$function$
;

--
-- Process drops in jazzhands
--
--
-- Process drops in net_manip
--
--
-- Process drops in network_strings
--
--
-- Process drops in time_util
--
--
-- Process drops in dns_utils
--
--
-- Process drops in person_manip
--
--
-- Process drops in auto_ac_manip
--
--
-- Process drops in company_manip
--
--
-- Process drops in token_utils
--
--
-- Process drops in port_support
--
--
-- Process drops in port_utils
--
--
-- Process drops in device_utils
--
--
-- Process drops in netblock_utils
--
--
-- Process drops in property_utils
--
--
-- Process drops in netblock_manip
--
--
-- Process drops in physical_address_utils
--
--
-- Process drops in component_utils
--
--
-- Process drops in snapshot_manip
--
--
-- Process drops in lv_manip
--
--
-- Process drops in approval_utils
--
--
-- Process drops in account_collection_manip
--
--
-- Process drops in script_hooks
--
--
-- Process drops in backend_utils
--
--
-- Process drops in rack_utils
--
--
-- Process drops in layerx_network_manip
--
--
-- Process drops in component_connection_utils
--
--
-- Process drops in schema_support
--
--
-- Process post-schema jazzhands_legacy
--
-- Dropping obsoleted sequences....


-- Dropping obsoleted audit sequences....


-- Processing tables with no structural changes
-- Some of these may be redundant
-- fk constraints
ALTER TABLE network_interface DROP CONSTRAINT IF EXISTS fk_net_int_lgl_port_id;
ALTER TABLE network_interface
	ADD CONSTRAINT fk_net_int_lgl_port_id
	FOREIGN KEY (logical_port_id, device_id) REFERENCES jazzhands.logical_port(logical_port_id, device_id);

ALTER TABLE network_interface DROP CONSTRAINT IF EXISTS uq_netint_device_id_logical_port_id;
ALTER TABLE network_interface
	ADD CONSTRAINT uq_netint_device_id_logical_port_id
	UNIQUE (device_id, logical_port_id);

-- index
DROP INDEX "jazzhands"."xif_net_int_lgl_port_id";
DROP INDEX IF EXISTS "jazzhands"."xif12network_interface";
CREATE INDEX xif12network_interface ON jazzhands.network_interface USING btree (logical_port_id, device_id);
-- triggers


-- Clean Up
SELECT schema_support.replay_object_recreates();
SELECT schema_support.replay_saved_grants();
SELECT schema_support.synchronize_cache_tables();
--
-- BEGIN: process_ancillary_schema(jazzhands_legacy)
--
--------------------------------------------------------------------
-- DEALING WITH TABLE operating_system
-- Save grants for later reapplication
SELECT schema_support.save_grants_for_replay('jazzhands', 'operating_system', 'operating_system');
SELECT schema_support.save_dependent_objects_for_replay('jazzhands_legacy', 'operating_system');
DROP VIEW IF EXISTS jazzhands_legacy.operating_system;
CREATE VIEW jazzhands_legacy.operating_system AS
 SELECT operating_system.operating_system_id,
    operating_system.operating_system_name,
    operating_system.operating_system_short_name,
    operating_system.company_id,
    operating_system.major_version,
    operating_system.version,
    operating_system.operating_system_family,
    operating_system.processor_architecture,
    operating_system.data_ins_user,
    operating_system.data_ins_date,
    operating_system.data_upd_user,
    operating_system.data_upd_date
   FROM jazzhands.operating_system;

DO $$

			BEGIN
				DELETE FROM __recreate WHERE schema = 'jazzhands_legacy' AND type = 'view' AND object = 'operating_system';
			EXCEPTION WHEN undefined_table THEN
				RAISE NOTICE 'Drop of operating_system failed but that is ok';
				NULL;
			END;
$$;

-- just in case
SELECT schema_support.prepare_for_object_replay();

-- PRIMARY AND ALTERNATE KEYS

-- Table/Column Comments
-- INDEXES

-- CHECK CONSTRAINTS

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO

-- TRIGGERS
-- this used to be at the end...
-- SELECT schema_support.replay_object_recreates();
-- DONE DEALING WITH TABLE operating_system (jazzhands_legacy)
--------------------------------------------------------------------
--------------------------------------------------------------------
-- DEALING WITH NEW TABLE v_account_collection_hier_from_ancestor (jazzhands_legacy)
SELECT schema_support.save_dependent_objects_for_replay('jazzhands_legacy', 'v_account_collection_hier_from_ancestor');
DROP VIEW IF EXISTS jazzhands_legacy.v_account_collection_hier_from_ancestor;
CREATE VIEW jazzhands_legacy.v_account_collection_hier_from_ancestor AS
 SELECT v_account_collection_hier_from_ancestor.root_account_collection_id,
    v_account_collection_hier_from_ancestor.intermediate_account_collection_id,
    v_account_collection_hier_from_ancestor.account_collection_id,
    v_account_collection_hier_from_ancestor.path,
    v_account_collection_hier_from_ancestor.cycle
   FROM jazzhands.v_account_collection_hier_from_ancestor;

DO $$

			BEGIN
				DELETE FROM __recreate WHERE schema = 'jazzhands_legacy' AND type = 'view' AND object = 'v_account_collection_hier_from_ancestor';
			EXCEPTION WHEN undefined_table THEN
				RAISE NOTICE 'Drop of v_account_collection_hier_from_ancestor failed but that is ok';
				NULL;
			END;
$$;


-- PRIMARY AND ALTERNATE KEYS

-- Table/Column Comments
-- INDEXES

-- CHECK CONSTRAINTS

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO

-- TRIGGERS
-- this used to be at the end...
-- SELECT schema_support.replay_object_recreates();
-- DONE DEALING WITH TABLE v_account_collection_hier_from_ancestor (jazzhands_legacy)
--------------------------------------------------------------------
--------------------------------------------------------------------
-- DEALING WITH NEW TABLE v_account_name (jazzhands_legacy)
SELECT schema_support.save_dependent_objects_for_replay('jazzhands_legacy', 'v_account_name');
DROP VIEW IF EXISTS jazzhands_legacy.v_account_name;
CREATE VIEW jazzhands_legacy.v_account_name AS
 SELECT v_account_name.account_id,
    v_account_name.first_name,
    v_account_name.last_name,
    v_account_name.display_name
   FROM jazzhands.v_account_name;

DO $$

			BEGIN
				DELETE FROM __recreate WHERE schema = 'jazzhands_legacy' AND type = 'view' AND object = 'v_account_name';
			EXCEPTION WHEN undefined_table THEN
				RAISE NOTICE 'Drop of v_account_name failed but that is ok';
				NULL;
			END;
$$;


-- PRIMARY AND ALTERNATE KEYS

-- Table/Column Comments
-- INDEXES

-- CHECK CONSTRAINTS

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO

-- TRIGGERS
-- this used to be at the end...
-- SELECT schema_support.replay_object_recreates();
-- DONE DEALING WITH TABLE v_account_name (jazzhands_legacy)
--------------------------------------------------------------------
--------------------------------------------------------------------
-- DEALING WITH NEW TABLE v_device_collection_hier_from_ancestor (jazzhands_legacy)
SELECT schema_support.save_dependent_objects_for_replay('jazzhands_legacy', 'v_device_collection_hier_from_ancestor');
DROP VIEW IF EXISTS jazzhands_legacy.v_device_collection_hier_from_ancestor;
CREATE VIEW jazzhands_legacy.v_device_collection_hier_from_ancestor AS
 SELECT v_device_collection_hier_from_ancestor.root_device_collection_id,
    v_device_collection_hier_from_ancestor.intermediate_device_collection_id,
    v_device_collection_hier_from_ancestor.device_collection_id,
    v_device_collection_hier_from_ancestor.path,
    v_device_collection_hier_from_ancestor.cycle
   FROM jazzhands.v_device_collection_hier_from_ancestor;

DO $$

			BEGIN
				DELETE FROM __recreate WHERE schema = 'jazzhands_legacy' AND type = 'view' AND object = 'v_device_collection_hier_from_ancestor';
			EXCEPTION WHEN undefined_table THEN
				RAISE NOTICE 'Drop of v_device_collection_hier_from_ancestor failed but that is ok';
				NULL;
			END;
$$;


-- PRIMARY AND ALTERNATE KEYS

-- Table/Column Comments
-- INDEXES

-- CHECK CONSTRAINTS

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO

-- TRIGGERS
-- this used to be at the end...
-- SELECT schema_support.replay_object_recreates();
-- DONE DEALING WITH TABLE v_device_collection_hier_from_ancestor (jazzhands_legacy)
--------------------------------------------------------------------
--------------------------------------------------------------------
-- DEALING WITH NEW TABLE v_netblock_collection_hier_from_ancestor (jazzhands_legacy)
SELECT schema_support.save_dependent_objects_for_replay('jazzhands_legacy', 'v_netblock_collection_hier_from_ancestor');
DROP VIEW IF EXISTS jazzhands_legacy.v_netblock_collection_hier_from_ancestor;
CREATE VIEW jazzhands_legacy.v_netblock_collection_hier_from_ancestor AS
 SELECT v_netblock_collection_hier_from_ancestor.root_netblock_collection_id,
    v_netblock_collection_hier_from_ancestor.intermediate_netblock_collection_id,
    v_netblock_collection_hier_from_ancestor.netblock_collection_id,
    v_netblock_collection_hier_from_ancestor.path,
    v_netblock_collection_hier_from_ancestor.cycle
   FROM jazzhands.v_netblock_collection_hier_from_ancestor;

DO $$

			BEGIN
				DELETE FROM __recreate WHERE schema = 'jazzhands_legacy' AND type = 'view' AND object = 'v_netblock_collection_hier_from_ancestor';
			EXCEPTION WHEN undefined_table THEN
				RAISE NOTICE 'Drop of v_netblock_collection_hier_from_ancestor failed but that is ok';
				NULL;
			END;
$$;


-- PRIMARY AND ALTERNATE KEYS

-- Table/Column Comments
-- INDEXES

-- CHECK CONSTRAINTS

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO

-- TRIGGERS
-- this used to be at the end...
-- SELECT schema_support.replay_object_recreates();
-- DONE DEALING WITH TABLE v_netblock_collection_hier_from_ancestor (jazzhands_legacy)
--------------------------------------------------------------------
--------------------------------------------------------------------
-- DEALING WITH NEW TABLE v_netblock_hier_expanded (jazzhands_legacy)
SELECT schema_support.save_dependent_objects_for_replay('jazzhands_legacy', 'v_netblock_hier_expanded');
DROP VIEW IF EXISTS jazzhands_legacy.v_netblock_hier_expanded;
CREATE VIEW jazzhands_legacy.v_netblock_hier_expanded AS
 SELECT v_netblock_hier_expanded.netblock_level,
    v_netblock_hier_expanded.root_netblock_id,
    v_netblock_hier_expanded.site_code,
    v_netblock_hier_expanded.path,
    v_netblock_hier_expanded.netblock_id,
    v_netblock_hier_expanded.ip_address,
    v_netblock_hier_expanded.netblock_type,
    v_netblock_hier_expanded.is_single_address,
    v_netblock_hier_expanded.can_subnet,
    v_netblock_hier_expanded.parent_netblock_id,
    v_netblock_hier_expanded.netblock_status,
    v_netblock_hier_expanded.ip_universe_id,
    v_netblock_hier_expanded.description,
    v_netblock_hier_expanded.external_id,
    v_netblock_hier_expanded.data_ins_user,
    v_netblock_hier_expanded.data_ins_date,
    v_netblock_hier_expanded.data_upd_user,
    v_netblock_hier_expanded.data_upd_date
   FROM jazzhands.v_netblock_hier_expanded;

DO $$

			BEGIN
				DELETE FROM __recreate WHERE schema = 'jazzhands_legacy' AND type = 'view' AND object = 'v_netblock_hier_expanded';
			EXCEPTION WHEN undefined_table THEN
				RAISE NOTICE 'Drop of v_netblock_hier_expanded failed but that is ok';
				NULL;
			END;
$$;


-- PRIMARY AND ALTERNATE KEYS

-- Table/Column Comments
-- INDEXES

-- CHECK CONSTRAINTS

-- FOREIGN KEYS FROM

-- FOREIGN KEYS TO

-- TRIGGERS
-- this used to be at the end...
-- SELECT schema_support.replay_object_recreates();
-- DONE DEALING WITH TABLE v_netblock_hier_expanded (jazzhands_legacy)
--------------------------------------------------------------------
-- DONE: process_ancillary_schema(jazzhands_legacy)
GRANT select on all tables in schema jazzhands to ro_role;
GRANT insert,update,delete on all tables in schema jazzhands to iud_role;
GRANT select on all sequences in schema jazzhands to ro_role;
GRANT usage on all sequences in schema jazzhands to iud_role;
GRANT select on all tables in schema audit to ro_role;
GRANT select on all sequences in schema audit to ro_role;
SELECT schema_support.end_maintenance();
--
-- BEGIN: Fix cache table entries.
--
-- removing old
-- adding new cache tables that are not there
INSERT INTO schema_support.cache_table (cache_table_schema, cache_table, defining_view_schema, defining_view, updates_enabled 
	) SELECT 'jazzhands_cache' , 'ct_netblock_hier' , 'jazzhands_cache' , 'v_netblock_hier' , '1'  WHERE ('jazzhands_cache' , 'ct_netblock_hier' , 'jazzhands_cache' , 'v_netblock_hier' , '1'  ) NOT IN ( SELECT * FROM schema_support.cache_table );
INSERT INTO schema_support.cache_table (cache_table_schema, cache_table, defining_view_schema, defining_view, updates_enabled 
	) SELECT 'jazzhands_cache' , 'ct_device_components' , 'jazzhands_cache' , 'v_device_components' , '1'  WHERE ('jazzhands_cache' , 'ct_device_components' , 'jazzhands_cache' , 'v_device_components' , '1'  ) NOT IN ( SELECT * FROM schema_support.cache_table );
INSERT INTO schema_support.cache_table (cache_table_schema, cache_table, defining_view_schema, defining_view, updates_enabled 
	) SELECT 'jazzhands_cache' , 'ct_netblock_hier' , 'jazzhands_cache' , 'v_netblock_hier' , '1'  WHERE ('jazzhands_cache' , 'ct_netblock_hier' , 'jazzhands_cache' , 'v_netblock_hier' , '1'  ) NOT IN ( SELECT * FROM schema_support.cache_table );
INSERT INTO schema_support.cache_table (cache_table_schema, cache_table, defining_view_schema, defining_view, updates_enabled 
	) SELECT 'jazzhands_cache' , 'ct_account_collection_hier_from_ancestor' , 'jazzhands_cache' , 'v_account_collection_hier_from_ancestor' , '1'  WHERE ('jazzhands_cache' , 'ct_account_collection_hier_from_ancestor' , 'jazzhands_cache' , 'v_account_collection_hier_from_ancestor' , '1'  ) NOT IN ( SELECT * FROM schema_support.cache_table );
INSERT INTO schema_support.cache_table (cache_table_schema, cache_table, defining_view_schema, defining_view, updates_enabled 
	) SELECT 'jazzhands_cache' , 'ct_device_collection_hier_from_ancestor' , 'jazzhands_cache' , 'v_device_collection_hier_from_ancestor' , '1'  WHERE ('jazzhands_cache' , 'ct_device_collection_hier_from_ancestor' , 'jazzhands_cache' , 'v_device_collection_hier_from_ancestor' , '1'  ) NOT IN ( SELECT * FROM schema_support.cache_table );
INSERT INTO schema_support.cache_table (cache_table_schema, cache_table, defining_view_schema, defining_view, updates_enabled 
	) SELECT 'jazzhands_cache' , 'ct_netblock_collection_hier_from_ancestor' , 'jazzhands_cache' , 'v_netblock_collection_hier_from_ancestor' , '1'  WHERE ('jazzhands_cache' , 'ct_netblock_collection_hier_from_ancestor' , 'jazzhands_cache' , 'v_netblock_collection_hier_from_ancestor' , '1'  ) NOT IN ( SELECT * FROM schema_support.cache_table );
--
-- DONE: Fix cache table entries.

CREATE INDEX aud_network_interface_uq_netint_device_id_logical_port_id ON audit.network_interface USING btree (device_id, logical_port_id);
--
select timeofday(), now();
