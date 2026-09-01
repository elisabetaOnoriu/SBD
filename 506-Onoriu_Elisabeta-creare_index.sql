CREATE INDEX idx_appointments_patient_id
ON appointments(patient_id);

CREATE INDEX idx_appointments_doctor_id
ON appointments(doctor_id);

CREATE INDEX idx_consultations_patient_id
ON consultations(patient_id);

CREATE INDEX idx_consultations_doctor_id
ON consultations(doctor_id);

CREATE INDEX idx_results_patient_id
ON medical_results(patient_id);

CREATE INDEX idx_results_doctor_id
ON medical_results(doctor_id);

CREATE INDEX idx_db_users_role_id
ON db_users(role_id);

CREATE INDEX idx_audit_username
ON audit_log(username);

CREATE INDEX idx_audit_table_name
ON audit_log(table_name);