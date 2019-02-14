<cfprocessingdirective pageEncoding="utf-8" />

<cfdiv class="cfwindow_container">

	<cfform
		action="#URLFor(controller='store_shelfs',action='addCategory')#"
		name="shelf_category_form"
		onsubmit="return validateNewShelfCategory();">

		<table class="admin_table">
			<thead>
				<tr>
					<th clas="first">&nbsp;</th>
					<th>Nazwa pola</th>
					<th>Wartość</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="first">&nbsp;</td>
					<td>Kategoria</td>
					<td>
						<cfinput
							type="text"
							name="shelfcategoryname"
							class="input" />
					</td>
				</tr>
				<tr>
					<td colspan="2" class="l">
						<cfinput
							type="submit"
							name="shelfcategorysubmit"
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
