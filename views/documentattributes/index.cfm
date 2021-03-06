<cfoutput>

	<div class="wrapper">
	
		<h3>Lista atrybutów dokumentu</h3>
		
		<table class="tables" id="documentAttributeTable">
			<thead>
				<tr>
					<th>Lp.</th>
					<th>Nazwa atrybutu</th>
					<th>Typ atrybutu</th>
					<th class="c">Dostęp</th>
				</tr>
			</thead>
			<tbody>
				<cfset index = 1>
				<cfloop query="attributes">
					<tr>
						<td>#index#</td>
						<td>#attributename#</td>
						<td>#typename#</td>
						<td class="c">
							#checkBoxTag(
								name="visible",
								value=1,
								class="documentAttributeAssign {id:#id#,attributeid:#attributeid#}",
								checked=YesNoFormat(documentattributevisible))#
						</td>
					</tr>
				<cfset index++>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="2"></td>
				</tr>
			</tfoot>
		</table>
	
	</div>

<script type="text/javascript">
$(function() {
	$(".documentAttributeAssign").live('click', function() {
		var id = $(this).metadata().id;
		$.ajax({
			type: 'get',
			dataType: 'html',
			data: {key:id},
			url: "#URLFor(controller='DocumentAttributes',action='updateDocumentAttribute',params='cfdebug')#",
			success: function(data) { 
	
			}
		});
	});
});
</script>

</cfoutput>