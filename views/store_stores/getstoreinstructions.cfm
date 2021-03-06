<cfoutput>
	
	<h5>Wewnętrzne akty prawne</h5>
		
	<table id="instruction_table" class="newtables">
		<thead>
			<tr>
				<th class="c">NR. DOK</th>
				<th class="c" filter-type="ddl">TYP DOK</th>
				<th class="c" filter-type="ddl">DEPARTAMENT</th>
				<th class="c">DOTYCZY</th>
				<th class="c">OD</th>
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
					<td class="bottomBorder">#instruction_about#</td>
					<td class="bottomBorder">
						
						#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(instruction_date_from, "dd.mm.yyyy")#
					
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
	
</cfoutput>

<script>
$(document).ready(function() {
	$('#instruction_table').tableFilter();
});
</script>