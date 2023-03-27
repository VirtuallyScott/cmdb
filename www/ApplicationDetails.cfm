
<cflock timeout="1" throwontimeout="No" name="ApplicationDetailsLock" type="READONLY">

	<cfinclude template="Header.cfm">
	<cfinclude template="TopMenu.cfm">
	<cfinclude template="pchk_owner.cfm">
	
	<cfswitch expression="#url.A#">
		<cfdefaultcase></cfdefaultcase>
		<cfcase value="Start">
		
			<cfquery name="GetAppDetails" datasource="#DSN#">
				sp_GetApplicationDetailsByUUID_2
					@ApplicationUUID = '#ApplicationUUID#'
			</cfquery>

			<cfscript>
				IF (session.Tformat IS "local") {
						AppStartDate = DateConvert("UTC2Local", GetAppDetails.StartDate);
					IF (LEN(GetAppDetails.EndDate) GT 0) {
							AppEndDate = DateConvert("UTC2Local", GetAppDetails.EndDate);
						}
					}
				ELSE {
						AppStartDate = GetAppDetails.StartDate;
						IF (LEN(GetAppDetails.EndDate) GT 0) {
								AppEndDate = GetAppDetails.EndDate;
							}
					}
				IF (NOT IsDefined("AppEndDate")) {
						AppEndDate = "False";
					}
			</cfscript>
			
			<cfif GetAppDetails.PCI EQ 1>
				<cfquery name="GetPCIDueDate" datasource="#DSN#">
					sp_GetPCIDueDateByApplicationUUID
						@ApplicationUUID = '#ApplicationUUID#'
				</cfquery>
			</cfif>
			
			<cfif GetAppDetails.DR EQ 1>
				<cfquery name="GetDRDueDate" datasource="#DSN#">
					sp_GetDRDueDateByApplicationUUID
						@ApplicationUUID = '#ApplicationUUID#'
				</cfquery>
			</cfif>
			
			<cfquery name="GetProductionSite" datasource="#DSN#">
				sp_GetProductionSiteByApplicationUUID
					@ApplicationUUID = '#ApplicationUUID#'
			</cfquery>
			
			<cfquery name="GetRecoverySite" datasource="#DSN#">
				sp_GetRecoverySiteByApplicationUUID
					@ApplicationUUID = '#ApplicationUUID#'
			</cfquery>
			
			<cfquery name="GetPrimaryOwner" datasource="#DSN#">
				sp_GetPrimaryOwnerByApplicationUUID	
					@ApplicationUUID = '#ApplicationUUID#'
			</cfquery>
			
			<cfquery name="GetAlternateOwner" datasource="#DSN#">
				sp_GetAlternateOwnerByApplicationUUID
					@ApplicationUUID = '#ApplicationUUID#'
			</cfquery>
			
			<cfquery name="GetUpstreamDependencies" datasource="#DSN#">
				sp_GetUpstreamDependenciesByApplicationUUID
					@ApplicationUUID = '#ApplicationUUID#'
			</cfquery>
			
			<cfquery name="GetDownstreamDependencies" datasource="#DSN#">
				sp_GetDownstreamDependenciesByApplicationUUID
					@ApplicationUUID = '#ApplicationUUID#'
			</cfquery>
		
			<cfquery name="AppHistory" datasource="#DSN#">
				sp_GetAppHistoryCountByApplicationUUID
					@ApplicationUUID = '#ApplicationUUID#'
			</cfquery>
			
			<cfquery name="GetSMEs" datasource="#DSN#">
				SELECT application_smes.PersonUUID, persondata.cn, persondata.givenName, persondata.sn, persondata.telephoneNumber, persondata.mail, persons.sAMAccountName, application_sme_types.SMEType
				FROM     persons INNER JOIN
				                  persondata ON persons.PersonUUID = persondata.PersonUUID INNER JOIN
				                  application_sme_types INNER JOIN
				                  application_smes ON application_sme_types.ApplicationSMETypeUUID = application_smes.ApplicationSMETypeUUID ON 
				                  persons.PersonUUID = application_smes.PersonUUID AND persondata.PersonUUID = application_smes.PersonUUID
				WHERE application_smes.EndDate IS NULL
				AND application_smes.ApplicationUUID = '#ApplicationUUID#'
				ORDER BY SMEType ASC
			</cfquery>
			
			<cfquery name="GetURLs" datasource="#DSN#">
				SELECT [Link], [Note]
					FROM [dbo].[application_urls]
				WHERE [ApplicationUUID] = '#ApplicationUUID#'
				AND EndDate IS NULL
				ORDER BY Note ASC
			</cfquery>
			
			<cfquery name="GetServers" datasource="#DSN#">
				SELECT servers.serverUUID, servers.ServerName, vCenter_Servers.vCenterHostName, sites.SiteName
				FROM     application_servers INNER JOIN
				                  servers ON application_servers.ServerUUID = servers.ServerUUID INNER JOIN
				                  vCenter_Servers ON servers.vCenterUUID = vCenter_Servers.vCenterUUID INNER JOIN
				                  sites ON vCenter_Servers.SiteUUID = sites.SiteUUID
				WHERE application_servers.ApplicationUUID = '#ApplicationUUID#'
				AND application_servers.EndDate IS NULL
			</cfquery>
			
			<cfquery name="GetTechnologies" datasource="#DSN#">
				SELECT technologies.Technology
				FROM     application_technologies INNER JOIN
				                  technologies ON application_technologies.TechnologyUUID = technologies.technologyUUID
				WHERE application_technologies.EndDate IS NULL
				AND application_technologies.ApplicationUUID = '#ApplicationUUID#'
			</cfquery>
			
			<cfquery name="GetFile" datasource="#DSN#">
				SELECT files.StartDate, files.fileDescription, files.fileSize, files.clientFile, files.contentType, files.contentSubType, files.ClientFileExt, files.FileUUID
				FROM     application_files INNER JOIN
				                  files ON application_files.FileUUID = files.FileUUID
				WHERE ApplicationUUID = '#ApplicationUUID#'
				AND application_files.EndDate IS NULL
			</cfquery>
			
			<cfquery name="GetAltOwners" datasource="#DSN#">
				SELECT persondata.personUUID, persondata.cn, persondata.mail
				FROM     application_owners INNER JOIN
				                  persondata ON application_owners.PersonUUID = persondata.PersonUUID
				WHERE application_owners.ApplicationUUID = '#ApplicationUUID#'
				AND application_owners.EndDate IS NULL
				AND OwnerType = 0
			</cfquery>
			
			<cfquery name="ADGroupCheck" datasource="#DSN#">
				SELECT ADGroupUUID
					FROM application_owners
				WHERE ApplicationUUID = '#ApplicationUUID#'
				AND ADGroupUUID IS NOT NULL
				AND EndDate IS NULL
			</cfquery>
			
			<cfif ADGroupCheck.RecordCount GT 0>

				<cfscript>
					InList = "";
					for (
							LoopCounter = 1;
							LoopCounter LTE ADGroupCheck.RecordCount;
							LoopCounter = LoopCounter +1)	{
								InList = ListAppend(InList, ADGroupCheck.ADGroupUUID[LoopCounter], SC);
						}
					InList = ListQualify(InList, SSQ, SC, "ALL");
				</cfscript>
				
				<cfquery name="GetMembers" datasource="#DSN#">
					SELECT persondata.cn, persondata.PersonUUID, persondata.mail, persondata.telephoneNumber, active_directory_groups.cn AS ADCN, active_directory_groups.ADGroupUUID,
								active_directory_groups.mail AS ADGroupMail
					FROM     active_directory_members INNER JOIN
					                  persondata ON active_directory_members.PersonUUID = persondata.PersonUUID INNER JOIN
					                  active_directory_groups ON active_directory_members.ADGroupUUID = active_directory_groups.ADGroupUUID
					WHERE  (active_directory_members.ADGroupUUID IN (#PreserveSingleQuotes(InList)#)) AND (persondata.EndDate IS NULL)
					ORDER BY active_directory_groups.cn, persondata.cn
				</cfquery>
			
			</cfif>
			
			<div class="page-header">
				<h1>Application Details - <cfoutput>#GetAppDetails.ApplicationName#</cfoutput></h1>
				
				<cfif AppOwner IS "True" AND OwnerType IS "Primary">
					<cfif IsDate(AppEndDate) IS "No">
						<cfoutput>
							<cfif session.permissions[1][2] EQ 1 OR session.PersonUUID IS GetPrimaryOwner.PersonUUID>
								<a class="btn btn-primary" href="ApplicationEdit.cfm?A=ChangePrimaryOwner&ApplicationUUID=#ApplicationUUID#" role="button">Change Owner</a>
								<a class="btn btn-default" href="ApplicationEdit.cfm?A=ChangeAlternateOwner&ApplicationUUID=#ApplicationUUID#" role="button">Add / Change Alternate Owner(s)</a>
							</cfif>
							<cfif AppHistory.TCount GT 0>
								<a class="btn btn-info" href="applicationhistory.cfm?ApplicationUUID=#ApplicationUUID#" role="button">App History</a>
							</cfif>
							<a class="btn btn-default" href="Dependencies.cfm?ApplicationUUID=#ApplicationUUID#" role="button">Manage Dependencies</a>
							<a class="btn btn-default" href="ApplicationEdit.cfm?ApplicationUUID=#ApplicationUUID#" role="button"><span class="glyphicon glyphicon-pencil"></span> Edit Application</a> 
							<a class="btn btn-danger" href="DisableApplication.cfm?ApplicationUUID=#ApplicationUUID#" role="button">Disable Application</a>
						</cfoutput>
					</cfif>
				</cfif>
			</div>

			<div>
			  <!-- Nav tabs -->
				<ul class="nav nav-tabs" role="tablist">
					<li role="presentation" class="active"><a href="#home" aria-controls="home" role="tab" data-toggle="tab"><span class="halflings halflings-home"></span> Home</a></li>
					<li role="presentation"><a href="#altowners" aria-controls="profile" role="tab" data-toggle="tab"><span class="halflings halflings-user"></span> Alternate Owners</a></li>
					<li role="presentation"><a href="#smes" aria-controls="profile" role="tab" data-toggle="tab"><span class="halflings halflings-user"></span> SMEs</a></li>
					<li role="presentation"><a href="#urls" aria-controls="profile" role="tab" data-toggle="tab"><span class="halflings halflings-link"></span> URLs</a></li>
					<li role="presentation"><a href="#technologies" aria-controls="profile" role="tab" data-toggle="tab"><span class="glyphicons glyphicons-cloud"></span> Technologies</a></li>
					<li role="presentation"><a href="#assets" aria-controls="messages" role="tab" data-toggle="tab"><span class="glyphicons glyphicons-imac"></span> Deployed Assets</a></li>
					<li role="presentation"><a href="#files" aria-controls="files" role="tab" data-toggle="tab"><span class="halflings halflings-glyph-paperclip"></span> Supporting Documentation <span class="glyphicon glyphicon-option-vertical"></span> Files</a></li>
				</ul>
			
			  <!-- Tab panes -->
				<div class="tab-content">
					<div role="tabpanel" class="tab-pane active" id="home">
						<table class="table table-striped table-bordered table-condensed">
							<tbody>
								<tr>
									<td>Application Name: </td>
									<td><cfoutput>#GetAppDetails.ApplicationName#</cfoutput></td>
								</tr>
								<tr>
									<td>Wiki Link</td>
									<td>
										<cfoutput>
											<cfif LEN(GetAppDetails.WikiURL) GT 0>
												<a href="#GetAppDetails.WikiURL#" target="_blank">#GetAppDetails.WikiURL#</a>
											<cfelse>
												#HTMLNULL#
											</cfif>
										</cfoutput>
									</td>
								</tr>
								<tr>
									<td>GIT Repo</td>
									<td>
										<cfoutput>
											<cfif LEN(GetAppDetails.GITURL) GT 0>
												<a href="#GetAppDetails.GITURL#" target="_blank">#GetAppDetails.GITURL#</a>
											<cfelse>
												#HTMLNULL#
											</cfif>
										</cfoutput>
									</td>
								</tr>
								<tr>
									<td>Application Type:</td>
									<td><cfoutput><a href="ApplicationsByType.cfm?ApplicationTypeUUID=#GetAppDetails.ApplicationTypeUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #GetAppDetails.ApplicationType#</a></cfoutput></td>
								</tr>
								<tr>
									<td>Primary Application Owner: </td>
									<td><cfoutput query="GetPrimaryOwner"><a href="mailto:#mail#"><span class="glyphicon glyphicon-envelope" aria-hidden="true"></span></a> <a href="persondetails.cfm?PersonUUID=#PersonUUID#"><span class="glyphicon glyphicon-user"></span> #cn#</a></cfoutput></td>
								</tr>
								<tr>
									<td>Alternate Application Owners: </td>
									<td>
										<cfif GetAlternateOwner.RecordCount GT 0>
											<ul>
												<cfoutput query="GetAlternateOwner">
													<li><a href="mailto:#mail#"><span class="glyphicon glyphicon-envelope" aria-hidden="true"></span></a> <a href="persondetails.cfm?PersonUUID=#PersonUUID#">#cn#</a></li>
												</cfoutput>
											</ul>
										<cfelse>
											<cfoutput>
												<a href="EditApplication.cfm?ApplicationUUID=#ApplicationUUID#&A=Start&Focus=AlternateOwners"><span class="glyphicon glyphicon-plus-sign"></span> Add Alternate Owners</a>
											</cfoutput>
										</cfif>
										</td>
								</tr>
								<tr>
									<td>Company: </td>
									<td><cfoutput>#GetAppDetails.CompanyName#</cfoutput></td>
								</tr>
								<tr>
									<td>Production Site / Recovery Site: </td>
									<td>
										<cfoutput>#GetProductionSite.SiteName#</cfoutput> 
									</td>
								</tr>
								<tr>
									<td>Recovery Site: </td>
									<td>
										<cfoutput>#GetRecoverySite.SiteName#</cfoutput>
									</td>
								</tr>
								<tr>
									<td>Payment Card Industry Requirement (PCI):</td>
									<td>
										<cfif GetAppDetails.PCI EQ 0>
											<span class="glyphicon glyphicon-remove"></span> 
											<cfoutput>
												<a href="EditApplication.cfm?ApplicationUUID=#ApplicationUUID#&A=AddPCI"><span class="glyphicon glyphicon-plus-sign"></span> Add PCI Requirement</a>
											</cfoutput>
										<cfelse>
											<span class="glyphicon glyphicon-ok"></span> 
											<span class="glyphicon glyphicon-lock"></span>
											Validation Date: <cfoutput>#DateFormat(GetPCIDueDate.DueDate, session.DateMask)#</cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td>Disaster Recovery Compliance (DR):</td>
									<td>
										<cfif GetAppDetails.DR EQ 0>
											<span class="glyphicon glyphicon-remove"></span> 
											<cfoutput>
												<a href="EditApplication.cfm?ApplicationUUID=#ApplicationUUID#&A=AddDR"><span class="glyphicon glyphicon-plus-sign"></span> Add DR Requirement</a>
											</cfoutput>
										<cfelse>
											<span class="glyphicon glyphicon-ok"></span> 
											<span class="glyphicon glyphicon-fire"></span> 
											Validation Date: <cfoutput>#DateFormat(GetDRDueDate.DueDate, session.DateMask)#</cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td>Is Utility: </td>
									<td></td>
								</tr>
								<tr>
									<td>Change Priority: </td>
									<td><cfoutput>#GetAppDetails.ChangePriority#</cfoutput></td>
								</tr>
								<tr>
									<td>Date Entered: </td>
									<td><cfoutput>#DateFormat(AppStartDate, session.DateMask)#</cfoutput></td>
								</tr>
								<cfif LEN(GetAppDetails.EndDate) GT 0>
									<tr>
										<td>Date Disabled: </td>
										<td><cfoutput>#DateFormat(AppEndDate, session.DateMask)#</cfoutput></td>
									</tr>
								</cfif>
								<tr>
									<td>Description:</td>
									<td>
										<cfoutput>
											<cfif LEN(GetAppDetails.ApplicationDescription) GT 0>
												#GetAppDetails.ApplicationDescription#
											<cfelse>
												<a href="EditApplication.cfm?ApplicationUUID=#ApplicationUUID#&A=Start&Focus=Description"><span class="glyphicon glyphicon-plus-sign"></span> Add Description</a>
											</cfif>
										</cfoutput>
									</td>
								</tr>
								<tr>
									<td>Upstream Application Dependencies:</td>
									<td>
										<cfif GetUpstreamDependencies.RecordCount GT 0>
											<cfoutput><a href="dependencies.cfm?ApplicationUUID=#ApplicationUUID#">Manage Dependencies</a></cfoutput>
											<div class="list-group">
												<cfoutput query="GetUpstreamDependencies">
													<a href="applicationdetails.cfm?ApplicationUUID=#ApplicationUUID#"  class="list-group-item">
														<span class="glyphicon glyphicon-sunglasses"></span> #ApplicationName#
													</a>
												</cfoutput>
											</div>
										<cfelse>
											<cfoutput><a href="dependencies.cfm?ApplicationUUID=#ApplicationUUID#"><span class="glyphicon glyphicon-plus-sign"></span> Add Dependency</a></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td>Downstream Application Dependencies:</td>
									<td>
										<cfif GetDownstreamDependencies.RecordCount GT 0>
											<cfoutput><a href="dependencies.cfm?ApplicationUUID=#ApplicationUUID#">Manage Dependencies</a></cfoutput>
											<div class="list-group">
												<cfoutput query="GetDownstreamDependencies">
													<a href="applicationdetails.cfm?ApplicationUUID=#ApplicationUUID#" class="list-group-item">
														<span class="glyphicon glyphicon-sunglasses"></span> #ApplicationName#
													</a>
												</cfoutput>
											</div>
										<cfelse>
											<cfoutput><a href="dependencies.cfm?ApplicationUUID=#ApplicationUUID#"><span class="glyphicon glyphicon-plus-sign"></span> Add Dependency</a></cfoutput>
										</cfif>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<table>
											<thead>
												<td>Notes:</td>
											</thead>
										</table>
									</td>				
								</tr>
							</tbody>
						</table>
					</div>
					<div role="tabpanel" class="tab-pane" id="altowners">
						<table class="table table-striped table-bordered table-condensed">
							<tr>
								<td>&nbsp;</td>
								<td><strong>Users</strong></td>
							</tr>
							<tr>
								<td>Alternate Owners</td>
								<td>
									<ul>
										<cfoutput query="GetAltOwners">
											<li><a href="mailto:#mail#"><span class="halflings halflings-envelope"></span></a> <a href="PersonDetails.cfm?PersonUUID=#PersonUUID#">#cn#</a></li>
										</cfoutput>
									</ul>
								</td>
							</tr>
							<cfif IsDefined("GetMembers")>
								<tr>
									<td><strong>Active Directory Group</strong></td>
									<td><strong>Users</strong></td>
								</tr>
								<cfoutput query="GetMembers" group="ADCN">
									<tr>
										<td>
											<cfif Len(ADGroupMail) GT 0>
												<a href="mailto:#ADGroupmail#"><span class="halflings halflings-envelope"></span></a>
											<cfelse>
												<span class="halflings halflings-envelope"></span>
											</cfif>
											<a href="ViewADMembers.cfm?ADGroupUUID=#ADGroupUUID#"><span class="halflings halflings-sunglasses"></span> #ADCN#</a>
										</td>
										<td>
											<ul>
												<cfoutput>
													<li>
														<a href="mailto:#mail#"><span class="halflings halflings-envelope"></span></a>
														<a href="PersonDetails.cfm?PersonUUID=#PersonUUID#">#cn#</a>
													</li>
												</cfoutput>
											</ul>
										</td>
									</tr>
								</cfoutput>
							</cfif>
						</table>
					</div>
					<div role="tabpanel" class="tab-pane" id="smes">
						<table class="table table-striped table-bordered table-condensed">
							<tr>
								<td colspan="1"><strong>SME Type</strong></td>
								<td colspan="3"><strong>Person</strong></td>
							</tr>
							<cfoutput query="GetSMEs">
								<tr>
									<td>#SMEType#</td>
									<td><a href="persondetails.cfm?PersonUUID=#PersonUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #CN#</a></td>
									<td><a href="mailto:#mail#"><span class="glyphicon glyphicon-envelope"></span> #mail#</a></td>
									<td><span class="glyphicon glyphicon-phone-alt"></span> #telephoneNumber#</td>
								</tr>
							</cfoutput>
						</table>
					</div>
					<div role="tabpanel" class="tab-pane" id="technologies">
						<table class="table table-striped table-bordered table-condensed">
							<tr>
								<td><strong>Technology</strong></td>
							</tr>
							<cfoutput query="GetTechnologies">
								<tr>
									<td>#Technology#</td>
								</tr>
							</cfoutput>
						</table>
					</div>
					<div role="tabpanel" class="tab-pane" id="urls">
						<table class="table table-striped table-bordered table-condensed">
							<tr>
								<td><strong>URL</strong></td>
								<td><strong>Notes</strong></td>
							</tr>
							<cfoutput query="GetURLs">
								<tr>
									<td><a href="#Link#" target="_blank">#Link#</a></td>
									<td>#Note#</td>
								</tr>
							</cfoutput>
						</table>
					</div>
					<div role="tabpanel" class="tab-pane" id="assets">
						<table class="table table-striped table-bordered table-condensed">
							<tr>
								<td><strong>Server</strong></td>
								<td><strong>Site</strong></td>
								<td><strong>Virtual Center</strong></td>
							</tr>
							<cfoutput query="GetServers">
								<tr>
									<td><a href="ServerDetails.cfm?A=ViewServer&ServerUUID=#ServerUUID#">#ServerName#</a></td>
									<td>#SiteName#</td>
									<td>#VCenterHostName#</td>
								</tr>
							</cfoutput>
						</table>
					</div>
					<div role="tabpanel" class="tab-pane" id="files">
						<table class="table table-striped table-bordered table-condensed">
							<tr>
								<td><strong>Date Uploaded</strong></td>
								<td><strong>File Description</strong></td>
								<td><strong>File</strong></td>
								<td><strong>File Type</strong></td>
							</tr>
							<cfoutput query="GetFile">
								<tr>
									<td>#DateFormat(DateConvert("UTC2Local", StartDate), session.DateMask)# - #TimeFormat(DateConvert("UTC2Local", StartDate), session.TimeMask)#</td>
									<td><cfif LEN(fileDescription) EQ 0>No Description Entered</cfif></td>
									<td><a href="Download.cfm?FileUUID=#FileUUID#">#clientFile#</a></td>
									<td>#clientFileExt#</td>
								</tr>
							</cfoutput>
						</table>
					</div>
				</div>
			</div>
			

		</cfcase>
	</cfswitch>
	
</cflock>

	
