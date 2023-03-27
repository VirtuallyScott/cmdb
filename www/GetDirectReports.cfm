<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>

<cfquery name="GetPersonUUID" datasource="#DSN#">
	SELECT PersonUUID, SamAccountName, EmployeeID
		FROM Persons
	WHERE PeopleLeader = 1
	AND EndDate IS NULL
</cfquery>

<cfif GetPersonUUID.RecordCount GT 0>
	<cfloop query="GetPersonUUID">
			<cfscript>
				LDAPUserName = "";
				LDAPPassWord = "";
				LDAPServer = "";
				DCStart = "DC=,DC=";
			</cfscript>
		
			<cfldap action="QUERY"
				        name="GetDirectReports"
				        attributes="directreports"
				        start="#dcStart#"
				        maxrows="1"
				        filter="samAccountName=#GetPersonUUID.SamAccountName#"
				        server="#LDAPServer#"
				        username="#LDAPUserName#"
				        password="#LDAPPassWord#">
	
				<cfloop index="i" list="#ReplaceNoCase(GetDirectReports.DirectReports, ",CN", "||CN", "ALL")#" delimiters="||">
				
					<cfquery name="CheckForRecord" datasource="#DSN#">
						SELECT PersonUUID
							FROM persondata
						WHERE DistinguishedName = '#i#'
					</cfquery>
					
					<cfif CheckForRecord.RecordCount EQ 0>
					
						<cfldap action="QUERY"
							        name="GetPersonDetails"
							        attributes="cn,givenName,sn,title,mail,distinguishedName,department,company,manager,telephoneNumber,employeeID,SamAccountName, directreports"
							        start="#dcStart#"
							        maxrows="1"
							        filter="DistinguishedName=#i#"
							        server="#LDAPServer#"
							        username="#LDAPUserName#"
							        password="#LDAPPassWord#">
									
						<cfif LEN(GetPersonDetails.SamAccountName) GT 0>
						
							<cfscript>
								IF (Len(GetPersonDetails.EmployeeID EQ 0)) {
										EmployeeID = 0;
									}
								ELSE {
										EmployeeID = GetPersonDetails.EmployeeID
									}
							</cfscript>
						
							<cfquery name="InsertNewUser" datasource="#DSN#">
								INSERT INTO dbo.persons
									(employeeID, SamAccountName<cfif LEN(GetPersonDetails.directreports) GT 0>, PeopleLeader</cfif>)
								VALUES (#EmployeeID#, '#LCase(GetPersonDetails.SamAccountName)#'<cfif LEN(GetPersonDetails.directreports) GT 0>,1</cfif>);
								SELECT PersonUUID
									FROM dbo.persons
								WHERE SamAccountName = '#LCase(GetPersonDetails.SamAccountName)#';
							</cfquery>
							
							<cfoutput query="GetPersonDetails">
								<cfquery name="InsertNewUserData" datasource="#DSN#">
									INSERT INTO dbo.persondata
										(personUUID,cn,givenName,sn,title,mail,distinguishedName,department,company,manageremployeeid,telephoneNumber,managerdistinguishedName)
									VALUES ('#InsertNewUser.PersonUUID#','#cn#','#givenName#','#sn#','#title#','#mail#','#distinguishedName#','#department#','#company#',
												#GetPersonUUID.EmployeeID#,'#telephoneNumber#','#manager#')
								</cfquery>
							</cfoutput>
							
						</cfif>
									
					<cfelseif CheckForRecord.RecordCount EQ 1>
					
					</cfif>
					
					
				</cfloop>
	</cfloop>	
</cfif>


</body>
</html>
