<cfoutput>

	<div class="wrapper">
		<div class="admin_wrapper">
			<h2 class="admin_collections">Lista zbiorów</h2>
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa zbioru</th>
						<th>Data utworzenia</th>
						<th>Użytkownik</th>
					</tr>
				</thead>	
				<tbody>
					<cfloop query="mycollections">
						<tr>
							<td>
								#linkTo(
									text="<span>pobierz pola zbioru</span>",
									controller="Place_collections",
									action="collectionFields",
									key=id,
									class="expand_step_forms")#
							</td>
							<td>#collectionname#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(collectioncreated, "yyyy-mm-dd")# #TimeFormat(collectioncreated, "HH:mm")#</td>
							<td>#givenname# #sn# <br /><span class="i">#position#</span></td>
						</tr>
					</cfloop>	
				</tbody>
				
			</table>
			
			<h2 class="admin_newcollection">Nowy zbiór</h2>
			
			#startFormTag(controller="Place_collections",action="actionAdd")#
			<table class="admin_table">
				
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Wartość</th>
					</tr>
				</thead>
				
				<tbody>
					<tr>
						<td>&nbsp;</td>
						<td>Nazwa zbioru</td>
						<td>
							#textFieldTag(
								name="collectionname",
								class="input",
								label=false)#
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Opis zbioru</td>
						<td>
							#textAreaTag(
								name="collectiondescription",
								class="textarea",
								label=false)#
						</td>
					</tr>
				</tbody>
				
			</table>
			
			<table class="admin_table" id="place_fields_list">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa pola</th>
						<th>Etykieta pola</th>
						<th>Typ pola</th>
						<th>Data utworzenia</th>
						<th>Zaznacz</th>
					</tr>
					<tr>
						<th colspan="6">
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
							<td>&nbsp;</td>
							<td>#fieldname#</td>
							<td>#fieldlabel#</td>
							<td>#fieldtypename#</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(fieldcreated, "yyyy-mm-dd")# #TimeFormat(fieldcreated, "HH:mm")#</td>
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
						<td class="r" colspan="6">
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
$(document).ready(function(){
	$('.expand_step_forms').live('click', function(e) {
		e.preventDefault();
		$("#flashMessages").show();
		
		var _link		=	$(this);
		var _point		=	$(this).parent().parent();
		$.ajax({
			type		:		'get',
			dataType	:		'html',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				_link.removeClass('expand_step_forms').addClass('collapse_step_forms');
				_point.after(data);
				$("#flashMessages").hide();
			}
		});
	});
	
	$('.collapse_step_forms').live('click', function(e) {
		e.preventDefault();
		
		var _link		=	$(this);
		var _point		=	$(this).parent().parent();
		
		_point.next().remove();
		_link.removeClass('collapse_step_forms').addClass('expand_step_forms');
	});
	
	$("#place_fields_list tbody>tr:has(td)").each(function() {
		var t = $(this).text().toLowerCase();
		$("<td class='indexColumn'></td>").hide().text(t).appendTo(this);
	});
	
	$("#tablesearch").keyup(function() {
		var s = $(this).val().toLowerCase().split(" ");
		$("#place_fields_list tbody>tr:hidden").show();
		$.each(s, function() {
			$("#place_fields_list tbody>tr:visible .indexColumn:not(:contains('" + this + "'))").parent().hide();
		});
	});
});
	
</script>