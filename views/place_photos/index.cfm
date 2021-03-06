<cfoutput>

<div class="wrapper">

	<div class="admin_wrapper">
	
		<h2 class="admin_photos">Zdjęcia</h2>
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa etapu</th>
					<th>Liczba zdjęć</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="allsteps">
					<tr>
						<td>
							#linkTo(
								text="<span>pobierz typy zdjęć etapu</span>",
								controller="Place_photos",
								action="stepPhotoTypes",
								key=id,
								class="expand_step_forms")#

						</td>
						<td>#stepname#</td>
						<td>#photocount#</td>
					</tr>
				</cfloop>
			</tbody>
			
		</table>
		
		<h2 class="admin_newphototype">Nowa kategoria zdjęcia</h2>
		
		#startFormTag(controller="Place_photos",action="actionAdd")#
		
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
					<td>Nazwa typu zdjęcia</td>
					<td>
						#textFieldTag(
							name="phototypename",
							class="input",
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
		
		<h2 class="admin_assign">Przypisz kategorię do etapu</h2>
		
		#startFormTag(controller="Place_photos",action="actionAssignToStep")#
		
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
					<td>Nazwa kategorii</td>
					<td>
						#selectTag(
							name="phototypeid",
							options=photos,
							label=false,
							class="selectbox")#
					</td>
				</tr>
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