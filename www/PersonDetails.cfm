
	<cfinclude template="header.cfm">
	<cfinclude template="topmenu.cfm">
	
	<cfquery name="GetPersonDetails" datasource="#DSN#">
		sp_GetPersonDataByUUID
			@PersonUUID = '#url.PersonUUID#'
	</cfquery>

	<cfquery name="GetMembership" datasource="#DSN#">
		sp_GetADMembershipsByPersonUUID
			@PersonUUID = '#url.PersonUUID#'
	</cfquery>

	<cfquery name="GetApplications" datasource="#DSN#">
		sp_GetApplicationsByOwnerUUID
			@PersonUUID = '#url.PersonUUID#'
	</cfquery>
	
	<cfscript>
		IF (FindNoCase("disabled", GetPersonDetails.DistinguishedName) GT 0) {
				FlagDisabled = "Yes";
			}
		ELSE {
				FlagDisabled = "No";
			}
	</cfscript>
	
	<div class="page-header<cfif FlagDisabled IS "Yes"> alert alert-danger</cfif>">
        <h1>Person Details<cfif FlagDisabled IS "Yes"> - <small>This User Is Disabled In Active Directory!</small></cfif></h1>
     </div>
	 
	<cfoutput>
		<table class="table table-striped table-bordered table-condensed">
			<tbody>
				<tr>
					<td>Name :</td>
					<td>#GetPersonDetails.cn#</td>
				</tr>
				<tr>
					<td>Title :</td>
					<td>#GetPersonDetails.Title#</td>
				</tr>
				<tr>
					<td>Company :</td>
					<td>#GetPersonDetails.Company#</td>
				</tr>
				<tr>
					<td>Department :</td>
					<td>#GetPersonDetails.department#</td>
				</tr>
				<tr>
					<td>Mail :</td>
					<td><a href="mailto:#GetPersonDetails.mail#">#GetPersonDetails.mail#</a></td>
				</tr>
				<tr>
					<td>Phone : </td>
					<td>#GetPersonDetails.telephoneNumber#</td>
				</tr>
				<tr>
					<td>Manager : </td>
					<td>

					</td>
				</tr>
				<tr>
					<td>People Leader : </td>
					<td><cfif GetPersonDetails.PeopleLeader EQ 1>Yes<cfelse>No</cfif></td>
				</tr>
				<cfif GetPersonDetails.PeopleLeader EQ 1>
					<cfquery name="GetDirectReports" datasource="#DSN#">
						SELECT PersonUUID, sn, givenname, EndDate
							FROM PersonData
						WHERE ManagerPersonUUID = '#GetPersonDetails.PersonUUID#'
						ORDER BY sn, EndDate
					</cfquery>
					
					<tr>
						<td>Direct Reports : </td>
						<td>
							<div class="list-group">
								<cfoutput query="GetDirectReports">
									<a href="PersonDetails.cfm?PersonUUID=#PersonUUID#" class="list-group-item">#sn#, #givenname#</a>
								</cfoutput>
							</div>
						</td>
					</tr>
				</cfif>
				<tr>
					<td><a href="applications.cfm?A=ByOwner&PersonUUID=#GetPersonDetails.PersonUUID#">Applications :</a></td>
					<td>
						<div class="list-group">
							<cfloop query="GetApplications"><a href="applicationdetails.cfm?ApplicationUUID=#GetApplications.ApplicationUUID#" class="list-group-item"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationName#</a></cfloop>
						</div>
					</td>
				</tr>
				<tr>
					<td>Active Directory Groups:</td>
					<td>
						<div class="list-group">
							<cfloop query="GetMembership">
								<a href="ViewADMembers.cfm?ADGroupUUID=#ADGroupUUID#" class="list-group-item"><span class="glyphicon glyphicon-sunglasses"></span>  #SamAccountName#</a>
							</cfloop>
						</div>
					</td>
				</tr>
			</tbody>
		</table>
	</cfoutput>
