<cfoutput>

	<div class="correspondence_modal_window_close close_curtain">[zamknij]</div>

	<div class="correspondence_modal_window">

		<cfform
			action="#URLFor(controller='Correspondences',action='printTodayList',params='format=pdf')#"
			name="newcorrespondenceform"
			target="_blank" >

		<table class="admin_table new_correspondence_table" id="correspondence">
			<thead>
				<tr>
					<th rowspan="2" class="first c">Lp.</th>
					<th rowspan="2" class="c">ADRESAT (imię i nazwisko lub nazwa)</th>
					<th rowspan="2" class="c">Dokładne miejsce doręczenia</th>
					<th colspan="2" class="c">Kwota zadekl. wart.</th>
					<th colspan="2" class="c">Masa</th>
					<th rowspan="2" class="c">Nr nadawczy</th>
					<th rowspan="2" class="c">Uwagi</th>
					<th colspan="2" class="c">Opłata</th>
					<th colspan="2" class="c">Kwota pobrania</th>
					<th rowspan="2" class="first">&nbsp;</th>
				</tr>
				<tr>
					<th class="first c">zł</th>
					<th class="first c">gr</th>
					<th class="first c">kg</th>
					<th class="first c">g</th>
					<th class="first c">zł</th>
					<th class="first c">gr</th>
					<th class="first c">zł</th>
					<th class="first c">gr</th>
				</tr>
			</thead>
			<tbody class="correspondence_body">
				<cfloop query="my_list">
				<tr>
					<td>
						<cfinput
							type="text"
							name="lp[#id#]"
							class="input first {id:#id#,field_name:'lp'}"
							value="#lp#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="adresat[#id#]"
							class="input {id:#id#,field_name:'adresat'} adresat"
							value="#adresat#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="miejsce_doreczenia[#id#]"
							class="input {id:#id#,field_name:'miejsce_doreczenia'} miejsce_doreczenia"
							value="#miejsce_doreczenia#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="kwota_zl[#id#]"
							class="input first {id:#id#,field_name:'kwota_zl'}"
							value="#kwota_zl#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="kwota_gr[#id#]"
							class="input first {id:#id#,field_name:'kwota_gr'}"
							value="#kwota_gr#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="masa_kg[#id#]"
							class="input first {id:#id#,field_name:'masa_kg'}"
							value="#masa_kg#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="masa_g[#id#]"
							class="input first {id:#id#,field_name:'masa_g'}"
							value="#masa_g#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="nr_nadawczy[#id#]"
							class="input {id:#id#,field_name:'nr_nadawczy'}"
							value="#nr_nadawczy#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="uwagi[#id#]"
							class="input {id:#id#,field_name:'uwagi'}"
							value="#uwagi#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="oplata_zl[#id#]"
							class="input first {id:#id#,field_name:'oplata_zl'}"
							value="#oplata_zl#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="oplata_gr[#id#]"
							class="input first {id:#id#,field_name:'oplata_gr'}"
							value="#oplata_gr#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="pobranie_zl[#id#]"
							class="input first {id:#id#,field_name:'pobranie_zl'}"
							value="#pobranie_zl#" />
					</td>
					<td>
						<cfinput
							type="text"
							name="pobranie_gr[#id#]"
							class="input first {id:#id#,field_name:'pobranie_gr'}"
							value="#pobranie_gr#" />
					</td>
					<td>
						#linkTo(
							text="<span>-</span>",
							controller="Correspondences",
							action="removeRow",
							key=id,
							class="remove_correspondence_row small_admin_button red_admin_button")#
					</td>
				</tr>
				</cfloop>
			</tbody>
			<tfoot>
				<tr>
					<th colspan="11" class="">
						<cfinput
							type="submit"
							name="newcorrespondencesubmit"
							class="admin_button green_admin_button print_today_list"
							value="Zapisz jako PDF" />
					</th>
					<th colspan="3">
						#linkTo(
							text="<span>+</span>",
							controller="Correspondences",
							action="addRow",
							class="add_row small_admin_button green_admin_button")#
					</th>
				</tr>
			</tfoot>
		</table>

		</cfform>

	</div>

</cfoutput>
<script>
$(function () {
	<!---
		Usunięcie wiersza korespondencji.
	--->
	$('.remove_correspondence_row').live('click', function (e) {
		e.preventDefault();
		$('#flashMessages').show();
		var _tr = $(this).parent().parent();
		$.ajax({
			type		:	'post',
			dataType	:	'html',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				_tr.remove();
				$('#flashMessages').hide();
			}
		});
	});

	$('.add_row').live('click', function (e) {
		e.preventDefault();
		$.ajax({
			type		:	'post',
			dataType	:	'html',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function(data) {
				<!---
					Wstawiam nowy wiersz na koniec sekcji tbody.
				--->
				$('.new_correspondence_table tbody tr:last').after(data);
			}
		});
	});

	$('.correspondence_body input[type="text"]').live('change', function(e) {
		$('#flashMessages').show();

		$.ajax({
			type		:	'post',
			dataType	:	'html',
			async		:	false,
			data		:	{id:$(this).metadata().id,field_name:$(this).metadata().field_name,field_value:$(this).val()},
			url			:	"<cfoutput>#URLFor(controller='Correspondences',action='updateField')#</cfoutput>",
			success		:	function(data) {
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
		Autouzupełnianie na adresacie.
	--->
	$('.adresat').live('keyup', function (e) {
		var _field = $(this);
		$(this).autocomplete({
			source: function (request, response) {
				$.ajax({
					url			:	"<cfoutput>#URLFor(controller='Correspondences',action='autocomplete')#</cfoutput>",
					datatype	:	'jsonp',
					data: {
						search: request.term
					},
					success		:	function(data) {
						response($.map(data.ROWS, function(item) {
							return {
								label: item.ADRESAT,
								value: item.ADRESAT,
								tmp: item.MIEJSCE_DORECZENIA
							}
						}));
					}
				});
			},
			select				:	function(element, ui) {
				<!---
					Po wybraniu opcji AJAXowo zapisuje ją w formularzu.
				--->
				$('#flashMessages').show();
				$.ajax({
					type		:	'post',
					dataType	:	'html',
					async		:	false,
					data		:	{id:_field.metadata().id,field_name:_field.metadata().field_name,field_value:ui.item.value},
					url			:	"<cfoutput>#URLFor(controller='Correspondences',action='updateField')#</cfoutput>",
					success		:	function(data) {
						$('#flashMessages').hide();
					}
				});

				<!---
					Zapisanie pola z miejscem doręczenia
				--->
				var _next = $(this).parent().parent().find('.miejsce_doreczenia');
				$(this).parent().parent().find('.miejsce_doreczenia').val(ui.item.tmp);
				$('#flashMessages').show();
				$.ajax({
					type		:	'post',
					dataType	:	'html',
					async		:	false,
					data		:	{id:_next.metadata().id,field_name:_next.metadata().field_name,field_value:ui.item.tmp},
					url			:	"<cfoutput>#URLFor(controller='Correspondences',action='updateField')#</cfoutput>",
					success		:	function(data) {
						$('#flashMessages').hide();
					}
				});
			}
		});
	});
});
</script>