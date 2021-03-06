<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  schema_id_info.asp
//
// Description    :  Information about User-Defined Table and View IDs
//
// Author         :  Dovetail Software, Inc.
//                   4807 Spicewood Springs Rd, Bldg 4 Suite 200
//                   Austin, TX 78759
//                   (512) 610-5400
//                   EMAIL: support@dovetailsoftware.com
//                   www.dovetailsoftware.com
//
// Platforms      :  This version supports Clarify 9.0 and later
//
// Copyright (C) 2001-2012 Dovetail Software, Inc.
// All Rights Reserved.
///////////////////////////////////////////////////////////////////////////////
-->
<html>
<head>
<title></title>
<meta http-equiv="expires" content="0">
<meta name="KeyWords" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="css/<%=Request.Cookies("boltTheme")%>bootstrap.min.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
<style>
#homeContainer h4 { text-align:left;margin: .5em 0; }
#homeContainer .btn { margin: 0 .5em; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Custom Schema IDs";
var sPageType = "Schema";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

function DisplayInfoForSchemaIdRange(minValue,maxValue) {
	var potentialAvailable = maxValue - minValue;
	var nextAvailableID = minValue;

	var sql = "select type_id from adp_tbl_name_map where type_id >=" + minValue + " and type_id <= " + maxValue + " order by type_id";
	var records = retrieveDataFromDBStatic(sql);
	var numUsed= records.RecordCount;
	var numAvailable = potentialAvailable - numUsed;
	var numUsedString = numUsed;

	if(numUsed == 0) numUsedString = "None";
	if(numUsed == potentialAvailable) numUsedString = "All";

	var counter = minValue;
	while(!records.EOF) {
		if(records("type_id") != counter) {
			nextAvailableID = counter;
			break;
		}
		counter++;
		records.MoveNext();
	}
	records.Close();

	rw(numUsedString + " of the " + potentialAvailable + " available IDs in this range have been used.&nbsp;");
	if(numUsed > 0) {
		var href = "tables.asp?minRange=" + minValue + "&maxRange=" + maxValue;
		rw('<button class="btn" onclick="window.location=\'' + href + '\'">View them</button>');
	}
	rw("<p>The lowest available ID in this range is <strong>" + nextAvailableID + "</strong>.</p>");
}
%>
<!--#include file="inc/ddonline.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2"></div>
		<div id="homeContainer" class="span8">

			<h3>More information about User-Defined Table and View IDs</h3>

			<p align="center">
				There are two ranges reserves for custom IDs: 430-571 and 2000-4999.<br/>
				The rest are reserved for Clarify baseline use.
			</p>

			<div class="topMargin">
				<h4>Low Range: 430-571</h4>
				<% DisplayInfoForSchemaIdRange(430,571); %>
			</div>

			<div class="topMargin">
				<h4>High Range: 2000-4999</h4>
				<% DisplayInfoForSchemaIdRange(2000,4999); %>
			</div>

		</div>
		<div class="span2"></div>
	</div>

</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf('/')+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>