-- HOSPITAL READMISSION & PATIENT ANALYTICS
-- SQLite
-- Definition: readmission = subsequent admission within 30 days
-- of previous discharge.

-- 1. Overall KPIs
SELECT
 COUNT(*) AS total_admissions,
 COUNT(DISTINCT patient_id) AS unique_patients,
 SUM(readmission_flag) AS total_readmissions,
 ROUND(100.0*SUM(readmission_flag)/COUNT(*),2) AS readmission_rate_pct,
 ROUND(AVG(length_of_stay),2) AS avg_length_of_stay,
 ROUND(AVG(billing_amount),2) AS avg_billing
FROM admissions;

-- 2. Readmission by department
SELECT d.department_name,
 COUNT(*) AS admissions,
 SUM(a.readmission_flag) AS readmissions,
 ROUND(100.0*SUM(a.readmission_flag)/COUNT(*),2) AS readmission_rate_pct
FROM admissions a
JOIN departments d ON a.department_id=d.department_id
GROUP BY d.department_id,d.department_name
ORDER BY readmission_rate_pct DESC;

-- 3. Readmission by condition
SELECT medical_condition,
 COUNT(*) AS admissions,
 SUM(readmission_flag) AS readmissions,
 ROUND(100.0*SUM(readmission_flag)/COUNT(*),2) AS readmission_rate_pct
FROM admissions
GROUP BY medical_condition
ORDER BY readmission_rate_pct DESC;

-- 4. Readmission by age group
SELECT
 CASE WHEN p.age<18 THEN 'Under 18'
      WHEN p.age<40 THEN '18-39'
      WHEN p.age<60 THEN '40-59'
      WHEN p.age<75 THEN '60-74'
      ELSE '75+'
 END AS age_group,
 COUNT(*) AS admissions,
 SUM(a.readmission_flag) AS readmissions,
 ROUND(100.0*SUM(a.readmission_flag)/COUNT(*),2) AS readmission_rate_pct
FROM admissions a
JOIN patients p ON a.patient_id=p.patient_id
GROUP BY age_group
ORDER BY readmission_rate_pct DESC;

-- 5. Readmission by admission type
SELECT admission_type,
 COUNT(*) AS admissions,
 SUM(readmission_flag) AS readmissions,
 ROUND(100.0*SUM(readmission_flag)/COUNT(*),2) AS readmission_rate_pct
FROM admissions
GROUP BY admission_type
ORDER BY readmission_rate_pct DESC;

-- 6. Readmitted patients
SELECT p.patient_id,p.patient_name,
 COUNT(*) AS total_admissions,
 SUM(a.readmission_flag) AS readmissions,
 ROUND(SUM(a.billing_amount),2) AS total_billing
FROM admissions a
JOIN patients p ON a.patient_id=p.patient_id
GROUP BY p.patient_id,p.patient_name
HAVING SUM(a.readmission_flag)>0
ORDER BY readmissions DESC,total_admissions DESC;

-- 7. Doctor workload
SELECT d.doctor_name,
 COUNT(*) AS admissions,
 SUM(a.readmission_flag) AS readmissions,
 ROUND(AVG(a.length_of_stay),2) AS avg_length_of_stay
FROM admissions a
JOIN doctors d ON a.doctor_id=d.doctor_id
GROUP BY d.doctor_id,d.doctor_name
ORDER BY admissions DESC;

-- 8. Billing: readmitted vs non-readmitted
SELECT readmission_status,
 COUNT(*) AS admissions,
 ROUND(AVG(billing_amount),2) AS avg_billing,
 ROUND(SUM(billing_amount),2) AS total_billing
FROM admissions
GROUP BY readmission_status;

-- 9. Multiple-admission patients
SELECT p.patient_name,COUNT(*) AS admissions
FROM patients p
JOIN admissions a ON p.patient_id=a.patient_id
GROUP BY p.patient_id,p.patient_name
HAVING COUNT(*)>1
ORDER BY admissions DESC;

-- 10. INNER JOIN
SELECT p.patient_name,d.doctor_name,dept.department_name,
       a.medical_condition,a.readmission_status
FROM patients p
INNER JOIN admissions a ON p.patient_id=a.patient_id
INNER JOIN doctors d ON a.doctor_id=d.doctor_id
INNER JOIN departments dept ON a.department_id=dept.department_id;

-- 11. LEFT JOIN
SELECT p.patient_id,p.patient_name,a.admission_id,a.readmission_status
FROM patients p
LEFT JOIN admissions a ON p.patient_id=a.patient_id;

-- 12. RIGHT JOIN equivalent in SQLite:
-- reverse table order and use LEFT JOIN
SELECT a.admission_id,p.patient_id,p.patient_name,a.readmission_status
FROM admissions a
LEFT JOIN patients p ON a.patient_id=p.patient_id;
