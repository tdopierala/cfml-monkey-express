<cfoutput>

	<div class="wrapper">
	
		<h3>Atrybuty użytkowników</h3>
		
		<div class="wrapper">
		
			<table id="usersAttributesTable" class="newtables">
				<thead>
					<tr class="top">
						<td colspan="3" class="bottomBorder"></td>
					</tr>
				</thead>
				
				<tbody>
				<cfloop query="userattributes">
					<tr>
						<td class="bottomBorder">#attributename#</td>
						<td class="bottomBorder">#attributelabel#</td>
						<td class="bottomBorder c">
							#checkBoxTag(
								name="visible",
								value=1,
								class="addRemoveAttributeToUser {attributeid:#attributeid#,id:#id#}",
								checked=YesNoFormat(visible))#

						</td>
					</tr>
				</cfloop>
				</tbody>
				
				<tfoot>
					<tr>
						<td colspan="3"></td>
					</tr>
				</tfoot>
			</table>
		
		</div>
	
	</div>

</cfoutput>

<script type="text/javascript">

$(function() {
	$('.addRemoveAttributeToUser').live('click', function() {
		var attributeId = $(this).metadata().attributeid;
		var id = $(this).metadata().id;
		$.ajax({
			type: 'get',
			dataType: 'html',
			data: {attributeid:attributeId,key:id},
			url: "<cfoutput>#URLFor(controller='UserAttributes',action='updateUserAttribute',params='cfdebug')#</cfoutput>",
			success: function(data) { 
			}
		});
	});
});

</script>