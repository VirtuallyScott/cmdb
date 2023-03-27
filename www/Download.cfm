<cfquery name="PermCheck" datasource="#DSN#">
	SELECT RestrictFile
		FROM [dbo].[files]
	WHERE FileUUID = '#url.FileUUID#'
</cfquery>
<cfif PermCheck.RestrictFile EQ 1>
	<cfquery name="ADGroupCheck" datasource="#DSN#">
		SELECT COUNT(*)
			FROM file_permissions
		WHERE ADGroupUUID IN (SELECT ADGroupUUID FROM active_directory_members WHERE PersonUUID = '#session.PersonUUID#')
	</cfquery>
<cfelse>

</cfif>
<cfquery name="GetFile" datasource="#DSN#">
	SELECT [StartDate], [fileSize], [clientFile], [clientFileExt], [contentType], [contentSubType], [fileContents]
		FROM [dbo].[files]
	WHERE FileUUID = '#url.FileUUID#'
</cfquery>
<cfset Sleep(2000)>
<cffile action="WRITE" file="E:\temp\#url.FileUUID#.#GetFile.clientFileExt#" output="#GetFile.fileContents#" addnewline="Yes">
<cfheader name="Content-Disposition" value="attachment; filename=#GetFile.clientFile#">
<cfcontent type="#GetFile.ContentType#/#GetFile.ContentSubType#" file="E:\temp\#url.FileUUID#.#GetFile.clientFileExt#" deletefile="Yes">