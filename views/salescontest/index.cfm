<cfoutput>
	<div class="wrapper salescontent"> 
		<h3>Ranking sklepów w "konkursie dla obrotnych"</h3>
		
		<table class="table table-striped table-hover"> 
			<thead>
				<tr>
					<th>##</th>
					<th>Nr sklep</th>
					<th>Miejscowość</th>
					<th>Wzrost (%)</th>
					<th>#DateFormat(DateAdd('d', -1, params.date),"mm-dd")#</th>
					<th>#DateFormat(DateAdd('d', -2, params.date),"mm-dd")#</th>
					<th>#DateFormat(DateAdd('d', -3, params.date),"mm-dd")#</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				#includePartial("index")#
			</tbody>
		</table>
		
		<ul class="pagination">
			<li><a href="##">&laquo;</a></li>
			
			<cfloop index="idx" from="7" to="1" step="-1">
				
				<cfset link =  URLFor(action='index') & "&date=" & DateAdd("d", -(idx), Now()) />
				<cfif idx eq 1>
					<li class="active"><a href="##">#DateFormat(DateAdd("d", -(idx), Now()), "mm.dd")#</a></li>
				<cfelse>
					<li><a href="#link#" data-date="#DateAdd("d", -(idx), Now())#">#DateFormat(DateAdd("d", -(idx), Now()), "mm.dd")#</a></li>
				</cfif>
				
			</cfloop>
			
			<cfif DateDiff("d", params.date, Now()) gte 0>
				<li class="disabled"><a href="##">&raquo;</a></li>
			<cfelse>
				<li><a href="##">&raquo;</a></li>
			</cfif>
			
		</ul>

	</div>
</cfoutput>

<cfif StructKeyExists(params, "debug") and params.debug eq 'true'>
	<cfdump var="#salesreport#" />
</cfif>
