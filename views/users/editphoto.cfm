<cfoutput>

	<div class="wrapper "><!---modalEditPhoto--->
		
		<h3>Edytuj zdjęcie</h3>
		
		<div class="wrapper wrapper-field user-photo-form-edit">
			<form 
				action="#URLFor(controller='Users',action='uploadPhoto')#" 
				id="userimguploadform" 
				method="post" 
				enctype="multipart/form-data">
					
				<fieldset>
					<!---<legend>Zdjęcie użytkownika</legend>--->
					<ol>
						<li>
							<label>Edytujesz zdjęcie użytkownnika:</label>
							<h4>#user.givenname# #user.sn#</h4>
							<!---#imageTag("avatars/thumbnailsmall/#user.photo#")#--->
						</li>
						<li class="imageForm">
							<label>Zdjęcie w formacie *.jpg lub *.png. Maksymalna wielkość pliku: 5MB.</label>
							<div class="user-photo-select-field">
								<div class="user-photo-select-field-text">
									Przeciągnij zdjęcie tutaj 
									<br />-- LUB --
									<br />kliknij aby otworzyć przeglądarkę plików
								</div>
								<input 
									name="imagedata" 
									type="file"
									class="imageinstancecontent input_file" />
							</div>
						</li>
					</ol>
				</fieldset>
				
				<div id="imageprogressbar" class="progressbar"></div>
				
			</form>
		</div>
		
		<div class="wrapper wrapper-field user-photo-field-edit">
			
		</div>
		
		<div class="wrapper wrapper-field">
			<span class="user_img size_x"></span>
			<span class="user_img size_x"></span>
			<span class="user_img size_x"></span>
			<span class="user_img size_x"></span>
			#submitTag(value="Zapisz zdjęcie", class="formButton button redButton cropImage")#
		</div>
		
		<!---<div class="forms">
			#startFormTag(
				action="ajaxActionEditPhoto",
				multipart=true,
				class="ajaxEditPhoto")#
			
				<cfif #session.userid# eq 2>
				
					#hiddenFieldTag(name="userid",value="#params.key#")#
				
				<cfelse>
				
					#hiddenFieldTag(name="userid",value="#session.userid#")#
				
				</cfif>
				#hiddenFieldTag(name="photo",class="userphotosrc",value="")#
				
			<ol>
				<li>
					#fileFieldTag(
						name="userphoto",
						class="userphoto",
						label="",
						labelPlacement="before")#
				</li>
				<li class="uploadifymessages"></li>
				<li class="userphotothumbnail"></li>
				<li class="thumbpreview"></li>
				<li>
					#submitTag(value="Zapisz",class="button darkGrayButton editUserPhotoButton",disabled="disabled")#
				</li>
			</ol>
			#endFormTag()#
		</div>--->
	
	</div>

</cfoutput>

