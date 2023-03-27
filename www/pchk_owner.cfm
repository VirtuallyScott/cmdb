
<cflock timeout="1" throwontimeout="No" name="pchk_owner" type="READONLY">

<!---
	
	Template = /pchk_owner.cfm (Permission Check Owner)
	Include Template Anywhere You Want To Check For Primary Or Alternate Application OwnerShip.
	If Person Is An Owner By Primary, Alternate Or Active Directory Group Membership Set AppOwner = True
	
	Set Error of 0. If Error Is 1 In Any Processing Throw An Error.
	Set Default Value For AppOwner As False. If AppOwner IS "False" Do Not Display Edit Menus.
	Set ApplicationUUID Of NULL. Check For ApplicationUUID Passed In Via URL Or Form And Set
		ApplicationUUID based on form.ApplicationUUID or url.ApplicationUUID
	If No form or url ApplicationUUID Passed In Set Error To 1
	
	Inputs;
			url.ApplicationUUID				Only One ApplicationUUID Input Is Required (url or form)
			form.ApplicationUUID		
			session.PersonUUID			Inherited
	
	Output;
			AppOwner 		VALUES [True,False]
			OwnerType		VALUES [Primary, Alternate, None]
--->

<cfscript>
	Error = 0;
	ApplicationUUID = "";
	AppOwner = "False";
	OwnerType = "None";
	IF (IsDefined("url.ApplicationUUID")) {
			ApplicationUUID = url.ApplicationUUID;
		}
	IF (IsDefined("form.ApplicationUUID")) {
			ApplicationUUID = form.ApplicationUUID;
		}
	IF (LEN(ApplicationUUID) EQ 0) {
			Error = 1;
		}
</cfscript>

<cfif Error EQ 1>

	<cfthrow message="Error!" type="Error" detail="No ApplicationUUID Provided">

</cfif>

<!--- Check To See If Current User Is Primary Owner --->
<cfquery name="PrimaryOwnerCheck" datasource="#DSN#">
	SELECT COUNT(*) AS TCount
		FROM application_owners
	WHERE ApplicationUUID = '#ApplicationUUID#'
	AND PersonUUID = '#session.PersonUUID#'
	AND EndDate IS NULL
	AND OwnerType = 1
</cfquery>

<!--- If Owner Is Primary Set AppOwner TRUE --->
<cfif PrimaryOwnerCheck.TCount EQ 1>
	<cfset AppOwner = "True">
	<cfset OwnerType = "Primary">
	
<!--- If For Some Reason PersonUUID Comes Back More Than Once Throw Error --->
<cfelseif PrimaryOwnerCheck.TCount GT 1>
	<cfthrow message="Error!" detail="More Than One Primary Owner Returned">
	
<!--- If Primary Owner Comes Back As 0 RecordCount Check For Alternate Ownership --->
<cfelse>
	<cfquery name="AlternateOwnerCheck" datasource="#DSN#">
		SELECT COUNT(*) AS TCount
			FROM application_owners
		WHERE ApplicationUUID = '#ApplicationUUID#'
		AND PersonUUID = '#session.PersonUUID#'
		AND EndDate IS NULL
		AND OwnerType = 0
	</cfquery>

<!--- If Owner Is Alternate Set AppOwner True ---->
	<cfif AlternateOwnerCheck.TCount EQ 1>
		<cfset AppOwner = "True">
		<cfset OwnerType = "Alternate">

<!--- If For Some Reason PersonUUID Comes Back More Than Once Throw Error --->
	<cfelseif AlternateOwnerCheck.TCount GT 1>
		<cfthrow message="Error!" detail="More Than One Alternate Owner Returned">
		
<!--- If Primary And Alternate Owners Come Back As 0 Check For ADGroup AS Owner --->
	<cfelse>
		
		<cfquery name="ADOwnershipCheck" datasource="#DSN#">
			SELECT ADGroupUUID
				FROM application_owners
			WHERE ApplicationUUID = '#ApplicationUUID#'
			AND EndDate IS NULL
			AND ADGroupUUID IS NOT NULL
		</cfquery>
		
		<cfif ADOwnershipCheck.RecordCount EQ 0>
			<cfset AppOwner = "False">
			<cfset OwnerType = "None">

<!--- If Only A Single ADGroupUUID Is Returned Query For Current User Membership --->
		<cfelseif ADOwnershipCheck.RecordCount EQ 1>
			<cfquery name="ADMembershipCheck" datasource="#DSN#">
				SELECT COUNT(*) AS TCount
					FROM [dbo].[active_directory_members]
				WHERE ADGroupUUID = '#ADOwnershipCheck.ADGroupUUID#'
				AND PersonUUID = '#session.PersonUUID#'
				AND EndDate IS NULL
			</cfquery>
			
<!--- If AD Group Membership Returns A Valid Record Set AppOwner True --->
			<cfif ADMembershipCheck.TCount EQ 1>
				<cfset AppOwner = "True">
				<cfset OwnerType = "Alternate">
<!--- If AD Group Membership Returns No Valid Record Set AppOwner False --->
			<cfelse>
				<cfset AppOwner = "False">
				<cfset OwnerType = "None">
			</cfif>			
			
			
<!--- If More Than one ADGroupUUID Is Returned Query For Current User Membership --->
		<cfelse>
			<cfscript>
				InList = "";
				for (
						LoopCounter = 1;
						LoopCounter LTE ADOwnershipCheck.RecordCount;
						LoopCounter = LoopCounter +1)	{
							InList = ListAppend(InList, ADOwnershipCheck.ADGroupUUID[LoopCounter], SC);
					}
				InList = ListQualify(InList, SSQ, SC, "ALL");
			</cfscript>
		
			<cfquery name="ADMembershipCheck" datasource="#DSN#">
				SELECT COUNT(*) AS TCount
					FROM [dbo].[active_directory_members]
				WHERE PersonUUID = '#session.PersonUUID#'
				AND ADGroupUUID IN (#PreserveSingleQuotes(InList)#)
				AND EndDate IS NULL
			</cfquery>
			
<!--- If AD Group Membership Returns A Valid Record Set AppOwner True --->
			<cfif ADMembershipCheck.TCount EQ 1>
				<cfset AppOwner = "True">
				<cfset OwnerType = "Alternate">
<!--- If AD Group Membership Returns No Valid Record Set AppOwner False --->
			<cfelse>
				<cfset AppOwner = "False">
				<cfset OwnerType = "None">
			</cfif>		
			
		</cfif>
		
	</cfif>
	
</cfif>

</cflock>
