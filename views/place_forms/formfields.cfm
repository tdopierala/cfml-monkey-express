<cfoutput>

	<tr>
		<td>&nbsp;</td>
		<td colspan="5" class="admin_submenu_options">
		
			<table class="admin_table tosearch sort">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Etykieta pola</th>
						<th>Typ pola</th>
						<th>Data dodania</th>
						<th>Obowiązkowe</th>
						<th>&nbsp;</th>
					</tr>
					<tr>
						<th colspan="7">
							Wyszukaj w tabeli:
							#textFieldTag(
								name="tablesearch",
								class="input input_search")#
						</th>
					</tr>
				</thead>
				<tbody>
				
				<cfloop query="fields">
				
					<tr id="#formfieldid#">
						<td>&nbsp;</td>
						<td>#fieldname#</td>
						<td>#fieldlabel#</td>
						<td>#fieldtypename#</td>
						<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(fieldcreated, "yyyy-mm-dd")# #TimeFormat(fieldcreated, "HH:mm")#</td>
						<td class="c">
							#checkBoxTag(
								name="requiredfield",
								class="requiredfield {id:#formfieldid#}",
								checked=YesNoFormat(required))#
						</td>
						<td class="c">
							<a href="index.cfm?controller=place_forms&action=remove-form-field&key=#formfieldid#" title="Usuń pole" class="delete_bin removeFormField"><span>Usuń pole</span></a>
						</td>
					</tr>
				
				</cfloop>
				
				</tbody>
			</table>
		
		</td>
	</tr>

</cfoutput>

<script>
$(function() {
	$(".tosearch tbody tr:has(td)").each(function() {
		var t = $(this).text().toLowerCase();
		$("<td class='indexColumn'></td>").hide().text(t).appendTo(this);
	});
		
	$("#tablesearch").keyup(function() {
		var s = $(this).val().toLowerCase().split(" ");
		$(".tosearch tr:hidden").show();
		$.each(s, function() {
			$(".tosearch tbody tr:visible .indexColumn:not(:contains('" + this + "'))").parent().hide();
		});
	});
	
	$(".sort tbody").sortable({
		update	:	function(event, ui) {
			var _order = $(this).sortable('toArray').toString();
			$.get("<cfoutput>#URLFor(controller='Place_forms',action='reorder')#</cfoutput>", {neworder:_order});
		}
	});
});
</script>
