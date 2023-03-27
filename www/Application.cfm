<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">
<cfprocessingdirective suppresswhitespace="Yes">
<!---
	Application.cfm Is Parsed First For Each Page Request. Set Up Session. Set Default url and session Variables.
	If session.isAuthenticated Is False, Redirect To Login Page.
--->

<cfapplication name="chao" sessiontimeout="#createTimeSpan(0, 0, 20, 0)#" applicationtimeout="#createTimeSpan(0, 0, 20, 0)#">

<cfparam name="url.A" type="string" default="Start">
<cfparam name="url.P" type="numeric" default="1">
<cfparam name="url.Step" type="string" default="Start">
<cfparam name="url.Sort" type="string" default="ASC">
<cfparam name="url.SortBy" type="string" default="Start">

<cflock timeout="1" throwontimeout="No" name="SetDefaultSessionVars" type="EXCLUSIVE">
	<cfparam name="session.bk" type="string" default="">
	<cfparam name="session.cn" type="string" default="">
	<cfparam name="session.DateMask" type="string" default="">
	<cfparam name="session.isAuthenticated" type="string" default="False">
	<cfparam name="session.PeopleLeader" type="string" default="False">
	<cfparam name="session.Permissions" default="">
	<cfparam name="sessionPersonUUID" type="string" default="">
	<cfparam name="session.SamAccountName" type="string" default="">
	<cfparam name="session.TimeMask" type="string" default="">
</cflock>

<cfscript>
	Container = "Application.cfm";
	CurrentTemplate = ListLast(cgi.Script_Name, "/");
	LoopCounter = 1;
	HTMLNULL = XMLFormat("<NULL>");
	SC = ",";
	DC = ",,";
	SDQ = """";
	SSQ = "'";
	DDQ = """""";
	IF (NOT IsDefined("RedirectURL")) {
			RedirectURL = ListFirst(cgi.request_url, "?") & "?" & cgi.query_string;
			RedirectURL = URLEncodedFormat(RedirectURL);
		}
</cfscript>

<!--- Include Properties.cfm From Outside Of Web Root. Sets Up LDAP Settings Other Settings With Passwords --->
<cfinclude template="/config/properties.cfm">

<cfif session.isAuthenticated IS NOT "True" AND CurrentTemplate IS NOT "Login.cfm" AND CurrentTemplate IS NOT "ProcessLogin.cfm" AND CurrentTemplate IS NOT "LogOut.cfm">
	<cflocation url="./login/Login.cfm?RedirectURL=#RedirectURL#" addtoken="No">
</cfif>
<cfif NOT IsDefined("session.cn") AND CurrentTemplate IS NOT "Login.cfm" AND CurrentTemplate IS NOT "ProcessLogin.cfm" AND CurrentTemplate IS NOT "LogOut.cfm">
	<cflocation url="./login/Login.cfm?RedirectURL=#RedirectURL#" addtoken="No">
</cfif>
<cfif NOT IsDefined("session.isAuthenticated") AND CurrentTemplate IS NOT "Login.cfm" AND CurrentTemplate IS NOT "ProcessLogin.cfm" AND CurrentTemplate IS NOT "LogOut.cfm">
	<cflocation url="./login/Login.cfm?RedirectURL=#RedirectURL#" addtoken="No">
</cfif>
<cfif NOT IsDefined("session.TimeMask") AND CurrentTemplate IS NOT "Login.cfm" AND CurrentTemplate IS NOT "ProcessLogin.cfm" AND CurrentTemplate IS NOT "LogOut.cfm">
	<cflocation url="./login/Login.cfm?RedirectURL=#RedirectURL#" addtoken="No">
</cfif>
<cfif NOT IsDefined("session.DateMask") AND CurrentTemplate IS NOT "Login.cfm" AND CurrentTemplate IS NOT "ProcessLogin.cfm" AND CurrentTemplate IS NOT "LogOut.cfm">
	<cflocation url="./login/Login.cfm?RedirectURL=#RedirectURL#" addtoken="No">
</cfif>

</cfprocessingdirective>
<cfsetting enablecfoutputonly="No" showdebugoutput="No">
