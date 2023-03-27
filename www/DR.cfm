
	<cfinclude template="header.cfm">	
	<cfinclude template="topmenu.cfm">
	
	<div class="page-header">
		<h1><span class="glyphicon glyphicon-fire"></span> Disaster Recovery Management</h1>
	</div>

	<cfquery name="x" datasource="#DSN#">
		sp_Get90DayDR
	</cfquery>
	<cfquery name="y" datasource="#DSN#">
		sp_Get60DayDR
	</cfquery>
	<cfquery name="z" datasource="#DSN#">
		sp_Get30DayDR
	</cfquery>
	<cfquery name="o" datasource="#DSN#">
		sp_GetOverDueDR
	</cfquery>
	
	<a class="btn btn-default" href="dr.cfm?A=ShowAllActive" role="button"><span class="glyphicon glyphicon-search"></span> DR Apps</a>
	<a class="btn btn-default" href="dr.cfm?A=Add" role="button"><span class="glyphicon glyphicon-plus-sign"></span> Add DR</a>
	<a class="btn btn-danger" href="dr.cfm?A=ShowOverDue" role="button"><span class="badge"><cfoutput>#o.TCount#</cfoutput></span> <span class="glyphicon glyphicon-warning-sign"></span> Overdue</a>
	<a class="btn btn-info" href="dr.cfm?A=ShowDueIn90" role="button"><span class="badge"><cfoutput>#x.TCount#</cfoutput></span> Due in 90 Days</a>
	<a class="btn btn-warning" href="dr.cfm?A=ShowDueIn60" role="button"><span class="badge"><cfoutput>#y.TCount#</cfoutput></span> Due in 60 Days</a>
	<a class="btn btn-danger" href="dr.cfm?A=ShowDueIn30" role="button"><span class="badge"><cfoutput>#z.TCount#</cfoutput></span> Due in 30 Days</a>
	
	<cfswitch expression="#url.A#">
		<cfdefaultcase>
			<div class="alert alert-danger" role="alert" align="center"><strong>ERROR:</strong> Invalid Case Statement</div>
		</cfdefaultcase>
		<cfcase value="Start">
		
		</cfcase>
		<cfcase value="ShowAllActive">
			<cfquery name="GetAppsWithDR" datasource="#DSN#">
				sp_GetAppsWithDR
			</cfquery>
			<cfif GetAppsWithDR.RecordCount GT 0>
				<table class="table table-striped table-bordered table-condensed">
					<tr>
						<th>Applications With DR</th>
					</tr>
					<tbody>
						<cfoutput query="GetAppsWithDR">
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
			<cfquery name="GetAppsNoDR" datasource="#DSN#">
				sp_GetAppsWithoutDR
			</cfquery>
			<div class="panel panel-default">
				<div class="panel-heading">Add DR To An Existing Application</div>
					<div class="panel-body">
						<form action="dr.cfm?A=ProcessAdd" method="post" name="AddDR" id="AddDR" class="form-horizontal">
							<div class="form-group">
								<label for="ApplicationUUID">Application</label>
								<select name="ApplicationUUID" class="form-control">
									<option value="0"></option>
									<cfoutput query="GetAppsNoDR">
										<option value="#ApplicationUUID#">#ApplicationName#</option>
									</cfoutput>
								</select>
							</div>
							<div class="form-group">
								<button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-plus-sign"></span> Add DR</button>
								<button type="reset" class="btn btn-default"><span class="glyphicon glyphicon-minus-sign"></span> Reset Form</button>
							</div>
						</form>
					</div>
				</div>
		</cfcase>
		<cfcase value="ProcessAdd">
			<cfquery name="AddDR" datasource="#DSN#">
				UPDATE applications
					SET DR = 1
				WHERE ApplicationUUID = '#form.ApplicationUUID#';
				INSERT INTO dr_validation_date
					(ApplicationUUID, DueDate)
					VALUES ('#form.ApplicationUUID#', DATEADD(quarter,1,GetUTCDate()));
			</cfquery>
			<cfinclude template="status.cfm">
		</cfcase>
		<cfcase value="ShowOverDue">
			<cfquery name="GetApps" datasource="#DSN#">
				SELECT applications.ApplicationName, applications.ApplicationUUID
				FROM     applications INNER JOIN
				                  dr_validation_date ON applications.ApplicationUUID = dr_validation_date.ApplicationUUID
				WHERE DueDate <= (getUTCDate())
			</cfquery>
				<table class="table table-striped table-bordered table-condensed">
					<tr>
						<th>Applications With DR Due in 60-90 Days</th>
					</tr>
					<tbody>
						<cfoutput query="GetApps">
							<tr>
								<td><a href="applicationdetails.cfm?ApplicationUUID=#ApplicationUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationName#</a></td>
							</tr>
						</cfoutput>
					</tbody>
				</table>	
		</cfcase>
		<cfcase value="ShowDueIn90">
			<cfquery name="GetApps" datasource="#DSN#">
				SELECT applications.ApplicationName, applications.ApplicationUUID
				FROM     applications INNER JOIN
				                  dr_validation_date ON applications.ApplicationUUID = dr_validation_date.ApplicationUUID
				WHERE DueDate BETWEEN (getUTCDate()) AND (DATEADD(day,90,getUTCDate()))
			</cfquery>
				<table class="table table-striped table-bordered table-condensed">
					<tr>
						<th>Applications With DR Due in 60-90 Days</th>
					</tr>
					<tbody>
						<cfoutput query="GetApps">
							<tr>
								<td><a href="applicationdetails.cfm?ApplicationUUID=#ApplicationUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationName#</a></td>
							</tr>
						</cfoutput>
					</tbody>
				</table>	
		</cfcase>
		<cfcase value="ShowDueIn60">
			<cfquery name="GetApps" datasource="#DSN#">
				SELECT applications.ApplicationName, applications.ApplicationUUID
				FROM     applications INNER JOIN
				                  dr_validation_date ON applications.ApplicationUUID = dr_validation_date.ApplicationUUID
				WHERE DueDate BETWEEN (getUTCDate()) AND (DATEADD(day,60,getUTCDate()))
			</cfquery>
				<table class="table table-striped table-bordered table-condensed">
					<tr>
						<th>Applications With DR Due in 30-60 Days</th>
					</tr>
					<tbody>
						<cfoutput query="GetApps">
							<tr>
								<td><a href="applicationdetails.cfm?ApplicationUUID=#ApplicationUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationName#</a></td>
							</tr>
						</cfoutput>
					</tbody>
				</table>	
		</cfcase>
		<cfcase value="ShowDueIn30">
			<cfquery name="GetApps" datasource="#DSN#">
				SELECT applications.ApplicationName, applications.ApplicationUUID
				FROM     applications INNER JOIN
				                  dr_validation_date ON applications.ApplicationUUID = dr_validation_date.ApplicationUUID
				WHERE DueDate BETWEEN (getUTCDate()) AND (DATEADD(day,30,getUTCDate()))
			</cfquery>
				<table class="table table-striped table-bordered table-condensed">
					<tr>
						<th>Applications With DR Due in 30-60 Days</th>
					</tr>
					<tbody>
						<cfoutput query="GetApps">
							<tr>
								<td><a href="applicationdetails.cfm?ApplicationUUID=#ApplicationUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationName#</a></td>
							</tr>
						</cfoutput>
					</tbody>
				</table>	
		</cfcase>
	</cfswitch>
	