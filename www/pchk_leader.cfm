
<cflock timeout="1" throwontimeout="No" name="pchk_leader" type="READONLY">
	<cfscript>
		Error = 0;
		IF (session.PeopleLeader EQ 0) {
				Error = 1;
				ErrorText = "You Are Not A People Leader Per Active Directory";
			}
		IF (IsDefined("url.PersonUUID")) {
				SubPersonUUID = url.PersonUUID;
			}
		IF (IsDefined("form.PersonUUID")) {
				SubPersonUUID = form.PersonUUID;
			}
		IF (LEN(SubPersonUUID EQ 0)) {
				Error = 1;
				ErrorText = "No Direct Report PersonUUID Passed In";
			}
	</cfscript>

</cflock>