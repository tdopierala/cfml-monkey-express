<cfoutput>

	<div class="wrapper">
		
		<h3>Koncesje</h3>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		<cfelseif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<div class="wrapper">
			#linkTo(
				text="Wypełnij nowy wniosek",
				action="new"
			)#
		</div>
		
		<table id="concession-table" class="tables concession-table">
			<thead>
				<tr>
					<th>Nr</th>
					<th>Imie i nazwisko</th>
					<th>Nr sklepu</th>
					<!---<th>Status</th>--->
					<th>Etap</th>
					<th>Data</th>
					<th>Akcje</th>
				</tr>
			</thead>
			<tbody>
				<!---#includePartial("index")#--->
				<cfloop query="concessionproposals">
		
					<tr>
						<td>#id#</td>
						<td>#givenname#</td>
						<td>#store#</td>
						<!---<td>#status#</td>--->
						<td>#step#</td>
						<td>#DateFormat(createddate, "yyyy-mm-dd")#</td>
						<td>
							#linkTo(
								text="Podgląd",
								controller="Concessions",
								action="edit-proposal",
								key=id)#
						</td>
					</tr>
					
				</cfloop> 
			</tbody>
		</table>
		
	</div>
	
</cfoutput>