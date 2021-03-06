<cfoutput>

<div class="wrapper">

	<div class="admin_wrapper">
	
		<h2 class="admin_newformfield">Nowe pole formularza</h2>
		
		#startFormTag(controller="Place_forms",action="actionAddField")#
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Pole</th>
					<th>Opis</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>&nbsp;</td>
					<td>Nazwa pola</td>
					<td>
						#textFieldTag(
							name="fieldname",
							class="input",
							label=false)#
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Etykieta pola</td>
					<td>
						#textFieldTag(
							name="fieldlabel",
							class="input",
							label=false)#
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Maska pola</td>
					<td>
						#textFieldTag(
							name="fieldmask",
							class="input",
							label=false)#
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Waga pola</td>
					<td>
						#textFieldTag(
							name="fieldrate",
							label=false,
							class="input")#
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Pole wymagane?</td>
					<td>
						#checkBoxTag(
							name="fieldrequired",
							checked=true)#
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>Typ pola</td>
					<td>
						#selectTag(
							name="fieldtypeid",
							options=fieldtypes,
							class="selectbox",
							label=false)#
					</td>
				</tr>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="3" class="r">
					
						#submitTag(value="Zapisz",class="admin_button green_admin_button")#

					</td>
				</tr>
			</tfoot>
		</table>
		
		#endFormTag()#
		
		<table class="admin_table" id="place_fields_list">
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
			
		</table>
	
	</div>
	
</div>

</cfoutput>

<script>	
	$(function() {
		$("#fieldtypeid").live('change', function(e) {
			var _fieldtypeid = $(this).attr("value");
			var _anchor = $(this).parent().parent();
			switch (_fieldtypeid) 
			{
				case "4":
					$("#flashMessages").show();
					$.ajax({
						type		:	"post",
						dataType	:	"html",
						url			:	"<cfoutput>#URLFor(controller='Place_forms',action='addSelectBoxForm')#</cfoutput>",
						success		:	function(data) {
							_anchor.after(data);
							$("#flashMessages").hide();
						}
					});
				break;	
			}
		});
		
		$(".add_selectbox_element").live('click', function(e) {
			e.preventDefault();
			var _anchor = $(this).parent().parent();
			var _link = $(this);
			var _td = $(this).parent();
			$.ajax({
				type		:	"post",
				dataType	:	"html",
				url			:	$(this).attr("href"),
				success		:	function(data) {
					_anchor.after(data);
					_link.remove();
					_td.append("<a href=\"#\" class=\"remove_selectbox_element\"><span>usuń</span></a>");
					$("#flashMessages").hide();
				}
			});
		});
		
		$(".remove_selectbox_element").live('click', function(e) {
			e.preventDefault();
			$(this).parent().parent().remove();
		});
		
		$("#place_fields_list tr:has(td)").each(function() {
			var t = $(this).text().toLowerCase();
			$("<td class='indexColumn'></td>").hide().text(t).appendTo(this);
		});
		
		$("#tablesearch").keyup(function() {
			var s = $(this).val().toLowerCase().split(" ");
			$("#place_fields_list tr:hidden").show();
			$.each(s, function() {
				$("#place_fields_list tr:visible .indexColumn:not(:contains('" + this + "'))").parent().hide();
			});
		});
	});
	
</script>

