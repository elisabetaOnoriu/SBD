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