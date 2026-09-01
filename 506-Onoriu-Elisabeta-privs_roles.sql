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