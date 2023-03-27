    <!-- Fixed navbar -->
	
	<cfquery name="GetTotalApps" datasource="#DSN#">
		sp_GetTotalAppCount
	</cfquery>
	<cflock timeout="1" throwontimeout="No" name="TopMenuLock" type="READONLY">
		<cfquery name="GetAppCount" datasource="#DSN#">
			sp_GetActiveAppCountByPersonUUID
				@PersonUUID = '#session.PersonUUID#'
		</cfquery>
		<cfquery name="GetApprovalCount" datasource="#DSN#">
			SELECT COUNT(*) AS TCount
				FROM [dbo].[approve_application_owner_change]
			WHERE [NewOwnerPersonUUID] = '#session.PersonUUID#'
		</cfquery>
	
    <nav class="navbar navbar-inverse navbar-fixed-top">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="/">
		  	Application Owners
		  </a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav">
            <li<cfif cgi.script_name IS "/Index.cfm"> class="active"</cfif>><a href="/"><span class="glyphicon glyphicon-home"></span></a></li>
			<li><a href="http://#baseURL#/RSS/" target="_blank"><span class="social social-rss"></span></a></li>
			<cfif GetApprovalCount.TCount GT 0>
				<li<cfif cgi.script_name IS "/Approvals.cfm"> class="active"</cfif>><a href="Approvals.cfm?A=MyApprovals"><span class="glyphicon glyphicon-alert"></span></a></li>
			</cfif>
			<li<cfif cgi.script_name IS "/NewApplication.cfm"> class="active"</cfif>><a href="NewApplication.cfm"><span class="glyphicon glyphicon-plus-sign"></span> Add Application</a></li>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicons glyphicons-cogwheel"></span> My Account <span class="caret"></span></a>
              <ul class="dropdown-menu">
				<li><a href="myAccount.cfm"><span class="glyphicon glyphicon-pencil"></span> Manage My Account</a></li>
				<cfif GetAppCount.TCount GT 0>
				<li><a href="Applications.cfm?A=ByOwner"><span class="badge"><cfoutput>#GetAppCount.TCount#</cfoutput></span> Manage My Applications</a></li>
				</cfif>
				<li><a href="Files.cfm"><span class="glyphicons glyphicons-file"></span> Manage Files</a></li>
				<li><a href="MyAccount.cfm?A=APIKey"><span class="halflings halflings-glyph-lock"></span> Manage API Keys</a></li>
				<li><a href="/Login/LogOut.cfm"><span class="glyphicon glyphicon-log-out"></span> Log Out</a></li>
			  </ul>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-folder-open"></span>  Manage <span class="caret"></span></a>
              <ul class="dropdown-menu">
                <li><a href="applications.cfm"><span class="badge"><cfoutput>#GetTotalApps.TCount#</cfoutput></span> View All Applications</a></li>
				<li><a href="filter.cfm"><span class="glyphicon glyphicon-filter"></span> Filter Applications</a></li>
	                <li role="separator" class="divider"></li>
	                <li class="dropdown-header">Administration</li>
						<cfif session.PeopleLeader IS "True">
							<li><a href="People.cfm?A=ShowMyDirectReports"><span class="glyphicon glyphicon-user"></span> My Direct Reports</a></li>
						</cfif>
						<li><a href="People.cfm"><span class="glyphicon glyphicon-user"></span> People Management</a></li>					
		                <li><a href="NewApplication.cfm"><span class="glyphicon glyphicon-plus-sign"></span> Add Application</a></li>
						<cfif session.Permissions[1][2] EQ 1>
							<li><a href="ManageApplicationTypes.cfm?A=AddNewType"><span class="glyphicon glyphicon-plus-sign"></span> Add Application Type</a></li>
						</cfif>
					<li role="separator" class="divider"></li>
						<li><a href="ManageApplications.cfm"><span class="glyphicon glyphicon-pencil"></span> Manage Applications</a></li>
						<cfif session.Permissions[1][2] EQ 1>
							<li><a href="ManageApplicationtypes.cfm"><span class="glyphicon glyphicon-pencil"></span> Manage Application Types</a></li>
						</cfif>
					<cfif session.Permissions[1][2] EQ 1>
					<li role="separator" class="divider"></li>
					<li class="dropdown-header">Regulatory Compliance</li>
						<li><a href="DR.cfm"><span class="glyphicon glyphicon-fire"></span> Disaster Recovery</a></li>
						<li><a href="PCI.cfm"><span class="glyphicon glyphicon-credit-card"></span> PCI Data</a></li>	
					</cfif>			
					<cfif session.Permissions[1][2] EQ 1>
						<li role="separator" class="divider"></li>
							<li class="dropdown-header">Misc Administration</li>
								<li><a href="Sites.cfm"><span class="glyphicon glyphicon-globe"></span> Manage Sites</a></li>
								<li><a href="Companies.cfm"><span class="glyphicon glyphicon-duplicate"></span> Manage Companies</a></li>
						<li role="separator" class="divider"></li>
							<li class="dropdown-header"><span class="glyphicon glyphicon-book"></span> Active Directory Management</li>
								<li><a href="admin_ActiveDirectory.cfm?A=ChaoSettings"><span class="glyphicon glyphicon-cog"></span> Active Directory Settings</a></li>
								<li><a href="admin_ActiveDirectory.cfm?A=GroupManager"><span class="glyphicon glyphicon-user"></span> Active Directory Groups</a></li>
					</cfif>
              </ul>
            </li>
            <li class="dropdown">
              <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-question-sign"></span> Help<span class="caret"></span></a>
              <ul class="dropdown-menu">
				<li><a href="AboutHelp.cfm"><span class="glyphicon glyphicon-question-sign"></span> Help <span class="glyphicon glyphicon-option-vertical"></span> Help</a></li>
				<li><a href="mailto:scott_smith@.com"><span class="glyphicon glyphicon-envelope"></span> Contact</a></li>
				<li><a href="/Login/LogOut.cfm"><span class="halflings halflings-log-out"></span> Logout</a></li>
			  </ul>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
</cflock>

    <div class="container theme-showcase" role="main">
		<div class="row">
			<div class="panel panel-default">
				<div class="panel-body">
						<a href="/"><img src="./images/Corp/Choice.png"></a>
						<form action="Filter.cfm?A=FromNavBar" method="post" class="navbar-right">
							<input type="text" name="SearchCriteria" class="form-control" placeholder="Search...">
						</form>
						<div class="panel-body">