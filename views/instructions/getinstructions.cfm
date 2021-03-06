<cfoutput>

	<div class="wrapper">
	
		<table class="newtables">
		
			<thead>
				<tr class="top">
					<th class="bottomBorder">DATA PUBLIKACJI</th>
					<th class="bottomBorder">AUTOR</th>
					<th class="bottomBorder">KATEGORIA</th>
					<th class="bottomBorder">NUMER</th>
					<th class="bottomBorder">NAZWA</th>
					<th class="bottomBorder">&nbsp;</th>
				</tr>
			</thead>
			
			<tbody>
			
				<cfloop query="instructions">
				
					<tr <cfif userinstructionread eq 0>class="unread"</cfif>>
						<td class="bottomBorder">#DateFormat(instructioncreated, "dd-mm-yyyy")# #TimeFormat(instructioncreated, "HH:mm")#</td>
						<td class="bottomBorder">#authorgivenname# #authorsn#</td>
						<td class="bottomBorder">#instructioncategoryname#</td>
						<td class="bottomBorder">#instructionnumber#</td>
						<td class="bottomBorder">#instructionname#</td>
						<td class="bottomBorder">
						
							#linkTo(
								text="<span>Pobierz instrukcję</span>",
								controller="Instructions",
								action="getInstructionFile",
								key=userinstructionid,
								class="pdf")#
						
						</td>
					</tr>
				
				</cfloop>
			
			</tbody>
		
		</table>
	
	</div>

</cfoutput>