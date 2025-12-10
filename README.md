# End-to-End Live Job Market Analysis  
PostgreSQL → Power Query → Real-Time Excel Dashboard

## Project Overview
SQL analysis of job posting data with application tracking, company insights, and skills demand analytics. Features advanced SQL techniques including complex JOINs, CTEs, window functions, and multi-timezone analysis.

## Database Schema
- companies - Company details & industry info
- job_postings - Job listings with salaries & locations  
- applications - Application tracking with status
- skills - Skill catalog with categories
- job_skills - Job-skill relationships

## Key Features
- Multi-timezone date analysis (Asia/Yangon, UTC, EST)
- Salary trends & evolution tracking
- Company hiring analytics with JOIN operations
- Skills demand ranking with window functions
- Application status categorization
- JOIN queries for business insights
- CTE and subquery optimizations
- Live PostgreSQL → Excel connection (real-time refresh)
- Interactive Excel dashboard (slicers + charts)
- Skills aggregation (many-to-many → one clean list per job)

## Tech Used
- PostgreSQL
- Advanced SQL (CTEs, Window Functions, Subqueries)
- Complex JOIN operations
- Query optimization with indexing
- Transaction safety
- Power Query (Excel)
- Live ODBC connection

## Files
- `create_tables.sql` - Database schema & indexes
- `import_csv_data.sql` - CSV data import scripts
- `analysis_queries.sql` - Main analysis queries
- `data/` - CSV files for data import
- `ER_diagram.png` - Database relationship diagram
- `data_job_analysis_dashboard.xlsx` - **Live Excel dashboard (open → Refresh All)**

## Quick Start
```bash
# Connect to database
psql job_market_analysis

# Run setup scripts
\i sql/create_tables.sql
\i sql/import_csv_data.sql
\i sql/analysis_queries.sql

### Key Highlights 

----- Salary -----
* Average maximum salary offered: USD 1,598 per month  
* Market pays well for senior and specialized roles

----- Experience Level -----
* Senior roles                  → 50% of all postings  
* Mid-level roles               → 40%  
* Entry-level / Junior          → only 10%  
* Very tough for fresh grads right now

----- Top 5 Highest-Paying Titles (Avg. Max Salary) -----
* 1. Senior Data Scientist       → USD 2,450  
* 2. Machine Learning Engineer   → USD 2,220  
* 3. Senior Data Engineer        → USD 2,026  
* 4. Cloud Engineer              → USD 1,780  
* 5. Senior Data Analyst         → USD 1,600

----- Most In-Demand Skills -----
* Python               → required in 42% of jobs  
* SQL                  → required in 40% of jobs  
* Statistics           → 24%  
* Excel                → 22%  
* AWS                  → 20%  
* Docker               → 20%  
* Machine Learning     → 18%  
* Scikit-learn         → 12%  
* Azure                → 10%

----- Work Arrangement -----
* On-site   → 38%  
* Hybrid  → 32%  
* Remote  → 30%

----- Geographic Hotspots -----
* Yangon          → 7 postings  
* Mandalay        → 4 postings  
* Ayeyarwady      → 4 postings  
* Sagaing         → 4 postings  
* Bago            → 4 postings  
* Rest of Myanmar → 2–3 each

----- Application Pipeline (current snapshot) -----
* Reviewed   → 17  
* Applied    → 16  
* Interview  → 15  
* Offered    → only 2 → very selective!

### Conclusion
If you have Python + SQL + AWS/Docker + some ML → you’re golden (and well paid).  