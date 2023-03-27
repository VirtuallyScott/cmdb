
	<cfinclude template="header.cfm">
	<cfinclude template="topmenu.cfm">
	
	<div class="page-header">
		<h1><span class="glyphicon glyphicon-plus-sign"></span> Add New Application</h1>
	</div>

		<cfswitch expression="#url.A#">
			<cfcase value="Start">
				<cfquery name="GetCompanies" datasource="#DSN#">
					sp_GetCompanies
				</cfquery>
				<cfquery name="GetPersons" datasource="#DSN#">
					sp_GetPerson_CN_Sam_UUID
				</cfquery>
				<cfquery name="GetSites" datasource="#DSN#">
					sp_GetSites
				</cfquery>
				<cfquery name="GetApplicationTypes" datasource="#DSN#">
					sp_GetApplicationTypes
				</cfquery>
				<cfquery name="GetChangePriorities" datasource="#DSN#">
					sp_GetChangePriorities
				</cfquery>
				<form action="newapplication.cfm?A=AddNew" method="post" name="newapplication" id="newapplication">
					<div class="form-group">
						<label for="ApplicationName">Application</label>
						<input type="text" class="form-control" id="ApplicationName" placeholder="New Application Name" name="ApplicationName">
					</div>
					<div class="form-group">
						<label for="ApplicationDescription">Application Description</label>
						<input type="text" class="form-control" id="ApplicationDescription" placeholder="Application Description" name="ApplicationDescription">
					</div>
					<div class="form-group">
						<label for="WikiURL">Wiki URL</label>
						<input type="text" class="form-control" id="WikiURL" placeholder="Wiki URL" name="WikiURL">
					</div>
					<div class="form-group">
						<label for="GITURL">GIT URL</label>
						<input type="text" class="form-control" id="GITURL" placeholder="GIT URL" name="GITURL">
					</div>
					<div class="form-group">
						<label for="ApplicationType">Application Type</label>
						<select name="ApplicationType" class="form-control">
							<cfoutput query="GetApplicationTypes">
								<option value="#CompanyUUID#,#ApplicationTypeUUID#">[#CompanyName#] #ApplicationType#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label for="ChangePriority">Change Priority</label>
						<select name="ChangePriority">
							<cfoutput query="GetChangePriorities">
								<option value="#ChangePriorityUUID#">#ChangePriority#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label for="Sites">Production Site</label>
						<select name="ProductionSiteUUID" class="form-control">
							<cfoutput query="GetSites">
								<option value="#SiteUUID#">#SiteName#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label for="Sites">Disaster Recovery Site</label>
						<select name="DRSiteUUID" class="form-control">
							<option></option>
							<cfoutput query="GetSites">
								<option value="#SiteUUID#">#SiteName#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<cfoutput><label for="Owner">Owner</label> <a href="Users.cfm?RedirectURL=#RedirectURL#" target="_blank">Preferred Owner Not Listed?</a></cfoutput>
						<select name="Owner" class="form-control">
							<cfoutput query="GetPersons">
								<option value="#PersonUUID#"<cfif session.PersonUUID EQ PersonUUID> selected</cfif>>#cn#</option>
							</cfoutput>
						</select>
					</div>
					<div class="checkbox">
						<label>
							<input type="checkbox" name="DR" value="1"> Requires Disaster Recovery
						</label>
					</div>
					<div class="checkbox">
						<label>
							<input type="checkbox" name="PCI" value="1"> Requires PCI Compliance
						</label>
					</div>
					<div class="form-group">
						<button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-plus-sign"></span> Add New Application</button>
						<button type="reset" class="btn btn-default"><span class="glyphicon glyphicon-minus-sign"></span> Reset Form</button>
					</div>
				</form>			
			</cfcase>
			<cfcase value="AddNew">
				<cfquery name="DupCheck" datasource="#DSN#">
					SELECT COUNT(*) TCount
						FROM applications
					WHERE applicationname = '#form.applicationname#'
					AND CompanyUUID = '#ListFirst(form.ApplicationType, ",")#'
					AND ApplicationTypeUUID = '#ListLast(form.ApplicationType, ",")#'
				</cfquery>
				<cfif DupCheck.TCount GT 0>
					<b>ERROR:</b>
				<cfelse>
					<cfscript>
						IF (NOT IsDefined("form.DR")) {
								form.DR = 0;
							}
						IF (NOT IsDefined("form.PCI")) {
								form.PCI = 0;
							}
					</cfscript>
					<cfquery name="AddNewApplication" datasource="#DSN#">
						INSERT INTO
							Applications(ApplicationTypeUUID, CompanyUUID, ChangePriorityUUID, ApplicationName, ApplicationDescription, PCI, DR, ProductionSiteUUID<cfif LEN(form.DRSiteUUID) GT 0>,DRSiteUUID</cfif>, WikiURL, GITURL)
						VALUES('#ListLast(form.ApplicationType, ",")#', '#ListFirst(form.ApplicationType, ",")#', '#form.ChangePriority#', '#form.ApplicationName#', '#form.ApplicationDescription#', #form.PCI#, #form.DR#, '#form.ProductionSiteUUID#'<cfif LEN(form.DRSiteUUID) GT 0>,'#form.DRSiteUUID#'</cfif>, '#form.WikiURL#', '#form.GITURL#');
						SELECT TOP 1 ApplicationUUID
							FROM Applications
						ORDER BY StartDate DESC
					</cfquery>
					<cfquery name="DRPCIOwner" datasource="#DSN#">
						INSERT INTO application_owners
							(applicationUUID, personUUID, ownertype)
						VALUES('#AddNewApplication.ApplicationUUID#', '#form.Owner#', '1')
						<cfif form.DR EQ 1>
							INSERT INTO dr_validation_date
								(ApplicationUUID, DueDate)
							VALUES('#AddNewApplication.ApplicationUUID#', DATEADD(quarter,1,GetUTCDate()))
						</cfif>
						<cfif form.PCI EQ 1>
							INSERT INTO pci_validation_date
								(ApplicationUUID, DueDate)
							VALUES('#AddNewApplication.ApplicationUUID#', DATEADD(quarter,1,GetUTCDate()))
						</cfif>
					</cfquery>
				</cfif>
				<cfinclude template="status.cfm">
			</cfcase>
		</cfswitch>
