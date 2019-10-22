\set ON_ERROR_STOP
CREATE SCHEMA jazzhands_legacy;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.account AS
SELECT
	account_id,
	login,
	person_id,
	company_id,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	account_realm_id,
	account_status,
	account_role,
	account_type,
	description,
	external_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.account;

CREATE OR REPLACE VIEW jazzhands_legacy.account_assignd_cert AS
SELECT account_id,x509_cert_id,x509_key_usg,key_usage_reason_for_assign,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_assigned_certificate;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.account_auth_log AS
SELECT
	account_id,
	account_auth_ts,
	auth_resource,
	account_auth_seq,
	CASE WHEN was_auth_success IS NULL THEN NULL
		WHEN was_auth_success = true THEN 'Y'
		WHEN was_auth_success = false THEN 'N'
		ELSE NULL
	END AS was_auth_success,
	auth_resource_instance,
	auth_origin,
	data_ins_date,
	data_ins_user
FROM jazzhands.account_auth_log;

CREATE OR REPLACE VIEW jazzhands_legacy.account_coll_type_relation AS
SELECT account_collection_relation,account_collection_type,max_num_members,max_num_collections,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_collection_type_relation;

CREATE OR REPLACE VIEW jazzhands_legacy.account_collection AS
SELECT account_collection_id,account_collection_name,account_collection_type,external_id,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_collection;

CREATE OR REPLACE VIEW jazzhands_legacy.account_collection_account AS
SELECT account_collection_id,account_id,account_collection_relation,account_id_rank,start_date,finish_date,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_collection_account;

CREATE OR REPLACE VIEW jazzhands_legacy.account_collection_hier AS
SELECT account_collection_id,child_account_collection_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_collection_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.account_password AS
SELECT account_id,account_realm_id,password_type,password,change_time,expire_time,unlock_time,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_password;

CREATE OR REPLACE VIEW jazzhands_legacy.account_realm AS
SELECT account_realm_id,account_realm_name,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_realm;

CREATE OR REPLACE VIEW jazzhands_legacy.account_realm_acct_coll_type AS
SELECT account_realm_id,account_collection_type,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_realm_account_collection_type;

CREATE OR REPLACE VIEW jazzhands_legacy.account_realm_company AS
SELECT account_realm_id,company_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_realm_company;

CREATE OR REPLACE VIEW jazzhands_legacy.account_realm_password_type AS
SELECT password_type,account_realm_id,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_realm_password_type;

CREATE OR REPLACE VIEW jazzhands_legacy.account_ssh_key AS
SELECT account_id,ssh_key_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_ssh_key;

CREATE OR REPLACE VIEW jazzhands_legacy.account_token AS
SELECT account_token_id,account_id,token_id,issued_date,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.account_token;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.account_unix_info AS
SELECT
	account_id,
	unix_uid,
	unix_group_account_collection_id AS unix_group_acct_collection_id,
	shell,
	default_home,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.account_unix_info;

CREATE OR REPLACE VIEW jazzhands_legacy.appaal AS
SELECT appaal_id,appaal_name,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.appaal;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.appaal_instance AS
SELECT
	appaal_instance_id,
	appaal_id,
	service_environment_id,
	file_mode,
	file_owner_account_id,
	file_group_account_collection_id AS file_group_acct_collection_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.appaal_instance;

CREATE OR REPLACE VIEW jazzhands_legacy.appaal_instance_device_coll AS
SELECT device_collection_id,appaal_instance_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.appaal_instance_device_collection;

CREATE OR REPLACE VIEW jazzhands_legacy.appaal_instance_property AS
SELECT appaal_instance_id,app_key,appaal_group_name,appaal_group_rank,app_value,encryption_key_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.appaal_instance_property;

CREATE OR REPLACE VIEW jazzhands_legacy.approval_instance AS
SELECT approval_instance_id,approval_process_id,approval_instance_name,description,approval_start,approval_end,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.approval_instance;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.approval_instance_item AS
SELECT
	approval_instance_item_id,
	approval_instance_link_id,
	approval_instance_step_id,
	next_approval_instance_item_id,
	approved_category,
	approved_label,
	approved_lhs,
	approved_rhs,
	CASE WHEN is_approved IS NULL THEN NULL
		WHEN is_approved = true THEN 'Y'
		WHEN is_approved = false THEN 'N'
		ELSE NULL
	END AS is_approved,
	approved_account_id,
	approval_note,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.approval_instance_item;

CREATE OR REPLACE VIEW jazzhands_legacy.approval_instance_link AS
SELECT approval_instance_link_id,acct_collection_acct_seq_id,person_company_seq_id,property_seq_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.approval_instance_link;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.approval_instance_step AS
SELECT
	approval_instance_step_id,
	approval_instance_id,
	approval_process_chain_id,
	approval_instance_step_name,
	approval_instance_step_due,
	approval_type,
	description,
	approval_instance_step_start,
	approval_instance_step_end,
	approver_account_id,
	external_reference_name,
	CASE WHEN is_completed IS NULL THEN NULL
		WHEN is_completed = true THEN 'Y'
		WHEN is_completed = false THEN 'N'
		ELSE NULL
	END AS is_completed,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.approval_instance_step;

CREATE OR REPLACE VIEW jazzhands_legacy.approval_instance_step_notify AS
SELECT approv_instance_step_notify_id,approval_instance_step_id,approval_notify_type,account_id,approval_notify_whence,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.approval_instance_step_notify;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.approval_process AS
SELECT
	approval_process_id,
	approval_process_name,
	approval_process_type,
	description,
	first_approval_process_chain_id AS first_apprvl_process_chain_id,
	property_name_collection_id AS property_collection_id,
	approval_expiration_action,
	attestation_frequency,
	attestation_offset,
	max_escalation_level,
	escalation_delay,
	escalation_reminder_gap,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.approval_process;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.approval_process_chain AS
SELECT
	approval_process_chain_id,
	approval_process_chain_name,
	approval_chain_response_period,
	description,
	message,
	email_message,
	email_subject_prefix,
	email_subject_suffix,
	max_escalation_level,
	escalation_delay,
	escalation_reminder_gap,
	approving_entity,
	CASE WHEN refresh_all_data IS NULL THEN NULL
		WHEN refresh_all_data = true THEN 'Y'
		WHEN refresh_all_data = false THEN 'N'
		ELSE NULL
	END AS refresh_all_data,
	accept_app_process_chain_id,
	reject_app_process_chain_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.approval_process_chain;

CREATE OR REPLACE VIEW jazzhands_legacy.asset AS
SELECT asset_id,component_id,description,contract_id,serial_number,part_number,asset_tag,ownership_status,lease_expiration_date,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.asset;

CREATE OR REPLACE VIEW jazzhands_legacy.badge AS
SELECT card_number,badge_type_id,badge_status,date_assigned,date_reclaimed,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.badge;

CREATE OR REPLACE VIEW jazzhands_legacy.badge_type AS
SELECT badge_type_id,badge_type_name,description,badge_color,badge_template_name,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.badge_type;

CREATE OR REPLACE VIEW jazzhands_legacy.certificate_signing_request AS
SELECT certificate_signing_request_id,friendly_name,subject,certificate_signing_request,private_key_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.certificate_signing_request;

CREATE OR REPLACE VIEW jazzhands_legacy.chassis_location AS
SELECT chassis_location_id,chassis_device_type_id,device_type_module_name,chassis_device_id,module_device_type_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.chassis_location;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.circuit AS
SELECT
	circuit_id,
	vendor_company_id,
	vendor_circuit_id_str,
	aloc_lec_company_id,
	aloc_lec_circuit_id_str,
	aloc_parent_circuit_id,
	zloc_lec_company_id,
	zloc_lec_circuit_id_str,
	zloc_parent_circuit_id,
	CASE WHEN is_locally_managed IS NULL THEN NULL
		WHEN is_locally_managed = true THEN 'Y'
		WHEN is_locally_managed = false THEN 'N'
		ELSE NULL
	END AS is_locally_managed,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.circuit;

CREATE OR REPLACE VIEW jazzhands_legacy.company AS
SELECT company_id,company_name,company_short_name,parent_company_id,description,external_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.company;

CREATE OR REPLACE VIEW jazzhands_legacy.company_collection AS
SELECT company_collection_id,company_collection_name,company_collection_type,description,external_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.company_collection;

CREATE OR REPLACE VIEW jazzhands_legacy.company_collection_company AS
SELECT company_collection_id,company_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.company_collection_company;

CREATE OR REPLACE VIEW jazzhands_legacy.company_collection_hier AS
SELECT company_collection_id,child_company_collection_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.company_collection_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.company_type AS
SELECT company_id,company_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.company_type;

CREATE OR REPLACE VIEW jazzhands_legacy.component AS
SELECT component_id,component_type_id,component_name,rack_location_id,parent_slot_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.component;

CREATE OR REPLACE VIEW jazzhands_legacy.component_property AS
SELECT component_property_id,component_function,component_type_id,component_id,inter_component_connection_id,slot_function,slot_type_id,slot_id,component_property_name,component_property_type,property_value,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.component_property;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.component_type AS
SELECT
	component_type_id,
	company_id,
	model,
	slot_type_id,
	description,
	part_number,
	CASE WHEN is_removable IS NULL THEN NULL
		WHEN is_removable = true THEN 'Y'
		WHEN is_removable = false THEN 'N'
		ELSE NULL
	END AS is_removable,
	CASE WHEN asset_permitted IS NULL THEN NULL
		WHEN asset_permitted = true THEN 'Y'
		WHEN asset_permitted = false THEN 'N'
		ELSE NULL
	END AS asset_permitted,
	CASE WHEN is_rack_mountable IS NULL THEN NULL
		WHEN is_rack_mountable = true THEN 'Y'
		WHEN is_rack_mountable = false THEN 'N'
		ELSE NULL
	END AS is_rack_mountable,
	CASE WHEN is_virtual_component IS NULL THEN NULL
		WHEN is_virtual_component = true THEN 'Y'
		WHEN is_virtual_component = false THEN 'N'
		ELSE NULL
	END AS is_virtual_component,
	size_units,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.component_type;

CREATE OR REPLACE VIEW jazzhands_legacy.component_type_component_func AS
SELECT component_function,component_type_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.component_type_component_function;

CREATE OR REPLACE VIEW jazzhands_legacy.component_type_slot_tmplt AS
SELECT component_type_slot_tmplt_id,component_type_id,slot_type_id,slot_name_template,child_slot_name_template,child_slot_offset,slot_index,physical_label,slot_x_offset,slot_y_offset,slot_z_offset,slot_side,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.component_type_slot_template;

CREATE OR REPLACE VIEW jazzhands_legacy.contract AS
SELECT contract_id,company_id,contract_name,vendor_contract_name,description,contract_termination_date,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.contract;

CREATE OR REPLACE VIEW jazzhands_legacy.contract_type AS
SELECT contract_id,contract_type,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.contract_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.department AS
SELECT
	account_collection_id,
	company_id,
	manager_account_id,
	CASE WHEN is_active IS NULL THEN NULL
		WHEN is_active = true THEN 'Y'
		WHEN is_active = false THEN 'N'
		ELSE NULL
	END AS is_active,
	dept_code,
	cost_center_name,
	cost_center_number,
	default_badge_type_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.department;

-- XXX - Need to fill in by hand!
CREATE OR REPLACE VIEW jazzhands_legacy.device AS
SELECT
	device_id,
	component_id,
	device_type_id,
	device_name,
	site_code,
	identifying_dns_record_id,
	host_id,
	physical_label,
	rack_location_id,
	chassis_location_id,
	parent_device_id,
	description,
	external_id,
	device_status,
	operating_system_id,
	service_environment_id,
	NULL AS auto_mgmt_protocol, -- Need to fill in
	CASE WHEN is_locally_managed IS NULL THEN NULL
		WHEN is_locally_managed = true THEN 'Y'
		WHEN is_locally_managed = false THEN 'N'
		ELSE NULL
	END AS is_locally_managed,
	NULL AS is_monitored, -- Need to fill in
	CASE WHEN is_virtual_device IS NULL THEN NULL
		WHEN is_virtual_device = true THEN 'Y'
		WHEN is_virtual_device = false THEN 'N'
		ELSE NULL
	END AS is_virtual_device,
	NULL AS should_fetch_config, -- Need to fill in
	date_in_service,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.device;

CREATE OR REPLACE VIEW jazzhands_legacy.device_collection AS
SELECT device_collection_id,device_collection_name,device_collection_type,description,external_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_collection;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.device_collection_assignd_cert AS
SELECT
	device_collection_id,
	x509_signed_certificate_id AS x509_cert_id,
	x509_key_usage AS x509_key_usg,
	x509_file_format,
	file_location_path,
	key_tool_label,
	file_access_mode,
	file_owner_account_id,
	file_group_account_collection_id AS file_group_acct_collection_id,
	file_passphrase_path,
	key_usage_reason_for_assignment AS key_usage_reason_for_assign,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.device_collection_assigned_certificate;

CREATE OR REPLACE VIEW jazzhands_legacy.device_collection_device AS
SELECT device_id,device_collection_id,device_id_rank,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_collection_device;

CREATE OR REPLACE VIEW jazzhands_legacy.device_collection_hier AS
SELECT device_collection_id,child_device_collection_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_collection_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.device_collection_ssh_key AS
SELECT ssh_key_id,device_collection_id,account_collection_id,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_collection_ssh_key;

CREATE OR REPLACE VIEW jazzhands_legacy.device_encapsulation_domain AS
SELECT device_id,encapsulation_type,encapsulation_domain,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_encapsulation_domain;

CREATE OR REPLACE VIEW jazzhands_legacy.device_layer2_network AS
SELECT device_id,layer2_network_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_layer2_network;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.device_management_controller AS
SELECT
	manager_device_id,
	device_id,
	device_management_control_type AS device_mgmt_control_type,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.device_management_controller;

CREATE OR REPLACE VIEW jazzhands_legacy.device_note AS
SELECT note_id,device_id,note_text,note_date,note_user,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_note;

CREATE OR REPLACE VIEW jazzhands_legacy.device_power_connection AS
SELECT device_power_connection_id,inter_component_connection_id,rpc_device_id,rpc_power_interface_port,power_interface_port,device_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_power_connection;

CREATE OR REPLACE VIEW jazzhands_legacy.device_power_interface AS
SELECT device_id,power_interface_port,power_plug_style,voltage,max_amperage,provides_power,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_power_interface;

CREATE OR REPLACE VIEW jazzhands_legacy.device_ssh_key AS
SELECT device_id,ssh_key_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_ssh_key;

CREATE OR REPLACE VIEW jazzhands_legacy.device_ticket AS
SELECT device_id,ticketing_system_id,ticket_number,device_ticket_notes,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_ticket;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.device_type AS
SELECT
	device_type_id,
	component_type_id,
	device_type_name,
	template_device_id,
	idealized_device_id,
	description,
	company_id,
	model,
	device_type_depth_in_cm,
	processor_architecture,
	config_fetch_type,
	rack_units,
	CASE WHEN has_802_3_interface IS NULL THEN NULL
		WHEN has_802_3_interface = true THEN 'Y'
		WHEN has_802_3_interface = false THEN 'N'
		ELSE NULL
	END AS has_802_3_interface,
	CASE WHEN has_802_11_interface IS NULL THEN NULL
		WHEN has_802_11_interface = true THEN 'Y'
		WHEN has_802_11_interface = false THEN 'N'
		ELSE NULL
	END AS has_802_11_interface,
	CASE WHEN snmp_capable IS NULL THEN NULL
		WHEN snmp_capable = true THEN 'Y'
		WHEN snmp_capable = false THEN 'N'
		ELSE NULL
	END AS snmp_capable,
	CASE WHEN is_chassis IS NULL THEN NULL
		WHEN is_chassis = true THEN 'Y'
		WHEN is_chassis = false THEN 'N'
		ELSE NULL
	END AS is_chassis,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.device_type;

CREATE OR REPLACE VIEW jazzhands_legacy.device_type_module AS
SELECT device_type_id,device_type_module_name,description,device_type_x_offset,device_type_y_offset,device_type_z_offset,device_type_side,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_type_module;

CREATE OR REPLACE VIEW jazzhands_legacy.device_type_module_device_type AS
SELECT module_device_type_id,device_type_id,device_type_module_name,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.device_type_module_device_type;

CREATE OR REPLACE VIEW jazzhands_legacy.dns_change_record AS
SELECT dns_change_record_id,dns_domain_id,ip_universe_id,ip_address,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.dns_change_record;

CREATE OR REPLACE VIEW jazzhands_legacy.dns_domain AS
SELECT dns_domain_id,soa_name,dns_domain_name,dns_domain_type,parent_dns_domain_id,description,external_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.dns_domain;

CREATE OR REPLACE VIEW jazzhands_legacy.dns_domain_collection AS
SELECT dns_domain_collection_id,dns_domain_collection_name,dns_domain_collection_type,description,external_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.dns_domain_collection;

CREATE OR REPLACE VIEW jazzhands_legacy.dns_domain_collection_dns_dom AS
SELECT dns_domain_collection_id,dns_domain_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.dns_domain_collection_dns_domain;

CREATE OR REPLACE VIEW jazzhands_legacy.dns_domain_collection_hier AS
SELECT dns_domain_collection_id,child_dns_domain_collection_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.dns_domain_collection_hier;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.dns_domain_ip_universe AS
SELECT
	dns_domain_id,
	ip_universe_id,
	soa_class,
	soa_ttl,
	soa_serial,
	soa_refresh,
	soa_retry,
	soa_expire,
	soa_minimum,
	soa_mname,
	soa_rname,
	CASE WHEN should_generate IS NULL THEN NULL
		WHEN should_generate = true THEN 'Y'
		WHEN should_generate = false THEN 'N'
		ELSE NULL
	END AS should_generate,
	last_generated,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.dns_domain_ip_universe;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.dns_record AS
SELECT
	dns_record_id,
	dns_name,
	dns_domain_id,
	dns_ttl,
	dns_class,
	dns_type,
	dns_value,
	dns_priority,
	dns_srv_service,
	dns_srv_protocol,
	dns_srv_weight,
	dns_srv_port,
	netblock_id,
	ip_universe_id,
	reference_dns_record_id,
	dns_value_record_id,
	CASE WHEN should_generate_ptr IS NULL THEN NULL
		WHEN should_generate_ptr = true THEN 'Y'
		WHEN should_generate_ptr = false THEN 'N'
		ELSE NULL
	END AS should_generate_ptr,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.dns_record;

CREATE OR REPLACE VIEW jazzhands_legacy.dns_record_relation AS
SELECT dns_record_id,related_dns_record_id,dns_record_relation_type,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.dns_record_relation;

