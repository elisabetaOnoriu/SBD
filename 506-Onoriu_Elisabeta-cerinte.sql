-- ============================================================ 
-- CERINȚA 1: CREARE INSERARE 
-- ============================================================ 

CREATE TABLE patients (
    patient_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    cnp VARCHAR2(13) NOT NULL UNIQUE,
    date_of_birth DATE,
    phone VARCHAR2(20),
    email VARCHAR2(100),
    address VARCHAR2(200),
    created_date DATE DEFAULT SYSDATE
);

CREATE TABLE doctors (
    doctor_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(20),
    status VARCHAR2(20) DEFAULT 'ACTIVE',
    created_date DATE DEFAULT SYSDATE,
    CONSTRAINT chk_doctors_status
        CHECK (status IN ('ACTIVE', 'INACTIVE'))
);

CREATE TABLE specializations (
    specialization_id NUMBER PRIMARY KEY,
    specialization_name VARCHAR2(100) NOT NULL UNIQUE,
    description VARCHAR2(300)
);

CREATE TABLE doctor_specializations (
    doctor_id NUMBER NOT NULL,
    specialization_id NUMBER NOT NULL,
    is_primary CHAR(1) DEFAULT 'N',
    assigned_date DATE DEFAULT SYSDATE,

    CONSTRAINT pk_doctor_specializations
        PRIMARY KEY (doctor_id, specialization_id),

    CONSTRAINT fk_ds_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id),

    CONSTRAINT fk_ds_specialization
        FOREIGN KEY (specialization_id)
        REFERENCES specializations(specialization_id),

    CONSTRAINT chk_ds_primary
        CHECK (is_primary IN ('Y', 'N'))
);

CREATE TABLE appointments (
    appointment_id NUMBER PRIMARY KEY,
    patient_id NUMBER NOT NULL,
    doctor_id NUMBER NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time VARCHAR2(10),
    status VARCHAR2(20) DEFAULT 'SCHEDULED',
    reason VARCHAR2(300),
    created_date DATE DEFAULT SYSDATE,

    CONSTRAINT fk_appointments_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_appointments_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id),

    CONSTRAINT chk_appointments_status
        CHECK (status IN ('SCHEDULED', 'IN_PROGRESS', 'COMPLETED', 'CANCELLED'))
);

CREATE TABLE consultations (
    consultation_id NUMBER PRIMARY KEY,
    patient_id NUMBER NOT NULL,
    doctor_id NUMBER NOT NULL,
    appointment_id NUMBER,
    consultation_date DATE DEFAULT SYSDATE,
    diagnosis VARCHAR2(500),
    treatment VARCHAR2(500),
    recommendations VARCHAR2(500),

    CONSTRAINT fk_consultations_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_consultations_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id),

    CONSTRAINT fk_consultations_appointment
        FOREIGN KEY (appointment_id)
        REFERENCES appointments(appointment_id)
);

CREATE TABLE medical_results (
    result_id NUMBER PRIMARY KEY,
    patient_id NUMBER NOT NULL,
    doctor_id NUMBER NOT NULL,
    result_type VARCHAR2(100) NOT NULL,
    result_value VARCHAR2(500),
    result_date DATE DEFAULT SYSDATE,
    confidential_notes VARCHAR2(500),

    CONSTRAINT fk_results_patient
        FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    CONSTRAINT fk_results_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id)
);

CREATE TABLE roles (
    role_id NUMBER PRIMARY KEY,
    role_name VARCHAR2(50) NOT NULL UNIQUE,
    description VARCHAR2(300)
);

CREATE TABLE db_users (
    user_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) NOT NULL UNIQUE,
    role_id NUMBER NOT NULL,
    doctor_id NUMBER,
    status VARCHAR2(20) DEFAULT 'ACTIVE',
    created_date DATE DEFAULT SYSDATE,

    CONSTRAINT fk_db_users_role
        FOREIGN KEY (role_id)
        REFERENCES roles(role_id),

    CONSTRAINT fk_db_users_doctor
        FOREIGN KEY (doctor_id)
        REFERENCES doctors(doctor_id),

    CONSTRAINT chk_db_users_status
        CHECK (status IN ('ACTIVE', 'INACTIVE', 'LOCKED'))
);

