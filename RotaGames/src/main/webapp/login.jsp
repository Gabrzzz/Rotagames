<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login - RotaGames</title>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="form-wrapper">
    <div class="form-container">
        <h2>Accesso RotaGames</h2>
        
        <%-- Stampa il messaggio di successo se arriva dalla registrazione --%>
		<% if ("true".equals(request.getParameter("successo"))) { %>
			<div class="success-msg">
		        Account creato con successo! Ora puoi accedere.
		    </div>
		<% } %>
		
		<%-- Stampa gli errori di login --%>
		<% 
		    String errore = (String) request.getAttribute("erroreLogin");
		    if (errore != null) { 
		%>
		    <div class="error"><%= errore %></div>
		<% } %>

        <form action="LoginServlet" method="post">
            <input type="email" name="email" placeholder="La tua Email" required>
            <input type="password" name="password" placeholder="Password" required>
            <input type="submit" value="ENTRA">
        </form>
        
        <span class="link-text">Nuovo giocatore? <a href="registrazione.jsp">Registrati ora</a></span>
    </div>
</div>

</body>
</html>