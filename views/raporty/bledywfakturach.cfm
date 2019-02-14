<cfsilent>
	<cfset pastDate = DateAdd("m", -12, Now()) />
</cfsilent>


<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Błędy w fakturach</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfchart format="png" scalefrom="0" scaleto="50" chartwidth="925" chartheight="320">
				<cfset licznik = 0 />
				<cfloop condition="licznik LESS THAN OR EQUAL TO 12" >
						
						<cfquery name="elementy" dbtype="query">
							select * from bledy
							where y = #Year(pastDate)# and m = #Month(pastDate)#
						</cfquery>
						
						<cfif elementy.RecordCount GT 0>
							<cfchartseries type="bar" serieslabel="Rok: #Year(pastDate)# Miesiąc: #Month(pastDate)#">
							<cfloop query="elementy">
								<cfchartdata item="#givenname# #sn#" value="#ilosc#">
							</cfloop>
							</cfchartseries>
							
						</cfif>

					<cfset pastDate = DateAdd("m", 1, pastDate) />
					<cfset licznik++ />
				</cfloop>
			</cfchart>

			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
</cfdiv>