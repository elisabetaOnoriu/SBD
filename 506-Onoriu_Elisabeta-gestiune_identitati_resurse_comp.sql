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