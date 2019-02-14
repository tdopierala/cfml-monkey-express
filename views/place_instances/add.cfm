<cfoutput>

<div class="wrapper">

	<div class="admin_wrapper">
	
		<h2 class="place_addbuilding">Nowa nieruchomość</h2>
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa pola</th>
					<th>Wartość</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>&nbsp;</td>
					<td>Województwo</td>
					<td>
						#textFieldTag(
							name="instanceprovince",
							label=false,
							class="input")#
					</td>
				</tr>
				
				<tr>
					<td>&nbsp;</td>
					<td>Miejscowość</td>
					<td>
						#textFieldTag(
							name="instanceplace",
							label=false,
							class="input")#
					</td>
				</tr>
				
				<tr>
					<td>&nbsp;</td>
					<td>Kod pocztowy</td>
					<td>
						#textFieldTag(
							name="instancepostalcode",
							class="input",
							label=false)#
					</td>
				</tr>
				
				<tr>
					<td>&nbsp;</td>
					<td>Ulica</td>
					<td>
						#textFieldTag(
							name="instancestreet",
							class="input",
							label=false)#
					</td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="3" class="r">
						#submitTag(value="Zapisz",class="admin_button green_admin_button")#
					</td>
				</tr>
			</tfoot>
		</table>
	
	</div>
	
</div>

</cfoutput>