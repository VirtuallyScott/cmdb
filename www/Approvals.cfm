
	<cfinclude template="Header.cfm">
	<cfinclude template="TopMenu.cfm">
	
	<cfswitch expression="#url.A#">
		<cfdefaultcase></cfdefaultcase>
		<cfcase value="Start">
		
		</cfcase>
		<cfcase value="MyApprovals">
			<cfquery name="GetApprovals" datasource="#DSN#">
				SELECT approve_application_owner_change.ApprovalApplicationOwnerUUID, approve_application_owner_change.StartDate, persondata.mail, applications.ApplicationName, 
				                  approve_application_owner_change.ApplicationUUID
				FROM     approve_application_owner_change INNER JOIN
				                  persondata ON approve_application_owner_change.NewOwnerPersonUUID = persondata.PersonUUID INNER JOIN
				                  applications ON approve_application_owner_change.ApplicationUUID = applications.ApplicationUUID
				WHERE approve_application_owner_change.NewOwnerPersonUUID = '#session.PersonUUID#'
			</cfquery>
			
			<cfoutput query="GetApprovals">
				#ApprovalApplicationOwnerUUID#<br>
			</cfoutput>
			
		</cfcase>
		
	</cfswitch>