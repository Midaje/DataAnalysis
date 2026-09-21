/*
What are the top skills based on salary?
- Look at the average salary associated with each skill for Data Analyst positions
- Focuses on roles with specified salaries, regardless of location
- Why? It reveals how different skills impact salary levels for Data Analysts and help identify the most financially rewarding skills to acquire or improve
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
    -- AND job_work_from_home = TRUE
GROUP BY
    skill
ORDER BY
    average_salary DESC
LIMIT 25;

/*
Key Industry Trends: 

- The "Data Analyst" Title Inflation: Skills like PySpark ($208k), Bitbucket ($189k), and Kubernetes ($133k) are core software and data engineering competencies. Roles offering these salaries are essentially data engineer or machine learning engineer positions masquerading under an analyst title.

- Python's Scientific Ecosystem Remains Lucrative: Advanced Python capabilities (Pandas at $152k, NumPy at $144k, Scikit-learn at $126k) earn substantially more than standard BI visualization platforms (such as MicroStrategy at $122k), reflecting employer willingness to pay a premium for algorithmic data modeling.

- Production Git Workflows Over Ad-Hoc Scripts: The presence of Bitbucket ($189k) and GitLab ($155k) at the very top indicates companies reward analysts who follow strict software engineering hygiene, peer code review, and automated testing.

- AutoML and Managed AI Integration: Tools like IBM Watson ($161k) and DataRobot ($155k) demonstrate strong demand for analysts who can deploy enterprise enterprise-grade predictive modeling without training neural nets from scratch.

Modern high-paying analytics jobs prioritize practitioners who can build scalable, automated pipelines over those who simply query existing tables and generate static reports.
*/