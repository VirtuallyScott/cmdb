
	<cfinclude template="header.cfm">	
	<cfinclude template="topmenu.cfm">
	
	<cflock timeout="1" throwontimeout="No" name="MyAccount" type="READONLY">
		<cfquery name="GetAppCountMyAccount" datasource="#DSN#">
			sp_GetActiveAppCountByPersonUUID
				@PersonUUID = '#session.PersonUUID#'
		</cfquery>
		<cfquery name="GetInActiveAppCountMyAccount" datasource="#DSN#">
			sp_GetInActiveAppCountByPersonUUID
				@PersonUUID = '#session.PersonUUID#'
		</cfquery>

	<cfquery name="GetApprovalCount" datasource="#DSN#">
		SELECT COUNT(*) AS TCount
			FROM [dbo].[approve_application_owner_change]
		WHERE [NewOwnerPersonUUID] = '#session.PersonUUID#'
	</cfquery>
		
	<div class="page-header">
		<h1>Manage My Account</h1>
		<cfif GetApprovalCount.TCount GT 0>
			<a href="Approvals.cfm?A=MyApprovals" class="btn btn-success btn-sm">My Approvals</a>
		</cfif>
		<cfif GetAppCountMyAccount.TCount GT 0>
			<cfoutput><a href="Applications.cfm?A=ByOwner" class="btn btn-default btn-sm">My Applications</a> </cfoutput>
		</cfif>
		<a href="NewApplication.cfm" class="btn btn-default btn-sm">Add New Application</a>
		<cfif session.PeopleLeader IS "True">
			<a href="People.cfm?A=ShowMyDirectReports" class="btn btn-default btn-sm">My Direct Reports</a>
		</cfif>
		<a href="MyAccount.cfm" class="btn btn-default btn-sm">My Account</a> 
		<a href="MyAccount.cfm?A=ViewPermissions" class="btn btn-default btn-sm">My Permissions</a> 
		<a href="MyAccount.cfm?A=APIKey" class="btn btn-default btn-sm">API Keys</a>
		<a href="Files.cfm" class="btn btn-default btn-sm">Upload | Manage Files</a>
		<a href="MyAccount.cfm?A=ViewADGroups" class="btn btn-default btn-sm">View AD Memberships</a>
	</div>

		<cfswitch expression="#url.A#">
				
			<!--- IF A USER ENDS UP HERE SOMETHING WENT WRONG --->
			<cfdefaultcase></cfdefaultcase>
			
			<!--- CASE OF START IS DEFINED AS DEFAULT IN APPLICATION.CFM --->
			<cfcase value="Start">
				<cfquery name="GetTimeMasks" datasource="#DSN#">
					sp_GetTimeMasks
				</cfquery>
				<cfquery name="GetDateMasks" datasource="#DSN#">
					sp_GetDateMasks
				</cfquery>
				<cflock timeout="1" throwontimeout="No" name="GetCurrentBKLock" type="READONLY">
					<cfquery name="GetCurrentBK" datasource="#DSN#">
						sp_GetBK
							@PersonUUID = '#session.PersonUUID#'
					</cfquery>
				</cflock>
				<form action="myAccount.cfm?A=ProcessEdit" method="post">
					<div class="form-group">
						<label for="DateMask">Date Mask</label>
						<select name="DateMask" class="form-control">
							<cfoutput query="GetDateMasks">
								<option value="#DateMask#"<cfif DateMask IS GetCurrentBK.DateMask> selected</cfif>>#DateMaskExample#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label for="TimeMask">Time Mask</label>
						<select name="TimeMask" class="form-control">
							<cfoutput query="GetTimeMasks">
								<option value="#TimeMask#"<cfif TimeMask IS GetCurrentBK.TimeMask> selected</cfif>>#TimeMaskExample#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label for="TFormat">Time Format</label>
						<select name="TFormat" class="form-control">
							<cfoutput>
								<option value="Local"<cfif GetCurrentBK.TFormat IS "Local"> selected</cfif>>Local</option>
								<option value="UTC"<cfif GetCurrentBK.Tformat IS "UTC"> selected</cfif>>UTC</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<label for="RRP">Number Of Records Per Page</label>
						<select name="RPP" class="form-control">
							<cfloop index="i" from="20" to="200" step="20">
								<cfoutput>
									<option value="#i#"<cfif GetCurrentBK.RPP EQ i> selected</cfif>>#i#</option>								
								</cfoutput>
							</cfloop>
						</select>
					</div>
					<div class="form-group">
						<button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-plus-sign"></span> Update Account</button>
						<button type="reset" class="btn btn-default"><span class="glyphicon glyphicon-minus-sign"></span> Reset Form</button>
					</div>
				</form>

