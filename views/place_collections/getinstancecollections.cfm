<cfoutput>
	
<div class="wrapper">
	<div class="admin_wrapper">
	
		<h2 class="admin_collection">Zbiór: #mycollection.collectionname#</h2>
	
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Dodane przez</th>
					<th>Data dodania</th>
					<th>Komentarze</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="mycollections">
				
					<tr>
						<td class="first">
							#linkTo(
								text="<span>pobierz zbiór</span>",
								controller="Place_collections",
								action="getInstance",
								key=id,
								class="expand_step_forms")#
						</td>
						<td>#givenname# #sn#<br /><span class="i">#position#</span></td>
						<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(instancecreated, "yyyy-mm-dd")# #TimeFormat(instancecreated, "HH:mm")#</td>
						<td>
							#linkTo(
								text="<span>Pobierz komentarze</span>",
								controller="Place_collections",
								action="getCollectionComments",
								key=id,
								class="place_comments show_comments")#
								(#commentscount#)
						</td>
						<td>
							#linkTo(
								text="<span>Usuń zbiór</span>",
								controller="Place_collections",
								action="delete",
								key=id,
								class="delete_collection")#
						</td>
					</tr>
				
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<td colspan="5" class="r">
						#linkTo(
							text="<span>Lista nieruchomości</span>",
							controller="Place_instances",
							action="index",
							class="admin_button gray_admin_button")#
						
						#linkTo(
							text="<span>Dodaj nowy zbiór</span>",
							controller="Place_collections",
							action="newCollection",
							params="collectionid=#mycollection.id#&instanceid=#myinstance.id#",
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
	
	$(".show_comments").live("click", function(e) {
		$("#flashMessages").show();
		e.preventDefault();
		var _link		=	$(this);
		var _point		=	$(this).closest("tr");
		
		$.ajax({
			type		:		'get',
			dataType	:		'html',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				_link.removeClass('show_comments').addClass('hide_comments');
				_point.after(data);
				$("#flashMessages").hide();
			}
		});
	});
	
	$(".hide_comments").live("click", function(e) {
		e.preventDefault();
		
		var _link		=	$(this);
		var _point		=	$(this).parent().parent();
		
		_point.next().remove();
		_link.removeClass('hide_comments').addClass('show_comments');
	});
	
	$(".submit_comment_form").live("click", function(e) {
		
		$("#flashMessages").show();
		e.preventDefault();
		
		var _form = $(this).closest("form");
		var _anchor = _form.closest("tr"); 
		
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		_form.serialize(),
			url			:		_form.attr('action'),
			success		:		function(data) {
				_anchor.after(data);
				_form.find("textarea").val("");
				$("#flashMessages").hide();
			}
		});
	});
	
	$(".delete_collection").live('click', function(e) {
		$("#flashMessages").show();
		e.preventDefault();
		
		var _tr = $(this).parent().parent();
		
		$.ajax({
			type		:	'post',
			dataType	:	'html',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function(data) {
				
				_tr.remove();
				$("#flashMessages").hide();
			}
		});
	});
});
</script>