
	<cfinclude template="header.cfm">
	<cfinclude template="topmenu.cfm">
	
	<div class="page-header">
		<h1>Manage People</h1>
	</div>

	<cfswitch expression="#url.A#">
		<cfdefaultcase></cfdefaultcase>
		<cfcase value="ImportPeople">
		
		</cfcase>
		<cfcase value="ImportPeopleStep2">
		
		</cfcase>
		<cfcase value="ImportPeopleStep3">
		
		</cfcase>
		<cfcase value="ShowActivePeople">
			<cfquery name="GetActivePersons" datasource="#DSN#">
				SELECT persondata.cn, persondata.sn, persondata.givenname, persons.PersonUUID, persondata.company
				FROM     persons INNER JOIN
				                  persondata ON persons.PersonUUID = persondata.PersonUUID
				WHERE persons.EndDate IS NULL
				ORDER BY persondata.sn ASC
			</cfquery>
			
		<cflock timeout="1" throwontimeout="No" name="RPPRead" type="READONLY">
			<cfscript>
				RPP = session.RPP;
				TotalPages = Ceiling(GetActivePersons.RecordCount/RPP);
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
			
			<table class="table table-striped table-bordered table-condensed">
				<tr>
					<td colspan="2" align="center">
						<strong>Users By First Letter Of Lastname</strong>
						<nav>
							<ul class="pagination">
								<cfloop index="strLetter" list="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z" delimiters=",">
									<cfoutput><li><a href="">#strLetter#</a></li></cfoutput>
								</cfloop>
							</ul>
						</nav>
						
						<nav>
							<ul class="pagination">
								<li>
									<a href="?A=ShowActivePeople&P=1"><span class="glyphicon glyphicon-fast-backward"></span></a>
								</li>
								<li<cfif url.P EQ 1> class="disabled"</cfif>>
									<cfoutput>
										<a href="?A=ShowActivePeople&P=#OldP#" aria-label="Previous">
											<span class="glyphicon glyphicon-backward"></span>
										</a>
									</cfoutput>
								</li>
								<cfloop index="i" from="#PageStart#" to="#PageStop#" step="1">
									<cfoutput>
										<li<cfif i EQ url.P> class="active"</cfif>><a href="?A=ShowActivePeople&P=#i#">#i#</a></li>			
									</cfoutput>
								</cfloop>
								<li>
									<a href="" aria-label="Next">
										<span class="glyphicon glyphicon-forward"></span>
									</a>
								</li>
								<li>
									<a href="?A=ShowActivePeople&P=<cfoutput>#TotalPages#</cfoutput>"><span class="glyphicon glyphicon-fast-forward"></span></a>
								</li>
							</ul>
						</nav>
					</td>
				</tr>
				<tr>
					<th>User</th>
					<th>Company</th>
				</tr>
				<cfoutput query="GetActivePersons" startrow="#QStart#" maxrows="#RPP#">
					<tr>
						<td><a href="persondetails.cfm?PersonUUID=#PersonUUID#">#sn#, #givenname#</a></td>
						<td>#company#</td>
					</tr>
				</cfoutput>
			</table>
		</cfcase>
		<cfcase value="ManageTemplatePermissions">
			<cfquery name="GetTemplatePermissions" datasource="#DSN#">
				SELECT persondata.cn, persondata.givenName, persondata.sn, template_permissions.Permission, template_permissions.TemplatePermissionUUID, templates.TemplateUUID, 
				                  templates.Template
				FROM     persondata INNER JOIN
				                  persons ON persondata.PersonUUID = persons.PersonUUID INNER JOIN
				                  template_permissions ON persons.PersonUUID = template_permissions.PersonUUID INNER JOIN
				                  templates ON template_permissions.TemplateUUID = templates.TemplateUUID
			</cfquery>
		</cfcase>
		<cfcase value="ShowMyDirectReports">
			<cfscript>
				IF (IsDefined("url.OverRide")) {
						ManagerUUID = url.OverRide;
					}
				ELSE {
						ManagerUUID = session.PersonUUID;
					}
			</cfscript>
			<cfquery name="GetDirectReports" datasource="#DSN#">
				SELECT sn, cn, givenName, PersonUUID
					FROM     persondata
				WHERE ManagerPersonUUID = '#ManagerUUID#'
				ORDER BY SN ASC
			</cfquery>
			
			<table class="table table-striped table-bordered table-condensed">
				<tr>
					<td>User</td>
				</tr>
				<cfoutput query="GetDirectReports">
					<tr>
						<td><a href="PersonDetails.cfm?PersonUUID=#PersonUUID#"><cfif sn IS ""><cfelse>#sn#, #givenname#</cfif></a></td>
					</tr>
				</cfoutput>
			</table>
		</cfcase>
	</cfswitch>