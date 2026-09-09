CREATE TABLE "dim_candidate" (
  "candidate_id" int PRIMARY KEY,
  "first_name" varchar,
  "last_name" varchar,
  "email" varchar
);

CREATE TABLE "dim_country" (
  "country_id" int PRIMARY KEY,
  "country_name" varchar
);

CREATE TABLE "dim_seniority" (
  "seniority_id" int PRIMARY KEY,
  "seniority_name" varchar
);

CREATE TABLE "dim_technology" (
  "technology_id" int PRIMARY KEY,
  "technology_name" varchar
);

CREATE TABLE "dim_date" (
  "date_id" date PRIMARY KEY,
  "year" int,
  "month" int,
  "day" int
);

CREATE TABLE "fact_applications" (
  "application_id" int PRIMARY KEY,
  "candidate_id" int,
  "country_id" int,
  "seniority_id" int,
  "technology_id" int,
  "date_id" date,
  "yoe" int,
  "code_challenge_score" int,
  "technical_interview_score" int,
  "is_hired" boolean
);

ALTER TABLE "fact_applications" ADD FOREIGN KEY ("candidate_id") REFERENCES "dim_candidate" ("candidate_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "fact_applications" ADD FOREIGN KEY ("country_id") REFERENCES "dim_country" ("country_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "fact_applications" ADD FOREIGN KEY ("seniority_id") REFERENCES "dim_seniority" ("seniority_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "fact_applications" ADD FOREIGN KEY ("technology_id") REFERENCES "dim_technology" ("technology_id") DEFERRABLE INITIALLY IMMEDIATE;

ALTER TABLE "fact_applications" ADD FOREIGN KEY ("date_id") REFERENCES "dim_date" ("date_id") DEFERRABLE INITIALLY IMMEDIATE;
