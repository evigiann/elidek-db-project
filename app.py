from flask import Flask, render_template, request, redirect
from flask_mysqldb import MySQL
from flask_cors import CORS
import os
from dotenv import load_dotenv


# Load environment variables from .env file if it exists
if os.path.exists('.env'):
    load_dotenv()


# creating a Flask app

app = Flask(__name__)
app.config['MYSQL_HOST'] = os.environ.get('DB_HOST')
app.config['MYSQL_USER'] = os.environ.get('DB_USER')
app.config['MYSQL_PASSWORD'] = os.environ.get('DB_PASSWORD')
app.config['MYSQL_DB'] = os.environ.get('DB_NAME')
app.config['MYSQL_PORT'] = int(os.environ.get('DB_PORT', 3306))
mysql = MySQL(app)
CORS(app)


@app.route('/')
def home():
    return render_template("home.html")
#project info
@app.route('/info')
def info(): 
    return render_template("info.html")
#explore database page
@app.route('/explore')
def explore():
        return render_template("explore.html")
#update database page
@app.route('/update')
def update():
    return render_template("update.html")
#explore programs tab (aka 3.1)
@app.route('/explore_programs',methods = ['GET'])
def explore_programs():
    program_details=[]
    if request.method == 'GET': 
        cur = mysql.connection.cursor()
        cur.execute("SELECT program_name, department FROM program")
        program_details = cur.fetchall()
        return render_template("explore_programs.html",program_details=program_details)
#explore projects tabs (aka also 3.1)
@app.route('/explore_projects', methods=['POST', 'GET'])
def explore_projects():
    return render_template('explore_projects.html')
#for getting project criteria and returning projects 
@app.route('/explore_projects_2', methods=['POST'])
def explore_projects_2():
    project_details = []
    if request.method == 'POST':
        project_get_details = request.form
        start_date = project_get_details['start_date']
        duration = project_get_details['duration']
        executive = project_get_details['executive']
        cur = mysql.connection.cursor()
        #no criteria
        if start_date == '' and executive == '' and duration == '': 
            cur.execute("""SELECT project.project_title, project.funding, project.start_date, executive.executive_name, TIMESTAMPDIFF(year, start_date,end_date) AS duration
                            FROM project INNER JOIN executive 
                            ON project.executive_name=executive.executive_name""")
            project_details = cur.fetchall()
            cur.close()
            return render_template('explore_projects_2.html', project_details=project_details)
        #just the start_date
        elif duration == '' and executive == '':
            cur.execute("""SELECT project.project_title, project.funding, project.start_date, executive.executive_name, TIMESTAMPDIFF(year, start_date,end_date) AS duration
                            FROM project INNER JOIN executive 
                            ON project.executive_name=executive.executive_name
                            WHERE (project.start_date >= '{}');""".format(start_date))
            project_details = cur.fetchall()
            cur.close()
            return render_template('explore_projects_2.html', project_details=project_details)
        #just the duration
        elif start_date == '' and executive == '': 
            cur.execute("""SELECT project.project_title, project.funding, project.start_date, executive.executive_name, TIMESTAMPDIFF(year, start_date,end_date) AS duration
                            FROM project INNER JOIN executive 
                            ON project.executive_name=executive.executive_name
                            WHERE (DATEDIFF(end_date,start_date) DIV 365 ='{}');""".format(duration))
            project_details = cur.fetchall()
            cur.close()
            return render_template('explore_projects_2.html', project_details=project_details)
        #just the executive
        elif start_date == '' and duration=='': 
            cur.execute("""SELECT project.project_title, project.funding, project.start_date, executive.executive_name, TIMESTAMPDIFF(year, start_date,end_date) AS duration
                            FROM project INNER JOIN executive 
                            ON project.executive_name=executive.executive_name
                            WHERE (executive.executive_name = '{}' );""".format(executive))
            project_details = cur.fetchall()
            cur.close()
            return render_template('explore_projects_2.html', project_details=project_details)
        #start_date and duration
        elif executive == '':
            cur.execute("""SELECT project.project_title, project.funding, project.start_date, executive.executive_name, TIMESTAMPDIFF(year, start_date,end_date) AS duration
                            FROM project INNER JOIN executive 
                            ON project.executive_name=executive.executive_name
                            WHERE (project.start_date >= '{}'
                            AND DATEDIFF(end_date,start_date) DIV 365 = '{}');""".format(start_date,duration))
            project_details = cur.fetchall()
            cur.close()
            return render_template('explore_projects_2.html', project_details=project_details)
        #start_date and executive
        elif duration == '': 
            cur.execute("""SELECT project.project_title, project.funding, project.start_date, executive.executive_name, TIMESTAMPDIFF(year, start_date,end_date) AS duration
                            FROM project INNER JOIN executive 
                            ON project.executive_name=executive.executive_name
                            WHERE (project.start_date >= '{}'
                            AND executive.executive_name = '{}' );""".format(start_date,executive))
            project_details = cur.fetchall()
            cur.close()
            return render_template('explore_projects_2.html', project_details=project_details)
        #executive and duration
        elif start_date =='':
            cur.execute("""SELECT project.project_title, project.funding, project.start_date, executive.executive_name, TIMESTAMPDIFF(year, start_date,end_date) AS duration
                            FROM project INNER JOIN executive 
                            ON project.executive_name=executive.executive_name
                            WHERE (DATEDIFF(end_date,start_date) DIV 365 = '{}'
                            AND executive.executive_name = '{}' );""".format(duration,executive))
            project_details = cur.fetchall()
            cur.close()
            return render_template('explore_projects_2.html', project_details=project_details)
        #executive and start_date and duration
        else:
            cur.execute("""SELECT project.project_title, project.funding, project.start_date, executive.executive_name, TIMESTAMPDIFF(year, start_date,end_date) AS duration
                            FROM project INNER JOIN executive 
                            ON project.executive_name=executive.executive_name
                            WHERE (project.start_date >= '{}'
                            AND DATEDIFF(end_date,start_date) DIV 365 = '{}'
                            AND executive.executive_name = '{}' );""".format(start_date,duration,executive))
            project_details = cur.fetchall()
            cur.close()
            return render_template('explore_projects_2.html', project_details=project_details)
    return render_template('explore_projects_2.html', project_details=project_details)
