<cfoutput>
	
	<div class="wrapper">
		
		<div class="admin_wrapper">
			
			<h2>Dostępne dashboardy</h2>
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Nazwa dashboardu</th>
						<th>Opis dashboardu</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="dashboards">
						<tr>
							<td class="first">&nbsp;</td>
							<td>#dashboardname#</td>
							<td>#dashboarddescription#</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
			
			<h2>Przypisz dashboard do użytkownika</h2>
			
			<cfform
				action=""
				name="dashboardassignform" >
			
			<table class="admin_table">
				<thead>
					<tr>
						<th style="width:33%;">Użytkownik</th>
						<th style="width:33%;" rowspan="2">Dostępne dashboardy</th>
						<th style="width:33%;" rowspan="2">Przypisane dashboardy</th>
					</tr>
					<tr>
						<th>
							<cfinput
								type="text"
								name="searchuser"
								class="input" />
						</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>
							<div class="users_list admin_submenu_options">
								
							</div>
						</td>
						<td>
							<div class="available_dashboards admin_submenu_options">
								
								<cfloop query="dashboards">
									<div class="dashboard_item" id="#id#">
										<span class="name">#dashboarddisplayname#</span>
									</div>
								</cfloop>
								
							</div>
						</td>
						<td>
							<div class="user_dashboards admin_submenu_options">
								
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			
			</cfform>
		</div>
		
	</div>
	
</cfoutput>
<script>
$(function() {
	
	<!---
		Obsługa wyszukiwania użytkownika do przypisania mu dashboardu.
	--->
	var timeout = null;
	
	$('#searchuser').live('keypress', function () {
	
		if (timeout) {
	        clearTimeout(timeout);
	        timeout = null;
		}
	
		timeout = setTimeout(function () {
			
			$('#flashMessages').show();
			
			$.ajax({
				type		:	'get',
				dataType	:	'json',
				data		:	{search:$('#searchuser').val()},
				url			:	"<cfoutput>#URLFor(controller='Users',action='search')#</cfoutput>",
				success		:	function(data) {
					
					$('.users_list').find('select').remove();
					
					var _mySELECT = "<select id=\"userid\" name=\"userid\" size=\""+ data.ROWSCOUNT +"\" class=\"select_box\" style=\"width:100%;\">";
					
					$.each(data.ROWS, function(i, item) {
						_mySELECT += "<option value=\"" + item.ID + "\">" + item.GIVENNAME + " " + item.SN + "</option>";
					});
						
					_mySELECT += "</select>";
					
					$('.users_list').append(_mySELECT);
					
					$('#flashMessages').hide();
					
				}
			});
		}, 500);
		
	});
	
	<!---
		Usuwam domyślną klasę dezaktywującą dashboard.
	--->
	$('.available_dashboards .dashboard_item').each(function() {
		$(this).removeClass('ui-draggable-disabled').removeClass('ui-state-disabled');
	});
				
	<!---
		Wybieram użytkownika z listy i pobieram dostępne dashboardy
		i te, które są do niego przypisane.
	--->
	$('#userid').live('change', function(e) {
		
		$('#flashMessages').show();
		
		<!---
			Pobieram listę przypisanych dashboardów.
		--->
		var tmp = $.ajax({
			type		:	'post',
			dataType	:	'json',
			data		:	{key:$(this).val()},
			url			:	"<cfoutput>#URLFor(controller='Dashboard_dashboards',action='userDashboards',cfdebug='')#</cfoutput>",
			success		:	function(data) {
				
				<!---
					21.02.2013
					Ponieważ nie wiem jak wywołać synchroniczne zapytania AJAXowe, zmieniłem sposób 
					informowania użytkownika, że jakieś dashboardy ma już przypisane.
					Teraz z wszystkich dostępnych dashboardów usuwam klace inactive.
				--->
				$('.available_dashboards .dashboard_item').each(function() {
					$(this).removeClass('ui-draggable-disabled').removeClass('ui-state-disabled');
				});
				
				<!---
					Tworzę listę dashboardów, które są przypisane do użytkownika.
				--->
				$('.user_dashboards').find('div').remove();
				$.each(data.ROWS, function(i, item) {
					$('.user_dashboards').append("<div class=\"dashboard_item\" id=\""+ item.ID +"\"><span class=\"name\">"+ item.DASHBOARDDISPLAYNAME + "</span></div>").data('userid', item.USERID).data('id', item.ID).data('dashboardid', item.DASHBOARDID);
					<!---
						Dodaję klasę disabled do listy dostępnych dashboardów.
					--->
					$('.available_dashboards #'+item.DASHBOARDID).addClass('ui-draggable-disabled');
				});
				
				$('#flashMessages').hide();

			}
		});
		
	});
	
	<!---
		Dodaję obsługę drag & drop dla dashboardów
	--->
	$('.dashboard_item').draggable({
		helper: 'clone',
		containment: '#content',
		stack: '.available_dashboards div',
		cursor: 'move',
		revert: true
    });
	
	$('.user_dashboards').droppable({
		accept: '.available_dashboards .dashboard_item',
		hoverClass: 'hovered',
		drop: function(event, ui) {
				
			if (!ui.draggable.hasClass('ui-draggable-disabled'))
			{
				ui.draggable.draggable('disable');
				ui.draggable.draggable('option', 'revert', false);
				
				<!---
					Appenduje nowy element do dashboardów
					przypisanych uzytkownikowi
				--->
				
				<!---
					Zapisuje nowy dashboard użytkownika.
					Wszystkie operacje odbywają się AJAXowo
				--->
				$.ajax({
					type		:		'post',
					dataType	:		'json',
					data		:		{userid:$('#userid').val(),dashboardid:ui.draggable.attr('id')},
					url			:		"<cfoutput>#URLFor(controller='Dashboard_dashboards',action='assignDashboardToUser')#</cfoutput>",
					success		:		function(data) {
						
					}
				});

			}
		}
	});
	
});
</script>