<div class="panel-body">				
			</cfcase>
			
			<!--- PROCESS EDIT TO BK OPTIONS --->
			<cfcase value="ProcessEdit">
				<cflock timeout="1" throwontimeout="No" name="UpdateBKLock" type="READONLY">
					<cfquery name="UpdateBK" datasource="#DSN#">
						UPDATE bk
							SET DateMask = '#form.DateMask#',
								  TimeMask = '#form.TimeMask#',
								  TFormat = '#form.TFormat#',
								  RPP = '#form.RPP#'
						WHERE PersonUUID = '#session.PersonUUID#'
					</cfquery>
				</cflock>
				<cflock timeout="1" throwontimeout="No" name="BKSetLock" type="EXCLUSIVE">
					<cfscript>
						session.DateMask = form.Datemask;
						session.TimeMask = form.TimeMask;
						session.TFormat = form.TFormat;
						session.RPP = form.RPP;
					</cfscript>
				</cflock>
				<cfinclude template="status.cfm">
			</cfcase>
			
			<!--- VIEW PERMISSIONS --->
			<cfcase value="ViewPermissions">
					<cfquery name="GetPermissions" datasource="#DSN#">
						sp_GetPermissionsByPersonUUID
							@PersonUUID = '#session.PersonUUID#'
					</cfquery>
					
					<table class="table table-striped table-bordered table-condensed">
						<tr>
							<td><strong>Permission Type</strong></td>
							<td><strong>Your Rights</strong></td>
						</tr>
						<cfoutput query="GetPermissions">
							<cfloop index="i" list="#ColumnList#" delimiters=",">
								<tr>
									<td>#RePlace(i, "_", " ", "All")#</td>
									<td>#Evaluate(i)#</td>
								</tr>
							</cfloop>
						</cfoutput>
					</table>
			</cfcase>
			
			<!--- FUTURE API REQUEST AND KEY MANAGEMENT --->
			<cfcase value="APIKey">
				<cfquery name="GetAPIKey" datasource="#DSN#">
					SELECT APIConsumerUUID, StartDate, EndDate, PublicKey, Notes, LastUpdate
						FROM [dbo].[api_consumers]
					WHERE PersonUUID = '#session.PersonUUID#'
					ORDER BY StartDate
				</cfquery>
