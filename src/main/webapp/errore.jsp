<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%
    Integer statusCode = (Integer) request.getAttribute("javax.servlet.error.status_code");
    String errorMessage = "Si è verificato un errore imprevisto.";
    
    if (statusCode == null) {
        statusCode = 500;
        errorMessage = "I server sono momentaneamente offline. Riprova più tardi.";
    } else if (statusCode == 404) {
        errorMessage = "La pagina che stai cercando è stata rimossa, rinominata o non è mai esistita.";
    } else if (statusCode == 403) {
        errorMessage = "Accesso negato. Non hai i permessi per visualizzare questa sezione.";
    } else if (statusCode == 500) {
        errorMessage = "Il server ha riscontrato un problema interno.";
    }
%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <title>Errore <%= statusCode %> - RotaGames</title>
    <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<jsp:include page="header.jsp">
    <jsp:param name="tipo" value="minimal" />
</jsp:include>

<div class="store-container error-page-wrapper">
    <h1 class="error-code-title"><%= statusCode %></h1>
    <h2 class="error-subtitle">Game Over</h2>
    
    <p class="error-desc">
        <%= errorMessage %>
    </p>
    
    <a href="index.jsp" class="btn-checkout btn-checkout-inline btn-error-home">Torna alla Home</a>
</div>

<jsp:include page="footer.jsp" />

</body>
</html>