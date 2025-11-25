-- Import companies data
COPY companies(company_id, company_name, industry, company_size, headquarters_location, website, created_date)
FROM 'C:\sql_data_job_analysis\data\companies.csv'
DELIMITER ',' CSV HEADER;

-- Import skills data  
COPY skills(skill_id, skill_name, skill_category)
FROM 'C:\sql_data_job_analysis\data\skills.csv'
DELIMITER ',' CSV HEADER;

-- Import job_postings data
COPY job_postings(job_id, company_id, job_title, job_description, salary_min, salary_max, job_location, job_type, experience_level, application_deadline, posting_date)
FROM 'C:\sql_data_job_analysis\data\job_postings.csv'
DELIMITER ',' CSV HEADER;

-- Import job_skills data
COPY job_skills(job_id, skill_id, skill_importance)
FROM 'C:\sql_data_job_analysis\data\job_skills.csv' 
DELIMITER ',' CSV HEADER;

-- Import applications data
COPY applications(application_id, job_id, applicant_name, applicant_email, application_date, application_status, resume_file_path, cover_letter_text)
FROM 'C:\sql_data_job_analysis\data\applications.csv'
DELIMITER ',' CSV HEADER;


SELECT * FROM companies;
SELECT * FROM skills;
SELECT * FROM job_postings;
SELECT * FROM job_skills;
SELECT * FROM applications;

-- Verify data was imported correctly
SELECT 'Companies: ' || COUNT(*)::TEXT as count FROM companies
UNION ALL
SELECT 'Skills: ' || COUNT(*)::TEXT as count FROM skills  
UNION ALL
SELECT 'Job Postings: ' || COUNT(*)::TEXT as count FROM job_postings
UNION ALL
SELECT 'Job Skills: ' || COUNT(*)::TEXT as count FROM job_skills
UNION ALL
SELECT 'Applications: ' || COUNT(*)::TEXT as count FROM applications;