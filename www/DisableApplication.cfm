
	<cfinclude template="header.cfm">
	<cfinclude template="topmenu.cfm">
	
	<cfswitch expression="#url.A#">
		<cfdefaultcase></cfdefaultcase>
		<cfcase value="Start">
			<div class="alert alert-danger" role="alert" align="center">
				<strong>ONCE AN APPLICATION IS DISABLED AN END-USER CANNOT RE-ENABLE IT.</strong><br>
			<form action="DisableApplication.cfm?A=DisableConfirmed" method="post">
				<input type="hidden" name="ApplicationToDelete" value="<cfoutput>#url.ApplicationUUID#</cfoutput>" class="form-control">
				<button type="submit" class="btn btn-danger"><span class="glyphicon glyphicon-warning-sign"></span> Disable Application</button>
			</form>
			</div>
		</cfcase>
		<cfcase value="DisableConfirmed">

				<cfinclude template="status.cfm">
				<cfquery name="DisableAllApplicationTables" datasource="#DSN#">
					BEGIN TRAN D1;
						UPDATE [dbo].[dr_validation_date]
							SET EndDate = (getUTCDate())
						WHERE ApplicationUUID = '#form.ApplicationToDelete#';
						UPDATE [dbo].[pci_validation_date]
							SET EndDate = (getUTCDate())
						WHERE ApplicationUUID = '#form.ApplicationToDelete#';
						UPDATE [dbo].[dependencies]
							SET EndDate = (getUTCDate())
						WHERE ParentUUID = '#form.ApplicationToDelete#'
						OR ChildUUID = '#form.ApplicationToDelete#';
						UPDATE [dbo].[application_owners]
							SET EndDate = (getUTCDate())
						WHERE ApplicationUUID = '#form.ApplicationToDelete#';
						UPDATE [dbo].[application_smes]
							SET EndDate = (getUTCDate())
						WHERE ApplicationUUID = '#form.ApplicationToDelete#';
						UPDATE [dbo].[applications]
							SET EndDate = (getUTCDate())
						WHERE ApplicationUUID = '#form.ApplicationToDelete#';
					COMMIT TRAN D1;
				</cfquery>
		
		</cfcase>
	</cfswitch>
