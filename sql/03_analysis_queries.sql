-- REMOVE micro seconds for timestamp at companies table
ALTER TABLE companies 
ALTER COLUMN created_date TYPE TIMESTAMP(0);


-- Change timestamp with timezone
ALTER TABLE companies 
ALTER COLUMN created_date TYPE TIMESTAMP WITH TIME ZONE;

ALTER TABLE applications 
ALTER COLUMN application_date TYPE TIMESTAMP WITH TIME ZONE;

ALTER TABLE applications 
ALTER COLUMN status_updated_date TYPE TIMESTAMP WITH TIME ZONE;


-- Show timestamps in different timezones
SELECT 
    application_date as original,    application_date AT TIME ZONE 'Asia/Yangon' as yangon_time,
    application_date AT TIME ZONE 'UTC' as utc_time,
    application_date AT TIME ZONE 'America/New_York' as new_york_time,
    -- Myanmar timezone extracts
    EXTRACT(DOW FROM (application_date AT TIME ZONE 'Asia/Yangon')) AS yangon_day_of_week,
    EXTRACT(HOUR FROM (application_date AT TIME ZONE 'Asia/Yangon')) AS yangon_hour_of_day,
    EXTRACT(QUARTER FROM (application_date AT TIME ZONE 'Asia/Yangon')) AS yangon_quarter,
    -- US timezone extracts  
    EXTRACT(DOW FROM (application_date AT TIME ZONE 'America/New_York')) AS us_day_of_week,
    EXTRACT(HOUR FROM (application_date AT TIME ZONE 'America/New_York')) AS us_hour_of_day,
    EXTRACT(QUARTER FROM (application_date AT TIME ZONE 'America/New_York')) AS us_quarter,
    -- UTC extracts
    EXTRACT(DOW FROM (application_date AT TIME ZONE 'UTC')) AS utc_day_of_week,
    EXTRACT(HOUR FROM (application_date AT TIME ZONE 'UTC')) AS utc_hour_of_day
FROM applications
LIMIT 5;

SELECT * FROM companies

UPDATE companies
SET created_date = '2025-1-22 16:12:27+06:30'
WHERE company_id = 2;

SELECT *
FROM companies
WHERE EXTRACT(MONTH FROM created_date AT TIME ZONE 'Asia/Yangon') = 1;

-- Truncate in correct order
TRUNCATE TABLE applications, job_skills, skills, job_postings, companies 
RESTART IDENTITY;


-- update data safety
BEGIN TRANSACTION;
UPDATE job_postings SET is_active = false WHERE company_id = 5;
UPDATE applications SET application_status = 'position_closed' 
WHERE job_id IN (SELECT job_id FROM job_postings WHERE company_id = 5);
COMMIT;


-- Case expression
-- Detailed application view
SELECT 
    applicant_name,
    application_status,
    CASE 
        WHEN LOWER(TRIM(application_status)) IN ('applied', 'under_review') THEN 'In Progress'
        WHEN LOWER(TRIM(application_status)) = 'interview' THEN 'Interview Stage'
        WHEN LOWER(TRIM(application_status)) IN ('rejected', 'withdrawn') THEN 'Closed'
        WHEN LOWER(TRIM(application_status)) = 'offered' THEN 'Successful'
        ELSE 'Other'
    END as status_group
FROM applications
ORDER BY status_group DESC;

-- Summary statistics  
SELECT 
    CASE 
        WHEN LOWER(TRIM(application_status)) IN ('applied', 'reviewed') THEN 'In Progress'
        WHEN LOWER(TRIM(application_status)) = 'interview' THEN 'Interview Stage'
        WHEN LOWER(TRIM(application_status)) IN ('rejected') THEN 'Closed'
        WHEN LOWER(TRIM(application_status)) = 'offered' THEN 'Successful'
        ELSE 'Other'
    END as status_group,
    COUNT(*) as total_applications
FROM applications
GROUP BY 1
ORDER BY total_applications DESC;


-- Find jobs with above-average salary
SELECT job_title, salary_min
FROM job_postings
WHERE salary_min > (
    SELECT AVG(salary_min)          
    FROM job_postings               
);


-- Find applications for Technology companies
SELECT applicant_name, application_status
FROM applications
WHERE job_id IN (
    SELECT job_id                   
    FROM job_postings                
    WHERE company_id IN (
        SELECT company_id            
        FROM companies 
        WHERE industry = 'Technology'
    )
);

-- Show each company with their job count
SELECT 
    company_name,
    (SELECT COUNT(*) 
     FROM job_postings 
     WHERE job_postings.company_id = companies.company_id) as job_count
FROM companies;

-- Skills that appear in more than 3 jobs
SELECT skill_name
FROM skills
WHERE skill_id IN (
    SELECT skill_id
    FROM (
        SELECT skill_id, COUNT(*) as job_count
        FROM job_skills
        GROUP BY skill_id
    ) as skill_counts
    WHERE job_count > 3        
);

-- Applicants who applied for remote jobs
SELECT applicant_name 
FROM Applications
WHERE job_id IN (
    SELECT job_id
    FROM job_postings
    WHERE LOWER(TRIM(job_type)) = 'remote'
)

