<cfoutput>
	
	<div class="new_material_description">
		
		<span class="close_curtain">[zamknij]</span>
		
		<h5>Dokumenty</h5>
		
		<div class="scroll_materials">
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa strony</th>
					<th>Dodano przez</th>
					<th>Data dodania</th>
					<th>&nbsp;</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="pages">
					<tr>
						<td class="first">&nbsp;</td>
						<td>#pagename#</td>
						<td>#givenname# #sn#</td>
						<td>#pagecreated#</td>
						<td>
							#linkTo(
								text="<span>Eksportuj do PDF</span>",
								controller="Material_pages",
								action="view",
								key=pageid,
								params="format=pdf",
								target="_blank",
								class="pdf")#
						</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		</div>
		
	</div>
	
</cfoutput>

<script>
$(function() {
	var myFORM = $('#newmaterialform');
	myFORM.bind('submit', function (e) {
		e.preventDefault();
		
		<!---var myDATA = myFORM.serialize();
		var editorDATA = CKEDITOR.instances.materialnote.getData();
		myDATA += '&materialnote='+editorDATA;--->
		
		$.ajax({
			dataType	:	'html',
			data: {
				materialname: $('#materialname').val(),
				folderid: $('#folderid option:selected').val(),
				materialnote: CKEDITOR.instances.materialnote.getData()
			},
			type		:	'post',
			url			:	myFORM.attr('action'),
			success		:	function(data) {
				$('.curtain').remove();
			}
		});
		
		return false;
	});
});
</script>