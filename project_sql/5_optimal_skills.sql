/*
What are the most optimal skills to learn (aka it’s high demand and a high-paying skill)?
- remote jobs, US, 2025-2026
*/

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary,
    EXTRACT(YEAR FROM job_posted_date) AS year
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN
    skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    salary_year_avg IS NOT NULL
    AND
    job_title_short = 'Data Analyst'
    AND
    job_location = 'Anywhere'
    AND
    job_country = 'United States'
    AND
    EXTRACT(YEAR FROM job_posted_date) >= 2025
GROUP BY
    skills_dim.skill_id,
    EXTRACT(YEAR FROM job_posted_date)
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    year DESC,
    demand_count DESC,
    avg_salary DESC
LIMIT 25;

/*
- SQL and Python Dominate Market Demand (40.24% of 2026 Demand): SQL remains the #1 requested skill across both years

- Niche Modern Stack Tools Yield the Highest Compensations: In 2026, the highest average salaries belong to specialized tools with lower demand counts: Looker ($132,609, 12 mentions), Go ($130,926, 13 mentions), and Snowflake ($116,026, 15 mentions), all commanding higher salaries than market staples like SQL ($103,233) and Excel ($94,331).
*/