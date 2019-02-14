<cfoutput>

<tr>
	<td>
		<input
			type="text"
			name="data_wyslania-#new_row.id#"
			class="input pick_up_date {id:#new_row.id#, field_name:'data_wyslania'}" />
	</td>
	<td>
		<select
			name="typeid-#new_row.id#"
			class="select_box {id:#new_row.id#,field_name:'typeid'}">

			<option value="">[Typ]</option>
			<cfloop query="my_types">
				<option value="#id#">#typename#</option>
			</cfloop>

		</select>
	</td>
	<td>
		<select
			name="category-#new_row.id#"
			class="select_box {id:#new_row.id#,field_name:'categoryid'}">

			<option value="">[Kategoria]</option>
			<cfloop query="my_categories">
				<option value="#id#">#categoryname#</option>
			</cfloop>

		</select>
	</td>
	<td>
		<input
			type="text"
			name="ilosc-#new_row.id#"
			class="input {id:#new_row.id#, field_name:'ilosc'}" />
	</td>
	<td>
		<input
			type="text"
			name="uwagi-#new_row.id#"
			class="input {id:#new_row.id#, field_name:'uwagi'}" />
	</td>
</tr>

</cfoutput>