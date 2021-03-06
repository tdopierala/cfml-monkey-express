<cfoutput>
	
	<div class="wrapper">
		<div class="admin_wrapper">
			
			<!---
				Dodanie nowego typu protokołów
			--->
			<h2 class="admin_types">Nowy typ protokołów</h2>
			
			<cfform
				action="#URLFor(controller='Protocol_types',action='add')#" >
					
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
						<td classs="first">&nbsp;</td>
						<td>Nazwa typu protokołu</td>
						<td>
							<cfinput
								name="typename"
								type="text"
								class="input" />
						</td>
					</tr>
					<tr>
						<td colspan="3" class="r">
							<cfinput
								name="submittype"
								type="submit"
								class="admin_button green_admin_button"
								value="Zapisz" /> 
						</td>
					</tr>
				</tbody>
			</table>
			
			</cfform>
			
			<!---
				Przypisanie grupy pól do typu protokołu
			--->
			<h2 class="admin_assign">Przypisz grupę do protokołu</h2>
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Typ protokołu</th>
						<th>Liczba przypisanych grup</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="mytypes">
						<tr>
							<td class="first">
								#linkTo(
									text="<span>pobierz grupy</span>",
									controller="Protocol_types",
									action="getGroups",
									key=typeid,
									class="expand_step_forms")#
							</td>
							<td>#typename#</td>
							<td>#groupscount#</td>
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
	
	$(".protocoltypegroups").live("click", function(e) {
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{id:$(this).metadata().id},
			url			:		"<cfoutput>#URLFor(controller='Protocol_types',action='updateAccess')#</cfoutput>",
			success		:		function(data) {
			}
		});
	});
});
</script>