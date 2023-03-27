<!---
	Template /ApplicationEdit.cfm
	Edit Application Details And Data With The Exception Of The Application Name.
	CaseStatements Are Based On The Variable url.A
	
	Inputs;
		url.ApplicationUUID
		form.ApplicationUUID
		url.A
		session.PersonUUID
	
	Outputs;
		ApplicationUUID			Inherited From pchk_owner.cfm Will Take url.ApplicationUUID or form.ApplicationUUID
			And Set Value For ApplicationUUID
		
	Include BootStrap Components and pchk_owner.cfm
	pchk_owner.cfm Will Return Variables 
		AppOwner
		OwnerType

--->

	<cfinclude template="Header.cfm">	
	<cfinclude template="TopMenu.cfm">
	<cfinclude template="pchk_owner.cfm">
	
	<cfquery name="GetAppName" datasource="#DSN#">
		sp_GetApplicationName
			@ApplicationUUID = '#ApplicationUUID#'
	</cfquery>
	
	<div class="page-header">
		<h1>Edit Application - <cfoutput>#GetAppName.ApplicationName#</cfoutput></h1>
	</div>	

	<cfif AppOwner IS "False" And OwnerType IS "None">
		<cfset Status = "False">
		<cfinclude template="Status.cfm">
	<cfelse>
	
	</cfif>
	


	<cfswitch expression="#url.A#">
		<cfdefaultcase></cfdefaultcase>
		<cfcase value="Start">
			<div class="page-header">
				<h1>Edit Application - </h1>
			</div>
		</cfcase>
		<cfcase value="AddDR">
			<cfquery name="AddDR" datasource="#DSN#">
				UPDATE applications
					SET DR = 1
				WHERE ApplicationUUID = '#url.ApplicationUUID#';
				INSERT INTO dr_validation_date
					(ApplicationUUID, DueDate)
					VALUES ('#url.ApplicationUUID#', DATEADD(quarter,1,GetUTCDate()));
			</cfquery>
			<cfinclude template="status.cfm">
		</cfcase>
		<cfcase value="AddPCI">
			<cfquery name="AddPCI" datasource="#DSN#">
				UPDATE applications
					SET PCI = 1
				WHERE ApplicationUUID = '#url.ApplicationUUID#';
				INSERT INTO pci_validation_date
					(ApplicationUUID, DueDate)
					VALUES ('#url.ApplicationUUID#', DATEADD(quarter,1,GetUTCDate()));
			</cfquery>
			<cfinclude template="status.cfm">
		</cfcase>

<!--- 
		Change Primary Application Owner. If The User Attempting The Change Is Not The Primary Owner Throw Error And Redirect User.
		Primary Owner Must Be An Individual With Active Active Directory Account, A Primary Owner Cannot Be An Active Directory Group.
--->
		<cfcase value="ChangePrimaryOwner">
			<cfif AppOwner IS "True" AND OwnerType IS "Primary">
			
			<cfelse>
				<cfset Status = "False">
				<cfinclude template="Status.cfm">
			</cfif>
		
		</cfcase>
		
<!--- 
		Change Alternate Application Owner(s). If The User Attempting The Change Is Not The Primary Owner Throw Error And Redirect User.
		Alternate Owners Can Be Either Active Directory Group Or Individual Active Directory User
