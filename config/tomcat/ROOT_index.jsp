<%
    String redirectURL = "/web/welcome";
    response.sendRedirect(redirectURL);
%>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html>
<head>
  <title>Interchange Transit</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <script type="text/javascript">window.location.replace("/web")</script>
</head>
<body>
  Go to <a href="/web">Web interface</a>
</body>
</html>
