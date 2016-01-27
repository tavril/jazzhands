-- Copyright (c) 2015-2016, Todd M. Kover
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

CREATE OR REPLACE VIEW v_hotpants_device_collection AS
SELECT DISTINCT
                Device_Id,
                Device_Name,
                dc.Device_Collection_Id,
                dc.Device_Collection_Name,
                dc.Device_Collection_Type,
                host(IP_Address) as IP_address
        FROM	property p
		INNER JOIN device_collection dc USING (device_collection_id)
		INNER JOIN v_device_coll_hier_detail dcr ON
			p.device_collection_id = dcr.parent_device_collection_id
                INNER JOIN device_collection_device dcd ON
                        dcd.device_collection_id = dcr.device_collection_id
                INNER JOIN Device USING (Device_Id) 
                INNER JOIN Network_Interface NI USING (Device_ID) 
                INNER JOIN Netblock NB USING (Netblock_id)
	WHERE
		property_type IN ('HOTPants', 'HOTPants-app')
;