<cfoutput>

	<div class="wrapper">
	
		<h3>Atrybuty nieruchomości</h3>
		
		<div class="wrapper">
		
			<table class="newtables">
			
				<thead>
					<tr class="top">
						<td colspan="4" class="bottomBorder"></td>
					</tr>
				</thead>
				
				<tbody>
				
					<cfloop query="attributes">
					
						<tr>
							<td class="bottomBorder">#attributename#</td>
							<td class="bottomBorder">#attributelabel#</td>
							<td class="bottomBorder">#typename#</td>
							<td class="bottomBorder">
							
								#checkBoxTag(
									name="visible",
									value=1,
									class="addRemoveAttribute {attributeid:#attributeid#,id:#id#}",
									checked=YesNoFormat(placeattributevisible))#
							
							</td>
						</tr>
					
					</cfloop>
				
				</tbody>
			
			</table>
		
		</div>
	
	</div>

</cfoutput>

<script>
	
	$(function() {
		$('.addRemoveAttribute').live('click', function(e) {
			
			var attributeId = $(this).metadata().attributeid;
			var id = $(this).metadata().id;
		
			$.ajax({
				type: 'get',
				dataType: 'html',
				data: {attributeid:attributeId,key:id},
				url: "<cfoutput>#URLFor(controller='PlaceAttributes',action='updateAttribute',params='cfdebug')#</cfoutput>",
				success: function(data) { 
				}
			});
		});
	});

</script>