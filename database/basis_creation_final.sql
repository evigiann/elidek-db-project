DROP SCHEMA IF EXISTS sql7799656;
CREATE SCHEMA sql7799656;
USE sql7799656;

CREATE TABLE organisation (
	organisation_name VARCHAR(100) NOT NULL,
	abbreviation VARCHAR(30) NOT NULL,
	postal_code SMALLINT unsigned NOT NULL,
	street VARCHAR(45) NOT NULL,
	city VARCHAR(30) NOT NULL,
	PRIMARY KEY (organisation_name)
    );


CREATE TABLE research_centre (
	organisation_name VARCHAR(100) NOT NULL,
	budget_minedu INT UNSIGNED,
	budget_private INT UNSIGNED,
	PRIMARY KEY (organisation_name),
	FOREIGN KEY (organisation_name) REFERENCES organisation(organisation_name)
		ON UPDATE CASCADE
        ON DELETE CASCADE
    );


CREATE TABLE university (
        organisation_name VARCHAR(100) NOT NULL,
        budget_minedu INT UNSIGNED,
        PRIMARY KEY (organisation_name),
        FOREIGN KEY (organisation_name) REFERENCES organisation(organisation_name)
			ON UPDATE CASCADE
			ON DELETE CASCADE
        );


CREATE TABLE enterprise (
        organisation_name VARCHAR(100) NOT NULL,
        budget_equity INT UNSIGNED,
        PRIMARY KEY (organisation_name),
        FOREIGN KEY (organisation_name) REFERENCES organisation(organisation_name)
			ON UPDATE CASCADE
			ON DELETE CASCADE
        );


CREATE TABLE telephone(
	telephone_number VARCHAR(10) NOT NULL,
	organisation_name VARCHAR(100) NOT NULL,
	PRIMARY KEY (telephone_number),
	FOREIGN KEY (organisation_name) REFERENCES organisation(organisation_name)
		ON UPDATE CASCADE
        ON DELETE CASCADE
    );


CREATE TABLE researcher (
	researcher_name VARCHAR(45) NOT NULL,
	researcher_surname VARCHAR(45) NOT NULL,
	gender VARCHAR(20) NOT NULL,
	date_of_birth DATE NOT NULL,
	organisation_name VARCHAR(100) NOT NULL,
	PRIMARY KEY (researcher_name,researcher_surname),
	FOREIGN KEY (organisation_name) REFERENCES organisation(organisation_name)
		ON UPDATE CASCADE
		ON DELETE CASCADE
    );
    
    
CREATE TABLE executive(
	executive_name VARCHAR(45) NOT NULL,
	PRIMARY KEY (executive_name)
    );


CREATE TABLE program(
	program_name VARCHAR(300) NOT NULL,
	department VARCHAR(45) NOT NULL,
	PRIMARY KEY (program_name,department)
    );    
    
CREATE TABLE project (
	project_title VARCHAR(300) NOT NULL,
	abstract TEXT,
	funding REAL UNSIGNED NOT NULL,
	CHECK (funding>100000 and funding<1000000),
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	organisation_name VARCHAR(100) NOT NULL,
	executive_name VARCHAR(45) NOT NULL,
	researcher_name VARCHAR(45) NOT NULL,
	researcher_surname VARCHAR(45) NOT NULL,
	program_name VARCHAR(300) NOT NULL,
	PRIMARY KEY (project_title),
	FOREIGN KEY (organisation_name) REFERENCES organisation(organisation_name)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (executive_name) REFERENCES executive(executive_name)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (researcher_name,researcher_surname) REFERENCES researcher(researcher_name,researcher_surname)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (program_name) REFERENCES program(program_name)
		ON UPDATE CASCADE
        ON DELETE CASCADE
    );


CREATE TABLE deliverable (
	deliverable_abstract TEXT NOT NULL,
	deliverable_title VARCHAR(45) NOT NULL,
	deadline DATE NOT NULL,
	project_title VARCHAR(300) NOT NULL,
	PRIMARY KEY (deliverable_title,project_title),
	FOREIGN KEY (project_title) REFERENCES project (project_title)
		ON UPDATE CASCADE
        ON DELETE CASCADE
    );


CREATE TABLE scientific_field(
	scientific_field_name VARCHAR(45) NOT NULL,
	PRIMARY KEY (scientific_field_name)
    );
    
    
CREATE TABLE scientific_field_of_project(
	scientific_field VARCHAR(45) NOT NULL,
	project_title VARCHAR(300) NOT NULL,
	PRIMARY KEY (scientific_field, project_title),
    FOREIGN KEY (scientific_field) REFERENCES scientific_field(scientific_field_name)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (project_title) REFERENCES project(project_title)
		ON UPDATE CASCADE
        ON DELETE CASCADE
    ); 

CREATE TABLE works_on (
	researcher_name VARCHAR(45) NOT NULL,
	researcher_surname VARCHAR(45) NOT NULL,
	project_title VARCHAR(300) NOT NULL,
	PRIMARY KEY (project_title,researcher_name,researcher_surname),
    FOREIGN KEY (project_title) REFERENCES project(project_title)
		ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (researcher_name,researcher_surname) REFERENCES researcher(researcher_name,researcher_surname)
		ON UPDATE CASCADE
        ON DELETE CASCADE
    );
    
    
CREATE TABLE evaluation(
		date_of_evaluation DATE NOT NULL,
		grade INT NOT NULL,
        CHECK (grade<100 AND grade>0),
		PRIMARY KEY (date_of_evaluation)
    );
    
    
CREATE TABLE evaluate(
        date_of_evaluation DATE NOT NULL,
	    researcher_name VARCHAR(45) NOT NULL,
        researcher_surname VARCHAR(45) NOT NULL,
	    project_title VARCHAR(300) NOT NULL,
        PRIMARY KEY (date_of_evaluation,researcher_name,researcher_surname,project_title),
	    FOREIGN KEY (date_of_evaluation) REFERENCES evaluation (date_of_evaluation)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
        FOREIGN KEY (researcher_name,researcher_surname) REFERENCES researcher (researcher_name,researcher_surname)
			ON UPDATE CASCADE
			ON DELETE CASCADE,
        FOREIGN KEY (project_title) REFERENCES project(project_title)
			ON UPDATE CASCADE
			ON DELETE CASCADE
        );

CREATE VIEW project_per_researcher_view (researcher_name,researcher_surname ,age, project_title, start_date,end_date)
AS
SELECT researcher.researcher_name, researcher.researcher_surname, TIMESTAMPDIFF(year, date_of_birth,now()) as age,
project.project_title, project.start_date, project.end_date
FROM (researcher INNER JOIN works_on ON (researcher.researcher_name=works_on.researcher_name AND researcher.researcher_surname=works_on.researcher_surname))
INNER JOIN project ON project.project_title = works_on.project_title
ORDER BY researcher.researcher_surname;

CREATE VIEW researcher_info (researcher_name, researcher_surname, date_of_birth, gender, project_title) 
AS SELECT researcher.researcher_name, researcher.researcher_surname, date_of_birth, gender, works_on.project_title
FROM (researcher INNER JOIN works_on ON researcher.researcher_name=works_on.researcher_name AND researcher.researcher_surname=works_on.researcher_surname);

CREATE INDEX project_index ON project(project_title);
CREATE INDEX researcher_index ON researcher(researcher_name,researcher_surname);
CREATE INDEX program_index ON program(program_name);
        