CREATE OR REPLACE VIEW jazzhands_legacy.encapsulation_domain AS
SELECT encapsulation_domain,encapsulation_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.encapsulation_domain;

CREATE OR REPLACE VIEW jazzhands_legacy.encapsulation_range AS
SELECT encapsulation_range_id,parent_encapsulation_range_id,site_code,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.encapsulation_range;

CREATE OR REPLACE VIEW jazzhands_legacy.encryption_key AS
SELECT encryption_key_id,encryption_key_db_value,encryption_key_purpose,encryption_key_purpose_version,encryption_method,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.encryption_key;

CREATE OR REPLACE VIEW jazzhands_legacy.inter_component_connection AS
SELECT inter_component_connection_id,slot1_id,slot2_id,circuit_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.inter_component_connection;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.ip_universe AS
SELECT
	ip_universe_id,
	ip_universe_name,
	ip_namespace,
	CASE WHEN should_generate_dns IS NULL THEN NULL
		WHEN should_generate_dns = true THEN 'Y'
		WHEN should_generate_dns = false THEN 'N'
		ELSE NULL
	END AS should_generate_dns,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.ip_universe;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.ip_universe_visibility AS
SELECT
	ip_universe_id,
	visible_ip_universe_id,
	CASE WHEN propagate_dns IS NULL THEN NULL
		WHEN propagate_dns = true THEN 'Y'
		WHEN propagate_dns = false THEN 'N'
		ELSE NULL
	END AS propagate_dns,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.ip_universe_visibility;

CREATE OR REPLACE VIEW jazzhands_legacy.kerberos_realm AS
SELECT krb_realm_id,realm_name,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.kerberos_realm;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.klogin AS
SELECT
	klogin_id,
	account_id,
	account_collection_id,
	krb_realm_id,
	krb_instance,
	destination_account_id AS dest_account_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.klogin;

CREATE OR REPLACE VIEW jazzhands_legacy.klogin_mclass AS
SELECT klogin_id,device_collection_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.klogin_mclass;

CREATE OR REPLACE VIEW jazzhands_legacy.l2_network_coll_l2_network AS
SELECT layer2_network_collection_id,layer2_network_id,layer2_network_id_rank,start_date,finish_date,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.layer2_network_collection_layer2_network;

CREATE OR REPLACE VIEW jazzhands_legacy.l3_network_coll_l3_network AS
SELECT layer3_network_collection_id,layer3_network_id,layer3_network_id_rank,start_date,finish_date,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.layer3_network_collection_layer3_network;

CREATE OR REPLACE VIEW jazzhands_legacy.layer1_connection AS
SELECT layer1_connection_id,physical_port1_id,physical_port2_id,circuit_id,baud,data_bits,stop_bits,parity,flow_control,tcpsrv_device_id,is_tcpsrv_enabled,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.layer1_connection;

CREATE OR REPLACE VIEW jazzhands_legacy.layer2_connection AS
SELECT layer2_connection_id,logical_port1_id,logical_port2_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.layer2_connection;

CREATE OR REPLACE VIEW jazzhands_legacy.layer2_connection_l2_network AS
SELECT layer2_connection_id,layer2_network_id,encapsulation_mode,encapsulation_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.layer2_connection_layer2_network;

CREATE OR REPLACE VIEW jazzhands_legacy.layer2_network AS
SELECT layer2_network_id,encapsulation_name,encapsulation_domain,encapsulation_type,encapsulation_tag,description,external_id,encapsulation_range_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.layer2_network;

CREATE OR REPLACE VIEW jazzhands_legacy.layer2_network_collection AS
SELECT layer2_network_collection_id,layer2_network_collection_name,layer2_network_collection_type,description,external_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.layer2_network_collection;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.layer2_network_collection_hier AS
SELECT
	layer2_network_collection_id,
	child_layer2_network_collection_id AS child_l2_network_coll_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.layer2_network_collection_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.layer3_network AS
SELECT layer3_network_id,netblock_id,layer2_network_id,default_gateway_netblock_id,rendezvous_netblock_id,description,external_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.layer3_network;

CREATE OR REPLACE VIEW jazzhands_legacy.layer3_network_collection AS
SELECT layer3_network_collection_id,layer3_network_collection_name,layer3_network_collection_type,description,external_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.layer3_network_collection;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.layer3_network_collection_hier AS
SELECT
	layer3_network_collection_id,
	child_layer3_network_collection_id AS child_l3_network_coll_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.layer3_network_collection_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.logical_port AS
SELECT logical_port_id,logical_port_name,logical_port_type,device_id,mlag_peering_id,parent_logical_port_id,mac_address,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.logical_port;

CREATE OR REPLACE VIEW jazzhands_legacy.logical_port_slot AS
SELECT logical_port_id,slot_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.logical_port_slot;

CREATE OR REPLACE VIEW jazzhands_legacy.logical_volume AS
SELECT logical_volume_id,logical_volume_name,logical_volume_type,volume_group_id,device_id,logical_volume_size_in_bytes,logical_volume_offset_in_bytes,filesystem_type,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.logical_volume;

CREATE OR REPLACE VIEW jazzhands_legacy.logical_volume_property AS
SELECT logical_volume_property_id,logical_volume_id,logical_volume_type,logical_volume_purpose,filesystem_type,logical_volume_property_name,logical_volume_property_value,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.logical_volume_property;

CREATE OR REPLACE VIEW jazzhands_legacy.logical_volume_purpose AS
SELECT logical_volume_purpose,logical_volume_id,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.logical_volume_purpose;

CREATE OR REPLACE VIEW jazzhands_legacy.mlag_peering AS
SELECT mlag_peering_id,device1_id,device2_id,domain_id,system_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.mlag_peering;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.netblock AS
SELECT
	netblock_id,
	ip_address,
	netblock_type,
	CASE WHEN is_single_address IS NULL THEN NULL
		WHEN is_single_address = true THEN 'Y'
		WHEN is_single_address = false THEN 'N'
		ELSE NULL
	END AS is_single_address,
	CASE WHEN can_subnet IS NULL THEN NULL
		WHEN can_subnet = true THEN 'Y'
		WHEN can_subnet = false THEN 'N'
		ELSE NULL
	END AS can_subnet,
	parent_netblock_id,
	netblock_status,
	ip_universe_id,
	description,
	external_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.netblock;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.netblock_collection AS
SELECT
	netblock_collection_id,
	netblock_collection_name,
	netblock_collection_type,
	netblock_ip_family_restriction AS netblock_ip_family_restrict,
	description,
	external_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.netblock_collection;

CREATE OR REPLACE VIEW jazzhands_legacy.netblock_collection_hier AS
SELECT netblock_collection_id,child_netblock_collection_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.netblock_collection_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.netblock_collection_netblock AS
SELECT netblock_collection_id,netblock_id,netblock_id_rank,start_date,finish_date,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.netblock_collection_netblock;

-- XXX - Need to fill in by hand!
CREATE OR REPLACE VIEW jazzhands_legacy.network_interface AS
SELECT
	layer3_interface_id AS network_interface_id,
	device_id,
	layer3_interface_name AS network_interface_name,
	description,
	parent_layer3_interface_id AS parent_network_interface_id,
	parent_relation_type,
	NULL AS physical_port_id, -- Need to fill in
	slot_id,
	logical_port_id,
	layer3_interface_type AS network_interface_type,
	CASE WHEN is_interface_up IS NULL THEN NULL
		WHEN is_interface_up = true THEN 'Y'
		WHEN is_interface_up = false THEN 'N'
		ELSE NULL
	END AS is_interface_up,
	mac_addr,
	CASE WHEN should_monitor IS NULL THEN NULL
		WHEN should_monitor = true THEN 'Y'
		WHEN should_monitor = false THEN 'N'
		ELSE NULL
	END AS should_monitor,
	CASE WHEN should_manage IS NULL THEN NULL
		WHEN should_manage = true THEN 'Y'
		WHEN should_manage = false THEN 'N'
		ELSE NULL
	END AS should_manage,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.layer3_interface;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.network_interface_netblock AS
SELECT
	netblock_id,
	layer3_interface_id AS network_interface_id,
	device_id,
	network_interface_rank,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.layer3_interface_netblock;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.network_interface_purpose AS
SELECT
	device_id,
	network_interface_purpose,
	layer3_interface_id AS network_interface_id,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.layer3_interface_purpose;

CREATE OR REPLACE VIEW jazzhands_legacy.network_range AS
SELECT network_range_id,network_range_type,description,parent_netblock_id,start_netblock_id,stop_netblock_id,dns_prefix,dns_domain_id,lease_time,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.network_range;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.network_service AS
SELECT
	network_service_id,
	name,
	description,
	network_service_type,
	CASE WHEN is_monitored IS NULL THEN NULL
		WHEN is_monitored = true THEN 'Y'
		WHEN is_monitored = false THEN 'N'
		ELSE NULL
	END AS is_monitored,
	device_id,
	network_interface_id,
	dns_record_id,
	service_environment_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.network_service;

-- XXX - Need to fill in by hand!
CREATE OR REPLACE VIEW jazzhands_legacy.operating_system AS
SELECT
	operating_system_id,
	operating_system_name,
	operating_system_short_name,
	company_id,
	major_version,
	version,
	operating_system_family,
	NULL AS processor_architecture, -- Need to fill in
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.operating_system;

CREATE OR REPLACE VIEW jazzhands_legacy.operating_system_snapshot AS
SELECT operating_system_snapshot_id,operating_system_snapshot_name,operating_system_snapshot_type,operating_system_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.operating_system_snapshot;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.person AS
SELECT
	person_id,
	description,
	first_name,
	middle_name,
	last_name,
	name_suffix,
	gender,
	preferred_first_name,
	preferred_last_name,
	nickname,
	birth_date,
	diet,
	shirt_size,
	pant_size,
	hat_size,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.person;

CREATE OR REPLACE VIEW jazzhands_legacy.person_account_realm_company AS
SELECT person_id,company_id,account_realm_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.person_account_realm_company;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.person_auth_question AS
SELECT
	auth_question_id,
	person_id,
	user_answer,
	CASE WHEN is_active IS NULL THEN NULL
		WHEN is_active = true THEN 'Y'
		WHEN is_active = false THEN 'N'
		ELSE NULL
	END AS is_active,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.person_auth_question;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.person_company AS
SELECT
	company_id,
	person_id,
	person_company_status,
	person_company_relation,
	CASE WHEN is_exempt IS NULL THEN NULL
		WHEN is_exempt = true THEN 'Y'
		WHEN is_exempt = false THEN 'N'
		ELSE NULL
	END AS is_exempt,
	CASE WHEN is_management IS NULL THEN NULL
		WHEN is_management = true THEN 'Y'
		WHEN is_management = false THEN 'N'
		ELSE NULL
	END AS is_management,
	CASE WHEN is_full_time IS NULL THEN NULL
		WHEN is_full_time = true THEN 'Y'
		WHEN is_full_time = false THEN 'N'
		ELSE NULL
	END AS is_full_time,
	description,
	position_title,
	hire_date,
	termination_date,
	manager_person_id,
	nickname,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.person_company;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.person_company_attr AS
SELECT
	company_id,
	person_id,
	person_company_attribute_name AS person_company_attr_name,
	attribute_value,
	attribute_value_timestamp,
	attribute_value_person_id,
	start_date,
	finish_date,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.person_company_attribute;

CREATE OR REPLACE VIEW jazzhands_legacy.person_company_badge AS
SELECT company_id,person_id,badge_id,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.person_company_badge;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.person_contact AS
SELECT
	person_contact_id,
	person_id,
	person_contact_type,
	person_contact_technology,
	person_contact_location_type,
	person_contact_privacy,
	person_contact_carrier_company_id AS person_contact_cr_company_id,
	iso_country_code,
	phone_number,
	phone_extension,
	phone_pin,
	person_contact_account_name,
	person_contact_order,
	person_contact_notes,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.person_contact;

CREATE OR REPLACE VIEW jazzhands_legacy.person_image AS
SELECT person_image_id,person_id,person_image_order,image_type,image_blob,image_checksum,image_label,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.person_image;

CREATE OR REPLACE VIEW jazzhands_legacy.person_image_usage AS
SELECT person_image_id,person_image_usage,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.person_image_usage;

CREATE OR REPLACE VIEW jazzhands_legacy.person_location AS
SELECT person_location_id,person_id,person_location_type,site_code,physical_address_id,building,floor,section,seat_number,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.person_location;

CREATE OR REPLACE VIEW jazzhands_legacy.person_note AS
SELECT note_id,person_id,note_text,note_date,note_user,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.person_note;

CREATE OR REPLACE VIEW jazzhands_legacy.person_parking_pass AS
SELECT person_parking_pass_id,person_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.person_parking_pass;

CREATE OR REPLACE VIEW jazzhands_legacy.person_vehicle AS
SELECT person_vehicle_id,person_id,vehicle_make,vehicle_model,vehicle_year,vehicle_color,vehicle_license_plate,vehicle_license_state,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.person_vehicle;

CREATE OR REPLACE VIEW jazzhands_legacy.physical_address AS
SELECT physical_address_id,physical_address_type,company_id,site_rank,description,display_label,address_agent,address_housename,address_street,address_building,address_pobox,address_neighborhood,address_city,address_subregion,address_region,postal_code,iso_country_code,address_freeform,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.physical_address;

-- XXX - Need to fill in by hand!
CREATE OR REPLACE VIEW jazzhands_legacy.physical_connection AS
SELECT
	physical_connection_id,
	NULL AS physical_port1_id, -- Need to fill in
	NULL AS physical_port2_id, -- Need to fill in
	slot1_id,
	slot2_id,
	cable_type,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.physical_connection;

CREATE OR REPLACE VIEW jazzhands_legacy.physical_port AS
SELECT physical_port_id,device_id,port_name,port_type,description,port_plug_style,port_medium,port_protocol,port_speed,physical_label,port_purpose,logical_port_id,tcp_port,is_hardwired,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.physical_port;

CREATE OR REPLACE VIEW jazzhands_legacy.physicalish_volume AS
SELECT physicalish_volume_id,physicalish_volume_name,physicalish_volume_type,device_id,logical_volume_id,component_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.physicalish_volume;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.private_key AS
SELECT
	private_key_id,
	private_key_encryption_type,
	CASE WHEN is_active IS NULL THEN NULL
		WHEN is_active = true THEN 'Y'
		WHEN is_active = false THEN 'N'
		ELSE NULL
	END AS is_active,
	subject_key_identifier,
	private_key,
	passphrase,
	encryption_key_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.private_key;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.property AS
SELECT
	property_id,
	account_collection_id,
	account_id,
	account_realm_id,
	company_collection_id,
	company_id,
	device_collection_id,
	dns_domain_collection_id,
	layer2_network_collection_id,
	layer3_network_collection_id,
	netblock_collection_id,
	network_range_id,
	operating_system_id,
	operating_system_snapshot_id,
	person_id,
	property_name_collection_id AS property_collection_id,
	service_environment_collection_id AS service_env_collection_id,
	site_code,
	x509_signed_certificate_id,
	property_name,
	property_type,
	property_value,
	property_value_timestamp,
	property_value_account_collection_id AS property_value_account_coll_id,
	property_value_device_collection_id AS property_value_device_coll_id,
	property_value_json,
	property_value_netblock_collection_id AS property_value_nblk_coll_id,
	property_value_password_type,
	property_value_person_id,
	property_value_sw_package_id,
	property_value_token_collection_id AS property_value_token_col_id,
	property_rank,
	start_date,
	finish_date,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.property;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.property_collection AS
SELECT
	property_name_collection_id AS property_collection_id,
	property_name_collection_name AS property_collection_name,
	property_name_collection_type AS property_collection_type,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.property_name_collection;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.property_collection_hier AS
SELECT
	property_name_collection_id AS property_collection_id,
	child_property_name_collection_id AS child_property_collection_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.property_name_collection_hier;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.property_collection_property AS
SELECT
	property_name_collection_id AS property_collection_id,
	property_name,
	property_type,
	property_id_rank,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.property_name_collection_property_name;

CREATE OR REPLACE VIEW jazzhands_legacy.pseudo_klogin AS
SELECT pseudo_klogin_id,principal,dest_account_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.pseudo_klogin;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.rack AS
SELECT
	rack_id,
	site_code,
	room,
	sub_room,
	rack_row,
	rack_name,
	rack_style,
	rack_type,
	description,
	rack_height_in_u,
	CASE WHEN display_from_bottom IS NULL THEN NULL
		WHEN display_from_bottom = true THEN 'Y'
		WHEN display_from_bottom = false THEN 'N'
		ELSE NULL
	END AS display_from_bottom,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.rack;

CREATE OR REPLACE VIEW jazzhands_legacy.rack_location AS
SELECT rack_location_id,rack_id,rack_u_offset_of_device_top,rack_side,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.rack_location;

CREATE OR REPLACE VIEW jazzhands_legacy.service_environment AS
SELECT service_environment_id,service_environment_name,production_state,description,external_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.service_environment;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.service_environment_coll_hier AS
SELECT
	service_environment_collection_id AS service_env_collection_id,
	child_service_environment_collection_id AS child_service_env_coll_id,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.service_environment_collection_hier;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.service_environment_collection AS
SELECT
	service_environment_collection_id AS service_env_collection_id,
	service_environment_collection_name AS service_env_collection_name,
	service_environment_collection_type AS service_env_collection_type,
	description,
	external_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.service_environment_collection;

CREATE OR REPLACE VIEW jazzhands_legacy.shared_netblock AS
SELECT shared_netblock_id,shared_netblock_protocol,netblock_id,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.shared_netblock;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.shared_netblock_network_int AS
SELECT
	shared_netblock_id,
	layer3_interface_id AS network_interface_id,
	priority,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.shared_netblock_layer3_interface;

CREATE OR REPLACE VIEW jazzhands_legacy.site AS
SELECT site_code,colo_company_id,physical_address_id,site_status,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.site;

CREATE OR REPLACE VIEW jazzhands_legacy.site_netblock AS
SELECT site_code,netblock_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.site_netblock;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.slot AS
SELECT
	slot_id,
	component_id,
	slot_name,
	slot_index,
	slot_type_id,
	component_type_slot_template_id AS component_type_slot_tmplt_id,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	physical_label,
	mac_address,
	description,
	slot_x_offset,
	slot_y_offset,
	slot_z_offset,
	slot_side,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.slot;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.slot_type AS
SELECT
	slot_type_id,
	slot_type,
	slot_function,
	slot_physical_interface_type,
	description,
	CASE WHEN remote_slot_permitted IS NULL THEN NULL
		WHEN remote_slot_permitted = true THEN 'Y'
		WHEN remote_slot_permitted = false THEN 'N'
		ELSE NULL
	END AS remote_slot_permitted,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.slot_type;

