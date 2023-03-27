
	<cfinclude template="header.cfm">	
	<cfinclude template="topmenu.cfm">

	<div class="page-header">
		<h1>Welcome!</h1>
		<a href="NewApplication.cfm" class="btn btn-default"><strong>Add Application</strong></a>
		<a href="Applications.cfm" class="btn btn-default"><strong>View Applications</strong></a>
		<a href="MyAccount.cfm" class="btn btn-default"><strong>Manage My Account</strong></a>
		<a href="Users.cfm" class="btn btn-default"><strong>View Users</strong></a>
	</div>
	
	<div class="panel panel-danger">
		<div class="panel-heading">
			<h3 class="panel-title"><span class="halflings halflings-alert"></span> <strong>Items Needing Attention!</strong></h3>
		</div>
		<div class="panel-body">
<pre>
Pending Approvals Here
PCI Expiration Alerts Here
DR Expiration Alerts Here
</pre>			
		</div>
	</div>
	
	<div class="panel panel-default">
		<div class="panel-heading">
			<h3 class="panel-title">Panel title</h3>
		</div>
		<div class="panel-body">
			Panel content
		</div>
	</div>