import sqlite3
import pandas as pd

DB="Hospital_Readmission_Analytics.db"
conn=sqlite3.connect(DB)

print("\n=== HOSPITAL READMISSION DASHBOARD ===")
q="""
SELECT COUNT(*) total_admissions,
       COUNT(DISTINCT patient_id) unique_patients,
       SUM(readmission_flag) total_readmissions,
       ROUND(100.0*SUM(readmission_flag)/COUNT(*),2) readmission_rate_pct,
       ROUND(AVG(length_of_stay),2) avg_length_of_stay,
       ROUND(AVG(billing_amount),2) avg_billing
FROM admissions;
"""
print(pd.read_sql_query(q,conn).to_string(index=False))

print("\n=== TOP READMISSION CONDITIONS ===")
q="""
SELECT medical_condition,
       COUNT(*) admissions,
       SUM(readmission_flag) readmissions,
       ROUND(100.0*SUM(readmission_flag)/COUNT(*),2) readmission_rate_pct
FROM admissions
GROUP BY medical_condition
ORDER BY readmission_rate_pct DESC;
"""
print(pd.read_sql_query(q,conn).to_string(index=False))

conn.close()
