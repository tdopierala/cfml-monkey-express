<cfoutput>

	<tr>
		<td>&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
		
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa formularza</th>
						<th>Opis formularza</th>
						<th>Liczba pól</th>
						<th>Data dodania</th>
						<th>Autootwieranie</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
				
					<cfloop query="forms">
						<tr>
							<td>
								#linkTo(
									text="<span>pobierz pola formularza</span>",
									controller="Place_forms",
									action="formFields",
									key=id,
									class="expand_step_forms")#
							</td>
							<td>#formname#</td>
							<td>#Left(formdescription, 48)#…</td>
							<td>#fieldcount#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(formcreated, "yyyy-mm-dd")# #TimeFormat(formcreated, "HH:mm")#</td>
							<td class="c">
								#checkBoxTag(
									name="defaultform-#id#",
									class="stepdefaultform {id:#stepformid#}",
									checked=YesNoFormat(defaultform))#
							</td>
							<td>
								#linkTo(
									text="<span>Usuń formularz z etapu</span>",
									controller="Place_forms",
									action="removeFromStep",
									key=stepformid,
									class="remove_from_step {stepid:#stepid#,formid:#id#}")#
							</td>
						</tr>
					</cfloop>
				
				</tbody>
			</table>
		
		</td>
	</tr>

</cfoutput>



