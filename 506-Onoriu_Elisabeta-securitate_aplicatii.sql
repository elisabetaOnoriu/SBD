-- =====================================================
-- 6_APLICATII_PE_BAZA_DE_DATE
-- =====================================================

SET SERVEROUTPUT ON;


-- =====================================================
-- 6.1 CONTEXTUL APLICATIEI
-- Contextul MED_APP_CTX trebuie sa fie creat anterior din SYSTEM
-- =====================================================

CREATE OR REPLACE PACKAGE MED_APP_CONTEXT_PKG AS 
    PROCEDURE set_current_user(p_username VARCHAR2); 
END; 
/ 
 
CREATE OR REPLACE PACKAGE BODY MED_APP_CONTEXT_PKG AS 
    PROCEDURE set_current_user(p_username VARCHAR2) IS 
    BEGIN 
        DBMS_SESSION.SET_CONTEXT( 
            namespace => 'MED_APP_CTX', 
            attribute => 'CURRENT_USER', 
            value     => p_username 
        ); 
    END; 
END; 
/ 
 
BEGIN 
    MED_APP_CONTEXT_PKG.set_current_user('MED_DOCTOR_1'); 
END; 
/ 
 
SELECT SYS_CONTEXT('MED_APP_CTX', 'CURRENT_USER') AS utilizator_curent 
FROM dual; 


-- =====================================================
-- 6.3 PROCEDURA VULNERABILA
-- =====================================================

CREATE OR REPLACE PROCEDURE search_patient_vulnerable ( 
    p_last_name IN VARCHAR2 
) 
IS 
    v_sql VARCHAR2(1000); 
BEGIN 
    v_sql := 'SELECT patient_id, first_name, last_name, email  
              FROM patients  
              WHERE last_name = ''' || p_last_name || ''''; 
 
    DBMS_OUTPUT.PUT_LINE(v_sql); 
END; 
/ 


-- Test normal

BEGIN 
    search_patient_vulnerable('Popescu'); 
END; 
/ 


-- Test SQL Injection

BEGIN 
    search_patient_vulnerable('Popescu'' OR ''1''=''1'); 
END; 
/ 


-- =====================================================
-- 6.4 PROCEDURA SECURIZATA
-- =====================================================

CREATE OR REPLACE PROCEDURE search_patient_secure ( 
    p_last_name IN VARCHAR2 
) 
IS 
    v_sql   VARCHAR2(1000); 
    v_count NUMBER; 
BEGIN 
    v_sql := 'SELECT COUNT(*) FROM patients WHERE last_name = :x'; 
 
    EXECUTE IMMEDIATE v_sql 
    INTO v_count 
    USING p_last_name; 
 
    DBMS_OUTPUT.PUT_LINE(v_sql); 
    DBMS_OUTPUT.PUT_LINE('Numar rezultate: ' || v_count); 
END; 
/ 


-- Test SQL Injection pe procedura securizata

BEGIN 
    search_patient_secure('Popescu'' OR ''1''=''1'); 
END; 
/