package com.project.dao;

import com.project.model.Project;
import com.project.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProjectDAO {

    public boolean createProject(Project project) {
        String sql = "INSERT INTO projects (student_id, title, abstract_text, domain_tag, github_url, demo_url, pdf_path, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, project.getStudentId());
            stmt.setString(2, project.getTitle());
            stmt.setString(3, project.getAbstractText());
            stmt.setString(4, project.getDomainTag());
            stmt.setString(5, project.getGithubUrl());
            stmt.setString(6, project.getDemoUrl());
            stmt.setString(7, project.getPdfPath());
            stmt.setString(8, project.getStatus());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Project> getProjectsByStudentId(int studentId) {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT * FROM projects WHERE student_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, studentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(extractProject(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Project getProjectById(int projectId) {
        String sql = "SELECT * FROM projects WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, projectId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return extractProject(rs);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateProject(Project project) {
        String sql = "UPDATE projects SET title=?, abstract_text=?, domain_tag=?, github_url=?, demo_url=?, pdf_path=?, status=? WHERE id=? AND student_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, project.getTitle());
            stmt.setString(2, project.getAbstractText());
            stmt.setString(3, project.getDomainTag());
            stmt.setString(4, project.getGithubUrl());
            stmt.setString(5, project.getDemoUrl());
            stmt.setString(6, project.getPdfPath());
            stmt.setString(7, project.getStatus());
            stmt.setInt(8, project.getId());
            stmt.setInt(9, project.getStudentId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Project> getAllSubmittedProjects() {
        List<Project> list = new ArrayList<>();
        String sql = "SELECT p.*, u.name AS student_name FROM projects p JOIN users u ON p.student_id = u.id WHERE p.status IN ('SUBMITTED', 'EVALUATED') ORDER BY p.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Project p = extractProject(rs);
                p.setStudentName(rs.getString("student_name"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateProjectStatus(int projectId, String status) {
        String sql = "UPDATE projects SET status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, projectId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<String> getAllDomains() {
        List<String> domains = new ArrayList<>();
        String sql = "SELECT DISTINCT domain_tag FROM projects WHERE status IN ('SUBMITTED', 'EVALUATED') ORDER BY domain_tag";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                domains.add(rs.getString(1));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return domains;
    }

    public List<Project> getPublicProjects(String keyword, String domain, String sortBy) {
        List<Project> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.*, u.name AS student_name, e.total_score ");
        sql.append("FROM projects p JOIN users u ON p.student_id = u.id ");
        sql.append("LEFT JOIN evaluations e ON p.id = e.project_id ");
        sql.append("WHERE p.status IN ('SUBMITTED', 'EVALUATED') ");

        boolean hasKeyword = keyword != null && !keyword.trim().isEmpty();
        boolean hasDomain = domain != null && !domain.trim().isEmpty() && !domain.equals("All");

        if (hasKeyword) {
            sql.append("AND (p.title LIKE ? OR p.abstract_text LIKE ?) ");
        }
        if (hasDomain) {
            sql.append("AND p.domain_tag = ? ");
        }

        if ("score_desc".equals(sortBy)) {
            sql.append("ORDER BY e.total_score DESC, p.created_at DESC");
        } else if ("title_asc".equals(sortBy)) {
            sql.append("ORDER BY p.title ASC");
        } else {
            sql.append("ORDER BY p.created_at DESC");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            if (hasKeyword) {
                String likeKeyword = "%" + keyword.trim() + "%";
                stmt.setString(paramIndex++, likeKeyword);
                stmt.setString(paramIndex++, likeKeyword);
            }
            if (hasDomain) {
                stmt.setString(paramIndex++, domain.trim());
            }

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Project p = extractProject(rs);
                    p.setStudentName(rs.getString("student_name"));
                    p.setTotalScore(rs.getInt("total_score")); 
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Project extractProject(ResultSet rs) throws SQLException {
        Project p = new Project();
        p.setId(rs.getInt("id"));
        p.setStudentId(rs.getInt("student_id"));
        p.setTitle(rs.getString("title"));
        p.setAbstractText(rs.getString("abstract_text"));
        p.setDomainTag(rs.getString("domain_tag"));
        p.setGithubUrl(rs.getString("github_url"));
        p.setDemoUrl(rs.getString("demo_url"));
        p.setPdfPath(rs.getString("pdf_path"));
        p.setStatus(rs.getString("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }
}
