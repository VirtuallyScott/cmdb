
	<cfinclude template="Header.cfm">
	<cfinclude template="TopMenu.cfm">
	<cfset BasePath = "/tmp">
	
	<div class="page-header">
		<h1><span class="glyphicons glyphicons-file"></span> Manage My Account</h1>
		<a href="Files.cfm?A=Upload" class="btn btn-default btn-sm">Upload New File</a>
		<a href="Files.cfm?A=ManageFiles" class="btn btn-default btn-sm">Manage My Files</a>
	</div>
	
	<cfswitch expression="#url.A#">
		<cfdefaultcase></cfdefaultcase>
		<cfcase value="Start">

		</cfcase>
		<cfcase value="Upload">
			<form action="Files.cfm?A=ProcessUpload" method="post" enctype="multipart/form-data">
				<div class="form-group">
					<label for="FileToUpload">File To Upload</label>
					<input type="file" name="FileToUpload">
				</div>
				<div class="form-group">
					<label for="Description">File Description</label>
					<input type="text" name="Description">
				</div>
				<button type="submit" class="btn btn-default">Upload File</button>
			</form>
		</cfcase>
		
		<cfcase value="ProcessUpload">
			<cffile action="UPLOAD" filefield="form.FileToUpload" destination="E:\temp" nameconflict="MAKEUNIQUE">
			<cfset sleep(5000)>
				<cfscript>
					DateLastAccessed = CreateODBCDateTime(DateConvert("Local2UTC", cffile.DateLastAccessed));
					TimeCreated = CreateODBCDateTime(DateConvert("Local2UTC", cffile.timeCreated));
					TimeLastModified = CreateODBCDateTime(DateConvert("Local2UTC", cffile.timeLastModified));
				</cfscript>
		
				<cfquery name="InsertFileRecord" datasource="#DSN#">
					INSERT INTO [dbo].[files]
						([PersonUUID], [IPNumber], [attemptedServerFile], [clientDirectory], [clientFile], [clientFileExt], [clientFileName],
							[contentSubType], [contentType], [dateLastAccessed], [fileExisted], [fileSize], [fileWasAppended], [fileWasOverwritten],
							[fileWasRenamed], [fileWasSaved], [oldFileSize], [serverDirectory], [serverFile], [serverFileExt], [serverFileName],
							[timeCreated], [timeLastModified])
					VALUES ('#session.PersonUUID#', '#cgi.remote_addr#', '#cffile.attemptedServerFile#', '#cffile.clientDirectory#', '#cffile.clientFile#', '#cffile.clientFileExt#',
						'#cffile.clientFileName#', '#cffile.contentSubType#', '#cffile.contentType#', #dateLastAccessed#,
						'#cffile.fileExisted#', '#cffile.fileSize#', '#cffile.fileWasAppended#', '#cffile.fileWasOverwritten#',
						'#cffile.fileWasRenamed#', '#cffile.fileWasSaved#', '#cffile.oldFileSize#', '#cffile.serverDirectory#',
						'#cffile.serverFile#', '#cffile.serverFileExt#', '#cffile.serverFileName#', #timeCreated#, #timeLastModified#);
					SELECT FileUUID
						FROM [dbo].[files]
					WHERE serverFile = '#cffile.serverFile#'
				</cfquery>

				<cfset FileToStream = BasePath & "\" & cffile.serverFile>
				<cffile action="READBINARY" file="#FileToStream#" variable="FileRead">
				<cfquery name="InsertFile" datasource="#DSN#">
					UPDATE [dbo].[files]
						SET FileContents = <cfqueryparam value="#FileRead#" cfsqltype="CF_SQL_BLOB">
					WHERE FileUUID = '#InsertFileRecord.FileUUID#'
				</cfquery>
		</cfcase>
		
		<cfcase value="ManageFiles">
			<cflock timeout="1" throwontimeout="No" name="GetFileLock" type="READONLY">
				<cfquery name="GetFile" datasource="#DSN#">
					SELECT StartDate, fileDescription, fileSize, clientFile, contentType, contentSubType, ClientFileExt, FileUUID
						FROM [dbo].[files]
					WHERE PersonUUID = '#session.PersonUUID#'
				</cfquery>
			</cflock>
			<table class="table table-striped table-bordered table-condensed">
				<tr>
					<td><strong>Delete</strong></td>
					<td><strong>Edit</strong></td>
					<td><strong>Date Uploaded</strong></td>
					<td><strong>File Description</strong></td>
					<td><strong>File</strong></td>
					<td><strong>File Type</strong></td>
					<td><strong>Manage Permissions</strong></td>
					<td><strong>Associate With Applications</strong></td>
				</tr>
				<cfoutput query="GetFile">

					<tr>
						<td align="center"><a href="Files.cfm?FileUUID=#FileUUID#&A=DeleteFile"><span class="halflings halflings-remove"></span></a></td>
						<td align="center"><a href="Files.cfm?FileUUID=#FileUUID#&A=EditFile"><span class="halflings halflings-edit"></span></a></td>
						<td>#DateFormat(DateConvert("UTC2Local", StartDate), session.DateMask)# - #TimeFormat(DateConvert("UTC2Local", StartDate), session.TimeMask)#</td>
						<td><cfif LEN(fileDescription) EQ 0>No Description Entered</cfif></td>
						<td><a href="Download.cfm?FileUUID=#FileUUID#">#clientFile#</a></td>
						<td>#clientFileExt#</td>
						<td><a href="Files.cfm?FileUUID=#FileUUID#&A=ManagePermissions">Permissions</a></td>
						<td><a href="Files.cfm?FileUUID=#FileUUID#&A=ManageApplicationAssociation">Applications</a></td>
					</tr>
				</cfoutput>
			</table>
		</cfcase>
	
		<cfcase value="ManagePermissions">
		
			<cfquery name="GetPermissions" datasource="#DSN#">
				SELECT RestrictFile
					FROM Files
				WHERE FileUUID = '#url.FileUUID#'
			</cfquery>
			
			<cfquery name="GetADGroups" datasource="#DSN#">
				SELECT ADGroupUUID, CN
					FROM active_directory_groups
				WHERE EndDate IS NULL
				AND ADGroupUUID NOT IN (SELECT ADGroupUUID FROM file_permissions WHERE FileUUID = '#url.FileUUID#')
				ORDER BY CN ASC
			</cfquery>
			
			<cfquery name="GetCurrentGroups" datasource="#DSN#">
				SELECT active_directory_groups.cn
				FROM     active_directory_groups INNER JOIN
				                  file_permissions ON active_directory_groups.ADGroupUUID = file_permissions.ADGroupUUID
				WHERE file_permissions.FileUUID = '#url.FileUUID#'
				ORDER BY CN ASC
			</cfquery>
			
			<form action="Files.cfm?A=ProcessAddPermission" method="post">
				<cfoutput><input type="hidden" name="FileUUID" value="#url.FileUUID#"></cfoutput>
				<select name="ActiveDirectoryGroup" size="10" multiple>
					<cfoutput query="GetADGroups">
						<option value="#ADGroupUUID#">#CN#</option>
					</cfoutput>
				</select>
				<input type="submit" value="Add AD Group Permissions">
			</form>
			
			<table class="table table-striped table-bordered table-condensed">
				<tr>
					<td></td>
				</tr>
				<cfoutput query="GetCurrentGroups">
					<tr>
						<td>#CN#</td>
					</tr>
				</cfoutput>
			</table>
			
		</cfcase>
		
		<cfcase value="ProcessAddPermission">
			<cfif ListLen(form.ActiveDirectoryGroup, ",") EQ 1>
				<cfquery name="UpdateFile" datasource="#DSN#">
					UPDATE [dbo].[files]
						SET [RestrictFile] = 1
					WHERE FileUUID = '#form.FileUUID#'
				</cfquery>
				<cfquery name="AddPermission" datasource="#DSN#">
					INSERT INTO [dbo].[file_permissions]
						([FileUUID], [ADGroupUUID])
					VALUES ('#form.FileUUID#', '#form.ActiveDirectoryGroup#')
				</cfquery>
				<cfoutput>#form.ActiveDirectoryGroup#</cfoutput>
			<cfelseif ListLen(form.ActiveDirectoryGroup, ",") GT 1>
				<cfloop index="i" list="#form.ActiveDirectoryGroup#" delimiters=",">
					<cfquery name="AddPermission" datasource="#DSN#">
						INSERT INTO [dbo].[file_permissions]
							([FileUUID], [ADGroupUUID])
						VALUES ('#form.FileUUID#', '#i#')
					</cfquery>
				</cfloop>
			<cfelse>
			
			</cfif>
		</cfcase>
		
		<cfcase value="ManageApplicationAssociation">
			<cfquery name="GetActiveApps" datasource="#DSN#">
				sp_GetAllActiveApps
			</cfquery>
			
			<cfquery name="GetApplications" datasource="#DSN#">
				SELECT applications.ApplicationName, applications.ApplicationUUID
				FROM     application_files INNER JOIN
				                  applications ON application_files.ApplicationUUID = applications.ApplicationUUID
				WHERE application_files.FileUUID = '#url.FileUUID#'
			</cfquery>
			
			<cfoutput>
			<form action="Files.cfm?A=ProcessApplicationAssociation&FileUUID=#url.FileUUID#" method="post">
			</cfoutput>
				<select name="ApplicationToAssociate">
					<cfoutput query="GetActiveApps">
						<option value="#ApplicationUUID#">#ApplicationName#</option>
					</cfoutput>
				</select>
				<input type="submit" name="Associate">
			</form>
			
			<table class="table table-striped table-bordered table-condensed">
				<tr>
					<td><strong>Remove Assocation</strong></td>
					<td><strong>Application</strong></td>
				</tr>
				<cfoutput query="GetApplications">
					<tr>
						<td><a href="Files.cfm?FileUUID=#FileUUID#&ApplicationUUID=#ApplicationUUID#&A=RemoveAssociation"><span class="halflings halflings-remove"></span></a></td>
						<td><a href="ApplicationDetails.cfm?ApplicationUUID=#ApplicationUUID#">#ApplicationName#</a></td>
					</tr>
				</cfoutput>
			</table>
		
		</cfcase>
		
		<cfcase value="ProcessApplicationAssociation">
			<cfquery name="AssociateFile" datasource="#DSN#">
				INSERT INTO [dbo].[application_files]
					([PersonUUID], [ApplicationUUID], [FileUUID])
				VALUES ('#session.PersonUUID#', '#form.ApplicationToAssociate#', '#url.FileUUID#')
			</cfquery>
		</cfcase>
		
		<cfcase value="RemoveAssociation">
			<cfquery name="RemoveAssocation" datasource="#DSN#">
				DELETE [dbo].[application_files]
					WHERE ApplicationUUID = '#url.ApplicationUUID#'
					AND FileUUID = '#url.FileUUID#'
			</cfquery>
		</cfcase>
		
		<cfcase value="DeleteFile">
			<cfquery name="AssociateCheck" datasource="#DSN#">
				SELECT COUNT(*) AS TCount
					FROM [dbo].[application_files]
				WHERE FileUUID = '#url.FileUUID#'
			</cfquery>
			
			<cfif AssociateCheck.TCount GT 0>
				ERROR! File Is Associated With An Application.
			<cfelse>
				<cfquery name="DeleteFile" datasource="#DSN#">
					DELETE Files
						WHERE FileUUID = '#url.FileUUID#'
				</cfquery>			
			</cfif>
		

		
		</cfcase>
		
		<cfcase value="EditFile">
		
		</cfcase>
	
	</cfswitch>