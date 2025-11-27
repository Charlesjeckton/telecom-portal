package filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter("/*")
public class RoleFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        String path = req.getRequestURI();

        // Public pages
        if (path.endsWith("login.jsp") || path.endsWith("login") || path.contains("assets")) {
            chain.doFilter(request, response);
            return;
        }

        // Session check
        if (session == null || session.getAttribute("username") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");

        // Admin protection
        if (path.contains("/admin/") && !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
            return;
        }

        // Customer protection
        if (path.contains("/customer/") && !"CUSTOMER".equals(role) && !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
            return;
        }

        // ❗ Prevent cached pages after logout
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        chain.doFilter(request, response);
    }
}
