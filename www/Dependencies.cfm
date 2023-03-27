
<!---


--->

	<cfinclude template="Header.cfm">
	<cfinclude template="TopMenu.cfm">
	<cfinclude template="pchk_owner.cfm">
	
	<cfoutput>#AppOwner# - #OwnerType#</cfoutput>
	
	<cfif AppOwner IS "True" AND OwnerType IS NOT "None">
	
	<cfswitch expression="#url.A#">
		<cfcase value="Start">
			<div class="page-header">
				<h1>Manage Application Dependencies</h1>
			</div>
			<script language="Javascript">
			function SelectMoveRows(SS1,SS2)
			{
			    var SelID='';
			    var SelText='';
			    // Move rows from SS1 to SS2 from bottom to top
			    for (i=SS1.options.length - 1; i>=0; i--)
			    {
			        if (SS1.options[i].selected == true)
			        {
			            SelID=SS1.options[i].value;
			            SelText=SS1.options[i].text;
			            var newRow = new Option(SelText,SelID);
			            SS2.options[SS2.length]=newRow;
			            SS1.options[i]=null;
			        }
			    }
			    SelectSort(SS2);
			}
			function SelectSort(SelList)
			{
			    var ID='';
			    var Text='';
			    for (x=0; x < SelList.length - 1; x++)
			    {
			        for (y=x + 1; y < SelList.length; y++)
			        {
			            if (SelList[x].text > SelList[y].text)
			            {
			                // Swap rows
			                ID=SelList[x].value;
			                Text=SelList[x].text;
			                SelList[x].value=SelList[y].value;
			                SelList[x].text=SelList[y].text;
			                SelList[y].value=ID;
			                SelList[y].text=Text;
			            }
			        }
			    }
			}
			function selectAll() {
				for (i=0; i<document.Dependencies.UpStream.length; i++) { 
				 document.Dependencies.UpStream.options[i].selected = true; 
					 }
				 for (i=0; i<document.Dependencies.AllApps.length; i++) { 
				 document.Dependencies.AllApps.options[i].selected = true; 
					 }
				 for (i=0; i<document.Dependencies.DownStream.length; i++) { 
				 document.Dependencies.DownStream.options[i].selected = true; 
					 }
			} 
			</script>
			
				<cfquery name="GetUpStream" datasource="#DSN#">
					sp_GetDependenciesUpStream
						@ChildUUID = '#ApplicationUUID#'
				</cfquery>
				
				<cfquery name="GetDownStream" datasource="#DSN#">
					sp_GetDependenciesDownStream
						@ParentUUID = '#ApplicationUUID#'
				</cfquery>

				<cfscript>
					NotInList = "";
					UpStreamList = "";
					DownStreamList = "";
					UpStreamArray = ArrayNew(2);
					DownStreamArray = ArrayNew(2);
				</cfscript>
				
				<cfif GetUpStream.RecordCount GT 0>
					
					<cfloop query="GetUpStream">
						<cfset NotInList = ListAppend(NotInList, "'#GetUpStream.ApplicationUUID#'", ",")>
						<cfset UpStreamList = ListAppend(UpStreamList,  "'#GetUpStream.ApplicationUUID#'", ",")>
					</cfloop>
					
					<cfquery name="FindUpStreamDependency" datasource="#DSN#">
						SELECT Applications.ApplicationUUID, Applications.ApplicationName
						FROM     Applications INNER JOIN
						                  Dependencies ON Applications.ApplicationUUID = Dependencies.ParentUUID
						WHERE Dependencies.EndDate IS NULL
						<cfif LEN(UpStreamList) GT 1>
							AND Dependencies.ChildUUID IN (#preserveSingleQuotes(UpStreamList)#)
						<cfelse>
							AND Dependencies.ChildUUID = '#UpStreamList#'
						</cfif>
						ORDER BY ApplicationName ASC
					</cfquery>
					
					<cfoutput query="FindUpStreamDependency">
						<cfset UpStreamList = ListAppend(UpStreamList,  "'#ApplicationUUID#'", ",")>
						<cfset UpStreamArray[CurrentRow][1] = ApplicationUUID>
						<cfset UpStreamArray[CurrentRow][2] = LEFT(ApplicationName, '25')>
					</cfoutput>
					
				</cfif>
				
				<cfif GetDownStream.RecordCount GT 0>
				
					<cfloop query="GetDownStream">
						<cfset NotInList = ListAppend(NotInList, "'#GetDownStream.ApplicationUUID#'", ",")>
						<cfset DownStreamList = ListAppend(DownStreamList,  "'#GetDownStream.ApplicationUUID#'", ",")>
					</cfloop>
				
					<cfquery name="FindDownStreamDependency" datasource="#DSN#">
					<cfoutput>
						SELECT Applications.ApplicationUUID, Applications.ApplicationName
						FROM     Applications INNER JOIN
						                  Dependencies ON Applications.ApplicationUUID = Dependencies.ChildUUID
						WHERE Dependencies.EndDate IS NULL
						AND ParentUUID != '#ApplicationUUID#'
						<cfif LEN(DownStreamList) GT 1>
							AND Dependencies.ParentUUID IN (#preserveSingleQuotes(DownStreamList)#)
						<cfelse>
							AND Dependencies.ParentUUID = '#DownStreamList#'
						</cfif>
						ORDER BY ApplicationName
					</cfoutput>

					</cfquery>
					<cfoutput query="FindDownStreamDependency">
						<cfset DownStreamList = ListAppend(DownStreamList, "'#ApplicationUUID#'", ",")>
						<cfset DownStreamArray[CurrentRow][1] = ApplicationUUID>
						<cfset DownStreamArray[CurrentRow][2] = LEFT(ApplicationName, '25')>
					</cfoutput>
				</cfif>
				
			
				<cfquery name="GetApplications" datasource="#DSN#">
					SELECT ApplicationID, ApplicationUUID, ApplicationName
						FROM Applications
					WHERE ApplicationUUID != '#ApplicationUUID#'
					<cfif ListLen(UpStreamList, ",") GT 0>AND ApplicationUUID NOT IN (#preserveSingleQuotes(UpStreamList)#)</cfif>
					<cfif ListLen(DownStreamList, ",") GT 0>AND ApplicationUUID NOT IN (#preserveSingleQuotes(DownStreamList)#)</cfif>
					<cfif ListLen(NotInList, ",") GT 0>AND ApplicationUUID NOT IN (#preserveSingleQuotes(NotInList)#)</cfif>
					AND EndDate IS NULL
					ORDER BY ApplicationName ASC
				</cfquery>
				
				<cfquery name="GetAppName" datasource="#DSN#">
					SELECT ApplicationName
						FROM Applications
					WHERE ApplicationUUID = '#ApplicationUUID#'
				</cfquery>

				<form action="ProcessDependencies.cfm?ApplicationUUID=<cfoutput>#ApplicationUUID#</cfoutput>" method="post" name="Dependencies" onsubmit="selectAll();" class="form-horizonal">
					<table class="table table-striped table-bordered table-condensed">
						<tr>
							<td colspan="5" align="center"><h2>Map Dependencies For <cfoutput><a href="applicationdetails.cfm?ApplicationUUID=#url.ApplicationUUID#"> - #GetAppName.ApplicationName#</a></cfoutput></h2></td>
						</tr>
						<tr>
							<td align="center"><h4>Inherited Upstream</h4></td>
							<td align="center"><h4>Upstream Dependency</h4></td>
							<td align="center"><h4>Applications</h4></td>
							<td align="center"><h4>Downstream Dependency</h4></td>
							<td align="center"><h4>Inherited Downstream</h4></td>
						</tr>
						<tr>
							<td valign="top">
								<cfloop index="i" from="1" to="#ArrayLen(UpStreamArray)#" step="1">
									<cfoutput>
										<a href="Dependency.cfm?PID=#UpStreamArray[i][1]#">#UpStreamArray[i][2]#</a><br>
									</cfoutput>
								</cfloop>
							</td>
							<td>
								<select name="UpStream" size="20" multiple class="form-control">
									<cfif GetUpStream.RecordCount GT 0>
										<cfoutput query="GetUpStream">
											<option value="#ApplicationUUID#">#LEFT(ApplicationName, 25)#</option>
										</cfoutput>
									</cfif>
								</select>
							</td>
							<td align="center">
								<select name="AllApps" size="20" multiple class="form-control">
									<cfoutput query="GetApplications"><option value="#ApplicationUUID#">#LEFT(ApplicationName, 25)#</option></cfoutput>
								</select>
							</td>
							<td>
								<select name="DownStream" size="20" multiple class="form-control">
									<cfif GetDownStream.RecordCount GT 0>
										<cfoutput query="GetDownStream">
											<option value="#ApplicationUUID#">#LEFT(ApplicationName, 25)#</option>
										</cfoutput>
									</cfif>
								</select>
							</td>
							<td valign="top">
								<cfloop index="i" from="1" to="#ArrayLen(DownStreamArray)#" step="1">
									<cfoutput>
										<a href="Dependency.cfm?PID=#DownStreamArray[i][1]#">#DownStreamArray[i][2]#</a><br>
									</cfoutput>
								</cfloop>
						</tr>
						<tr>
							<td></td>
							<td align="center"><input type="Button" value="Return >>" onClick="SelectMoveRows(document.Dependencies.UpStream,document.Dependencies.AllApps)" class="btn btn-default"></td>
							<td align="center">
								<div class="form-group">
									
								<input type="Button" value="<< Upstream" onClick="SelectMoveRows(document.Dependencies.AllApps,document.Dependencies.UpStream)" class="btn btn-default">
								<input type="Button" value="Downstream >>" onClick="SelectMoveRows(document.Dependencies.AllApps,document.Dependencies.DownStream)" class="btn btn-default">
								</div>
							</td>
							<td align="center"><input type="Button" value="<< Return" onClick="SelectMoveRows(document.Dependencies.DownStream,document.Dependencies.AllApps)" class="btn btn-default"></td>
							<td></td>
						</tr>
						<tr>
							<td colspan="5" align="center">
								<button type="submit" class="btn btn-default"><span class="glyphicon glyphicon-plus-sign"></span> Update Depdendencies</button>
							</td>
						</tr>
					</table>
				</form>

			
		</cfcase>
	
	</cfswitch>
	
	<cfelse>
		<cfset Status = "False">
		<cfinclude template="Status.cfm">
	
	</cfif>