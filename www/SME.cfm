<cfinclude template="Header.cfm">
<cfinclude template="TopMenu.cfm">


<cfswitch expression="#url.A#">
	<cfdefaultcase></cfdefaultcase>
	<cfcase value="Start">
	
	</cfcase>
	<cfcase value="AddSME">
		<cfquery name="GetSMETypes" datasource="#DSN#">
			sp_GetAllSMETypes
		</cfquery>
		<cfquery name="GetApplications" datasource="#DSN#">
			sp_GetAllActiveAppsNameUUID
		</cfquery>
		<cfquery name="GetPeople" datasource="#DSN#">
			sp_GetPerson_CN_Sam_UUID
		</cfquery>
					

		<form action="SME.cfm?A=ProcessSMEAdd" method="post">
			<div class="form-group">
			<select name="ApplicationSMETypeUUID">
				<cfoutput query="GetSMETypes">
					<option value="#ApplicationSMETypeUUID#">#SMEType#</option>
				</cfoutput>
			</select>
			</div>
			<div class="form-group">
			<select name="ApplicationUUID">
				<cfoutput query="GetApplications">
					<option value="#ApplicationUUID#">#ApplicationName#</option>
				</cfoutput>
			</select>
			</div>
			<div class="form-group">
			<select name="PersonUUID">
				<cfoutput query="GetPeople">
					<option value="#PersonUUID#">#CN#</option>
				</cfoutput>
			</select>
			</div>
			<div class="form-group">
				<input type="submit" name="Add SME">
			</div>
		</form>
		
	</cfcase>
	<cfcase value="ProcessSMEAdd">
		<cfquery name="InsertSME" datasource="#DSN#">
			INSERT INTO [dbo].[application_smes]
				([ApplicationUUID], [PersonUUID], [ApplicationSMETypeUUID])
			VALUES ('#form.ApplicationUUID#', '#form.personUUID#', '#form.ApplicationSMETypeUUID#')
				
		</cfquery>
	</cfcase>
</cfswitch>


