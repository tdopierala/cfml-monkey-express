<cfoutput>

	<div class="wrapper">
	
		<h4>Zapisano mapę #map.mapname# z zaznaczonymi:</h5>
		
		<table class="newtables">
			<thead>
				<tr class="top">
					<td colspan="3" class="bottomBorder"></td>
				</tr>
			</thead>
			<tbody>
				<cfloop query="markers">
					<tr>
						<td class="bottomBorder">#markertitle#</td>
						<td class="bottomBorder">#markeraddress#</td>
						<td class="bottomBorder"><img src="#markericon#" /></td>
					</tr>
				</cfloop>
			</tbody>
		</table>
	
	</div>

</cfoutput>