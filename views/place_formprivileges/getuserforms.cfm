<cfoutput>
	
	<tr>
		
		<td class="first">&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
			
			<table class="admin_table">
				
				<thead>
					<tr>
						<th class="first">&nbsp</th>
						<th>Nazwa formularza</th>
						<th>Odczyt</th>
						<th>Zapis</th>
						<th>Akceptacja</th>
					</tr>
				</thead>
				<tbody>
					
					<cfloop query="forms">
						
						<tr>
							
							<td class="first"></td>
							<td>#formname#</td>
							<td class="c">
								
								#checkBoxTag(
									name="readprivilege",
									class="readprivilege {id:#id#}",
									checked=YesNoFormat(readprivilege))#
								
							</td>
							<td class="c">
								
								#checkBoxTag(
									name="writeprivilege",
									class="writeprivilege {id:#id#}",
									checked=YesNoFormat(writeprivilege))#
							
							</td>
							<td class="c">
								
								#checkBoxTag(
									name="acceptprivilege",
									class="acceptprivilege {id:#id#}",
									checked=YesNoFormat(acceptprivilege))#
								
							</td>
							
						</tr>
						
					</cfloop>
					
				</tbody>
				
			</table>
			
		</td>
		
	</tr>
	
</cfoutput>