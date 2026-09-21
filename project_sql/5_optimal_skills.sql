/*
What are the most optimal skills to learn (aka it’s high demand and a high-paying skill)?
- Identify skills in high demand and associated with high average salaries for Data Analyst roles
- Concentrates on remote positions with specified salaries
- Why? Targets skills that offer job security (high demand) and financial benefits (high salaries), offering strategic insights for career development in data analysis
*/
-- 1. řešení, kde kombinujeme předchozí dvě query do CTE
WITH demanded_skills AS (
    SELECT 
        skills_dim.skill_id,
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
        salary_year_avg IS NOT NULL
        AND
        job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
),
    average_salary AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills AS skill,
        ROUND(AVG(salary_year_avg), 2) AS avg_salary
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
        job_work_from_home = TRUE
    GROUP BY
        skills_dim.skill_id
)
SELECT
    demanded_skills.skill_id,
    demanded_skills.skills,
    demand_count,
    avg_salary
FROM
    demanded_skills
INNER JOIN
    average_salary ON demanded_skills.skill_id = average_salary.skill_id
ORDER BY -- ty se můžou prohodit a zjistíme, že nejlépe placené skilly jsou velmi výjimečné
    demand_count DESC,
    avg_salary DESC
LIMIT 25;

-- jednodušší řešení bez CTE
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(job_postings_fact.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM
    job_postings_fact
INNER JOIN
    skills_job_dim ON skills_job_dim.job_id = job_postings_fact.job_id
INNER JOIN
    skills_dim ON skills_dim.skill_id = skills_job_dim.skill_id
WHERE
    salary_year_avg IS NOT NULL
    AND
    job_work_from_home = TRUE
    AND
    job_title_short = 'Data Analyst'
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    demand_count DESC,
    avg_salary DESC
LIMIT 25;