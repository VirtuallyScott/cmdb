
	<cfinclude template="header.cfm">	
	<cfinclude template="topmenu.cfm">

	<div class="page-header">
		<h1>Manage Application Types</h1>
	</div>

	<a class="btn btn-default" href="manageapplicationtypes.cfm?A=AddNewType" role="button">Add New Type</a> <a class="btn btn-default" href="manageapplicationtypes.cfm?A=ShowAllTypes" role="button">Show All Types</a> <a class="btn btn-default" href="manageapplicationtypes.cfm?A=ShowActiveTypes" role="button">Show Active Types</a> <a class="btn btn-default" href="manageapplicationtypes.cfm?A=ShowExpiredTypes" role="button">Show Expired Types</a>
	
	<cfswitch expression="#url.A#">
		<cfcase value="Start">
		
		</cfcase>
		<cfcase value="ShowAllTypes">
			<cfquery name="GetAllTypesActive" datasource="#DSN#">
				SELECT application_types.ApplicationTypeUUID, application_types.ApplicationType, application_types.EndDate, companies.CompanyName
				FROM     application_types INNER JOIN
				                  companies ON application_types.CompanyUUID = companies.CompanyUUID
				ORDER BY application_types.ApplicationType
			</cfquery>
			<table class="table table-striped table-bordered table-condensed table-hover">
				<thead>
					<tr>
						<td>Application Type</td>
						<td>Company</td>
						<td>Edit</td>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="GetAllTypesActive">
					<tr>
						<td><a href="ApplicationsByType.cfm?ApplicationTypeUUID=#ApplicationTypeUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationType#</a></td>
						<td>#CompanyName#</td>
						<td>
							<cfif LEN(EndDate) GT 0>
								Inactive #DateFormat(EndDate, "mm/d/yyyy")#
							<cfelse>
								<a href="manageapplicationtypes.cfm?ApplicationTypeUUID=#ApplicationTypeUUID#&A=Edit"><span class="glyphicon glyphicon-pencil"></span></a>
							</cfif>
						</td>
					</tr>
					</cfoutput>
				</tbody>
			</table>
		</cfcase>
		<cfcase value="ShowActiveTypes">
			<cfquery name="GetAllTypesActive" datasource="#DSN#">
				SELECT application_types.ApplicationTypeUUID, application_types.ApplicationType, application_types.EndDate, companies.CompanyName
				FROM     application_types INNER JOIN
				                  companies ON application_types.CompanyUUID = companies.CompanyUUID
				WHERE application_types.EndDate IS NULL
				ORDER BY application_types.ApplicationType
			</cfquery>
			<table class="table table-striped table-bordered table-condensed table-hover">
				<thead>
					<tr>
						<td>Application Type</td>
						<td>Company</td>
						<td>Edit</td>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="GetAllTypesActive">
					<tr>
						<td><a href="ApplicationsByType.cfm?ApplicationTypeUUID=#ApplicationTypeUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationType#</a></td>
						<td>#CompanyName#</td>
						<td>
							<cfif LEN(EndDate) GT 0>
								Inactive #DateFormat(EndDate, "mm/d/yyyy")#
							<cfelse>
								<a href="manageapplicationtypes.cfm?ApplicationTypeUUID=#ApplicationTypeUUID#&A=Edit"><span class="glyphicon glyphicon-pencil"></span></a>
							</cfif>
						</td>
					</tr>
					</cfoutput>
				</tbody>
			</table>
		</cfcase>
		<cfcase value="ShowExpiredTypes">
			<cfquery name="GetAllTypesActive" datasource="#DSN#">
				SELECT application_types.ApplicationType, application_types.EndDate, companies.CompanyName
				FROM     application_types INNER JOIN
				                  companies ON application_types.CompanyUUID = companies.CompanyUUID
				WHERE application_types.EndDate IS NOT NULL
				ORDER BY application_types.ApplicationType
			</cfquery>
			<table class="table table-striped table-bordered table-condensed table-hover">
				<thead>
					<tr>
						<td>Application Type</td>
						<td>Company</td>
						<td>Inactive Date</td>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="GetAllTypesActive">
						<cfscript>
							if (session.TFormat IS "Local") {
									FixedDate = DateConvert("UTC2Local", EndDate);
								}
							else {
									FixedDate = EndDate;
								}
							FixedDate = ParseDateTime(FixedDate);
							FixedTime = TimeFormat(FixedDate, session.TimeMask);
						</cfscript>
						<tr>
							<td>#ApplicationType#</td>
							<td>#CompanyName#</td>
							<td>#DateFormat(EndDate, session.DateMask)# - #FixedTime#</td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
		</cfcase>
		<cfcase value="Edit">
			<cfquery name="GetApplicationsByApplicationType" datasource="#DSN#">
				SELECT ApplicationUUID, ApplicationName
					FROM Applications
				WHERE ApplicationTypeUUID = '#url.ApplicationTypeUUID#'
			</cfquery>
			<cfquery name="GetAppType" datasource="#DSN#">
				SELECT ApplicationType
					FROM application_types
				WHERE ApplicationTypeUUID = '#url.ApplicationTypeUUID#'
			</cfquery>
			<cfif GetApplicationsByApplicationType.RecordCount GT 0>
				<div class="alert alert-danger" role="alert">
					Application Type Associated To Applications - <a href="manageapplicationtypes.cfm?ApplicationTypeUUID=<cfoutput>#url.ApplicationTypeUUID#&A=Edit</cfoutput>" class="alert-link">Try Again</a>
				</div>
			<cfelse>
					<form action="manageapplicationtypes.cfm?A=ProcessEdit&ApplicationTypeUUID=<cfoutput>#url.ApplicationTypeUUID#</cfoutput>" method="post" name="manageapplicationtype" id="manageapplicationtype">
						<div class="form-group">
							<label for="ApplicationType">Application Type</label>
							<input type="text" class="form-control" id="ApplicationType" placeholder="<cfoutput>#GetAppType.ApplicationType#</cfoutput>" name="ApplicationType">
						</div>
						<div class="form-group">
							<div class="checkbox">
								<label>
								<input type="checkbox" id="DisableApplicationType" value="Disable" name="DisableApplicationType">
								Disable Application Type
								</label>
							</div>
						</div>
						<div class="form-group">
							<button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-plus-sign"></span> Update Type</button>
							<button type="reset" class="btn btn-default"><span class="glyphicon glyphicon-minus-sign"></span> Reset Form</button>
						</div>

					</form>
			</cfif>
		</cfcase>
		<cfcase value="AddNewType">
			<cfquery name="GetCompanies" datasource="#DSN#">
				SELECT CompanyUUID, CompanyName
					FROM [dbo].[companies]
				WHERE EndDate IS NULL
				ORDER BY CompanyName ASC
			</cfquery>
				<form action="manageapplicationtypes.cfm?A=ProcessAddNewType" method="post" name="newapplicationtype" id="newapplicationtype">
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
		<cfcase value="ProcessAddNewType">
			<cfquery name="DupCheck" datasource="#DSN#">
				SELECT *
					FROM application_types
				WHERE CompanyUUID = '#form.CompanyUUID#'
				AND ApplicationType = '#TRIM(#form.ApplicationType#)#'
				AND EndDate IS NULL
			</cfquery>
			<cfif DupCheck.RecordCount GT 0>
				<div class="alert alert-danger" role="alert">
					Application Type Already Exists - <a href="manageapplicationtypes.cfm?A=AddNewType" class="alert-link">Try Again</a>
				</div>
			<cfelse>
				<cfquery name="AddApplicationType" datasource="#DSN#">
					INSERT INTO application_types
						(CompanyUUID, ApplicationType)
					VALUES ('#form.CompanyUUID#', '#TRIM(#form.ApplicationType#)#')
				</cfquery>
			</cfif>
		</cfcase>
		<cfcase value="ProcessEdit">
			<cfif form.DisableApplicationType IS "Disable">
				<cfquery name="UpdateApplicationType" datasource="#DSN#">
					UPDATE application_types
						SET EndDate = (GetUTCDate())
					WHERE ApplicationTypeUUID = '#url.ApplicationTypeUUID#'
				</cfquery>
			</cfif>
			<cfinclude template="status.cfm">
		</cfcase>
	</cfswitch>
