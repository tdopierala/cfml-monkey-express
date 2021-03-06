<cfoutput>

<div class="wrapper">

	<div class="admin_wrapper">
	
		<h2 class="admin_newform">Nowy formularz</h2>
		
		#startFormTag(controller="Place_forms",action="actionAdd")#
		
		<table class="admin_table">
			<thead>
				<tr>
					<th>&nbsp;</th>
					<th>Pole</th>
					<th>Opis</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>&nbsp;</td>
					<td>Nazwa formularza</td>
					<td>
						#textFieldTag(
							name="formname",
							class="input",
							label=false)#
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Opis formularza</td>
					<td>
						#textAreaTag(
							name="formdescription",
							class="textarea",
							label=false)#
					</td>
				</tr>
			</tbody>
		</table>
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa pola</th>
					<th>Typ pola</th>
					<th>Zaznacz</th>
				</tr>
				<tr>
				<th colspan="4">
					Wyszukaj w tabeli:
					#textFieldTag(
						name="tablesearch",
						class="input input_search")#
				</th>
			</thead>
			<tbody>
				
				<cfloop query="fields">
					<tr>
						<td>&nbsp;</td>
						<td>#fieldname#</td>
						<td>#fieldtypename#</td>
						<td>
							#checkBoxTag(
								name="fields[#id#]",
								value=1,
								label=false)#
						</td>
					</tr>
				</cfloop>
				
			</tbody>
			
			<tfoot>
				<tr>
					<td colspan="4" class="r">
						#submitTag(value="Zapisz",class="admin_button green_admin_button")#
					</td>
				</tr>
			</tfoot>
		</table>
		
		#endFormTag()#
	
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