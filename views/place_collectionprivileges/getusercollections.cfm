<cfoutput>
	
	<tr>
		
		<td class="first">&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
			
			<table class="admin_table">
				
				<thead>
					<tr>
						<th class="first">&nbsp</th>
						<th>Nazwa zbioru</th>
						<th>Odczyt</th>
						<th>Zapis</th>
					</tr>
				</thead>
				<tbody>
					
					<cfloop query="collections">
						
						<tr>
							
							<td class="first">&nbsp;</td>
							<td>#collectionname#</td>
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
							
						</tr>
						
					</cfloop>
					
				</tbody>
				
			</table>
			
		</td>
		
	</tr>
	
</cfoutput>