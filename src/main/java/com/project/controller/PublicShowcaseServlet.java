package com.project.controller;

import com.project.dao.ProjectDAO;
import com.project.model.Project;
import com.project.util.JsonUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/PublicShowcaseServlet")
public class PublicShowcaseServlet extends HttpServlet {
    private ProjectDAO projectDAO = new ProjectDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");
        PrintWriter out = resp.getWriter();
        
        String keyword = req.getParameter("q");
        String domain = req.getParameter("domain");
        String sortBy = req.getParameter("sortBy");
        
        List<String> domains = projectDAO.getAllDomains();
        List<Project> projects = projectDAO.getPublicProjects(keyword, domain, sortBy);
        
        StringBuilder json = new StringBuilder();
        json.append("{\"domains\": [");
        for (int i = 0; i < domains.size(); i++) {
            json.append("\"").append(JsonUtil.escape(domains.get(i))).append("\"");
            if (i < domains.size() - 1) json.append(", ");
        }
        json.append("], \"projects\": [");
        
        for (int i = 0; i < projects.size(); i++) {
            Project p = projects.get(i);
            json.append("{");
            json.append("\"id\": ").append(p.getId()).append(", ");
            json.append("\"title\": \"").append(JsonUtil.escape(p.getTitle())).append("\", ");
            json.append("\"domainTag\": \"").append(JsonUtil.escape(p.getDomainTag())).append("\", ");
            json.append("\"studentName\": \"").append(JsonUtil.escape(p.getStudentName())).append("\", ");
            json.append("\"abstractText\": \"").append(JsonUtil.escape(p.getAbstractText())).append("\", ");
            json.append("\"githubUrl\": \"").append(JsonUtil.escape(p.getGithubUrl())).append("\", ");
            json.append("\"demoUrl\": \"").append(JsonUtil.escape(p.getDemoUrl())).append("\", ");
            json.append("\"status\": \"").append(JsonUtil.escape(p.getStatus())).append("\", ");
            json.append("\"totalScore\": ").append(p.getTotalScore());
            json.append("}");
            if (i < projects.size() - 1) json.append(", ");
        }
        json.append("]}");
        
        out.print(json.toString());
    }
}
