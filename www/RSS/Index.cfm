<cfprocessingdirective suppresswhitespace="Yes">
		<cfquery name="GetAllActiveApplications" datasource="dev_chao">
			SELECT applications.ApplicationUUID, applications.ApplicationName, applications.ApplicationDescription, persondata.cn, persondata.givenName, persondata.sn, persondata.mail, 
			                  persondata.telephoneNumber, application_types.ApplicationType
			FROM     applications INNER JOIN
			                  application_owners ON applications.ApplicationUUID = application_owners.ApplicationUUID INNER JOIN
			                  persondata ON application_owners.PersonUUID = persondata.PersonUUID INNER JOIN
			                  application_types ON applications.ApplicationTypeUUID = application_types.ApplicationTypeUUID
			WHERE  (applications.EndDate IS NULL)
			ORDER BY applications.ApplicationName
		</cfquery>
		<cfsavecontent variable="ToOutPut">
<cfoutput>
<rss version="2.0">
<channel>
	<title>Application Owner Data</title>
	<link>#BaseURL#</link>
	<description>Application Owner CMDB</description>
	<image>
		<url>http://</url>
		<title></title>
		<link>../index.cfm</link>
	</image>
	<copyright>Application Owner Database : For Internal Use Only #DateFormat(Now(), "YYYY")#</copyright>
	<ttl>60</ttl>
	<skipDays>
		<day>Saturday</day>
		<day>Sunday</day>
	</skipDays>
	<pubDate>#DateConvert("Local2UTC", Now())#</pubDate>
	<skipHours>
		<hour>0</hour>
		<hour>1</hour>
		<hour>2</hour>
		<hour>3</hour>
		<hour>4</hour>
		<hour>5</hour>
		<hour>6</hour>
		<hour>18</hour>
		<hour>19</hour>
		<hour>20</hour>
		<hour>21</hour>
		<hour>22</hour>
		<hour>23</hour>
	</skipHours>
</cfoutput>
<cfoutput query="GetAllActiveApplications">
<cfset FormattedEmail = XMLFormat(mail)>
	<item>
		<title>#XMLFormat(ApplicationName)#</title>
		<link>#XMLFormat(baseURL)#ApplicationDetails.cfm?ApplicationUUID=#XMLFormat(ApplicationUUID)#</link>
		<guid>#XMLFormat(ApplicationUUID)#</guid>
		<description>
			Application Description - #XMLFormat(ApplicationDescription)# #BR#
			Application Type - #XMLFormat(ApplicationType)# #BR#
			Application Owner - #XMLFormat(cn)# #BR#
			#XMLFormat("<a href=""mailto:")##FormattedEmail##XMLFormat(""">")##FormattedEmail##XMLFormat("</a>")# #BR#

		</description>
		<comments></comments>
	</item>
</cfoutput>
<cfoutput>
</channel>
</rss>
</cfoutput>
		</cfsavecontent>
<cfoutput><cfheader name="Content-Type" value="text/xml"><?xml version="1.0" encoding="UTF-8"?>#ToOutPut#</cfoutput>
</cfprocessingdirective>
