/* --- Creating Project --- */
CREATE OR REPLACE FUNCTION check_create_project () RETURNS trigger
AS $$ BEGIN
    IF created_project_more_than_n_days(NEW.email, 3) THEN
        RAISE EXCEPTION 'User % created project in last 3 days.', NEW.email; 
    END IF;

    IF has_not_logged_in_past_n_days(NEW.email, 10) THEN
        RAISE EXCEPTION 'User % has not logged in past 10 days.', NEW.email;
    END IF;

    IF has_not_created_in_past_n_days(NEW.email, 30) THEN
        RAISE EXCEPTION 'User % had just been created in past 30 days.', NEW.email;
    END IF;

    RETURN NEW;
END; $$
LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS check_create_project ON Projects;
CREATE TRIGGER check_create_project BEFORE INSERT ON Projects
    FOR EACH ROW EXECUTE PROCEDURE check_create_project();

CREATE OR REPLACE FUNCTION created_project_more_than_n_days (
    varchar(255), integer) RETURNS boolean
AS $$
DECLARE
    _var integer;
BEGIN
    EXECUTE format('SELECT 1 FROM Projects P
        NATURAL JOIN Users U
        WHERE   P.email = ''%s''
        AND     (LOCALTIMESTAMP - project_created_timestamp) <= interval ''%s days'';', $1, $2)
    INTO _var;
    IF _var THEN
        RETURN true;
    ELSE
        RETURN false;
    END IF;
END; $$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION has_not_logged_in_past_n_days(
    varchar(255), integer) RETURNS boolean
AS $$
DECLARE
    _var integer;
BEGIN
    EXECUTE format('SELECT 1 FROM Users U
        WHERE   U.email = ''%s''
        AND     (LOCALTIMESTAMP - user_last_login_timestamp) > interval ''%s days'';', $1, $2)
    INTO _var;

    IF _var THEN
        RETURN true;
    ELSE
        RETURN false;
    END IF;
END; $$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION has_not_created_in_past_n_days(
    varchar(255), integer) RETURNS boolean
AS $$
DECLARE
    _var integer;
BEGIN
    EXECUTE format('SELECT 1 FROM Users U
        WHERE   U.email = ''%s''
        AND     (LOCALTIMESTAMP - U.user_created_timestamp) <= interval ''%s days'';', $1, $2)
    INTO _var;

    IF _var THEN
        RETURN true;
    ELSE
        RETURN false;
    END IF;
END; $$
LANGUAGE PLPGSQL;

/* --- Creating Feedback --- */
CREATE OR REPLACE FUNCTION check_create_feedback () RETURNS trigger
AS $$ BEGIN
    IF user_is_creator_of_project_receiving_feedback(NEW.project_name, NEW.email) THEN
        RAISE EXCEPTION 'Creator of project cannot give feedback on their own project.';
    END IF;

    RAISE NOTICE 'Created feedback!';

    /*
    IF user_has_backed_project(NEW.email, NEW.project_name) != true THEN
        RAISE EXCEPTION 'User has not backed the project';
    END IF;

    IF project_backed_is_fully_funded() != true THEN
        RAISE EXCEPTION 'Project is not successfully funded'
    END IF

    IF project_backed_is_live() THEN
        RAISE EXCEPTION 'Project is still ongoing.'
    END IF
    */

    RETURN NEW;
END; $$
LANGUAGE PLPGSQL;

CREATE OR REPLACE FUNCTION user_is_creator_of_project_receiving_feedback (
    varchar(255), varchar(255)) RETURNS boolean
AS $$
DECLARE
    _result_count integer;
BEGIN
    EXECUTE format('SELECT COUNT(P.project_name) FROM Projects AS P
        WHERE P.project_name = ''%s''
        AND P.email = ''%s'';', $1, $2)
        INTO _result_count;
    IF _result_count THEN
        RETURN true;
    ELSE
        RETURN false;
    END IF;
END; $$
LANGUAGE PLPGSQL;

DROP TRIGGER IF EXISTS check_create_feedback ON Feedbacks;
CREATE TRIGGER check_create_feedback BEFORE INSERT ON Feedbacks
    FOR EACH ROW EXECUTE PROCEDURE check_create_feedback();
