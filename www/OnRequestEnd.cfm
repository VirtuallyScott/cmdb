
<!---
	OnRequestEnd.cfm Is Processed At The End Of Each Page Request And
	Appended To The End. Do Not Display If The Page Is A Login Script.
	
	Close The DIVs
	Load BootStrap JavaScripts
--->

<cfif CurrentTemplate IS NOT "Login.cfm" AND CurrentTemplate IS NOT "ProcessLogin.cfm" AND CurrentTemplate IS NOT "LogOut.cfm">

								     <div class="well">
								        <p>
											Application Owner Database : For Internal Use Only &copy; <cfoutput>#DateFormat(Now(), "YYYY")#</cfoutput><br>
											Logged In As: <cfoutput><a href="myAccount.cfm">#session.cn#</a></cfoutput> 
											<span class="glyphicon glyphicon-option-vertical"></span> 
											<a href="/Login/LogOut.cfm"><span class="glyphicon glyphicon-log-out"></span> Log Out</a> 
											<span class="glyphicon glyphicon-option-vertical"></span> 
											<a href="Impersonate.cfm"><span class="halflings halflings-user"></span></a> 
											<span class="glyphicon glyphicon-option-vertical"></span> 
											<a href="Impersonate.cfm?A=EnableMegaDump"><span class="glyphicons glyphicons-circle-info"></span></a>
											<br>
										</p>
									</div>
								</div>
					      </div>		
					</div>
				</div>
			</div>
		  
	    <!-- Bootstrap core JavaScript
	    ================================================== -->
	    <!-- Placed at the end of the document so the pages load faster -->
	    <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	    <script src="./js/bootstrap.min.js"></script>
	    <script src="./js/docs.min.js"></script>
	    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
	    <script src="./js/ie10-viewport-bug-workaround.js"></script>
		  
		</body>
	</html>

	<cfif IsDefined("session.MegaDump") AND session.MegaDump IS "True">
		<cf_megadump>
		<cfoutput>#megadump#</cfoutput>	
	</cfif>
	
</cfif>
