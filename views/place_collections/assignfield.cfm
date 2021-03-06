<cfoutput>
	
	<div class="wrapper">
		<div class="admin_wrapper">
			<h2 class="admin_collections">Lista zbiorów</h2>
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa etapu</th>
						<th>Ilość zbiorów</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="mysteps">
					
						<tr>
							<td>
								#linkTo(
									text="<span>pobierz zbiory etapu</span>",
									controller="Place_collections",
									action="stepCollections",
									key=id,
									class="expand_step_forms")#
							</td>
							<td>#stepname#</td>
							<td>#collectioncount#</td>
						</tr>
					
					</cfloop>
				</tbody>
			</table>
			
			<h2 class="admin_collectionassign">Przypisz pole do zbioru</h2>
			
			#startFormTag(controller="Place_collections",action="actionAssignField")#
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
							#selectTag(
								name="collectionid",
								options=collections,
								label=false,
								class="selectbox")#
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td>Nazwa pola</td>
						<td>
							#selectTag(
								name="fieldid",
								options=fields,
								label=false,
								class="selectbox")#
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td class="r" colspan="3">
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