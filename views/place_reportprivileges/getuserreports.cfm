<cfoutput>
	
	<tr>
		
		<td class="first">&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
			
			<table class="admin_table">
				
				<thead>
					<tr>
						<th class="first">&nbsp</th>
						<th>Nazwa raportu</th>
						<th>Odczyt</th>
					</tr>
				</thead>
				<tbody>
					
					<cfloop query="myreports">
						
						<tr>
							
							<td class="first">&nbsp;</td>
							<td>#reportname#</td>
							<td class="c">
								
								#checkBoxTag(
									name="readprivilege",
									class="readprivilege {id:#id#}",
									checked=YesNoFormat(readprivilege))#
								
							</td>
							
						</tr>
						
					</cfloop>
					
				</tbody>
				
			</table>
			
		</td>
		
	</tr>
	
</cfoutput>