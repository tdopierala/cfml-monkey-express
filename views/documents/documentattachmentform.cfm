<cfprocessingdirective pageencoding="utf-8" />

<div class="documentAttachmentSubmitFileForm" style="width:99%;">

<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Formularz dodawania załącznika</h3>
	</div>
</div>
	
<cfform name="zalaczniki_do_faktury_form" action="index.cfm?controller=documents&action=document-attachment-form&documentid=#documentid#" enctype="multipart/form-data" target="myIframe">
	<cfinput type="hidden" name="documentid" value="#documentid#" /> 
		<ol class="horizontal">
			<li>
				<label for="file">Załącznik do faktury</label>
				<cfinput type="file" name="file"  /> 
			</li>
			<li>
				<label for="komentarz">Komentarz do pliku</label>
				<textarea class="textarea full p100" name="komentarz" ></textarea>
			</li>
			<li>
				<cfinput type="submit" class="admin_button green_admin_button"
						 name="zalaczniki_do_faktury_form_submit" value="Zapisz" />
			</li>
		</ol>
	</cfform>
</div>