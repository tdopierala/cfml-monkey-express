<cfoutput>
	
		<div class="wrapper" style="width:600px;">
		<div class="admin_wrapper">
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Użytkownik</th>
						<th>Data dodania</th>
						<th>Notatka</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="mynotes">
							
							<tr>
								<td class="first">&nbsp;</td>
								<td>#givenname# #sn#</td>
								<td>
									<cfif Len(created)>
										#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(created, "yyyy-mm-dd")# #TimeFormat(created, "HH:mm")#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
								<td>
									<cfif Len(formnote)>
										#formnote#
									<cfelse>
										&nbsp;
									</cfif>
								</td>
							</tr>
						
					</cfloop>
				</tbody>
			</table>
			
		</div>
	</div>
	
</cfoutput>