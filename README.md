# ETL Workshop 1: Data Engineer Challenge

## 1. Project Overview

This repository contains my solution for the ETL workshop challenge. The main goal was to take a CSV file that holds 50,000 candidate records, clean and transform that data with Python (Pandas), and then load it into a PostgreSQL Data Warehouse.

I built the data model with a Star Schema to make reporting clear and querying fast. After loading the cleaned data through SQLAlchemy, I drew visualizations that rely on SQL queries taken straight from the database. The original CSV file was never used for the charts.

## 2. How to run this project

To run this project, you must have Python and PostgreSQL installed on your machine with libraries such as pandas, sqlalchemy, matplotlib, and seaborn.

1. Clone this repository.

2. Create a database in pgAdmin4. You can name it `etl`.

3. Open the `etl_candidates_csv.ipynb` file.

4. Update the database connection variables (`USER` `PASSWORD` `HOST` `PORT `DB_NAME`) with your own local PostgreSQL credentials.

5. Run all the cells in the notebook in order. This will extract the data clean it apply business rules and load it into the database.

6. At the end of the notebook the charts will appear showing the results from the DW.

## 3. Data Model and ETL Decisions

### Star Schema Design

I chose a Star Schema because it separates metrics from context, making analytical queries easier and faster.

![Star Schema Diagram](https://github.com/JheffreyUrbano/candidate-selection-etl/blob/bf8797a0439ae40569e050b45cb494d459ef91b5/assets/star-schema.png)

*(Note: Diagram created using dbdiagram.io to show relationships between facts and dimensions)*

* **Fact Table (`fact_applications`)**: This central table holds scores and years of experience. I also added a column named `is_hired` (boolean). The column is calculated using the business rule: both technical and challenge scores must be at least 7. Pre‑calculating this during the ETL saves time as the database does not need to compute this logic on every query.

* **Dimension Tables**: I split the context data into five dimension tables: `dim_candidate` `dim_country` `dim_seniority` `dim_technology` and `dim_date`. Isolating the `dim_date` table is especially useful for filtering and grouping data by year in visualizations avoiding heavy date‑parsing functions.

### Data Cleaning Strategies

Real‑world data is often messy. Because this data was randomly generated it contained specific anomalies. So I proceeded applied the following cleaning steps in Pandas before loading it into the database:

* **Null Values**: I removed rows where essential identifiers such as email or application date were missing. For missing test scores, I replaced them with 0 assuming the test was not taken.

* **Score Scale Correction**: I identified values up to 100 in the test scores, which should follow a 0-10 scale. Any score greater than 10 was divided by 10 to correct scaling typos.

* **Missing Experience (YOE)**: I converted any negative years of experience to their absolute positive value. Instead of using 0 or dropping rows with missing years of experience, I used statistical imputation. I filled those values with the median experience of the corresponding seniority level, making the data more realistic.

* **Outliers**: I used the Interquartile Range (IQR) method to handle anomalous values in the years of experience column. For example, a candidate listed with 40 years of experience but classified as an "Intern" was capped to a realistic number using winsorization bounds.

## 4. KPIs & Visualizations

After cleaning and loading the data, queries found that 7,660 candidates were effectively hired (scores ≥ 7). Because the original CSV data was randomly generated using a library the distributions are quite uniform.

### Hires by Technology

The hiring distribution across technologies is very even. The percentage of hires ranges from 7.9 % for Data Engineer and MuleSoft to 8.7 % for Sales and React.

![Hires by Technology Pie Chart](https://github.com/JheffreyUrbano/candidate-selection-etl/blob/bf8797a0439ae40569e050b45cb494d459ef91b5/assets/hires_by_tech.png)

### Hires by Year

Most hires occurred steadily between 2022 and 2025. Each year in that range had around 1,500 hires with tails in 2021 and early 2026.

![Hires by Year Bar Chart](https://github.com/JheffreyUrbano/candidate-selection-etl/blob/bf8797a0439ae40569e050b45cb494d459ef91b5/assets/hires_by_year.png)

### Hires by Seniority

All seniority levels maintained a volume between 1,000 and 1,100 hires. Interestingly the Intern level showed a spike with over 1,400 hires.

![Hires by Seniority Bar Chart](https://github.com/JheffreyUrbano/candidate-selection-etl/blob/bf8797a0439ae40569e050b45cb494d459ef91b5/assets/hires_by_seniority.png)

### Hires by Country Over Years

Focusing on the USA, Brazil, Colombia and Ecuador the multi‑line chart shows similar hiring trends with overlapping lines over the years. This uniformity is expected because the dataset was randomly generated.

![Hires, by Country Line Chart](https://github.com/JheffreyUrbano/candidate-selection-etl/blob/bf8797a0439ae40569e050b45cb494d459ef91b5/assets/hires_by_country_over_years.png)
