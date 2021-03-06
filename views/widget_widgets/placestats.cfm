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

		<cfif c gte max>
			<cfset max = c />
		</cfif>

		<cfif c lte min>
			<cfset min = c />
		</cfif>
	</cfloop>

	<!---
		Teraz definiuje kolory dla wykresu.
	--->

	<cfloop query="my_report">

		<cfif c eq max>
			<cfset myColorList &= '##75bd4e,' />
		<cfelseif c eq min>
			<cfset myColorList &= '##eb0f0f,' />
		<cfelse>
			<cfset myColorList &= '##898989,' />
		</cfif>

	</cfloop>
</cfsilent>

<cfoutput>

	<div class="widget_container">

	<h5>Nieruchomości</h5>

	<cfchart
         format="png"
         scalefrom="0" >

	<cfchartseries
		type="bar"
		serieslabel="Dodane"
		query="my_report"
		valuecolumn="c"
		colorlist="#myColorList#"
		itemcolumn="month" >

	<cfchartseries
		type="line"
		serieslabel="Odrzucone"
		query="my_report"
		valuecolumn="r"
		itemcolumn="month" >

	</cfchartseries>

	</cfchart>

	</div>

</cfoutput>