CREATE TABLE privileges (
    privilege_id NUMBER PRIMARY KEY,
    privilege_type VARCHAR2(50) NOT NULL,
    privilege_name VARCHAR2(100) NOT NULL,
    object_name VARCHAR2(50),
    grantable VARCHAR2(3) DEFAULT 'NO',

    CONSTRAINT chk_privilege_type
        CHECK (privilege_type IN ('SYSTEM', 'OBJECT')),

    CONSTRAINT chk_privilege_grantable
        CHECK (grantable IN ('YES', 'NO'))
);

CREATE TABLE role_privileges (
    role_id NUMBER NOT NULL,
    privilege_id NUMBER NOT NULL,
    granted_date DATE DEFAULT SYSDATE,

    CONSTRAINT pk_role_privileges
        PRIMARY KEY (role_id, privilege_id),

    CONSTRAINT fk_rp_role
        FOREIGN KEY (role_id)
        REFERENCES roles(role_id),

    CONSTRAINT fk_rp_privilege
        FOREIGN KEY (privilege_id)
        REFERENCES privileges(privilege_id)
);

CREATE TABLE audit_log (
    audit_id NUMBER PRIMARY KEY,
    username VARCHAR2(50) NOT NULL,
    action_type VARCHAR2(50) NOT NULL,
    table_name VARCHAR2(50),
    record_id NUMBER,
    old_value VARCHAR2(500),
    new_value VARCHAR2(500),
    action_date DATE DEFAULT SYSDATE,
    session_id VARCHAR2(100)
);

SELECT table_name
FROM user_tables
ORDER BY table_name;

INSERT INTO patients (
    patient_id,
    first_name,
    last_name,
    cnp,
    date_of_birth,
    phone,
    email,
    address,
    created_date
) VALUES (
    1,
    'Ana',
    'Marin',
    '2990101123456',
    DATE '1999-01-01',
    '0733000001',
    'ana.marin@email.com',
    'Bucuresti',
    SYSDATE
);

INSERT INTO patients (
    patient_id,
    first_name,
    last_name,
    cnp,
    date_of_birth,
    phone,
    email,
    address,
    created_date
) VALUES (
    2,
    'Mihai',
    'Stan',
    '1880505123456',
    DATE '1988-05-05',
    '0733000002',
    'mihai.stan@email.com',
    'Ilfov',
    SYSDATE
);

INSERT INTO patients (
    patient_id,
    first_name,
    last_name,
    cnp,
    date_of_birth,
    phone,
    email,
    address,
    created_date
) VALUES (
    3,
    'Elena',
    'Georgescu',
    '2761111123456',
    DATE '1976-11-11',
    '0733000003',
    'elena.georgescu@email.com',
    'Bucuresti',
    SYSDATE
);

COMMIT;

INSERT INTO doctors (
    doctor_id,
    first_name,
    last_name,
    email,
    phone,
    status,
    created_date
) VALUES (
    1,
    'Andrei',
    'Popescu',
    'andrei.popescu@clinic.ro',
    '0722000001',
    'ACTIVE',
    SYSDATE
);

INSERT INTO doctors (
    doctor_id,
    first_name,
    last_name,
    email,
    phone,
    status,
    created_date
) VALUES (
    2,
    'Maria',
    'Ionescu',
    'maria.ionescu@clinic.ro',
    '0722000002',
    'ACTIVE',
    SYSDATE
);

COMMIT;

INSERT INTO consultations (
    consultation_id,
    patient_id,
    doctor_id,
    appointment_id,
    consultation_date,
    diagnosis,
    treatment,
    recommendations
) VALUES (
    100,
    1,
    1,
    NULL,
    SYSDATE,
    'Diagnostic initial pentru test audit',
    'Tratament initial pentru test audit',
    'Recomandare initiala'
);

COMMIT;

INSERT INTO medical_results (
    result_id,
    patient_id,
    doctor_id,
    result_type,
    result_value,
    result_date,
    confidential_notes
)
VALUES (
    1,
    1,
    1,
    'Analiza sange',
    'Hemoglobina scazuta',
    SYSDATE,
    'Pacient cu istoric medical sensibil'
);

COMMIT;

