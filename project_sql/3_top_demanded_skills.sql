/*
Question: What are the most in-demand skills for data analysts?
- remote jobs, 2025-2026
*/

SELECT 
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM   
    job_postings_fact
INNER JOIN
    skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN
    skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
    AND
    job_location = 'Anywhere'
    AND
    job_country = 'United States'
    AND
    EXTRACT(YEAR FROM job_posted_date) >= 2025
GROUP BY
    skills_dim.skills
ORDER BY
    demand_count DESC
LIMIT 5;

/*
- SQL is the dominant foundational skill

- Balanced demand between general-purpose manipulation and programming: Excel (656 mentions, 20.99%) and Python (647 mentions, 20.70%)

- BI and visualization platforms command market share: Tableau (510 mentions, 16.31%) and Power BI (451 mentions, 14.43%) together represent 961 mentions (30.74% of top-5 mentions), virtually matching the standalone demand for SQL (962 mentions)
*/