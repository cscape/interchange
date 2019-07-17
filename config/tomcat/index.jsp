<%@page import="org.transitclock.db.webstructs.WebAgency"%>
<%@page import="java.util.Collection"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!doctype html>
<html>
<head>
  <%@include file="/template/includes.jsp" %>
  <title>Agencies - Interchange Transit</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    /* center the table */
    #agencyList {
      margin-left: auto;
      margin-right: auto;
    }
    
    /* adjust text in table */
    .agency {
      padding-left: 1rem;
      padding-right: 1rem;
      padding-top: 0.75rem;
      padding-bottom: 0.75rem;
      text-align: left;
    }
    
    /* Alternate row colors to make table more readable */
    .agency:nth-child(odd) {background: #F6F6F6}
    .agency:nth-child(even) {background: #EBEBEB}
  
    /* for handling names that are too long */
    .agencyName {
      width: 100%;
      font-size: 1.25rem;
      line-height: 1.4;
      font-weight: 500;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .agencylink {
      padding-right: 0.75rem;
    }
  </style>
</head>

<body>
<%@include file="/template/header.jsp" %>
<div id="mainDiv">
<div id="title">Agencies</div>
  <div id="agencyList">
  <%
  // Output links for all the agencies
  Collection<WebAgency> webAgencies = WebAgency.getCachedOrderedListOfWebAgencies();
  for (WebAgency webAgency : webAgencies) {
    // Only output active agencies
    if (!webAgency.isActive())
      continue;
    %>
    <div class="agency">
      <div class="agencyName"><%= webAgency.getAgencyName() %></div>
      <a class="agencylink" href="<%= request.getContextPath() %>/maps/index.jsp?a=<%= webAgency.getAgencyId() %>" title="Real-time maps">Maps</a>
      <a class="agencylink" href="<%= request.getContextPath() %>/reports/index.jsp?a=<%= webAgency.getAgencyId() %>" title="Reports on historic information">Reports</a>
      <a class="agencylink" href="<%= request.getContextPath() %>/reports/apiCalls/index.jsp?a=<%= webAgency.getAgencyId() %>" title="API calls">API</a>
      <a class="agencylink" href="<%= request.getContextPath() %>/status/index.jsp?a=<%= webAgency.getAgencyId() %>" title="Pages showing current status of system">Status</a>
      <a class="agencylink" href="<%= request.getContextPath() %>/synoptic/index.jsp?a=<%= webAgency.getAgencyId() %>" title="Real-time synoptic">Synoptic</a>
      <!-- &nbsp; <a href="<%= request.getContextPath() %>/extensions/index.jsp?a=<%= webAgency.getAgencyId() %>" title="Page of links to extension to the system">Extensions</a> -->
    </div>
    <%
  }
  %>
  </div>
</div>

</body>
</html>