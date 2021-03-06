<cfoutput>
	
	<div class="wrapper">
		
		<h3>Podsumowanie protokołów</h3>
		
		<div class="wrapper">
			
			<div class="admin_wrapper">
			
			<table class="admin_table">
			
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>DATA</th>
					</tr>
				</thead>	
				<tbody>
					<cfloop query="my_dates">
						<tr>
							<td class="first">
								#linkTo(
									text="<span>Pobierz protokoły</span>",
									controller="Protocol_instances",
									action="summaryDay",
									params="year=#DateFormat(date, 'yyyy')#&month=#DateFormat(date, 'mm')#&day=#DateFormat(date, 'dd')#",
									class="expand_step_forms")#
							</td>
							<td>
								
								#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(date, "yyyy-mm-dd")#
								-
								Liczba protokołów (#c#)
								
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			</div>
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