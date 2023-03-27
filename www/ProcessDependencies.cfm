


	<cfinclude template="header.cfm">
	<cfinclude template="topmenu.cfm">



<cfset InList = "">
<cfloop index="i" list="#form.AllApps#" delimiters=",">
	<cfset InList = ListAppend(InList, "'#i#'",",")>
</cfloop>

<cfquery name="UpdateUpstream" datasource="#DSN#">
	UPDATE Dependencies
		SET EndDate = #CreateODBCDateTime(Now())#
	WHERE ParentUUID IN (#preserveSingleQuotes(InList)#)
	AND ChildUUID = '#url.ApplicationUUID#'
	AND EndDate IS NULL
</cfquery>

<cfquery name="UpdateDownStream" datasource="#DSN#">
	UPDATE Dependencies
		SET EndDate = #CreateODBCDateTime(Now())#
	WHERE ChildUUID IN (#preserveSingleQuotes(InList)#)
	AND ParentUUID = '#url.ApplicationUUID#'
	AND EndDate IS NULL
</cfquery>

<cfif IsDefined("form.UpStream")>
	<cfloop index="i" list="#form.Upstream#" delimiters=",">
		<cfquery name="UpStreamCheck" datasource="#DSN#">
			SELECT COUNT(*) AS TCount
				FROM Dependencies
			WHERE ParentUUID = '#i#'
			AND ChildUUID = '#url.ApplicationUUID#'
			AND EndDate IS NULL
		</cfquery>
		<cfif UpStreamCheck.TCount EQ 0>
			<cfquery name="InsertUpStream" datasource="#DSN#">
				INSERT INTO
					DEPENDENCIES (PersonUUID, ParentUUID, ChildUUID)
				VALUES ('#session.PersonUUID#','#i#','#url.ApplicationUUID#')
			</cfquery>
		</cfif>
	</cfloop>
</cfif>

<cfif IsDefined("form.DownStream")>
		<cfloop index="i" list="#form.DownStream#" delimiters=",">
		<cfquery name="DownStreamCheck" datasource="#DSN#">
			SELECT COUNT(*) AS TCount
				FROM Dependencies
			WHERE ChildUUID = '#i#'
			AND ParentUUID = '#url.ApplicationUUID#'
			AND EndDate IS NULL
		</cfquery>
		<cfif DownStreamCheck.TCount EQ 0>
			<cfquery name="InsertDownStream" datasource="#DSN#">
				INSERT INTO
					DEPENDENCIES (PersonUUID, ParentUUID, ChildUUID)
				VALUES ('#session.PersonUUID#','#url.ApplicationUUID#', '#i#')
			</cfquery>
		</cfif>
	</cfloop>
</cfif>

<div class="row">
	<h3 align="center">Updating Dependencies</h3>
</div>
<cfinclude template="status.cfm">