-- ============================================================ 
-- CERINȚA 2: CRIPTAREA DATELOR 
-- Adăugarea coloanelor criptate 
-- ============================================================ 
 
ALTER TABLE patients ADD ( 
    cnp_encrypted RAW(2000) 
); 
 
ALTER TABLE consultations ADD ( 
    diagnosis_encrypted RAW(2000), 
    treatment_encrypted RAW(2000) 
); 
 
ALTER TABLE medical_results ADD ( 
    result_value_encrypted RAW(2000), 
    confidential_notes_encrypted RAW(2000) 
); 

-- Verificarea coloanelor criptate adăugate

SELECT  
    table_name, 
    column_name, 
    data_type 
FROM user_tab_columns 
WHERE column_name LIKE '%ENCRYPTED' 
ORDER BY table_name, column_name;

-- ============================================================ 
-- Pachet PL/SQL pentru criptare și decriptare
-- ============================================================ 

CREATE OR REPLACE PACKAGE medical_crypto_pkg AS
    FUNCTION encrypt_value(p_text IN VARCHAR2) RETURN RAW;
    FUNCTION decrypt_value(p_raw IN RAW) RETURN VARCHAR2;
END medical_crypto_pkg;
/
 
CREATE OR REPLACE PACKAGE BODY medical_crypto_pkg AS  
  
    g_key RAW(32) := UTL_RAW.CAST_TO_RAW('12345678901234567890123456789012');  
  
    FUNCTION encrypt_value(p_text IN VARCHAR2) RETURN RAW IS  
        v_encrypted RAW(2000);  
    BEGIN  
        v_encrypted := SYS.DBMS_CRYPTO.ENCRYPT(  
            src => UTL_I18N.STRING_TO_RAW(p_text, 'AL32UTF8'),  
            typ => SYS.DBMS_CRYPTO.ENCRYPT_AES256  
                 + SYS.DBMS_CRYPTO.CHAIN_ECB  
                 + SYS.DBMS_CRYPTO.PAD_PKCS5,  
            key => g_key  
        );  
  
        RETURN v_encrypted;  
    END encrypt_value;  
  
    FUNCTION decrypt_value(p_raw IN RAW) RETURN VARCHAR2 IS  
        v_decrypted RAW(2000);  
    BEGIN  
        v_decrypted := SYS.DBMS_CRYPTO.DECRYPT(  
            src => p_raw,  
            typ => SYS.DBMS_CRYPTO.ENCRYPT_AES256  
                 + SYS.DBMS_CRYPTO.CHAIN_ECB  
                 + SYS.DBMS_CRYPTO.PAD_PKCS5,  
            key => g_key  
        );  
  
        RETURN UTL_I18N.RAW_TO_CHAR(v_decrypted, 'AL32UTF8');  
    END decrypt_value;  
  
END medical_crypto_pkg;  
/  
  
-- Criptarea datelor sensibile existente 
 
UPDATE patients  
SET cnp_encrypted = medical_crypto_pkg.encrypt_value(cnp);  
  
UPDATE consultations  
SET diagnosis_encrypted = medical_crypto_pkg.encrypt_value(diagnosis),  
    treatment_encrypted = medical_crypto_pkg.encrypt_value(treatment);  
  
UPDATE medical_results  
SET result_value_encrypted = medical_crypto_pkg.encrypt_value(result_value),  
    confidential_notes_encrypted = medical_crypto_pkg.encrypt_value(confidential_notes);  
  
COMMIT;  
  
-- Verificarea valorilor criptate 
 
SELECT   
    patient_id,  
    cnp,  
    cnp_encrypted  
FROM patients;  
 
-- Verificarea decriptării 
 
SELECT   
    patient_id,  
    cnp, 
    medical_crypto_pkg.decrypt_value(cnp_encrypted) AS decrypted_cnp 
FROM patients;

-- ============================================================
-- CERINȚA 3: AUDITAREA ACTIVITĂȚILOR ASUPRA BAZEI DE DATE
-- 3.1 Auditare standard
-- ============================================================

AUDIT SELECT, INSERT, UPDATE, DELETE ON patients BY ACCESS;
AUDIT SELECT, INSERT, UPDATE, DELETE ON appointments BY ACCESS;
AUDIT SELECT, INSERT, UPDATE, DELETE ON consultations BY ACCESS;
AUDIT SELECT, INSERT, UPDATE, DELETE ON medical_results BY ACCESS;

