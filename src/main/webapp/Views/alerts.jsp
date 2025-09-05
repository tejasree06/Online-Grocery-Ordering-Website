<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    String successMessage = request.getParameter("success");
    String errorMessage = request.getParameter("error");
%>

<script>
    <% if (successMessage != null) { %>
        alert("<%= successMessage %>");
    <% } %>

    <% if (errorMessage != null) { %>
        alert("<%= errorMessage %>");
    <% } %>
</script>