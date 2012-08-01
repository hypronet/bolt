<%@ language="JavaScript" %>
<!DOCTYPE html>
<!--
///////////////////////////////////////////////////////////////////////////////
// Product        :  Online Tools(tm)
//
// Series         :  Dovetail Software Development Series(tm)
//
// Name           :  view.asp
//
// Description    :  View Details
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
<link href="css/bootstrap.css" rel="stylesheet">
<link href="css/style.css" rel="stylesheet">
<link href="css/bootstrap-responsive.css" rel="stylesheet">
<link href="css/jquery.tablesorter.css" rel="stylesheet">
<link href="css/columnSelect.css" rel="stylesheet">
<!--#include file="inc/config.inc"-->
<!--#include file="inc/adojavas.inc"-->
<%
var type_id = Request("type_id");
var type_name = Request("type_name");
var rsSpecRelID;

var sPageTitle = "Details for View";
var sPageType = "Schema";

var FSO = Server.CreateObject("Scripting.FileSystemObject");
var udl_file = FSO.GetFile(dbConnect.replace("File Name=","").replace(/\\/g,"\\\\"));

//Update the Recent Cookie Collection
UpdateCookies();
%>
<!--#include file="inc/ddonline.inc"-->
<!--#include file="inc/quicklinks.inc"-->
<!--#include file="inc/viewDetails.js"-->
</head>
<body>
<!--#include file="inc/navbar.inc"-->
<%
//see if this is a sql view
//if so, redirect to sql_view.asp
TheSQL = "select type_flags from " + TABLE_TABLE + " where " + ID_FIELD + " = ";
TheSQL+= type_id;
rsView = retrieveDataFromDB(TheSQL);
var Flags = rsView("type_flags") + "";
rsView.Close;
rsView = null;

if (Flags & SQL_VIEW_FLAG){
   var TheURL = BuildSQLViewURL(type_id, type_name);
   Response.Redirect(TheURL);
}

if (Flags & UNION_VIEW_FLAG){
   var TheURL = BuildUnionViewURL(type_id, type_name);
   Response.Redirect(TheURL);
}
%>

