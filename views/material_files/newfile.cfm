<cfoutput>
	
	<div class="new_material_description">
		
		<span class="close_curtain">[zamknij]</span>
		
		<h5>Nowy plik</h5>
		
		<cfform
			action="#URLFor(controller='Material_files',action='actionNewFile')#"
			name="newfileform" >
				
			<ol class="horizontal">
				
				<li>
					<label for="folderid">Zapisz w materiale</label>
					<select name="materialid" size="4" class="select_box_size" id="materialid">
					<cfloop query="materials">
						<option value="#materialid#">#materialname# (#foldername#)</option>
					</cfloop>
					</select>
				</li>
				
				<li>
					<label for="materialnote">Notatka do pliku</label>
					<cftextarea
						name="filenote"
						class="textarea ckeditor" >
							
					</cftextarea>
				</li>
				
				<li>
					<cfinput
						type="file"
						name="materialfile" />
				</li>
				
				<li>
					<cfinput
						type="submit"
						name="newfilesubmit"
						class="admin_button green_admin_button"
						value="Zapisz" />
				</li>
				
			</ol>
				
		</cfform>
		
	</div>
	
</cfoutput>

<script>
$(function() {
	var jForm = $("#newfileform");
 
	jForm.bind('submit', function (e) {
		var jThis = $(this);
		var strName = ("uploader" + (new Date()).getTime());
		var jFrame = $("<iframe name=\"" + strName + "\" src=\"about:blank\" />");
		jFrame.css("display", "none");
		jFrame.load(
		function(e){
			var objUploadBody = window.frames[strName].document.getElementsByTagName("body")[0];
			var jBody = $(objUploadBody);
			setTimeout(
				function(){
					jFrame.remove();
				}, 100);
		});
 
		$("body:first").append(jFrame);
		jThis
			.attr("action", jForm.attr("action"))
			.attr("method", "post")
			.attr("enctype", "multipart/form-data")
			.attr("encoding", "multipart/form-data")
			.attr("target", strName);
	});

});
</script>