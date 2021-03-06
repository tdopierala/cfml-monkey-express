<script type="text/javascript">

	

</script>

<cfoutput>

	<div class="wrapper">
	
		<h3>Lista zdefiniowanych atrybutów</h3>
	
		<table class="tables" id="attributeTable">
			<thead>
				<tr>
					<th>Lp.</th>
					<th>Nazwa atrybutu</th>
					<th>Typ atrybutu</th>
					<th>Etykieta</th>
					<th>Akcje</th>
				</tr>
			</thead>
			<tbody>
				<cfset index = 1>
				<cfloop query="attributes">
					<tr>
						<td>#index#</td>
						<td>#attributename#</td>
						<td>#typename#</td>
						<td>#attributelabel#</td>
						<td>
							#linkTo(
								text="edytuj",
								controller="Attributes",
								action="edit",
								key=id,
								title="Edytuj atrybut")#
						</td>
					</tr>
				<cfset index++>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="5">
						#linkTo(
							text="[+ dodaj]",
							controller="Attributes",
							action="add",
							title="Dodawanie nowego atrybutu")#
					</td>
				</tr>
			</tfoot>
		</table>
		
	</div>

</cfoutput>