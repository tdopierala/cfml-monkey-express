<cfoutput>

	<div class="wrapper">
	
		<h3>Regały</h3>
		
		<div class="wrapper">
		
			<table class="newtables">
				<thead>
					<tr class="top">
						<td class="bottomBorder" colspan="3"></td>
					</tr>
				</thead>
				
				<tbody>
					<cfloop query="shelfs">
						<tr>
							<td class="bottomBorder">#shelftypename#</td>
							<td class="bottomBorder">#shelfcategoryname#</td>
							<td class="bottomBorder">sklepy | dodaj sklep</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		
		</div>
	
	</div>

</cfoutput>