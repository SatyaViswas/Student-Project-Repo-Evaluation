package com.project.controller;

import com.project.dao.EvaluationDAO;
import com.project.dao.ProjectDAO;
import com.project.model.Evaluation;
import com.project.model.Project;
import com.project.util.JsonUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/PublicProjectDetailServlet")
public class PublicProjectDetailServlet extends HttpServlet {
    private ProjectDAO projectDAO = new ProjectDAO();
    private EvaluationDAO evaluationDAO = new EvaluationDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        
        try {
            int projectId = Integer.parseInt(req.getParameter("id"));
            Project p = projectDAO.getProjectById(projectId);
            
            if (p == null || "DRAFT".equals(p.getStatus())) {
                resp.setStatus(404);
                out.print("{\"error\": \"Project not found or not public\"}");
                return;
            }

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"id\": ").append(p.getId()).append(", ");
            json.append("\"title\": \"").append(JsonUtil.escape(p.getTitle())).append("\", ");
            json.append("\"abstractText\": \"").append(JsonUtil.escape(p.getAbstractText())).append("\", ");
            json.append("\"domainTag\": \"").append(JsonUtil.escape(p.getDomainTag())).append("\", ");
            json.append("\"githubUrl\": \"").append(JsonUtil.escape(p.getGithubUrl())).append("\", ");
            json.append("\"demoUrl\": \"").append(JsonUtil.escape(p.getDemoUrl())).append("\", ");
            json.append("\"pdfPath\": \"").append(JsonUtil.escape(p.getPdfPath())).append("\", ");
            json.append("\"status\": \"").append(JsonUtil.escape(p.getStatus())).append("\"");

            if ("EVALUATED".equals(p.getStatus())) {
                Evaluation ev = evaluationDAO.getEvaluationByProjectId(p.getId());
                if (ev != null) {
                    json.append(", \"evaluation\": {");
                    json.append("\"problemScore\": ").append(ev.getProblemScore()).append(", ");
                    json.append("\"codeScore\": ").append(ev.getCodeScore()).append(", ");
                    json.append("\"docScore\": ").append(ev.getDocScore()).append(", ");
                    json.append("\"executionScore\": ").append(ev.getExecutionScore()).append(", ");
                    json.append("\"totalScore\": ").append(ev.getTotalScore()).append(", ");
                    json.append("\"feedback\": \"").append(JsonUtil.escape(ev.getFeedback())).append("\"");
                    json.append("}");
                }
            }
            json.append("}");
            out.print(json.toString());
            
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(500);
            out.print("{\"error\": \"Server error\"}");
        }
    }
}