--->
		<cfcase value="ChangeAlternateOwner">
			<cfif AppOwner IS "True" AND OwnerType IS "Primary">
			
				<cfquery name="CheckExistingADOwners" datasource="#DSN#">
					SELECT [ADGroupUUID]
						FROM [dbo].[application_owners]
					WHERE [ApplicationUUID] = '#ApplicationUUID#'
					AND EndDate IS NULL
				</cfquery>

				<cfscript>
					InList = "";
					for (
							LoopCounter = 1;
							LoopCounter LTE CheckExistingADOwners.RecordCount;
							LoopCounter = LoopCounter +1)	{
								InList = ListAppend(InList, CheckExistingADOwners.ADGroupUUID[LoopCounter], SC);
						}
					InList = ListQualify(InList, SSQ, SC, "ALL");
				</cfscript>
				
				<cfif LEN(InList) GT 0>
					<cfquery name="GetExistingADGroups" datasource="#DSN#">
						SELECT ADGroupUUID, CN, SamAccountName
							FROM [dbo].[active_directory_groups]
						WHERE ADGroupUUID IN (#PreserveSingleQuotes(InList)#)
						AND EndDate IS NULL
						ORDER BY cn ASC
					</cfquery>
				</cfif>
			
				<cfquery name="GetADGroups" datasource="#DSN#">
					<cfif LEN(InList) GT 0>
						SELECT ADGroupUUID, CN, SamAccountName
							FROM [dbo].[active_directory_groups]
						WHERE ADGroupUUID NOT IN (#PreserveSingleQuotes(InList)#)
						AND EndDate IS NULL
						ORDER BY cn ASC
					<cfelse>
						sp_GetActiveDirectoryGroups
					</cfif>
				</cfquery>
				
				<cfquery name="CheckExistingAlternates" datasource="#DSN#">
					SELECT PersonUUID
						FROM [dbo].[application_owners]
					WHERE [ApplicationUUID] = '#ApplicationUUID#'
					AND OwnerType = 0
					AND EndDate IS NULL
				</cfquery>
				
				<cfscript>
					InList = "";
					for (
							LoopCounter = 1;
							LoopCounter LTE CheckExistingAlternates.RecordCount;
							LoopCounter = LoopCounter +1)	{
								InList = ListAppend(InList, CheckExistingAlternates.PersonUUID[LoopCounter], SC);
						}
					InList = ListQualify(InList, SSQ, SC, "ALL");
				</cfscript>
				
				<cfif LEN(InList) GT 0>
					<cfquery name="GetExistingAlternates" datasource="#DSN#">
						SELECT persons.sAMAccountName, persondata.cn, persons.PersonUUID
						FROM     persondata INNER JOIN
						                  persons ON persondata.PersonUUID = persons.PersonUUID
						WHERE persons.PersonUUID IN (#PreserveSingleQuotes(InList)#)
						AND persons.EndDate IS NULL
						ORDER BY cn ASC
					</cfquery>
				</cfif>
				
				<cfquery name="GetUsers" datasource="#DSN#">
					<cfif LEN(InList) GT 0>
						SELECT persons.sAMAccountName, persondata.cn, persons.PersonUUID
						FROM     persondata INNER JOIN
						                  persons ON persondata.PersonUUID = persons.PersonUUID
						WHERE persons.PersonUUID NOT IN (#PreserveSingleQuotes(InList)#)
						AND persons.EndDate IS NULL
						ORDER BY cn ASC
					<cfelse>
						sp_GetPerson_CN_Sam_UUID
					</cfif>
				</cfquery>
				
				<table class="table table-bordered table-condensed">
					<form action="ApplicationEdit.cfm?A=ProcessChangeAlternateOwner" method="post" name="AlternateOwner" id="AlternateOwner">
						<cfoutput>
							<input type="hidden" name="ApplicationUUID" value="#ApplicationUUID#">
							<input type="hidden" name="RedirectURL" value="#cgi.script_name#?#cgi.query_string#">
						</cfoutput>
						<input type="hidden" name="ChangeType" value="Individual">
					<tr>
						<td colspan="2" align="center"><strong>Individual Alternate Owners</strong></td>
					</tr>
					<tr>
						<td><strong>Current Alternate Owners</strong></td>
						<td><strong>Assign New Alternate Owners</strong></td>
					</tr>
					<tr>
						<td>
							<select name="OwnersToRemove" size="10" multiple>
								<cfif IsDefined("GetExistingAlternates")>
									<cfoutput query="GetExistingAlternates">
										<option value="#PersonUUID#">#CN#</option>
									</cfoutput>								
								</cfif>
							</select>
						</td>
						<td>
							<select name="OwnersToAdd" size="10" multiple>
								<cfoutput query="GetUsers">
									<option value="#PersonUUID#">#CN#</option>
								</cfoutput>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<div class="form-group">
								<button type="submit" class="btn btn-default"><span class="halflings halflings-edit"></span> Edit Alternate Owners</button>
								<button type="reset" class="btn btn-default"><span class="glyphicon glyphicon-minus-sign"></span> Reset Form</button>
							</div>
						</form>	
						</td>
					</tr>
				</table>
				
				<table class="table table-bordered table-condensed">
					<form action="ApplicationEdit.cfm?A=ProcessChangeAlternateOwner" method="post" name="AlternateOwnerGroup" id="AlternateOwnerGroup">
						<cfoutput>
							<input type="hidden" name="ApplicationUUID" value="#ApplicationUUID#">
							<input type="hidden" name="RedirectURL" value="#cgi.script_name#?#cgi.query_string#">
						</cfoutput>
						<input type="hidden" name="ChangeType" value="ActiveDirectory">
					<tr>
						<td colspan="2" align="center"><strong>Active Directory Groups</strong></td>
					</tr>
					<tr>
						<td><strong>Current Groups Assigned</strong></td>
						<td><strong>Assign New Groups</strong></td>
					</tr>
					<tr>
						<td>
							<select name="ADGroupsToRemove" size="10" multiple>
								<cfif IsDefined("GetExistingADGroups")>
									<cfoutput query="GetExistingADGroups">
										<option value="#ADGroupUUID#">#CN#</option>
									</cfoutput>
								</cfif>
							</select>
						</td>
						<td>
							<select name="ADGroupsToAdd" size="10" multiple>
								<cfoutput query="GetADGroups">
									<option value="#ADGroupUUID#">#CN#</option>
								</cfoutput>
							</select>						
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<div class="form-group">
								<button type="submit" class="btn btn-default"><span class="halflings halflings-edit"></span> Edit Alternate Owners</button>
								<button type="reset" class="btn btn-default"><span class="glyphicon glyphicon-minus-sign"></span> Reset Form</button>
							</div>
						</form>	
						</td>
					</tr>
				</table>


			
			<cfelse>
				<cfset Status = "False">
				<cfinclude template="Status.cfm">
			</cfif>
		
		</cfcase>
		
		<cfcase value="ProcessChangeAlternateOwner">
<!--- Edit Alternate Owners. Add Or Remove Active Directory Groups. --->
			<cfif form.ChangeType IS "ActiveDirectory">
				<cfif IsDefined("form.ADGroupsToAdd")>
					<cfset AddQueryList = form.ADGroupsToAdd>
					<cfquery name="AddGroups" datasource="#DSN#">
						<cfif ListLen(AddQueryList, SC) GT 1>
							<cfloop index="i" list="#AddQueryList#" delimiters="#SC#">
								INSERT INTO [dbo].[application_owners]
									([ApplicationUUID], [OwnerType], [ADGroupUUID])
								VALUES ('#ApplicationUUID#', 0, '#i#');
							</cfloop>
						<cfelse>
							INSERT INTO [dbo].[application_owners]
								([ApplicationUUID], [OwnerType], [ADGroupUUID])
							VALUES ('#ApplicationUUID#', 0, '#AddQueryList#')
						</cfif>
					</cfquery>
				</cfif>
				<cfif IsDefined("form.ADGroupsToRemove")>
					<cfset RemoveQueryList = ListQualify(form.ADGroupsToRemove, SSQ, SC, "ALL")>
					<cfquery name="RemoveGroups" datasource="#DSN#">
						DELETE [dbo].[application_owners]
							WHERE ApplicationUUID = '#ApplicationUUID#'
							AND ADGroupUUID IN (#PreserveSingleQuotes(RemoveQueryList)#)
					</cfquery>
				</cfif>
				<cfset Status = "True">
				<cfinclude template="Status.cfm">
<!--- Edit Alternate Owners. Add Or Remove Individuals. --->
			<cfelseif ChangeType IS "Individual">
				<cfif IsDefined("form.OwnersToAdd")>
					<cfset AddQueryList = form.OwnersToAdd>
					<cfquery name="AddOwners" datasource="#DSN#">
						<cfif ListLen(AddQueryList, SC) GT 1>
							<cfloop index="i" list="#AddQueryList#" delimiters="#SC#">
								INSERT INTO [dbo].[application_owners]
									([ApplicationUUID], [OwnerType], [PersonUUID])
								VALUES ('#ApplicationUUID#', 0, '#i#');
							</cfloop>
						<cfelse>
							INSERT INTO [dbo].[application_owners]
								([ApplicationUUID], [OwnerType], [PersonUUID])
							VALUES ('#ApplicationUUID#', 0, '#AddQueryList#')
						</cfif>
					</cfquery>
				</cfif>
					<cfif IsDefined("form.OwnersToRemove")>
						<cfset RemoveQueryList = ListQualify(form.OwnersToRemove, SSQ, SC, "ALL")>
						<cfquery name="RemoveOwners" datasource="#DSN#">
							DELETE [dbo].[application_owners]
								WHERE ApplicationUUID = '#ApplicationUUID#'
								AND PersonUUID IN (#PreserveSingleQuotes(RemoveQueryList)#)
						</cfquery>
					</cfif>
					<cfset Status = "True">
					<cfinclude template="Status.cfm">				
			<cfelse>

			</cfif>
			
		</cfcase>
		
	</cfswitch>
