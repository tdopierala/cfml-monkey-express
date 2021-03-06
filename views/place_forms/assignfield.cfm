<cfoutput>

<div class="wrapper">

	<div class="admin_wrapper">
	
		<h2 class="admin_assign">Przypisz pole do formularza</h2>
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa formularza</th>
					<th>Opis formularza</th>
					<th>Liczba pól</th>
					<th>Data utworzenia</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="allforms">
				
					<tr>
						<td>
							#linkTo(
								text="<span>pobierz pola formularza</span>",
								controller="Place_forms",
								action="formFields",
								key=id,
								class="expand_step_forms")#
						</td>
						<td>#formname#</td>
						<td>#Left(formdescription, 64)#...</td>
						<td>#fieldcount#</td>
						<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(formcreated, "yyyy-mm-dd")# #TimeFormat(formcreated, "HH:mm")#</td>
					</tr>
				
				</cfloop>
			</tbody>
			
		</table>
		
		#startFormTag(controller="Place_forms",action="actionAssignField")#
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa pola</th>
					<th>Wartość pola</th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td>&nbsp;</td>
					<td>Pole formularza</td>
					<td>
						#selectTag(
							name="fieldid",
							options=fields,
							label=false,
							class="selectbox")#
					</td>
				</tr>
				<tr>
					<td></td>
					<td>Formularz</td>
					<td>
						#selectTag(
							name="formid",
							options=forms,
							label=false,
							class="selectbox")#
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
	
	</div>
	
</div>

</cfoutput>

<script>
$(function() {
	$('.expand_step_forms').live('click', function(e) {
		e.preventDefault();
		
		var _link		=	$(this);
		var _point		=	$(this).parent().parent();
		$.ajax({
			type		:		'get',
			dataType	:		'html',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				_link.removeClass('expand_step_forms').addClass('collapse_step_forms');
				_point.after(data);
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
});
</script>