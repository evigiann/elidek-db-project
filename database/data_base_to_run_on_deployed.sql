DROP SCHEMA IF EXISTS sql7799656;
CREATE SCHEMA sql7799656;
USE sql7799656;


-- TABLE CREATION
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


-- DATA INSERTION GENERAL
-- PROGRAM (31)
insert into program (program_name, department) values ('Music and Man','Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Artificial Inteligence and Consiousness', 'STEM');
insert into program (program_name, department) values ('Rexamination of Personality Disorders', 'Psychology and Medicine');
insert into program (program_name, department) values ('Disability in the Workpalce', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Testing Security System Safety', 'STEM');
insert into program (program_name, department) values ('Enviromental Crisis Solution Examination Program', 'STEM');
insert into program (program_name, department) values ('Pandemics and Endemics', 'Psychology and Medicine');
insert into program (program_name, department) values ('Techology and Personhood', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Cryptology, Codes and Riddles', 'STEM');
insert into program (program_name, department) values ('Rexamination of the Capitalistic Model', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Chinese History Program', 'History and Philosophy');
insert into program (program_name, department) values ('Greek History Program', 'History and Philosophy');
insert into program (program_name, department) values ('Political Tendencies of the World',  'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Classic Literature and the Modern Reader', 'Marketing');
insert into program (program_name, department) values ('5+ Human Senses', 'STEM');
insert into program (program_name, department) values ('Sleep and Chronic Fatigue', 'Psychology and Medicine');
insert into program (program_name, department) values ('Examination of Human Fear', 'Psychology and Medicine');
insert into program (program_name, department) values ('Social Networks:A Blessing or a Curse', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Studying Methods', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Types of Intelligence', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Food throughout History', 'History and Philosophy');
insert into program (program_name, department) values ('Bias in Medicine', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Reducing the Catastrophic Effecs of the Current Business', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Politics and Different Cultures', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Creating a Safer Workplace', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Japanese History Program', 'History and Philosophy');
insert into program (program_name, department) values ('Limitation of Science', 'STEM');
insert into program (program_name, department) values ('Safety of Medical Personel', 'Sociology, Politics and Anthropology');
insert into program (program_name, department) values ('Infastracture and Natural Enviromnent' , 'STEM');
insert into program (program_name, department) values ('50 years of Greek History', 'History and Philosophy');
-- EXECUTIVE (22)
insert into executive (executive_name) values ('Cherin Cleverley');
insert into executive (executive_name) values ('Augustina Kardos-Stowe');
insert into executive (executive_name) values ('Esme Stowell');
insert into executive (executive_name) values ('Mercie Glasgow');
insert into executive (executive_name) values ('Candie Eades');
insert into executive (executive_name) values ('Leroi Radbond');
insert into executive (executive_name) values ('Naoma Dysart');
insert into executive (executive_name) values ('Armstrong Harrisson');
insert into executive (executive_name) values ('Emyle Androck');
insert into executive (executive_name) values ('Pippy Camocke');
insert into executive (executive_name) values ('Zebedee Herion');
insert into executive (executive_name) values ('Darbie Troman');
insert into executive (executive_name) values ('Pamela Spendlove');
insert into executive (executive_name) values ('Garland Redford');
insert into executive (executive_name) values ('Kevyn Lumb');
insert into executive (executive_name) values ('Tallie Dicke');
insert into executive (executive_name) values ('Art Terbeek');
insert into executive (executive_name) values ('Robena Lanston');
insert into executive (executive_name) values ('Drud Conring');
insert into executive (executive_name) values ('Anissa Rummery');
insert into executive (executive_name) values ('Waneta Linkleter');
insert into executive (executive_name) values ('Shannen Giacomasso');
-- ORGANISATION (31) 
INSERT INTO organisation VALUES('National Centre of Insects','NCI','5317','61 Quincy Circle', 'Basak');
INSERT INTO organisation VALUES('The Magnus Institute','TMI','94627','573 Pepper Wood Center','Oakland');
INSERT INTO organisation VALUES('Lab of the Detection of Pathology','DetPath','562450','298 Shelley Pass', 'Jiguan');
INSERT INTO organisation VALUES('Research lab of Nephrology','RPLN','L8J','31 International Park','Trois-Rivieres');
INSERT INTO organisation VALUES('Research Center for the Detection of Phytology','RCDP','368458','89163 Valley Edge Point','Tsurib');
INSERT INTO organisation VALUES('Testing Grounds of Progressed Cryptology','TGPC','778435','1 Paget Street','Oshnaviyeh');
INSERT INTO organisation VALUES('Bureau of Sheltered Oncogenics','BSO','6204','2 Granby Point','Taytaytan');
INSERT INTO organisation VALUES('Lab of the Mutation of Zoogenics','LMZ','762819','753 Maryland Terrace','Kariai');
INSERT INTO organisation VALUES('Research Center of Adjusted Volcanology','ReVo','8206','77678 Blaine Parkway','Barisal');
INSERT INTO organisation VALUES('National Cosmologic Research Center','NatCosmo','5140-058','81 Pine View Parkway','Carrazeda de Ansiaes');
INSERT INTO organisation VALUES('Lab of Tectonic Monitoring','LTM','245573','93384 Corry Trail','Banjar Tribubiyu Kaja');
INSERT INTO organisation VALUES('Athenian Center of Applied Mathematics','ACAM','157743','54 Eschian Circle','Pacet');
INSERT INTO organisation VALUES('Testing Bureau and Archive of Exobiology','BAE','734625','79 Clemons Pass','Riangkroko');
INSERT INTO organisation VALUES('National Technical University of Athens','NTUA','62377','1 Melody Park','Athens');
INSERT INTO organisation VALUES('University of Prague','PrUni','2322345','Nerudova Street','Prague');
INSERT INTO organisation VALUES('Ivonburn Classic Studies College','ICSC','843933','1 Mosinee Avenue','Wangxian');
INSERT INTO organisation VALUES('National Academy of Scientific Adjustements','NASA','85500-000','40 Porter Street','Pato Branco');
INSERT INTO organisation VALUES('Iraworths History University','IHU','824566','56 6th Plaza','Citundum');
INSERT INTO organisation VALUES('King Richard University','KRU','237579','023 Hollow Ridge Terrace','Bovoyaevskoe');
INSERT INTO organisation VALUES('Hellenic School of Mythology','HSM','82882','6771 Warbler Lane','Quan Hau');
INSERT INTO organisation VALUES('National University of Mathematics','MathEdu','4421','6268 Hudson Point','El Carril');
INSERT INTO organisation VALUES('Iroupian Academy of Psychology','IAP','55178','87078 Gateaway Center','El Potreto');
INSERT INTO organisation VALUES('Anathema','ANA','43425','59 Blackbrird Plaza','Nasilava');
INSERT INTO organisation VALUES('Cube','CB','8987','98229 Dennis Park','Longxi');
INSERT INTO organisation VALUES('Waystar Royco','WR','42001','4897 5th Parkway','Utabi');
INSERT INTO organisation VALUES('Flux Security','FS','9485','83477 Morningstar Road','Ohafia-ifigh');
INSERT INTO organisation VALUES('Lifebank','LB','9833','1 Sage Parkway','Guanshan');
INSERT INTO organisation VALUES('Singex','Singex','94857','8277 Sundown Hill','Glubczyce');
INSERT INTO organisation VALUES('North Starporation','Norcorp','34927','1277 Sutherland Hill','Laguna Salada');
INSERT INTO organisation VALUES('Alphawater','A','48597','759 3rd Way','Novokubansk');
INSERT INTO organisation VALUES('Ecorp','Ecorp','43923','8922 Rutledge Point','Ouesso');
INSERT INTO organisation VALUES('Alpaca Beer Organisation','ABO','32993','311 Nobel Lane','Prinza');
INSERT INTO organisation VALUES('Omega Technologies','OmeT','56788','933 Farwest Lane','North Diskomet');
-- TELEPHONE_NUMBER DONE
insert into telephone (telephone_number, organisation_name) values ('1261401793', 'National Centre of Insects');
insert into telephone (telephone_number, organisation_name) values ('8326099297', 'The Magnus Institute');
insert into telephone (telephone_number, organisation_name) values ('7549991486', 'Lab of the Detection Of Pathology');
insert into telephone (telephone_number, organisation_name) values ('3247314174', 'Research Center for the Detection of Phytology');
insert into telephone (telephone_number, organisation_name) values ('7697431619', 'Testing Grounds of Progressed Cryptology');
insert into telephone (telephone_number, organisation_name) values ('9806040197', 'Bureau of Sheltered Oncogenics');
insert into telephone (telephone_number, organisation_name) values ('3025098664', 'Research Center of Adjusted Volcanology');
insert into telephone (telephone_number, organisation_name) values ('1465530237', 'National Cosmologic Research Center');
insert into telephone (telephone_number, organisation_name) values ('1162716573', 'Lab of Tectonic Monitoring');
insert into telephone (telephone_number, organisation_name) values ('8374494576', 'Athenian Center of Applied Mathematics');
insert into telephone (telephone_number, organisation_name) values ('9143865666', 'Testing Bureau and Archive of Exobiology');
insert into telephone (telephone_number, organisation_name) values ('4818497073', 'National Technical University of Athens');
insert into telephone (telephone_number, organisation_name) values ('8412489207', 'University of Prague');
insert into telephone (telephone_number, organisation_name) values ('4012201422', 'Ivonburn Classic Studies College');
insert into telephone (telephone_number, organisation_name) values ('1614072163', 'National Academy of Scientific Adjustements');
insert into telephone (telephone_number, organisation_name) values ('2196943534', 'Iraworths History University');
insert into telephone (telephone_number, organisation_name) values ('3725538307', 'King Richard University');
insert into telephone (telephone_number, organisation_name) values ('5576032262', 'Hellenic School of Mythology');
insert into telephone (telephone_number, organisation_name) values ('4913919533', 'National University of Mathematics');
insert into telephone (telephone_number, organisation_name) values ('3631280408', 'Iroupian Academy of Psychology');
insert into telephone (telephone_number, organisation_name) values ('9537657399', 'Anathema');
insert into telephone (telephone_number, organisation_name) values ('8629603549', 'Cube');
insert into telephone (telephone_number, organisation_name) values ('5087334322', 'Waystar Royco');
insert into telephone (telephone_number, organisation_name) values ('7688110093', 'Flux Security');
insert into telephone (telephone_number, organisation_name) values ('7746056344', 'Lifebank');
insert into telephone (telephone_number, organisation_name) values ('9393507417', 'Singex');
insert into telephone (telephone_number, organisation_name) values ('3386110087', 'North Starporation');
insert into telephone (telephone_number, organisation_name) values ('4163266696', 'Alphawater');
insert into telephone (telephone_number, organisation_name) values ('3854026776', 'Ecorp');
insert into telephone (telephone_number, organisation_name) values ('8211995872', 'Alpaca Beer Organisation');
insert into telephone (telephone_number, organisation_name) values ('5307560287', 'National Centre of Insects');
insert into telephone (telephone_number, organisation_name) values ('8185088490', 'National Technical University of Athens');
insert into telephone (telephone_number, organisation_name) values ('3369302353', 'University of Prague');
insert into telephone (telephone_number, organisation_name) values ('2191469570', 'Anathema');
insert into telephone (telephone_number, organisation_name) values ('6991353465', 'Cube');
insert into telephone (telephone_number, organisation_name) values ('7555782593', 'Waystar Royco');
insert into telephone (telephone_number, organisation_name) values ('6334202099', 'Waystar Royco');
insert into telephone (telephone_number, organisation_name) values ('9248696704', 'Flux Security');
insert into telephone (telephone_number, organisation_name) values ('3553890821', 'Ecorp');
insert into telephone (telephone_number, organisation_name) values ('1193149865', 'Ecorp');
insert into telephone (telephone_number, organisation_name) values ('6181467951', 'Omega Technologies');
insert into telephone (telephone_number, organisation_name) values ('4525358054', 'Omega Technologies');
insert into telephone (telephone_number, organisation_name) values ('5688040631', 'Omega Technologies');
insert into telephone (telephone_number, organisation_name) values ('8651725563', 'Alpaca Beer Organisation');
insert into telephone (telephone_number, organisation_name) values ('2476832446', 'Alpaca Beer Organisation');
insert into telephone (telephone_number, organisation_name) values ('7568637404', 'Athenian Center of Applied Mathematics');
insert into telephone (telephone_number, organisation_name) values ('4257731262', 'Research Center for the Detection of Phytology');
insert into telephone (telephone_number, organisation_name) values ('9717723333', 'Lab of Tectonic Monitoring');
insert into telephone (telephone_number, organisation_name) values ('8802999601', 'Iraworths History University');
insert into telephone (telephone_number, organisation_name) values ('7673563399', 'Research Center of Adjusted Volcanology');
-- RESEARCH_CENTRE (12)
INSERT INTO research_centre VALUES('National Centre of Insects', 5000000, 1000000);
INSERT INTO research_centre VALUES('The Magnus Institute', '200000000','3000000');
INSERT INTO research_centre VALUES('Lab of the Detection of Pathology', '120000000','3000000');
INSERT INTO research_centre VALUES('Research Lab of Nephrology', '467000000','2000000');
INSERT INTO research_centre VALUES('Research Center for the Detection of Phytology', '11000000','20000000');
INSERT INTO research_centre VALUES('Testing Grounds of Progressed Cryptology', '66000000','51000000');
INSERT INTO research_centre VALUES('Bureau of Sheltered Oncogenics', '4000000','39000000');
INSERT INTO research_centre VALUES('Lab of the Mutation of Zoogenics', '61000000','98000000');
INSERT INTO research_centre VALUES('Research Center of Adjusted Volcanology', '455000000','97000000');
INSERT INTO research_centre VALUES('National Cosmologic Research Center', '97000000','556000000');
INSERT INTO research_centre VALUES('Lab of Tectonic Monitoring', '7000000','56000000');
INSERT INTO research_centre VALUES('Athenian Center of Applied Mathematics', '44000000','67000000');
INSERT INTO research_centre VALUES('Testing Bureau and Archive of Exobiology', '2200000','48000000');
-- UNIVERSITY (9)
INSERT INTO university VALUES('National Technical University of Athens', '170000000');
INSERT INTO university VALUES('University of Prague', '33000000');
INSERT INTO university VALUES('Ivonburn Classic Studies College', '76000000');
INSERT INTO university VALUES('National Academy of Scientific Adjustements', '33000000');
INSERT INTO university VALUES('Iraworths History University', '88000000');
INSERT INTO university VALUES('King Richard University', '99000000');
INSERT INTO university VALUES('Hellenic School of Mythology', '1000000');
INSERT INTO university VALUES('National University of Mathematics', '746000000');
INSERT INTO university VALUES('Iroupian Academy of Psychology', '65000000');
-- ENTERPRISE (11)
INSERT INTO enterprise VALUES('Anathema', '12000000');
INSERT INTO enterprise VALUES('Cube', '3000000000');
INSERT INTO enterprise VALUES('Waystar Royco', '42000000');
INSERT INTO enterprise VALUES('Flux Security', '83000000');
INSERT INTO enterprise VALUES('Lifebank', '760000000');
INSERT INTO enterprise VALUES('Singex', '2000000');
INSERT INTO enterprise VALUES('North Starporation', '30000000');
INSERT INTO enterprise VALUES('Alphawater', '10000000');
INSERT INTO enterprise VALUES('Ecorp', '66000000');
INSERT INTO enterprise VALUES('Omega technologies', '690000000');
INSERT INTO enterprise VALUES('Alpaca Beer Organisation', '690000000');
-- RESEARCHER (105)
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Curry', 'Cockett', 'Male', '1999-08-12', 'National Centre of Insects');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Bria', 'Yeend', 'Female', '2003-10-15', 'National Centre of Insects');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Jolynn', 'Fahey', 'Female', '2003-08-06', 'National Centre of Insects');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Olivier', 'Gilhouley', 'Male', '1982-09-29', 'National Centre of Insects');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Giselle', 'Rylatt', 'Female', '2003-07-01', 'The Magnus Institute');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Amelia', 'Chichgar', 'Female', '1951-09-03', 'Lab of the Detection of Pathology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Linoel', 'Good', 'Male', '1969-03-17', 'Research Lab of Nephrology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Harlin', 'Mandrier', 'Male', '1979-08-18', 'Research Center for the Detection of Phytology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Gail', 'Arnet', 'Female', '1972-12-29', 'Lab of the Detection of Pathology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Chucho', 'MacDougal', 'Male', '1960-07-11', 'Research Lab of Nephrology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Prince', 'Richly', 'Male', '1992-03-25','Research Lab of Nephrology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Adolpho', 'Merrigan', 'Male', '1988-06-04', 'Research Lab of Nephrology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Kincaid', 'Wilford', 'Male', '1998-12-11', 'Research Lab of Nephrology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Stephanus', 'Santer', 'Male', '1981-05-16', 'Testing Grounds of Progressed Cryptology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Minni', 'McKimmie', 'Female', '1961-03-02', 'Bureau of Sheltered Oncogenics');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Diandra', 'Redmell', 'Genderqueer', '1982-06-01', 'Lab of the Mutation of Zoogenics');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Konstantin', 'Prebble', 'Male', '1949-01-07', 'Research Center of Adjusted Volcanology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Pammi', 'Rosenfelt', 'Bigender', '1978-03-08', 'Research Center of Adjusted Volcanology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Kacey', 'Timoney', 'Female', '1953-01-08', 'Research Center of Adjusted Volcanology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Reynolds', 'Swiffin', 'Genderfluid', '1970-04-22', 'Research Center of Adjusted Volcanology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Rosemaria', 'Whyteman', 'Female', '1979-05-13','Research Center of Adjusted Volcanology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Alberto', 'Dadge', 'Male', '1952-03-02', 'National Cosmologic Research Center');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Leora', 'Grishukhin', 'Female', '1994-04-25', 'Lab of Tectonic Monitoring');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Carena', 'Gronauer', 'Polygender', '2004-08-25', 'Athenian Center of Applied Mathematics');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Waverley', 'Kelsall', 'Male', '1957-10-18', 'Testing Bureau and Archive of Exobiology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Silvanus', 'Cockaday', 'Bigender', '1968-07-31', 'National Technical University of Athens');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Dianemarie', 'Chaffin', 'Female', '2000-02-22', 'National Technical University of Athens');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Adrea', 'Duinbleton', 'Female', '1965-03-15', 'National Technical University of Athens');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Patrizia', 'Gallahar', 'Female', '1988-08-19', 'National Technical University of Athens');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Karil', 'Munton', 'Female', '2003-10-16', 'Lab of Tectonic Monitoring');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Pearline', 'MacConneely', 'Female', '2003-11-21', 'Lab of Tectonic Monitoring');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Meredeth', 'Lovick', 'Male', '1972-01-14', 'Lab of Tectonic Monitoring');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Otho', 'Tabert', 'Male', '1993-06-28', 'University of Prague');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Melva', 'Escala', 'Female', '1989-09-15', 'University of Prague');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Talbot', 'Kernocke', 'Male', '1954-02-04', 'University of Prague');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Ara', 'Raftery', 'Male', '1957-06-05', 'University of Prague');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Alfred', 'Seston', 'Male', '1991-03-20', 'University of Prague');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Jonathon', 'Capoun', 'Male', '1980-05-20', 'Ivonburn Classic Studies College');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Rosco', 'Swayland', 'Male', '1946-12-11', 'National Academy of Scientific Adjustements');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Myrtia', 'Pea', 'Female', '1974-12-25', 'Iraworths History University');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Heriberto', 'Knotton', 'Male', '1993-07-15', 'King Richard University');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Ricky', 'Lakeland', 'Male', '1993-07-04', 'King Richard University');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Crysta', 'Nares', 'Female', '1959-10-04','King Richard University');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Carl', 'McGaughay', 'Male', '1989-08-01', 'King Richard University');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Quintina', 'Sandal', 'Female', '1967-10-29', 'King Richard University');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Edouard', 'Westphalen', 'Male', '1997-09-06', 'Hellenic School of Mythology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Bob', 'Widdup', 'Male', '1969-05-12', 'National University of Mathematics');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Danny', 'Kubin', 'Female', '1946-05-23', 'Iroupian Academy of Psychology');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Lea', 'Wentworth', 'Female', '1973-11-27', 'Anathema');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Revkah', 'Schofield', 'Female', '1971-07-01', 'Anathema');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Thorn', 'MacAulay', 'Male', '1989-01-30', 'Anathema');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Karla', 'Carlos', 'Female', '1947-08-15','Anathema');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Janek', 'Hinrichs', 'Male', '1962-11-12', 'Anathema');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Cesare', 'Gert', 'Non-binary', '1973-11-17', 'Cube');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Flore', 'Delgado', 'Female', '1983-02-14', 'Cube');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Agnella', 'Shillingford', 'Female', '1995-12-06', 'Cube');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Anni', 'Pharrow', 'Female', '1975-03-05','Waystar Royco');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Aldis', 'Wittman', 'Male', '1959-12-12','Waystar Royco');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Randolf', 'Geldeford', 'Male', '1964-09-14','Waystar Royco');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Trevar', 'Simeone', 'Male', '1946-09-12', 'Waystar Royco');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Shelley', 'Salleir', 'Female', '1956-01-25', 'Flux Security');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Deva', 'Cattlemull', 'Female', '1956-10-27', 'Flux Security');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Mick', 'Quarlis', 'Male', '1969-04-02', 'Flux Security');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Luci', 'Conan', 'Non-binary', '1971-12-04', 'Flux Security');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Barris', 'McKyrrelly', 'Male', '1957-07-18', 'Lifebank');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Lianne', 'Mathevet', 'Female', '1999-10-28', 'Lifebank');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Jayme', 'Davenall', 'Male', '1982-01-31', 'Singex');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Gawain', 'Suermeiers', 'Genderfluid', '1970-02-15', 'Singex');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Keri', 'Johnke', 'Female', '2003-12-19', 'Singex');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Cherilyn', 'Norval', 'Agender', '1952-03-19', 'Singex');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Kassandra', 'Ashwood', 'Female', '2000-02-12', 'North Starporation');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Grissel', 'Vautre', 'Female', '1964-05-06', 'North Starporation');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Gabriela', 'Stockley', 'Female', '1955-08-02','North Starporation');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Terri', 'Beswell', 'Male', '1987-08-23', 'North Starporation');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Andrea', 'Von Der Empten', 'Non-binary', '1956-10-18', 'North Starporation');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Roxane', 'Pressman', 'Female', '1991-04-13', 'Alphawater');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Sherie', 'Cowterd', 'Female', '1970-05-16', 'Alphawater');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Olva', 'MacFie', 'Female', '1995-02-11', 'Alphawater');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Cyrus', 'Whordley', 'Male', '1970-10-15', 'Alphawater');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Vinnie', 'Sherrock', 'Female', '1953-09-30', 'Alphawater');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Kylynn', 'McLuckie', 'Female', '1968-01-27',  'Ecorp');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Bridie', 'Price', 'Female', '1982-04-30', 'Ecorp');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Sheri', 'Valentelli', 'Female', '1984-05-17', 'Ecorp');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Jessica', 'Templar', 'Female', '2004-06-04', 'Ecorp');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Zitella', 'Georgiades', 'Female', '1980-09-08', 'Ecorp');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Aurilia', 'Thorbon', 'Female', '1978-10-18', 'Ecorp');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Teresita', 'Pohl', 'Female', '1991-01-04', 'Ecorp');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Delores', 'Dufaire', 'Genderqueer', '1972-01-10', 'Ecorp');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Erick', 'Broscombe', 'Male', '1997-03-28', 'Ecorp');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Helaina', 'Jirasek', 'Female', '1972-04-10', 'Omega Technologies');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Vernor', 'Whitnall', 'Male', '1996-10-04', 'Omega Technologies');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Cinderella', 'Micklem', 'Female', '1971-12-22', 'Omega Technologies');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Johannah', 'Bartelot', 'Female', '1978-03-06', 'Omega Technologies');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Evelyn', 'Bandiera', 'Female', '1954-12-18', 'Omega Technologies');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Derry', 'Halpen', 'Male', '1977-12-06', 'Omega Technologies');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Crosby', 'Hallatt', 'Non-binary', '1960-06-20', 'Omega Technologies');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Lorraine', 'Lassells', 'Female', '1974-03-06', 'Omega Technologies');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Dorena', 'Mulholland', 'Female', '1950-05-12', 'Omega Technologies');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Mohandas', 'Pendreigh', 'Male', '1963-10-26', 'Alpaca Beer Organisation');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Jammal', 'Clifford', 'Genderqueer', '1963-11-18','Alpaca Beer Organisation' );
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Nye', 'Shrieves', 'Male', '1982-12-19', 'Alpaca Beer Organisation');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Fania', 'Belderson', 'Female', '1955-01-02', 'Alpaca Beer Organisation');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Rurik', 'Crampsy', 'Male', '1946-05-09', 'Alpaca Beer Organisation');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Teodoor', 'Bysaker', 'Male', '1994-08-24', 'Alpaca Beer Organisation');
insert into researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) values ('Charo', 'Bleything', 'Female', '1949-09-20', 'Alpaca Beer Organisation');
-- PROJECT 
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Maintaining social bonds via music', 496976, '2021-11-05', '2023-06-06','National Technical University Of Athens','Cherin Cleverley','Silvanus', 'Cockaday', 'Music and Man', 'Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Use of AI in robotics', 155824, '2021-10-05', '2024-02-21','Athenian Center of Applied Mathematics', 'Cherin Cleverley','Carena', 'Gronauer', 'Artificial Inteligence and Consiousness', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Narcissistic personality disorder: genetic factors', 681872, '2021-10-07', '2024-09-11','Lifebank','Cherin Cleverley','Lianne', 'Mathevet','Rexamination of Personality Disorders', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Mental effects of remote work' , 362613, '2022-03-27', '2025-03-18','Lifebank','Augustina Kardos-Stowe','Lianne', 'Mathevet', 'Disability in the Workpalce', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Use of infrared detectors in alarm systems', 219356, '2021-03-05', '2024-08-10','Flux Security', 'Augustina Kardos-Stowe','Luci', 'Conan','Testing Security System Safety', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Cosmological simulations and machine learning', 228964, '2021-12-17', '2023-03-25','National Cosmologic Research Center','Esme Stowell','Alberto', 'Dadge','Artificial Inteligence and Consiousness', 'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Achieving climate-positive agriculture', 404778, '2021-11-24', '2023-03-31','National Centre of Insects', 'Esme Stowell','Jolynn', 'Fahey', 'Enviromental Crisis Solution Examination Program', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Emerging infectious diseases: detection and prevention', 580822, '2021-06-23', '2024-11-23','Lab of the Mutation of Zoogenics', 'Esme Stowell','Diandra', 'Redmell', 'Pandemics and Endemics', 'Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Technology-enhanced education in the post-COVID era', 809029, '2022-05-29', '2024-11-29','Alpaca Beer Organisation','Mercie Glasgow','Teodoor', 'Bysaker' , 'Pandemics and Endemics', 'Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Disability inclusion in the workplace', 187902, '2021-06-15', '2024-01-22','Lifebank','Candie Eades','Lianne', 'Mathevet', 'Disability in the Workpalce', 'Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Has big data changed our lives for the better?', 537340, '2021-08-24', '2024-08-13','Ecorp','Leroi Radbond', 'Zitella', 'Georgiades', 'Techology and Personhood', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Neural networks are algorithms that can learn to solve problems.', 744736, '2022-04-03', '2025-01-27','Testing Grounds of Progressed Cryptology', 'Leroi Radbond','Stephanus', 'Santer', 'Techology and Personhood', 'Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The current state of cryptography and how it may develop.', 878120, '2022-01-14', '2025-02-12','Testing Grounds of Progressed Cryptology', 'Naoma Dysart','Stephanus', 'Santer', 'Cryptology, Codes and Riddles', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The pros and cons of transitioning to cloud technologies.', 224625, '2022-01-19', '2025-07-13','Testing Bureau and Archive of Exobiology', 'Armstrong Harrisson','Waverley', 'Kelsall', 'Techology and Personhood','Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('What issues does automation raise, and how can they be solved?', 274635, '2021-08-11', '2024-02-28','Lifebank','Emyle Androck','Lianne', 'Mathevet', 'Techology and Personhood', 'Fusce consequat. Nulla nisl. Nunc nisl.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Should we keep using multi-factor authentication?', 212933, '2020-11-10', '2023-02-03','Singex','Pippy Camocke','Jayme', 'Davenall', 'Techology and Personhood', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Are big tech companies monopolistic in their behaviors?', 433284, '2020-10-06', '2023-03-22', 'Waystar Royco','Zebedee Herion','Randolf', 'Geldeford', 'Rexamination of the Capitalistic Model', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The history of the Chinese Empire over the millennia.', 173838, '2020-07-19', '2023-06-24','Iraworths History University', 'Darbie Troman','Myrtia', 'Pea' , 'Chinese History Program', 'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The rise and fall of Ancient Greek city-states.', 343394, '2020-09-15', '2023-06-23','Research Center of Adjusted Volcanology','Darbie Troman','Konstantin', 'Prebble', 'Greek History Program', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Liberalism in national politics: emergence and evolution.', 646510, '2020-09-01', '2023-11-02','Waystar Royco','Darbie Troman','Trevar', 'Simeone', 'Political Tendencies of the World', 'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('What is the correlation between personality and taste in literature?', 755446, '2020-12-30', '2023-05-09','Iroupian Academy of Psychology','Darbie Troman','Danny', 'Kubin', 'Classic Literature and the Modern Reader', 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Tricking the taste buds: how does smell affect the taste?', 955983, '2019-07-13', '2022-10-23','Iroupian Academy of Psychology','Pamela Spendlove','Danny', 'Kubin', '5+ Human Senses', 'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Music vs. body: how does your body respond?', 497778, '2019-04-30', '2022-10-02','Iroupian Academy of Psychology','Pamela Spendlove','Danny', 'Kubin', 'Music and Man' , 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Negative influences of sleep deprivation on social behavior.', 839420, '2019-06-08', '2022-12-28','Iroupian Academy of Psychology', 'Pamela Spendlove','Danny', 'Kubin', 'Sleep and Chronic Fatigue', 'Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The origin of phobias and fears: engaging the monster within', 706592, '2019-01-31', '2022-12-29','The Magnus Institute', 'Garland Redford','Giselle', 'Rylatt', 'Examination of Human Fear', 'Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.Fusce consequat. Nulla nisl. Nunc nisl.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The impact and outcomes of social networks and mental health', 465782, '2019-06-11', '2022-09-19','Waystar Royco', 'Garland Redford', 'Randolf', 'Geldeford', 'Social Networks:A Blessing or a Curse', 'Fusce consequat. Nulla nisl. Nunc nisl.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Individualized vs. group learning: which is better suited for current reality?', 132184, '2019-08-13', '2022-04-24','Iroupian Academy of Psychology', 'Garland Redford','Danny', 'Kubin', 'Studying Methods', 'Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Are standardized tests helpful or damaging to children’s education?', 111156, '2019-12-01', '2022-02-07','Iroupian Academy of Psychology', 'Kevyn Lumb', 'Danny', 'Kubin', 'Studying Methods', 'Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The interpretation of IQ test results', 191969, '2019-04-07', '2022-01-17','North Starporation','Kevyn Lumb','Grissel', 'Vautre', 'Types of Intelligence' , 'Sed ante. Vivamus tortor. Duis mattis egestas metus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Is third-wave feminism still a movement for equality?', 524119, '2019-08-26', '2022-01-31','Waystar Royco','Kevyn Lumb','Randolf', 'Geldeford', 'Political Tendencies of the World', 'Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Eating habits in dissimilar cultures', 562703, '2019-05-02', '2022-07-05','Alphawater','Kevyn Lumb', 'Olva', 'MacFie', 'Food throughout History' , 'Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Race and ethnicity-based differences in normal health indicators.', 175534, '2019-10-13', '2023-05-26','Lab of the Detection of Pathology', 'Kevyn Lumb','Amelia', 'Chichgar', 'Bias in Medicine', 'In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The development of prosthetics: current technologies and promising ideas', 614700, '2018-03-23', '2021-02-04','Lifebank','Kevyn Lumb','Barris', 'McKyrrelly' ,'Techology and Personhood', 'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Best contemporary practice in green supply chain management for businesses.', 234908, '2018-09-14', '2020-01-27','Research Center for the Detection of Phytology', 'Kevyn Lumb','Harlin', 'Mandrier', 'Reducing the Catastrophic Effecs of the Current Business', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('A cross-cultural comparison of leadership styles.', 803017, '2018-01-24', '2020-07-26','Cube','Tallie Dicke', 'Flore', 'Delgado', 'Politics and Different Cultures', 'Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Prevention of organizational misconduct: barriers and strategies.', 725392, '2017-04-24', '2020-06-05','Iroupian Academy of Psychology','Tallie Dicke', 'Danny', 'Kubin', 'Creating a Safer Workplace', 'Phasellus in felis. Donec semper sapien a libero. Nam dui.Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Discuss economic viability in corporations that operate at a loss.', 408970, '2016-09-11', '2019-08-02','National University of Mathematics', 'Art Terbeek', 'Bob', 'Widdup', 'Rexamination of the Capitalistic Model', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The evolution of Japanese literature in the Meiji Era.', 897351, '2015-03-19', '2018-12-22','Iraworths History University','Art Terbeek','Myrtia', 'Pea', 'Japanese History Program' ,'Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The traits of 20th century dystopian works.', 136586, '2014-03-07', '2017-07-04','Ivonburn Classic Studies College','Art Terbeek','Jonathon', 'Capoun', 'Classic Literature and the Modern Reader', 'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('What is the origin and purpose of powers separation in government?', 389745, '2013-12-01', '2015-05-29','Anathema', 'Robena Lanston','Thorn', 'MacAulay' , 'Politics and Different Cultures', 'Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('A comparison between the two-party system and multi-party nations.', 185507, '2013-02-15', '2016-06-14','Hellenic School of Mythology','Robena Lanston', 'Edouard', 'Westphalen' , 'Politics and Different Cultures', 'Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.Phasellus in felis. Donec semper sapien a libero. Nam dui.Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Pros and cons of globalism as a political philosophy.', 731282, '2012-07-09', '2014-09-18','Anathema','Robena Lanston', 'Thorn', 'MacAulay' ,'Politics and Different Cultures', 'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The attempts to create the theory of everything', 495566, '2012-05-18', '2015-06-23','National Academy of Scientific Adjustements','Robena Lanston','Crysta', 'Nares', 'Limitation of Science', 'Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Are people who claim to have extrasensory perception frauds?', 813565, '2012-05-02', '2014-04-09','Iroupian Academy of Psychology','Drud Conring','Danny', 'Kubin', 'Rexamination of Personality Disorders', 'Fusce consequat. Nulla nisl. Nunc nisl.Puis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Comparison of sociological laws in different historical epochs.', 603162, '2012-06-02', '2015-07-17','King Richard University', 'Drud Conring','Crysta', 'Nares' , 'Politics and Different Cultures', 'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Best practice in the diagnosis and treatment of tuberculosis.', 637703, '2012-03-12', '2014-07-06', 'Lab of the Detection of Pathology','Anissa Rummery','Amelia', 'Chichgar', 'Pandemics and Endemics','Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Potential risks for nurses in the workplace.', 564426, '2011-08-13', '2013-02-12','Bureau of Sheltered Oncogenics', 'Anissa Rummery', 'Minni', 'McKimmie', 'Safety of Medical Personel','Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Do nurses need additional stimuli to improve their qualifications?', 667966, '2011-02-20', '2013-07-19','Bureau of Sheltered Oncogenics', 'Waneta Linkleter','Minni', 'McKimmie', 'Safety of Medical Personel', 'Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('Study cases of patient violence toward nurses in the intensive care unit.', 836011, '2011-07-17', '2014-10-03', 'Research lab of Nephrology','Waneta Linkleter','Linoel', 'Good', 'Safety of Medical Personel', 'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('How is ideology reflected in architecture?', 537009, '2011-09-27', '2014-03-23','Lab of Tectonic Monitoring', 'Shannen Giacomasso', 'Leora', 'Grishukhin ', 'Infastracture and Natural Enviromnent', 'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.');
insert into project (project_title, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name, abstract) values ('The most prevalent economic issues in Greece after joining the EU', 161285, '2010-09-02', '2013-01-12','University of Prague', 'Shannen Giacomasso','Talbot', 'Kernocke', '50 years of Greek History', 'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.');
-- EVALUATION (30)
insert into evaluation (date_of_evaluation, grade) values ('1968-08-15', 1);
insert into evaluation (date_of_evaluation, grade) values ('2000-04-30', 43);
insert into evaluation (date_of_evaluation, grade) values ('1975-10-25', 64);
insert into evaluation (date_of_evaluation, grade) values ('1965-12-19', 39);
insert into evaluation (date_of_evaluation, grade) values ('2003-06-05', 51);
insert into evaluation (date_of_evaluation, grade) values ('1982-06-08', 50);
insert into evaluation (date_of_evaluation, grade) values ('1980-11-13', 99);
insert into evaluation (date_of_evaluation, grade) values ('1970-02-22', 6);
insert into evaluation (date_of_evaluation, grade) values ('1988-04-24', 92);
insert into evaluation (date_of_evaluation, grade) values ('1969-10-01', 91);
insert into evaluation (date_of_evaluation, grade) values ('2010-05-02', 12);
insert into evaluation (date_of_evaluation, grade) values ('2009-08-01', 27);
insert into evaluation (date_of_evaluation, grade) values ('2018-07-07', 90);
insert into evaluation (date_of_evaluation, grade) values ('1987-01-22', 10);
insert into evaluation (date_of_evaluation, grade) values ('2007-09-17', 79);
insert into evaluation (date_of_evaluation, grade) values ('2008-05-20', 57);
insert into evaluation (date_of_evaluation, grade) values ('1984-08-28', 48);
insert into evaluation (date_of_evaluation, grade) values ('2004-10-21', 40);
insert into evaluation (date_of_evaluation, grade) values ('1997-04-05', 23);
insert into evaluation (date_of_evaluation, grade) values ('1967-09-28', 52);
insert into evaluation (date_of_evaluation, grade) values ('2003-10-10', 59);
insert into evaluation (date_of_evaluation, grade) values ('2009-06-26', 18);
-- EVALUATE
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1968-08-15','Charo', 'Bleything','Maintaining social bonds via music');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('2000-04-30','Teodoor', 'Bysaker','Use of AI in robotics');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1975-10-25','Rurik', 'Crampsy','Narcissistic personality disorder: genetic factors');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1965-12-19','Fania', 'Belderson','Mental effects of remote work');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('2003-06-05','Nye', 'Shrieves','Use of infrared detectors in alarm systems');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1982-06-08','Jammal', 'Clifford','Cosmological simulations and machine learning');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1980-11-13','Mohandas', 'Pendreigh','Achieving climate-positive agriculture');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1970-02-22','Dorena', 'Mulholland','Emerging infectious diseases: detection and prevention');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1988-04-24','Lorraine', 'Lassells','Technology-enhanced education in the post-COVID era');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1969-10-01','Crosby', 'Hallatt','Disability inclusion in the workplace');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('2010-05-02','Derry', 'Halpen','Has big data changed our lives for the better?');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('2009-08-01','Evelyn', 'Bandiera','Neural networks are algorithms that can learn to solve problems.');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('2018-07-07','Johannah', 'Bartelot','The current state of cryptography and how it may develop.');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1987-01-22','Cinderella', 'Micklem','The pros and cons of transitioning to cloud technologies.');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('2007-09-17','Vernor', 'Whitnall','What issues does automation raise, and how can they be solved?');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('2008-05-20','Helaina', 'Jirasek','Should we keep using multi-factor authentication?');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1984-08-28','Erick', 'Broscombe','Are big tech companies monopolistic in their behaviors?');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('2004-10-21','Delores','Dufaire','The history of the Chinese Empire over the millennia.');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1997-04-05','Teresita', 'Pohl','The rise and fall of Ancient Greek city-states.');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('1967-09-28','Aurilia', 'Thorbon','Liberalism in national politics: emergence and evolution.');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('2003-10-10','Zitella', 'Georgiades','What is the correlation between personality and taste in literature?');
insert into evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) values ('2009-06-26','Jessica', 'Templar','Tricking the taste buds: how does smell affect the taste?');
-- WORKS_ON
insert into works_on (researcher_name, researcher_surname, project_title) values ('Curry', 'Cockett', 'Achieving climate-positive agriculture');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Bria', 'Yeend','Achieving climate-positive agriculture');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jolynn', 'Fahey','Achieving climate-positive agriculture');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Olivier', 'Gilhouley','Achieving climate-positive agriculture');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Giselle', 'Rylatt', 'Maintaining social bonds via music');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Giselle', 'Rylatt','The origin of phobias and fears: engaging the monster within');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Amelia', 'Chichgar', 'Emerging infectious diseases: detection and prevention');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Linoel', 'Good', 'Emerging infectious diseases: detection and prevention');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Harlin', 'Mandrier', 'Study cases of patient violence toward nurses in the intensive care unit.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Gail', 'Arnet', 'Do nurses need additional stimuli to improve their qualifications?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Chucho', 'MacDougal', 'Do nurses need additional stimuli to improve their qualifications?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Prince', 'Richly', 'Best practice in the diagnosis and treatment of tuberculosis.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Adolpho', 'Merrigan', 'Best practice in the diagnosis and treatment of tuberculosis.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Kincaid', 'Wilford','Best practice in the diagnosis and treatment of tuberculosis.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Stephanus', 'Santer', 'Use of AI in robotics');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Minni', 'McKimmie', 'Race and ethnicity-based differences in normal health indicators.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Diandra', 'Redmell', 'Potential risks for nurses in the workplace.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Konstantin', 'Prebble', 'Prevention of organizational misconduct: barriers and strategies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Pammi', 'Rosenfelt', 'Prevention of organizational misconduct: barriers and strategies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Kacey', 'Timoney', 'Prevention of organizational misconduct: barriers and strategies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Reynolds', 'Swiffin', 'Prevention of organizational misconduct: barriers and strategies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Rosemaria', 'Whyteman', 'Prevention of organizational misconduct: barriers and strategies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Alberto', 'Dadge', 'Cosmological simulations and machine learning');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Leora', 'Grishukhin', 'Prevention of organizational misconduct: barriers and strategies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Carena', 'Gronauer', 'The most prevalent economic issues in Greece after joining the EU');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Waverley', 'Kelsall', 'Cosmological simulations and machine learning');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Silvanus', 'Cockaday', 'The interpretation of IQ test results');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Dianemarie', 'Chaffin', 'The interpretation of IQ test results');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Adrea', 'Duinbleton', 'How is ideology reflected in architecture?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Patrizia', 'Gallahar', 'Music vs. body: how does your body respond?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Karil', 'Munton', 'Prevention of organizational misconduct: barriers and strategies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Pearline', 'MacConneely', 'Prevention of organizational misconduct: barriers and strategies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Meredeth', 'Lovick', 'Prevention of organizational misconduct: barriers and strategies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Otho', 'Tabert', 'Are standardized tests helpful or damaging to children’s education?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Melva', 'Escala', 'Individualized vs. group learning: which is better suited for current reality?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Talbot', 'Kernocke', 'The impact and outcomes of social networks and mental health');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Talbot', 'Kernocke','The traits of 20th century dystopian works.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Ara', 'Raftery', 'Negative influences of sleep deprivation on social behavior.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Alfred', 'Seston', 'Tricking the taste buds: how does smell affect the taste?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jonathon', 'Capoun', 'Are big tech companies monopolistic in their behaviors?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Rosco', 'Swayland','Achieving climate-positive agriculture');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Myrtia', 'Pea', 'The history of the Chinese Empire over the millennia.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Heriberto', 'Knotton','Achieving climate-positive agriculture');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Ricky', 'Lakeland', 'Achieving climate-positive agriculture');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Crysta', 'Nares', 'Achieving climate-positive agriculture');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Carl', 'McGaughay', 'What is the correlation between personality and taste in literature?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Quintina', 'Sandal', 'Liberalism in national politics: emergence and evolution.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Edouard', 'Westphalen', 'The rise and fall of Ancient Greek city-states.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Bob', 'Widdup', 'The most prevalent economic issues in Greece after joining the EU');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Danny', 'Kubin', 'Are people who claim to have extrasensory perception frauds?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Danny', 'Kubin','Comparison of sociological laws in different historical epochs.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Lea', 'Wentworth', 'Is third-wave feminism still a movement for equality?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Revkah', 'Schofield', 'Is third-wave feminism still a movement for equality?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Thorn', 'MacAulay', 'Is third-wave feminism still a movement for equality?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Thorn', 'MacAulay','Pros and cons of globalism as a political philosophy.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Karla', 'Carlos', 'The development of prosthetics: current technologies and promising ideas');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Janek', 'Hinrichs', 'The development of prosthetics: current technologies and promising ideas');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Cesare', 'Gert', 'Technology-enhanced education in the post-COVID era');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Flore', 'Delgado', 'Technology-enhanced education in the post-COVID era');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Agnella', 'Shillingford', 'Technology-enhanced education in the post-COVID era');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Anni', 'Pharrow', 'Technology-enhanced education in the post-COVID era');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Aldis', 'Wittman', 'Technology-enhanced education in the post-COVID era');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Randolf', 'Geldeford', 'A comparison between the two-party system and multi-party nations.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Trevar', 'Simeone', 'What is the origin and purpose of powers separation in government?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Shelley', 'Salleir', 'Use of infrared detectors in alarm systems');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Deva', 'Cattlemull', 'Use of infrared detectors in alarm systems');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Mick', 'Quarlis', 'Use of infrared detectors in alarm systems');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Luci', 'Conan', 'Use of infrared detectors in alarm systems');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Barris', 'McKyrrelly', 'Disability inclusion in the workplace');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Lianne', 'Mathevet', 'Disability inclusion in the workplace');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jayme', 'Davenall', 'Has big data changed our lives for the better?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Gawain', 'Suermeiers', 'Has big data changed our lives for the better?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Keri', 'Johnke', 'Has big data changed our lives for the better?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Cherilyn', 'Norval', 'Has big data changed our lives for the better?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Kassandra', 'Ashwood', 'Has big data changed our lives for the better?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Grissel', 'Vautre', 'Should we keep using multi-factor authentication?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Gabriela', 'Stockley', 'Should we keep using multi-factor authentication?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Terri', 'Beswell', 'Should we keep using multi-factor authentication?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Andrea', 'Von Der Empten', 'Should we keep using multi-factor authentication?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Roxane', 'Pressman', 'Prevention of organizational misconduct: barriers and strategies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Sherie', 'Cowterd', 'A cross-cultural comparison of leadership styles.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Olva', 'MacFie', 'Eating habits in dissimilar cultures');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Cyrus', 'Whordley', 'Eating habits in dissimilar cultures');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Vinnie', 'Sherrock', 'What issues does automation raise, and how can they be solved?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Kylynn', 'McLuckie', 'Narcissistic personality disorder: genetic factors');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Bridie', 'Price', 'Narcissistic personality disorder: genetic factors');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Sheri', 'Valentelli', 'Narcissistic personality disorder: genetic factors');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jessica', 'Templar', 'The pros and cons of transitioning to cloud technologies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Zitella', 'Georgiades', 'The pros and cons of transitioning to cloud technologies.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Aurilia', 'Thorbon', 'The current state of cryptography and how it may develop.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Teresita', 'Pohl', 'The current state of cryptography and how it may develop.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Delores', 'Dufaire', 'The current state of cryptography and how it may develop.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Erick', 'Broscombe', 'The current state of cryptography and how it may develop.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Helaina', 'Jirasek','Neural networks are algorithms that can learn to solve problems.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Vernor', 'Whitnall', 'Neural networks are algorithms that can learn to solve problems.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Cinderella', 'Micklem', 'Neural networks are algorithms that can learn to solve problems.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Johannah', 'Bartelot', 'Neural networks are algorithms that can learn to solve problems.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Evelyn', 'Bandiera', 'Neural networks are algorithms that can learn to solve problems.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Derry', 'Halpen', 'Neural networks are algorithms that can learn to solve problems.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Crosby', 'Hallatt', 'Neural networks are algorithms that can learn to solve problems.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Lorraine', 'Lassells', 'Neural networks are algorithms that can learn to solve problems.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Dorena', 'Mulholland', 'Neural networks are algorithms that can learn to solve problems.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Mohandas', 'Pendreigh', 'Discuss economic viability in corporations that operate at a loss.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jammal', 'Clifford', 'Best contemporary practice in green supply chain management for businesses.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Nye', 'Shrieves', 'Mental effects of remote work');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Fania', 'Belderson', 'Mental effects of remote work');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Rurik', 'Crampsy', 'Mental effects of remote work');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Teodoor', 'Bysaker', 'Mental effects of remote work');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Charo', 'Bleything', 'Mental effects of remote work');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jammal', 'Clifford', 'Mental effects of remote work');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jammal', 'Clifford', 'Neural networks are algorithms that can learn to solve problems.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jammal', 'Clifford', 'The current state of cryptography and how it may develop.');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jammal', 'Clifford', 'Should we keep using multi-factor authentication?');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jammal', 'Clifford', 'Narcissistic personality disorder: genetic factors');
insert into works_on (researcher_name, researcher_surname, project_title) values ('Jammal', 'Clifford', 'Technology-enhanced education in the post-COVID era');
-- SCIENTIFIC FIELD (16).
insert into scientific_field values ('Mathematics');
insert into scientific_field values ('Physics');
insert into scientific_field values ('Biochemistry');
insert into scientific_field values ('Psychology');
insert into scientific_field values ('Sociology');
insert into scientific_field values ('Political Science');
insert into scientific_field values ('History');
insert into scientific_field values ('Medicine');
insert into scientific_field values ('Computer Science');
insert into scientific_field values ('Astronomy');
insert into scientific_field values ('Geology');
-- SCIENTIFIC_FIELD_OF_PROJECT
insert into scientific_field_of_project (project_title, scientific_field) values ('Maintaining social bonds via music','Physics');
insert into scientific_field_of_project (project_title, scientific_field) values ('Use of AI in robotics','Computer Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('Narcissistic personality disorder: genetic factors', 'Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Mental effects of remote work','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Use of infrared detectors in alarm systems','Computer Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('Cosmological simulations and machine learning','Mathematics');
insert into scientific_field_of_project (project_title, scientific_field) values ('Achieving climate-positive agriculture','Geology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Emerging infectious diseases: detection and prevention','Medicine');
insert into scientific_field_of_project (project_title, scientific_field) values ('Technology-enhanced education in the post-COVID era','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Disability inclusion in the workplace','Sociology'); 
insert into scientific_field_of_project (project_title, scientific_field) values ('Has big data changed our lives for the better?','Computer Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('Neural networks are algorithms that can learn to solve problems.','Computer Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('The current state of cryptography and how it may develop.','Computer Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('The pros and cons of transitioning to cloud technologies.','Computer Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('What issues does automation raise, and how can they be solved?','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Should we keep using multi-factor authentication?','Computer Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('Are big tech companies monopolistic in their behaviors?','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('The history of the Chinese Empire over the millennia.','History');
insert into scientific_field_of_project (project_title, scientific_field) values ('The rise and fall of Ancient Greek city-states.','History');
insert into scientific_field_of_project (project_title, scientific_field) values ('Liberalism in national politics: emergence and evolution.','Political Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('What is the correlation between personality and taste in literature?','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Tricking the taste buds: how does smell affect the taste?','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Music vs. body: how does your body respond?','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Negative influences of sleep deprivation on social behavior.','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('The origin of phobias and fears: engaging the monster within','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('The impact and outcomes of social networks and mental health','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('The impact and outcomes of social networks and mental health','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Individualized vs. group learning: which is better suited for current reality?','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Are standardized tests helpful or damaging to children’s education?','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('The interpretation of IQ test results','Mathematics');
insert into scientific_field_of_project (project_title, scientific_field) values ('The interpretation of IQ test results','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Is third-wave feminism still a movement for equality?','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Eating habits in dissimilar cultures','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Race and ethnicity-based differences in normal health indicators.','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('The development of prosthetics: current technologies and promising ideas','Physics');
insert into scientific_field_of_project (project_title, scientific_field) values ('Best contemporary practice in green supply chain management for businesses.','Geology');
insert into scientific_field_of_project (project_title, scientific_field) values ('A cross-cultural comparison of leadership styles.','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Prevention of organizational misconduct: barriers and strategies.','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Discuss economic viability in corporations that operate at a loss.','Political Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('The evolution of Japanese literature in the Meiji Era.','History');
insert into scientific_field_of_project (project_title, scientific_field) values ('The traits of 20th century dystopian works.','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('What is the origin and purpose of powers separation in government?','Political Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('A comparison between the two-party system and multi-party nations.','Political Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('Pros and cons of globalism as a political philosophy.','Political Science');
insert into scientific_field_of_project (project_title, scientific_field) values ('The attempts to create the theory of everything','Mathematics');
insert into scientific_field_of_project (project_title, scientific_field) values ('The attempts to create the theory of everything','Physics');
insert into scientific_field_of_project (project_title, scientific_field) values ('The attempts to create the theory of everything','Astronomy');
insert into scientific_field_of_project (project_title, scientific_field) values ('Are people who claim to have extrasensory perception frauds?','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Comparison of sociological laws in different historical epochs.','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Best practice in the diagnosis and treatment of tuberculosis.','Biochemistry');
insert into scientific_field_of_project (project_title, scientific_field) values ('Best practice in the diagnosis and treatment of tuberculosis.','Medicine');
insert into scientific_field_of_project (project_title, scientific_field) values ('Potential risks for nurses in the workplace.','Sociology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Do nurses need additional stimuli to improve their qualifications?','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('Study cases of patient violence toward nurses in the intensive care unit.','Medicine');
insert into scientific_field_of_project (project_title, scientific_field) values ('How is ideology reflected in architecture?','Psychology');
insert into scientific_field_of_project (project_title, scientific_field) values ('The most prevalent economic issues in Greece after joining the EU','Mathematics');
insert into scientific_field_of_project (project_title, scientific_field) values ('The most prevalent economic issues in Greece after joining the EU','Sociology');
-- DELIVERABLE
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Maintaining social bonds via music','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Use of AI in robotics','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Narcissistic personality disorder: genetic factors','Deliverable 1','First Deliverable of Project','2022-10-12');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Mental effects of remote work','Deliverable 1','First Deliverable of Project','2022-11-24');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Use of infrared detectors in alarm systems','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Cosmological simulations and machine learning','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Achieving climate-positive agriculture','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Emerging infectious diseases: detection and prevention','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Technology-enhanced education in the post-COVID era','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Disability inclusion in the workplace','Deliverable 1','First Deliverable of Project','2022-11-29'); 
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Has big data changed our lives for the better?','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Neural networks are algorithms that can learn to solve problems.','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The current state of cryptography and how it may develop.','Deliverable 1','First Deliverable of Project','2022-11-23');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The pros and cons of transitioning to cloud technologies.','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('What issues does automation raise, and how can they be solved?','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Should we keep using multi-factor authentication?','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Are big tech companies monopolistic in their behaviors?','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The history of the Chinese Empire over the millennia.','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The rise and fall of Ancient Greek city-states.','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Liberalism in national politics: emergence and evolution.','Deliverable 1','First Deliverable of Project','2022-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('What is the correlation between personality and taste in literature?','Deliverable 1','First Deliverable of Project','2020-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Tricking the taste buds: how does smell affect the taste?','Deliverable 1','First Deliverable of Project','2020-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Music vs. body: how does your body respond?','Deliverable 1','First Deliverable of Project','2020-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Negative influences of sleep deprivation on social behavior.','Deliverable 1','First Deliverable of Project','2020-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The origin of phobias and fears: engaging the monster within','Deliverable 1','First Deliverable of Project','2020-11-12');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The impact and outcomes of social networks and mental health','Deliverable 1','First Deliverable of Project','2020-04-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The impact and outcomes of social networks and mental health','Deliverable 2','Second Deliverable of Project','2020-12-13');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Individualized vs. group learning: which is better suited for current reality?','Deliverable 1','First Deliverable of Project','2020-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Are standardized tests helpful or damaging to children’s education?','Deliverable 1','First Deliverable of Project','2020-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The interpretation of IQ test results','Deliverable 1','First Deliverable of Project','2020-05-05');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The interpretation of IQ test results','Deliverable 2','Second Deliverable of Project','2020-08-04');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Is third-wave feminism still a movement for equality?','Deliverable 1','First Deliverable of Project','2020-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Eating habits in dissimilar cultures','Deliverable 1','First Deliverable of Project','2020-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('Race and ethnicity-based differences in normal health indicators.','Deliverable 1','First Deliverable of Project','2020-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The development of prosthetics: current technologies and promising ideas','Deliverable 1','First Deliverable of Project','2020-11-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The attempts to create the theory of everything','Deliverable 1','First Deliverable of Project','2014-02-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The attempts to create the theory of everything','Deliverable 2','Second Deliverable of Project','2014-06-29');
insert into deliverable (project_title, deliverable_title, deliverable_abstract, deadline) values ('The attempts to create the theory of everything','Deliverable 3','Third Deliverable of Project','2014-08-29');



-- DATA FOR QUERIES
-- Insert Organizations (including research centres)
INSERT INTO organisation (organisation_name, abbreviation, postal_code, street, city) VALUES
('University of Crete', 'UoC', 74100, 'University Campus', 'Rethymno'),
('Aristotle University of Thessaloniki', 'AUTH', 54124, 'University Campus', 'Thessaloniki'),
('Democritus University of Thrace', 'DUTH', 68100, 'University Campus', 'Komotini'),
('University of the Aegean', 'UAeg', 81100, 'University Hill', 'Mytilene'),
('Technical University of Crete', 'TUC', 73100, 'University Campus', 'Chania'),
('Omega Biotech Ltd', 'OmegaBio', 54352, 'Science Park', 'Thessaloniki'),
('Delta Software Systems', 'DeltaSoft', 11528, 'Tech Park', 'Athens'),
('Zeta Energy Solutions', 'ZetaEnergy', 10442, 'Energy Center', 'Athens'),
-- Add the research centres to organisation table first
('Foundation for Research & Technology - Hellas', 'FORTH', 70013, 'N. Plastira 100', 'Heraklion'),
('Athena Research Center', 'ARC', 15125, 'Artemidos 6', 'Athens'),
('Biomedical Research Foundation', 'BRF', 11527, 'Soroyou 4', 'Athens');

-- Insert Universities
INSERT INTO university (organisation_name, budget_minedu) VALUES
('University of Crete', 4500000),
('Aristotle University of Thessaloniki', 5200000),
('Democritus University of Thrace', 3800000),
('University of the Aegean', 3200000),
('Technical University of Crete', 4100000);

-- Insert Research Centres (NOW they exist in organisation table)
INSERT INTO research_centre (organisation_name, budget_minedu, budget_private) VALUES
('Foundation for Research & Technology - Hellas', 3000000, 2000000),
('Athena Research Center', 2500000, 1500000),
('Biomedical Research Foundation', 2000000, 3000000);

-- Insert Enterprises
INSERT INTO enterprise (organisation_name, budget_equity) VALUES
('Omega Biotech Ltd', 12000000),
('Delta Software Systems', 9500000),
('Zeta Energy Solutions', 7500000);

-- Insert Telephones
INSERT INTO telephone (telephone_number, organisation_name) VALUES
('2831023456', 'University of Crete'),
('2831023457', 'University of Crete'),
('2310996888', 'Aristotle University of Thessaloniki'),
('2531034567', 'Democritus University of Thrace'),
('2251033333', 'University of the Aegean'),
('2821037777', 'Technical University of Crete'),
('2310555666', 'Omega Biotech Ltd'),
('2108888999', 'Delta Software Systems'),
('2107777666', 'Zeta Energy Solutions'),
('2810391000', 'Foundation for Research & Technology - Hellas'),
('2106543210', 'Athena Research Center'),
('2105555555', 'Biomedical Research Foundation');


-- Insert Researchers
INSERT INTO researcher (researcher_name, researcher_surname, gender, date_of_birth, organisation_name) VALUES
-- Young researchers (<40) for query 3.6
('Christos', 'Papadakis', 'Male', '1990-05-15', 'University of Crete'),
('Anna', 'Michailidou', 'Female', '1988-08-22', 'Aristotle University of Thessaloniki'),
('Dimitra', 'Georgiadou', 'Female', '1992-12-10', 'Democritus University of Thrace'),
('Stelios', 'Antonopoulos', 'Male', '1985-03-30', 'University of the Aegean'),
('Eirini', 'Karagianni', 'Female', '1995-07-18', 'Technical University of Crete'),
('Vasilis', 'Vasileiadis', 'Male', '1991-11-25', 'Omega Biotech Ltd'),
('Georgia', 'Nikolopoulou', 'Female', '1989-09-14', 'Delta Software Systems'),
('Thanasis', 'Dimitriadis', 'Male', '1993-04-05', 'Zeta Energy Solutions'),

-- Older researchers (>40)
('Konstantinos', 'Papageorgiou', 'Male', '1975-01-20', 'University of Crete'),
('Despina', 'Christodoulou', 'Female', '1978-06-12', 'Aristotle University of Thessaloniki');

-- Insert Executives
INSERT INTO executive (executive_name) VALUES
('Petros Petridis'),
('Anna Athanasiou'),
('Michalis Mavridis'),
('Eva Evangelou'),
('Stavros Stavropoulos');

-- Insert Programs
INSERT INTO program (program_name, department) VALUES
('Information and Communication Technologies', 'Computer Science'),
('Biotechnology and Bioengineering', 'Biology'),
('Renewable Energy Systems', 'Engineering'),
('Advanced Materials Science', 'Chemistry'),
('Data Science and AI', 'Computer Science');

-- Insert Projects (with consecutive years for query 3.4)
INSERT INTO project (project_title, abstract, funding, start_date, end_date, organisation_name, executive_name, researcher_name, researcher_surname, program_name) VALUES
-- Projects for University of Crete in 2022 (10+ projects)
('AI Medical Diagnostics', 'AI algorithms for medical diagnosis', 450000, '2022-01-01', '2024-12-31', 'University of Crete', 'Petros Petridis', 'Konstantinos', 'Papageorgiou', 'Information and Communication Technologies'),
('Renewable Energy Grid', 'Smart energy distribution systems', 380000, '2022-02-01', '2024-02-01', 'University of Crete', 'Anna Athanasiou', 'Christos', 'Papadakis', 'Renewable Energy Systems'),
('Autonomous Robotics', 'AI systems for autonomous robots', 520000, '2022-03-01', '2025-03-01', 'University of Crete', 'Michalis Mavridis', 'Anna', 'Michailidou', 'Information and Communication Technologies'),
('Blockchain Applications', 'Practical blockchain implementations', 410000, '2022-04-01', '2024-04-01', 'University of Crete', 'Eva Evangelou', 'Dimitra', 'Georgiadou', 'Information and Communication Technologies'),
('Quantum Algorithms', 'Developing quantum computing algorithms', 680000, '2022-05-01', '2026-05-01', 'University of Crete', 'Stavros Stavropoulos', 'Stelios', 'Antonopoulos', 'Data Science and AI'),
('Biometric Systems', 'Advanced biometric security', 350000, '2022-06-01', '2024-06-01', 'University of Crete', 'Petros Petridis', 'Eirini', 'Karagianni', 'Information and Communication Technologies'),
('Environmental IoT', 'IoT for environmental monitoring', 290000, '2022-07-01', '2024-07-01', 'University of Crete', 'Anna Athanasiou', 'Vasilis', 'Vasileiadis', 'Information and Communication Technologies'),
('AI Drug Discovery', 'Machine learning for pharmaceuticals', 550000, '2022-08-01', '2025-08-01', 'University of Crete', 'Michalis Mavridis', 'Georgia', 'Nikolopoulou', 'Biotechnology and Bioengineering'),
('Business Automation', 'Automating business processes', 420000, '2022-09-01', '2024-09-01', 'University of Crete', 'Eva Evangelou', 'Thanasis', 'Dimitriadis', 'Information and Communication Technologies'),
('Advanced NLP', 'Natural language processing research', 480000, '2022-10-01', '2024-10-01', 'University of Crete', 'Stavros Stavropoulos', 'Konstantinos', 'Papageorgiou', 'Data Science and AI'),
('Computer Vision AI', 'Image recognition systems', 510000, '2022-11-01', '2025-11-01', 'University of Crete', 'Petros Petridis', 'Christos', 'Papadakis', 'Information and Communication Technologies'),

-- Projects for University of Crete in 2023 (same count as 2022 for query 3.4)
('Medical AI 2.0', 'Next-gen medical AI systems', 470000, '2023-01-01', '2025-12-31', 'University of Crete', 'Petros Petridis', 'Konstantinos', 'Papageorgiou', 'Information and Communication Technologies'),
('Smart Energy Storage', 'Advanced energy storage solutions', 390000, '2023-02-01', '2025-02-01', 'University of Crete', 'Anna Athanasiou', 'Christos', 'Papadakis', 'Renewable Energy Systems'),
('Drone Navigation', 'AI for autonomous drone systems', 530000, '2023-03-01', '2026-03-01', 'University of Crete', 'Michalis Mavridis', 'Anna', 'Michailidou', 'Information and Communication Technologies'),
('Crypto Security', 'Enhanced cryptocurrency security', 430000, '2023-04-01', '2025-04-01', 'University of Crete', 'Eva Evangelou', 'Dimitra', 'Georgiadou', 'Information and Communication Technologies'),
('Quantum ML', 'Machine learning on quantum computers', 690000, '2023-05-01', '2027-05-01', 'University of Crete', 'Stavros Stavropoulos', 'Stelios', 'Antonopoulos', 'Data Science and AI'),
('Multi-Factor Auth', 'Advanced authentication systems', 370000, '2023-06-01', '2025-06-01', 'University of Crete', 'Petros Petridis', 'Eirini', 'Karagianni', 'Information and Communication Technologies'),
('Agricultural IoT', 'IoT for precision agriculture', 310000, '2023-07-01', '2025-07-01', 'University of Crete', 'Anna Athanasiou', 'Vasilis', 'Vasileiadis', 'Information and Communication Technologies'),
('Drug Interaction AI', 'Predicting pharmaceutical interactions', 560000, '2023-08-01', '2026-08-01', 'University of Crete', 'Michalis Mavridis', 'Georgia', 'Nikolopoulou', 'Biotechnology and Bioengineering'),
('Process Automation', 'Enterprise process automation', 440000, '2023-09-01', '2025-09-01', 'University of Crete', 'Eva Evangelou', 'Thanasis', 'Dimitriadis', 'Information and Communication Technologies'),
('Sentiment Analysis AI', 'Advanced sentiment analysis', 490000, '2023-10-01', '2025-10-01', 'University of Crete', 'Stavros Stavropoulos', 'Konstantinos', 'Papageorgiou', 'Data Science and AI'),
('3D Vision Systems', '3D object recognition technology', 520000, '2023-11-01', '2026-11-01', 'University of Crete', 'Petros Petridis', 'Christos', 'Papadakis', 'Information and Communication Technologies'),

-- Active projects for young researchers (query 3.6)
('Wearable Health Tech', 'Wearable health monitoring systems', 420000, '2023-01-01', '2025-12-31', 'Aristotle University of Thessaloniki', 'Anna Athanasiou', 'Despina', 'Christodoulou', 'Biotechnology and Bioengineering'),
('Green Energy Tech', 'Sustainable energy technologies', 580000, '2023-03-01', '2026-03-01', 'Democritus University of Thrace', 'Michalis Mavridis', 'Dimitra', 'Georgiadou', 'Renewable Energy Systems'),

-- Projects for enterprises with high funding (query 3.7)
('Biotech AI Platform', 'AI platform for biotechnology', 980000, '2023-01-01', '2026-12-31', 'Omega Biotech Ltd', 'Petros Petridis', 'Vasilis', 'Vasileiadis', 'Biotechnology and Bioengineering'),
('Enterprise Security AI', 'Corporate AI security solutions', 920000, '2023-02-01', '2025-02-01', 'Delta Software Systems', 'Anna Athanasiou', 'Georgia', 'Nikolopoulou', 'Information and Communication Technologies'),
('Advanced Energy Materials', 'New materials for energy storage', 890000, '2023-03-01', '2026-03-01', 'Zeta Energy Solutions', 'Michalis Mavridis', 'Thanasis', 'Dimitriadis', 'Advanced Materials Science');

-- Insert Works_on relationships
INSERT INTO works_on (researcher_name, researcher_surname, project_title) VALUES
-- Young researchers working on multiple active projects (query 3.6)
('Christos', 'Papadakis', 'AI Medical Diagnostics'),
('Christos', 'Papadakis', 'Renewable Energy Grid'),
('Christos', 'Papadakis', 'Computer Vision AI'),
('Christos', 'Papadakis', 'Wearable Health Tech'),

('Anna', 'Michailidou', 'Autonomous Robotics'),
('Anna', 'Michailidou', 'Drone Navigation'),
('Anna', 'Michailidou', 'Green Energy Tech'),

('Dimitra', 'Georgiadou', 'Blockchain Applications'),
('Dimitra', 'Georgiadou', 'Crypto Security'),
('Dimitra', 'Georgiadou', 'Green Energy Tech'),

('Stelios', 'Antonopoulos', 'Quantum Algorithms'),
('Stelios', 'Antonopoulos', 'Quantum ML'),

('Eirini', 'Karagianni', 'Biometric Systems'),
('Eirini', 'Karagianni', 'Multi-Factor Auth'),
('Eirini', 'Karagianni', 'Biotech AI Platform'),

-- Researchers working on projects WITHOUT deliverables (query 3.8)
('Vasilis', 'Vasileiadis', 'Environmental IoT'),
('Vasilis', 'Vasileiadis', 'Agricultural IoT'),
('Vasilis', 'Vasileiadis', 'Biotech AI Platform'),
('Vasilis', 'Vasileiadis', 'Enterprise Security AI'),
('Vasilis', 'Vasileiadis', 'Advanced Energy Materials'),

('Georgia', 'Nikolopoulou', 'AI Drug Discovery'),
('Georgia', 'Nikolopoulou', 'Drug Interaction AI'),
('Georgia', 'Nikolopoulou', 'Enterprise Security AI'),
('Georgia', 'Nikolopoulou', 'Advanced Energy Materials'),
('Georgia', 'Nikolopoulou', 'Green Energy Tech');

-- Insert Scientific Fields
INSERT INTO scientific_field (scientific_field_name) VALUES
('Artificial Intelligence'),
('Machine Learning'),
('Bioinformatics'),
('Biotechnology'),
('Renewable Energy'),
('Materials Science'),
('Data Science'),
('Quantum Computing'),
('Internet of Things'),
('Cybersecurity'),
('Pharmaceuticals');

-- Insert Scientific Fields of Projects (for interdisciplinary pairs - query 3.5)
INSERT INTO scientific_field_of_project (scientific_field, project_title) VALUES
-- Create interdisciplinary pairs
('Computer Science', 'AI Medical Diagnostics'),
('Artificial Intelligence', 'AI Medical Diagnostics'),
('Bioinformatics', 'AI Medical Diagnostics'),

('Computer Science', 'Renewable Energy Grid'),
('Renewable Energy', 'Renewable Energy Grid'),
('Internet of Things', 'Renewable Energy Grid'),

('Artificial Intelligence', 'Autonomous Robotics'),
('Machine Learning', 'Autonomous Robotics'),
('Computer Science', 'Autonomous Robotics'),

('Computer Science', 'Blockchain Applications'),
('Cybersecurity', 'Blockchain Applications'),

('Quantum Computing', 'Quantum Algorithms'),
('Computer Science', 'Quantum Algorithms'),
('Data Science', 'Quantum Algorithms'),

('Biotechnology', 'AI Drug Discovery'),
('Machine Learning', 'AI Drug Discovery'),
('Pharmaceuticals', 'AI Drug Discovery'),

('Computer Science', 'Advanced NLP'),
('Artificial Intelligence', 'Advanced NLP'),
('Data Science', 'Advanced NLP'),

('Computer Science', 'Computer Vision AI'),
('Artificial Intelligence', 'Computer Vision AI'),
('Machine Learning', 'Computer Vision AI');

-- Insert Deliverables (only for some projects to leave others without deliverables for query 3.8)
INSERT INTO deliverable (deliverable_title, deliverable_abstract, deadline, project_title) VALUES
('Initial Research Report', 'Preliminary findings and methodology', '2023-06-30', 'AI Medical Diagnostics'),
('Prototype System', 'First working prototype', '2024-01-31', 'AI Medical Diagnostics'),
('Algorithm Documentation', 'Detailed algorithm specifications', '2023-09-15', 'Renewable Energy Grid'),
('Security Assessment', 'Comprehensive security analysis', '2023-12-20', 'Blockchain Applications');

-- Insert Evaluations
INSERT INTO evaluation (date_of_evaluation, grade) VALUES
('2022-02-15', 85),
('2022-03-20', 92),
('2022-05-10', 78),
('2023-02-20', 88),
('2023-03-25', 95),
('2023-05-15', 82);

-- Insert Evaluate relationships
INSERT INTO evaluate (date_of_evaluation, researcher_name, researcher_surname, project_title) VALUES
('2022-02-15', 'Konstantinos', 'Papageorgiou', 'AI Medical Diagnostics'),
('2022-03-20', 'Despina', 'Christodoulou', 'Renewable Energy Grid'),
('2022-05-10', 'Konstantinos', 'Papageorgiou', 'Autonomous Robotics'),
('2023-02-20', 'Despina', 'Christodoulou', 'Medical AI 2.0'),
('2023-03-25', 'Konstantinos', 'Papageorgiou', 'Smart Energy Storage'),
('2023-05-15', 'Despina', 'Christodoulou', 'Drone Navigation');