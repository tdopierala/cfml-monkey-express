<cfoutput>

	<tr>
		<td>&nbsp;</td>
		<td colspan="3" class="admin_submenu_options">
			
			<table class="admin_table sort">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Typ pola</th>
						<th>Data utworzenia</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="myfields">
					
						<tr id="#collectionfieldid#" class={collectionfieldid:#collectionfieldid#,collectionid:#collectionid#}>
							<td>&nbsp;</td>
							<td>#fieldname#</td>
							<td>#fieldtypename#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(fieldcreated, "yyyy-mm-dd")# #TimeFormat(fieldcreated, "HH:mm")#</td>
						</tr>
					
					</cfloop>
				</tbody>
			</table>
			
		</td>
	</tr>
	
</cfoutput>

<script>
$(function() {
	$(".sort tbody").sortable({
		update	:	function(event, ui) {
			var _order = $(this).sortable('toArray').toString();
			$.get("<cfoutput>#URLFor(controller='Place_collections',action='reorder')#</cfoutput>", {neworder:_order});
		}
	});
});
</script>