<cfprocessingdirective pageencoding="utf-8" />
	
<tr class="expand-child">
	<td class="leftBorder rightBorder bottomBorder">&nbsp;</td>
	<td colspan="3" class="rightBorder bottomBorder">
		
		<table class="uiTable aosTable">
			<tbody>
				<cfloop query="hosty">
					<tr>
						<th class="leftBorder bottomBorder rightBorder" colspan="2"><cfoutput>#nazwaTypu# - #ip#</cfoutput></th>
					</tr>
					
					<cfloop query="aplikacje">
						<cfif aplikacje.idMmarketHost eq hosty.idMmarketHost>
							<tr>
								<td class="leftBorder bottomBorder rightBorder l"><cfoutput>#nazwaAplikacji#</cfoutput></td>
								<td class="bottomBorder rightBorder r"><cfoutput>#wersjaAplikacji#</cfoutput></td>
							</tr>
						</cfif>
					</cfloop>
					
				</cfloop>
			</tbody>
		</table>
		
	</td>
</tr>