#for getting project name and returning researchers working there 
@app.route('/explore_projects_3', methods=['POST'])
def explore_projects_3():
    project_details = []
    if request.method == 'POST':
        project_get_details = request.form
        project_name= project_get_details['project_name']
        cur = mysql.connection.cursor() 
        cur.execute("""SELECT researcher.researcher_name AS 'Researcher name', researcher.researcher_surname AS 'Researcher surname'
                        FROM researcher INNER JOIN works_on
                        ON  researcher.researcher_name=works_on.researcher_name AND researcher.researcher_surname=works_on.researcher_surname 
                        WHERE works_on.project_title = '{}';""".format(project_name))
        project_details = cur.fetchall()
        cur.close()
        return render_template('explore_projects_3.html', project_details=project_details)
#explore researchers (aka 3.2)
@app.route('/explore_researchers')
def explore_researchers():
    return render_template("explore_researchers.html")
    
@app.route('/researcher_info', methods=['POST', 'GET'])
def researcher_info():
    researcher_details=[]
    if request.method == 'GET':
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM researcher_info ")
        researcher_details = cur.fetchall()
        cur.close()
    return render_template('researcher_info.html', researcher_details=researcher_details)

@app.route('/researcher_per_project', methods=['POST', 'GET'])
def researcher_per_project():
    researcher_details=[]
    if request.method == 'GET':
        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM project_per_researcher_view ;")
        researcher_details = cur.fetchall()
        cur.close()
    return render_template('researcher_per_project.html', researcher_details=researcher_details)

#exlore scientific fields(aka 3.3)
@app.route('/explore_scientific_fields', methods=['POST', 'GET'])
def explore_scientific_fields():
    return render_template("explore_scientific_fields.html")
#returning projects
@app.route('/explore_scientific_fields_2',methods = ['POST'])
def explore_scientific_fields_2():
        field_details=[]
        if request.method == 'POST':
            scientific_field_details = request.form
            scientific_field = scientific_field_details ['scientific_field']
            cur = mysql.connection.cursor()
            cur.execute("""SELECT project.project_title,scientific_field_of_project.project_title FROM project 
                        INNER JOIN scientific_field_of_project  ON
                        project.project_title = scientific_field_of_project.project_title
                        WHERE scientific_field_of_project.scientific_field='{}' AND ((curdate()<project.end_date) AND (curdate()>project.start_date)); """.format(scientific_field))
            field_details = cur.fetchall()
            cur.close()
            return render_template("explore_scientific_fields_2.html", field_details=field_details)
