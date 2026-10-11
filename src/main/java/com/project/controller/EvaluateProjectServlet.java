package com.project.controller;

import com.project.dao.EvaluationDAO;
import com.project.dao.ProjectDAO;
import com.project.model.Evaluation;
import com.project.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/EvaluateProjectServlet")
public class EvaluateProjectServlet extends HttpServlet {

    private ProjectDAO projectDAO = new ProjectDAO();
    private EvaluationDAO evaluationDAO = new EvaluationDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            resp.setStatus(401);
            out.print("{\"success\": false, \"message\": \"Not authenticated.\"}");
            return;
        }
        
        User user = (User) session.getAttribute("loggedUser");
        if (!"EVALUATOR".equals(user.getRole())) {
            resp.setStatus(403);
            out.print("{\"success\": false, \"message\": \"Access denied.\"}");
            return;
        }

        try {
            int projectId = Integer.parseInt(req.getParameter("projectId"));
            int problemScore = Integer.parseInt(req.getParameter("problemScore"));
            int codeScore = Integer.parseInt(req.getParameter("codeScore"));
            int docScore = Integer.parseInt(req.getParameter("docScore"));
            int executionScore = Integer.parseInt(req.getParameter("executionScore"));
            String feedback = req.getParameter("feedback");

            int totalScore = problemScore + codeScore + docScore + executionScore;

            Evaluation evaluation = new Evaluation();
            evaluation.setProjectId(projectId);
            evaluation.setEvaluatorId(user.getId());
            evaluation.setProblemScore(problemScore);
            evaluation.setCodeScore(codeScore);
            evaluation.setDocScore(docScore);
            evaluation.setExecutionScore(executionScore);
            evaluation.setTotalScore(totalScore);
            evaluation.setFeedback(feedback);

            boolean isExisting = evaluationDAO.getEvaluationByProjectId(projectId) != null;
            boolean success;
            if (isExisting) {
                success = evaluationDAO.updateEvaluation(evaluation);
            } else {
                success = evaluationDAO.createEvaluation(evaluation);
            }

            if (success) {
                projectDAO.updateProjectStatus(projectId, "EVALUATED");
                out.print("{\"success\": true, \"message\": \"Evaluation submitted successfully.\"}");
            } else {
                out.print("{\"success\": false, \"message\": \"Failed to submit evaluation.\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            out.print("{\"success\": false, \"message\": \"Server error occurred.\"}");
        }
    }
}
