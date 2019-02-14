<cfprocessingdirective pageEncoding="utf-8" />

<cfdiv class="cfwindow_container">

	<cfform
		action="#URLFor(controller='Store_shelfs',action='addType')#"
		name="shelf_type_form"
		onsubmit="javascript:return validateNewShelfType();">

		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa pola</th>
					<th>Wartośc</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td class="first">&nbsp;</td>
					<td>W</td>
					<td>
						<cfinput
							name="w"
							class="input"
							type="text" />
					</td>
				</tr>
				<tr>
					<td class="first">&nbsp;</td>
					<td>H</td>
					<td>
						<cfinput
							name="h"
							class="input"
							type="text" />
					</td>
				</tr>
				<!---
				<tr>
					<td class="first">&nbsp;</td>
					<td>Ilość</td>
					<td>
						<cfinput
							type="text" 
							name="number_of"
							class="input" /> 
					</td>
				</tr>
				--->
				<tr>
					<td colspan="2" class="l">
						<cfinput
							name="shelftypesubmit"
							class="admin_button green_admin_button"
							value="Zapisz"
							type="submit" />
					</td>
					<td>
						<span class="new_shelf_validation_message"></span>
					</td>
				</tr>
			</tbody>
		</table>

	</cfform>

</cfdiv>