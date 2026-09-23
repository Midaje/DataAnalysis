# Introduction
Dive into the data job market! Focusing on data analyst roles, this project explores top-paying jobs, in-demand skills and where high demand meets high salary in data analytics.

SQL queries? Check them out here: [project_sql folder](/project_sql/).

# Background
This project is part of the “SQL for Data Analytics” course taught by Luke Barousse. The course covers everything from the absolute basics of SQL to more advanced features such as CTEs.

[Link to the course here!](https://www.lukebarousse.com/sql)

# Tools I used
- SQL, Postgres, Git, GitHub

# The Analysis
Each query for this project aimed at investigating specific aspects of the data analyst job market. Each query was built on the previous one and further expanded on the data obtained.

**Overview of the questions examined:**

### Query 1
At first, I was curious about which remote data analyst positions paid the most in 2025 and 2026.
```sql 
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
```
 - The average salary across the 10 roles is $244,253, with a median of $199,500. However, the top two roles at Netflix ($445,000 each) pull the overall mean up substantially; the bottom 8 roles sit in a tight range between $172,500 and $225,000 (mean of $194,067).

- "Staff" Represents the High-Income Ceiling for Non-Engineering Analysts

- 80% of positions are explicit senior/executive tiers. Traditional, unspecialized "Data Analyst" titles represent only 10% of the dataset.
___
### Query 2
I then looked into what skills are required for these 10 highest-paying positions.

```sql
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
```
- SQL and Python anchor the top-tier compensation market: SQL appears in 8 of the 9 jobs (88.9%), and Python appears in 6 of the 9 jobs (66.7%). Every job paying over $215,000 requiring technical skills includes SQL

- The two highest-paying roles (Netflix Analytics Engineer at $445,000) specifically require core engineering and systems languages—Go, Scala, and TypeScript—moving beyond traditional tabular reporting tools

- BI visualization tools are standard in mid-tier senior roles ($172K–$225K): Looker and Tableau each appear in 4 of 9 jobs (44.4%), but are completely absent from the top two $445,000 roles

[Graf](sql_2.png) *vytvořen za pomoci umělé inteligence*

---
### Query 3
As someone from a different field who wants to become a data analyst, I was curious to know which skills appear most frequently in job postings for this position. This will help me decide which ones I should learn first.
```sql
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
```
- SQL is the dominant foundational skill

- Balanced demand between general-purpose manipulation and programming: Excel (656 mentions, 20.99%) and Python (647 mentions, 20.70%)

- BI and visualization platforms command market share: Tableau (510 mentions, 16.31%) and Power BI (451 mentions, 14.43%) together represent 961 mentions (30.74% of top-5 mentions), virtually matching the standalone demand for SQL (962 mentions)
---
### Query 4
Out of curiosity, I also took a look at which skills are the “highest-paying”—that is, the ones required for the highest-paying positions.
```sql
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
```
- Python and SQL show the lowest average salaries in the list despite being industry standards. Because they are ubiquitous requirements across entry-level to senior roles, their overall averages are pulled down relative to niche tools.
---
### Query 5
As someone just starting out in data analysis, I’m interested in finding out which skills are most commonly required and also well-paid. It doesn’t make sense to start by learning a very specific skill that’s required for only a small percentage of the highest-paying positions. So, the last query shows the most commonly required skills, sorted by the average salary of the positions for which they’re required.

```sql
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
```
- SQL and Python Dominate Market Demand (40.24% of 2026 Demand): SQL remains the #1 requested skill across both years

- Niche Modern Stack Tools Yield the Highest Compensations: In 2026, the highest average salaries belong to specialized tools with lower demand counts: Looker ($132,609, 12 mentions), Go ($130,926, 13 mentions), and Snowflake ($116,026, 15 mentions), all commanding higher salaries than market staples like SQL ($103,233) and Excel ($94,331).

# Conclusions

**SQL & Python Form the Non-Negotiable Core**  
   SQL emerged as the single most requested skill across both 2025 and 2026 postings, paired closely with Python. Rather than being "nice-to-have" perks, they represent the baseline entry ticket to the market and are present in nearly all top-tier compensation tiers.

**The "High-Paying Skill" Paradox (Ubiquity vs. Premium)**  
   Query 4 revealed that standard tools like SQL and Excel often show lower overall salary averages than niche technologies. This isn't because they are less valued, but because they are ubiquitous across all tiers—from entry-level to staff roles. High volume naturally normalizes average salary numbers.

**Specialization & Engineering Drive Top-Tier Pay ($200k+)**  
   The roles commanding the absolute highest compensation shift focus from classical reporting toward data engineering and systems programming. Specialization pays exponentially, but only on top of solid fundamentals.

**BI & Visualization Remain High-Volume Anchors**  
   Tableau and Power BI together rivaled the overall standalone volume of SQL. For mid-level and traditional data analyst roles, bridging the gap between raw data queries and business stakeholder dashboards remains a primary expectation.

**Pragmatic Learning Strategy for Career Changers**  
   Chasing niche, high-paying tools (e.g., Go, Scala) early on is counterproductive for entry-level applicants due to low posting volume. The optimal path to market readiness is mastering the high-demand foundational stack (SQL + Excel/Power BI + Python) before branching into specialized cloud data warehouses or engineering tools.

---

### Closing Thoughts
This project served as a comprehensive bridge between theoretical SQL and realistic analytical problem-solving:

Writing multi-table joins, subqueries, CTEs, and aggregated filters allowed me to work with realistic database schemas and edge cases (such as handling `NULL` values and salary normalization).

Rather than just pulling numbers, each query was designed around a real-world decision-making process—understanding market viability and strategically optimizing my own career roadmap.

Working through the data demystified the current job market. It helped me replace assumptions about "what skills sound impressive" with actual evidence on what hiring managers currently look for.