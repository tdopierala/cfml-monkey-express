<cfoutput>
<h4>Wewnętrzne akty prawne <span class="user_instructions_count">(#myinstructions.RecordCount#)</span>
<span class="all_instructions">
	#linkTo(
		text="wszystkie",
		controller="Instructions",
		action="index")#
</span>
</h4>

<div class="user_instructions">
	<table class="newtables" id="user_instructions_table">
		<thead>
			<tr class="top">
				<td colspan="4" class="bottomBorder">&nbsp;</td>
			</tr>
		</thead>
		<tbody>
			<cfloop query="myinstructions">
				<tr>
					<td class="bottomBorder">
						#linkTo(
							text=instruction_number,
							href="files/instructions/#filename#",
							target="_blank")#
					</td>
					<td class="bottomBorder">#documenttypename#</td>
					<td class="bottomBorder">#department_name#</td>
					<td class="bottomBorder">
							
						#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(instruction_created, "dd.mm.yyyy")#
							
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>

</div>

</cfoutput>