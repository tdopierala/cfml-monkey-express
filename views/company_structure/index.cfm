<script language="JavaScript">
	/*(function($) {
		$.fn.domNext = function() { return this.children(":eq(0)").add(this.next()).add(this.parents().filter(function() { return $(this).next().length > 0; }).next()).first(); };
		$.fn.domPrev = function() { return this.prev().find("*:last").add(this.parent()).add(this.prev()).last(); };
	})(jQuery);
	function lastNode(obj){ if (obj.has('ol').length > 0) return lastNode(obj.children("ol").children("li:last-child")); else return obj; }
	*/
	function loadStructTree(){
		$('#flashMessages').show();
		
		$.ajax({
			url		: 
			<cfif structKeyExists(params, 'edit') and params.edit eq 'true'>
				<cfoutput>"#URLFor(controller='Company_structure',action='index',params='edit=true')#",</cfoutput>
			<cfelse>
				<cfoutput>"#URLFor(controller='Company_structure',action='index')#",</cfoutput>
			</cfif>
			type		: "get",
			dataType	: "html",
			success: function( data ) 
			{
				$( ".users-structure-root" ).html(data);
				$('#flashMessages').hide();
			}
		});
	}
</script>
<cfoutput>
	<div class="wrapper">
		<h3>Struktura organizacyjna</h3>
		
		<div class="wrapper companystructure">
			
			<div class="structureEditOptions">
				<button class="reloadTree">Przeładuj</button>
				
				<button class="collapseAll">Rozwiń wszystkie</button>
				
				<cfif StructKeyExists(params, 'edit') and params.edit eq 'true' >
					<button class="add_to_structure">Dodaj nowy element</button>
				</cfif>
				
				<cfif privArrayContains(priv.rows, 14) and privArrayContains(priv.rows, 31) >
					<cfif StructKeyExists(params, 'edit') and params.edit eq 'true' >
						<button class="edit end">Zakończ edycję</button>
					<cfelse>
						<button class="edit begin">Edytuj strukture</button>
					</cfif>
				</cfif>
				
			</div>
				
				<div id="create_element_form" title="Dodaj nowy element">
					<p class="validateTips"></p>
					<form>
						<fieldset>
							<div class="create_element_form">
								<label for="type">Rodzaj nowego elementu</label>
								<select name="type" id="type">
									<option value="0"></option>
									<option value="1">Użytkownik</option>
									<option value="2">Departament</option>
									<option value="3">Dział</option>
								</select>
								<p class="create_element_form_type_tip"></p>
							</div>
							
							<div class="create_element_form">
								<label for="name">Nazwa / Imię i nazwisko</label>
								<input type="text" name="name" id="name" class="text ui-widget-content ui-corner-all" />
								<input type="hidden" name="uid" id="uid" />
								<p class="create_element_form_name_tip"></p>
								<p class="fieldTips">Dodając użytkownika do struktóry wyszukaj go wpisując jego imię i nazwisko</p>
							</div>
						</fieldset>
					</form>
				</div>
				
				<div id="delete-confirm" title="Czy jesteś pewien, że chcesz go usunąć?">
					<p style="margin: 15px 0;"><span class="ui-icon ui-icon-alert" style="float: left; margin: 0 7px 20px 0;"></span>
					Uwaga! Wykasowanie tego elementu spowoduje usunięcie wszystkich elementów podlegających (np. podwładnych).<br />
					<strong>Czy jesteś pewien, że chcesz go usunąć?</strong></p>
				</div>
				
				<ol class="users-structure-root" id="id_0">
					#includePartial('index')#
				</ol>
			
		</div>
	</div>
</cfoutput>

<script language="JavaScript">
	$(function(){
		<!--- loadStructTree(); --->
		
		<!--- $('#reloadTree').on({
			click: function(){
				alert('reload');
				loadStructTree();
			}
		}); --->
		
		$('.reloadTree').on({
			click: function(){
				loadStructTree();
				return false;
			}
		});
		
		$(document).on("dblclick", ".userStructTreeLeaf", function(){
			$(this).parent().children('ol').slideToggle();
			return false;
		});
		
		$(document).on("click", ".end", function() {
			window.location.href = "<cfoutput>#URLFor(controller='Company_structure',action='index')#</cfoutput>";
		});
			
		$(document).on("click", ".begin", function() {
			window.location.href = "<cfoutput>#URLFor(controller='Company_structure',action='index', params="edit=true")#</cfoutput>";
		});
		
		$(document).on("click", ".collapseAll", function(){
			var name = $(this).html();
			if(name == 'Rozwiń wszystkie'){
				$('ol.lvl1').find('ol').slideDown();
				$(this).html('Zwiń wszystkie');
			} else {
				$('ol.lvl1').find('ol').slideUp();
				$(this).html('Rozwiń wszystkie');
			}
		});
	});
