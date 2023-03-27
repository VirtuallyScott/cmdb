
	<cfinclude template="Header.cfm">
	<cfinclude template="TopMenu.cfm">
	
	<cfswitch expression="#url.A#">
		<cfdefaultcase></cfdefaultcase>
		<cfcase value="Start">
			<cfquery name="GetADGroupMembers" datasource="#DSN#">
				SELECT active_directory_groups.SamAccountName, persondata.PersonUUID, persondata.cn
				FROM     active_directory_groups INNER JOIN
				                  active_directory_members ON active_directory_groups.ADGroupUUID = active_directory_members.ADGroupUUID INNER JOIN
				                  persondata ON active_directory_members.PersonUUID = persondata.PersonUUID
				WHERE active_directory_groups.ADGroupUUID = '#url.ADGroupUUID#'
				ORDER BY persondata.cn ASC
			</cfquery>
			
			<table class="table table-bordered table-condensed table-striped">
				<tr>
					<td>User</td>
				</tr>
				<cfoutput query="GetADGroupMembers">
					<tr>
						<td><a href="PersonDetails.cfm?PersonUUID=#PersonUUID#">#CN#</a></td>
					</tr>
				</cfoutput>
			</table>
			
		</cfcase>
	</cfswitch>