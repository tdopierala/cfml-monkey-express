<!---<h1>ARGUMENRS</h1>
<cfdump var="#arguments#" />
	
<h1>URL</h1>
<cfdump var="#url#" />
	
<h1>REQUEST</h1>
<cfif isDefined("Request")>
	<cfdump var="#Request#" />
</cfif>--->
	
<!---<h1>CFCATCH</h1>
<cfdump var="#cfcatch#" />--->
	
<h1>SESSION.USER</h1>
<cfdump var="#session.user#" showUDFs="true" />
<cfdump var="#statuses#">

<cfloop index="idx" from="1" to="#ArrayLen(emails)#">
		
	<cfif ArrayIsDefined(emails, idx) and not ArrayIsEmpty(emails[idx])>
		<cfoutput>
        	<p>Witaj #users[idx].name#, <br />
			poniżej widnieje zestawienie zmian w indeksach z dnia #DateFormat(DateAdd('d', -1, Now()),'dd-mm-yyyy')#</p>
				<table border="0" cellpading="0" cellspacing="0">
					<thead>
						<tr>
							<th colspan="1">Zmiany w indeksach</th>
						</tr>
					</thead>
					<tbody>
						<cfloop array="#emails[idx]#" index="x">
							<tr>
								<td>
									#linkTo(
										text=x.message,
										host="intranet.monkey.xyz",
										controller="products",
										action="view",
										key=x.indexid,
										onlyPath=false)#
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			
        </cfoutput>
	</cfif>
		
</cfloop>
<cfabort>