CREATE OR REPLACE VIEW jazzhands_legacy.slot_type_prmt_comp_slot_type AS
SELECT slot_type_id,component_slot_type_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.slot_type_permitted_component_slot_type;

CREATE OR REPLACE VIEW jazzhands_legacy.slot_type_prmt_rem_slot_type AS
SELECT slot_type_id,remote_slot_type_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.slot_type_permitted_remote_slot_type;

CREATE OR REPLACE VIEW jazzhands_legacy.ssh_key AS
SELECT ssh_key_id,ssh_key_type,ssh_public_key,ssh_private_key,encryption_key_id,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.ssh_key;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.static_route AS
SELECT
	static_route_id,
	device_source_id AS device_src_id,
	network_interface_destination_id AS network_interface_dst_id,
	netblock_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.static_route;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.static_route_template AS
SELECT
	static_route_template_id,
	netblock_source_id AS netblock_src_id,
	network_interface_destination_id AS network_interface_dst_id,
	netblock_id,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.static_route_template;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.sudo_acct_col_device_collectio AS
SELECT
	sudo_alias_name,
	device_collection_id,
	account_collection_id,
	run_as_account_collection_id,
	CASE WHEN requires_password IS NULL THEN NULL
		WHEN requires_password = true THEN 'Y'
		WHEN requires_password = false THEN 'N'
		ELSE NULL
	END AS requires_password,
	CASE WHEN can_exec_child IS NULL THEN NULL
		WHEN can_exec_child = true THEN 'Y'
		WHEN can_exec_child = false THEN 'N'
		ELSE NULL
	END AS can_exec_child,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.sudo_account_collection_device_collection;

CREATE OR REPLACE VIEW jazzhands_legacy.sudo_alias AS
SELECT sudo_alias_name,sudo_alias_value,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.sudo_alias;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.svc_environment_coll_svc_env AS
SELECT
	service_environment_collection_id AS service_env_collection_id,
	service_environment_id,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.service_environment_collection_service_environment;

CREATE OR REPLACE VIEW jazzhands_legacy.sw_package AS
SELECT sw_package_id,sw_package_name,sw_package_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.sw_package;

CREATE OR REPLACE VIEW jazzhands_legacy.ticketing_system AS
SELECT ticketing_system_id,ticketing_system_name,ticketing_system_url,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.ticketing_system;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.token AS
SELECT
	token_id,
	token_type,
	token_status,
	description,
	external_id,
	token_serial,
	zero_time,
	time_modulo,
	time_skew,
	token_key,
	encryption_key_id,
	token_password,
	expire_time,
	CASE WHEN is_token_locked IS NULL THEN NULL
		WHEN is_token_locked = true THEN 'Y'
		WHEN is_token_locked = false THEN 'N'
		ELSE NULL
	END AS is_token_locked,
	token_unlock_time,
	bad_logins,
	last_updated,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.token;

CREATE OR REPLACE VIEW jazzhands_legacy.token_collection AS
SELECT token_collection_id,token_collection_name,token_collection_type,description,external_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.token_collection;

CREATE OR REPLACE VIEW jazzhands_legacy.token_collection_hier AS
SELECT token_collection_id,child_token_collection_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.token_collection_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.token_collection_token AS
SELECT token_collection_id,token_id,token_id_rank,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.token_collection_token;

CREATE OR REPLACE VIEW jazzhands_legacy.token_sequence AS
SELECT token_id,token_sequence,last_updated
FROM jazzhands.token_sequence;

CREATE OR REPLACE VIEW jazzhands_legacy.unix_group AS
SELECT account_collection_id,unix_gid,group_password,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.unix_group;

CREATE OR REPLACE VIEW jazzhands_legacy.v_account_collection_account AS
SELECT account_collection_id,account_id,account_collection_relation,account_id_rank,start_date,finish_date,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.v_account_collection_account;

CREATE OR REPLACE VIEW jazzhands_legacy.v_account_collection_expanded AS
SELECT level,root_account_collection_id,account_collection_id
FROM jazzhands.v_account_collection_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_account_collection_hier_from_ancestor AS
SELECT root_account_collection_id,account_collection_id,path,cycle
FROM jazzhands.v_account_collection_hier_from_ancestor;

CREATE OR REPLACE VIEW jazzhands_legacy.v_account_manager_hier AS
SELECT level,account_id,person_id,company_id,login,human_readable,account_realm_id,manager_account_id,manager_login,manager_person_id,manager_company_id,manager_human_readable,array_path
FROM jazzhands.v_account_manager_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.v_account_manager_map AS
SELECT login,account_id,person_id,company_id,account_realm_id,first_name,last_name,middle_name,manager_person_id,employee_id,human_readable,manager_account_id,manager_login,manager_human_readable,manager_last_name,manager_middle_name,manger_first_name,manager_employee_id,manager_company_id
FROM jazzhands.v_account_manager_map;

CREATE OR REPLACE VIEW jazzhands_legacy.v_account_name AS
SELECT account_id,first_name,last_name,display_name
FROM jazzhands.v_account_name;

CREATE OR REPLACE VIEW jazzhands_legacy.v_acct_coll_acct_expanded AS
SELECT account_collection_id,account_id
FROM jazzhands.v_account_collection_account_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_acct_coll_acct_expanded_detail AS
SELECT account_collection_id,root_account_collection_id,account_id,acct_coll_level,dept_level,assign_method,text_path,array_path
FROM jazzhands.v_account_collection_account_expanded_detail;

CREATE OR REPLACE VIEW jazzhands_legacy.v_acct_coll_expanded AS
SELECT level,account_collection_id,root_account_collection_id,text_path,array_path,rvs_array_path
FROM jazzhands.v_account_collection_expanded;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.v_acct_coll_expanded_detail AS
SELECT
	account_collection_id,
	root_account_collection_id,
	account_collection_level AS acct_coll_level,
	department_level AS dept_level,
	assignment_method AS assign_method,
	text_path,
	array_path
FROM jazzhands.v_account_collection_expanded_detail;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.v_acct_coll_prop_expanded AS
SELECT
	account_collection_id,
	property_id,
	property_name,
	property_type,
	property_value,
	property_value_timestamp,
	property_value_account_collection_id AS property_value_account_coll_id,
	property_value_netblock_collection_id AS property_value_nblk_coll_id,
	property_value_password_type,
	property_value_person_id,
	property_value_token_collection_id AS property_value_token_col_id,
	property_rank,
	is_multivalue,
	assignment_rank AS assign_rank
FROM jazzhands.v_account_collection_property_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_application_role AS
SELECT role_level,role_id,parent_role_id,root_role_id,root_role_name,role_name,role_path,role_is_leaf,array_path,cycle
FROM jazzhands.v_application_role;

CREATE OR REPLACE VIEW jazzhands_legacy.v_application_role_member AS
SELECT device_id,role_id,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.v_application_role_member;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_approval_instance_step_expanded AS
SELECT
	first_approval_instance_item_id,
	root_step_id,
	approval_instance_item_id,
	approval_instance_step_id,
	tier,
	level,
	CASE WHEN is_approved IS NULL THEN NULL
		WHEN is_approved = true THEN 'Y'
		WHEN is_approved = false THEN 'N'
		ELSE NULL
	END AS is_approved
FROM jazzhands.v_approval_instance_step_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_company_hier AS
SELECT root_company_id,company_id
FROM jazzhands.v_company_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.v_component_hier AS
SELECT component_id,child_component_id,component_path,level
FROM jazzhands.v_component_hier;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_corp_family_account AS
SELECT
	account_id,
	login,
	person_id,
	company_id,
	account_realm_id,
	account_status,
	account_role,
	account_type,
	description,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.v_corp_family_account;

CREATE OR REPLACE VIEW jazzhands_legacy.v_department_company_expanded AS
SELECT company_id,account_collection_id
FROM jazzhands.v_department_company_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_dev_col_device_root AS
SELECT device_id,root_id,root_name,root_type,leaf_id,leaf_name,leaf_type
FROM jazzhands.v_dev_col_device_root;

CREATE OR REPLACE VIEW jazzhands_legacy.v_dev_col_root AS
SELECT root_id,root_name,root_type,leaf_id,leaf_name,leaf_type
FROM jazzhands.v_device_collection_root;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_dev_col_user_prop_expanded AS
SELECT
	property_id,
	device_collection_id,
	account_id,
	login,
	account_status,
	account_realm_id,
	account_realm_name,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	property_type,
	property_name,
	property_rank,
	property_value,
	is_multivalue,
	is_boolean
FROM jazzhands.v_device_collection_account_property_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_col_account_cart AS
SELECT device_collection_id,account_id,setting
FROM jazzhands.v_device_collection_account_cart;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_col_account_col_cart AS
SELECT device_collection_id,account_collection_id,setting
FROM jazzhands.v_device_collection_account_collection_cart;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_col_acct_col_expanded AS
SELECT device_collection_id,account_collection_id,account_id
FROM jazzhands.v_device_collection_account_collection_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_col_acct_col_unixgroup AS
SELECT device_collection_id,account_collection_id
FROM jazzhands.v_device_collection_account_collection_unix_group;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_col_acct_col_unixlogin AS
SELECT device_collection_id,account_collection_id,account_id
FROM jazzhands.v_device_collection_account_collection_unix_login;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_coll_device_expanded AS
SELECT device_collection_id,device_id
FROM jazzhands.v_device_collection_device_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_coll_hier_detail AS
SELECT device_collection_id,parent_device_collection_id,device_collection_level
FROM jazzhands.v_device_collection_hier_detail;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_collection_account_ssh_key AS
SELECT device_collection_id,account_id,ssh_public_key
FROM jazzhands.v_device_collection_account_ssh_key;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_collection_hier_from_ancestor AS
SELECT root_device_collection_id,device_collection_id,path,cycle
FROM jazzhands.v_device_collection_hier_from_ancestor;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_component_summary AS
SELECT device_id,cpu_model,cpu_count,core_count,memory_count,total_memory,disk_count,total_disk
FROM jazzhands.v_device_component_summary;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_components AS
SELECT device_id,component_id,component_path,level
FROM jazzhands.v_device_components;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_components_expanded AS
SELECT device_id,component_id,slot_id,vendor,model,serial_number,functions,slot_name,memory_size,memory_speed,disk_size,media_type
FROM jazzhands.v_device_components_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_components_json AS
SELECT device_id,components
FROM jazzhands.v_device_components_json;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_slot_connections AS
SELECT inter_component_connection_id,device_id,slot_id,slot_name,slot_index,mac_address,slot_type_id,slot_type,slot_function,remote_device_id,remote_slot_id,remote_slot_name,remote_slot_index,remote_mac_address,remote_slot_type_id,remote_slot_type,remote_slot_function
FROM jazzhands.v_device_slot_connections;

CREATE OR REPLACE VIEW jazzhands_legacy.v_device_slots AS
SELECT device_id,device_component_id,component_id,slot_id
FROM jazzhands.v_device_slots;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_dns AS
SELECT
	dns_record_id,
	network_range_id,
	dns_domain_id,
	dns_name,
	dns_ttl,
	dns_class,
	dns_type,
	dns_value,
	dns_priority,
	ip,
	netblock_id,
	ip_universe_id,
	ref_record_id,
	dns_srv_service,
	dns_srv_protocol,
	dns_srv_weight,
	dns_srv_port,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	CASE WHEN should_generate_ptr IS NULL THEN NULL
		WHEN should_generate_ptr = true THEN 'Y'
		WHEN should_generate_ptr = false THEN 'N'
		ELSE NULL
	END AS should_generate_ptr,
	dns_value_record_id
FROM jazzhands.v_dns;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_dns_changes_pending AS
SELECT
	dns_change_record_id,
	dns_domain_id,
	ip_universe_id,
	CASE WHEN should_generate IS NULL THEN NULL
		WHEN should_generate = true THEN 'Y'
		WHEN should_generate = false THEN 'N'
		ELSE NULL
	END AS should_generate,
	last_generated,
	soa_name,
	ip_address
FROM jazzhands.v_dns_changes_pending;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_dns_domain_nouniverse AS
SELECT
	dns_domain_id,
	soa_name,
	soa_class,
	soa_ttl,
	soa_serial,
	soa_refresh,
	soa_retry,
	soa_expire,
	soa_minimum,
	soa_mname,
	soa_rname,
	parent_dns_domain_id,
	CASE WHEN should_generate IS NULL THEN NULL
		WHEN should_generate = true THEN 'Y'
		WHEN should_generate = false THEN 'N'
		ELSE NULL
	END AS should_generate,
	last_generated,
	dns_domain_type,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.v_dns_domain_nouniverse;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_dns_fwd AS
SELECT
	dns_record_id,
	network_range_id,
	dns_domain_id,
	dns_name,
	dns_ttl,
	dns_class,
	dns_type,
	dns_value,
	dns_priority,
	ip,
	netblock_id,
	ip_universe_id,
	ref_record_id,
	dns_srv_service,
	dns_srv_protocol,
	dns_srv_weight,
	dns_srv_port,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	CASE WHEN should_generate_ptr IS NULL THEN NULL
		WHEN should_generate_ptr = true THEN 'Y'
		WHEN should_generate_ptr = false THEN 'N'
		ELSE NULL
	END AS should_generate_ptr,
	dns_value_record_id
FROM jazzhands.v_dns_fwd;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_dns_rvs AS
SELECT
	dns_record_id,
	network_range_id,
	dns_domain_id,
	dns_name,
	dns_ttl,
	dns_class,
	dns_type,
	dns_value,
	dns_priority,
	ip,
	netblock_id,
	ip_universe_id,
	rdns_record_id,
	dns_srv_service,
	dns_srv_protocol,
	dns_srv_weight,
	dns_srv_srv_port,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	CASE WHEN should_generate_ptr IS NULL THEN NULL
		WHEN should_generate_ptr = true THEN 'Y'
		WHEN should_generate_ptr = false THEN 'N'
		ELSE NULL
	END AS should_generate_ptr,
	dns_value_record_id
FROM jazzhands.v_dns_rvs;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_dns_sorted AS
SELECT
	dns_record_id,
	network_range_id,
	dns_value_record_id,
	dns_name,
	dns_ttl,
	dns_class,
	dns_type,
	dns_value,
	dns_priority,
	ip,
	netblock_id,
	ref_record_id,
	dns_srv_service,
	dns_srv_protocol,
	dns_srv_weight,
	dns_srv_port,
	CASE WHEN should_generate_ptr IS NULL THEN NULL
		WHEN should_generate_ptr = true THEN 'Y'
		WHEN should_generate_ptr = false THEN 'N'
		ELSE NULL
	END AS should_generate_ptr,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	dns_domain_id,
	anchor_record_id,
	anchor_rank
FROM jazzhands.v_dns_sorted;

CREATE OR REPLACE VIEW jazzhands_legacy.v_hotpants_account_attribute AS
SELECT property_id,account_id,device_collection_id,login,property_name,property_type,property_value,property_rank,is_boolean
FROM jazzhands.v_hotpants_account_attribute;

CREATE OR REPLACE VIEW jazzhands_legacy.v_hotpants_client AS
SELECT device_id,device_name,ip_address,radius_secret
FROM jazzhands.v_hotpants_client;

CREATE OR REPLACE VIEW jazzhands_legacy.v_hotpants_dc_attribute AS
SELECT property_id,device_collection_id,property_name,property_type,property_rank,property_value
FROM jazzhands.v_hotpants_device_collection_attribute;

CREATE OR REPLACE VIEW jazzhands_legacy.v_hotpants_device_collection AS
SELECT device_id,device_name,device_collection_id,device_collection_name,device_collection_type,ip_address
FROM jazzhands.v_hotpants_device_collection;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_hotpants_token AS
SELECT
	token_id,
	token_type,
	token_status,
	token_serial,
	token_key,
	zero_time,
	time_modulo,
	token_password,
	CASE WHEN is_token_locked IS NULL THEN NULL
		WHEN is_token_locked = true THEN 'Y'
		WHEN is_token_locked = false THEN 'N'
		ELSE NULL
	END AS is_token_locked,
	token_unlock_time,
	bad_logins,
	token_sequence,
	last_updated,
	encryption_key_db_value,
	encryption_key_purpose,
	encryption_key_purpose_version,
	encryption_method
FROM jazzhands.v_hotpants_token;

CREATE OR REPLACE VIEW jazzhands_legacy.v_l1_all_physical_ports AS
SELECT layer1_connection_id,physical_port_id,device_id,port_name,port_type,port_purpose,other_physical_port_id,other_device_id,other_port_name,other_port_purpose,baud,data_bits,stop_bits,parity,flow_control
FROM jazzhands.v_l1_all_physical_ports;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.v_l2_network_coll_expanded AS
SELECT
	level,
	layer2_network_collection_id,
	root_layer2_network_collection_id AS root_l2_network_coll_id,
	text_path,
	array_path,
	rvs_array_path
FROM jazzhands.v_layer2_network_collection_expanded;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.v_l3_network_coll_expanded AS
SELECT
	level,
	layer3_network_collection_id,
	root_layer3_network_collection_id AS root_l3_network_coll_id,
	text_path,
	array_path,
	rvs_array_path
FROM jazzhands.v_layer3_network_collection_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_layerx_network_expanded AS
SELECT layer3_network_id,layer3_network_description,netblock_id,ip_address,netblock_type,ip_universe_id,default_gateway_netblock_id,default_gateway_ip_address,default_gateway_netblock_type,default_gateway_ip_universe_id,layer2_network_id,encapsulation_name,encapsulation_domain,encapsulation_type,encapsulation_tag,layer2_network_description
FROM jazzhands.v_layerx_network_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_lv_hier AS
SELECT physicalish_volume_id,volume_group_id,logical_volume_id,child_pv_id,child_vg_id,child_lv_id,pv_path,vg_path,lv_path
FROM jazzhands.v_lv_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.v_nblk_coll_netblock_expanded AS
SELECT netblock_collection_id,netblock_id
FROM jazzhands.v_netblock_collection_netblock_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_netblock_coll_expanded AS
SELECT level,netblock_collection_id,root_netblock_collection_id,text_path,array_path,rvs_array_path
FROM jazzhands.v_netblock_collection_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_netblock_collection_hier_from_ancestor AS
SELECT root_netblock_collection_id,netblock_collection_id,path,cycle
FROM jazzhands.v_netblock_collection_hier_from_ancestor;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_netblock_hier AS
SELECT
	netblock_level,
	root_netblock_id,
	ip,
	netblock_id,
	ip_address,
	netblock_status,
	CASE WHEN is_single_address IS NULL THEN NULL
		WHEN is_single_address = true THEN 'Y'
		WHEN is_single_address = false THEN 'N'
		ELSE NULL
	END AS is_single_address,
	description,
	parent_netblock_id,
	site_code,
	text_path,
	array_path,
	array_ip_path
