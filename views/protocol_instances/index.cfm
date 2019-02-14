<cfoutput>
	
	<div class="wrapper">
		<h3>Protokoły</h3>
		
		<div class="wrapper">
			
			<div class="protocol_instances">
				
				<table id="protocol_instance_table" class="newtables">
					
					<thead>
						<tr>
							<th class="c">NUMER PROTOKOŁU</th>
							<th class="c">RODZAJ PROTOKOŁU</th>
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
									#imageTag(source="clock.png",alt="Data i godzina")#
									#DateFormat(instance_created, "dd-mm-yyyy")# #TimeFormat(instance_created, "HH:mm")#
								</td>
							</tr>
						</cfloop>
					</tbody>
					
				</table>
				
			</div>
			
		</div>
		
	</div>
	
</cfoutput>

<script>
$(document).ready(function() {
	$('#protocol_instance_table').tableFilter();
});
</script>