SELECT *
FROM user_obj_audit_opts
WHERE object_name IN (
    'PATIENTS',
    'APPOINTMENTS',
    'CONSULTATIONS',
    'MEDICAL_RESULTS'
);

-- ============================================================
-- 3.2 Trigger-i de auditare
-- ============================================================

CREATE SEQUENCE seq_audit
START WITH 1
INCREMENT BY 1;

CREATE OR REPLACE TRIGGER trg_audit_appointments_insert
AFTER INSERT ON appointments
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (
        audit_id,
        username,
        action_type,
        table_name,
        record_id,
        old_value,
        new_value,
        action_date,
        session_id
    ) VALUES (
        seq_audit.NEXTVAL,
        USER,
        'INSERT',
        'APPOINTMENTS',
        :NEW.appointment_id,
        NULL,
        'patient_id=' || :NEW.patient_id ||
        ', doctor_id=' || :NEW.doctor_id ||
        ', status=' || :NEW.status,
        SYSDATE,
        SYS_CONTEXT('USERENV', 'SESSIONID')
    );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_consultations_update
AFTER UPDATE ON consultations
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (
        audit_id,
        username,
        action_type,
        table_name,
        record_id,
        old_value,
        new_value,
        action_date,
        session_id
    ) VALUES (
        seq_audit.NEXTVAL,
        USER,
        'UPDATE',
        'CONSULTATIONS',
        :NEW.consultation_id,
        'diagnosis=' || :OLD.diagnosis || ', treatment=' || :OLD.treatment,
        'diagnosis=' || :NEW.diagnosis || ', treatment=' || :NEW.treatment,
        SYSDATE,
        SYS_CONTEXT('USERENV', 'SESSIONID')
    );
END;
/

CREATE OR REPLACE TRIGGER trg_audit_results_delete
AFTER DELETE ON medical_results
FOR EACH ROW
BEGIN
    INSERT INTO audit_log (
        audit_id,
        username,
        action_type,
        table_name,
        record_id,
        old_value,
        new_value,
        action_date,
        session_id
    ) VALUES (
        seq_audit.NEXTVAL,
        USER,
        'DELETE',
        'MEDICAL_RESULTS',
        :OLD.result_id,
        'result_type=' || :OLD.result_type ||
        ', result_value=' || :OLD.result_value,
        NULL,
        SYSDATE,
        SYS_CONTEXT('USERENV', 'SESSIONID')
    );
END;
/

SELECT 
    trigger_name,
    table_name,
    triggering_event,
    status
FROM user_triggers
WHERE trigger_name LIKE 'TRG_AUDIT%'
ORDER BY trigger_name;

-- ============================================================
-- 3.3 Politici de auditare
-- ============================================================

BEGIN
    DBMS_FGA.ADD_POLICY(
        object_schema   => USER,
        object_name     => 'PATIENTS',
        policy_name     => 'FGA_PATIENT_CNP_ACCESS',
        audit_column    => 'CNP',
        statement_types => 'SELECT',
        enable          => TRUE
    );
END;
/

BEGIN
    DBMS_FGA.ADD_POLICY(
        object_schema   => USER,
        object_name     => 'CONSULTATIONS',
        policy_name     => 'FGA_CONSULTATION_ACCESS',
        audit_column    => 'DIAGNOSIS,TREATMENT',
        statement_types => 'SELECT',
        enable          => TRUE
    );
END;
/

BEGIN
    DBMS_FGA.ADD_POLICY(
        object_schema   => USER,
        object_name     => 'MEDICAL_RESULTS',
        policy_name     => 'FGA_RESULTS_ACCESS',
        audit_column    => 'RESULT_VALUE,CONFIDENTIAL_NOTES',
        statement_types => 'SELECT',
        enable          => TRUE
    );
END;
/

-- ============================================================
-- 3.4 Testarea auditării
-- ============================================================

