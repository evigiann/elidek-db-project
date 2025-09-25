# ELIDEK Research Management System

A full-stack web application for managing research projects, organizations, and researchers for the Hellenic Foundation for Research and Innovation (ELIDEK). This system provides comprehensive database management with advanced analytics capabilities for research funding oversight.

## 🚀 Features

### Core Functionality
- **Project Management**: Complete CRUD operations for research projects, deliverables, and evaluations
- **Organization Management**: Handle universities, research centers, and enterprises with distinct budget types
- **Researcher Portal**: Manage researcher profiles, project assignments, and interdisciplinary collaborations
- **Program Administration**: Oversee research programs and departmental allocations

### Advanced Analytics
- **Project Duration Analysis**: Track project timelines and completion patterns
- **Funding Distribution**: Examine funding allocation across research areas
- **Interdisciplinary Research**: Identify top field pairs in collaborative projects
- **Performance Metrics**: Evaluate research outcomes and success indicators
- **Young Researcher Analytics**: Monitor researchers under 40 working on active projects
- **Executive Funding Analysis**: Top executives by company funding allocations

### User Experience
- **Responsive Design**: Bootstrap-powered interface with dark theme
- **Dynamic Filtering**: Real-time project filtering by multiple criteria
- **Interactive Forms**: User-friendly data entry with validation
- **Comprehensive Views**: Multiple database perspectives for different user needs

## 🛠️ Technology Stack

### Backend
- **Python 3.x** with Flask web framework
- **MySQL** relational database management
- **Flask-MySQLdb** for database connectivity
- **Environment-based configuration**

### Frontend
- **HTML5** templates
- **Bootstrap 5** for responsive UI components
- **Font Awesome** icons for enhanced UX
- **Custom CSS** with dark theme styling

### Key Libraries
- `flask` - Web application framework
- `flask-mysqldb` - MySQL database integration
- `flask-cors` - Cross-origin resource sharing
- `python-dotenv` - Environment variable management

## 📊 Database Schema

The system implements a comprehensive relational database with 15 interconnected tables:

![ELIDEK Portal](/database_schema.png)

### Key Features
- **Referential Integrity**: Cascading updates and deletes
- **Data Validation**: Check constraints for funding ranges, grades, and dates
- **Optimized Indexing**: Strategic indexes for query performance
- **Materialized Views**: Pre-computed researcher-project relationships

## 🚦 Installation & Setup

### Prerequisites
- Python 3.8+
- MySQL 5.7+ or MariaDB
- pip package manager

### Step-by-Step Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/evigiann/elidek-db-project.git
   cd elidek-db-project
   ```

2. **Set up Python environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

3. **Database Configuration**
   ```bash
   # Import the database schema
   mysql -u root -p < basis_creation_final.sql
   
   # Create environment configuration
   cp .env.example .env
   # Edit .env with your database credentials
   ```

4. **Configure Environment Variables**
   ```env
   DB_HOST=localhost
   DB_USER=your_username
   DB_PASSWORD=your_password
   DB_NAME=sql7799656
   DB_PORT=3306
   ```

5. **Run the Application**
   ```bash
   python app.py
   ```
   Access the application at `http://localhost:5000`

## 📈 Key SQL Features Implemented

### Complex Queries
1. **Organization Consistency**: Find organizations with same project counts in consecutive years
2. **Interdisciplinary Analysis**: Top 3 field pairs across projects
3. **Young Researcher Tracking**: Researchers under 40 with most active projects
4. **Executive Performance**: Top 5 executives by single-company funding
5. **Project Deliverable Analysis**: Researchers in projects without deliverables

### Optimization Techniques
- **Materialized Views**: `project_per_researcher_view`, `researcher_info`
- **Strategic Indexing**: Optimized for frequent query patterns
- **Efficient JOINs**: Properly indexed relationships for performance
- **Aggregate Functions**: Advanced statistical analysis

## 🎯 About Project

### Project Requirements Met
- ✅ ER and Relational Diagram design
- ✅ Comprehensive DDL with constraints and indexes
- ✅ Advanced SQL queries with optimization
- ✅ Full-stack web application implementation
- ✅ User-friendly interface without SQL knowledge requirement
- ✅ Data integrity and validation enforcement

## 🔧 API Endpoints

### Data Exploration
- `/explore_programs` - Browse available research programs
- `/explore_projects` - Filter projects by date, duration, executive
- `/explore_researchers` - View researcher-project relationships
- `/explore_scientific_fields` - Field-specific project and researcher analysis

### Advanced Analytics
- `/fun_fact_1` - Organization project consistency analysis
- `/fun_fact_2` - Interdisciplinary field pairs
- `/fun_fact_3` - Young researchers in active projects
- `/fun_fact_4` - Executive funding analysis
- `/fun_fact_5` - Researchers in projects without deliverables

### Data Management
- CRUD operations for all entities: programs, executives, organizations, researchers, projects



