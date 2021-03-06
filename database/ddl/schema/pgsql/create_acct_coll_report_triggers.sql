/*
 * Copyright (c) 2015 Todd Kover
 * All rights reserved.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

\set ON_ERROR_STOP

--
-- Changes to account trigger addition/removal from various things.  This is
-- actually redundant with the second two triggers on person_company and
-- person, which deal with updates.  This covers the case of accounts coming
-- into existance after the rows in person/person_company
--
-- This currently does not move an account out of a "site" class when someone
-- moves around, which should probably be revisited.
--
CREATE OR REPLACE FUNCTION account_automated_reporting_ac()
RETURNS TRIGGER AS $_$
DECLARE
	_tally	INTEGER;
	_numrpt	INTEGER;
	_r		RECORD;
BEGIN
	IF TG_OP = 'DELETE' THEN
		IF OLD.account_role != 'primary' THEN
			RETURN OLD;
		END IF;
	ELSIF TG_OP = 'INSERT' THEN
		IF NEW.account_role != 'primary' THEN
			RETURN NEW;
		END IF;
	ELSIF TG_OP = 'UPDATE' THEN
		IF NEW.account_role != 'primary' AND OLD.account_role != 'primary' THEN
			RETURN NEW;
		END IF;
	END IF;

	-- XXX check account realm to see if we should be inserting for this
	-- XXX account realm

	IF TG_OP = 'INSERT' THEN
		PERFORM auto_ac_manip.make_all_auto_acs_right(
			account_id := NEW.account_id,
			account_realm_id := NEW.account_realm_id,
			login := NEW.login
		);
	ELSIF TG_OP = 'UPDATE' THEN
		PERFORM auto_ac_manip.rename_automated_report_acs(
			NEW.account_id, OLD.login, NEW.login, NEW.account_realm_id);
	ELSIF TG_OP = 'DELETE' THEN
		DELETE FROM account_collection_account WHERE account_id
			= OLD.account_id
		AND account_collection_id IN ( select account_collection_id
			FROM account_collection where account_collection_type
			= 'automated'
		);
		-- PERFORM auto_ac_manip.destroy_report_account_collections(
		--	account_id := OLD.account_id,
		--	account_realm_id := OLD.account_realm_id
		-- );
	END IF;

	IF TG_OP = 'DELETE' THEN
		RETURN OLD;
	ELSE
		RETURN NEW;
	END IF;
END;
$_$
SET search_path=jazzhands
LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS trig_add_account_automated_reporting_ac ON account;
CREATE TRIGGER trig_add_account_automated_reporting_ac
	AFTER INSERT OR UPDATE OF login, account_status
	ON account
	FOR EACH ROW
	EXECUTE PROCEDURE account_automated_reporting_ac();

DROP TRIGGER IF EXISTS trig_rm_account_automated_reporting_ac ON account;
CREATE TRIGGER trig_rm_account_automated_reporting_ac
	BEFORE DELETE
	ON account
	FOR EACH ROW
	EXECUTE PROCEDURE account_automated_reporting_ac();

--------------------------------------------------------------------------