-- Test INSERT pe tabela APPOINTMENTS
INSERT INTO appointments (
    appointment_id,
    patient_id,
    doctor_id,
    appointment_date,
    appointment_time,
    status,
    reason,
    created_date
) VALUES (
    100,
    1,
    1,
    SYSDATE + 5,
    '09:30',
    'SCHEDULED',
    'Test audit programare',
    SYSDATE
);

-- Test UPDATE pe tabela CONSULTATIONS
UPDATE consultations
SET diagnosis = 'Diagnostic modificat pentru test audit',
    treatment = 'Tratament modificat pentru test audit'
WHERE consultation_id = 100;

-- Test DELETE pe tabela MEDICAL_RESULTS
INSERT INTO medical_results (
    result_id,
    patient_id,
    doctor_id,
    result_type,
    result_value,
    result_date,
    confidential_notes
) VALUES (
    100,
    1,
    1,
    'Test audit',
    'Valoare test',
    SYSDATE,
    'Observatie test'
);

DELETE FROM medical_results
WHERE result_id = 100;

COMMIT;

-- Verificarea înregistrărilor generate în AUDIT_LOG
SELECT 
    audit_id,
    username,
    action_type,
    table_name,
    record_id,
    action_date
FROM audit_log
ORDER BY audit_id;

-- ============================================================
-- CERINȚA 4: GESTIUNEA UTILIZATORILOR ȘI A RESURSELOR
-- 4.5 Implementarea utilizatorilor, cotelor și profilelor
-- ============================================================

-- Verificarea conexiunii curente
SELECT USER, SYS_CONTEXT('USERENV','CON_NAME') AS container_curent
FROM dual;

-- ============================================================
-- Crearea profilelor de resurse
-- ============================================================

CREATE PROFILE receptionist_profile LIMIT
    SESSIONS_PER_USER 2
    IDLE_TIME 20
    FAILED_LOGIN_ATTEMPTS 3;

CREATE PROFILE doctor_profile LIMIT
    SESSIONS_PER_USER 3
    IDLE_TIME 30
    FAILED_LOGIN_ATTEMPTS 3;

CREATE PROFILE lab_profile LIMIT
    SESSIONS_PER_USER 2
    IDLE_TIME 20
    FAILED_LOGIN_ATTEMPTS 3;

CREATE PROFILE auditor_profile LIMIT
    SESSIONS_PER_USER 1
    IDLE_TIME 40
    FAILED_LOGIN_ATTEMPTS 3;

CREATE PROFILE admin_profile LIMIT
    SESSIONS_PER_USER 5
    IDLE_TIME 60
    FAILED_LOGIN_ATTEMPTS 5;

-- ============================================================
-- Crearea utilizatorilor Oracle
-- ============================================================

CREATE USER receptionist_user IDENTIFIED BY Reception123
PROFILE receptionist_profile
QUOTA UNLIMITED ON SYSTEM;

CREATE USER doctor_user IDENTIFIED BY Doctor123
PROFILE doctor_profile
QUOTA UNLIMITED ON SYSTEM;

CREATE USER lab_user IDENTIFIED BY Lab123
PROFILE lab_profile
QUOTA UNLIMITED ON SYSTEM;

CREATE USER auditor_user IDENTIFIED BY Auditor123
PROFILE auditor_profile
QUOTA UNLIMITED ON SYSTEM;

CREATE USER medical_admin_user IDENTIFIED BY Admin123
PROFILE admin_profile
QUOTA UNLIMITED ON SYSTEM;

-- ============================================================
-- Acordarea dreptului minim de conectare
-- ============================================================

GRANT CREATE SESSION TO receptionist_user;
GRANT CREATE SESSION TO doctor_user;
GRANT CREATE SESSION TO lab_user;
GRANT CREATE SESSION TO auditor_user;
GRANT CREATE SESSION TO medical_admin_user;

-- ============================================================
-- Verificarea utilizatorilor creați
-- ============================================================

SELECT 
    username,
    account_status,
    profile
FROM dba_users
WHERE username IN (
    'RECEPTIONIST_USER',
    'DOCTOR_USER',
    'LAB_USER',
    'AUDITOR_USER',
    'MEDICAL_ADMIN_USER'
)
ORDER BY username;

-- ============================================================
-- Verificarea profilelor de resurse
-- ============================================================

SELECT 
    profile,
    resource_name,
    limit
