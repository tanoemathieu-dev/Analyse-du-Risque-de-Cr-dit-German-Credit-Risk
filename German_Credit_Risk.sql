CREATE DATABASE projet8;
USE projet8;
CREATE TABLE German_Credit_Risk (
client_id INT AUTO_INCREMENT PRIMARY KEY,
status VARCHAR (150),
duration SMALLINT,
credit_history VARCHAR (150),
purpose VARCHAR (150),
amount INT,
savings VARCHAR (150),
employment_duration VARCHAR (150),
installment_rate TINYINT,
personal_status_sex VARCHAR (150),
other_debtors VARCHAR (150),
present_residence TINYINT,
property VARCHAR (150),
age TINYINT,
other_installment_plans VARCHAR (150),
housing VARCHAR (150),
number_credits TINYINT,
job VARCHAR (200),
people_liable TINYINT,
telephone VARCHAR (20),
foreign_worker VARCHAR (10),
credit_risk TINYINT
)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;	

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/German_Credit_Risk.csv'
INTO TABLE German_Credit_Risk 
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(status, duration, credit_history, purpose, amount, savings,
 employment_duration, installment_rate, personal_status_sex, other_debtors,
 present_residence, property, age, other_installment_plans, housing,
 number_credits, job, people_liable, telephone, foreign_worker, credit_risk);
 SELECT COUNT(*) FROM German_Credit_Risk ;
 
-- Verification des valeurs NULL sur les colonnes 

SELECT
    SUM(status IS NULL) AS null_status,
    SUM(duration IS NULL) AS null_duration,
    SUM(credit_history IS NULL) AS null_credit_history,
    SUM(purpose IS NULL) AS null_purpose,
    SUM(amount IS NULL) AS null_amount,
    SUM(savings IS NULL) AS null_savings,
    SUM(employment_duration IS NULL) AS null_employment_duration,
    SUM(installment_rate IS NULL) AS null_installment_rate,
    SUM(personal_status_sex IS NULL) AS null_personal_status_sex,
    SUM(other_debtors IS NULL) AS null_other_debtors,
    SUM(present_residence IS NULL) AS null_present_residence,
    SUM(property IS NULL) AS null_property,
    SUM(age IS NULL) AS null_age,
    SUM(other_installment_plans IS NULL) AS null_other_installment_plans,
    SUM(housing IS NULL) AS null_housing,
    SUM(number_credits IS NULL) AS null_number_credits,
    SUM(job IS NULL) AS null_job,
    SUM(people_liable IS NULL) AS null_people_liable,
    SUM(telephone IS NULL) AS null_telephone,
    SUM(foreign_worker IS NULL) AS null_foreign_worker,
    SUM(credit_risk IS NULL) AS null_credit_risk
FROM German_Credit_Risk;

-- Verification des doublons (hors client_id)
SELECT status, duration, credit_history, purpose, amount, savings,
       employment_duration, installment_rate, personal_status_sex,
       other_debtors, present_residence, property, age,
       other_installment_plans, housing, number_credits, job,
       people_liable, telephone, foreign_worker, credit_risk,
       COUNT(*) AS occurrences
FROM German_Credit_Risk
GROUP BY status, duration, credit_history, purpose, amount, savings,
         employment_duration, installment_rate, personal_status_sex,
         other_debtors, present_residence, property, age,
         other_installment_plans, housing, number_credits, job,
         people_liable, telephone, foreign_worker, credit_risk
HAVING COUNT(*) > 1;


