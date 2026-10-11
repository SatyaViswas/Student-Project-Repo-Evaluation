CREATE DATABASE IF NOT EXISTS project_repository; 
USE project_repository; 

CREATE TABLE IF NOT EXISTS users (     
    id INT AUTO_INCREMENT PRIMARY KEY,     
    name VARCHAR(100) NOT NULL,     
    email VARCHAR(100) UNIQUE NOT NULL,     
    password VARCHAR(255) NOT NULL,     
    role ENUM('STUDENT', 'EVALUATOR') NOT NULL,     
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
);

CREATE TABLE IF NOT EXISTS projects (     
    id INT AUTO_INCREMENT PRIMARY KEY,     
    student_id INT NOT NULL,     
    title VARCHAR(200) NOT NULL,     
    abstract_text TEXT NOT NULL,     
    domain_tag VARCHAR(50) NOT NULL,     
    github_url VARCHAR(255) NOT NULL,     
    demo_url VARCHAR(255),     
    pdf_path VARCHAR(255),     
    status ENUM('DRAFT', 'SUBMITTED', 'EVALUATED') DEFAULT 'DRAFT',     
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     
    FOREIGN KEY (student_id) REFERENCES users(id) ON DELETE CASCADE 
);

CREATE TABLE IF NOT EXISTS evaluations (     
    id INT AUTO_INCREMENT PRIMARY KEY,     
    project_id INT UNIQUE NOT NULL,     
    evaluator_id INT NOT NULL,     
    problem_score INT NOT NULL,     
    code_score INT NOT NULL,     
    doc_score INT NOT NULL,     
    execution_score INT NOT NULL,     
    total_score INT NOT NULL,     
    feedback TEXT,     
    evaluated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,     
    FOREIGN KEY (project_id) REFERENCES projects(id) ON DELETE CASCADE,     
    FOREIGN KEY (evaluator_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Seed Data
INSERT INTO users (name, email, password, role) VALUES  
('Alice Student', 'alice@student.edu', 'password123', 'STUDENT'), 
('Dr. Bob Evaluator', 'bob@faculty.edu', 'password123', 'EVALUATOR'); 

INSERT INTO projects (student_id, title, abstract_text, domain_tag, github_url, demo_url, status) VALUES  
(1, 'AI Course Recommender', 'A system to recommend courses based on student performance using collaborative filtering.', 'AI', 'https://github.com/alice/course-recommender', 'https://course-recommender.demo', 'SUBMITTED');