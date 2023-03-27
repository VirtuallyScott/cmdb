
<cfinclude template="header.cfm">	
<cfinclude template="topmenu.cfm">

<cfquery name="GetDN" datasource="#DSN#">
	sp_GetDNByPersonUUID
		@PersonUUID = '#session.PersonUUID#'
</cfquery>

<cfswitch expression="#url.A#">
	<cfdefaultcase></cfdefaultcase>
	<cfcase value="MyStaff">
	
	</cfcase>
	<cfcase value="ImportStaff">
		<cfscript>
			LDAPUserName = "ssmith@CHI.CHICORP";
			LDAPPassWord = "__Mp4f9!!";
			LDAPServer = "172.20.86.131";
			DCStart = "DC=CHI,DC=CHICORP";
		</cfscript>
		<cfldap action="QUERY"
			        name="GetDirectReports"
			        attributes="directreports"
			        start="#dcStart#"
			        filter="distinguishedname=#GetDN.DN#"
			        server="#LDAPServer#"
			        username="#LDAPUserName#"
			        password="#LDAPPassWord#">
		<ul>
		<cfoutput query="GetDirectReports">
			<li>#ListLast(ListFirst(DirectReports, ","), "=")# - #DN#</li>
		</cfoutput>
		</ul>
		
	</cfcase>
</cfswitch>
