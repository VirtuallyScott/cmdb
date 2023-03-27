
	<cfinclude template="header.cfm">
	<cfinclude template="topmenu.cfm">
	
	<div class="page-header">
		<h1>Users</h1>
	</div>
	
	<cfswitch expression="#url.A#">
		<cfdefaultcase></cfdefaultcase>
		<cfcase value="Start">
			<a href="Users.cfm?A=SearchAD">Search Active Directory</a>
		</cfcase>
		<cfcase value="SearchAD">
			<div class="panel panel-default">
				<div class="panel-body">
			<cfoutput>
			<form action="#cgi.script_name#?A=ProcessADSearch" method="post" class="form-horizontal">
			</cfoutput>
				<div class="form-group">
					<div class="form-group">
						<label for="FirstName" class="col-sm-2 control-label">First Name:</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="FirstName" placeholder="..." name="FirstName">
						</div>
					</div>
					<div class="form-group">
						<label for="FirstNamePattern" class="col-sm-2 control-label">First Name Criteria:</label>
						<div class="col-sm-10">
							<select name="FirstNamePattern" class="form-control">
								<option value="Exact">Exact</option>
								<option value="Contains" selected>Contains</option>
								<option value="StartsWith">Starts With</option>
								<option value="EndsWith">Ends With</option>
							</select>				
						</div>
					</div>
				</div>
				<div class="form-group">
					<div class="form-group">
						<label for="LastName" class="col-sm-2 control-label">Last Name:</label>
						<div class="col-sm-10">
							<input type="text" class="form-control" id="LastName" placeholder="..." name="LastName">
						</div>
					</div>
					<div class="form-group">
						<label for="LastNamePattern" class="col-sm-2 control-label">Last Name Criteria:</label>
						<div class="col-sm-10">
							<select name="FirstNamePattern" class="form-control">
								<option value="Exact" selected>Exact</option>
								<option value="Contains">Contains</option>
								<option value="StartsWith">Starts With</option>
								<option value="EndsWith">Ends With</option>
							</select>				
						</div>
					</div>
				</div>
				<div class="form-group">
				<button type="submit" class="btn btn-primary" align="center"><span class="glyphicon glyphicon-search"></span> Search Active Directory</button>
				</div>
			</form>
				</div>
			</div>
		</cfcase>
		<cfcase value="ProcessADSearch">
			<cfscript>
				// BUILD LDAP FILTER CRITERIA
				IF (LEN(form.FirstName) GT 0) {
						GivenName = form.FirstName;
					}
				IF (LEN(form.LastName) GT 0) {
						SN = form.LastName;
					}
				IF (form.FirstNamePattern IS "exact") {
						GivenName = GivenName;
					}
				ELSE IF (form.FirstNamePattern IS "Contains") {
						GivenName = "*" & GivenName & "*";
					}
				ELSE IF (form.FirstNamePattern IS "StartsWith") {
						GivenName = "*" & GivenName;
					}
				ELSE {
						GivenName = GivenName & "*";
					}
				LDAPUserName = "ssmith@CHI.CHICORP";
				LDAPPassWord = "__Mp4f9!!";
				LDAPServer = "172.20.86.131";
				DCStart = "DC=CHI,DC=CHICORP";
			</cfscript>
		
			<cfldap action="QUERY"
				        name="GetADUsers"
				        attributes="samaccountname,sn,givenName,distinguishedname, company"
				        start="#dcStart#"
				        filter="givenname=#GivenName#"
				        server="#LDAPServer#"
				        username="#LDAPUserName#"
				        password="#LDAPPassWord#">

			<cfif GetADUsers.RecordCount GT 0>
				<cfoutput><form action="#cgi.script_name#?A=ProcessAddUsers" method="post" name="AddADUsers" id="AddADUsers"></cfoutput>
				<table class="table table-striped table-bordered table-condensed">
					<tr>
						<td>Import:</td>
						<td>User</td>
						<td>Company: </td>
					</tr>
					<cfoutput query="GetADUsers">
						<cfif DistinguishedName DOES NOT CONTAIN "disabled">
							<cfquery name="DupCheck" datasource="#DSN#">
								SELECT COUNT(*) AS TCount
									FROM dbo.persons
								WHERE SamAccountName = '#SamAccountName#'
							</cfquery>
							<cfif DupCheck.TCount EQ 0>
								<tr>
									<td><input type="checkbox" name="PersonToImport" value="#SamAccountName#"></td>
									<td>#SN#, #GivenName#</td>
									<td>#Company#</td>
								</tr>
							</cfif>
						</cfif>
					</cfoutput>
					<tr>
						<td colspan="3" align="center"><button type="submit" class="btn btn-primary" align="center"><span class="glyphicon glyphicon-search"></span> Add Users</button></td>
					</tr>
				</table>
				</form>
			</cfif>
						
		</cfcase>
		
		<cfcase value="ProcessAddUsers">
			
			<cfscript>
				LDAPUserName = "ssmith@CHI.CHICORP";
				LDAPPassWord = "__Mp4f9!!";
				LDAPServer = "172.20.86.131";
				DCStart = "DC=CHI,DC=CHICORP";
			</cfscript>
			
			<cfdump var="#form#">
		
			<cfloop index="i" list="#form.PersonToImport#" delimiters=",">
				<cfldap action="QUERY"
					        name="GetPersonDetails"
					        attributes="cn,givenName,sn,title,mail,distinguishedName,department,company,manager,telephoneNumber,employeeID,SamAccountName, directreports"
					        start="#dcStart#"
					        maxrows="1"
					        filter="samAccountName=#i#"
					        server="#LDAPServer#"
					        username="#LDAPUserName#"
					        password="#LDAPPassWord#">

					<cfif GetPersonDetails.RecordCount EQ 1>
					
						<cfquery name="InsertNewUser" datasource="#DSN#">
							INSERT INTO dbo.persons
								(employeeID, SamAccountName<cfif LEN(GetPersonDetails.directreports) GT 0>, PeopleLeader</cfif>)
							VALUES (#GetPersonDetails.employeeID#, '#LCase(GetPersonDetails.SamAccountName)#'<cfif LEN(GetPersonDetails.directreports) GT 0>,1</cfif>);
							SELECT PersonUUID
								FROM dbo.persons
							WHERE SamAccountName = '#LCase(GetPersonDetails.SamAccountName)#';
						</cfquery>

							<cfldap action="QUERY"
								        name="GetLeaderEmployeeID"
								        attributes="employeeID"
								        start="#dcStart#"
								        maxrows="1"
								        filter="distinguishedName=#GetPersonDetails.manager#"
								        server="#LDAPServer#"
								        username="#LDAPUserName#"
								        password="#LDAPPassWord#">
							<cfscript>
								IF (GetleaderEmployeeID.RecordCount EQ 0) {
										LeaderEmployeeID = 0;
									}
								ELSE {
										LeaderEmployeeID = GetLeaderEmployeeID.employeeID;
									}
							</cfscript>
							<cfoutput query="GetPersonDetails">
								<cfquery name="InsertNewUserData" datasource="#DSN#">
									INSERT INTO dbo.persondata
										(personUUID,cn,givenName,sn,title,mail,distinguishedName,department,company,manageremployeeid,telephoneNumber,managerdistinguishedName)
									VALUES ('#InsertNewUser.PersonUUID#','#cn#','#givenName#','#sn#','#title#','#mail#','#distinguishedName#','#department#','#company#',
												#LeaderEmployeeID#,'#telephoneNumber#','#manager#')
								</cfquery>
							</cfoutput>
						
					</cfif>
					
			</cfloop>
			
			
			
		</cfcase>
		
	</cfswitch>
	
	
