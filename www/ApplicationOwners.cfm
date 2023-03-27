

	<cfinclude template="header.cfm">
	<cfinclude template="topmenu.cfm">
	
	<cfscript>
		Error = 0;
		IF (IsDefined("url.ApplicationUUID")) {
				ApplicationUUID = url.ApplicationUUID;
			}
		IF (IsDefined("form.ApplicationUUID")) {
				ApplicationUUID = form.ApplicationUUID;
			}
		IF (LEN(ApplicationUUID) EQ 0) {
				Error = 1;
			}
	</cfscript>
	
	
	<cfswitch expression="#url.A#">
		<cfdefaultcase><strong>ERROR!</strong></cfdefaultcase>
		<cfcase value="Start">
		
		</cfcase>
		
		<cfcase value="ChangePrimaryOwner">

			<cfquery name="GetPrimaryOwner" datasource="#DSN#">
				sp_GetPrimaryOwnerByApplicationUUID	
					@ApplicationUUID = '#ApplicationUUID#'
			</cfquery>

			<cfif session.Permissions[1][2] EQ 1 OR GetPrimaryOwner.PersonUUID IS session.PersonUUID>

				<cfquery name="GetActiveUsers" datasource="#DSN#">
					sp_GetPerson_CN_Sam_UUID
				</cfquery>
				

				<form action="ApplicationOwners.cfm?A=ProcessChangePrimaryOwner" method="post" name="ChangePrimaryOwner" id="ChangePrimaryOwner">
					<cfoutput>
						<input type="hidden" name="ApplicationUUID" value="#url.ApplicationUUID#">
						<input type="hidden" name="OldOwnerPersonUUID" value="#GetPrimaryOwner.PersonUUID#">
					</cfoutput>
					<div class="form-group">
						<label for="NewOwnerPersonUUID">New Primary Owner: </label>
						<select name="NewOwnerPersonUUID">
							<cfoutput query="GetActiveUsers">
								<option value="#PersonUUID#">#CN#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<button type="submit" class="btn btn-default">Change Primary Owner</button>
					</div>
				</form>
				
			<cfelse>
				<cferror type="REQUEST" template="" exception="You Don't Belong Here!">
			</cfif>
			
			
		</cfcase>
		
		<cfcase value="ChangeAlternateOwner">
		
		</cfcase>
		
		<cfcase value="ProcessChangePrimaryOwner">
			<cfquery name="InsertApprovalRecord" datasource="#DSN#">
				INSERT INTO 
					[dbo].[approve_application_owner_change]
				([ApplicationUUID],[NewOwnerPersonUUID],[OldOwnerPersonUUID],[OwnerType])
				VALUES('#form.ApplicationUUID#', '#form.NewOwnerPersonUUID#', '#form.OldOwnerPersonUUID#', 1)
			</cfquery>
			
			<cfquery name="GetApprovalDetails" datasource="#DSN#">
				SELECT approve_application_owner_change.ApprovalApplicationOwnerUUID, approve_application_owner_change.StartDate, persondata.mail
					FROM approve_application_owner_change INNER JOIN
				persondata ON approve_application_owner_change.NewOwnerPersonUUID = persondata.PersonUUID
				WHERE approve_application_owner_change.EndDate IS NULL
				AND approve_application_owner_change.ApprovalDate IS NULL
			</cfquery>

			<cfmail to="#GetApprovalDetails.Mail#" from="" subject="Pending CMDB Approval" server="" port=25 timeout=60>
				You have approvals requiring your attention http://#baseURL#/Approvals.cfm?A=MyApprovals
			</cfmail>

			
		</cfcase>
		
	</cfswitch>