# Hospital Readmission & Patient Analytics

**SQL + SQLite + Python**

## Project Goal
Analyze hospital admission data to measure **30-day readmissions**, identify
where readmissions are concentrated, and compare patient utilization,
length of stay and billing.

## Key KPIs
- Total admissions: 2,356
- Unique patients: 1,500
- 30-day readmissions: 139
- Readmission rate: 5.90%
- Average length of stay: 8.16 days
- Average billing: 23,733.24

## Readmission Logic
A patient's admission is marked as a readmission when it occurs **0–30 days
after the patient's previous discharge**.

This is an analytical project definition, not a clinical reporting standard.

## Analyses
1. Overall readmission rate
2. Department-wise readmission
3. Condition-wise readmission
4. Age-group readmission
5. Admission-type readmission
6. Readmitted patient frequency
7. Doctor workload
8. Billing comparison
9. Multiple-admission patients
10. INNER JOIN
11. LEFT JOIN
12. SQLite RIGHT JOIN equivalent

## Database
```text
patients
   |
   +----< admissions >---- doctors
                 |
                 +-------- departments
```

## Files
```text
data/
  patients.csv
  departments.csv
  doctors.csv
  admissions.csv

sql/
  analysis_queries.sql

results/
  CSV outputs for each analysis

Hospital_Readmission_Analytics.db
run_analysis.py
README.md
```

## Run
```bash
python run_analysis.py
```

Open `Hospital_Readmission_Analytics.db` in DB Browser for SQLite.
