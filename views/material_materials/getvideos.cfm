<cfoutput>
	
	<div class="new_material_description">
		
		<span class="close_curtain">[zamknij]</span>
		
		<h5>Video</h5>
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Nazwa pliku</th>
					<th>Data dodania</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="videos">
					<tr>
						<td class="first">&nbsp;</td>
						<td>
							#linkTo(
								text=videoname,
								controller="Material_videos",
								action="view",
								key=videoid,
								class="view_video",
								title="Oglądaj",
								name="#videoname#")#
						</td>
						<td>#DateFormat(created, "dd-mm-yyyy")#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		
	</div>
	
</cfoutput>

<script>
$(function () {
	$('.view_video').live('click', function (e) {
		e.preventDefault();
		var windowName = $(this).attr("name");
		window.open($(this).attr('href'), windowName, 'width=720,height=480,menubar=no,toolbar=no,titlebar=no,location=no');	

	});
});
</script>