#returning researchers
@app.route('/explore_scientific_fields_3',methods = ['POST'])
def explore_scientific_fields_3():
        field_details=[]
        if request.method == 'POST':
            scientific_field_details = request.form
            scientific_field = scientific_field_details ['scientific_field']
            cur = mysql.connection.cursor()
            cur.execute("""SELECT researcher.researcher_name,works_on.researcher_name, researcher.researcher_surname,works_on.researcher_surname FROM researcher 
                                INNER JOIN works_on 
                                ON researcher.researcher_name = works_on.researcher_name AND researcher.researcher_surname = works_on.researcher_surname
                                WHERE works_on.project_title IN
                                ( SELECT project.project_title FROM project
                                INNER JOIN scientific_field_of_project 
                                ON project.project_title = scientific_field_of_project.project_title
                                WHERE((scientific_field_of_project.scientific_field='{}')
                                AND( project.start_date<=DATE_SUB(CURDATE(),INTERVAL 1 YEAR)) AND ((curdate()<project.end_date) AND (curdate()>project.start_date))
                                ));""".format(scientific_field))
            field_details = cur.fetchall()
            cur.close()
            return render_template("explore_scientific_fields_3.html", field_details=field_details)
#for the more niche queries
@app.route('/other')
def other():
    return render_template("other.html")
#3.4
@app.route('/fun_fact_1',methods = ['POST','GET'])
def fun_fact_1():
    fun_fact_details_1=[]
    if request.method == 'GET': 
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT o1.organisation_name, o1.year AS first_year, o2.year AS second_year, o1.project_count
            FROM (
                SELECT o.organisation_name, YEAR(p.start_date) AS year, COUNT(*) AS project_count
                FROM organisation o 
                INNER JOIN project p ON o.organisation_name = p.organisation_name
                GROUP BY o.organisation_name, YEAR(p.start_date)
                HAVING COUNT(*) >= 10
            ) o1
            INNER JOIN (
                SELECT o.organisation_name, YEAR(p.start_date) AS year, COUNT(*) AS project_count
                FROM organisation o 
                INNER JOIN project p ON o.organisation_name = p.organisation_name
                GROUP BY o.organisation_name, YEAR(p.start_date)
                HAVING COUNT(*) >= 10
            ) o2 ON o1.organisation_name = o2.organisation_name 
                 AND o2.year = o1.year + 1 
                 AND o1.project_count = o2.project_count
            ORDER BY o1.project_count DESC
        """)
        fun_fact_details_1 = cur.fetchall()
        return render_template("fun_fact_1.html", fun_fact_details_1=fun_fact_details_1)
#3.5
@app.route('/fun_fact_2',methods = ['POST','GET'])
def fun_fact_2():
    fun_fact_details_2=[]
    if request.method == 'GET': 
        cur = mysql.connection.cursor()
        cur.execute("""SELECT count(sfop1.project_title) AS counter, sfop1.scientific_field AS field1, sfop2.scientific_field AS field2
                    FROM scientific_field_of_project sfop1 INNER JOIN scientific_field_of_project sfop2
                    ON (sfop1.scientific_field<sfop2.scientific_field AND sfop1.project_title=sfop2.project_title)
                    GROUP BY
                    sfop1.scientific_field,
                    sfop2.scientific_field
                    ORDER BY counter DESC LIMIT 3;""")
        fun_fact_details_2 = cur.fetchall()
        return render_template("fun_fact_2.html",fun_fact_details_2=fun_fact_details_2)
@app.route('/fun_fact_3',methods = ['POST','GET'])
def fun_fact_3():
    fun_fact_details_3=[]
    if request.method == 'GET': 
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT researcher_name, researcher_surname, age, COUNT(project_title) as counter
            FROM project_per_researcher_view
            WHERE project_title IN (
                SELECT project_title FROM project 
                WHERE CURDATE() BETWEEN start_date AND end_date
            )
            AND age < 40
            GROUP BY researcher_name, researcher_surname, age
            ORDER BY counter DESC 
        """)
        fun_fact_details_3 = cur.fetchall()
        return render_template("fun_fact_3.html", fun_fact_details_3=fun_fact_details_3)
#3.7
@app.route('/fun_fact_4',methods = ['POST','GET'])
def fun_fact_4():
    fun_fact_details_4=[]
    if request.method == 'GET': 
        cur = mysql.connection.cursor()
        cur.execute("""SELECT  executive_name, funding, project.organisation_name, enterprise.organisation_name
                        FROM project
                        INNER JOIN enterprise ON project.organisation_name=enterprise.organisation_name
                        ORDER BY funding DESC limit 5;""")
        fun_fact_details_4 = cur.fetchall()
        return render_template("fun_fact_4.html",fun_fact_details_4=fun_fact_details_4)
