<cfoutput>
	
	<tr>
		<td class="first">&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa raportu</th>
						<th>Data utworzenia</th>
						<th>Domyślny</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="myreports">
						<tr>
							<td class="first">
								#linkTo(
									text="<span>pobierz grupy raportu</span>",
									controller="Place_reports",
									action="getReportGroups",
									key=reportid,
									class="expand_step_forms")#
							</td>
							<td>#reportname#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(reportcreated, "yyyy-mm-dd")# #TimeFormat(reportcreated, "HH:mm")#</td>
							<td class="c">
								#checkBoxTag(
									name="defaultreport",
									class="defaultreport {id:#id#}",
									checked=YesNoFormat(defaultreport))#
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
		</td>
	</tr>
	
</cfoutput>