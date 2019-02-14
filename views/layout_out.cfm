<cfajaximport tags="cfform,cfwindow,cffileupload,cfinput-datefield " />

<cfparam
	name="title"
	type="string" />

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset=utf-8>
		<meta name="viewport" content="width=1200">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<!---<cfheader name="expires" value="#Now()#" />--->
		<!---<cfheader name="pragma" value="no-cache" />--->
		<!---<cfheader name="cache-control" value="no-cache, no-store, must-revalidate" />--->

		<!--- Główne style --->
		<cfoutput>#styleSheetLinkTag("reset,style,main,jquery.Jcrop,prettyPhoto")#</cfoutput>
		
<cfcache
	timespan="#createTimespan(0, 1, 0, 1)#" >
	
		<!--- jquery-ui-1.10.1.custom.min <==> blitzer/jquery-ui-1.8.16.custom --->
		<cfoutput>#styleSheetLinkTag("blitzer/jquery-ui.min.css,jquery-ui-timepicker-addon,flexigrid,flexigrid.pack,basic,uploadify")#</cfoutput>

		<!---<link href="/<cfoutput>#get('loc').intranet.directory#</cfoutput>/stylesheets/style.css?<cfoutput>#DateFormat(Now(), "ddmmyyyy")##TimeFormat(Now(), "HHmmssll")#</cfoutput>" rel="stylesheet" type="text/css" />--->

		<cfoutput>#javaScriptIncludeTag("jquery-1.8.0.min,jquery-ui-1.10.1.custom.min,globalize,globalize.culture.pl-PL,jquery.filter_input,jquery-ui-timepicker-addon,jquery.metadata,jquery.dataTables.min,flexigrid,flexigrid.pack,jquery.simplemodal.1.4.3.min,intranet,picnet.table.filter.min,jquery.form,jquery.Jcrop,jquery.prettyPhoto,jquery.simple.class.creation,jquery.tablesorter")#</cfoutput>
		
		<!--- jQuery EasyUI 1.3.4 --->
		<!---<cfoutput>#javaScriptIncludeTag("jquery.easyui.1.3.4/jquery.easyui.min,jquery.easyui.1.3.4/datagrid-detailview")#</cfoutput>--->

        <!--- ExtJS library 3.4 --->
        <!---<cfoutput>#javaScriptIncludeTag("ext-3.4.0/adapter/ext/ext-base-debug,ext-3.4.0/ext-all-debug")#</cfoutput>--->
		<!--- ExtJS library 4.0.7 --->
 		<!---<cfoutput>#javaScriptIncludeTag("ext-4.0.7-gpl/ext-all-debug")#</cfoutput>--->
        <!--- uploadify --->
        <cfoutput>#javaScriptIncludeTag("uploadify/swfobject,uploadify/jquery.uploadify.v2.1.4.min")#</cfoutput>
		<!--- okienko modalne z komunikatem o ładowaniu strony --->
		<cfoutput>#javaScriptIncludeTag("flashmessages,ajaxlinks")#</cfoutput>
		<!--- walidacja pól formularza --->
		<cfoutput>#javaScriptIncludeTag("validation")#</cfoutput>
		<!--- Zakładki rozwiązujące problem guzika wstecz --->
		<cfoutput>#javaScriptIncludeTag("bookmarks")#</cfoutput>
		<!--- Autouzupełnianie --->
<!--- 		<cfoutput>#styleSheetLinkTag('jquery.autocomplete')#</cfoutput> --->
<!--- 		<cfoutput>#javaScriptIncludeTag('jquery.autocomplete-min')#</cfoutput> --->

		<!--- Funkcje js wykorzystywane w aplikacji --->
		<cfoutput>#javaScriptIncludeTag("functions")#</cfoutput>

		<!--- jWYSIWYG --->
		<!---<cfoutput>#javaScriptIncludeTag("jwysiwyg/jquery.wysiwyg,jwysiwyg/controls/wysiwyg.image,jwysiwyg/controls/wysiwyg.link,jwysiwyg/controls/wysiwyg.table")#</cfoutput>--->
		<!---<cfoutput>#styleSheetLinkTag("../javascripts/jwysiwyg/jquery.wysiwyg")#</cfoutput>--->

		<!--- Ajax File Upload --->
		<cfoutput>#javaScriptIncludeTag("ajaxfileupload")#</cfoutput>

</cfcache>

		<!--- Mapki Google --->
		<!--- Załączam Google Map do modułu nieruchomości --->
		<!---<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>--->
		<!---<script src="http://maps.googleapis.com/maps/api/js?libraries=places&sensor=false" type="text/javascript"></script>--->
		<!---<cfoutput>#javaScriptIncludeTag("googlemap")#</cfoutput>--->

<cfcache
	timespan="#createTimespan(0, 1, 0, 16)#" >

		<!--- CKEditor --->
		<!---<cfoutput>#javaScriptIncludeTag('ckeditor_4.0.1/ckeditor,ckeditor_4.0.1/adapters/jquery')#</cfoutput>--->
		<cfoutput>#javaScriptIncludeTag('ckeditor/ckeditor,ckeditor/adapters/jquery')#</cfoutput>
		<cfoutput>#javaScriptIncludeTag('ckfinder/ckfinder')#</cfoutput>
		
		<!--- Ajaxowe dodawanie plików --->
		<!--- Załączam style dla Ajaxowego dodawania plików --->
 		<!---<cfoutput>#styleSheetLinkTag("fileuploader")#</cfoutput>--->

		<!--- Sortowanie listy nested set --->
		<cfoutput>#javaScriptIncludeTag("jquery.mjs.nestedSortable")#</cfoutput>
		
		<!--- Google jsapi --->
		<script type="text/javascript" src="https://www.google.com/jsapi"></script>
		<script type="text/javascript" src="javascripts/jquery.fancybox.js?v=2.1.5"></script>
		<link rel="stylesheet" type="text/css" href="stylesheets/jquery.fancybox.css?v=2.1.5" media="screen" />
		
</cfcache>

		<title><cfoutput>#title#</cfoutput></title>

	</head>
	<body>
		<div id="flashMessages" style="display: none;"><cfoutput>#imageTag('ajax-loader-1.gif')#</cfoutput>Pobieram dane…</div>

		<div id="container">
			<!---
				2.04.2013
				Usuwam header. Wzoruje się na wyglądzie Facebook.
			--->
			<!---
			<div id="header">
				<div class="width">
					<cfinclude template="header.cfm" >
				</div>
			</div>
			--->

			<div id="content">
				<div class="width">
					
					<div class="wrapAll">

							<cfdiv
								id="intranet_left_content">

								<cfoutput>#includeContent()#</cfoutput>

							</cfdiv>
						<div class="clear"></div>
					</div>
				</div>
			</div>
			<div class="clear"></div>
			<div id="footer">
				<div class="width">
				</div>
			</div>

		</div>
		<div id="modal"></div>

		<!---
		<script type="text/javascript">
			window.onload = function(){
				bookmarks.initialize();
			}
		</script>
		--->

	</body>
</html>