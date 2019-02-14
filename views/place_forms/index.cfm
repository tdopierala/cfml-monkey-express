<cfoutput>

<div class="wrapper">

	<div class="admin_wrapper">
	
		<h2 class="admin_formlist">Lista formularzy</h2>
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa formularza</th>
					<th>Opis formularza</th>
					<th>Liczba pól</th>
					<th>Data utworzenia</th>
					<th>Domyślny</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="forms">
				
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
						<td>
							#checkBoxTag(
								name="default",
								value=1,
								checked=YesNoFormat(def))#
						</td>
					</tr>
				
				</cfloop>
			</tbody>
			
			<tfoot>
				<tr>
					<td colspan="6" class="r">
						#linkTo(
							text="<span>Dodaj formularz</span>",
							controller="Place_forms",
							action="add",
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
	
	$(".requiredfield").live("click", function(e) {
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{formfieldid:$(this).metadata().id},
			url			:		"<cfoutput>#URLFor(controller='Place_forms',action='updateRequired')#</cfoutput>",
			success		:		function(data) {
			}
		});
	});
	
	$('.removeFormField').live('click', function(e) {
		var _link = $(this);
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{},
			url			:		$(this).attr('href'),
			success		:		function(data){
				_link.parent().parent().fadeOut("300").remove();
			}
		});
		return false;
	});
	
});
</script>