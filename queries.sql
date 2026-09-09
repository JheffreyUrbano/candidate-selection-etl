-- Hires by technology
SELECT t.technology_name, COUNT(f.application_id) AS total_hires
FROM fact_applications f
JOIN dim_technology t ON f.technology_id = t.technology_id
WHERE f.is_hired = true
GROUP BY t.technology_name;


-- Hires by year
SELECT d.year, COUNT(f.application_id) AS total_hires
FROM fact_applications f
JOIN dim_date d ON f.date_id = d.date_id
WHERE f.is_hired = true
GROUP BY d.year
ORDER BY d.year;


-- Hires by seniority
SELECT s.seniority_name, COUNT(f.application_id) AS total_hires
FROM fact_applications f
JOIN dim_seniority s ON f.seniority_id = s.seniority_id
WHERE f.is_hired = true
GROUP BY s.seniority_name;


-- Hires by country over years
SELECT c.country_name, d.year, COUNT(f.application_id) AS total_hires
FROM fact_applications f
JOIN dim_country c ON f.country_id = c.country_id
JOIN dim_date d ON f.date_id = d.date_id
WHERE f.is_hired = true 
  AND c.country_name IN ('USA', 'Brazil', 'Colombia', 'Ecuador')
GROUP BY c.country_name, d.year
ORDER BY d.year, c.country_name;