<cfoutput>
	
	<tr>
		<td class="first">&nbsp;</td>
		<td class="admin_submenu_options">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="c">SKLEP</th>
						<th class="c">AJENT</th>
						<th class="c">DATA DODANIA</th>
						<th class="c">RODZAJ PROTOKOŁU</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="my_protocols">
						<tr>
							<td>#login#</td>
							<td>#givenname#</td>
							<td>#date#</td>
							<td>#typename#</td>
							<td>
								#linkTo(
									text="<span>pobierz pdf</span>",
									controller="Protocol_instances",
									action="view",
									key=protocolid,
									params="typeid=#typeid#&format=pdf",
									class="pdf")#
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		</td>
	</tr>
	
</cfoutput>