<div class="container-fluid">
	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div id="headerContainer" class="span8">
		<%	outputViewHeader("", ""); %>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid topMargin">
		<div class="span2"></div>
		<div id="hyperlinksContainer" class="span8">
		<%	//See if it contributes to any UNION views
		   var unionViewsList = getUnionViewsList(type_id);

			//See if it has filter SQL
		   var filterSQL = getFilterSQL();

			hyperlinksTable();
		%>
		</div>
		<div class="span2"></div>
	</div>

	<div class="row-fluid">
		<div id="fieldsContainer" class="span12">
		<% outputViewFields(); %>
		</div>
	</div>

	<div class="row-fluid">
		<div id="joinsContainer" class="span12">
		<%	//Get the List of Joins for this View
   		TheSQL = "select * from " + JOIN_TABLE + " where " + VIEW_ID + " = " + type_id;
   		TheSQL+= " and flags = (select MIN(flags) from " + JOIN_TABLE + " where " + VIEW_ID + " = " + type_id + ")";
   		rsJoins = retrieveDataFromDB(TheSQL);

   		//Define a new array
   		//Its structure will look like:
   		//Column 0: From Table ID
   		//Column 1: From Table Name
   		//Column 2: From Spec Rel ID
   		//Column 3: From Relation Name
   		//Column 4: To Table Name
   		//Column 5: To Relation Name
   		//Column 6: From Table Alias
   		//Column 7: To Table Alias
   		//Column 8: Join Flag

   		var JoinArray = [];

   		row = 0;
   		while (!rsJoins.EOF){
   		   ObjectTypeID = rsJoins(JOIN_FROM_TBL_ID);
   		   ToAlias = rsJoins(JOIN_PRIM_ALIAS) + "";
   		   FromAlias = rsJoins(JOIN_SEC_ALIAS) + "";
   		   JoinFlag = rsJoins("join_flag") + "";
   		   ObjectSpecRelID = 0;

   		   ObjectSpecRelID = rsJoins("obj_spec_rel_id");
   		   if (ObjectSpecRelID >= 16384) {
   		      ObjectSpecRelID = ObjectSpecRelID - 16384;
   		   }

   		   JoinArray[row] = [];
   		   JoinArray[row][0] = ObjectTypeID + "";
   		   JoinArray[row][6] = FromAlias + "";
   		   JoinArray[row][7] = ToAlias + "";
   		   JoinArray[row][8] = JoinFlag + "";

   		   //Get the Table Name
   		   TableName = GetTableName(ObjectTypeID);
   		   JoinArray[row][1] = TableName + "";

   		   //Get the Relation Info
   		   TheSQL = "select * from adp_sch_rel_info where type_id = ";
   		   TheSQL+= ObjectTypeID;
   		   TheSQL+= " and spec_rel_id = ";
   		   TheSQL+= ObjectSpecRelID;
   		   rsRelName = retrieveDataFromDB(TheSQL);
   		   JoinArray[row][3] = rsRelName("rel_name") + "";
   		   JoinArray[row][4] = rsRelName("target_name") + "";
   		   JoinArray[row][5] = rsRelName("inv_rel_name") + "";
   		   rsRelName.Close();
   		   rsRelName = null;

   		   row = row + 1;
   		   rsJoins.MoveNext();
   		}

			//Print the Table of Joins
			//Build the table header
   		rw("<h4>Joins:</h4>");
   		rw("<table id='joins' class='tablesorter'>");
   		rw("<thead><tr class='headerRow'>");
   		rw("<th>");
   		rw("Join From");
   		rw("</th>");
   		rw("<th>");
   		rw("Join To");
   		rw("</th>");
   		rw("</tr></thead>");

   		nFields = JoinArray.length;
   		for(row = 0; row < nFields; row++) {
   		   FromTableNum = JoinArray[row][0];
   		   FromTable = JoinArray[row][1];
   		   FromRel = JoinArray[row][3];
   		   ToTable = JoinArray[row][4];
   		   ToRel = JoinArray[row][5];
   		   FromAlias = JoinArray[row][6];
   		   ToAlias = JoinArray[row][7];
   		   JoinFlag = JoinArray[row][8];
   		   ToTableNum = GetTableNum(ToTable);
   		   FromJoin = '';
   		   ToJoin = '';
   		   LeftOuter = '';
   		   RightOuter = '';
   		   if (JoinFlag == "1") { LeftOuter  = "OUTER "; }
   		   if (JoinFlag == "2") { RightOuter = "OUTER "; }
   		   if (JoinFlag == "3") { RightOuter = "CROSS "; }

   		   //Make the From Joined Table Name be a hyperlink:
   		   TheLink = BuildTableHyperLink(FromTableNum,FromTable);
   		   //If there's an alias, show the alias, and put the real table in parens & hyperlinked

   		   switch(FromAlias){
   		    case "","null":
   		      FromJoin = RightOuter + TheLink + Dot + FromRel;
   		      break;
   		    default:
   		      FromJoin = RightOuter + FromAlias + "(" + TheLink + ")" + ((FromRel != undefined) ? (Dot + FromRel) : '');
   		      break;
   		   }

   		   //Make the To Joined Table Name be a hyperlink:
   		   TheLink = BuildTableHyperLink(ToTableNum,ToTable);
   		   //If there's an alias, show the alias, and put the real table in parens & hyperlinked

   		   switch(ToAlias){
   		    case "","null":
   		      ToJoin = LeftOuter + TheLink + Dot + ToRel;
   		      break;
   		    default:
   		      ToJoin = LeftOuter + ToAlias + ((ToRel != undefined) ? ("(" + TheLink + ")" + Dot + ToRel) : '');
   		      break;
   		   }

				rw("<tr>");
   		   rw("<TD>");
   		   rw(FromJoin);
   		   rw("</TD>");
   		   rw("<TD>");
   		   rw(ToJoin);
   		   rw("</TD>");
   		   rw("</tr>");
   		}
   		rw("</table>");

   		rsJoins.Close;
   		rsJoins = null;

			//Print the filter
   		if(filterSQL != '') {
   		   rw("<h4 id='filters'>Filters:</h4>");
   		   rw(filterSQL.replace(/\n/g,'<br>'));
   		}

			//Print the Table of Union Views this view contributes to
   		if(unionViewsList.length > 0) {
   		   rw("<h4 id='contribs'>Contributes To UNION Views:</h4>");
   		   rw("<table id='contribs' class='tablesorter'>");
   		   rw("<thead><tr>");
   		   rw("<th>");
   		   rw("View Name");
   		   rw("</th>");
   		   rw("</tr></thead>");

   		   for(var j=0; j < unionViewsList.length; j++) {
					rw("<tr>");
   		      rw("<TD>");
   		      rw(BuildViewHyperLink(unionViewsList[j][0],unionViewsList[j][1]));
   		      rw("</TD>");
   		      rw("</tr>");
   		   }
   		   rw("</table>");
   		}
		%>
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
</div>
</body>
<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7/jquery.min.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/jquery.tablesorter.min.js"></script>
<script type="text/javascript" src="js/columnSelect.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	var path = window.location.pathname;
	var page = path.substr(path.lastIndexOf("/")+1);
	$("ul.nav li a[href$='" + page + "']").parent().addClass("active");
	$(".navbar").find(".connected").text("<%=connect_info%>");
	document.title = "Bolt: <%=sPageTitle%>";

   $(".tablesorter").tablesorter();
	$(".tablesorter tr").click(function () {
	   $(this).children("td").toggleClass("highlight");
	});
});
</script>
</html>
<%
FSO = null;
udl_file = null;
%>