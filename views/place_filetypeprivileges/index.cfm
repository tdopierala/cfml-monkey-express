<cfoutput>

	<div class="wrapper">
		<div class="admin_wrapper">

			<h2 class="admin_privileges">Uprawnienia do plików</h2>

			<table class="admin_table" id="privileges">

				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Imię i nazwisko</th>
						<th>Stanowisko</th>
					</tr>
					<tr>
						<th colspan="3">
							Wyszukaj w tabeli:
								#textFieldTag(
								name="tablesearch",
								class="input input_search")#
						</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="users">

						<tr>
							<td class="first">

								#linkTo(
									text="<span>Lista plików</span>",
									controller="Place_filetypeprivileges",
									action="getUserFileTypes",
									key=userid,
									class="expand_step_forms")#

							</td>
							<td>#givenname# #sn#</td>
							<td class="i">#position#</td>
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

	$('.place_form_modal').live('click', function(e){

	});

	$("#privileges tbody>tr:has(td)").each(function() {
		var t = $(this).text().toLowerCase();
		$("<td class='indexColumn'></td>").hide().text(t).appendTo(this);
	});

	$("#tablesearch").live("keyup", function(e) {
		var s = $(this).val().toLowerCase().split(" ");
		$("#privileges tbody>tr:hidden").show();
		$.each(s, function() {
			$("#privileges tbody>tr:visible .indexColumn:not(:contains('" + this + "'))").parent().hide();
		});
	});

	$(".readprivilege").live("click", function(e) {
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{filetypeprivilegeid:$(this).metadata().id},
			url			:		"<cfoutput>#URLFor(controller='Place_filetypeprivileges',action='updateReadPrivilege')#</cfoutput>",
			success		:		function(data) {
			}
		});
	});

	$(".writeprivilege").live("click", function(e) {
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{filetypeprivilegeid:$(this).metadata().id},
			url			:		"<cfoutput>#URLFor(controller='Place_filetypeprivileges',action='updateWritePrivilege')#</cfoutput>",
			success		:		function(data) {
			}
		});
	});

	$(".deleteprivilege").live("click", function(e) {
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			data		:		{filetypeprivilegeid:$(this).metadata().id},
			url			:		"<cfoutput>#URLFor(controller='Place_filetypeprivileges',action='updateDeletePrivilege')#</cfoutput>",
			success		:		function(data) {
			}
		});
	});

});
</script>