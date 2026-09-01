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