FROM jazzhands.v_netblock_hier;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_netblock_hier_expanded AS
SELECT
	netblock_level,
	root_netblock_id,
	site_code,
	path,
	netblock_id,
	ip_address,
	netblock_type,
	CASE WHEN is_single_address IS NULL THEN NULL
		WHEN is_single_address = true THEN 'Y'
		WHEN is_single_address = false THEN 'N'
		ELSE NULL
	END AS is_single_address,
	CASE WHEN can_subnet IS NULL THEN NULL
		WHEN can_subnet = true THEN 'Y'
		WHEN can_subnet = false THEN 'N'
		ELSE NULL
	END AS can_subnet,
	parent_netblock_id,
	netblock_status,
	ip_universe_id,
	description,
	external_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.v_netblock_hier_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_network_range_expanded AS
SELECT network_range_id,network_range_type,description,parent_netblock_id,ip_address,netblock_type,ip_universe_id,start_netblock_id,start_ip_address,start_netblock_type,start_ip_universe_id,stop_netblock_id,stop_ip_address,stop_netblock_type,stop_ip_universe_id,dns_prefix,dns_domain_id,soa_name
FROM jazzhands.v_network_range_expanded;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_person AS
SELECT
	person_id,
	description,
	first_name,
	middle_name,
	last_name,
	name_suffix,
	gender,
	preferred_first_name,
	preferred_last_name,
	legal_first_name,
	legal_last_name,
	nickname,
	birth_date,
	diet,
	shirt_size,
	pant_size,
	hat_size,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.v_person;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_person_company AS
SELECT
	company_id,
	person_id,
	person_company_status,
	person_company_relation,
	CASE WHEN is_exempt IS NULL THEN NULL
		WHEN is_exempt = true THEN 'Y'
		WHEN is_exempt = false THEN 'N'
		ELSE NULL
	END AS is_exempt,
	CASE WHEN is_management IS NULL THEN NULL
		WHEN is_management = true THEN 'Y'
		WHEN is_management = false THEN 'N'
		ELSE NULL
	END AS is_management,
	CASE WHEN is_full_time IS NULL THEN NULL
		WHEN is_full_time = true THEN 'Y'
		WHEN is_full_time = false THEN 'N'
		ELSE NULL
	END AS is_full_time,
	description,
	employee_id,
	payroll_id,
	external_hr_id,
	position_title,
	badge_system_id,
	hire_date,
	termination_date,
	manager_person_id,
	supervisor_person_id,
	nickname,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.v_person_company;

CREATE OR REPLACE VIEW jazzhands_legacy.v_person_company_expanded AS
SELECT company_id,person_id
FROM jazzhands.v_person_company_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_person_company_hier AS
SELECT level,person_id,subordinate_person_id,intermediate_person_id,person_company_relation,array_path,rvs_array_path,cycle
FROM jazzhands.v_person_company_hier;

CREATE OR REPLACE VIEW jazzhands_legacy.v_physical_connection AS
SELECT level,inter_component_connection_id,layer1_connection_id,physical_connection_id,inter_dev_conn_slot1_id,inter_dev_conn_slot2_id,layer1_physical_port1_id,layer1_physical_port2_id,slot1_id,slot2_id,physical_port1_id,physical_port2_id
FROM jazzhands.v_physical_connection;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_property AS
SELECT
	property_id,
	account_collection_id,
	account_id,
	account_realm_id,
	company_collection_id,
	company_id,
	device_collection_id,
	dns_domain_collection_id,
	layer2_network_collection_id,
	layer3_network_collection_id,
	netblock_collection_id,
	network_range_id,
	operating_system_id,
	operating_system_snapshot_id,
	person_id,
	property_name_collection_id AS property_collection_id,
	service_environment_collection_id AS service_env_collection_id,
	site_code,
	x509_signed_certificate_id,
	property_name,
	property_type,
	property_value,
	property_value_timestamp,
	property_value_account_collection_id AS property_value_account_coll_id,
	property_value_device_collection_id AS property_value_device_coll_id,
	property_value_json,
	property_value_netblock_collection_id AS property_value_nblk_coll_id,
	property_value_password_type,
	property_value_person_id,
	property_value_sw_package_id,
	property_value_token_collection_id AS property_value_token_col_id,
	property_rank,
	start_date,
	finish_date,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.v_property;

CREATE OR REPLACE VIEW jazzhands_legacy.v_site_netblock_expanded AS
SELECT site_code,netblock_id
FROM jazzhands.v_site_netblock_expanded;

CREATE OR REPLACE VIEW jazzhands_legacy.v_site_netblock_expanded_assigned AS
SELECT site_code,netblock_id
FROM jazzhands.v_site_netblock_expanded_assigned;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.v_token AS
SELECT
	token_id,
	token_type,
	token_status,
	token_serial,
	token_sequence,
	account_id,
	token_password,
	zero_time,
	time_modulo,
	time_skew,
	CASE WHEN is_token_locked IS NULL THEN NULL
		WHEN is_token_locked = true THEN 'Y'
		WHEN is_token_locked = false THEN 'N'
		ELSE NULL
	END AS is_token_locked,
	token_unlock_time,
	bad_logins,
	issued_date,
	token_last_updated,
	token_sequence_last_updated,
	lock_status_last_updated
FROM jazzhands.v_token;

CREATE OR REPLACE VIEW jazzhands_legacy.v_unix_account_overrides AS
SELECT device_collection_id,account_id,setting
FROM jazzhands.v_unix_account_overrides;

CREATE OR REPLACE VIEW jazzhands_legacy.v_unix_group_mappings AS
SELECT device_collection_id,account_collection_id,group_name,unix_gid,group_password,setting,mclass_setting,members
FROM jazzhands.v_unix_group_mappings;

CREATE OR REPLACE VIEW jazzhands_legacy.v_unix_group_overrides AS
SELECT device_collection_id,account_collection_id,setting
FROM jazzhands.v_unix_group_overrides;

CREATE OR REPLACE VIEW jazzhands_legacy.v_unix_mclass_settings AS
SELECT device_collection_id,mclass_setting
FROM jazzhands.v_unix_mclass_settings;

CREATE OR REPLACE VIEW jazzhands_legacy.v_unix_passwd_mappings AS
SELECT device_collection_id,account_id,login,crypt,unix_uid,unix_group_name,gecos,home,shell,ssh_public_key,setting,mclass_setting,extra_groups
FROM jazzhands.v_unix_passwd_mappings;

CREATE OR REPLACE VIEW jazzhands_legacy.val_account_collection_relatio AS
SELECT account_collection_relation,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_account_collection_relation;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_account_collection_type AS
SELECT
	account_collection_type,
	description,
	CASE WHEN is_infrastructure_type IS NULL THEN NULL
		WHEN is_infrastructure_type = true THEN 'Y'
		WHEN is_infrastructure_type = false THEN 'N'
		ELSE NULL
	END AS is_infrastructure_type,
	max_num_members,
	max_num_collections,
	CASE WHEN can_have_hierarchy IS NULL THEN NULL
		WHEN can_have_hierarchy = true THEN 'Y'
		WHEN can_have_hierarchy = false THEN 'N'
		ELSE NULL
	END AS can_have_hierarchy,
	account_realm_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_account_collection_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_account_role AS
SELECT
	account_role,
	CASE WHEN uid_gid_forced IS NULL THEN NULL
		WHEN uid_gid_forced = true THEN 'Y'
		WHEN uid_gid_forced = false THEN 'N'
		ELSE NULL
	END AS uid_gid_forced,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_account_role;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_account_type AS
SELECT
	account_type,
	CASE WHEN is_person IS NULL THEN NULL
		WHEN is_person = true THEN 'Y'
		WHEN is_person = false THEN 'N'
		ELSE NULL
	END AS is_person,
	CASE WHEN uid_gid_forced IS NULL THEN NULL
		WHEN uid_gid_forced = true THEN 'Y'
		WHEN uid_gid_forced = false THEN 'N'
		ELSE NULL
	END AS uid_gid_forced,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_account_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_app_key AS
SELECT appaal_group_name,app_key,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_app_key;

CREATE OR REPLACE VIEW jazzhands_legacy.val_app_key_values AS
SELECT appaal_group_name,app_key,app_value,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_app_key_values;

CREATE OR REPLACE VIEW jazzhands_legacy.val_appaal_group_name AS
SELECT appaal_group_name,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_appaal_group_name;

CREATE OR REPLACE VIEW jazzhands_legacy.val_approval_chain_resp_prd AS
SELECT approval_chain_response_period,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_approval_chain_response_period;

CREATE OR REPLACE VIEW jazzhands_legacy.val_approval_expiration_action AS
SELECT approval_expiration_action,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_approval_expiration_action;

CREATE OR REPLACE VIEW jazzhands_legacy.val_approval_notifty_type AS
SELECT approval_notify_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_approval_notifty_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_approval_process_type AS
SELECT approval_process_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_approval_process_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_approval_type AS
SELECT approval_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_approval_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_attestation_frequency AS
SELECT attestation_frequency,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_attestation_frequency;

CREATE OR REPLACE VIEW jazzhands_legacy.val_auth_question AS
SELECT auth_question_id,question_text,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_auth_question;

CREATE OR REPLACE VIEW jazzhands_legacy.val_auth_resource AS
SELECT auth_resource,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_auth_resource;

CREATE OR REPLACE VIEW jazzhands_legacy.val_badge_status AS
SELECT badge_status,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_badge_status;

CREATE OR REPLACE VIEW jazzhands_legacy.val_cable_type AS
SELECT cable_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_cable_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_company_collection_type AS
SELECT
	company_collection_type,
	description,
	CASE WHEN is_infrastructure_type IS NULL THEN NULL
		WHEN is_infrastructure_type = true THEN 'Y'
		WHEN is_infrastructure_type = false THEN 'N'
		ELSE NULL
	END AS is_infrastructure_type,
	max_num_members,
	max_num_collections,
	CASE WHEN can_have_hierarchy IS NULL THEN NULL
		WHEN can_have_hierarchy = true THEN 'Y'
		WHEN can_have_hierarchy = false THEN 'N'
		ELSE NULL
	END AS can_have_hierarchy,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_company_collection_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_company_type AS
SELECT company_type,description,company_type_purpose,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_company_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_company_type_purpose AS
SELECT company_type_purpose,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_company_type_purpose;

CREATE OR REPLACE VIEW jazzhands_legacy.val_component_function AS
SELECT component_function,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_component_function;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_component_property AS
SELECT
	component_property_name,
	component_property_type,
	description,
	CASE WHEN is_multivalue IS NULL THEN NULL
		WHEN is_multivalue = true THEN 'Y'
		WHEN is_multivalue = false THEN 'N'
		ELSE NULL
	END AS is_multivalue,
	property_data_type,
	permit_component_type_id,
	required_component_type_id,
	permit_component_function,
	required_component_function,
	permit_component_id,
	permit_inter_component_connection_id AS permit_intcomp_conn_id,
	permit_slot_type_id,
	required_slot_type_id,
	permit_slot_function,
	required_slot_function,
	permit_slot_id,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_component_property;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_component_property_type AS
SELECT
	component_property_type,
	description,
	CASE WHEN is_multivalue IS NULL THEN NULL
		WHEN is_multivalue = true THEN 'Y'
		WHEN is_multivalue = false THEN 'N'
		ELSE NULL
	END AS is_multivalue,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_component_property_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_component_property_value AS
SELECT component_property_name,component_property_type,valid_property_value,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_component_property_value;

CREATE OR REPLACE VIEW jazzhands_legacy.val_contract_type AS
SELECT contract_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_contract_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_country_code AS
SELECT iso_country_code,dial_country_code,primary_iso_currency_code,country_name,display_priority,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_country_code;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_device_collection_type AS
SELECT
	device_collection_type,
	description,
	max_num_members,
	max_num_collections,
	CASE WHEN can_have_hierarchy IS NULL THEN NULL
		WHEN can_have_hierarchy = true THEN 'Y'
		WHEN can_have_hierarchy = false THEN 'N'
		ELSE NULL
	END AS can_have_hierarchy,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_device_collection_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_device_mgmt_ctrl_type AS
SELECT device_mgmt_control_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_device_management_controller_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_device_status AS
SELECT device_status,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_device_status;

CREATE OR REPLACE VIEW jazzhands_legacy.val_diet AS
SELECT diet,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_diet;

CREATE OR REPLACE VIEW jazzhands_legacy.val_dns_class AS
SELECT dns_class,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_dns_class;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_dns_domain_collection_type AS
SELECT
	dns_domain_collection_type,
	description,
	max_num_members,
	max_num_collections,
	CASE WHEN can_have_hierarchy IS NULL THEN NULL
		WHEN can_have_hierarchy = true THEN 'Y'
		WHEN can_have_hierarchy = false THEN 'N'
		ELSE NULL
	END AS can_have_hierarchy,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_dns_domain_collection_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_dns_domain_type AS
SELECT
	dns_domain_type,
	CASE WHEN can_generate IS NULL THEN NULL
		WHEN can_generate = true THEN 'Y'
		WHEN can_generate = false THEN 'N'
		ELSE NULL
	END AS can_generate,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_dns_domain_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_dns_record_relation_type AS
SELECT dns_record_relation_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_dns_record_relation_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_dns_srv_service AS
SELECT dns_srv_service,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_dns_srv_service;

CREATE OR REPLACE VIEW jazzhands_legacy.val_dns_type AS
SELECT dns_type,description,id_type,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_dns_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_encapsulation_mode AS
SELECT encapsulation_mode,encapsulation_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_encapsulation_mode;

CREATE OR REPLACE VIEW jazzhands_legacy.val_encapsulation_type AS
SELECT encapsulation_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_encapsulation_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_encryption_key_purpose AS
SELECT encryption_key_purpose,encryption_key_purpose_version,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_encryption_key_purpose;

CREATE OR REPLACE VIEW jazzhands_legacy.val_encryption_method AS
SELECT encryption_method,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_encryption_method;

CREATE OR REPLACE VIEW jazzhands_legacy.val_filesystem_type AS
SELECT filesystem_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_filesystem_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_image_type AS
SELECT image_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_image_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_ip_namespace AS
SELECT ip_namespace,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_ip_namespace;

CREATE OR REPLACE VIEW jazzhands_legacy.val_iso_currency_code AS
SELECT iso_currency_code,description,currency_symbol,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_iso_currency_code;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.val_key_usg_reason_for_assgn AS
SELECT
	key_usage_reason_for_assignment AS key_usage_reason_for_assign,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_key_usage_reason_for_assignment;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_layer2_network_coll_type AS
SELECT
	layer2_network_collection_type,
	description,
	max_num_members,
	max_num_collections,
	CASE WHEN can_have_hierarchy IS NULL THEN NULL
		WHEN can_have_hierarchy = true THEN 'Y'
		WHEN can_have_hierarchy = false THEN 'N'
		ELSE NULL
	END AS can_have_hierarchy,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_layer2_network_collection_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_layer3_network_coll_type AS
SELECT
	layer3_network_collection_type,
	description,
	max_num_members,
	max_num_collections,
	CASE WHEN can_have_hierarchy IS NULL THEN NULL
		WHEN can_have_hierarchy = true THEN 'Y'
		WHEN can_have_hierarchy = false THEN 'N'
		ELSE NULL
	END AS can_have_hierarchy,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_layer3_network_collection_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_logical_port_type AS
SELECT logical_port_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_logical_port_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_logical_volume_property AS
SELECT logical_volume_property_name,filesystem_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_logical_volume_property;

CREATE OR REPLACE VIEW jazzhands_legacy.val_logical_volume_purpose AS
SELECT logical_volume_purpose,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_logical_volume_purpose;

CREATE OR REPLACE VIEW jazzhands_legacy.val_logical_volume_type AS
SELECT logical_volume_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_logical_volume_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_netblock_collection_type AS
SELECT
	netblock_collection_type,
	description,
	max_num_members,
	max_num_collections,
	CASE WHEN can_have_hierarchy IS NULL THEN NULL
		WHEN can_have_hierarchy = true THEN 'Y'
		WHEN can_have_hierarchy = false THEN 'N'
		ELSE NULL
	END AS can_have_hierarchy,
	netblock_is_single_address_restriction AS netblock_single_addr_restrict,
	netblock_ip_family_restriction AS netblock_ip_family_restrict,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_netblock_collection_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_netblock_status AS
SELECT netblock_status,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_netblock_status;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_netblock_type AS
SELECT
	netblock_type,
	description,
	CASE WHEN db_forced_hierarchy IS NULL THEN NULL
		WHEN db_forced_hierarchy = true THEN 'Y'
		WHEN db_forced_hierarchy = false THEN 'N'
		ELSE NULL
	END AS db_forced_hierarchy,
	CASE WHEN is_validated_hierarchy IS NULL THEN NULL
		WHEN is_validated_hierarchy = true THEN 'Y'
		WHEN is_validated_hierarchy = false THEN 'N'
		ELSE NULL
	END AS is_validated_hierarchy,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_netblock_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_network_interface_purpose AS
SELECT network_interface_purpose,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_network_interface_purpose;

CREATE OR REPLACE VIEW jazzhands_legacy.val_network_interface_type AS
SELECT network_interface_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_network_interface_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_network_range_type AS
SELECT
	network_range_type,
	description,
	dns_domain_required,
	default_dns_prefix,
	netblock_type,
	CASE WHEN can_overlap IS NULL THEN NULL
		WHEN can_overlap = true THEN 'Y'
		WHEN can_overlap = false THEN 'N'
		ELSE NULL
	END AS can_overlap,
	CASE WHEN require_cidr_boundary IS NULL THEN NULL
		WHEN require_cidr_boundary = true THEN 'Y'
		WHEN require_cidr_boundary = false THEN 'N'
		ELSE NULL
	END AS require_cidr_boundary,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_network_range_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_network_service_type AS
SELECT network_service_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_network_service_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_operating_system_family AS
SELECT operating_system_family,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_operating_system_family;

CREATE OR REPLACE VIEW jazzhands_legacy.val_os_snapshot_type AS
SELECT operating_system_snapshot_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_operating_system_snapshot_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_ownership_status AS
SELECT ownership_status,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_ownership_status;

CREATE OR REPLACE VIEW jazzhands_legacy.val_package_relation_type AS
SELECT package_relation_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_package_relation_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_password_type AS
SELECT password_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_password_type;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.val_person_company_attr_dtype AS
SELECT
	person_company_attribute_data_type AS person_company_attr_data_type,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_person_company_attribute_data_type;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.val_person_company_attr_name AS