-- Companies with the most applications
SELECT company_name 
FROM companies
WHERE company_id IN (
    SELECT company_id
    FROM job_postings
    WHERE job_id IN (
        SELECT job_id  
        FROM applications
        GROUP BY job_id
        HAVING COUNT(application_id) >= 2
    )
)

SELECT c.company_name,
COUNT(a.application_id) AS total_application 
FROM companies c
JOIN job_postings j ON c.company_id = j.company_id 
JOIN applications a ON j.job_id = a.job_id
GROUP BY c.company_name
ORDER BY total_application DESC;


-- using CTE to find top 3 companies by application count
WITH CompanyApplicationCounts AS (
    SELECT 
        c.company_id,
        c.company_name,
        (
            SELECT COUNT(a.application_id)
            FROM job_postings jp, applications a
            WHERE jp.job_id = a.job_id
            AND jp.company_id = c.company_id
        ) as total_applications
    FROM companies c
)
SELECT company_name, total_applications
FROM CompanyApplicationCounts
WHERE total_applications >= 2
ORDER BY total_applications DESC
LIMIT 3;

-- Show all job applications with company names and job titles
SELECT a.application_id, a.applicant_name, c.company_name, j.job_title
FROM applications a 
JOIN job_postings j ON a.job_id = j.job_id
JOIN companies c ON j.company_id = c.company_id
ORDER BY a.application_id ;

-- Using CTE to find companies that have more than 2 job postings, then show their average salary 
WITH companiesWithManyJobs AS (
   SELECT c.company_id, c.company_name, COUNT(jp.company_id) AS total_job_postings
   FROM companies c 
   JOIN job_postings jp ON c.company_id = jp.company_id
   GROUP BY c.company_id, c.company_name
   HAVING COUNT(jp.company_id) >= 2
   ORDER BY  c.company_id, total_job_postings DESC
),
companyAverageSalary AS (
    SELECT c.company_id, c.company_name,
    ROUND(AVG((jp.salary_min + jp.salary_max)/2),0) AS average_salary
    FROM companiesWithManyJobs c
    JOIN job_postings jp ON c.company_id = jp.company_id
    WHERE jp.salary_max IS NOT NULL AND jp.salary_min IS NOT NULL
    GROUP BY c.company_id, c.company_name 
)
SELECT cm.total_job_postings, cm.company_name, cas.average_salary
FROM companiesWithManyJobs cm
JOIN companyAverageSalary cas ON cm.company_id = cas.company_id
ORDER BY cas.average_salary DESC;

-- All name from database
SELECT company_name as name, 'Company' as type
FROM companies
UNION
SELECT applicant_name as name, 'Applicant' as type
FROM applications;

-- All system activities for audit log
SELECT 
     job_title AS activity_name,
     posting_date AS activity_date,
     'Job posted' AS activity_type
FROM job_postings
UNION ALL 
SELECT 
    CONCAT('Application for' ,jp.job_title) AS activity_name,
    a.application_date AS activity_date,
    'Application submitted' AS activity_type
    FROM job_postings jp
    JOIN applications a ON jp.job_id = a.job_id

ORDER BY activity_type;


-- Salary Evolution for Roles:
SELECT 
    job_title,
    posting_date,
    salary_min,
    LAG(salary_min) OVER (
        PARTITION BY job_title 
        ORDER BY posting_date
    ) as prev_salary,
    CASE 
        WHEN LAG(salary_min) OVER (PARTITION BY job_title ORDER BY posting_date) IS NOT NULL
        THEN ROUND((salary_min - LAG(salary_min) OVER (PARTITION BY job_title ORDER BY posting_date)) * 100.0 / 
                   LAG(salary_min) OVER (PARTITION BY job_title ORDER BY posting_date), 2)
        ELSE NULL
    END as salary_change_percent
FROM job_postings
WHERE job_title = 'Data Analyst'
ORDER BY posting_date;

--RANK Skills by Demand (Most Requested Skills)
WITH SkillDemand AS (
    SELECT 
        s.skill_name,
        s.skill_category,
        COUNT(js.job_id) as job_count
    FROM skills s
    JOIN job_skills js ON s.skill_id = js.skill_id
    GROUP BY s.skill_id, s.skill_name, s.skill_category
)
SELECT 
    skill_name,
    skill_category,
    job_count,
    RANK() OVER (ORDER BY job_count DESC) as overall_rank,
    RANK() OVER (PARTITION BY skill_category ORDER BY job_count DESC) as category_rank
FROM SkillDemand
ORDER BY overall_rank;

SELECT setval('companies_company_id_seq', (SELECT MAX(company_id) FROM companies) + 1);

SELECT nextval('companies_company_id_seq');

INSERT INTO companies (company_name, industry, company_size, headquarters_location, website)
VALUES ('OpenAI', 'Artificial Intelligence', '1000+', 'San Francisco, CA', 'https://openai.com');

INSERT INTO companies (company_name, industry, company_size, headquarters_location, website)
VALUES ('AI TECH X', 'Artificial Intelligence', '1000+', 'Mandalay region', 'https://openai.com');
