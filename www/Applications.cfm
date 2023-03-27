
<cfinclude template="header.cfm">
<cfinclude template="topmenu.cfm">

<cfswitch expression="#url.A#">
	<cfcase value="Start">
		<cfquery name="GetAllActiveApps" datasource="#DSN#">
			sp_GetAllActiveApps
		</cfquery>
	</cfcase>
	<cfcase value="ByOwner">
		<cfscript>
			IF (IsDefined("url.PersonUUID")) {
					OwnerUUID = url.PersonUUID;
				}
			ELSE {
					OwnerUUID = session.PersonUUID;
				}
		</cfscript>
		<!---
			!! come back here and add logic to show disabled based on url variable
		--->
		<cfquery name="GetAllActiveApps" datasource="#DSN#">
			sp_GetApplicationsByOwnerUUID
				@PersonUUID = '#OwnerUUID#'
		</cfquery>
		<cfquery name="GetAllInActiveApps" datasource="#DSN#">
			sp_GetInActiveApplicationsByOwnerUUID
				@PersonUUID = '#OwnerUUID#'
		</cfquery>
	</cfcase>
	<cfcase value="ByProductionSite">
		<cfquery name="GetAllActiveApps" datasource="#DSN#">
			sp_GetAppsByProductionSite
				@ProductionSiteUUID = '#url.ProductionSiteUUID#'
		</cfquery>
	</cfcase>
</cfswitch>

	<div class="page-header">
        <h1>Applications</h1>
     </div>

<cflock timeout="1" throwontimeout="No" name="RPPRead" type="READONLY">
	<cfscript>
		RPP = session.RPP;
		TotalPages = Ceiling(GetAllActiveApps.RecordCount/RPP);
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

	<cfif GetAllActiveApps.RecordCount EQ 0 AND GetAllInActiveApps.RecordCount EQ 0>
		<div class="alert alert-danger" role="warning" align="center"><strong>No Results Found...</strong></div>
	<cfelse>
      <table class="table table-bordered table-condensed">
	  	<cfif GetAllActiveApps.RecordCount LT session.RPP>

		<cfelse>
		  	<tr>
				<td colspan="4" align="center">
					<nav>
						<ul class="pagination">
							<li>
								<a href="?P=1"><span class="glyphicon glyphicon-fast-backward"></span></a>
							</li>
							<li<cfif url.P EQ 1> class="disabled"</cfif>>
								<cfoutput>
									<a href="?P=#OldP#" aria-label="Previous">
										<span class="glyphicon glyphicon-backward"></span>
									</a>
								</cfoutput>
							</li>
							<cfloop index="i" from="#PageStart#" to="#PageStop#" step="1">
								<cfoutput>
									<li<cfif i EQ url.P> class="active"</cfif>><a href="?P=#i#">#i#</a></li>
								</cfoutput>
							</cfloop>
							<li>
								<a href="" aria-label="Next">
									<span class="glyphicon glyphicon-forward"></span>
								</a>
							</li>
							<li>
								<a href="?P=<cfoutput>#TotalPages#</cfoutput>"><span class="glyphicon glyphicon-fast-forward"></span></a>
							</li>
						</ul>
					</nav>
				</td>
			</tr>
		</cfif>

          <tr>
            <th>Application <a href=""><span class="glyphicon glyphicon-triangle-bottom"></span></a> <a href=""><span class="glyphicon glyphicon-triangle-top"></span></a></th>
            <th>Type <a href=""><span class="glyphicon glyphicon-triangle-bottom"></span></a> <a href=""><span class="glyphicon glyphicon-triangle-top"></span></a></th>
            <th>Owner <a href=""><span class="glyphicon glyphicon-triangle-bottom"></span></a> <a href=""><span class="glyphicon glyphicon-triangle-top"></span></a></th>
			<th>Company <a href=""><span class="glyphicon glyphicon-triangle-bottom"></span></a> <a href=""><span class="glyphicon glyphicon-triangle-top"></span></a></th>
          </tr>
			<tr class="success">
				<td colspan="4" align="center"><strong>Active Applications</strong></td>
			</tr>
		<cfoutput query="GetAllActiveApps" startrow="#QStart#" maxrows="#RPP#">
			<tr class="success">
				<td><a href="applicationdetails.cfm?ApplicationUUID=#ApplicationUUID#"><span class="glyphicon glyphicon-sunglasses"></span>#LEFT(ApplicationName, "25")#</a></td>
				<td><a href="ApplicationsByType.cfm?ApplicationTypeUUID=#ApplicationTypeUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationType#</a></td>
				<td><a href="persondetails.cfm?PersonUUID=#PersonUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #cn#</a></td>
				<td>#CompanyName#</td>
			</tr>
		</cfoutput>
		<cfif IsDefined("GetAllInActiveApps")>
				<tr class="danger">
					<td colspan="4" align="center"><strong>Disabled Applications</strong></td>
				</tr>
			<cfoutput query="GetAllInActiveApps" startrow="#QStart#" maxrows="#RPP#">
				<tr class="danger">
					<td><a href="applicationdetails.cfm?ApplicationUUID=#ApplicationUUID#"><span class="glyphicon glyphicon-sunglasses"></span>#LEFT(ApplicationName, "25")#</a></td>
					<td><a href="ApplicationsByType.cfm?ApplicationTypeUUID=#ApplicationTypeUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #ApplicationType#</a></td>
					<td><a href="persondetails.cfm?PersonUUID=#PersonUUID#"><span class="glyphicon glyphicon-sunglasses"></span> #cn#</a></td>
					<td>#CompanyName#</td>
				</tr>
			</cfoutput>
		</cfif>

      </table>
	</cfif>



