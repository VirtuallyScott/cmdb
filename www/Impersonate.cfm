
<cfinclude template="Header.cfm">
<cfinclude template="TopMenu.cfm">

<cfswitch expression="#url.A#">
	<cfdefaultcase></cfdefaultcase>
	<cfcase value="Start">
		<cfquery name="GetActiveUsers" datasource="#DSN#">
			SELECT PersonUUID, CN
				FROM PersonData
			WHERE EndDate IS NULL
			ORDER BY CN ASC
		</cfquery>
		
		<form action="Impersonate.cfm?A=ProcessImpersonate" method="post">
		<select name="ToImpersonate" size="10">
			<cfoutput query="GetActiveUsers">
				<option value="#PersonUUID#">#CN#</option>
			</cfoutput>
		</select>
		<input type="submit" value="Impersonate">
		</form>
	</cfcase>
	
	<cfcase value="ProcessImpersonate">
		<cfquery name="GetPersonData" datasource="#DSN#">
			SELECT *
				FROM PersonData
			WHERE PersonUUID = '#form.ToImpersonate#'
		</cfquery>
		<cfquery name="GetBK" datasource="#DSN#">
			SELECT *
				FROM BK
			WHERE PersonUUID = '#form.ToImpersonate#'
		</cfquery>
		<cfquery name="GetPerson" datasource="#DSN#">
			SELECT *
				FROM Persons
			WHERE PersonUUID = '#form.ToImpersonate#'
		</cfquery>
		<cfquery name="GetPermissions" datasource="#DSN#">
			sp_GetPermissionsByPersonUUID
				@PersonUUID = '#form.ToImpersonate#'
		</cfquery>
		<cfquery name="ManageApp" datasource="#DSN#">
			SELECT COUNT(*) AS TCount
				FROM application_owners
			WHERE PersonUUID = '#form.ToImpersonate#'
			AND EndDate IS NULL
		</cfquery>
		<cfif GetPermissions.RecordCount EQ 1>
			<cfoutput query="GetPermissions">
				<cfloop index="i" list="#GetPermissions.ColumnList#">
					<cfscript>
						ToEval = i;
						ToEval = #ToEval#;
						ToEval = #Evaluate(ToEval)#;
						IF (LoopCounter EQ 1) {
								session.Permissions = ArrayNew(2);									
							}
						session.Permissions[LoopCounter][1] = LCase(i);
						session.Permissions[LoopCounter][2] = ToEval;
						LoopCounter = LoopCounter + 1;
					</cfscript>
				</cfloop>
			</cfoutput>
		</cfif>
		<cfscript>
			session.CN = GetPersonData.cn;
			session.PersonUUID = form.ToImpersonate;
			session.DateMask = GetBK.DateMask;
			session.PeopleLeader = GetPerson.PeopleLeader;
			session.SamAccountName = GetPerson.SamAccountName;
			session.TimeMask = GetBK.TimeMask;
		</cfscript>
		<cfset Status = "True">
		<cfinclude template="Status.cfm">
	</cfcase>
	
	<cfcase value="EnableMegaDump">
		<cfif IsDefined("session.MegaDump") AND session.MegaDump IS "True">
			<cfset session.MegaDump = "False">
		<cfelseif IsDefined("session.MegaDump") AND session.MegaDump IS "False">
			<cfset session.MegaDump = "True">
		<cfelse>
			<cfset session.MegaDump = "True">
		</cfif>
		<cfset Status = "True">
		<cfinclude template="Status.cfm">	
	</cfcase>
</cfswitch>

