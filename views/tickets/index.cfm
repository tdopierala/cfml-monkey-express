<cfoutput>

	<div class="wrapper">
	
		<h3>Lista zgłoszonych błędów w systemie</h3>
	
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>
		
		<table class="tables" id="ticketsTable">
			<thead>
				<tr>
					<th class="c">Lp.</th>
					<th>Nazwa</th>
					<th>Opis</th>
					<th class="c">Dodano</th>
				</tr>
			</thead>
			<tbody>
				<cfset index = 1>
				<cfloop query="tickets">
				
					<tr>
						<td class="c">#index#</td>
						<td>#ticketname#</td>
						<td>#ticketdescription#</td>
						<td class="c">#DateFormat(ticketcreated, "dd/mm/yy")#</td>
					</tr>
				
				<cfset index++>
				</cfloop>
			</tbody>
		</table>
		
	</div>

</cfoutput>

<cfdump var="#tickets#">