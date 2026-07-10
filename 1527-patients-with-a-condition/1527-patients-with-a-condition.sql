select patient_id, patient_name, conditions from Patients where concat(' ' ,conditions) ilike '% 
DIAB1%';
{"headers":{"Patients":["patient_id","patient_name","conditions"]},"rows":{"Patients":[[1,"Daniel","YFEV COUGH"],[2,"Alice",""],[3,"Bob","DIAB100 MYOP"],[4,"George","ACNE DIAB100"],[5,"Alain","DIAB201"]]}}
| patient_id | patient_name | conditions   |
| ---------- | ------------ | ------------ |
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |
| patient_id | patient_name | conditions   |
| ---------- | ------------ | ------------ |
| 3          | Bob          | DIAB100 MYOP |
| 4          | George       | ACNE DIAB100 |