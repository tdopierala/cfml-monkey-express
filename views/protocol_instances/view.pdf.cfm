<cfset filename = "#ExpandPath('files/protocols/')##ReplaceNoCase(protocol.protocolnumber, '/', '_', 'all')#_#DateFormat(protocol.instance_created, 'dd-mm-yyyy')#.pdf" />
<cfset savefilename = "#ReplaceNoCase(protocol.protocolnumber, '/', '_', 'all')#_#DateFormat(protocol.instance_created, 'dd-mm-yyyy')#.pdf" />

<!---<cfif FileExists(filename)>--->
<cfif false>

	<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
	<cfheader name="Expires" value="#Now()#" />
	<cfcontent type="application/pdf" file="#filename#" />
	
<cfelse>

	<cfdocument format="pdf" fontEmbed="yes" pageType="A4" name="protocolpdf">
	
	<style type="text/css">
	<!--
	  @import url("stylesheets/protocolpdf.css");
	  
	  .protocolheader ul li { width: 100%; }
	  .protocolheader ul li span.name { float: left; width: 40%; }
	  .protocolheader ul li span.value { float: right; width: 55%; }
	  .clear { float: none; clear: both; }
	  
	-->
	</style>
	
		<div class="wrapper pdf">
		
		<span class="h1">Protokół rozbieżności nr <cfoutput>#protocol.protocolnumber#</cfoutput></span>
		
		<cfloop array="#myprotocol_array#" index="i" >
			
			<cfif structIsEmpty(i) >
				<cfcontinue />
			</cfif>
			
			<cfset tmp = structNew() />
			<cfset tmp = {
				groupid 		= 	i.groupid,
				instanceid 		= 	i.instanceid,
				typeid 			=	i.typeid} />
			
			<span class="h3"><cfoutput>#i.groupname#</cfoutput></span>	
				<!---
					Tutaj umieszczam wygenerowany formularz w formacie PDF.
					Pierwsze są elementy, które się nie powtarzają.
				--->
				<cfif i.repeat eq 0>
					<div class="protocolheader">
						<ul>
						<cfset toloop = i.query.1 />
						<cfloop query="toloop">
							<cfoutput><li><span class="name">#fieldname#</span> <span class="value">#fieldvalue#</span></li></cfoutput>	
						</cfloop>
						</ul>
						
						<div class="clear"></div>
					</div>
				<!---
					Te elementy są powtarzalne więc generuje je w poziomie
				--->
				<cfelse>
					<div class="protocolcontent">
					<table class="pdftables" cellspacing="0">
						<thead>
							<tr>
								<th class="bottomBorder rightBorder leftBorder topBorder">Lp.</th>
								<cfif structKeyExists(i, "query")>
									<cfset toloop1 = i.query.1 />
									<cfloop query="toloop1">
										<th class="bottomBorder rightBorder topBorder"><cfoutput>#fieldname#</cfoutput></th>
									</cfloop>
								</cfif>
							</tr>
						</thead>
						<tbody>
							<!---
								Tworzę tyle wierszy, ile jest elementów row
							--->
							<cfif structKeyExists(i, "query")>
								<cfset toloop2 = i.query />
								<cfset colspan = 0 />
								<cfset tmp = 1 />
								<cfloop collection="#toloop2#" item="j" >
									<tr>
										<td class="c leftBorder rightBorder bottomBorder"><cfoutput>#tmp#</cfoutput></td>
										<!---
											Tutaj tworzę tyle kolumn ile jest eleentów grupy.
										--->
										<cfset toloop3 = i.query[j] />
										<cfset colspan = i.query[j].recordCount />
										<cfloop query="toloop3">
											<td class="rightBorder bottomBorder">
												<cfoutput>#fieldvalue#</cfoutput>
											</td>
										</cfloop>
									</tr>
									<cfset tmp++ />
								</cfloop>
							</cfif>
						</tbody>
					</table>
					</div> <!--- end protocolcontent --->
				</cfif>

		</cfloop> 
		
		<div class="franchisor">
		PODPIS I PIECZĄTKA AJENTA
		</div>
		
		<div class="driver">
		PODPIS I PIECZĄTKA KIEROWCY
		</div>
		
		<div class="clear"></div>
		
		<div class="credits">
		Data wygenerowania dokumentu: <cfoutput>#DateFormat(Now(), "dd-mm-yyyy")# #TimeFormat(Now(), "HH:mm:ss")#</cfoutput></div>
		</div> <!--- koniec wrapper dla ca?ego widoku --->
	
	</cfdocument>
	
	<cfpdf 
	    action = "write" 
	    source = "protocolpdf" 
	    destination="#filename#"
		overwrite="yes" />
	
	<cfheader name="Content-Disposition" value="inline; filename=#savefilename#" />
	<cfheader name="Expires" value="#Now()#" />
	<cfcontent type="application/pdf" file="#filename#" />

</cfif>