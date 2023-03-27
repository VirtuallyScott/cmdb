<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>
	
	<ul>
		<li><a href="./Login/LogOut.cfm">Logout</a></li>
		<li><cfoutput><a href="#cgi.script_name#?A=isAuthenticated">Kill session.isAuthenticated</a></cfoutput></li>
	</ul>

	<cfswitch expression="#url.A#">
		<cfdefaultcase></cfdefaultcase>
		<cfcase value="isAuthenticated">
			<cfset session.isAuthenticated = "False">
		</cfcase>
	</cfswitch>
	
	<cf_megadump>
	<cfoutput>
		#megadump#
	</cfoutput>


</body>
</html>