<script>	
	$(function(){
		var timebox, time=0;
		
		function progress(obj){
			time += 5;
			
			if( time < 90 ){ 
				obj.progressbar( "option", "value", time ); } 
			else { 
				obj.progressbar( "option", "value", false ); 
				clearInterval(timebox); 
			}
		}
		
		function saveImgCoords(c){
			$("#user-photo-editor-image").data("size", { x1:c.x, y1:c.y, x2:c.x2, y2:c.y2, h:c.h, w:c.w });
		};
		
		$("#user_profile_cfdiv").on("mouseenter", '#userimguploadform', function(){
			$(this).ajaxForm(form_options);
		});
		
		var form_options = {
			dataType	: 'json',
			type		: 'post',
			url		: "<cfoutput>#URLFor(controller='Users',action='uploadPhoto')#</cfoutput>",
			beforeSubmit: function(arr, $form, options){
				
				$("#imageprogressbar").show();
				timebox = setInterval( function(){ 
					progress( $("#imageprogressbar") ); 
				} ,100);
				
			},
			success: function (responseText, statusText, xhr, $form){
				
				clearInterval(timebox);
				
				var img = document.createElement('img');
				img.setAttribute('src', 'images/users/'+responseText.sfilename);
				img.setAttribute('alt', responseText.sfilename);
				img.id='user-photo-editor-image';
				
				$(".user-photo-field-edit").html(img);
				$("#user-photo-editor-image").Jcrop({
					onChange	: saveImgCoords,
					onSelect	: saveImgCoords,
					setSelect	: [ 50, 50, 300, 300 ],
					minSize		: [ 150, 150 ],
            		aspectRatio	: 1
				});
				
				$("#user-photo-editor-image").data("name", responseText.sfilename);
				
				$("#imageprogressbar").progressbar( "option", "value", 100 );
				
				$('.user-photo-field-edit').fadeIn();
				$('.user-photo-form-edit').slideUp();
				
				//alert(responseText.cfilename);
				/*$('.imageForm').append('<div class="productimg"><a href="files/products/images/' 
					+ responseText.sfilename + '">'
					+ '<img src="files/products/images/' + responseText.thumbnail + '" alt="' 
					+ responseText.cfilename + '" /></a></div>');*/
					
				//$('.imageForm').children(".productimg").fadeIn("slow");
				
				//$("#imageprogressbar").slideUp();
				
				//$("#product-form").append('<input type="hidden" name="product[image]" value="' + responseText.sfilename + '" />');
			}
		};
		
		$("#user_profile_cfdiv").on("change", ".imageinstancecontent", function(){
			
			var i = 0, error = new Array();
			time=0;
			$("#imageprogressbar").progressbar({ value: 0 });
			
			$(".user-photo-select-field").nextAll().remove();
			
			if (window.FileReader) {
				//("The file API isn't supported on this browser yet.");
				
				file = $(this);
				
				if(file[0].files[0].size > 5000000)
					error.push("Rozmiar pliku przekracza dopuszczalne maksimum 5MB.");
					
				if(	   file[0].files[0].type != 'image/jpeg' 
					&& file[0].files[0].type != 'image/png')
					error.push("Nieprawidłowy format pliku.");
					
				var ext = $(this).val().toString().toLowerCase().split(".");
				if(    ext[ ext.length-1 ] != 'jpg' 
					&& ext[ ext.length-1 ] != 'jpeg' 
					&& ext[ ext.length-1 ] != 'png')
					error.push("Dopuszczalne formaty plików: .jpg lub .png");
					
					
				if(error.length > 0) {
					
					console.log(error);
					
					for(var a=0; a<error.length; a++){
						
						var $obj = $('<p></p>').addClass("errorMsg").text(error[a]).fadeIn();
						$(".user-photo-select-field").after($obj);
						
					}
					
				} else {
					
					console.log("image form submit");
					$("#userimguploadform").submit();
						
				}
			}
			
		});
		
		$("#user_profile_cfdiv").on("click", ".cropImage", function(){
			
			var $img = $("#user-photo-editor-image");
					
			if($img.length > 0){
				
				var c = $img.data("size");
				
				$.post(
					<cfoutput>"#URLFor(controller='Users',action='actionEditPhoto', key=params.key)#"</cfoutput>,
					{ x1:c.x1, y1:c.y1, x2:c.x2, y2:c.y2, w:c.w, h:c.h, filename: $("#user-photo-editor-image").data("name")},
					function(data){
						document.location = <cfoutput>"#URLFor(controller='Users',action='view', key=params.key)#"</cfoutput>
					}, 'json'
				);
			} else {
				alert('Brak wybranego zdjęcia');
			}
			
			//alert($("#user-photo-editor-image").data("size").serialize());
			
			return false;
		});
		
	});	
</script>

<!---	<script type="text/javascript">
	
		// Przesyłanie pliku na serwer
		$('.userphoto').uploadify({
			'uploader'  	:	<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/uploadify/uploadify.swf"</cfoutput>,
			'script'    	:	<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/userphoto.cfm"</cfoutput>,
			'cancelImg' 	:	<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/uploadify/cancel.png"</cfoutput>,
			'folder'    	:	<cfoutput>"#ExpandPath('images/avatars/')#"</cfoutput>,
			'auto'      	:	true,
			'buttonText'	:	'Wybierz plik',
			'displayData'	:	'percentage',
			'fileExt'		:	'*.png;*.gif;*.jpg',
			'fileDesc'		:	'Tylko pliki graficzne (*.jpg, *.gif, *.png)',
			'onError'		:	function (event, ID, fileObj, errorObj) {
	      		$('.uploadifymessages').append('<div class="documentUploadStatus no">' + errorObj.type + ' Błąd ' + errorObj.info + '</div>');
			},
			'onComplete'  : function(event, ID, fileObj, response, data) {
				var json = jQuery.parseJSON(response);
				var file = (json != null) ? json.file : '';
				var thumbnail = (json != null) ? json.thumbnail : '';
				
				$('.editUserPhotoButton').attr("disabled", false); 
				$('.userphotosrc').val(file);
				$('.thumbpreview').html("<img src=\"images/avatars/thumbnail/" + thumbnail + "\" />");
				$('.uploadifymessages').append('<div class="documentUploadStatus ok">Plik został prawidłowo zapisany na serwerze.</div>');
				
				$('#userphotothumbnail').val(thumbnail);
				
			}
	    }); // Koniec przesyłania pliku na serwer
	
	</script>--->