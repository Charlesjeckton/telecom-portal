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

        String path = req.getRequestURI();
        HttpSession session = req.getSession(false);

        // ================================
        //       PUBLIC PAGES (NO LOGIN)
        // ================================
        if (
                path.endsWith("login.jsp") ||
                path.endsWith("/login") ||

                path.endsWith("registerCustomer.jsp") ||     // JSP form
                path.endsWith("/registerCustomer") ||        // Servlet mapping

                path.contains("/assets/") ||
                path.contains("/css/") ||
                path.contains("/js/") ||
                path.contains("/images/")
        ) {
            chain.doFilter(request, response);
            return;
        }

        // ================================
        //       REQUIRE LOGIN
        // ================================
        if (session == null || session.getAttribute("username") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String role = (String) session.getAttribute("role");

        // ================================
        //         ROLE BLOCKING
        // ================================
        if (path.contains("/admin/") && !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
            return;
        }

        if (path.contains("/customer/") &&
            !"CUSTOMER".equals(role) &&
            !"ADMIN".equals(role)) {
            res.sendRedirect(req.getContextPath() + "/accessDenied.jsp");
            return;
        }

        // ================================
        //  PREVENT BACK AFTER LOGOUT
        // ================================
        res.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        res.setHeader("Pragma", "no-cache");
        res.setDateHeader("Expires", 0);

        chain.doFilter(request, response);
    }
}
