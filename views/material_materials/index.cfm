<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Materiały szkoleniowe</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		
		<cfinvoke
			component="controllers.Tree_groupusers"
			method="checkUserTreeGroup"
			returnvariable="priv" >

			<cfinvokeargument
				name="groupname"
				value="Dodawanie materiałów" />

		</cfinvoke>

		<cfif priv is not false>

		<div class="material_navigation">
			<div class="inner">
			<ul>
				<li>
					<a 
						href="<cfoutput>#URLFor(controller='Material_materials',action='newMaterial')#</cfoutput>"
						class="new_material"
						title="Dodaj nowy materiał">
						<span>Dodaj materiał</span>		
					</a>
				</li>
				<li>
					<a 
						href="<cfoutput>#URLFor(controller='Material_pages',action='newPage')#</cfoutput>"
						class="new_page"
						title="Dodaj dokument">
						<span>Dodaj dokument</span>		
					</a>
				</li>
				<li>
					<a 
						href="<cfoutput>#URLFor(controller='Material_files',action='newFile')#</cfoutput>"
						class="new_file"
						title="Dodaj plik">
						<span>Dodaj plik</span>		
					</a>
				</li>
				<li>
					<a 
						href="<cfoutput>#URLFor(controller='Material_videos',action='newVideo')#</cfoutput>"
						class="new_video"
						title="Dodaj video">
						<span>Dodaj video</span>		
					</a>
				</li>
				<li>
					<a 
						href="<cfoutput>#URLFor(controller='Material_folders',action='new')#</cfoutput>"
						class="new_folder"
						title="Dodaj katalog">
						<span>Dodaj katalog</span>		
					</a>
				</li>
			</ul>
			</div>
		</div>

		</cfif>
		
		<div class="material_folder_browser left">

			<div class="tree_browser">

				<select name="folderid" size="12" class="select_box_full" id="folderid">
				<cfloop query="folder_tree">
					<option value="<cfoutput>#folderid#</cfoutput>" class="level<cfoutput>#level#</cfoutput>"><cfoutput>#foldername#</cfoutput></option>
				</cfloop>
				</select>

			</div>

		</div> <!--- end .material_folder_browser --->

		<div class="material_folder_content right">

			<div class="element_content">

			</div>

		</div>

		<div class="uiFooter">
		</div>
	</div>
</div>

<div class="footerArea">

</div>

<script>
$(function() {

	$('#folderid').live('change' ,function() {
		$.ajax({
			type		:	'post',
			dataType	:	'json',
			data		:	{key:$(this).val()},
			url			:	"<cfoutput>#URLFor(controller='Material_materials',action='getMaterials')#</cfoutput>",
			success		:	function(data) {
				<!---
					Dodaję listę materiałów szkoleniowych
				--->
				$('.material_folder_content .element_content').empty();

				$.each(data.ROWS, function(i, item) {
					var myMATERIAL = "<div class=\"material_item\">"
						+ "<h5>" + item.MATERIALNAME + "</h5>"
						+ "<div class=\"material_details\">Utworzone przez" + item.GIVENNAME + " " + item.SN + " dnia " + item.MATERIALCREATED + "</div>"
						+ "<div class=\"material_description\">" + item.MATERIALNOTE + "</div>"
						+ "<div class=\"material_summary\"><a href=\"index.cfm?controller=material_materials&action=get-files&key="+item.ID+"\" class=\"get_files\">Pliki</a> ("+item.FILESCOUNT+") <a href=\"index.cfm?controller=material_materials&action=get-pages&key="+item.ID+"\"class=\"get_pages\">Dokumenty</a> ("+item.PAGESCOUNT+") <a href=\"index.cfm?controller=material_materials&action=get-videos&key="+item.ID+"\"class=\"get_videos\">Video</a> ("+item.VIDEOSCOUNT+")</div>"
						+ "</div>";

					$('.material_folder_content .element_content').append(myMATERIAL);
				});
			}
		});
	});

	<!---
		Dodawanie nowego materiału szkoleniowego.
		Generowane jest nowe okienko na środku ekranu z formularzem dodawania
		nowego materiału. MAteriał musi być przypisany do określonego katalogu.
	--->
	$('.new_material').die('click').live('click', function (e) {
		e.preventDefault();

		$.ajax({
			type		:	'post',
			dataType	:	'html',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				console.log(CKEDITOR);
				CKEDITOR.replace('materialnote');

			}
		});
	});

	<!---
		Dodawanie nowej strony do materiałów szkoleniowych.
		Strony są przypinane do materiałów. Nie może być dodanej strony,
		która nigdzie nie jest przypisana.
	--->
	$('.new_page').die('click').live('click', function (e) {
		e.preventDefault();

		$.ajax({
			type		:	'post',
			dataType	:	'html',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				console.log(CKEDITOR);
				CKEDITOR.replace('pagecontent');

			}
		});
	});

	<!---
		Pobieram strony, które są przypisane do materiału.
	--->
	$('.get_pages').die('click').live('click', function (e) {
		e.preventDefault();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
			}
		});
	});

	<!---
		Pobieram listę plików, które są przypisane do materiału szkoleniowego
	--->
	$('.get_files').die('click').live('click', function (e) {
		e.preventDefault();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
			}
		});
	});

	<!---
		Pobieram listę plików video przypisanych do materiału
	--->
	$('.get_videos').die('click').live('click', function (e) {
		e.preventDefault();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
			}
		});
	});

	<!---
		Pobieram formularz dodawnia nowego pliku do materiału szkoleniowego.
	--->
	$('.new_file').die('click').live('click', function (e) {
		e.preventDefault();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				CKEDITOR.replace('filenote');
			}
		});
	});

	<!---
		Okienko do zarządzania katalogami.
	--->
	$('.new_folder').die('click').live('click', function (e) {
		e.preventDefault();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
			}
		});
	});

	<!---
		Okienko dodawania plików video.
	--->
	$('.new_video').die('click').live('click', function (e) {
		e.preventDefault();
		$.ajax({
			dataType	:	'html',
			type		:	'post',
			data		:	{},
			url			:	$(this).attr('href'),
			success		:	function (data) {
				$('body').append("<div class=\"curtain\"></div>");
				$('.curtain').append(data);
				CKEDITOR.replace('videonote');
			}
		});
	});

	<!---
		Zamykam okienko.
	--->
	$('.close_curtain').live('click', function (e) {
		$('.curtain').remove();
	});
});
</script>