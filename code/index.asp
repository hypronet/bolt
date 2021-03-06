<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  index.asp
//
// Description    :  Selection page for Database objects (app default)
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
input.formInput { margin-bottom: 0;margin-left: .5em; }
table.middle tr td { padding: .2em 0; }
.bottomMargin { margin-bottom: 3em; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var sPageTitle = "Schema";
var sPageType = "Schema";
var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->

<div class="container-fluid">
	<div class="row-fluid bottomMargin">
		<div class="span2"></div>
		<div id="homeContainer" class="span8">

			<h3>Schema Search</h3>

			<center>
			<table class="middle">
				<tr>
					<td>Tables/Views whose name starts with</td>
					<td>
						<div class="input-append">
    						<input type="text" class="input-medium formInput" id="type_name" />
    						<button class="btn " id="ddonline">Search</button>
						</div>
  					</td>
				</tr>
				<tr>
					<td>Tables/Views whose ID equals</td>
					<td>
						<div class="input-append">
							<input type="text" class="input-medium formInput" id="type_id" />
							<button class="btn " id="ddonline2">Search</button>
						</div>
					</td>
				</tr>
				<tr>
					<td>Tables/Views that contain a field named</td>
					<td>
						<div class="input-append">
						<input type="text" class="input-medium formInput" id="field_name" />
							<button class="btn " id="fieldButton">Search</button>
							<input type="hidden" value="search_by_field_name" id="search_type" />
						</div>
					</td>
				</tr>
				<tr>
					<td>Tables that contain a relation name starting with</td>
					<td>
						<div class="input-append">
							<input type="text" class="input-medium formInput" id="rel_name" />
							<button class="btn " id="relationButton">Search</button>
						</div>
					</td>
				</tr>
				<tr>
					<td>User-Defined Tables/Views whose name starts with</td>
					<td>
						<div class="input-append">
							<input type="text" class="input-medium formInput" id="type_custom" />
							<button class="btn " id="customButton">Search</button>
						</div>
					</td>
				</tr>
			</table>
			</center>
			<br/>

		<h4><a href="schema_id_info.asp">More information about User-Defined Table/View IDs</a></h4>

		</div>
		<div class="span2"></div>
	</div>

	<!--#include file="inc/recent_objects.asp"-->
	<!--#include file="inc/quick_links.asp"-->

</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/schemaValidate.js"></script>
<script type="text/javascript">
function submitFormByName(strUrl, fieldName) {
	if(!validate_filter(fieldName)) return;
	window.location = strUrl + "?" + fieldName + "=" + $("#" + fieldName).val() + "&custom=0";
}

function submitFormById(strUrl, fieldName) {
	if(!validate_id(fieldName)) return;
	window.location = strUrl + "?" + fieldName + "=" + $("#" + fieldName).val() + "&custom=0";
}

function submitCustom() {
	if(!validate_filter("type_custom")) return;
	window.location = "tables.asp?type_name=" + $("#type_custom").val() + "&custom=1";
	submitFormByName("", "");
}

$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	$("#type_name").keypress(function(event) {
		if(event.keyCode == 13) $("#ddonline").click();
	});
	$("#ddonline").click(function() {
		submitFormByName("tables.asp", "type_name");
	});

	$("#type_id").keypress(function(event) {
		if(event.keyCode == 13) $("#ddonline2").click();
	});
	$("#ddonline2").click(function() {
		submitFormById("tables.asp", "type_id");
	});

	$("#field_name").keypress(function(event) {
		if(event.keyCode == 13) $("#fieldButton").click();
	});
	$("#fieldButton").click(function() {
		submitFormByName("search_fields.asp", "field_name");
	});

	$("#rel_name").keypress(function(event) {
		if(event.keyCode == 13) $("#relationButton").click();
	});
	$("#relationButton").click(function() {
		submitFormByName("search_rels.asp", "rel_name");
	});

	$("#type_custom").keypress(function(event) {
		if(event.keyCode == 13) $("#customButton").click();
	});
	$("#customButton").click(submitCustom);

	$("#type_name").focus();
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>