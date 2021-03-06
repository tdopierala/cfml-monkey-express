<cfoutput>
	
	<div class="correspondence_modal_window_close close_curtain">[zamknij]</div>
	
	<div class="correspondence_modal_window">
		
		<div class="admin_submenu_bar">
			<cfform
				name="letters_filter_form"
				action="#URLFor(controller='Correspondences',action='newNormalLetters')#"
				id="letters_filter_form" >
					
				<ul class="correspondence_filters">
					<li>
						<cfinput
							type="text"
							class="input pick_up_date"
							name="listy_data_od"
							placeholder="Data od"
							value="#DateFormat(session.letters_filter.data_od, 'yyyy-mm-dd')#" />
					</li>
					<li>
						<cfinput
							type="text"
							class="input pick_up_date"
							name="listy_data_do"
							placeholder="Data do"
							value="#DateFormat(session.letters_filter.data_do, 'yyyy-mm-dd')#" />
					</li>
					<li>
						<cfinput
							type="submit"
							class="admin_button green_admin_button"
							name="correspondence_filter_submit"
							value="Filtruj" />
					</li>
				</ul>
						
			</cfform>
		</div>
	
		<cfform
			action="#URLFor(controller='Correspondences',action='printNormalLetters',params='format=pdf')#"
			name="normallettersform"
			target="_blank" >
				
			<table class="admin_table" id="normal_letters_table">
				<thead>
					<tr>
						<th>Rodzaj listu</th>
						<th>Data nadania</th>
						<th>Ilość listów</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="my_list">
						<tr>
							<td>
								<select
									name="typeid[#id#]"
									class="select_box {id:#id#,field_name:'typeid'} typeid"
									id="typeid[#id#]">
									
									<option value=""></option>
									
									<cfset tmp = typeid />	
									<cfloop query="my_types">
										<option value="#id#" <cfif id eq tmp> selected="selected"</cfif>>#typename#</option>
									</cfloop>
									
								</select>

							</td>
							<td>
								<cfinput
									name="data_nadania[#id#]"
									type="text"
									class="input {id:#id#,field_name:'data_nadania'} data_nadania"
									value="#DateFormat(data_nadania, 'yyyy-mm-dd')#" />
							</td>
							<td>
								<cfinput
									name="letters_count[#id#]"
									type="text"
									class="input {id:#id#,field_name:'letters_count'} letters_count"
									value="#letters_count#" />
							</td>
							<td>
								#linkTo(
									text="<span>-</span>",
									controller="Correspondences",
									action="removeLetterRow",
									key=id,
									class="remove_letter_row small_admin_button red_admin_button")#
							</td>
						</tr>
					</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="3" class="l">
							<cfinput
								type="submit"
								name="normalletterssubmit"
								value="Drukuj"
								class="admin_button green_admin_button" />
						</th>
						<th class="first">
							#linkTo(
								text="<span>+</span>",
								controller="Correspondences",
								action="addLetterRow",
								class="add_letter_row small_admin_button green_admin_button")#
						</th>
					</tr>
				</tfoot>
			</table>
				
		</cfform>
		
	</div>
	
</cfoutput>
<script>
$(function () {
	$('.add_letter_row').live('click', function (e) {
		e.preventDefault();
		$('#flashMessages').show();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				$('#normal_letters_table tbody tr:last').after(data);
				$('#flashMessages').hide();
			}
		});
	});
	
	$('.remove_letter_row').live('click', function (e) {
		e.preventDefault();
		$('#flashMessages').show();
		var _tr = $(this).parent().parent();
		
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				_tr.remove();
				$('#flashMessages').hide();
			}
		});
	});
	
	<!---
		Zamykam okienko.
	--->
	$('.close_curtain').live('click', function (e) {
		$('.curtain').remove();
	});
	
	<!---
		Autozapisywanie wprowadzonej wartości w inputa
	--->
	$('#normal_letters_table input[type="text"], .typeid').live('change', function(e) {
		$('#flashMessages').show();
		
		$.ajax({
			type		:	'post',
			dataType	:	'html',
			async		:	false,
			data		:	{id:$(this).metadata().id,field_name:$(this).metadata().field_name,field_value:$(this).val()},
			url			:	"<cfoutput>#URLFor(controller='Correspondences',action='updateLetterField')#</cfoutput>",
			success		:	function(data) {
				$('#flashMessages').hide();
			}
		});
	});
	
	<!---
		Wybranie daty z listy
	--->
	$('.data_nadania, .pick_up_date').datepicker({
		dateFormat: 'yy-mm-dd',
		monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
		dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
		firstDay: 1
	});
	
	<!---
		Filtr po listach
	--->
	var myFORM = $('#letters_filter_form');
	myFORM.live('submit', function (e) {
		e.preventDefault();
		$('#flashMessages').show();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	myFORM.serialize(),
			url			:	myFORM.attr('action'),
			success		:	function (data) {
				$('#normal_letters_table tbody > tr').remove();
				$('#normal_letters_table tbody').append(data);
				$('#flashMessages').hide();
			}
		});
		return false;
	});
});
</script>