@app.route('/fun_fact_5',methods = ['POST','GET'])
def fun_fact_5():
    fun_fact_details_5=[]
    if request.method == 'GET': 
        cur = mysql.connection.cursor()
        cur.execute("""
            SELECT w.researcher_name, w.researcher_surname, COUNT(DISTINCT w.project_title) as project_count
            FROM works_on w
            WHERE w.project_title NOT IN (
                SELECT DISTINCT project_title FROM deliverable
            )
            GROUP BY w.researcher_name, w.researcher_surname 
            HAVING project_count >= 5
            ORDER BY project_count DESC
        """)
        fun_fact_details_5 = cur.fetchall()
        return render_template("fun_fact_5.html", fun_fact_details_5=fun_fact_details_5)
#delete page 
@app.route('/delete_existing_data')
def delete_existing_data():
    return render_template("delete_existing_data.html")
#insert page
@app.route('/insert_new_data')
def insert_new_data():
    return render_template("insert_new_data.html")
#insert program
@app.route('/insert_program', methods = ['POST','GET'])
def insert_program():
    if request.method == 'POST':
        program_details = request.form
        program_name = program_details['program_name']
        department = program_details ['department']
        cur = mysql.connection.cursor()
        if(program_name=='' or department==''):
            return render_template("insert_program.html", message = 'Error in Creating New Program')
        cur.execute("INSERT INTO program (program_name, department) VALUES ('{}', '{}')".format(program_name,department))
        mysql.connection.commit()
        return render_template("insert_program.html",message = 'Succesfully Created New Program!')
    elif request.method == 'GET':
        return render_template('insert_program.html',message = '')
#insert executive
@app.route('/insert_executive', methods = ['POST','GET'])
def insert_executive():
    if request.method == 'POST':
        executive_details = request.form
        executive_name = executive_details['executive_name']
        cur = mysql.connection.cursor()
        if(executive_name ==''):
            return render_template("insert_executive.html", message = 'Error in Creating New Executive')
        cur.execute("INSERT INTO executive (executive_name) VALUES ('{}')".format(executive_name))
        mysql.connection.commit()
        return render_template("insert_executive.html", message = 'Succesfully Created New Executive!')
    elif request.method == 'GET':
        return render_template('insert_executive.html',message = '')
#insert organisation
@app.route('/insert_organisation', methods = ['POST','GET'])
def insert_organisation():
    if request.method == 'POST':
        organisation_details = request.form
        organisation_name = organisation_details['organisation_name']
        abbreviation = organisation_details['abbreviation']
        postal_code = organisation_details['postal_code']
        street = organisation_details['street']
        city = organisation_details['city']
        telephone = organisation_details['telephone']
        type = organisation_details['type']
        budget_minedu = organisation_details['budget_minedu']
        budget_private = organisation_details['budget_private']
        budget_equity = organisation_details ['budget_equity']
        cur = mysql.connection.cursor()
        if((abbreviation =='' or postal_code=='' or street== '' or city =='' or type == '') and (telephone =='' and organisation_name=='')):
            return render_template("insert_organisation.html", message = 'Error in Creating New Organisation')
        if (organisation_name !='' and telephone!='' and (abbreviation =='' or postal_code=='' or street== '' or city =='' or type == '')):
            cur.execute("INSERT INTO telephone (telephone_number,organisation_name ) VALUES ('{}', '{}');".format(telephone,organisation_name))
            mysql.connection.commit()
            return render_template("insert_organisation.html", message = 'Added New Telephone Number!')
        cur.execute("INSERT INTO organisation (organisation_name, abbreviation, postal_code, street, city) VALUES ('{}', '{}','{}','{}','{}');".format(organisation_name,abbreviation,postal_code,street,city))
        mysql.connection.commit()
        if(type=='research_center'):
            cur.execute("INSERT INTO research_centre (organisation_name, budget_minedu, budget_private) VALUES ('{}', '{}','{}');".format(organisation_name,budget_minedu,budget_private))
            mysql.connection.commit()
        elif (type=='university'):
            cur.execute("INSERT INTO university (organisation_name,budget_minedu) VALUES ('{}','{}');".format(organisation_name,budget_minedu))
            mysql.connection.commit()
        elif (type=='enterprise'):
            cur.execute("INSERT INTO enterprise (organisation_name,budget_equity) VALUES ('{}', '{}');".format(organisation_name,budget_equity))
            mysql.connection.commit()
        else:
            return render_template("insert_organisation.html", message = 'Error in Creating New Organisation')
        return render_template("insert_organisation.html", message = 'Succesfully Created Organisation!')
    elif request.method == 'GET':
        return render_template('insert_organisation.html',message = '')
