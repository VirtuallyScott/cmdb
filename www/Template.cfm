<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Untitled</title>
</head>

<body>


<cfswitch expression="#url.A#">
	<cfdefaultcase></cfdefaultcase>
	<cfcase value="Start">
	
	</cfcase>
	<cfcase value="ProcessImport">
		<cfscript>
			thisPath = expandpath("*.*");
			thisDirectory = GetDirectoryFromPath(thisPath);
		</cfscript>
		
		<cfdirectory action="LIST" directory="#thisDirectory#" name="GetTemplates" filter="*.cfm" sort="FileName ASC">
		
		<cfoutput query="GetTemplates">
			<cfquery name="DupCheck" datasource="#DSN#">
				SELECT COUNT(*) AS TCount
					FROM dbo.templates
				WHERE Template = '#Name#'
			</cfquery>
			<cfif DupCheck.TCount GT 0>
			
			<cfelse>
				<cfquery name="AddTemplate" datasource="#DSN#">
					INSERT INTO templates
						(Template)
					VALUES('#name#')
				</cfquery>
			</cfif>
		</cfoutput>				


	</cfcase>
	
	<cfcase value="blah">
	
		<cfquery name="GetPersonUUID" datasource="#DSN#">
			sp_GetAllActivePersonUUID
		</cfquery>
		<cfloop query="GetPersonUUID">
			<cfquery name="GetTemplateUUID" datasource="#DSN#">
				sp_GetAllActiveTemplatesUUID
			</cfquery>
			<cfloop query="GetTemplateUUID">
				<cfquery name="InsertTemplatePerm" datasource="#DSN#">
					INSERT INTO template_permissions
						(TemplateUUID, PersonUUID)
					VALUES('#GetTemplateUUID.TemplateUUID#', '#GetPersonUUID.PersonUUID#')
				</cfquery>
			</cfloop>
		</cfloop>
		
	</cfcase>
	
	
</cfswitch>



</body>
</html>
