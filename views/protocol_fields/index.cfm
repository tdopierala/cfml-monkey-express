<cfoutput>
	
	<div class="wrapper">
		
		<div class="admin_wrapper">
			
			<!---
				Dodawanie nowego pola protokołu
			--->
			<h2 class="admin_newformfield">Nowe pole protokołu</h2>
	
			<cfform
				action="#URLFor(controller='Protocol_fields',action='add')#" >
					
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
						<td>
							Nazwa pola
						</td>
						<td>
							<cfinput
								type="text" 
								name="fieldname"
								class="input" /> 
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							Etykieta pola
						</td>
						<td>
							<cfinput
								name="fieldlabel"
								type="text"
								class="input" />
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							Atrybut class
						</td>
						<td>
							<cfinput 
								name="fieldclass"
								type="text"
								class="input" />
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							Pole wymagane
						</td>
						<td>
							<cfinput
								type="checkbox" 
								name="fieldrequired"
								value="1" /> 
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>
							Typ pola
						</td>
						<td>
							<cfselect
								name="fieldtypeid"
								query="fieldtypes"
								value="id"
								display="fieldtypename" >
							</cfselect>
						</td>
					</tr>
					<tr>
						<td class="r" colspan="3">
							<cfinput 
								type="submit" 
								name="submitprotocolfields" 
								value="Zapisz" 
								class="admin_button green_admin_button" />
						</td>
					</tr>
				</tbody>
			</table>
			
			</cfform>
			<!---
				Dodanie grupy pól protokołu
			--->
			<h2 class="admin_fieldgroups">Nowa grupa pól</h2>
			
			<cfform
				action="#URLFor(controller='Protocol_fields',action='addFieldGroup')#">
					
				<table class="admin_table">
					<thead>
						<tr>
							<th class="first">&nbsp;</th>
							<th>Nazwa pola</th>
							<th>Wartośc pola</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="first">&nbsp;</td>
							<td>Nazwa grupy pól</td>
							<td>
								<cfinput
									type="text"
									name="groupname"
									class="input" />
							</td>
						</tr>
						<tr>
							<td class="first">&nbsp;</td>
							<td>Grupa powtarzalna</td>
							<td>
								<cfinput
									type="checkbox" 
									name="grouprepeat"
									value="1" /> 
							</td>
						</tr>
						<tr>
							<td class="r" colspan="3">
								<cfinput
									type="submit"
									name="submitfieldgroup"
									value="Zapisz"
									class="admin_button green_admin_button" />
							</td>
						</tr>
					</tbody>
				</table>
					
			</cfform>
			
			<!---
				Przypisanie pola protokołu do grupy pól
			--->
			<h2 class="admin_assign">Przypisz pole do grupy</h2>
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa grupy</th>
						<th>Liczba pól</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="groups">
						<tr>
							<td class="first">
								#linkTo(
									text="<span>pobierz pola grupy</span>",
									controller="Protocol_groups",
									action="getFields",
									key=groupid,
									class="expand_step_forms")#
							</td>
							<td>#groupname#</td>
							<td>#fieldscount#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
		
	</div>
	
</cfoutput>

<script>
$(function() {
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
	
	$(".protocolaccessfield").live("click", function(e) {
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{id:$(this).metadata().id},
			url			:		"<cfoutput>#URLFor(controller='Protocol_fields',action='updateAccess')#</cfoutput>",
			success		:		function(data) {
			}
		});
	});
	
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