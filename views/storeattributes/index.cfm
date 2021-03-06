<cfoutput>

	<div class="wrapper">
	
		<h3>Atrybuty sklepu</h3>
		
		<div class="wrapper">
		
			<table id="storeAttributesTable" class="newtables">
				<thead>
					<tr class="top">
						<td colspan="3" class="bottomBorder"></td>
					</tr>
				</thead>
				
				<tbody>
				<cfloop query="storeattributes">
					<tr>
						<td class="bottomBorder">#attributename#</td>
						<td class="bottomBorder">#attributelabel#</td>
						<td class="bottomBorder c">
							#checkBoxTag(
								name="visible",
								value=1,
								class="addRemoveAttributeToStore {attributeid:#attributeid#,id:#id#}",
								checked=YesNoFormat(storeattributevisible))#

						</td>
					</tr>
				</cfloop>
				</tbody>
				
			</table>
		
		</div>
	
	</div>

</cfoutput>

<script type="text/javascript">

$(function() {
	$('.addRemoveAttributeToStore').live('click', function() {
		var attributeId = $(this).metadata().attributeid;
		var id = $(this).metadata().id;
		$.ajax({
			type: 'get',
			dataType: 'html',
			data: {attributeid:attributeId,key:id},
			url: "<cfoutput>#URLFor(controller='StoreAttributes',action='updateAttribute',params='cfdebug')#</cfoutput>",
			success: function(data) { 
			}
		});
	});
});

</script>