FROM dba_profiles
WHERE profile IN (
    'RECEPTIONIST_PROFILE',
    'DOCTOR_PROFILE',
    'LAB_PROFILE',
    'AUDITOR_PROFILE',
    'ADMIN_PROFILE'
)
AND resource_name IN (
    'SESSIONS_PER_USER',
    'IDLE_TIME',
    'FAILED_LOGIN_ATTEMPTS'
)
ORDER BY profile, resource_name;

-- =====================================================
-- 5. PRIVILEGII SI ROLURI
-- Se ruleaza din SYSTEM, conectat la medpdb
-- =====================================================


-- =====================================================
-- 5.1 ROLURI DEFINITE IN SISTEM
-- =====================================================

CREATE ROLE RECEPTIONIST_ROLE;
CREATE ROLE DOCTOR_ROLE;
CREATE ROLE LAB_ROLE;
CREATE ROLE AUDITOR_ROLE;
CREATE ROLE ADMIN_ROLE;


-- Verificare roluri definite

SELECT role
FROM dba_roles
WHERE role IN (
    'RECEPTIONIST_ROLE',
    'DOCTOR_ROLE',
    'LAB_ROLE',
    'AUDITOR_ROLE',
    'ADMIN_ROLE'
)
ORDER BY role;


-- =====================================================
-- 5.2 PRIVILEGII DE SISTEM SI PRIVILEGII PE OBIECTE
-- =====================================================

-- Utilizatori operationali

CREATE USER MED_RECEPTIONIST_1 IDENTIFIED BY Reception123;
CREATE USER MED_DOCTOR_1 IDENTIFIED BY Doctor123;
CREATE USER MED_LAB_1 IDENTIFIED BY Lab123;
CREATE USER MED_AUDITOR_1 IDENTIFIED BY Auditor123;


-- Drept de conectare

GRANT CREATE SESSION TO MED_RECEPTIONIST_1;
GRANT CREATE SESSION TO MED_DOCTOR_1;
GRANT CREATE SESSION TO MED_LAB_1;
GRANT CREATE SESSION TO MED_AUDITOR_1;
GRANT CREATE SESSION TO MED_APP_ADMIN;


-- Privilegii pentru rolul de receptioner

GRANT SELECT ON MED_APP_ADMIN.PATIENTS TO RECEPTIONIST_ROLE;
GRANT SELECT, INSERT, UPDATE ON MED_APP_ADMIN.APPOINTMENTS TO RECEPTIONIST_ROLE;


-- Privilegii pentru rolul de medic

GRANT SELECT ON MED_APP_ADMIN.PATIENTS TO DOCTOR_ROLE;
GRANT SELECT ON MED_APP_ADMIN.APPOINTMENTS TO DOCTOR_ROLE;
GRANT SELECT, INSERT, UPDATE ON MED_APP_ADMIN.CONSULTATIONS TO DOCTOR_ROLE;
GRANT SELECT ON MED_APP_ADMIN.MEDICAL_RESULTS TO DOCTOR_ROLE;


-- Privilegii pentru rolul de laborator

GRANT SELECT ON MED_APP_ADMIN.PATIENTS TO LAB_ROLE;
GRANT SELECT, INSERT, UPDATE ON MED_APP_ADMIN.MEDICAL_RESULTS TO LAB_ROLE;


-- Privilegii pentru rolul de auditor

GRANT SELECT ON MED_APP_ADMIN.AUDIT_LOG TO AUDITOR_ROLE;


-- Privilegii pentru rolul de administrator

GRANT SELECT, INSERT, UPDATE, DELETE ON MED_APP_ADMIN.PATIENTS TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON MED_APP_ADMIN.DOCTORS TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON MED_APP_ADMIN.SPECIALIZATIONS TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON MED_APP_ADMIN.APPOINTMENTS TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON MED_APP_ADMIN.CONSULTATIONS TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON MED_APP_ADMIN.MEDICAL_RESULTS TO ADMIN_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON MED_APP_ADMIN.AUDIT_LOG TO ADMIN_ROLE;


-- Verificare privilegii pe obiecte