</script>
<cfif StructKeyExists(params, 'edit') and params.edit eq 'true' >
	<script language="JavaScript">
		$(function(){
				
			$('ol.lvl2').show();
			
			$('.users-structure-root .li-disabled').disableSelection();
			
			$('.users-structure-root').nestedSortable({
				handle: 'div',
				items: 'li',
				listType: 'ol',
				placeholder: 'placeholder',
				opacity: 0.5,
				<!--- protectRoot: true, --->
				update: function ( event, ui ) {
					
					$.ajax({
						type		:	'post',
						dataType	:	'html',
						data		:	{
										my_id		:	$(ui.item).children().attr("id").substring(3),
										parent_id		:	$(ui.item).parent().prev().attr("id").substring(3)
									},
						url		:	"<cfoutput>#URLFor(controller='Company_structure',action='usersStructMove')#</cfoutput>",
						success	:	function(data) {
							loadStructTree();
						}
					});
				}
			});
			
			 $( "#delete-confirm" ).dialog({
			 	autoOpen: false,
				resizable: false,
				height: 200,
				width: 400,
				modal: true,
				buttons: {
					"Usuń element": function( event, ui ) {
										
						//alert( $( ui ).html() );
						<!--- $.ajax({
							type		:	'post',
							dataType	:	'html',
							data		:	{
											id	:	$(ui.item).parent().parent().attr("id").substring(3)
										},
							url		:	"<cfoutput>#URLFor(controller='Company_structure',action='usersStructDelete')#</cfoutput>",
							success	:	function(data) {
								$( "#delete-confirm" ).dialog( "close" );
								loadStructTree();
							}
						}); --->
					},
					Cancel: function() {
						$( this ).dialog( "close" );
					}
				}
			});
			
			$(document).on("click", ".delete a", function() {
				//$( "#delete-confirm" ).dialog( "open" );
				
				if(confirm('Jesteś pewien, że chcesz ususnąć ten element ze struktury wraz z jego podelementami?')){
					$.ajax({
						type		:	'post',
						dataType	:	'html',
						data		:	{
										id	:	$(this).parent().parent().attr("id").substring(3)
									},
						url		:	"<cfoutput>#URLFor(controller='Company_structure',action='usersStructDelete')#</cfoutput>",
						success	:	function(data) {
							loadStructTree();
						}
					});
				}
				return false;
			});
			
			$( "#create_element_form" ).dialog({
				autoOpen: false,
				height: 300,
				width: 400,
				modal: true,
				buttons: {
					"Utwórz nowy element": function() {
						var validate = true;
						
						var _type = $( ".create_element_form select#type" ).val();
						if( _type <= 0) {
							$('.create_element_form_type_tip').html("Wybierz rodzaj nowego elementu w strukturze");
							validate = false;
						}
						
						var _name = $( ".create_element_form input#name" ).val();
						if( _name == '' ) {
							$('.create_element_form_name_tip').html("Wpisz nazwę nowego elementu lub wybierz uzytkowniak z listy");
							validate = false;
						}
						
						var _id = $( ".create_element_form input#uid" ).val();
						if( _type == 1 && _id == '' ) {
							$('.create_element_form_name_tip').html("Wybierz użytkonika z listy po wpisaniu kilku pierwszych liter imienia lub nazwiska");
							validate = false;
						} 
						
						if( validate ) {
							//alert( 'type:'+ _type + ' name:' + _name + ' id:' + _id);
							$.ajax({
								type		: "POST",
								dataType	: "json",
								url		: "<cfoutput>#URLFor(controller='Company_structure',action='usersStructAdd')#</cfoutput>",
								data		: { type: _type, name: _name, id: _id },
								success: function( data ){
									$( "#create_element_form" ).dialog( "close" );
									loadStructTree();
								}
							});
						}
					}
				},
				Cancel: function() {
					$( this ).dialog( "close" );
				},
				close: function() {
					
				}
			});
			
			$(document).on("click", ".add_to_structure", function() {
				$( ".create_element_form input#name" ).val( '' );
				$( ".create_element_form select#type" ).val( 0 );
				$( ".create_element_form input#uid" ).val( '' );
				$( "#create_element_form" ).dialog( "open" );
			});
			
			$(document).on("change", ".create_element_form select#type", function() {
				if( $(this).val() == 1 ) {
					$( ".create_element_form input#name" ).autocomplete( "option", "disabled", false );
					$( ".create_element_form input#name" ).val('');
				}
				else
					$( ".create_element_form input#name" ).autocomplete( "option", "disabled", true );
			});
			
			var timeout;
			$( ".create_element_form input#name" ).autocomplete({
				disabled	: true
				,source	: function( request, response ) {
					clearTimeout(timeout);
				   	timeout = setTimeout(function() {
						$.ajax({
							url		: <cfoutput>"#URLFor(controller='Users',action='getUserToWorkflowStep')#"</cfoutput> + "&searchvalue=" + request.term,
							type		: "get",
							dataType	: "json",
							success: function( data ) {
								response( $.map( data.ROWS, function( item ) {
									return {
										label: item.GIVENNAME + " " + item.SN,
										id: item.ID
									}
								}));
							}
						});
				   	}, 500);
				}
				,minLength: 2
				,select: function( event, ui ) {
					$( ".create_element_form input#uid" ).val( ui.item.id );
					//alert( ui.item ? "Selected: " + ui.item.id : "Nothing selected, input was " + this.value);
				}
			});
		});
	</script>
<cfelse>
	<script language="JavaScript">
		$(function(){
			
			
			var timeout;
			$(document).on("mouseenter", ".employee", function() {
				//$('._userdetails').hide().html('').removeClass('selected');	
				$(this).children('.userdetails').children('._userdetails').addClass('selected').show();
				
				var id = $(this).children('.userid').html();
				
				var html = $('div.selected').children();
					
				if(html.html() == '') {
					timeout = setTimeout(function() {
		      				
		      			$.ajax({
							type		:	'get',
							dataType	:	'html',
							url		:	<cfoutput>"#URLFor(controller='Company_structure',action='usersStructDetails')#"</cfoutput> + "&key=" + id,
							success	:	function(data) {
								html.html(data);
							}
						});
					}, 1000);
				}
			});
			
			$(document).on("mouseleave", ".employee", function() {
				clearTimeout(timeout);
				$(this).children('.userdetails').children('._userdetails').hide().removeClass('selected');
			});
		});
	</script>
</cfif>