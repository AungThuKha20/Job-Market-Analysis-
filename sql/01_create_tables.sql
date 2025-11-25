-- 1. companies table
CREATE TABLE companies (
    company_id SERIAL PRIMARY KEY,
    company_name VARCHAR(255) NOT NULL,
    industry VARCHAR(100),
    company_size VARCHAR(50),
    headquarters_location VARCHAR(100),
    website VARCHAR(255),
    created_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. job_postings table
CREATE TABLE job_postings (
    job_id SERIAL PRIMARY KEY,
    company_id INTEGER REFERENCES companies(company_id),
    job_title VARCHAR(255) NOT NULL,
    job_description TEXT,
    salary_min INTEGER,
    salary_max INTEGER,
    salary_currency VARCHAR(10) DEFAULT 'USD',
    job_location VARCHAR(100),
    job_type VARCHAR(50), -- Remote, On-site, Hybrid
    experience_level VARCHAR(50), -- Entry, Mid, Senior
    application_deadline DATE,
    posting_date DATE DEFAULT CURRENT_DATE,
    is_active BOOLEAN DEFAULT TRUE
);

-- 3. skills table
CREATE TABLE skills (
    skill_id SERIAL PRIMARY KEY,
    skill_name VARCHAR(100) NOT NULL UNIQUE,
    skill_category VARCHAR(100) 
);

-- 4. job_skills table (Many-to-Many relationship)
CREATE TABLE job_skills (
    job_id INTEGER REFERENCES job_postings(job_id),
    skill_id INTEGER REFERENCES skills(skill_id),
    skill_importance VARCHAR(50) DEFAULT 'Required', -- Required, Preferred, Optional
    PRIMARY KEY (job_id, skill_id)
);

-- 5. applications table
CREATE TABLE applications (
    application_id SERIAL PRIMARY KEY,
    job_id INTEGER REFERENCES job_postings(job_id),
    applicant_name VARCHAR(255),
    applicant_email VARCHAR(255),
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resume_file_path VARCHAR(500),
    cover_letter_text TEXT,
    application_status VARCHAR(50) DEFAULT 'Applied', -- Applied, Reviewed, Interview, Rejected, Offered
    status_updated_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_job_postings_company ON job_postings(company_id);
CREATE INDEX idx_job_postings_location ON job_postings(job_location);
CREATE INDEX idx_job_skills_job ON job_skills(job_id);
CREATE INDEX idx_job_skills_skill ON job_skills(skill_id);
CREATE INDEX idx_applications_job ON applications(job_id);
CREATE INDEX idx_applications_status ON applications(application_status);

-- Display confirmation
SELECT 'All tables created successfully!' as status;

-- Check owner
SELECT tablename, tableowner 
FROM pg_tables 
WHERE schemaname = 'public';




