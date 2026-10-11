package com.project.model;

import java.sql.Timestamp;

public class Evaluation {
    private int id;
    private int projectId;
    private int evaluatorId;
    private int problemScore;
    private int codeScore;
    private int docScore;
    private int executionScore;
    private int totalScore;
    private String feedback;
    private Timestamp evaluatedAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getProjectId() { return projectId; }
    public void setProjectId(int projectId) { this.projectId = projectId; }

    public int getEvaluatorId() { return evaluatorId; }
    public void setEvaluatorId(int evaluatorId) { this.evaluatorId = evaluatorId; }

    public int getProblemScore() { return problemScore; }
    public void setProblemScore(int problemScore) { this.problemScore = problemScore; }

    public int getCodeScore() { return codeScore; }
    public void setCodeScore(int codeScore) { this.codeScore = codeScore; }

    public int getDocScore() { return docScore; }
    public void setDocScore(int docScore) { this.docScore = docScore; }

    public int getExecutionScore() { return executionScore; }
    public void setExecutionScore(int executionScore) { this.executionScore = executionScore; }

    public int getTotalScore() { return totalScore; }
    public void setTotalScore(int totalScore) { this.totalScore = totalScore; }

    public String getFeedback() { return feedback; }
    public void setFeedback(String feedback) { this.feedback = feedback; }

    public Timestamp getEvaluatedAt() { return evaluatedAt; }
    public void setEvaluatedAt(Timestamp evaluatedAt) { this.evaluatedAt = evaluatedAt; }
}
