                    
                    
				-- ====================================================--
					-- PROJECT :	HOSPITAL DATA ANALYZE--		 
                -- ====================================================-

create database hospital_data;

-- Departments Table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100)
);

-- Doctors Table
CREATE TABLE doctors (
    doctor_id INT PRIMARY KEY,
    name VARCHAR(100),
    specialization VARCHAR(100),
    experience_years INT
);

-- Patients Table
CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    admission_date DATE,
    discharge_date DATE
);

-- Visits Table
CREATE TABLE visits (
    visit_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    department_id INT,
    visit_date DATE,
    diagnosis TEXT,
    treatment_cost DECIMAL(10,2),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Medications Table
CREATE TABLE medications (
    medication_id INT PRIMARY KEY,
    visit_id INT,
    medicine_name VARCHAR(100),
    dosage VARCHAR(50),
    cost DECIMAL(10,2),
    FOREIGN KEY (visit_id) REFERENCES visits(visit_id)
);


-- Insert into Departments
INSERT INTO departments VALUES
(1, 'Cardiology'),
(2, 'Neurology'),
(3, 'Pediatrics');

-- Insert into Doctors
INSERT INTO doctors VALUES
(101, 'Dr. Ramesh Singh', 'Cardiology', 12),
(102, 'Dr. Anjali Mehta', 'Neurology', 8),
(103, 'Dr. Vivek Kumar', 'Pediatrics', 5);

-- Insert into Patients
INSERT INTO patients VALUES
(1001, 'Rahul Sharma', 45, 'Male', '2023-12-01', '2023-12-07'),
(1002, 'Sneha Gupta', 30, 'Female', '2024-01-15', '2024-01-20'),
(1003, 'Amit Yadav', 5, 'Male', '2024-03-10', '2024-03-14');

-- Insert into Visits
INSERT INTO visits VALUES
(201, 1001, 101, 1, '2023-12-02', 'Chest pain', 5500.00),
(202, 1002, 102, 2, '2024-01-16', 'Migraine', 4200.00),
(203, 1003, 103, 3, '2024-03-11', 'Fever and cold', 3000.00);

-- Insert into Medications
INSERT INTO medications VALUES
(301, 201, 'MedCardio', '1 tablet daily', 300.00),
(302, 202, 'NeuroPlus', '2 tablets daily', 450.00),
(303, 203, 'Paracetamol', '1 tablet twice', 150.00);


select* from departments;
select* from doctors;
select* from medications;
select* from patients;
select* from visits;

-- ============--
-- QUESTION --
-- ===========--

-- Q1. Total number of patients admited per department 

select d.department_name,count(distinct v.patient_id)as total_patients
from visits v 
join departments d on v.department_id=d.department_id
group by d.department_name;

-- Q2. Average treatment cost per department 

select d.department_name, round(avg(v.treatment_cost),2)as avg_treatment_cost
from visits v 
join departments d on v.department_id=d.department_id
group by d.department_name;

-- Q3. total medication cost per patient 

select p.name as patient_name,sum(m.cost)as total_medication_cost
from patients p 
join visits v on p.patient_id=v.patient_id
join medications m on m.visit_id=v.visit_id
group by p.name;

-- Q4. find top 1 doctor who handled the most patient 

select d.name,count(*)as total_visits
from visits v 
join doctors d on v.doctor_id=d.doctor_id
group by d.name
order by count(*) desc
limit 1;

-- Q5. gender whise patient count 

select gender,count(*)as total_patients
from patients
group by gender;

-- Q6. repeat patient (visited more then one)

select patient_id,count(*)as total_visits
from visits 
group by patient_id
order by count(*)>1;

-- Q7. average length of hospital stay per patients 

SELECT name, 
       DATEDIFF(discharge_date, admission_date) AS days_in_hospital
FROM patients;

-- Q8. daily revenue from treatment 

select visit_date,sum(treatment_cost)as daily_revenue
from visits
group by visit_date
order by visit_date;

-- Q9. rank doctor by treatment revenue generated 

select d.name as doctor_name,sum(v.treatment_cost)as total_revenue,
rank() over(order by sum(v.treatment_cost)desc)as doctor_rnk
from visits v 
join doctors d on v.doctor_id=d.doctor_id
group by d.name;

-- Q10. list all patient with their department and doctor 

select p.name as patient,dept. department_name,d.name as doctor
from visits v 
join patients p on v.patient_id=p.patient_id
join doctors d on v.doctor_id=d.doctor_id
join departments dept on v.department_id=dept.department_id;

