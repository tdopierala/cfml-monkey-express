<cfprocessingdirective pageEncoding="utf-8" />

<div class="cfwindow_container">

	<cffileupload
		url="#URLFor(controller='User_photos',action='uploadFile')#"
		progressbar="true"
		name="file"
		addButtonLabel="Dodaj plik"
		clearButtonlabel="Wyczyść" 
		hideUploadButton="false"
		height=200
		title="Zdjęcia"
		maxuploadsize="50"
		extensionfilter="*.png,*.jpg,*.jpeg"
		MAXFILESELECT=8
		onuploadcomplete="afterUploadFile"
		UPLOADBUTTONLABEL="Zapisz pliki"
		deletebuttonlabel="Usuń"/>
		
</div>

<script>

function afterUploadFile(response){
	console.log(response);

}
</script>