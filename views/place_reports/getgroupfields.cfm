<cfoutput>
	
	<tr>
		<td>&nbsp;</td>
		<td colspan="2" class="admin_submenu_options">
		
			<table id="groupfields" class="admin_table sort">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Widoczność</th>
						<th>Formularz</th>
					</tr>
					<tr>
						<th colspan="4">
							Wyszukaj w tabeli: 
							#textFieldTag(
								name="tablesearch",
								class="input input_search")#
						</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="myfields">
						<tr>
							<td class="first">&nbsp;</td>
							<td>#fieldname#</td>
							<td class="c">
								#checkBoxTag(
									name="access",
									class="reportfieldaccess {id:#fieldgroupid#}",
									checked=YesNoFormat(access))#
							</td>
							<td>
								<select class="fieldgroupform" name="formid" class="selectbox">
									<cfset tmp = fieldgroupid />
									<cfset tmp2 = formid />
									<cfloop query="myforms">
									<option value="#id#" class="{fieldgroupid:#tmp#}" <cfif tmp2 eq id >selected="selected"</cfif>>#formname#</option>
									</cfloop>
								</select>
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
	$("#groupfields tbody>tr:has(td)").each(function() {
		var t = $(this).text().toLowerCase();
		$("<td class='indexColumn'></td>").hide().text(t).appendTo(this);
	});
	
	$("#tablesearch").live("keyup", function(e) {
		var s = $(this).val().toLowerCase().split(" ");
		$("#groupfields tbody>tr:hidden").show();
		$.each(s, function() {
			$("#groupfields tbody>tr:visible .indexColumn:not(:contains('" + this + "'))").parent().hide();
		});
	});
	
	$('.fieldgroupform').live('change', function(e) {		
		var _val = $(this).val();
		var _fieldgroupid = $(this).find('option:selected').metadata().fieldgroupid;
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{formid:_val,fieldgroupid:_fieldgroupid},
			url			:		"<cfoutput>#URLFor(controller='Place_reports',action='updateFieldGroupForm')#</cfoutput>",
			success		:		function(data) {
			}
		});
	});
});
</script>