<%@ language="JavaScript" %>
<!DOCTYPE html>
<html>
<head>
<title></title>
<meta http-equiv="expires" content="0">
<meta name="KeyWords" content="">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="Shortcut Icon" href="favicon.ico">
<link href="css/bootstrap.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/bootstrap-responsive.css" rel="stylesheet">
<link href="css/jquery.tablesorter.css" rel="stylesheet">
<style>
#showControlSearch, #hideControlSearch { padding-top:50px;text-align:center; }
#hideControlSearch, #controlsSearchArea { display:none; }
.bottomMargin { margin-bottom: .7em; }
#formsonline { margin-bottom: 0; }
</style>
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%

var sPageTitle = "Forms";
var sPageType = "Forms";

//Set the Default control for focus
var sDefaultControl = "filter";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<%
%>

<div class="container-fluid">
	<div class="row-fluid">
		<div class="span2"></div>
		<div id="headerContainer" class="span8 topMargin">
			<form method="POST" name="formsonline" id="formsonline" action="forms.asp">
				<h3>Search for Forms where</h3>

				<select id="attribute" name="attribute">
					<option selected value="title">Title</option>
					<option value="dialog_name">Name</option>
					<option value="id">ID</option>
					<option value="description">Description</option>
					<option value="ver_clarify">Clarify Version</option>
					<option value="ver_customer">Customer Version</option>
				</select>

				<select id="operator" name="operator">
					<option selected value="starts">starts with</option>
					<option value="ends">ends with</option>
					<option value="equals">equals</option>
					<option value="contains">contains</option>
				</select>

				<input type="text" id="filter" name="filter" class="filter" />

				<button id="formSearchButton" class="btn btn-primary bottomMargin">Search</button>

				<select name="which" id="which">
			   	<option selected value="all">Search all forms</option>
			   	<option value="custom">Search only custom forms</option>
			   	<option value="baseline">Search only baseline forms</option>
				</select>
			</form>

			<p id="showControlSearch">You can also <a href=# onClick="toggleSearch();">search for a particular control</a>.</p>
			<p id="hideControlSearch"><a href=# onClick="toggleSearch();">Hide the Search for Controls section</a></p>

			<div id="controlsSearchArea">
				<form method="POST" name="controlSearchForm" id="controlSearchForm" action="controls.asp">
				<h3>Search for Controls where</h3>

				<select name="attribute">
					<option selected value="control_name">Control Name</option>
					<option value="control_label">Control Label</option>
					<option value="win_id">Form ID</option>
					<option value="win_name">Form Name</option>
					<option value="clarify_ver">Clarify Version</option>
					<option value="customer_ver">Customer Version</option>
				</select>

				<select name="operator">
					<option selected value="starts">starts with</option>
					<option value="ends">ends with</option>
					<option value="equals">equals</option>
					<option value="contains">contains</option>
				</select>

				<input type="text" id="controlFilter" name="controlFilter" class="filter" />

				<button id="controlSearchButton" class="btn btn-primary bottomMargin">Search</button>
				<br />

				<select name="which" id="which" style="width:280px;">
				    <option selected value="all">Search for All Control Types or limit to...</option>
				    <option value="4">Button</option>
				    <option value="0">Static Text</option>
				    <option value="2">Bitmap</option>
				    <option value="3">Multi-Line Edit</option>
				    <option value="5">Option Button/Tab</option>
				    <option value="6">Check Box</option>
				    <option value="7">Dropdown List Box</option>
				    <option value="9">List Box</option>
				    <option value="11">Dropdown Combo Box</option>
				    <option value="13">Grid</option>
				    <option value="14">Group Box</option>
				    <option value="7">Dropdown List Box</option>
				    <option value="9">List Box</option>
				    <option value="11">Dropdown Combo Box</option>
				    <option value="18">Select CBX</option>
				    <option value="19">Line</option>
				    <option value="20">Active X Control</option>
				    <option value="21">Graph</option>
				    <option value="22">UpDown</option>
				    <option value="23">Progress Bar</option>
				    <option value="24">Slider</option>
				    <option value="25">Animation</option>
				    <option value="26">Tree View</option>
				  </select>
				</form>
			</div>
			</div>
		</div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div class="span8 hero-unit">
		<!--#include file="inc/recent_objects.asp"-->
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid">
		<div class="span2"></div>
		<div class="span8 hero-unit">
		<!--#include file="inc/quick_links.asp"-->
		</div>
		<div class="span2"></div>
	</div>

<!--#include file="inc/footer.inc"-->
</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript">
function toggleSearch(){
	$("#controlsSearchArea").toggle();
	$("#hideControlSearch").toggle();
	$("#showControlSearch").toggle();
	$(".filter:not(:hidden)").focus();
}

$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf('/')+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

	if($("#controlsSearchArea #controlFilter").val().length > 0) toggleSearch();

	$("#controlSearchButton").click(function() {
 		if(validate_form("formsonline")) $("#formsonline").submit();
	});

	$("#controlSearchButton").click(function() {
 		if(validate_form("controlSearchForm")) $("#controlSearchForm").submit();
	});

	$("#filter").focus();
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>