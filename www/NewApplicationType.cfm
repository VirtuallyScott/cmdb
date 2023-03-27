
	<cfinclude template="header.cfm">
	<cfinclude template="topmenu.cfm">
	

	
		<cfswitch expression="#url.A#">
			<cfcase value="Start">
				<cfquery name="GetCompanies" datasource="#DSN#">
					SELECT CompanyUUID, CompanyName
						FROM [dbo].[companies]
					WHERE EndDate IS NULL
					ORDER BY CompanyName ASC
				</cfquery>
				<div class="page-header">
					<h1><span class="glyphicon glyphicon-plus-sign"></span> New Application Type</h1>
				</div>

					<form action="newapplicationtype.cfm?A=AddNew" method="post" name="newapplicationtype" id="newapplicationtype">
						<div class="form-group">
							<label for="ApplicationType">Application Type</label>
							<input type="text" class="form-control" id="ApplicationType" placeholder="New Application Type" name="ApplicationType">
						</div>
						<div class="form-group">
							<label for="CompanyUUID">Company</label>
							<select name="CompanyUUID" class="form-control">
								<cfoutput query="GetCompanies">
									<option value="#CompanyUUID#">#CompanyName#</option>
								</cfoutput>
							</select>
						</div>
						<div class="form-group">
							<button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-plus-sign"></span> Add Type</button>
							<button type="reset" class="btn btn-default"><span class="glyphicon glyphicon-minus-sign"></span> Reset Form</button>
						</div>
					</form>

			</cfcase>
			<cfcase value="AddNew">
				<div class="page-header">
					<h3>Adding New Application Type</h1>
				</div>

				<cfquery name="DupCheck" datasource="#DSN#">
					SELECT *
						FROM application_types
					WHERE CompanyUUID = '#form.CompanyUUID#'
					AND ApplicationType = '#TRIM(#form.ApplicationType#)#'
					AND EndDate IS NULL
				</cfquery>
				<cfif DupCheck.RecordCount GT 0>

					<div class="alert alert-danger" role="alert">
						Application Already Exists - <a href="newapplicationtype.cfm" class="alert-link">Try Again</a>
					</div>
				<cfelse>
					<cfquery name="AddApplicationType" datasource="#DSN#">
						INSERT INTO application_types
							(CompanyUUID, ApplicationType)
						VALUES ('#form.CompanyUUID#', '#TRIM(#form.ApplicationType#)#')
					</cfquery>
				</cfif>
				
				
			</cfcase>
		</cfswitch>
	