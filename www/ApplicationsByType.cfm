
	<cfinclude template="header.cfm">
	<cfinclude template="topmenu.cfm">
	
	<cfquery name="GetApplicationsByServiceType" datasource="#DSN#">
		sp_GetAppsByAppType
			@ApplicationTypeUUID = '#url.ApplicationTypeUUID#'
	</cfquery>
	
	<cfquery name="GetApplicationTypeName" datasource="#DSN#">
		SELECT ApplicationType
			FROM application_types
		WHERE ApplicationTypeUUID = '#url.ApplicationTypeUUID#'
	</cfquery>

<cflock timeout="1" throwontimeout="No" name="RPPRead" type="READONLY">
	<cfscript>
		RPP = session.RPP;
		TotalPages = Ceiling(GetApplicationsByServiceType.RecordCount/RPP);
		IF (url.P GT 1) {
				QStart = ((url.P * RPP)  - RPP);
				QStop = QStart + RPP;
			}
		ELSE {
				QStart = 1;
				Qstop = RPP;		
			}
		PageStart = url.P;
		PageStop = url.P + 4;
		IF (PageStop GT TotalPages) {
				PageStop = TotalPages;
				PageStart = PageStop - 4;
			IF (PageStart LT 0) {
					PageStart = 1
				}
			}
		IF (url.P GTE 2) {
				OldP = url.P - 1;
			}
		ELSE {
				OldP = 1;
			}
	</cfscript>
</cflock>
	
	<div class="page-header">
		<h1>Applications By Type - <small><cfoutput>#GetApplicationTypeName.ApplicationType#</cfoutput></small></h1>
	</div>
	
		<table class="table table-striped table-bordered table-condensed">
			<tr>
				<td colspan="3" align="center">
					<nav>
						<ul class="pagination">
							<li>
								<a href="?P=1&ApplicationTypeUUID=<cfoutput>#url.ApplicationTypeUUID#</cfoutput>"><span class="glyphicon glyphicon-fast-backward"></span></a>
							</li>
							<li<cfif url.P EQ 1> class="disabled"</cfif>>
								<cfoutput>
									<a href="?P=#OldP#&ApplicationTypeUUID=#url.ApplicationTypeUUID#" aria-label="Previous">
										<span class="glyphicon glyphicon-backward"></span>
									</a>
								</cfoutput>
							</li>
							<cfloop index="i" from="#PageStart#" to="#PageStop#" step="1">
								<cfoutput>
									<li<cfif i EQ url.P> class="active"</cfif>><a href="?P=#i#&ApplicationTypeUUID=#url.ApplicationTypeUUID#">#i#</a></li>			
								</cfoutput>
							</cfloop>
							<li>
								<a href="" aria-label="Next">
									<span class="glyphicon glyphicon-forward"></span>
								</a>
							</li>
							<li>
								<a href="?P=<cfoutput>#TotalPages#&ApplicationTypeUUID=#url.ApplicationTypeUUID#</cfoutput>"><span class="glyphicon glyphicon-fast-forward"></span></a>
							</li>
						</ul>
					</nav>
				</td>
			</tr>
			<tr>
				<th>Application</th>
				<th>Owner</th>
				<th>Company</th>
			</tr>
			<cfoutput query="GetApplicationsByServiceType" startrow="#QStart#" maxrows="#RPP#">
				<tr>
					<td><a href="applicationdetails.cfm?ApplicationUUID=#ApplicationUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationName#</a></td>
					<td><a href="mailto:#mail#"><span class="glyphicon glyphicon-envelope" aria-hidden="true"></span></a> <a href="persondetails.cfm?PersonUUID=#PersonUUID#"><span class="glyphicon glyphicon-user"></span> #cn#</a></td>
					<td>#CompanyName#</td>
				</tr>
			</cfoutput>
		</table>
		
