<cfoutput>

	<div class="wrapper">
		<div class="admin_wrapper">

			<h2 class="tree_groups">Struktura</h2>

			<div class="tree_group_admin">
				<div class="inner">
					<ul>
						<li>
							#linkTo(
								text="<span>Dodaj grupę</span>",
								controller="Tree_groups",
								action="newGroup",
								class="new_tree_group")#
						</li>
					</ul>
				</div>
			</div>

			<div class="tree_group_users_search">
				<div class="inner">

					<h5>Znajdź użytkownika aby zmienić jego uprawniania</h5>

					<cfform
						action=""
						name="treegroupusersearchform">

						<ol class="vertival">
							<li>
								<cfinput
									type="text"
									name="usersearch"
									class="search_user input" />

								<select
									name="userid"
									id="userid"
									class="select_box">

								</select>
							</li>
						</ol>

					</cfform>
				</div>
			</div>

			<div class="tree_group_structure_container">
			<ul class="tree_group_structure">
			<cfloop query="my_tree">
				<li class="level-#level# {id:#id#, lft:#lft#, rgt:#rgt#, parentid:#parentid#}">
					<input
						type="checkbox"
						value="1"
						name="groupid#id#"
						class="group_access {id:#id#, lft:#lft#, rgt:#rgt#, parentid:#parentid#}" />

					<label for="groupid#id#">#groupname#</label>

					(
					#linkTo(
						text="<span>menu</span>",
						controller="Tree_groupmenus",
						action="index",
						key=id,
						class="tree_group_menu modal_frame")# |

					#linkTo(
						text="<span>widgety</span>",
						controller="Tree_groupwidgets",
						action="index",
						key=id,
						class="tree_group_widget modal_frame")#
					)

					#linkTo(
						text="<span>x</span>",
						controller="Tree_groups",
						action="delete",
						key=id,
						class="delete_tree_group_node {id:#id#}",
						confirm="Usunięcie grupy sposoduje usunięcie wszystkich powiązanych z nią elementów. Czy mam kontynuować?")#

				</li>
			</cfloop>
			</ul>
			</div>

		</div>
	</div>

</cfoutput>

<script>
$(function() {
	$(document).on('change', '#userid', function(e) {
		getUserPrivileges($(this).val())
	});

	$(document).on('click', '.new_tree_group', function (e) {
		e.preventDefault();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				CKEDITOR.replace('groupdescription');
				$('flashMessages').hide();
			}
		});
	});

	$(document).on('click', '.close_curtain', function (e) {
		$('.curtain').remove();
	});

	$(".tree_group_structure").sortable({
		items	:	"> li",
		stop	:	function(event, ui) {
			$('#flashMessages').show();
			$.ajax({
				dataType	:	'html',
				type		:	'post',
				data		:	{my_root:ui.item.metadata().id,new_parent:ui.item.prev().metadata().id},
				url			:	"<cfoutput>#URLFor(controller='Tree_groups',action='move')#</cfoutput>",
				success		:	function (data) {
					$('.tree_group_structure_container ul').remove();
					$('.tree_group_structure_container').append(data);
					$('#flashMessages').hide();
				}
			});

		}
	});

	$(document).on('click', '.modal_frame', function (e) {
		e.preventDefault();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				$('flashMessages').hide();
			}
		});
	});

	
	/* Dodaje obsługę zapisywania uprawnień użytkownika. */
	
	$(document).on('click', '.group_access', function (e) {
		if ($('#userid option:selected').val() !== undefined) {

			/*
				Sprawdzam, czy pole jest zaznaczone.
				Jak jest zaznaczone to dodaje wszystkie uprawnienia użytkownika.
				Jak nie jest zaznaczone to odejmuje wszystkie uprawnienia użytkownika.
			*/
			
			$('.tree_group_structure').append("<div class=\"white_curtain\"><img width=\"16\" height=\"11\" src=\"images/ajax-loader-3.gif\" alt=\"Ajax loader 3\"></div>");

			
			/* Sprawdzam, czy zaznaczyłem checkbox, czy odznaczyłem. */			
			if ($(this).is(":checked")) {
				/* Nadaje uprawnienia */
				$.ajax({
					dataType	:	'json',
					type		:	'post',
					data		:	{userid:$('#userid option:selected').val(),lft:$(this).metadata().lft,rgt:$(this).metadata().rgt},
					url			:	"<cfoutput>#URLFor(controller='Tree_groups',action='grant')#</cfoutput>",
					success		:	function (data) {
						$('.group_access').attr('checked', false);
						$.each(data.ROWS, function(i, item) {
							$('input[name=groupid'+item.GROUPID+']').attr('checked', 'checked');
						});

						$('.white_curtain').remove();
					}
				});

			} else {
				/* Odbieram uprawnienia */
				$.ajax({
					dataType	:	'json',
					type		:	'post',
					data		:	{userid:$('#userid option:selected').val(),lft:$(this).metadata().lft,rgt:$(this).metadata().rgt},
					url			:	"<cfoutput>#URLFor(controller='Tree_groups',action='revoke')#</cfoutput>",
					success		:	function (data) {
						$('.group_access').attr('checked', false);
						$.each(data.ROWS, function(i, item) {
							$('input[name=groupid'+item.GROUPID+']').attr('checked', 'checked');
						});

						$('.white_curtain').remove();
					}
				});

			}


		}
	});

	/* Wyszukiwanie użytkownika */
	var timeout = null;

    $(document).on('keypress', '.search_user', function () {
    	if (timeout) {
	        clearTimeout(timeout);
	        timeout = null;
    	}
    	timeout = setTimeout(getUserToWorkflowStep, 500);
    });

});

function getUserToWorkflowStep() {
	var searchValue = $('.search_user').attr('value');
	$.ajax({
		type		:		'post',
		dataType	:		'json',
		data		:		{searchvalue:searchValue, searchall:1},
		url			:		<cfoutput>"#URLFor(controller='Users',action='getUserToWorkflowStep',params='cfdebug')#"</cfoutput>,
		success		:		function(data) {
			var myOPTIONS = "";
			$.each(data.ROWS, function(i, item){
				myOPTIONS += "<option value=\""+item.ID+"\">"+item.GIVENNAME+" "+item.SN+" ("+item.LOGIN+")</option>";
			});
			$('#userid > option').remove();
			$('#userid').append(myOPTIONS);
			getUserPrivileges($('#userid option:selected').val());
		}
	});
}

function getUserPrivileges(userid) {
	$('.tree_group_structure').append("<div class=\"white_curtain\"><img width=\"16\" height=\"11\" src=\"images/ajax-loader-3.gif\" alt=\"Ajax loader 3\"></div>");

	$.ajax({
		dataType	:	'json',
		type		:	'post',
		data		:	{userid:userid},
		url			:	"<cfoutput>#URLFor(controller='Tree_groupusers',action='getUserGroups')#</cfoutput>",
		success		:	function (data) {
			$('.group_access').attr('checked', false);
			$.each(data.ROWS, function(i, item) {
				$('input[name=groupid'+item.GROUPID+']').attr('checked', 'checked');
			});
			$('.white_curtain').remove();
		}
	});

}
</script>

<script>
$(function() {
	$('.delete_tree_group_menu').live('click', function (e) {
		e.preventDefault();
		var _li = $(this).parent();
		$('#flashMessages').show();
		$.ajax({
			dataType	:	'html',
			type		:	'get',
			url			:	$(this).attr('href'),
			success		:	function (data) {
				_li.remove();
				$('#flashMessages').hide();
			}
		});
	});
});
</script>