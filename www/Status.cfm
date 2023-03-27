

<cfscript>
	IF (NOT IsDefined("Status")) {
			Status = "";	
		}
	IF (IsDefined("form.RedirectURL")) {
			StatusRedirect = form.RedirectURL;
		}
	ELSE IF (IsDefined("url.RedirectURL")) {
			StatusRedirect = url.RedirectURL;
		}
	ELSE {
			StatusRedirect = "/";
		}
</cfscript>

<cfif Status IS "True">
	<div class="alert alert-success" role="alert" align="center"><strong>Updating Database. Redirecting In 3 Seconds...</strong></div>
	<cfoutput><META http-equiv="refresh" content="3;URL=#StatusRedirect#"></cfoutput>	
<cfelse>
	<div class="alert alert-danger" role="alert" align="center"><strong>You Do Not Have Permissions For The Attempted Action...</strong></div>
	<cfoutput><META http-equiv="refresh" content="2;URL=#StatusRedirect#"></cfoutput>	
</cfif>


