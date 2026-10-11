package com.project.dao;

import com.project.model.Evaluation;
import com.project.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class EvaluationDAO {

    public boolean createEvaluation(Evaluation evaluation) {
        String sql = "INSERT INTO evaluations (project_id, evaluator_id, problem_score, code_score, doc_score, execution_score, total_score, feedback) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, evaluation.getProjectId());
            stmt.setInt(2, evaluation.getEvaluatorId());
            stmt.setInt(3, evaluation.getProblemScore());
            stmt.setInt(4, evaluation.getCodeScore());
            stmt.setInt(5, evaluation.getDocScore());
            stmt.setInt(6, evaluation.getExecutionScore());
            stmt.setInt(7, evaluation.getTotalScore());
            stmt.setString(8, evaluation.getFeedback());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Evaluation getEvaluationByProjectId(int projectId) {
        String sql = "SELECT * FROM evaluations WHERE project_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Evaluation ev = new Evaluation();
                    ev.setId(rs.getInt("id"));
                    ev.setProjectId(rs.getInt("project_id"));
                    ev.setEvaluatorId(rs.getInt("evaluator_id"));
                    ev.setProblemScore(rs.getInt("problem_score"));
                    ev.setCodeScore(rs.getInt("code_score"));
                    ev.setDocScore(rs.getInt("doc_score"));
                    ev.setExecutionScore(rs.getInt("execution_score"));
                    ev.setTotalScore(rs.getInt("total_score"));
                    ev.setFeedback(rs.getString("feedback"));
                    ev.setEvaluatedAt(rs.getTimestamp("evaluated_at"));
                    return ev;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateEvaluation(Evaluation evaluation) {
        String sql = "UPDATE evaluations SET evaluator_id=?, problem_score=?, code_score=?, doc_score=?, execution_score=?, total_score=?, feedback=? WHERE project_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, evaluation.getEvaluatorId());
            stmt.setInt(2, evaluation.getProblemScore());
            stmt.setInt(3, evaluation.getCodeScore());
            stmt.setInt(4, evaluation.getDocScore());
            stmt.setInt(5, evaluation.getExecutionScore());
            stmt.setInt(6, evaluation.getTotalScore());
            stmt.setString(7, evaluation.getFeedback());
            stmt.setInt(8, evaluation.getProjectId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
