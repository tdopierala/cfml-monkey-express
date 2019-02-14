<cfoutput>
	
	<tr>
		
		<td class="first">&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
			
			<table class="admin_table">
				
				<thead>
					<tr>
						<th class="first">&nbsp</th>
						<th>Nazwa etapu</th>
						<th class="c">Odczyt</th>
						<th class="c">Zapis</th>
						<th class="c">Akceptacja</th>
						<th class="c">Odrzucenie</th>
						<th class="c">Archiwum</th>
						<th class="c">Usunięcie</th>
						<th class="c">Przesunięcie</th>
						<th class="c">Controlling</th>
						<th class="c">Dział techn.</th>
					</tr>
				</thead>
				<tbody>
					
					<cfloop query="steps">
						
						<tr>
							
							<td class="first">&nbsp;</td>
							<td>#stepname#</td>
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
							<td class="c">
								
								#checkBoxTag(
									name="refuseprivilege",
									class="refuseprivilege {id:#id#}",
									checked=YesNoFormat(refuseprivilege))#
							
							</td>
							<td class="c">
								
								#checkBoxTag(
									name="archiveprivilege",
									class="archiveprivilege {id:#id#}",
									checked=YesNoFormat(archiveprivilege))#
							
							</td>
							
							<td class="c">
								
								#checkBoxTag(
									name="deleteprivilege",
									class="deleteprivilege {id:#id#}",
									checked=YesNoFormat(deleteprivilege))#
								
							</td>
							
							<td class="c">
								
								#checkBoxTag(
									name="moveprivilege",
									class="moveprivilege {id:#id#}",
									checked=YesNoFormat(moveprivilege))#
								
							</td>
							
							<td class="c">
								
								#checkBoxTag(
									name="controllingprivilege",
									class="controllingprivilege {id:#id#}",
									checked=YesNoFormat(controllingprivilege))#
								
							</td>
							
							<td class="c">
								
								#checkBoxTag(
									name="dtprivilege",
									class="dtprivilege {id:#id#}",
									checked=YesNoFormat(dtprivilege))#
								
							</td>
							
						</tr>
						
					</cfloop>
					
				</tbody>
				
			</table>
			
		</td>
		
	</tr>
	
</cfoutput>