SELECT grantee, owner, table_name, privilege
FROM dba_tab_privs
WHERE grantee IN (
    'RECEPTIONIST_ROLE',
    'DOCTOR_ROLE',
    'LAB_ROLE',
    'AUDITOR_ROLE',
    'ADMIN_ROLE'
)
ORDER BY grantee, table_name, privilege;


-- =====================================================
-- 5.3 IERARHIA ROLURILOR
-- =====================================================

GRANT RECEPTIONIST_ROLE TO ADMIN_ROLE;
GRANT DOCTOR_ROLE TO ADMIN_ROLE;
GRANT LAB_ROLE TO ADMIN_ROLE;
GRANT AUDITOR_ROLE TO ADMIN_ROLE;


-- Verificare ierarhie roluri

SELECT grantee, granted_role
FROM dba_role_privs
WHERE grantee = 'ADMIN_ROLE'
ORDER BY granted_role;


-- =====================================================
-- 5.4 TESTAREA PRIVILEGIILOR ACORDATE
-- =====================================================

GRANT RECEPTIONIST_ROLE TO MED_RECEPTIONIST_1;
GRANT DOCTOR_ROLE TO MED_DOCTOR_1;
GRANT LAB_ROLE TO MED_LAB_1;
GRANT AUDITOR_ROLE TO MED_AUDITOR_1;
GRANT ADMIN_ROLE TO MED_APP_ADMIN;


-- Verificare roluri acordate utilizatorilor

SELECT grantee, granted_role
FROM dba_role_privs
WHERE grantee LIKE 'MED_%'
ORDER BY grantee, granted_role;

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

-- =====================================================
-- 7_MASCAREA_DATELOR
-- =====================================================


-- =====================================================
-- 7.2 FUNCTII DE MASCARE
-- =====================================================

CREATE OR REPLACE FUNCTION mask_cnp (
    p_cnp IN VARCHAR2
)
RETURN VARCHAR2
IS
BEGIN
    RETURN SUBSTR(p_cnp, 1, 1) || '***********' || SUBSTR(p_cnp, -1);
END;
/

CREATE OR REPLACE FUNCTION mask_email (
    p_email IN VARCHAR2
)
RETURN VARCHAR2
IS
BEGIN
    RETURN SUBSTR(p_email, 1, 2) || '****@****';
END;
/

CREATE OR REPLACE FUNCTION mask_phone (
    p_phone IN VARCHAR2
)
RETURN VARCHAR2
IS
BEGIN
    RETURN SUBSTR(p_phone, 1, 3) || '******' || SUBSTR(p_phone, -1);
END;
/

CREATE OR REPLACE FUNCTION mask_text (
    p_text IN VARCHAR2
)
RETURN VARCHAR2
IS
BEGIN
    RETURN '***DATE MASCATE***';
END;
/


-- Verificarea functiilor de mascare

SELECT
    mask_cnp('1980101123456') AS cnp_mascat,
    mask_email('pacient@email.com') AS email_mascat,
    mask_phone('0712345678') AS telefon_mascat,
    mask_text('Diagnostic confidential') AS text_mascat
FROM dual;


-- =====================================================
-- 7.3 VIEW-URI MASCATE
-- =====================================================

CREATE OR REPLACE VIEW v_patients_masked AS
SELECT
    patient_id,
    first_name,
    last_name,
    mask_cnp(cnp) AS cnp_masked,
    mask_email(email) AS email_masked,
    mask_phone(phone) AS phone_masked,
    mask_text(address) AS address_masked,
    date_of_birth,
    created_date
FROM patients;


CREATE OR REPLACE VIEW v_medical_results_masked AS
SELECT
    result_id,
    patient_id,
    doctor_id,
    result_type,
    mask_text(result_value) AS result_value_masked,
    result_date,
    mask_text(confidential_notes) AS confidential_notes_masked
FROM medical_results;


-- Verificarea view-urilor mascate

SELECT *
FROM v_patients_masked;

SELECT *
FROM v_medical_results_masked;


-- =====================================================
-- 7.4 TESTAREA MASCARII
-- =====================================================

-- Date originale

SELECT patient_id, first_name, last_name, cnp, email, phone, address
FROM patients;


-- Date mascate

SELECT patient_id, first_name, last_name, cnp_masked, email_masked, phone_masked, address_masked
FROM v_patients_masked;