#insert researcher 
@app.route('/insert_researcher', methods = ['POST','GET'])
def insert_researcher():
    if request.method == 'POST':
        researcher_details = request.form
        researcher_name = researcher_details['researcher_name']
        researcher_surname = researcher_details['researcher_surname']
        gender = researcher_details['gender']
        date_of_birth = researcher_details['date_of_birth']
        organisation_name=researcher_details['organisation_name']
        project_title = researcher_details['project_title']
        cur = mysql.connection.cursor()
        if(researcher_name =='' or researcher_surname =='' or ((gender=='' or date_of_birth=='' or organisation_name=='') and project_title=='')):
            return render_template("insert_researcher.html", message = 'Error in Creating New Researcher')
        if(gender!='' and date_of_birth!='' and organisation_name!=''):
            cur.execute("""INSERT INTO researcher (researcher_name,researcher_surname , gender, date_of_birth, organisation_name)
                        VALUES ('{}', '{}', '{}', '{}',  '{}');
                        """.format(researcher_name,researcher_surname,gender,date_of_birth,organisation_name))
            mysql.connection.commit()
        if(project_title!=''):
            cur.execute("""INSERT INTO works_on (researcher_name,researcher_surname,project_title)
                        VALUES ('{}', '{}','{}');""".format(researcher_name,researcher_surname,project_title))
            mysql.connection.commit()
        return render_template("insert_researcher.html", message = 'Succesfully Created Researcher!')
    elif request.method == 'GET':
        return render_template('insert_researcher.html',message = '')
#insert project 
@app.route('/insert_project', methods = ['POST','GET'])
def insert_project():
    if request.method == 'POST':
        flag = False
        project_details = request.form
        project_title = project_details['project_title']
        abstract = project_details['abstract']
        funding = project_details['funding']
        start_date = project_details['start_date']
        end_date = project_details['end_date']
        organisation_name = project_details['organisation_name']
        executive_name = project_details['executive_name']
        responsible_researcher_name = project_details['responsible_researcher_name']
        responsible_researcher_surname = project_details['responsible_researcher_surname']
        program_name = project_details['program_name']
        evaluation_grade = project_details ['evaluation_grade']
        evaluation_date = project_details ['evaluation_date']
        evaluating_researcher_name = project_details ['evaluating_researcher_name']
        evaluating_researcher_surname = project_details['evaluating_researcher_surname']
        scientific_field = project_details['scientific_field']
        deliverable_title = project_details ['deliverable_title']
        deliverable_abstract = project_details ['deliverable_abstract']
        deliverable_due_date = project_details ['deliverable_due_date']
        cur = mysql.connection.cursor()
        if(project_title!='' and abstract!='' and funding!='' and start_date!='' and end_date!='' and organisation_name!='' and executive_name!='' and program_name!='' and responsible_researcher_name!='' and responsible_researcher_surname!=''):
            cur.execute("""INSERT INTO project (project_title, abstract, funding, start_date, end_date,organisation_name, executive_name,researcher_name, researcher_surname, program_name)
                        VALUES ('{}', '{}','{}','{}', '{}', '{}','{}','{}','{}','{}');
                        """.format(project_title,abstract,funding,start_date,end_date,organisation_name,executive_name,responsible_researcher_name,responsible_researcher_surname,program_name))
            mysql.connection.commit()
            flag=True
        if(project_title!='' and evaluation_grade=='' and evaluation_date!='' and evaluating_researcher_name!='' and evaluating_researcher_surname!=''):
            cur.execute("""INSERT INTO evaluation (date_of_evaluation,grade)
                            VALUES ('{}','{}');""".format(evaluation_date,evaluation_grade))
            mysql.connection.commit()
            cur.execute("""INSERT INTO evaluate (date_of_evaluation, researcher_name,researcher_surname, project_title)
                            VALUES ('{}', '{}','{}','{}');""".format(evaluation_date,evaluating_researcher_name,evaluating_researcher_surname,project_title))
            mysql.connection.commit()
            flag=True
        if(project_title!='' and deliverable_title!='' and deliverable_abstract!='' and deliverable_due_date!=''):
            cur.execute("""INSERT INTO deliverable (deliverable_abstract, deliverable_title,deadline,project_title)
                            VALUES ('{}','{}','{}','{}');""".format(deliverable_abstract,deliverable_title,deliverable_due_date,project_title))
            mysql.connection.commit()
            flag=True
        if(project_title!='' and scientific_field!=''):
            cur.execute("""INSERT INTO scientific_field_of_project (scientific_field,project_title)
                            VALUES ('{}','{}');""".format(scientific_field,project_title))
            mysql.connection.commit()
            flag=True 
        if flag:
            return render_template("insert_project.html", message = 'Succesfully Created New Project!')
        else:
            return render_template("insert_project.html", message = 'Error in Creating New Researcher')
    elif request.method == 'GET':
        return render_template('insert_project.html',message = '')
