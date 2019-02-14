
<cfoutput>
	
	<div class="wrapper">
	
		<h3>#myprotocolinfo.typename#</h3>
		
		<div class="wrapper">
		
		<div class="admin_wrapper">
		
		<cfform
			action="#URLFor(controller='Protocol_instances',action='save',key=myinstnceid,params="typeid=#myprotocolinfo.id#")#" >
		
		<cfloop array="#myprotocol_array#" index="i" >
			
			<cfif structIsEmpty(i) >
				<cfcontinue />
			</cfif>
			
		<cfset tmp = structNew() />
		<cfset tmp = {
			groupid 		= 	i.groupid,
			instanceid 		= 	i.instanceid,
			typeid 			=	i.typeid} />
			
			<h5>#i.groupname#</h5>
		
			<!---
				Sprawdzam, czy grupa ma być powtarzalna. Jeżeli tak
				to wszystkie pola generuje w poziomie a nie pionie :)
			--->
			<cfif i.repeat eq 0>
				<table class="admin_table">
					<thead>
						<tr>
							<th class="first">&nbsp;</th>
							<th>Pole</th>
							<th>Wartość</th>
						</tr>
					</thead>
					<tbody>
						
						<cfset toloop = i.query.1 />
						<cfloop query="toloop">
							
							<tr>
								<td class="first">&nbsp;</td>
								<td>#fieldname#</td>
								<td>
									<cfinput
										type="text"
										name="instancevalue[#id#]"
										class="input"
										value="#fieldvalue#" />
								</td>
							</tr>
							
						</cfloop>
						
					</tbody>
				</table>
				
			<!---
				Te elementy są powtarzalne więc generuje je w poziomie
			--->
			<cfelse>
				<table class="admin_table repeat">
					<thead>
						<tr>
							<cfif structKeyExists(i, "query")>
								<cfset toloop1 = i.query.1 />
								<cfloop query="toloop1">
									<th>#fieldname#</th>
								</cfloop>
							</cfif>
							<th>&nbsp;</th>
						</tr>
					</thead>
					<tbody>
						<!---
							Tworzę tyle wierszy, ile jest elementów row
						--->
						<cfif structKeyExists(i, "query")>
							<cfset toloop2 = i.query />
							<cfset colspan = 0 />
							<cfloop collection="#toloop2#" item="j" >
								<tr>

									<!---
										Tutaj tworzę tyle kolumn ile jest eleentów grupy.
									--->
									<cfset toloop3 = i.query[j] />
									<cfset colspan = i.query[j].recordCount />
									<cfloop query="toloop3">
										<td>
											<cfswitch expression="#fieldtypeid#" >
												<cfcase value="4" >
													<!---
														Select box z opcjami do wyboru.
													--->
													<cfset my_query = my_selectbox_values[fieldid] />
													<cfselect 
														name="instancevalue[#id#]"
														query="my_query"
														value="fieldvalue"
														display="fieldvalue" >
														
													</cfselect>
													
													<!---
														Koniec selectboxa.
													--->
												</cfcase>
												<cfdefaultcase>
													<!---
														Domyślne pole formularza
													--->
													<cfif readonly eq 1>
												
														<cfinput
															type="text"
															name="instancevalue[#id#]"
															class="horizontal_input #fieldclass#"
															value="#fieldvalue#" />
												
														<cfelse>
														
														<cfinput
															type="text"
															name="instancevalue[#id#]"
															class="horizontal_input #fieldclass#"
															value="#fieldvalue#" />
												
													</cfif>
													
												</cfdefaultcase>
											</cfswitch>
											
										</td>
									</cfloop>
									<td>
										#linkTo(
											text="-",
											controller="Protocol_instances",
											action="removeRow",
											params="groupid=#i.groupid#&typeid=#i.typeid#&instanceid=#i.instanceid#&row=#j-1#",
											class="small_admin_button red_admin_button remove_row")#
									</td>
								</tr>
							</cfloop>
						</cfif>
						<tr>
							<cfif isDefined("colspan")>
								<td colspan="#colspan#">&nbsp;</td>
							<cfelse>
								
							</cfif>
							<td>
								#linkTo(
									text="+",
									controller="Protocol_instances",
									action="addRow",
									params="groupid=#i.groupid#&typeid=#i.typeid#&instanceid=#i.instanceid#",
									class="small_admin_button green_admin_button add_row")#
							</td>
						</tr>
					</tbody>
				</table>
			</cfif>
		
		</cfloop> 
		
			<table class="admin_table">
				<thead>
					<tr>
						<th class="l b darkred">
							Uwaga. Dokument należy wypełniać w jednostce miary „sztuka".
						</th>
					</td>
					<tr>
						<th class="r">
							<cfinput
								type="submit"
								name="submitprotocol"
								value="Zapisz"
								class="admin_button green_admin_button" />
						</th>
					</tr>
				</thead>
			</table>
		
		</cfform>
		
		</div> <!--- koniec admin_wrapper --->
	
		</div> <!--- koniec wrapper --->
	
	</div>
	
</cfoutput>

<script>
$(function() {
	$('.add_row').live('click', function(e) {
		e.preventDefault();
		var _row = $(this).closest("tr");
		$.ajax({
			type		:	'post',
			dataType	:	'html',
			url			:	$(this).attr('href'),
			success		:	function(data) {
				<!---_link.removeClass('expand_step_forms').addClass('collapse_step_forms');--->
				_row.before(data);
			},
			error		:	function(xhr, ajaxOptions, thrownError) {
			}
		});
	});
	
	$('.remove_row').live('click', function(e) {
		e.preventDefault();
		var _row = $(this).closest('tr');
		$.ajax({
			type		:		'post',
			dataType	:		'html',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				_row.remove();
			}
		});
	});
	
	$('.asseco_indeks_produktu').live('keyup', function (e) {
		$(this).autocomplete({
			source: function(request, response) {
				$.getJSON('index.cfm?controller=asseco&action=get-indexes&params=cfdebug', {search: request.term}, response);				
		},
			select: function(element, ui) {
				var prms = ui.item.label.split("|");
				$(this).parent().parent().find('.asseco_nazwa_produktu').val(prms[0]);
				$(this).parent().parent().find('.index_ean').val(prms[1]);
			}
		});
	});
	
	$('.pick_up_date').datepicker({
		dateFormat: 'dd-mm-yy',
		monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
		dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
		firstDay: 1
	});
	
	$('#submitprotocol').live('click', function() {
		$('form').hide();
		var _link = '<cfoutput>#linkTo(text='Wróc do swojego profilu',controller='store_stores',action='view',key=session.userid)#</cfoutput>';
		
		$('.admin_wrapper').append(_link);
	});
	
});
</script>