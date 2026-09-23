/*
Question: What skills are required for the top-paying data analyst jobs?
- Use the top 10 highest-paying Data Analyst jobs from first query
- Add the specific skills required for these roles
*/

WITH top_paying_jobs AS (
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
  LIMIT 10
)
SELECT 
    top_paying_jobs.*, 
    skills_dim.skills
FROM
    top_paying_jobs
INNER JOIN
    skills_job_dim ON skills_job_dim.job_id = top_paying_jobs.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC;

/*
- SQL and Python anchor the top-tier compensation market: SQL appears in 8 of the 9 jobs (88.9%), and Python appears in 6 of the 9 jobs (66.7%). Every job paying over $215,000 requiring technical skills includes SQL

- The two highest-paying roles (Netflix Analytics Engineer at $445,000) specifically require core engineering and systems languages—Go, Scala, and TypeScript—moving beyond traditional tabular reporting tools

- BI visualization tools are standard in mid-tier senior roles ($172K–$225K): Looker and Tableau each appear in 4 of 9 jobs (44.4%), but are completely absent from the top two $445,000 roles
*/