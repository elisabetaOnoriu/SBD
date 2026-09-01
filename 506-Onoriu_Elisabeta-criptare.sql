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