/*
Question: What are the top skills based on salary?
- remote jobs, US, 2025-2026
*/

SELECT
    skills_dim.skills AS skill,
    ROUND(AVG(salary_year_avg), 2) AS average_salary
FROM   
    job_postings_fact
INNER JOIN
    skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
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
    skill
ORDER BY
    average_salary DESC
LIMIT 25;

/*
- Python and SQL show the lowest average salaries in the list despite being industry standards. Because they are ubiquitous requirements across entry-level to senior roles, their overall averages are pulled down relative to niche tools.
*/