<cfoutput>

<div class="wrapper">

	<div class="admin_wrapper">

		<h2 class="admin_fieldlist">Pola formularzy</h2>

		#linkTo(
			text="<span>Doda pole</span>",
			controller="Place_forms",
			action="addField",
			class="admin_button green_admin_button")#

		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa pola</th>
					<th>Etykieta pola</th>
					<th>Typ pola</th>
					<th>Data utworzenia</th>
				</tr>
				<tr>
					<th colspan="5">
						Wyszukaj w tabeli:
						#textFieldTag(
							name="tablesearch",
							class="input input_search")#
					</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="fields">

					<tr>
						<td>&nbsp;</td>
						<td>#fieldname#</td>
						<td>#fieldlabel#</td>
						<td>#fieldtypename#</td>
						<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(fieldcreated, "yyyy-mm-dd")# #TimeFormat(fieldcreated, "HH:mm")#</td>
					</tr>

				</cfloop>
			</tbody>

			<tfoot>
				<tr>
					<td colspan="5" class="r">
						#linkTo(
							text="<span>Doda pole</span>",
							controller="Place_forms",
							action="addField",
							class="admin_button green_admin_button")#
					</td>
				</tr>
			</tfoot>
		</table>

	</div>

</div>

</cfoutput>

<script>
$(function() {
	$(".admin_table tr:has(td)").each(function() {
		var t = $(this).text().toLowerCase();
		$("<td class='indexColumn'></td>").hide().text(t).appendTo(this);
	});

	$("#tablesearch").keyup(function() {
		var s = $(this).val().toLowerCase().split(" ");
		$(".admin_table tr:hidden").show();
		$.each(s, function() {
			$(".admin_table tr:visible .indexColumn:not(:contains('" + this + "'))").parent().hide();
		});
	});
});
</script>