
	<cfinclude template="header.cfm">	
	<cfinclude template="topmenu.cfm">
	
	<div class="page-header">
		<h1><span class="glyphicon glyphicon-credit-card"></span> Payment Card Industry Management</h1>
	</div>

	<cfquery name="x" datasource="#DSN#">
		sp_Get90DayPCI
	</cfquery>
	<cfquery name="y" datasource="#DSN#">
		sp_Get60DayPCI
	</cfquery>
	<cfquery name="z" datasource="#DSN#">
		sp_Get30DayPCI
	</cfquery>
	<cfquery name="o" datasource="#DSN#">
		sp_GetOverDuePCI
	</cfquery>
	
	<a class="btn btn-default" href="pci.cfm?A=ShowAllActive" role="button"><span class="glyphicon glyphicon-search"></span> PCI Apps</a>
	<a class="btn btn-default" href="pci.cfm?A=Add" role="button"><span class="glyphicon glyphicon-plus-sign"></span> Add PCI</a>
	<a class="btn btn-danger" href="pci.cfm?A=ShowOverDue" role="button"><span class="badge"><cfoutput>#o.TCount#</cfoutput></span> <span class="glyphicon glyphicon-warning-sign"></span> Overdue</a>
	<a class="btn btn-info" href="pci.cfm?A=ShowDueIn90" role="button"><span class="badge"><cfoutput>#x.TCount#</cfoutput></span> Due in 90 Days</a>
	<a class="btn btn-warning" href="pci.cfm?A=ShowDueIn60" role="button"><span class="badge"><cfoutput>#y.TCount#</cfoutput></span> Due in 60 Days</a>
	<a class="btn btn-danger" href="pci.cfm?A=ShowDueIn30" role="button"><span class="badge"><cfoutput>#z.TCount#</cfoutput></span> Due in 30 Days</a>

	
	<cfswitch expression="#url.A#">
		<cfdefaultcase>
			<div class="alert alert-danger" role="alert" align="center"><strong>ERROR:</strong> Invalid Case Statement</div>
		</cfdefaultcase>
		<cfcase value="Start">
		
		</cfcase>
		<cfcase value="ShowAllActive">
			<cfquery name="GetAppsWithPCI" datasource="#DSN#">
				sp_GetAppsWithPCI
			</cfquery>
			<cfif GetAppsWithPCI.RecordCount GT 0>
				<table class="table table-striped table-bordered table-condensed">
					<tr>
						<th>Applications With DR</th>
					</tr>
					<tbody>
						<cfoutput query="GetAppsWithPCI">
							<tr>
								<td><a href="applicationdetails.cfm?ApplicationUUID=#ApplicationUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationName#</a></td>
							</tr>
						</cfoutput>
					</tbody>
				</table>			
			<cfelse>
			
			</cfif>

			
		</cfcase>
		<cfcase value="Add">
			<cfquery name="GetAppsNoPCI" datasource="#DSN#">
				sp_GetAppsWithoutPCI
			</cfquery>
			<div class="panel panel-default">
				<div class="panel-heading">Add PCI To An Existing Application</div>
					<div class="panel-body">
						<form action="pci.cfm?A=ProcessAdd" method="post" name="AddDR" id="AddDR" class="form-horizontal">
							<div class="form-group">
								<label for="ApplicationUUID">Application</label>
								<select name="ApplicationUUID" class="form-control">
									<option value="0"></option>
									<cfoutput query="GetAppsNoPCI">
										<option value="#ApplicationUUID#">#ApplicationName#</option>
									</cfoutput>
								</select>
							</div>
							<div class="form-group">
								<button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-plus-sign"></span> Add PCI</button>
								<button type="reset" class="btn btn-default"><span class="glyphicon glyphicon-minus-sign"></span> Reset Form</button>
							</div>
						</form>
					</div>
				</div>
		</cfcase>
		<cfcase value="ProcessAdd">
			<cfquery name="AddPCI" datasource="#DSN#">
				UPDATE applications
					SET PCI = 1
				WHERE ApplicationUUID = '#form.ApplicationUUID#';
				INSERT INTO pci_validation_date
					(ApplicationUUID, DueDate)
					VALUES ('#form.ApplicationUUID#', DATEADD(quarter,1,GetUTCDate()));
			</cfquery>
			<cfinclude template="status.cfm">
		</cfcase>
		<cfcase value="ShowOverDue">
		
		</cfcase>
		<cfcase value="ShowDueIn90">
		
		</cfcase>
		<cfcase value="ShowDueIn60">
		
		</cfcase>
		<cfcase value="ShowDueIn30">
		
		</cfcase>
	</cfswitch>
	
	
	