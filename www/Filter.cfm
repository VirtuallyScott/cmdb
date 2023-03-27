
	<cfinclude template="header.cfm">	
	<cfinclude template="topmenu.cfm">
	
	<div class="page-header">
		<h1><span class="glyphicon glyphicon-search"></span> Filter Results</h1>
	</div>
	<div class="row">
		<cfswitch expression="#url.A#">
			<cfdefaultcase></cfdefaultcase>
			<cfcase value="Start">

<form>
 	<div class="form-group">
		<select>
			<option value="%_%">Contains</option>
			<option value="%_">Ends With</option>
			<option value="_%">Starts With</option>
		</select>
	</div>
</form>
			</cfcase>
			
			<cfcase value="FromNavBar">
			
				<cfif LEN(form.SearchCriteria) EQ 0>
					<b>ERROR!</b> No Search Criteria
				<cfelse>
					<cfquery name="SearchApps" datasource="#DSN#">
						SELECT EndDate, ApplicationUUID, ApplicationName, ApplicationDescription
							FROM applications
						WHERE ApplicationName LIKE '%#form.SearchCriteria#%'
						OR ApplicationDescription LIKE '%#form.SearchCriteria#%'
						ORDER BY ApplicationName ASC
					</cfquery>
					
					<cfif SearchApps.RecordCount GT 0>
						<table class="table table-striped table-bordered table-condensed">
							<tr>
								<td><strong>View Application</strong></td>
								<td><strong>Application</strong></td>
								<td><strong>Description</strong></td>
							</tr>
						<cfoutput query="SearchApps">
							<cfif LEN(EndDate) EQ 0>
								<tr>
							<cfelse>
								<tr class="danger">
							</cfif>
								<td><a href="ApplicationDetails.cfm?ApplicationUUID=#ApplicationUUID#">View</a></td>
								<td>#ApplicationName#</td>
								<td>#ApplicationDescription#</td>
							</tr>
						</cfoutput>
						</table>
					<cfelse>
						No Results
					</cfif>
					
				</cfif>
			

			</cfcase>
			
		</cfswitch>
	</div>