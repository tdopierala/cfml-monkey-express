<cfoutput>

	<div class="wrapper">
	
		#includePartial(partial="header")#	
	
	</div>
	
	<table class="newtables">
			<thead>
				<tr class="top">
					<td colspan="3" class="bottomBorder"></td>
				</tr>
			</thead>
			<tbody>
				<cfloop query="maps">
					<tr>
						<td class="bottomBorder">#mapname#</td>
						<td class="bottomBorder">#maplat#</td>
						<td class="bottomBorder">#maplng#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	
</cfoutput>