
	<cfinclude template="header.cfm">	
	<cfinclude template="topmenu.cfm">
	
	<div class="page-header">
		<h1><span class="glyphicon glyphicon-globe"></span> Company Management</h1>
	</div>
	
	<cfswitch expression="#url.A#">
		<cfcase value="Start">
			<cfquery name="GetActiveCompanies" datasource="#DSN#">
				sp_GetAllActiveCompanies
			</cfquery>
			
			<table class="table table-striped table-bordered table-condensed">
				<tr>
					<th>Date Entered</th>
					<th>Company</th>
				</tr>
				<cfoutput query="GetActiveCompanies">
					<tr>
						<td>#DateFormat(StartDate, session.DateMask)#</td>
						<td>#CompanyName#</td>
					</tr>
				</cfoutput>
			</table>
		</cfcase>
	</cfswitch>
	