SELECT
	person_company_attribute_name AS person_company_attr_name,
	person_company_attribute_data_type AS person_company_attr_data_type,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_person_company_attribute_name;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.val_person_company_attr_value AS
SELECT
	person_company_attribute_name AS person_company_attr_name,
	person_company_attribute_value AS person_company_attr_value,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_person_company_attribute_value;

CREATE OR REPLACE VIEW jazzhands_legacy.val_person_company_relation AS
SELECT person_company_relation,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_person_company_relation;

CREATE OR REPLACE VIEW jazzhands_legacy.val_person_contact_loc_type AS
SELECT person_contact_location_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_person_contact_location_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_person_contact_technology AS
SELECT person_contact_technology,person_contact_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_person_contact_technology;

CREATE OR REPLACE VIEW jazzhands_legacy.val_person_contact_type AS
SELECT person_contact_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_person_contact_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_person_image_usage AS
SELECT
	person_image_usage,
	CASE WHEN is_multivalue IS NULL THEN NULL
		WHEN is_multivalue = true THEN 'Y'
		WHEN is_multivalue = false THEN 'N'
		ELSE NULL
	END AS is_multivalue,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_person_image_usage;

CREATE OR REPLACE VIEW jazzhands_legacy.val_person_location_type AS
SELECT person_location_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_person_location_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_person_status AS
SELECT
	person_status,
	description,
	CASE WHEN is_enabled IS NULL THEN NULL
		WHEN is_enabled = true THEN 'Y'
		WHEN is_enabled = false THEN 'N'
		ELSE NULL
	END AS is_enabled,
	CASE WHEN propagate_from_person IS NULL THEN NULL
		WHEN propagate_from_person = true THEN 'Y'
		WHEN propagate_from_person = false THEN 'N'
		ELSE NULL
	END AS propagate_from_person,
	CASE WHEN is_forced IS NULL THEN NULL
		WHEN is_forced = true THEN 'Y'
		WHEN is_forced = false THEN 'N'
		ELSE NULL
	END AS is_forced,
	CASE WHEN is_db_enforced IS NULL THEN NULL
		WHEN is_db_enforced = true THEN 'Y'
		WHEN is_db_enforced = false THEN 'N'
		ELSE NULL
	END AS is_db_enforced,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_person_status;

CREATE OR REPLACE VIEW jazzhands_legacy.val_physical_address_type AS
SELECT physical_address_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_physical_address_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_physicalish_volume_type AS
SELECT physicalish_volume_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_physicalish_volume_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_processor_architecture AS
SELECT processor_architecture,kernel_bits,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_processor_architecture;

CREATE OR REPLACE VIEW jazzhands_legacy.val_production_state AS
SELECT production_state,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_production_state;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_property AS
SELECT
	property_name,
	property_type,
	description,
	account_collection_type,
	company_collection_type,
	device_collection_type,
	dns_domain_collection_type,
	layer2_network_collection_type,
	layer3_network_collection_type,
	netblock_collection_type,
	network_range_type,
	property_name_collection_type AS property_collection_type,
	service_environment_collection_type AS service_env_collection_type,
	CASE WHEN is_multivalue IS NULL THEN NULL
		WHEN is_multivalue = true THEN 'Y'
		WHEN is_multivalue = false THEN 'N'
		ELSE NULL
	END AS is_multivalue,
	property_value_account_collection_type_restriction AS prop_val_acct_coll_type_rstrct,
	property_value_device_collection_type_restriction AS prop_val_dev_coll_type_rstrct,
	property_value_netblock_collection_type_restriction AS prop_val_nblk_coll_type_rstrct,
	property_data_type,
	property_value_json_schema,
	permit_account_collection_id,
	permit_account_id,
	permit_account_realm_id,
	permit_company_id,
	permit_company_collection_id,
	permit_device_collection_id,
	permit_dns_domain_collection_id AS permit_dns_domain_coll_id,
	permit_layer2_network_collection_id AS permit_layer2_network_coll_id,
	permit_layer3_network_collection_id AS permit_layer3_network_coll_id,
	permit_netblock_collection_id,
	permit_network_range_id,
	permit_operating_system_id,
	permit_operating_system_snapshot_id AS permit_os_snapshot_id,
	permit_person_id,
	permit_property_name_collection_id AS permit_property_collection_id,
	permit_service_environment_collection AS permit_service_env_collection,
	permit_site_code,
	permit_x509_signed_certificate_id AS permit_x509_signed_cert_id,
	permit_property_rank,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_property;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_property_collection_type AS
SELECT
	property_name_collection_type AS property_collection_type,
	description,
	max_num_members,
	max_num_collections,
	CASE WHEN can_have_hierarchy IS NULL THEN NULL
		WHEN can_have_hierarchy = true THEN 'Y'
		WHEN can_have_hierarchy = false THEN 'N'
		ELSE NULL
	END AS can_have_hierarchy,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_property_name_collection_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_property_data_type AS
SELECT property_data_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_property_data_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_property_type AS
SELECT
	property_type,
	description,
	property_value_account_collection_type_restriction AS prop_val_acct_coll_type_rstrct,
	CASE WHEN is_multivalue IS NULL THEN NULL
		WHEN is_multivalue = true THEN 'Y'
		WHEN is_multivalue = false THEN 'N'
		ELSE NULL
	END AS is_multivalue,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_property_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_property_value AS
SELECT property_name,property_type,valid_property_value,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_property_value;

CREATE OR REPLACE VIEW jazzhands_legacy.val_pvt_key_encryption_type AS
SELECT private_key_encryption_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_private_key_encryption_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_rack_type AS
SELECT rack_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_rack_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_raid_type AS
SELECT raid_type,description,primary_raid_level,secondary_raid_level,raid_level_qualifier,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_raid_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_service_env_coll_type AS
SELECT
	service_environment_collection_type AS service_env_collection_type,
	description,
	max_num_members,
	max_num_collections,
	CASE WHEN can_have_hierarchy IS NULL THEN NULL
		WHEN can_have_hierarchy = true THEN 'Y'
		WHEN can_have_hierarchy = false THEN 'N'
		ELSE NULL
	END AS can_have_hierarchy,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_service_environment_collection_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_shared_netblock_protocol AS
SELECT shared_netblock_protocol,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_shared_netblock_protocol;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_slot_function AS
SELECT
	slot_function,
	description,
	CASE WHEN can_have_mac_address IS NULL THEN NULL
		WHEN can_have_mac_address = true THEN 'Y'
		WHEN can_have_mac_address = false THEN 'N'
		ELSE NULL
	END AS can_have_mac_address,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_slot_function;

CREATE OR REPLACE VIEW jazzhands_legacy.val_slot_physical_interface AS
SELECT slot_physical_interface_type,slot_function,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_slot_physical_interface;

CREATE OR REPLACE VIEW jazzhands_legacy.val_ssh_key_type AS
SELECT ssh_key_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_ssh_key_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_sw_package_type AS
SELECT sw_package_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_sw_package_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_token_collection_type AS
SELECT
	token_collection_type,
	description,
	max_num_members,
	max_num_collections,
	CASE WHEN can_have_hierarchy IS NULL THEN NULL
		WHEN can_have_hierarchy = true THEN 'Y'
		WHEN can_have_hierarchy = false THEN 'N'
		ELSE NULL
	END AS can_have_hierarchy,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_token_collection_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_token_status AS
SELECT token_status,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_token_status;

CREATE OR REPLACE VIEW jazzhands_legacy.val_token_type AS
SELECT token_type,description,token_digit_count,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_token_type;

CREATE OR REPLACE VIEW jazzhands_legacy.val_volume_group_purpose AS
SELECT volume_group_purpose,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_volume_group_purpose;

CREATE OR REPLACE VIEW jazzhands_legacy.val_volume_group_relation AS
SELECT volume_group_relation,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_volume_group_relation;

CREATE OR REPLACE VIEW jazzhands_legacy.val_volume_group_type AS
SELECT volume_group_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_volume_group_type;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.val_x509_certificate_file_fmt AS
SELECT
	x509_certificate_file_format AS x509_file_format,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_x509_certificate_file_format;

CREATE OR REPLACE VIEW jazzhands_legacy.val_x509_certificate_type AS
SELECT x509_certificate_type,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_x509_certificate_type;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.val_x509_key_usage AS
SELECT
	x509_key_usage AS x509_key_usg,
	description,
	CASE WHEN is_extended IS NULL THEN NULL
		WHEN is_extended = true THEN 'Y'
		WHEN is_extended = false THEN 'N'
		ELSE NULL
	END AS is_extended,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_x509_key_usage;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.val_x509_key_usage_category AS
SELECT
	x509_key_usage_category AS x509_key_usg_cat,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.val_x509_key_usage_category;

CREATE OR REPLACE VIEW jazzhands_legacy.val_x509_revocation_reason AS
SELECT x509_revocation_reason,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.val_x509_revocation_reason;

CREATE OR REPLACE VIEW jazzhands_legacy.volume_group AS
SELECT volume_group_id,device_id,component_id,volume_group_name,volume_group_type,volume_group_size_in_bytes,raid_type,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.volume_group;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.volume_group_physicalish_vol AS
SELECT
	physicalish_volume_id,
	volume_group_id,
	device_id,
	volume_group_primary_position AS volume_group_primary_pos,
	volume_group_secondary_position AS volume_group_secondary_pos,
	volume_group_relation,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.volume_group_physicalish_vol;

CREATE OR REPLACE VIEW jazzhands_legacy.volume_group_purpose AS
SELECT volume_group_id,volume_group_purpose,description,data_ins_user,data_ins_date,data_upd_user,data_upd_date
FROM jazzhands.volume_group_purpose;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.x509_certificate AS
SELECT
	x509_cert_id,
	friendly_name,
	CASE WHEN is_active IS NULL THEN NULL
		WHEN is_active = true THEN 'Y'
		WHEN is_active = false THEN 'N'
		ELSE NULL
	END AS is_active,
	CASE WHEN is_certificate_authority IS NULL THEN NULL
		WHEN is_certificate_authority = true THEN 'Y'
		WHEN is_certificate_authority = false THEN 'N'
		ELSE NULL
	END AS is_certificate_authority,
	signing_cert_id,
	x509_ca_cert_serial_number,
	public_key,
	private_key,
	certificate_sign_req,
	subject,
	subject_key_identifier,
	valid_from,
	valid_to,
	x509_revocation_date,
	x509_revocation_reason,
	passphrase,
	encryption_key_id,
	ocsp_uri,
	crl_uri,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.x509_certificate;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.x509_key_usage_attribute AS
SELECT
	x509_signed_certificate_id AS x509_cert_id,
	x509_key_usage AS x509_key_usg,
	x509_key_usgage_category AS x509_key_usg_cat,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.x509_key_usage_attribute;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.x509_key_usage_categorization AS
SELECT
	x509_key_usage_category AS x509_key_usg_cat,
	x509_key_usage AS x509_key_usg,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.x509_key_usage_categorization;

-- Simple column rename
CREATE OR REPLACE VIEW jazzhands_legacy.x509_key_usage_default AS
SELECT
	x509_signed_certificate_id,
	x509_key_usage AS x509_key_usg,
	description,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.x509_key_usage_default;

-- XXX - Type change
CREATE OR REPLACE VIEW jazzhands_legacy.x509_signed_certificate AS
SELECT
	x509_signed_certificate_id,
	x509_certificate_type,
	subject,
	friendly_name,
	subject_key_identifier,
	CASE WHEN is_active IS NULL THEN NULL
		WHEN is_active = true THEN 'Y'
		WHEN is_active = false THEN 'N'
		ELSE NULL
	END AS is_active,
	CASE WHEN is_certificate_authority IS NULL THEN NULL
		WHEN is_certificate_authority = true THEN 'Y'
		WHEN is_certificate_authority = false THEN 'N'
		ELSE NULL
	END AS is_certificate_authority,
	signing_cert_id,
	x509_ca_cert_serial_number,
	public_key,
	private_key_id,
	certificate_signing_request_id,
	valid_from,
	valid_to,
	x509_revocation_date,
	x509_revocation_reason,
	ocsp_uri,
	crl_uri,
	data_ins_user,
	data_ins_date,
	data_upd_user,
	data_upd_date
FROM jazzhands.x509_signed_certificate;



-- Deal with dropped tables
--- XXX - need to sort out snmp_commstr by hand
--- XXX - need to sort out v_device_collection_hier_trans by hand
--- XXX - need to sort out v_network_interface_trans by hand
--- XXX - need to sort out val_device_auto_mgmt_protocol by hand
--- XXX - need to sort out val_snmp_commstr_type by hand
-- Triggers for account

