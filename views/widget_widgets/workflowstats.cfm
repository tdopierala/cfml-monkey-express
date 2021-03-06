<cfsilent>
	<cfparam
		name="max"
		default=0 />
		
	<cfparam
		name="min"
		default=999999 />
		
	<cfparam
		name="myColorList"
		default="" />
	
	<cfloop query="my_report">
		
		<cfif count gte max>
			<cfset max = count />
		</cfif>
		
		<cfif count lte min>
			<cfset min = count />
		</cfif>
	</cfloop>	
	
	<!---
		Teraz definiuje kolory dla wykresu.
	--->
	
	<cfloop query="my_report">
				
		<cfif count eq max>
			<cfset myColorList &= '##75bd4e,' />
		<cfelseif count eq min>
			<cfset myColorList &= '##eb0f0f,' />
		<cfelse>
			<cfset myColorList &= '##cccccc,' />
		</cfif>
		
	</cfloop>
</cfsilent>

<cfoutput>
	
	<div class="widget_container">
		
	<h5>Obieg dokumentów</h5>
		
	<cfchart
         format="png"
         scalefrom="0" >
		 	 
	<cfchartseries
		type="bar"
		serieslabel="Obieg dokumentów"
		colorlist="#myColorList#"
		query="my_report"
		valuecolumn="count">
		
	</cfchartseries>
	
	</cfchart>
	
	</div>
	
</cfoutput>