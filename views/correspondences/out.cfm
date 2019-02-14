<cfoutput>

	<div class="correspondence_modal_window_close close_curtain">[zamknij]</div>

	<div class="correspondence_modal_window">

		<cfform
			name="correspondence_in_edit_form"
			action="" >

			<table class="admin_table " id="correspondence_out_table_edit">
				<thead>
					<tr>
						<th class="c">Data wysłania</th>
						<th class="c">Typ przesyłki</th>
						<th class="c">Kategoria</th>
						<th class="c">Ilość</th>
						<th class="c">Uwagi</th>
					</tr>
				</thead>
				<tbody>

				</tbody>
				<tfoot>
					<tr>
						<th colspan="9">
							#linkTo(
								text="<span>+ wiersz</span>",
								controller="Correspondences",
								action="addOutRow",
								class="admin_button green_admin_button add_in_row")#
						</th>
					</tr>
				</tfoot>
			</table>

		</cfform>

	</div>

</cfoutput>

<script>
$(function(){
	$('.add_in_row').die("click").live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();

		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('#correspondence_out_table_edit tbody').append(data);
				$('#flashMessages').hide();
			}
		});
	});

	$('#correspondence_out_table_edit input[type="text"], #correspondence_out_table_edit select').live('change', function(e) {
		$('#flashMessages').show();

		$.ajax({
			type		:	'post',
			dataType	:	'html',
			async		:	false,
			data		:	{id:$(this).metadata().id,field_name:$(this).metadata().field_name,field_value:$(this).val()},
			url			:	"<cfoutput>#URLFor(controller='Correspondences',action='updateCorrespondenceOut')#</cfoutput>",
			success		:	function(data) {
				$('#flashMessages').hide();
			}
		});
	});
});
</script>

<script>
$(function(){

});
</script>