# Job Postings Database Analysis

## Project Overview
SQL analysis of job posting data with application tracking, company insights, and skills demand analytics. Features advanced SQL techniques including complex JOINs, CTEs, window functions, and multi-timezone analysis.

# Full live connection from PostgreSQL → Excel with real-time dashboard.

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