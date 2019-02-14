<cfoutput>

<div class="wrapper">

	<div class="admin_wrapper">
	
		<h2 class="admin_assign">Przypisz formularz do etapu</h2>
				
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa etapu</th>
					<th>Liczba formularzy</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="allsteps">
					
					<tr>
						<td class="c">
						
							#linkTo(
								text="<span>pobierz formularza</span>",
								controller="Place_forms",
								action="stepForms",
								key=id,
								class="expand_step_forms")#
						
						</td>
						<td>#stepname#</td>
						<td>#formcount#</td>
					</tr>
				
				</cfloop>
			</tbody>
		</table>
		
		#startFormTag(controller="Place_forms",action="actionAssignToStep")#
		
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
					<td>Etap</td>
					<td>
						
						#selectTag(
							name="stepid",
							options=steps,
							label=false,
							class="selectbox")#
					
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
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
	
	$('.remove_from_step').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		var _el = $(this).parent().parent();
		
		$.ajax({
			type		:		'get',
			dataType	:		'html',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				_el.remove();
				$('#flashMessages').hide();
			}
		});
	});
	
	$(".stepdefaultform").live("click", function(e){
		$.ajax({
			type		:	"post",
			dataType	:	"html",
			data		:	{stepformid:$(this).metadata().id},
			url			:	"index.cfm?controller=place_forms&action=default-step-form",
			success		:	function(result){
				console.debug(result);
			},
			error		:	function(xhr, error){
				console.debug(xhr);
				console.debug(error);
			}
		});
	});
});
</script>