<cfoutput>
	
	<h5>Protokoły</h5>
	
	<ul class="ajent_buttons_list">
		<li class="fltl">
			#linkTo(
				text="Nowy protokół",
				controller="Protocol_instances",
				action="add",
				key=session.userid,
				class="small ajent_button green")#
		</li>
		<li class="fltl">
			#linkTo(
				text="Wszystkie protokoły",
				controller="Protocol_instances",
				action="index",
				class="small ajent_button yellow")#
		</li>
	</ul>
	
	<table id="protocol_instance_table" class="newtables">
		<thead>
			<tr>
				<th class="c">NUMER PROTOKOŁU</th>
				<th class="c" filter-type="ddl">TYP PROTOKOŁU</th>
				<th class="c">DATA UTWORZENIA</th>
			</tr>
		</thead>
		<tbody>
			<cfloop query="myprotocols">
				<tr>
					<td class="bottomBorder">
						#linkTo(
							text=protocolnumber,
							controller="Protocol_instances",
							action="view",
							params="typeid=#protocoltypeid#&format=pdf",
							key=protocolinstanceid)#
					</td>
					<td class="bottomBorder">#typename#</td>
					<td class="bottomBorder c">
						#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(instance_created, "dd.mm.yyyy")# #TimeFormat(instance_created, "HH:mm")#
					</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
	
</cfoutput>

<script>
$(document).ready(function() {
	$('#protocol_instance_table').tableFilter();
});
</script>