<cfoutput>

	<div class="wrapper">
	
		<h5>Przypisane zdjęcia</h5>
		
		<div class="placegallery">
			
			<ul>
			<cfloop query="photos">
			
				<li>
					<span class="placeimagetitle">#placefilecategoryname#</span>
					<img src="files/places/#place.id#/#filename#" />
					#checkBoxTag(
						name="toexport",
						checked=YesNoFormat(toexport),
						label=false,
						class="toexportphoto {id:#id#, fileid:#fileid#, placeid:#place.id#}")#

				</li>
			
			</cfloop>
			</ul>
			
		</div>
	
	</div>

</cfoutput>

<script>

$(function() {
	$('.toexportphoto').live('click', function(e) {
		
		var id = $(this).metadata().id;
		
		$.ajax({
			type: 'post',
			dataType: 'html',
			data: {key:id},
			url: <cfoutput>"#URLFor(controller='Places',action='toExport',params='cfdebug')#"</cfoutput>,
			success: function(data) { 
			}
		});
		
	});
});

</script>