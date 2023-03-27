
	<cfinclude template="header.cfm">	
	<cfinclude template="topmenu.cfm">
	
	<div class="page-header">
		<h1><span class="glyphicon glyphicon-globe"></span> Site Management</h1>
	</div>

				<cfswitch expression="#url.A#">
					<cfcase value="Start">
						<cfquery name="GetActiveSites" datasource="#DSN#">
							SELECT SiteUUID, StartDate, SiteName
								FROM sites
							WHERE EndDate IS NULL
							ORDER BY SiteName ASC
						</cfquery>
						<table class="table table-striped table-bordered">
							<tr>
								<th>Date Entered</th>
								<th>Site Location</th>
								<th>Edit</th>
							</tr>
							<cfoutput query="GetActiveSites">
								<tr>
									<td>#DateFormat(StartDate, "mm/d/yyyy")#</td>
									<td><a href="applications.cfm?A=ByProductionSite&ProductionSiteUUID=#SiteUUID#">#SiteName#</a></td>
									<td><a href="sites.cfm?A=Edit&SiteUUID=#SiteUUID#"><span class="glyphicon glyphicon-pencil"</a></td>
								</tr>
							</cfoutput>
						</table>
					</cfcase>
					<cfcase value="Edit">
					
					</cfcase>
				</cfswitch>
