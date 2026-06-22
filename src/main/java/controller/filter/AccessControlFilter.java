package controller.filter; 

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.Utente;

// Intercetta tutte le richieste che arrivano al server 
@WebFilter(filterName = "/AccessControlFilter", urlPatterns = "/*")
public class AccessControlFilter extends HttpFilter implements Filter {
    private static final long serialVersionUID = 1L;

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getServletPath();
        HttpSession session = httpRequest.getSession();
        
        // Recuperiamo l'utente loggato (se esiste) 
        Utente utente = (Utente) session.getAttribute("utenteLoggato");

        // Protezione per l'area Admin 
        if (path.contains("AdminDashboardServlet") || path.contains("admin_dashboard.jsp")) {
            // Se l'utente non è loggato oppure non è amministratore, viene cacciato al login 
            if (utente == null || !"AMMINISTRATORE".equals(utente.getRuolo())) {
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp"); 
                return; 
            }
        }

        // Se ha superato il controllo (o se è in una pagina libera), la richiesta prosegue 
        chain.doFilter(request, response); 
    }
    
    public void init(FilterConfig fConfig) throws ServletException {}
    public void destroy() {}
}