#insert program 
@app.route('/delete_program', methods = ['POST','GET'])
def delete_program():
    if request.method == 'POST':
        program_details = request.form
        program_name = program_details['program_name']
        cur = mysql.connection.cursor()
        if(program_name==''):
            return render_template("delete_program.html", message = 'Error in Deleting Program')
        cur.execute("DELETE FROM program WHERE program_name ='{}';".format(program_name))
        mysql.connection.commit()
        return render_template("delete_program.html", message = 'Succesfully Deleted Program!')
    elif request.method == 'GET':
        return render_template('delete_program.html',message = '')
#insert executive 
@app.route('/delete_executive', methods = ['POST','GET'])
def delete_executive():
    if request.method == 'POST':
        executive_details = request.form
        executive_name = executive_details['executive_name']
        cur = mysql.connection.cursor()
        if(executive_name ==''):
            return render_template("delete_executive.html", message = 'Error in Deleting Executive')
        cur.execute("DELETE FROM executive WHERE executive_name ='{}';".format(executive_name))
        mysql.connection.commit()
        return render_template("delete_executive.html", message = 'Succesfully Deeleted Executive!')
    elif request.method == 'GET':
        return render_template('delete_executive.html',message = '')
#insert organisation
@app.route('/delete_organisation', methods = ['POST','GET'])
def delete_organisation():
   if request.method == 'POST':
        organisation_details = request.form
        organisation_name =  organisation_details['organisation_name']
        cur = mysql.connection.cursor()
        if(organisation_name ==''):
            return render_template("delete_organisation.html", message = 'Error in Deleting Organisation')
        cur.execute("DELETE FROM organisation WHERE organisation_name ='{}';".format(organisation_name))
        mysql.connection.commit()
        return render_template("delete_organisation.html", message = 'Succesfully Deleted Organisation!')
   elif request.method == 'GET':
        return render_template('delete_organisation.html',message = '')
#delete researcher 
@app.route('/delete_researcher', methods = ['POST','GET'])
def delete_researcher():
   if request.method == 'POST':
        researcher_details = request.form
        researcher_name =  researcher_details['researcher_name']
        researcher_surname =  researcher_details['researcher_surname']
        cur = mysql.connection.cursor()
        if(researcher_name =='' or researcher_surname==''):
            return render_template("delete_researcher.html", message = 'Error in Deleting Researcher')
        cur.execute("DELETE FROM researcher WHERE researcher_name='{}' AND researcher_surname='{}';".format(researcher_name,researcher_surname))
        mysql.connection.commit()
        return render_template("delete_researcher.html", message = 'Succesfully Deleted Researcher!')
   elif request.method == 'GET':
        return render_template('delete_researcher.html',message = '')
#delete project 
@app.route('/delete_project', methods = ['POST','GET'])
def delete_project():
   if request.method == 'POST':
        project_details = request.form
        project_title =  project_details['project_title']
        cur = mysql.connection.cursor()
        if(project_title =='' ):
            return render_template("delete_project.html", message = 'Error in Deleting Project')
        cur.execute("DELETE FROM project WHERE project_title='{}';".format(project_title))
        mysql.connection.commit()
        return render_template("delete_project.html", message = 'Succesfully Deleted Project!')
   elif request.method == 'GET':
        return render_template('delete_project.html',message = '')

if __name__ == '__main__':
    port = int(os.environ.get("PORT", 5000))
    app.run(host='0.0.0.0', port=port, debug=False)

