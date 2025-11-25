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
TRUNCATE TABLE applications, job_skills, job_postings, companies 
RESTART IDENTITY;

-- Case expression
SELECT 
    applicant_name,
    application_status,
    CASE 
        WHEN LOWER(TRIM(application_status)) IN ('applied', 'under_review') THEN 'In Progress'
        WHEN LOWER(TRIM(application_status)) = 'interview' THEN 'Interview Stage'
        WHEN LOWER(TRIM(application_status)) IN ('rejected', 'withdrawn') THEN 'Closed'
        WHEN LOWER(TRIM(application_status)) = 'accepted' THEN 'Successful'
        ELSE 'Other'
    END as status_group,
FROM applications
ORDER BY status_group  DESC;

SELECT 
    CASE 
        WHEN LOWER(TRIM(application_status)) IN ('applied', 'under_review') THEN 'In Progress'
        WHEN LOWER(TRIM(application_status)) = 'interview' THEN 'Interview Stage'
        WHEN LOWER(TRIM(application_status)) IN ('rejected', 'withdrawn') THEN 'Closed'
        WHEN LOWER(TRIM(application_status)) = 'accepted' THEN 'Successful'
        ELSE 'Other'
    END as status_group,
    COUNT(*) as total_applications
FROM applications
ORDER BY status_group, total_applications  DESC;
