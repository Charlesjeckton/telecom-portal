<%@ page import="dao.ServiceDAO" %>
<%@ page import="model.Service" %>
<%@ page import="java.util.List" %>

<%
    // Authentication check
    Integer userId = (Integer) session.getAttribute("userId");
    if (userId == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    ServiceDAO serviceDAO = new ServiceDAO();
    List<Service> services = serviceDAO.getAllActiveServices();

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
    <head>
        <%@ include file="includes/customerTheme.jspf" %>
        <title>Add Subscription</title>
    </head>
    <body>

        <%@ include file="includes/customerNavbar.jspf" %>

        <div class="page-container">

            <div class="card shadow-sm mx-auto" style="max-width: 500px; padding: 30px; border-radius: 12px;">
                <h2 class="text-center mb-4">Add New Subscription</h2>

                <% if (error != null && !error.isEmpty()) {%>
                <div class="alert alert-danger text-center"><%= error%></div>
                <% } %>

                <form action="addSubscription" method="post">

                    <!-- SERVICE SELECT -->
                    <div class="mb-3">
                        <label class="form-label">Select Service:</label>
                        <select id="serviceSelect" name="service_id" class="form-select" required>
                            <option value="">-- Select Service --</option>
                            <% if (services != null) {
                            for (Service s : services) {%>

                            <option 
                                value="<%= s.getId()%>"
                                data-price="<%= s.getCharge()%>"
                                data-durationvalue="<%= s.getDurationValue()%>"
                                data-durationunit="<%= s.getDurationUnit()%>"
                                >
                                <%= s.getName()%>
                            </option>

                            <%   }
                        }%>
                        </select>
                    </div>

                    <!-- SERVICE CHARGES (HIDDEN INITIALLY) -->
                    <div id="chargesBox" class="mb-3" style="display:none;">
                        <label class="form-label">Charges:</label>
                        <input id="serviceCharge" type="text" class="form-control" readonly>
                    </div>

                    <!-- SERVICE DURATION (HIDDEN INITIALLY) -->
                    <div id="durationBox" class="mb-3" style="display:none;">
                        <label class="form-label">Duration:</label>
                        <input id="serviceDuration" type="text" class="form-control" readonly>
                    </div>


                    <!-- Buttons -->
                    <div class="d-flex justify-content-between mt-4">
                        <button type="submit" class="btn btn-success w-50 me-2">Add Subscription</button>
                        <a href="subscriptions.jsp" class="btn btn-secondary w-50 ms-2">Cancel</a>
                    </div>

                </form>
            </div>

        </div>
                        <script>
document.getElementById("serviceSelect").addEventListener("change", function () {

    const option = this.options[this.selectedIndex];

    const price = option.getAttribute("data-price");
    const durationValue = option.getAttribute("data-durationvalue");
    const durationUnit = option.getAttribute("data-durationunit");

    // Update values
    document.getElementById("serviceCharge").value =
        price ? price + " KES" : "";

    document.getElementById("serviceDuration").value =
        durationValue && durationUnit ? durationValue + " " + durationUnit.toLowerCase() : "";

    // Show fields only when a valid service is selected
    if (this.value !== "") {
        document.getElementById("chargesBox").style.display = "block";
        document.getElementById("durationBox").style.display = "block";
    } else {
        document.getElementById("chargesBox").style.display = "none";
        document.getElementById("durationBox").style.display = "none";
    }
});
</script>


       
    </body>
</html>
