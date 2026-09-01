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