<pre>
API Keys have a standard expiration date of two years after the date requested, they can be manually revoked or re-newed at any time.
For help and examples on consuming the API, see <a href="./REST/help.cfm" target="_blank"><span class="glyphicon glyphicon-question-sign"></span> API Help</a>.
</pre>
				<cfif GetAPIKey.RecordCount GT 0>
					<table class="table table-bordered table-condensed">
						<tr>
							<td><strong>Date Requested :</strong></td>
							<td><strong>Expiration Date :</strong></td>
							<td><strong>Key :</strong></td>
							<td><strong>Notes :</strong></td>
							<td><strong>Manage</strong></td>
						</tr>
						<cfoutput query="GetAPIKey">
							<cfif DateCompare(DateConvert("UTC2Local",EndDate), Now(), "d") EQ 1>
								<tr class="success">
							<cfelse>
								<tr class="warning">
							</cfif>
								<td>#DateFormat(StartDate, session.DateMask)#</td>
								<td>#DateFormat(EndDate, session.DateMask)#</td>
								<td>
								<cfif DateCompare(DateConvert("UTC2Local",EndDate), Now(), "d") EQ 1>
									<button id="#PublicKey#" type="button" class="btn btn-success btn-sm" onclick="copyToClipboard(document.getElementById('#PublicKey#').innerHTML)">#PublicKey#</button>
								<cfelse>
									#PublicKey#
								</cfif>
								</td>
								<td>#Notes#</td>
								<td>
									<cfif DateCompare(DateConvert("UTC2Local",EndDate), Now(), "d") EQ 1>
									<a href="MyAccount.cfm?A=DisableAPIKey&PublicKey=#APIConsumerUUID#&RedirectURL=" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-minus-sign"></span>  Disable API Key</a>
									</cfif>
									<a href="MyAccount.cfm?A=ExtendAPIKey&PublicKey=#APIConsumerUUID#" class="btn btn-default btn-sm"><span class="glyphicon glyphicon-plus-sign"></span>  Extend API Key</a>
								</td>
							</tr>
						</cfoutput>
						<tr>
							<td colspan="5" align="center">
								<form action="MyAccount.cfm?A=RequestAPIKey" method="post" class="form-horizontal">
									<div class="form-group">
										<label for="APIKeyNotes" class="col-sm-2 control-label">Notes For API Key</label>
										<div class="col-sm-10">
											<input type="text" name="APIKeyNotes" id="APIKeyNotes" class="form-control" placeholder="Application Name...">
										</div>
										<div class="col-sm-offset-2 col-sm-10">
											<button type="submit" class="btn btn-default"><span class="halflings halflings-plus-sign"></span> Create New API Key</button>
										</div>
									</div>
								</form>
							</td>
						</tr>
					</table>

					<script>
					  function copyToClipboard(text) {
					    window.prompt("Copy to clipboard: Ctrl+C, Enter", text);
					  }
					</script>
				<cfelse>
					<a href="MyAccount.cfm?A=RequestAPIKey" class="btn btn-default btn-sm">Request API Key</a>
				</cfif>
			
			</cfcase>
			
			<cfcase value="RequestAPIKey">
				<cfquery name="GetAPIKey" datasource="#DSN#">
					INSERT INTO
						[dbo].[api_consumers]
					(PersonUUID, EndDate, Notes)
					VALUES('#session.PersonUUID#', DATEADD(year,2,GetUTCDate()), '#form.APIKeyNotes#')
				</cfquery>
				<cfinclude template="status.cfm">
			</cfcase>
		
			<cfcase value="DisableAPIKey">
				<cfquery name="DisableAPIKey" datasource="#DSN#">
					UPDATE [dbo].[api_consumers]
						SET EndDate = (getUTCDate()),
							LastUpdate = (getUTCDate())
					WHERE APIConsumerUUID = '#url.PublicKey#'
				</cfquery>
				<cfinclude template="status.cfm">
			</cfcase>
		
			<cfcase value="ExtendAPIKey">
				<cfquery name="UpdateAPIKey" datasource="#DSN#">
					UPDATE [dbo].[api_consumers]
						SET EndDate = DATEADD(year,2,GetUTCDate()),
							LastUpdate = (getUTCDate())
					WHERE APIConsumerUUID = '#url.PublicKey#'
				</cfquery>
				<cfinclude template="status.cfm">
			</cfcase>
			
			<cfcase value="ViewADGroups">
				<cfquery name="GetADMembership" datasource="#DSN#">
					SELECT active_directory_groups.SamAccountName, active_directory_groups.ADGroupUUID
					FROM     active_directory_groups INNER JOIN
					                  active_directory_members ON active_directory_groups.ADGroupUUID = active_directory_members.ADGroupUUID
					WHERE active_directory_members.PersonUUID = '#session.PersonUUID#'
					ORDER BY SamAccountName ASC
				</cfquery>
				<table class="table table-bordered table-condensed table-striped">
					<tr>
						<td><strong>View Other Members</strong></td>
						<td><strong>Active Directory Group</strong></td>
					</tr>
					<cfoutput query="GetADMembership">
						<tr>
							<td><a href="ViewADMembers.cfm?ADGroupUUID=#ADGroupUUID#">View Other Members</a></td>
							<td>#SamAccountName#</td>
						</tr>
					</cfoutput>
				</table>
				
				
			</cfcase>
		</cfswitch>
		
	</cflock>
</div>
