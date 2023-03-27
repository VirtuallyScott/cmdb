<cfprocessingdirective suppresswhitespace="Yes">
<cfsetting enablecfoutputonly="Yes" showdebugoutput="No">
<cfparam name="url.A" type="string" default="ViewApps">
<cfscript>
	Error = 0;
	LoopCounter = 1;
	DSN = "";
	BaseURL = "";
	BR = XMLFormat("<br>");
</cfscript>
</cfprocessingdirective>