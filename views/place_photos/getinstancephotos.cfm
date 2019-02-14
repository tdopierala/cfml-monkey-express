<cfoutput>

	<div class="wrapper">
		<div class="admin_wrapper">
			<h2 class="admin_photos">#myphototype.phototypename#</h2>

			<cfif flashKeyExists("success")>
				<div class="success">
					#flash("success")#
				</div>
			</cfif>

			<cfif flashKeyExists("error")>
				<div class="error">
					#flash("error")#
				</div>
			</cfif>

			<cfif flashKeyExists("fileErrors")>
				<div class="error">
					#flash("fileErrors")#
				</div>
			</cfif>

			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Miniaturka</th>
						<th>Data dodania</th>
						<th>Dodano przez</th>
						<th>Nazwa pliku</th>
						<th>Akcja</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="myphotos">
						<tr>
							<td>&nbsp;</td>
							<td class="c">
								<img src="files/places/#phototypethumb#" />
							</td>
							<td>#imageTag(source="clock.png",alt="Data i godzina")# #DateFormat(phototypecreated, "yyyy-mm-dd")# #TimeFormat(phototypecreated, "HH:mm")#</td>
							<td>#givenname# #sn# <br/><span class="i">#position#</span></td>
							<td>
								#linkTo(
									text=phototypename,
									href="files/places/#phototypesrc#",
									target="_blank")#
							</td>
							<td>
								#linkTo(
									text="<span>Usuń zdjęcie</span>",
									controller="Place_photos",
									action="delete",
									key=id,
									class="delete_photo")#
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>

			<h2 class="admin_newphoto">Dodaj zdjęcie do tej kategorii</h2>

			<cfform
				name="add_photo_to_instance_form"
				action="#URLFor(controller='Place_photos',action='actionAddPhotoToInstance')#"
				enctype="multipart/form-data"
				method="post">

				<cfinput
					type="hidden"
					name="phototypeid"
					value="#myphototype.id#" />

				<cfinput
					type="hidden"
					name="instanceid"
					value="#myinstance.instanceid#" />

			<table class="admin_table" id="new_photo_form">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Pole</th>
						<th>Wartość</th>
						<th>&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>&nbsp;</td>
						<td>Plik</td>
						<td>
							<cfinput
								type="file"
								name="phototypefile[#i#]"
								accept="image/jpg,image/png,application/pdf" />

							<span class="info">Maksymalna wielkość przesłanego pliku to 750KB</span>
						</td>
						<td>
							<a href="#URLFor(controller='Place_photos',action='addFileRow',key=i)#"
								class="add_file_row small_admin_button green_admin_button">

								+

							</a>
						</td>
					</tr>
				</tbody>
				<tfoot>
					<tr>
						<td colspan="4" class="r">
							<cfinput
								type="submit"
								class="admin_button green_admin_button"
								value="Zapisz"
								name="add_photo_to_instance_form_submit" />
						</td>
					</tr>
				</tfoot>
			</table>

			</cfform>

		</div>
	</div>
	<!---<div id="dispImage"></div>--->

</cfoutput>

<script>
<!---
function loadImages(flName) {
	var iwet="";
	setTimeout('loadImages(iwet)', 8000);
	var fullPath= "files/places/" + flName;
	document.getElementById('dispImage').innerHTML = "<img border='0' src="+fullPath+" />";

}
--->

$(function() {
	$('.add_file_row').live('click', function (e) {
		$('#flashMessages').show();
		var _l = $(this);

		e.preventDefault();

		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				_l.parent().append("&nbsp;");
				_l.remove();
				$('#new_photo_form tbody tr:last').after(data);
				$('#flashMessages').hide();
			}
		});
	});

	$('#add_photo_to_instance_form').submit(function () {
		$('#flashMessages').show();
	});

<!---
	var jForm = $("form#add_photo_to_instance_form");
	jForm.submit(
		function(objEvent){
			var jThis = $(this);
			document.getElementById('dispImage').innerHTML = "<img src='images/ajax-loader-3.gif' border='0' />";
			var strName = ("uploader" + (new Date()).getTime());
			var jFrame = $("<iframe name=\"" + strName + "\" src=\"about:blank\" />");
			jFrame.css("display", "none");
			jFrame.load(
				function(objEvent){
					var objUploadBody = window.frames[strName].document.getElementsByTagName("body")[0];
					var jBody = $(objUploadBody);
					// document.write(jBody.html());
					var objData = jBody.html();
					// prompt("Return Data:", objData);
					setTimeout(
						function(){
							jFrame.remove();
						},
						100
						);

						setTimeout(
						function(){
							loadImages(objData);
						},
						5000
						);
				}
			);

			$("body:first").append(jFrame);

			jThis
				.attr("action", jForm.attr("action"))
				.attr("method", "post")
				.attr("enctype", "multipart/form-data")
				.attr("encoding", "multipart/form-data")
				.attr("target", strName);
		}
	);
--->
});
</script>