<cfoutput>
	
	<div class="wrapper">
		
		<cfif flashKeyExists("success")>
	    	<span class="success">#flash("success")#</span>
		</cfif>
		
		<h3>Formularz dodawanie nowej treści do pomysłu</h3>
		
		<div class="forms ideaForm">
			#startFormTag(action="create-text", multipart="true", id="text-form")#
			
			#hiddenField(objectName="text", property="ideaid")#
			
				<ol>
					<li class="title">Dodawanie nowej treści do pomysłu</li>
					<li>
						#textArea(objectName="text", property="text", label="Nowa treść pomysłu", labelPlacement="before", class="textarea ckeditor")#
					</li>
					<!---<li>
						#fileField(objectName="text", property="file", label="Plik do załączenia (np. pdf, jpg)", labelPlacement="before")#
					</li>--->
				</ol>
				<div id="documentInstance-file" class="ideas-documentInstance-file"></div>
		
			#endFormTag()#
		
			<div class="invoiceForm">
				#startFormTag(action="uploadFile",multipart=true,class="ajaxFormUploadDocument")#
				
					<ol>
						<li>
							#fileFieldTag(
								name="filedata", 
								label="Plik do załączenia (np. pdf, jpg)",
								class="documentinstancecontent",
								labelPlacement="before")#
							<!---#submitTag(value="Wyślij", class="formButton button redButton")#--->
						</li>
					</ol>
				
				#endFormTag()#
			</div>
			
			<div id="documentInstance-thumbnail" class="ideas-documentInstance-thumbnail"></div>
		
			<div id="form-submit" class="ideas-new-submit">#submitTag(value="Wyślij", class="formButton button redButton")#</div>
			
		</div>
	</div>
	
</cfoutput>

<script type="text/javascript">
// <![CDATA[

$(function() {
	
	// Przesyłanie pliku na serwer
	$('.documentinstancecontent').uploadify({
		'uploader'  	:	<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/uploadify/uploadify.swf"</cfoutput>,
		'script'    	:	<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/upload_idea.cfm"</cfoutput>,
		'cancelImg' 	:	<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/uploadify/cancel.png"</cfoutput>,
		'folder'    	:	<cfoutput>"#ExpandPath('files/ideas/')#"</cfoutput>,
		'auto'      	:	true,
		'buttonText'	:	'Wybierz plik',
		'displayData'	:	'percentage',
		'fileExt'		:	'*.pdf; *.jpg; *.png',
		'fileDesc'		:	'pdf, jpg, png',
		
		
		'onError'		:	function (event, ID, fileObj, errorObj) {
			
			//alert(errorObj.info);
      		$('.invoiceForm').append('<div class="documentUploadStatus ok">' + errorObj.type + ' Błąd ' + errorObj.info + '</div>');
		
		},
		'onComplete'	:	function (event, ID, fileObj, response, data) {
			
			//alert('complete!');
			
			var json = jQuery.parseJSON(response);			
			var file = (json != null) ? json.cfilename : '';
			var thumbnail = (json != null) ? json.thumbnail : '';
			
			$('.invoiceForm').append('<div class="documentUploadStatus ok">Plik ' + file + ' został prawidłowo zapisany na serwerze.</div>');
			$('#documentInstance-file').append('<input type="hidden" name="text[file]" value="' + json.sfilename + '" />');
			$('#documentInstance-thumbnail').append('<div class="thumb"><img src="files/ideas/' + thumbnail + '" alt="' + json.sfilename + '" /></div>');
			
			//window.open(<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/files/ideas/"</cfoutput> + file, 'Podgląd dokumentu', 'width=800', 'height=600');
		}
    }); // Koniec przesyłania pliku na serwer
    
	$("#form-submit input").click(function(){
		$("#text-form").submit();
	});
	
});

// ]]>
</script>