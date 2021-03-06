<cfoutput>

	<div class="workflow_filter_div">

	<cfform
		action="#URLFor(controller='Workflows',action='index',key=session.user.id)#" >

		<table class="workflow_filter_table">
			<tbody>
				<tr>
					<td class="label_column">
						Rok
					</td>
					<td class="value_column">
						<select id="workflow_filter_year" name="workflow_filter_year">
							<cfloop collection="#years#" item="year" >
								<option value="#year#" <cfif year eq session.workflow_filter.year> selected</cfif>>#years[year]#</option>
							</cfloop>
						</select>
					</td>
					<td class="label_column">
						Miesiąc
					</td>
					<td class="value_column">
						<select id="workflow_filter_month" name="workflow_filter_month">
							<cfloop collection="#months#" item="month">
								<option value="#month#" <cfif month eq session.workflow_filter.month> selected</cfif>>#months[month]#</option>
							</cfloop>
						</select>
					</td>
					<!---
					<td class="label_column">
						Typ
					</td>
					<td class="value_column">
						<select id="typeid" name="typeid">
							<option value="0">[wszystkie]</option>
							<cfloop query="types">
								<option value="#id#" <cfif id eq session.workflow_filter.type> selected</cfif>>#typename#</option>
							</cfloop>
						</select>
					</td>
					--->
					<td class="label_column">
						<cfinput
							name="submit_workflow_filter"
							type="submit"
							value="Filtruj"
							class="admin_button small_green_admin_button" />
					</td>
				</tr>
			</tbody>
		</table>

	</cfform>

	</div>

</cfoutput>