CREATE OR REPLACE FUNCTION jazzhands_legacy.account_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.account (
		account_id,login,person_id,company_id,is_enabled,account_realm_id,account_status,account_role,account_type,description,external_id
	) VALUES (
		NEW.account_id,NEW.login,NEW.person_id,NEW.company_id,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END,NEW.account_realm_id,NEW.account_status,NEW.account_role,NEW.account_type,NEW.description,NEW.external_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_account_ins
	ON jazzhands_legacy.account;
CREATE TRIGGER _trigger_account_ins
	INSTEAD OF INSERT ON jazzhands_legacy.account
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.account_ins();


-- Triggers for account_auth_log

CREATE OR REPLACE FUNCTION jazzhands_legacy.account_auth_log_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.account_auth_log (
		account_id,account_auth_ts,auth_resource,account_auth_seq,was_auth_success,auth_resource_instance,auth_origin
	) VALUES (
		NEW.account_id,NEW.account_auth_ts,NEW.auth_resource,NEW.account_auth_seq,CASE WHEN NEW.was_auth_success = 'Y' THEN true WHEN NEW.was_auth_success = 'N' THEN false ELSE NULL END,NEW.auth_resource_instance,NEW.auth_origin
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_account_auth_log_ins
	ON jazzhands_legacy.account_auth_log;
CREATE TRIGGER _trigger_account_auth_log_ins
	INSTEAD OF INSERT ON jazzhands_legacy.account_auth_log
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.account_auth_log_ins();


-- Triggers for approval_instance_item

CREATE OR REPLACE FUNCTION jazzhands_legacy.approval_instance_item_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.approval_instance_item (
		approval_instance_item_id,approval_instance_link_id,approval_instance_step_id,next_approval_instance_item_id,approved_category,approved_label,approved_lhs,approved_rhs,is_approved,approved_account_id,approval_note
	) VALUES (
		NEW.approval_instance_item_id,NEW.approval_instance_link_id,NEW.approval_instance_step_id,NEW.next_approval_instance_item_id,NEW.approved_category,NEW.approved_label,NEW.approved_lhs,NEW.approved_rhs,CASE WHEN NEW.is_approved = 'Y' THEN true WHEN NEW.is_approved = 'N' THEN false ELSE NULL END,NEW.approved_account_id,NEW.approval_note
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_approval_instance_item_ins
	ON jazzhands_legacy.approval_instance_item;
CREATE TRIGGER _trigger_approval_instance_item_ins
	INSTEAD OF INSERT ON jazzhands_legacy.approval_instance_item
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.approval_instance_item_ins();


-- Triggers for approval_instance_step

CREATE OR REPLACE FUNCTION jazzhands_legacy.approval_instance_step_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.approval_instance_step (
		approval_instance_step_id,approval_instance_id,approval_process_chain_id,approval_instance_step_name,approval_instance_step_due,approval_type,description,approval_instance_step_start,approval_instance_step_end,approver_account_id,external_reference_name,is_completed
	) VALUES (
		NEW.approval_instance_step_id,NEW.approval_instance_id,NEW.approval_process_chain_id,NEW.approval_instance_step_name,NEW.approval_instance_step_due,NEW.approval_type,NEW.description,NEW.approval_instance_step_start,NEW.approval_instance_step_end,NEW.approver_account_id,NEW.external_reference_name,CASE WHEN NEW.is_completed = 'Y' THEN true WHEN NEW.is_completed = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_approval_instance_step_ins
	ON jazzhands_legacy.approval_instance_step;
CREATE TRIGGER _trigger_approval_instance_step_ins
	INSTEAD OF INSERT ON jazzhands_legacy.approval_instance_step
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.approval_instance_step_ins();


-- Triggers for approval_process_chain

CREATE OR REPLACE FUNCTION jazzhands_legacy.approval_process_chain_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.approval_process_chain (
		approval_process_chain_id,approval_process_chain_name,approval_chain_response_period,description,message,email_message,email_subject_prefix,email_subject_suffix,max_escalation_level,escalation_delay,escalation_reminder_gap,approving_entity,refresh_all_data,accept_app_process_chain_id,reject_app_process_chain_id
	) VALUES (
		NEW.approval_process_chain_id,NEW.approval_process_chain_name,NEW.approval_chain_response_period,NEW.description,NEW.message,NEW.email_message,NEW.email_subject_prefix,NEW.email_subject_suffix,NEW.max_escalation_level,NEW.escalation_delay,NEW.escalation_reminder_gap,NEW.approving_entity,CASE WHEN NEW.refresh_all_data = 'Y' THEN true WHEN NEW.refresh_all_data = 'N' THEN false ELSE NULL END,NEW.accept_app_process_chain_id,NEW.reject_app_process_chain_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_approval_process_chain_ins
	ON jazzhands_legacy.approval_process_chain;
CREATE TRIGGER _trigger_approval_process_chain_ins
	INSTEAD OF INSERT ON jazzhands_legacy.approval_process_chain
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.approval_process_chain_ins();


-- Triggers for circuit

CREATE OR REPLACE FUNCTION jazzhands_legacy.circuit_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.circuit (
		circuit_id,vendor_company_id,vendor_circuit_id_str,aloc_lec_company_id,aloc_lec_circuit_id_str,aloc_parent_circuit_id,zloc_lec_company_id,zloc_lec_circuit_id_str,zloc_parent_circuit_id,is_locally_managed
	) VALUES (
		NEW.circuit_id,NEW.vendor_company_id,NEW.vendor_circuit_id_str,NEW.aloc_lec_company_id,NEW.aloc_lec_circuit_id_str,NEW.aloc_parent_circuit_id,NEW.zloc_lec_company_id,NEW.zloc_lec_circuit_id_str,NEW.zloc_parent_circuit_id,CASE WHEN NEW.is_locally_managed = 'Y' THEN true WHEN NEW.is_locally_managed = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_circuit_ins
	ON jazzhands_legacy.circuit;
CREATE TRIGGER _trigger_circuit_ins
	INSTEAD OF INSERT ON jazzhands_legacy.circuit
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.circuit_ins();


-- Triggers for component_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.component_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.component_type (
		component_type_id,company_id,model,slot_type_id,description,part_number,is_removable,asset_permitted,is_rack_mountable,is_virtual_component,size_units
	) VALUES (
		NEW.component_type_id,NEW.company_id,NEW.model,NEW.slot_type_id,NEW.description,NEW.part_number,CASE WHEN NEW.is_removable = 'Y' THEN true WHEN NEW.is_removable = 'N' THEN false ELSE NULL END,CASE WHEN NEW.asset_permitted = 'Y' THEN true WHEN NEW.asset_permitted = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_rack_mountable = 'Y' THEN true WHEN NEW.is_rack_mountable = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_virtual_component = 'Y' THEN true WHEN NEW.is_virtual_component = 'N' THEN false ELSE NULL END,NEW.size_units
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_component_type_ins
	ON jazzhands_legacy.component_type;
CREATE TRIGGER _trigger_component_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.component_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.component_type_ins();


-- Triggers for department

CREATE OR REPLACE FUNCTION jazzhands_legacy.department_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.department (
		account_collection_id,company_id,manager_account_id,is_active,dept_code,cost_center_name,cost_center_number,default_badge_type_id
	) VALUES (
		NEW.account_collection_id,NEW.company_id,NEW.manager_account_id,CASE WHEN NEW.is_active = 'Y' THEN true WHEN NEW.is_active = 'N' THEN false ELSE NULL END,NEW.dept_code,NEW.cost_center_name,NEW.cost_center_number,NEW.default_badge_type_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_department_ins
	ON jazzhands_legacy.department;
CREATE TRIGGER _trigger_department_ins
	INSTEAD OF INSERT ON jazzhands_legacy.department
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.department_ins();


-- Triggers for device

CREATE OR REPLACE FUNCTION jazzhands_legacy.device_ins()
RETURNS TRIGGER AS
$$
BEGIN
	-- XXX dropped columns: auto_mgmt_protocolis_monitoredshould_fetch_config
	INSERT INTO jazzhands.device (
		device_id,component_id,device_type_id,device_name,site_code,identifying_dns_record_id,host_id,physical_label,rack_location_id,chassis_location_id,parent_device_id,description,external_id,device_status,operating_system_id,service_environment_id,is_locally_managed,is_virtual_device,date_in_service
	) VALUES (
		NEW.device_id,NEW.component_id,NEW.device_type_id,NEW.device_name,NEW.site_code,NEW.identifying_dns_record_id,NEW.host_id,NEW.physical_label,NEW.rack_location_id,NEW.chassis_location_id,NEW.parent_device_id,NEW.description,NEW.external_id,NEW.device_status,NEW.operating_system_id,NEW.service_environment_id,CASE WHEN NEW.is_locally_managed = 'Y' THEN true WHEN NEW.is_locally_managed = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_virtual_device = 'Y' THEN true WHEN NEW.is_virtual_device = 'N' THEN false ELSE NULL END,NEW.date_in_service
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_device_ins
	ON jazzhands_legacy.device;
CREATE TRIGGER _trigger_device_ins
	INSTEAD OF INSERT ON jazzhands_legacy.device
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.device_ins();


-- Triggers for device_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.device_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.device_type (
		device_type_id,component_type_id,device_type_name,template_device_id,idealized_device_id,description,company_id,model,device_type_depth_in_cm,processor_architecture,config_fetch_type,rack_units,has_802_3_interface,has_802_11_interface,snmp_capable,is_chassis
	) VALUES (
		NEW.device_type_id,NEW.component_type_id,NEW.device_type_name,NEW.template_device_id,NEW.idealized_device_id,NEW.description,NEW.company_id,NEW.model,NEW.device_type_depth_in_cm,NEW.processor_architecture,NEW.config_fetch_type,NEW.rack_units,CASE WHEN NEW.has_802_3_interface = 'Y' THEN true WHEN NEW.has_802_3_interface = 'N' THEN false ELSE NULL END,CASE WHEN NEW.has_802_11_interface = 'Y' THEN true WHEN NEW.has_802_11_interface = 'N' THEN false ELSE NULL END,CASE WHEN NEW.snmp_capable = 'Y' THEN true WHEN NEW.snmp_capable = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_chassis = 'Y' THEN true WHEN NEW.is_chassis = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_device_type_ins
	ON jazzhands_legacy.device_type;
CREATE TRIGGER _trigger_device_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.device_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.device_type_ins();


-- Triggers for dns_domain_ip_universe

CREATE OR REPLACE FUNCTION jazzhands_legacy.dns_domain_ip_universe_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.dns_domain_ip_universe (
		dns_domain_id,ip_universe_id,soa_class,soa_ttl,soa_serial,soa_refresh,soa_retry,soa_expire,soa_minimum,soa_mname,soa_rname,should_generate,last_generated
	) VALUES (
		NEW.dns_domain_id,NEW.ip_universe_id,NEW.soa_class,NEW.soa_ttl,NEW.soa_serial,NEW.soa_refresh,NEW.soa_retry,NEW.soa_expire,NEW.soa_minimum,NEW.soa_mname,NEW.soa_rname,CASE WHEN NEW.should_generate = 'Y' THEN true WHEN NEW.should_generate = 'N' THEN false ELSE NULL END,NEW.last_generated
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_dns_domain_ip_universe_ins
	ON jazzhands_legacy.dns_domain_ip_universe;
CREATE TRIGGER _trigger_dns_domain_ip_universe_ins
	INSTEAD OF INSERT ON jazzhands_legacy.dns_domain_ip_universe
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.dns_domain_ip_universe_ins();


-- Triggers for dns_record

CREATE OR REPLACE FUNCTION jazzhands_legacy.dns_record_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.dns_record (
		dns_record_id,dns_name,dns_domain_id,dns_ttl,dns_class,dns_type,dns_value,dns_priority,dns_srv_service,dns_srv_protocol,dns_srv_weight,dns_srv_port,netblock_id,ip_universe_id,reference_dns_record_id,dns_value_record_id,should_generate_ptr,is_enabled
	) VALUES (
		NEW.dns_record_id,NEW.dns_name,NEW.dns_domain_id,NEW.dns_ttl,NEW.dns_class,NEW.dns_type,NEW.dns_value,NEW.dns_priority,NEW.dns_srv_service,NEW.dns_srv_protocol,NEW.dns_srv_weight,NEW.dns_srv_port,NEW.netblock_id,NEW.ip_universe_id,NEW.reference_dns_record_id,NEW.dns_value_record_id,CASE WHEN NEW.should_generate_ptr = 'Y' THEN true WHEN NEW.should_generate_ptr = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_dns_record_ins
	ON jazzhands_legacy.dns_record;
CREATE TRIGGER _trigger_dns_record_ins
	INSTEAD OF INSERT ON jazzhands_legacy.dns_record
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.dns_record_ins();


-- Triggers for ip_universe

CREATE OR REPLACE FUNCTION jazzhands_legacy.ip_universe_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.ip_universe (
		ip_universe_id,ip_universe_name,ip_namespace,should_generate_dns,description
	) VALUES (
		NEW.ip_universe_id,NEW.ip_universe_name,NEW.ip_namespace,CASE WHEN NEW.should_generate_dns = 'Y' THEN true WHEN NEW.should_generate_dns = 'N' THEN false ELSE NULL END,NEW.description
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_ip_universe_ins
	ON jazzhands_legacy.ip_universe;
CREATE TRIGGER _trigger_ip_universe_ins
	INSTEAD OF INSERT ON jazzhands_legacy.ip_universe
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.ip_universe_ins();


-- Triggers for ip_universe_visibility

CREATE OR REPLACE FUNCTION jazzhands_legacy.ip_universe_visibility_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.ip_universe_visibility (
		ip_universe_id,visible_ip_universe_id,propagate_dns
	) VALUES (
		NEW.ip_universe_id,NEW.visible_ip_universe_id,CASE WHEN NEW.propagate_dns = 'Y' THEN true WHEN NEW.propagate_dns = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_ip_universe_visibility_ins
	ON jazzhands_legacy.ip_universe_visibility;
CREATE TRIGGER _trigger_ip_universe_visibility_ins
	INSTEAD OF INSERT ON jazzhands_legacy.ip_universe_visibility
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.ip_universe_visibility_ins();


-- Triggers for netblock

CREATE OR REPLACE FUNCTION jazzhands_legacy.netblock_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.netblock (
		netblock_id,ip_address,netblock_type,is_single_address,can_subnet,parent_netblock_id,netblock_status,ip_universe_id,description,external_id
	) VALUES (
		NEW.netblock_id,NEW.ip_address,NEW.netblock_type,CASE WHEN NEW.is_single_address = 'Y' THEN true WHEN NEW.is_single_address = 'N' THEN false ELSE NULL END,CASE WHEN NEW.can_subnet = 'Y' THEN true WHEN NEW.can_subnet = 'N' THEN false ELSE NULL END,NEW.parent_netblock_id,NEW.netblock_status,NEW.ip_universe_id,NEW.description,NEW.external_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_netblock_ins
	ON jazzhands_legacy.netblock;
CREATE TRIGGER _trigger_netblock_ins
	INSTEAD OF INSERT ON jazzhands_legacy.netblock
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.netblock_ins();


-- Triggers for network_interface

CREATE OR REPLACE FUNCTION jazzhands_legacy.network_interface_ins()
RETURNS TRIGGER AS
$$
BEGIN
	-- XXX dropped columns: physical_port_id
	INSERT INTO jazzhands.layer3_interface (
		layer3_interface_id,device_id,layer3_interface_name,description,parent_layer3_interface_id,parent_relation_type,slot_id,logical_port_id,layer3_interface_type,is_interface_up,mac_addr,should_monitor,should_manage
	) VALUES (
		NEW.network_interface_id,NEW.device_id,NEW.network_interface_name,NEW.description,NEW.parent_network_interface_id,NEW.parent_relation_type,NEW.slot_id,NEW.logical_port_id,NEW.network_interface_type,CASE WHEN NEW.is_interface_up = 'Y' THEN true WHEN NEW.is_interface_up = 'N' THEN false ELSE NULL END,NEW.mac_addr,CASE WHEN NEW.should_monitor = 'Y' THEN true WHEN NEW.should_monitor = 'N' THEN false ELSE NULL END,CASE WHEN NEW.should_manage = 'Y' THEN true WHEN NEW.should_manage = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_network_interface_ins
	ON jazzhands_legacy.network_interface;
CREATE TRIGGER _trigger_network_interface_ins
	INSTEAD OF INSERT ON jazzhands_legacy.network_interface
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.network_interface_ins();


-- Triggers for network_service

CREATE OR REPLACE FUNCTION jazzhands_legacy.network_service_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.network_service (
		network_service_id,name,description,network_service_type,is_monitored,device_id,network_interface_id,dns_record_id,service_environment_id
	) VALUES (
		NEW.network_service_id,NEW.name,NEW.description,NEW.network_service_type,CASE WHEN NEW.is_monitored = 'Y' THEN true WHEN NEW.is_monitored = 'N' THEN false ELSE NULL END,NEW.device_id,NEW.network_interface_id,NEW.dns_record_id,NEW.service_environment_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_network_service_ins
	ON jazzhands_legacy.network_service;
CREATE TRIGGER _trigger_network_service_ins
	INSTEAD OF INSERT ON jazzhands_legacy.network_service
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.network_service_ins();


-- Triggers for person_auth_question

CREATE OR REPLACE FUNCTION jazzhands_legacy.person_auth_question_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.person_auth_question (
		auth_question_id,person_id,user_answer,is_active
	) VALUES (
		NEW.auth_question_id,NEW.person_id,NEW.user_answer,CASE WHEN NEW.is_active = 'Y' THEN true WHEN NEW.is_active = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_person_auth_question_ins
	ON jazzhands_legacy.person_auth_question;
CREATE TRIGGER _trigger_person_auth_question_ins
	INSTEAD OF INSERT ON jazzhands_legacy.person_auth_question
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.person_auth_question_ins();


-- Triggers for person_company

CREATE OR REPLACE FUNCTION jazzhands_legacy.person_company_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.person_company (
		company_id,person_id,person_company_status,person_company_relation,is_exempt,is_management,is_full_time,description,position_title,hire_date,termination_date,manager_person_id,nickname
	) VALUES (
		NEW.company_id,NEW.person_id,NEW.person_company_status,NEW.person_company_relation,CASE WHEN NEW.is_exempt = 'Y' THEN true WHEN NEW.is_exempt = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_management = 'Y' THEN true WHEN NEW.is_management = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_full_time = 'Y' THEN true WHEN NEW.is_full_time = 'N' THEN false ELSE NULL END,NEW.description,NEW.position_title,NEW.hire_date,NEW.termination_date,NEW.manager_person_id,NEW.nickname
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_person_company_ins
	ON jazzhands_legacy.person_company;
CREATE TRIGGER _trigger_person_company_ins
	INSTEAD OF INSERT ON jazzhands_legacy.person_company
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.person_company_ins();


-- Triggers for private_key

CREATE OR REPLACE FUNCTION jazzhands_legacy.private_key_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.private_key (
		private_key_id,private_key_encryption_type,is_active,subject_key_identifier,private_key,passphrase,encryption_key_id
	) VALUES (
		NEW.private_key_id,NEW.private_key_encryption_type,CASE WHEN NEW.is_active = 'Y' THEN true WHEN NEW.is_active = 'N' THEN false ELSE NULL END,NEW.subject_key_identifier,NEW.private_key,NEW.passphrase,NEW.encryption_key_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_private_key_ins
	ON jazzhands_legacy.private_key;
CREATE TRIGGER _trigger_private_key_ins
	INSTEAD OF INSERT ON jazzhands_legacy.private_key
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.private_key_ins();


-- Triggers for property

CREATE OR REPLACE FUNCTION jazzhands_legacy.property_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.property (
		property_id,account_collection_id,account_id,account_realm_id,company_collection_id,company_id,device_collection_id,dns_domain_collection_id,layer2_network_collection_id,layer3_network_collection_id,netblock_collection_id,network_range_id,operating_system_id,operating_system_snapshot_id,person_id,property_name_collection_id,service_environment_collection_id,site_code,x509_signed_certificate_id,property_name,property_type,property_value,property_value_timestamp,property_value_account_collection_id,property_value_device_collection_id,property_value_json,property_value_netblock_collection_id,property_value_password_type,property_value_person_id,property_value_sw_package_id,property_value_token_collection_id,property_rank,start_date,finish_date,is_enabled
	) VALUES (
		NEW.property_id,NEW.account_collection_id,NEW.account_id,NEW.account_realm_id,NEW.company_collection_id,NEW.company_id,NEW.device_collection_id,NEW.dns_domain_collection_id,NEW.layer2_network_collection_id,NEW.layer3_network_collection_id,NEW.netblock_collection_id,NEW.network_range_id,NEW.operating_system_id,NEW.operating_system_snapshot_id,NEW.person_id,NEW.property_collection_id,NEW.service_env_collection_id,NEW.site_code,NEW.x509_signed_certificate_id,NEW.property_name,NEW.property_type,NEW.property_value,NEW.property_value_timestamp,NEW.property_value_account_coll_id,NEW.property_value_device_coll_id,NEW.property_value_json,NEW.property_value_nblk_coll_id,NEW.property_value_password_type,NEW.property_value_person_id,NEW.property_value_sw_package_id,NEW.property_value_token_col_id,NEW.property_rank,NEW.start_date,NEW.finish_date,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_property_ins
	ON jazzhands_legacy.property;
CREATE TRIGGER _trigger_property_ins
	INSTEAD OF INSERT ON jazzhands_legacy.property
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.property_ins();


-- Triggers for rack

CREATE OR REPLACE FUNCTION jazzhands_legacy.rack_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.rack (
		rack_id,site_code,room,sub_room,rack_row,rack_name,rack_style,rack_type,description,rack_height_in_u,display_from_bottom
	) VALUES (
		NEW.rack_id,NEW.site_code,NEW.room,NEW.sub_room,NEW.rack_row,NEW.rack_name,NEW.rack_style,NEW.rack_type,NEW.description,NEW.rack_height_in_u,CASE WHEN NEW.display_from_bottom = 'Y' THEN true WHEN NEW.display_from_bottom = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_rack_ins
	ON jazzhands_legacy.rack;
CREATE TRIGGER _trigger_rack_ins
	INSTEAD OF INSERT ON jazzhands_legacy.rack
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.rack_ins();


-- Triggers for slot

CREATE OR REPLACE FUNCTION jazzhands_legacy.slot_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.slot (
		slot_id,component_id,slot_name,slot_index,slot_type_id,component_type_slot_template_id,is_enabled,physical_label,mac_address,description,slot_x_offset,slot_y_offset,slot_z_offset,slot_side
	) VALUES (
		NEW.slot_id,NEW.component_id,NEW.slot_name,NEW.slot_index,NEW.slot_type_id,NEW.component_type_slot_tmplt_id,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END,NEW.physical_label,NEW.mac_address,NEW.description,NEW.slot_x_offset,NEW.slot_y_offset,NEW.slot_z_offset,NEW.slot_side
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_slot_ins
	ON jazzhands_legacy.slot;
CREATE TRIGGER _trigger_slot_ins
	INSTEAD OF INSERT ON jazzhands_legacy.slot
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.slot_ins();


-- Triggers for slot_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.slot_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.slot_type (
		slot_type_id,slot_type,slot_function,slot_physical_interface_type,description,remote_slot_permitted
	) VALUES (
		NEW.slot_type_id,NEW.slot_type,NEW.slot_function,NEW.slot_physical_interface_type,NEW.description,CASE WHEN NEW.remote_slot_permitted = 'Y' THEN true WHEN NEW.remote_slot_permitted = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_slot_type_ins
	ON jazzhands_legacy.slot_type;
CREATE TRIGGER _trigger_slot_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.slot_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.slot_type_ins();


-- Triggers for sudo_acct_col_device_collectio

CREATE OR REPLACE FUNCTION jazzhands_legacy.sudo_acct_col_device_collectio_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.sudo_account_collection_device_collection (
		sudo_alias_name,device_collection_id,account_collection_id,run_as_account_collection_id,requires_password,can_exec_child
	) VALUES (
		NEW.sudo_alias_name,NEW.device_collection_id,NEW.account_collection_id,NEW.run_as_account_collection_id,CASE WHEN NEW.requires_password = 'Y' THEN true WHEN NEW.requires_password = 'N' THEN false ELSE NULL END,CASE WHEN NEW.can_exec_child = 'Y' THEN true WHEN NEW.can_exec_child = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_sudo_acct_col_device_collectio_ins
	ON jazzhands_legacy.sudo_acct_col_device_collectio;
CREATE TRIGGER _trigger_sudo_acct_col_device_collectio_ins
	INSTEAD OF INSERT ON jazzhands_legacy.sudo_acct_col_device_collectio
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.sudo_acct_col_device_collectio_ins();


-- Triggers for token

CREATE OR REPLACE FUNCTION jazzhands_legacy.token_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.token (
		token_id,token_type,token_status,description,external_id,token_serial,zero_time,time_modulo,time_skew,token_key,encryption_key_id,token_password,expire_time,is_token_locked,token_unlock_time,bad_logins,last_updated
	) VALUES (
		NEW.token_id,NEW.token_type,NEW.token_status,NEW.description,NEW.external_id,NEW.token_serial,NEW.zero_time,NEW.time_modulo,NEW.time_skew,NEW.token_key,NEW.encryption_key_id,NEW.token_password,NEW.expire_time,CASE WHEN NEW.is_token_locked = 'Y' THEN true WHEN NEW.is_token_locked = 'N' THEN false ELSE NULL END,NEW.token_unlock_time,NEW.bad_logins,NEW.last_updated
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_token_ins
	ON jazzhands_legacy.token;
CREATE TRIGGER _trigger_token_ins
	INSTEAD OF INSERT ON jazzhands_legacy.token
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.token_ins();


-- Triggers for v_approval_instance_step_expanded

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_approval_instance_step_expanded_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_approval_instance_step_expanded (
		first_approval_instance_item_id,root_step_id,approval_instance_item_id,approval_instance_step_id,tier,level,is_approved
	) VALUES (
		NEW.first_approval_instance_item_id,NEW.root_step_id,NEW.approval_instance_item_id,NEW.approval_instance_step_id,NEW.tier,NEW.level,CASE WHEN NEW.is_approved = 'Y' THEN true WHEN NEW.is_approved = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_approval_instance_step_expanded_ins
	ON jazzhands_legacy.v_approval_instance_step_expanded;
CREATE TRIGGER _trigger_v_approval_instance_step_expanded_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_approval_instance_step_expanded
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_approval_instance_step_expanded_ins();


-- Triggers for v_corp_family_account

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_corp_family_account_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_corp_family_account (
		account_id,login,person_id,company_id,account_realm_id,account_status,account_role,account_type,description,is_enabled
	) VALUES (
		NEW.account_id,NEW.login,NEW.person_id,NEW.company_id,NEW.account_realm_id,NEW.account_status,NEW.account_role,NEW.account_type,NEW.description,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_corp_family_account_ins
	ON jazzhands_legacy.v_corp_family_account;
CREATE TRIGGER _trigger_v_corp_family_account_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_corp_family_account
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_corp_family_account_ins();


-- Triggers for v_dev_col_user_prop_expanded

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_dev_col_user_prop_expanded_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_device_collection_account_property_expanded (
		property_id,device_collection_id,account_id,login,account_status,account_realm_id,account_realm_name,is_enabled,property_type,property_name,property_rank,property_value,is_multivalue,is_boolean
	) VALUES (
		NEW.property_id,NEW.device_collection_id,NEW.account_id,NEW.login,NEW.account_status,NEW.account_realm_id,NEW.account_realm_name,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END,NEW.property_type,NEW.property_name,NEW.property_rank,NEW.property_value,NEW.is_multivalue,NEW.is_boolean
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_dev_col_user_prop_expanded_ins
	ON jazzhands_legacy.v_dev_col_user_prop_expanded;
CREATE TRIGGER _trigger_v_dev_col_user_prop_expanded_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_dev_col_user_prop_expanded
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_dev_col_user_prop_expanded_ins();


-- Triggers for v_dns

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_dns_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_dns (
		dns_record_id,network_range_id,dns_domain_id,dns_name,dns_ttl,dns_class,dns_type,dns_value,dns_priority,ip,netblock_id,ip_universe_id,ref_record_id,dns_srv_service,dns_srv_protocol,dns_srv_weight,dns_srv_port,is_enabled,should_generate_ptr,dns_value_record_id
	) VALUES (
		NEW.dns_record_id,NEW.network_range_id,NEW.dns_domain_id,NEW.dns_name,NEW.dns_ttl,NEW.dns_class,NEW.dns_type,NEW.dns_value,NEW.dns_priority,NEW.ip,NEW.netblock_id,NEW.ip_universe_id,NEW.ref_record_id,NEW.dns_srv_service,NEW.dns_srv_protocol,NEW.dns_srv_weight,NEW.dns_srv_port,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END,CASE WHEN NEW.should_generate_ptr = 'Y' THEN true WHEN NEW.should_generate_ptr = 'N' THEN false ELSE NULL END,NEW.dns_value_record_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_dns_ins
	ON jazzhands_legacy.v_dns;
CREATE TRIGGER _trigger_v_dns_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_dns
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_dns_ins();


-- Triggers for v_dns_changes_pending

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_dns_changes_pending_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_dns_changes_pending (
		dns_change_record_id,dns_domain_id,ip_universe_id,should_generate,last_generated,soa_name,ip_address
	) VALUES (
		NEW.dns_change_record_id,NEW.dns_domain_id,NEW.ip_universe_id,CASE WHEN NEW.should_generate = 'Y' THEN true WHEN NEW.should_generate = 'N' THEN false ELSE NULL END,NEW.last_generated,NEW.soa_name,NEW.ip_address
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_dns_changes_pending_ins
	ON jazzhands_legacy.v_dns_changes_pending;
CREATE TRIGGER _trigger_v_dns_changes_pending_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_dns_changes_pending
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_dns_changes_pending_ins();


-- Triggers for v_dns_domain_nouniverse

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_dns_domain_nouniverse_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_dns_domain_nouniverse (
		dns_domain_id,soa_name,soa_class,soa_ttl,soa_serial,soa_refresh,soa_retry,soa_expire,soa_minimum,soa_mname,soa_rname,parent_dns_domain_id,should_generate,last_generated,dns_domain_type
	) VALUES (
		NEW.dns_domain_id,NEW.soa_name,NEW.soa_class,NEW.soa_ttl,NEW.soa_serial,NEW.soa_refresh,NEW.soa_retry,NEW.soa_expire,NEW.soa_minimum,NEW.soa_mname,NEW.soa_rname,NEW.parent_dns_domain_id,CASE WHEN NEW.should_generate = 'Y' THEN true WHEN NEW.should_generate = 'N' THEN false ELSE NULL END,NEW.last_generated,NEW.dns_domain_type
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_dns_domain_nouniverse_ins
	ON jazzhands_legacy.v_dns_domain_nouniverse;
CREATE TRIGGER _trigger_v_dns_domain_nouniverse_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_dns_domain_nouniverse
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_dns_domain_nouniverse_ins();


-- Triggers for v_dns_fwd

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_dns_fwd_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_dns_fwd (
		dns_record_id,network_range_id,dns_domain_id,dns_name,dns_ttl,dns_class,dns_type,dns_value,dns_priority,ip,netblock_id,ip_universe_id,ref_record_id,dns_srv_service,dns_srv_protocol,dns_srv_weight,dns_srv_port,is_enabled,should_generate_ptr,dns_value_record_id
	) VALUES (
		NEW.dns_record_id,NEW.network_range_id,NEW.dns_domain_id,NEW.dns_name,NEW.dns_ttl,NEW.dns_class,NEW.dns_type,NEW.dns_value,NEW.dns_priority,NEW.ip,NEW.netblock_id,NEW.ip_universe_id,NEW.ref_record_id,NEW.dns_srv_service,NEW.dns_srv_protocol,NEW.dns_srv_weight,NEW.dns_srv_port,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END,CASE WHEN NEW.should_generate_ptr = 'Y' THEN true WHEN NEW.should_generate_ptr = 'N' THEN false ELSE NULL END,NEW.dns_value_record_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_dns_fwd_ins
	ON jazzhands_legacy.v_dns_fwd;
CREATE TRIGGER _trigger_v_dns_fwd_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_dns_fwd
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_dns_fwd_ins();


-- Triggers for v_dns_rvs

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_dns_rvs_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_dns_rvs (
		dns_record_id,network_range_id,dns_domain_id,dns_name,dns_ttl,dns_class,dns_type,dns_value,dns_priority,ip,netblock_id,ip_universe_id,rdns_record_id,dns_srv_service,dns_srv_protocol,dns_srv_weight,dns_srv_srv_port,is_enabled,should_generate_ptr,dns_value_record_id
	) VALUES (
		NEW.dns_record_id,NEW.network_range_id,NEW.dns_domain_id,NEW.dns_name,NEW.dns_ttl,NEW.dns_class,NEW.dns_type,NEW.dns_value,NEW.dns_priority,NEW.ip,NEW.netblock_id,NEW.ip_universe_id,NEW.rdns_record_id,NEW.dns_srv_service,NEW.dns_srv_protocol,NEW.dns_srv_weight,NEW.dns_srv_srv_port,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END,CASE WHEN NEW.should_generate_ptr = 'Y' THEN true WHEN NEW.should_generate_ptr = 'N' THEN false ELSE NULL END,NEW.dns_value_record_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_dns_rvs_ins
	ON jazzhands_legacy.v_dns_rvs;
CREATE TRIGGER _trigger_v_dns_rvs_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_dns_rvs
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_dns_rvs_ins();


-- Triggers for v_dns_sorted

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_dns_sorted_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_dns_sorted (
		dns_record_id,network_range_id,dns_value_record_id,dns_name,dns_ttl,dns_class,dns_type,dns_value,dns_priority,ip,netblock_id,ref_record_id,dns_srv_service,dns_srv_protocol,dns_srv_weight,dns_srv_port,should_generate_ptr,is_enabled,dns_domain_id,anchor_record_id,anchor_rank
	) VALUES (
		NEW.dns_record_id,NEW.network_range_id,NEW.dns_value_record_id,NEW.dns_name,NEW.dns_ttl,NEW.dns_class,NEW.dns_type,NEW.dns_value,NEW.dns_priority,NEW.ip,NEW.netblock_id,NEW.ref_record_id,NEW.dns_srv_service,NEW.dns_srv_protocol,NEW.dns_srv_weight,NEW.dns_srv_port,CASE WHEN NEW.should_generate_ptr = 'Y' THEN true WHEN NEW.should_generate_ptr = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END,NEW.dns_domain_id,NEW.anchor_record_id,NEW.anchor_rank
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_dns_sorted_ins
	ON jazzhands_legacy.v_dns_sorted;
CREATE TRIGGER _trigger_v_dns_sorted_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_dns_sorted
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_dns_sorted_ins();


-- Triggers for v_hotpants_token

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_hotpants_token_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_hotpants_token (
		token_id,token_type,token_status,token_serial,token_key,zero_time,time_modulo,token_password,is_token_locked,token_unlock_time,bad_logins,token_sequence,last_updated,encryption_key_db_value,encryption_key_purpose,encryption_key_purpose_version,encryption_method
	) VALUES (
		NEW.token_id,NEW.token_type,NEW.token_status,NEW.token_serial,NEW.token_key,NEW.zero_time,NEW.time_modulo,NEW.token_password,CASE WHEN NEW.is_token_locked = 'Y' THEN true WHEN NEW.is_token_locked = 'N' THEN false ELSE NULL END,NEW.token_unlock_time,NEW.bad_logins,NEW.token_sequence,NEW.last_updated,NEW.encryption_key_db_value,NEW.encryption_key_purpose,NEW.encryption_key_purpose_version,NEW.encryption_method
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_hotpants_token_ins
	ON jazzhands_legacy.v_hotpants_token;
CREATE TRIGGER _trigger_v_hotpants_token_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_hotpants_token
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_hotpants_token_ins();


-- Triggers for v_netblock_hier

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_netblock_hier_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_netblock_hier (
		netblock_level,root_netblock_id,ip,netblock_id,ip_address,netblock_status,is_single_address,description,parent_netblock_id,site_code,text_path,array_path,array_ip_path
	) VALUES (
		NEW.netblock_level,NEW.root_netblock_id,NEW.ip,NEW.netblock_id,NEW.ip_address,NEW.netblock_status,CASE WHEN NEW.is_single_address = 'Y' THEN true WHEN NEW.is_single_address = 'N' THEN false ELSE NULL END,NEW.description,NEW.parent_netblock_id,NEW.site_code,NEW.text_path,NEW.array_path,NEW.array_ip_path
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_netblock_hier_ins
	ON jazzhands_legacy.v_netblock_hier;
CREATE TRIGGER _trigger_v_netblock_hier_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_netblock_hier
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_netblock_hier_ins();


-- Triggers for v_netblock_hier_expanded

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_netblock_hier_expanded_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_netblock_hier_expanded (
		netblock_level,root_netblock_id,site_code,path,netblock_id,ip_address,netblock_type,is_single_address,can_subnet,parent_netblock_id,netblock_status,ip_universe_id,description,external_id
	) VALUES (
		NEW.netblock_level,NEW.root_netblock_id,NEW.site_code,NEW.path,NEW.netblock_id,NEW.ip_address,NEW.netblock_type,CASE WHEN NEW.is_single_address = 'Y' THEN true WHEN NEW.is_single_address = 'N' THEN false ELSE NULL END,CASE WHEN NEW.can_subnet = 'Y' THEN true WHEN NEW.can_subnet = 'N' THEN false ELSE NULL END,NEW.parent_netblock_id,NEW.netblock_status,NEW.ip_universe_id,NEW.description,NEW.external_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_netblock_hier_expanded_ins
	ON jazzhands_legacy.v_netblock_hier_expanded;
CREATE TRIGGER _trigger_v_netblock_hier_expanded_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_netblock_hier_expanded
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_netblock_hier_expanded_ins();


-- Triggers for v_person_company

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_person_company_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_person_company (
		company_id,person_id,person_company_status,person_company_relation,is_exempt,is_management,is_full_time,description,employee_id,payroll_id,external_hr_id,position_title,badge_system_id,hire_date,termination_date,manager_person_id,supervisor_person_id,nickname
	) VALUES (
		NEW.company_id,NEW.person_id,NEW.person_company_status,NEW.person_company_relation,CASE WHEN NEW.is_exempt = 'Y' THEN true WHEN NEW.is_exempt = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_management = 'Y' THEN true WHEN NEW.is_management = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_full_time = 'Y' THEN true WHEN NEW.is_full_time = 'N' THEN false ELSE NULL END,NEW.description,NEW.employee_id,NEW.payroll_id,NEW.external_hr_id,NEW.position_title,NEW.badge_system_id,NEW.hire_date,NEW.termination_date,NEW.manager_person_id,NEW.supervisor_person_id,NEW.nickname
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_person_company_ins
	ON jazzhands_legacy.v_person_company;
CREATE TRIGGER _trigger_v_person_company_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_person_company
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_person_company_ins();


-- Triggers for v_property

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_property_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_property (
		property_id,account_collection_id,account_id,account_realm_id,company_collection_id,company_id,device_collection_id,dns_domain_collection_id,layer2_network_collection_id,layer3_network_collection_id,netblock_collection_id,network_range_id,operating_system_id,operating_system_snapshot_id,person_id,property_name_collection_id,service_environment_collection_id,site_code,x509_signed_certificate_id,property_name,property_type,property_value,property_value_timestamp,property_value_account_collection_id,property_value_device_collection_id,property_value_json,property_value_netblock_collection_id,property_value_password_type,property_value_person_id,property_value_sw_package_id,property_value_token_collection_id,property_rank,start_date,finish_date,is_enabled
	) VALUES (
		NEW.property_id,NEW.account_collection_id,NEW.account_id,NEW.account_realm_id,NEW.company_collection_id,NEW.company_id,NEW.device_collection_id,NEW.dns_domain_collection_id,NEW.layer2_network_collection_id,NEW.layer3_network_collection_id,NEW.netblock_collection_id,NEW.network_range_id,NEW.operating_system_id,NEW.operating_system_snapshot_id,NEW.person_id,NEW.property_collection_id,NEW.service_env_collection_id,NEW.site_code,NEW.x509_signed_certificate_id,NEW.property_name,NEW.property_type,NEW.property_value,NEW.property_value_timestamp,NEW.property_value_account_coll_id,NEW.property_value_device_coll_id,NEW.property_value_json,NEW.property_value_nblk_coll_id,NEW.property_value_password_type,NEW.property_value_person_id,NEW.property_value_sw_package_id,NEW.property_value_token_col_id,NEW.property_rank,NEW.start_date,NEW.finish_date,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_property_ins
	ON jazzhands_legacy.v_property;
CREATE TRIGGER _trigger_v_property_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_property
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_property_ins();


-- Triggers for v_token

CREATE OR REPLACE FUNCTION jazzhands_legacy.v_token_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.v_token (
		token_id,token_type,token_status,token_serial,token_sequence,account_id,token_password,zero_time,time_modulo,time_skew,is_token_locked,token_unlock_time,bad_logins,issued_date,token_last_updated,token_sequence_last_updated,lock_status_last_updated
	) VALUES (
		NEW.token_id,NEW.token_type,NEW.token_status,NEW.token_serial,NEW.token_sequence,NEW.account_id,NEW.token_password,NEW.zero_time,NEW.time_modulo,NEW.time_skew,CASE WHEN NEW.is_token_locked = 'Y' THEN true WHEN NEW.is_token_locked = 'N' THEN false ELSE NULL END,NEW.token_unlock_time,NEW.bad_logins,NEW.issued_date,NEW.token_last_updated,NEW.token_sequence_last_updated,NEW.lock_status_last_updated
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_v_token_ins
	ON jazzhands_legacy.v_token;
CREATE TRIGGER _trigger_v_token_ins
	INSTEAD OF INSERT ON jazzhands_legacy.v_token
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.v_token_ins();


-- Triggers for val_account_collection_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_account_collection_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_account_collection_type (
		account_collection_type,description,is_infrastructure_type,max_num_members,max_num_collections,can_have_hierarchy,account_realm_id
	) VALUES (
		NEW.account_collection_type,NEW.description,CASE WHEN NEW.is_infrastructure_type = 'Y' THEN true WHEN NEW.is_infrastructure_type = 'N' THEN false ELSE NULL END,NEW.max_num_members,NEW.max_num_collections,CASE WHEN NEW.can_have_hierarchy = 'Y' THEN true WHEN NEW.can_have_hierarchy = 'N' THEN false ELSE NULL END,NEW.account_realm_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_account_collection_type_ins
	ON jazzhands_legacy.val_account_collection_type;
CREATE TRIGGER _trigger_val_account_collection_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_account_collection_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_account_collection_type_ins();


-- Triggers for val_account_role

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_account_role_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_account_role (
		account_role,uid_gid_forced,description
	) VALUES (
		NEW.account_role,CASE WHEN NEW.uid_gid_forced = 'Y' THEN true WHEN NEW.uid_gid_forced = 'N' THEN false ELSE NULL END,NEW.description
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_account_role_ins
	ON jazzhands_legacy.val_account_role;
CREATE TRIGGER _trigger_val_account_role_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_account_role
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_account_role_ins();


-- Triggers for val_account_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_account_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_account_type (
		account_type,is_person,uid_gid_forced,description
	) VALUES (
		NEW.account_type,CASE WHEN NEW.is_person = 'Y' THEN true WHEN NEW.is_person = 'N' THEN false ELSE NULL END,CASE WHEN NEW.uid_gid_forced = 'Y' THEN true WHEN NEW.uid_gid_forced = 'N' THEN false ELSE NULL END,NEW.description
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_account_type_ins
	ON jazzhands_legacy.val_account_type;
CREATE TRIGGER _trigger_val_account_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_account_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_account_type_ins();


-- Triggers for val_company_collection_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_company_collection_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_company_collection_type (
		company_collection_type,description,is_infrastructure_type,max_num_members,max_num_collections,can_have_hierarchy
	) VALUES (
		NEW.company_collection_type,NEW.description,CASE WHEN NEW.is_infrastructure_type = 'Y' THEN true WHEN NEW.is_infrastructure_type = 'N' THEN false ELSE NULL END,NEW.max_num_members,NEW.max_num_collections,CASE WHEN NEW.can_have_hierarchy = 'Y' THEN true WHEN NEW.can_have_hierarchy = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_company_collection_type_ins
	ON jazzhands_legacy.val_company_collection_type;
CREATE TRIGGER _trigger_val_company_collection_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_company_collection_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_company_collection_type_ins();


-- Triggers for val_component_property

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_component_property_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_component_property (
		component_property_name,component_property_type,description,is_multivalue,property_data_type,permit_component_type_id,required_component_type_id,permit_component_function,required_component_function,permit_component_id,permit_inter_component_connection_id,permit_slot_type_id,required_slot_type_id,permit_slot_function,required_slot_function,permit_slot_id
	) VALUES (
		NEW.component_property_name,NEW.component_property_type,NEW.description,CASE WHEN NEW.is_multivalue = 'Y' THEN true WHEN NEW.is_multivalue = 'N' THEN false ELSE NULL END,NEW.property_data_type,NEW.permit_component_type_id,NEW.required_component_type_id,NEW.permit_component_function,NEW.required_component_function,NEW.permit_component_id,NEW.permit_intcomp_conn_id,NEW.permit_slot_type_id,NEW.required_slot_type_id,NEW.permit_slot_function,NEW.required_slot_function,NEW.permit_slot_id
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_component_property_ins
	ON jazzhands_legacy.val_component_property;
CREATE TRIGGER _trigger_val_component_property_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_component_property
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_component_property_ins();


-- Triggers for val_component_property_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_component_property_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_component_property_type (
		component_property_type,description,is_multivalue
	) VALUES (
		NEW.component_property_type,NEW.description,CASE WHEN NEW.is_multivalue = 'Y' THEN true WHEN NEW.is_multivalue = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_component_property_type_ins
	ON jazzhands_legacy.val_component_property_type;
CREATE TRIGGER _trigger_val_component_property_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_component_property_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_component_property_type_ins();


-- Triggers for val_device_collection_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_device_collection_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_device_collection_type (
		device_collection_type,description,max_num_members,max_num_collections,can_have_hierarchy
	) VALUES (
		NEW.device_collection_type,NEW.description,NEW.max_num_members,NEW.max_num_collections,CASE WHEN NEW.can_have_hierarchy = 'Y' THEN true WHEN NEW.can_have_hierarchy = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_device_collection_type_ins
	ON jazzhands_legacy.val_device_collection_type;
CREATE TRIGGER _trigger_val_device_collection_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_device_collection_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_device_collection_type_ins();


-- Triggers for val_dns_domain_collection_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_dns_domain_collection_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_dns_domain_collection_type (
		dns_domain_collection_type,description,max_num_members,max_num_collections,can_have_hierarchy
	) VALUES (
		NEW.dns_domain_collection_type,NEW.description,NEW.max_num_members,NEW.max_num_collections,CASE WHEN NEW.can_have_hierarchy = 'Y' THEN true WHEN NEW.can_have_hierarchy = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_dns_domain_collection_type_ins
	ON jazzhands_legacy.val_dns_domain_collection_type;
CREATE TRIGGER _trigger_val_dns_domain_collection_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_dns_domain_collection_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_dns_domain_collection_type_ins();


-- Triggers for val_dns_domain_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_dns_domain_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_dns_domain_type (
		dns_domain_type,can_generate,description
	) VALUES (
		NEW.dns_domain_type,CASE WHEN NEW.can_generate = 'Y' THEN true WHEN NEW.can_generate = 'N' THEN false ELSE NULL END,NEW.description
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_dns_domain_type_ins
	ON jazzhands_legacy.val_dns_domain_type;
CREATE TRIGGER _trigger_val_dns_domain_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_dns_domain_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_dns_domain_type_ins();


-- Triggers for val_layer2_network_coll_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_layer2_network_coll_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_layer2_network_collection_type (
		layer2_network_collection_type,description,max_num_members,max_num_collections,can_have_hierarchy
	) VALUES (
		NEW.layer2_network_collection_type,NEW.description,NEW.max_num_members,NEW.max_num_collections,CASE WHEN NEW.can_have_hierarchy = 'Y' THEN true WHEN NEW.can_have_hierarchy = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_layer2_network_coll_type_ins
	ON jazzhands_legacy.val_layer2_network_coll_type;
CREATE TRIGGER _trigger_val_layer2_network_coll_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_layer2_network_coll_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_layer2_network_coll_type_ins();


-- Triggers for val_layer3_network_coll_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_layer3_network_coll_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_layer3_network_collection_type (
		layer3_network_collection_type,description,max_num_members,max_num_collections,can_have_hierarchy
	) VALUES (
		NEW.layer3_network_collection_type,NEW.description,NEW.max_num_members,NEW.max_num_collections,CASE WHEN NEW.can_have_hierarchy = 'Y' THEN true WHEN NEW.can_have_hierarchy = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_layer3_network_coll_type_ins
	ON jazzhands_legacy.val_layer3_network_coll_type;
CREATE TRIGGER _trigger_val_layer3_network_coll_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_layer3_network_coll_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_layer3_network_coll_type_ins();


-- Triggers for val_netblock_collection_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_netblock_collection_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_netblock_collection_type (
		netblock_collection_type,description,max_num_members,max_num_collections,can_have_hierarchy,netblock_is_single_address_restriction,netblock_ip_family_restriction
	) VALUES (
		NEW.netblock_collection_type,NEW.description,NEW.max_num_members,NEW.max_num_collections,CASE WHEN NEW.can_have_hierarchy = 'Y' THEN true WHEN NEW.can_have_hierarchy = 'N' THEN false ELSE NULL END,NEW.netblock_single_addr_restrict,NEW.netblock_ip_family_restrict
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_netblock_collection_type_ins
	ON jazzhands_legacy.val_netblock_collection_type;
CREATE TRIGGER _trigger_val_netblock_collection_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_netblock_collection_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_netblock_collection_type_ins();


-- Triggers for val_netblock_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_netblock_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_netblock_type (
		netblock_type,description,db_forced_hierarchy,is_validated_hierarchy
	) VALUES (
		NEW.netblock_type,NEW.description,CASE WHEN NEW.db_forced_hierarchy = 'Y' THEN true WHEN NEW.db_forced_hierarchy = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_validated_hierarchy = 'Y' THEN true WHEN NEW.is_validated_hierarchy = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_netblock_type_ins
	ON jazzhands_legacy.val_netblock_type;
CREATE TRIGGER _trigger_val_netblock_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_netblock_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_netblock_type_ins();


-- Triggers for val_network_range_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_network_range_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_network_range_type (
		network_range_type,description,dns_domain_required,default_dns_prefix,netblock_type,can_overlap,require_cidr_boundary
	) VALUES (
		NEW.network_range_type,NEW.description,NEW.dns_domain_required,NEW.default_dns_prefix,NEW.netblock_type,CASE WHEN NEW.can_overlap = 'Y' THEN true WHEN NEW.can_overlap = 'N' THEN false ELSE NULL END,CASE WHEN NEW.require_cidr_boundary = 'Y' THEN true WHEN NEW.require_cidr_boundary = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_network_range_type_ins
	ON jazzhands_legacy.val_network_range_type;
CREATE TRIGGER _trigger_val_network_range_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_network_range_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_network_range_type_ins();


-- Triggers for val_person_image_usage

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_person_image_usage_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_person_image_usage (
		person_image_usage,is_multivalue
	) VALUES (
		NEW.person_image_usage,CASE WHEN NEW.is_multivalue = 'Y' THEN true WHEN NEW.is_multivalue = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_person_image_usage_ins
	ON jazzhands_legacy.val_person_image_usage;
CREATE TRIGGER _trigger_val_person_image_usage_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_person_image_usage
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_person_image_usage_ins();


-- Triggers for val_person_status

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_person_status_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_person_status (
		person_status,description,is_enabled,propagate_from_person,is_forced,is_db_enforced
	) VALUES (
		NEW.person_status,NEW.description,CASE WHEN NEW.is_enabled = 'Y' THEN true WHEN NEW.is_enabled = 'N' THEN false ELSE NULL END,CASE WHEN NEW.propagate_from_person = 'Y' THEN true WHEN NEW.propagate_from_person = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_forced = 'Y' THEN true WHEN NEW.is_forced = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_db_enforced = 'Y' THEN true WHEN NEW.is_db_enforced = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_person_status_ins
	ON jazzhands_legacy.val_person_status;
CREATE TRIGGER _trigger_val_person_status_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_person_status
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_person_status_ins();


-- Triggers for val_property

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_property_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_property (
		property_name,property_type,description,account_collection_type,company_collection_type,device_collection_type,dns_domain_collection_type,layer2_network_collection_type,layer3_network_collection_type,netblock_collection_type,network_range_type,property_name_collection_type,service_environment_collection_type,is_multivalue,property_value_account_collection_type_restriction,property_value_device_collection_type_restriction,property_value_netblock_collection_type_restriction,property_data_type,property_value_json_schema,permit_account_collection_id,permit_account_id,permit_account_realm_id,permit_company_id,permit_company_collection_id,permit_device_collection_id,permit_dns_domain_collection_id,permit_layer2_network_collection_id,permit_layer3_network_collection_id,permit_netblock_collection_id,permit_network_range_id,permit_operating_system_id,permit_operating_system_snapshot_id,permit_person_id,permit_property_name_collection_id,permit_service_environment_collection,permit_site_code,permit_x509_signed_certificate_id,permit_property_rank
	) VALUES (
		NEW.property_name,NEW.property_type,NEW.description,NEW.account_collection_type,NEW.company_collection_type,NEW.device_collection_type,NEW.dns_domain_collection_type,NEW.layer2_network_collection_type,NEW.layer3_network_collection_type,NEW.netblock_collection_type,NEW.network_range_type,NEW.property_collection_type,NEW.service_env_collection_type,CASE WHEN NEW.is_multivalue = 'Y' THEN true WHEN NEW.is_multivalue = 'N' THEN false ELSE NULL END,NEW.prop_val_acct_coll_type_rstrct,NEW.prop_val_dev_coll_type_rstrct,NEW.prop_val_nblk_coll_type_rstrct,NEW.property_data_type,NEW.property_value_json_schema,NEW.permit_account_collection_id,NEW.permit_account_id,NEW.permit_account_realm_id,NEW.permit_company_id,NEW.permit_company_collection_id,NEW.permit_device_collection_id,NEW.permit_dns_domain_coll_id,NEW.permit_layer2_network_coll_id,NEW.permit_layer3_network_coll_id,NEW.permit_netblock_collection_id,NEW.permit_network_range_id,NEW.permit_operating_system_id,NEW.permit_os_snapshot_id,NEW.permit_person_id,NEW.permit_property_collection_id,NEW.permit_service_env_collection,NEW.permit_site_code,NEW.permit_x509_signed_cert_id,NEW.permit_property_rank
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_property_ins
	ON jazzhands_legacy.val_property;
CREATE TRIGGER _trigger_val_property_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_property
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_property_ins();


-- Triggers for val_property_collection_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_property_collection_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_property_name_collection_type (
		property_name_collection_type,description,max_num_members,max_num_collections,can_have_hierarchy
	) VALUES (
		NEW.property_collection_type,NEW.description,NEW.max_num_members,NEW.max_num_collections,CASE WHEN NEW.can_have_hierarchy = 'Y' THEN true WHEN NEW.can_have_hierarchy = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_property_collection_type_ins
	ON jazzhands_legacy.val_property_collection_type;
CREATE TRIGGER _trigger_val_property_collection_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_property_collection_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_property_collection_type_ins();


-- Triggers for val_property_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_property_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_property_type (
		property_type,description,property_value_account_collection_type_restriction,is_multivalue
	) VALUES (
		NEW.property_type,NEW.description,NEW.prop_val_acct_coll_type_rstrct,CASE WHEN NEW.is_multivalue = 'Y' THEN true WHEN NEW.is_multivalue = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_property_type_ins
	ON jazzhands_legacy.val_property_type;
CREATE TRIGGER _trigger_val_property_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_property_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_property_type_ins();


-- Triggers for val_service_env_coll_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_service_env_coll_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_service_environment_collection_type (
		service_environment_collection_type,description,max_num_members,max_num_collections,can_have_hierarchy
	) VALUES (
		NEW.service_env_collection_type,NEW.description,NEW.max_num_members,NEW.max_num_collections,CASE WHEN NEW.can_have_hierarchy = 'Y' THEN true WHEN NEW.can_have_hierarchy = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_service_env_coll_type_ins
	ON jazzhands_legacy.val_service_env_coll_type;
CREATE TRIGGER _trigger_val_service_env_coll_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_service_env_coll_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_service_env_coll_type_ins();


-- Triggers for val_slot_function

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_slot_function_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_slot_function (
		slot_function,description,can_have_mac_address
	) VALUES (
		NEW.slot_function,NEW.description,CASE WHEN NEW.can_have_mac_address = 'Y' THEN true WHEN NEW.can_have_mac_address = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_slot_function_ins
	ON jazzhands_legacy.val_slot_function;
CREATE TRIGGER _trigger_val_slot_function_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_slot_function
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_slot_function_ins();


-- Triggers for val_token_collection_type

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_token_collection_type_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_token_collection_type (
		token_collection_type,description,max_num_members,max_num_collections,can_have_hierarchy
	) VALUES (
		NEW.token_collection_type,NEW.description,NEW.max_num_members,NEW.max_num_collections,CASE WHEN NEW.can_have_hierarchy = 'Y' THEN true WHEN NEW.can_have_hierarchy = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_token_collection_type_ins
	ON jazzhands_legacy.val_token_collection_type;
CREATE TRIGGER _trigger_val_token_collection_type_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_token_collection_type
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_token_collection_type_ins();


-- Triggers for val_x509_key_usage

CREATE OR REPLACE FUNCTION jazzhands_legacy.val_x509_key_usage_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.val_x509_key_usage (
		x509_key_usage,description,is_extended
	) VALUES (
		NEW.x509_key_usg,NEW.description,CASE WHEN NEW.is_extended = 'Y' THEN true WHEN NEW.is_extended = 'N' THEN false ELSE NULL END
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_val_x509_key_usage_ins
	ON jazzhands_legacy.val_x509_key_usage;
CREATE TRIGGER _trigger_val_x509_key_usage_ins
	INSTEAD OF INSERT ON jazzhands_legacy.val_x509_key_usage
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.val_x509_key_usage_ins();


-- Triggers for x509_certificate

CREATE OR REPLACE FUNCTION jazzhands_legacy.x509_certificate_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.x509_certificate (
		x509_cert_id,friendly_name,is_active,is_certificate_authority,signing_cert_id,x509_ca_cert_serial_number,public_key,private_key,certificate_sign_req,subject,subject_key_identifier,valid_from,valid_to,x509_revocation_date,x509_revocation_reason,passphrase,encryption_key_id,ocsp_uri,crl_uri
	) VALUES (
		NEW.x509_cert_id,NEW.friendly_name,CASE WHEN NEW.is_active = 'Y' THEN true WHEN NEW.is_active = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_certificate_authority = 'Y' THEN true WHEN NEW.is_certificate_authority = 'N' THEN false ELSE NULL END,NEW.signing_cert_id,NEW.x509_ca_cert_serial_number,NEW.public_key,NEW.private_key,NEW.certificate_sign_req,NEW.subject,NEW.subject_key_identifier,NEW.valid_from,NEW.valid_to,NEW.x509_revocation_date,NEW.x509_revocation_reason,NEW.passphrase,NEW.encryption_key_id,NEW.ocsp_uri,NEW.crl_uri
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_x509_certificate_ins
	ON jazzhands_legacy.x509_certificate;
CREATE TRIGGER _trigger_x509_certificate_ins
	INSTEAD OF INSERT ON jazzhands_legacy.x509_certificate
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.x509_certificate_ins();


-- Triggers for x509_signed_certificate

CREATE OR REPLACE FUNCTION jazzhands_legacy.x509_signed_certificate_ins()
RETURNS TRIGGER AS
$$
BEGIN

	INSERT INTO jazzhands.x509_signed_certificate (
		x509_signed_certificate_id,x509_certificate_type,subject,friendly_name,subject_key_identifier,is_active,is_certificate_authority,signing_cert_id,x509_ca_cert_serial_number,public_key,private_key_id,certificate_signing_request_id,valid_from,valid_to,x509_revocation_date,x509_revocation_reason,ocsp_uri,crl_uri
	) VALUES (
		NEW.x509_signed_certificate_id,NEW.x509_certificate_type,NEW.subject,NEW.friendly_name,NEW.subject_key_identifier,CASE WHEN NEW.is_active = 'Y' THEN true WHEN NEW.is_active = 'N' THEN false ELSE NULL END,CASE WHEN NEW.is_certificate_authority = 'Y' THEN true WHEN NEW.is_certificate_authority = 'N' THEN false ELSE NULL END,NEW.signing_cert_id,NEW.x509_ca_cert_serial_number,NEW.public_key,NEW.private_key_id,NEW.certificate_signing_request_id,NEW.valid_from,NEW.valid_to,NEW.x509_revocation_date,NEW.x509_revocation_reason,NEW.ocsp_uri,NEW.crl_uri
	);
	RETURN NEW;
END;
$$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trigger_x509_signed_certificate_ins
	ON jazzhands_legacy.x509_signed_certificate;
CREATE TRIGGER _trigger_x509_signed_certificate_ins
	INSTEAD OF INSERT ON jazzhands_legacy.x509_signed_certificate
	FOR EACH ROW
	EXECUTE PROCEDURE jazzhands_legacy.x509_signed_certificate_ins();




