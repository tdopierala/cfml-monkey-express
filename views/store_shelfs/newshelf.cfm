<cfprocessingdirective pageEncoding="utf-8" />

<cfdiv class="cfwindow_container">

	<cfform
		name="new_shelf_form"
		action="#URLFor(controller='Store_shelfs',action='addShelf')#"
		onsubmit="javascript:return validateNewShelf();" >

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
				<td>Typ sklepu</td>
				<td>
					<cfselect
						name="storetypeid"
						query="myStoreTypes"
						value="id"
						display="store_type_name"
						class="select_box"
						queryPosition="below" >

						<option value="0">[wybierz]</option>

					</cfselect>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>Typ regału</td>
				<td>
					<cfselect
						name="shelftypeid"
						query="myShelfTypes"
						value="id"
						display="shelftypename"
						class="select_box"
						queryPosition="below">

						<option value="0">[wybierz]</option>

					</cfselect>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>Kategoria regału</td>
				<td>
					<cfselect
						name="shelfcategoryid"
						query="myShelfCategories"
						value="id"
						display="shelfcategoryname"
						class="select_box"
						queryPosition="below">

						<option value="0">[wybierz]</option>

					</cfselect>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td>Ilość półek</td>
				<td>
					<cfinput
						name="number_of"
						type="text"
						class="input" />
				</td>
			</tr>
			<tr>
				<td class="l" colspan="2">
					<cfinput
						type="submit"
						name="new_shelf_form_submit"
						class="admin_button green_admin_button"
						value="Zapisz" />
				</td>
				<td>
					<span class="new_shelf_validation_message"></span>
				</td>
			</tr>
		</tbody>
	</table>

	</cfform>	

</cfdiv>