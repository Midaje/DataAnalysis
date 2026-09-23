/*
Question: What are the top-paying data analyst jobs?
- only years 2025, 2026
- only United States remote jobs
*/

SELECT
    job_id,
    job_title,
    company_dim.name AS company_name,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date::DATE
FROM 
    job_postings_fact
LEFT JOIN
    company_dim ON company_dim.company_id = job_postings_fact.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND
    salary_year_avg IS NOT NULL
    AND
    job_location = 'Anywhere'
    AND
    EXTRACT(YEAR FROM job_posted_date) >= 2025
    AND
    job_country = 'United States'
ORDER BY
    salary_year_avg DESC
LIMIT 10;

/*
- The average salary across the 10 roles is $244,253, with a median of $199,500. However, the top two roles at Netflix ($445,000 each) pull the overall mean up substantially; the bottom 8 roles sit in a tight range between $172,500 and $225,000 (mean of $194,067).

- "Staff" Represents the High-Income Ceiling for Non-Engineering Analysts

- 80% of positions are explicit senior/executive tiers. Traditional, unspecialized "Data Analyst" titles represent only 10% of the dataset.
*/