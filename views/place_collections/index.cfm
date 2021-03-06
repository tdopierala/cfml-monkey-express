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
					<cfloop query="mycollections" >
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
				
				<tfoot>
					<tr>
						<td colspan="4" class="r">
							#linkTo(
								text="Dodaj zbiór",
								controller="Place_collections",
								action="add",
								class="admin_button green_admin_button")#
								
							#linkTo(
								text="Dodaj pole",
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
});
</script>