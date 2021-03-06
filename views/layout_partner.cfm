<cfparam name="title" type="string">
<?xml version=”1.0″ encoding=”UTF-8″?>
<!DOCTYPE html PUBLIC “-//W3C//DTD XHTML 1.0 Transitional//EN” “http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd”>
<html xmlns=”http://www.w3.org/1999/xhtml”>
	<head> 
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<cfoutput>#styleSheetLinkTag("reset,style,blitzer/jquery-ui-1.8.16.custom,jquery-ui-timepicker-addon,flexigrid,flexigrid.pack,aloha,basic,uploadify")#</cfoutput>
		<cfoutput>#javaScriptIncludeTag("jquery-1.8.0.min,jquery-ui-1.8.23.custom.min,jquery-ui-timepicker-addon,jquery.metadata,jquery.dataTables.min,flexigrid,flexigrid.pack,jquery.simplemodal.1.4.3.min,intranet,picnet.table.filter.min")#</cfoutput>
        <!--- ExtJS library 3.4 --->
        <cfoutput>#javaScriptIncludeTag("ext-3.4.0/adapter/ext/ext-base-debug,ext-3.4.0/ext-all-debug")#</cfoutput>
		<!--- ExtJS library 4.0.7 --->
<!--- 		<cfoutput>#javaScriptIncludeTag("ext-4.0.7-gpl/ext-all-debug")#</cfoutput> --->
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
		
		<!--- Mapki Google --->
		<!--- Załączam Google Map do modułu nieruchomości --->
		<script src="http://maps.google.com/maps/api/js?sensor=false" type="text/javascript"></script>
		<script src="http://maps.googleapis.com/maps/api/js?libraries=places&sensor=false" type="text/javascript"></script>
		<cfoutput>#javaScriptIncludeTag("googlemap")#</cfoutput>
		
		<!--- Ajaxowe dodawanie plików --->
		<!--- Załączam style dla Ajaxowego dodawania plików --->
<!--- 		<cfoutput>#styleSheetLinkTag("fileuploader")#</cfoutput> --->
		<title><cfoutput>#title#</cfoutput></title>


	</head>
	<body>
		<div id="flashMessages" style="display: none;"><cfoutput>#imageTag('ajax-loader-1.gif')#</cfoutput>Pobieram dane…</div>
		<div id="container">
			<div id="header">
				<div class="width">
					<cfinclude template="header_partner.cfm" >
				</div>
			</div>
			<div id="nav">
				<div class="width">
					<cfoutput>#includePartial(partial="/nav")#</cfoutput>
				</div>
			</div>
			<div id="content">
				<div class="width">
					<div class="wrapAll">
						<div id="breadcrumb_wrapper">
							<!---<cfinclude template="breadcrumbs.cfm" />--->
						</div>
						
						<div id="left">
							<cfoutput>#includeContent()#</cfoutput>
						</div>
						
						<div id="right">
							<cfoutput>#includePartial(partial="/subnav")#</cfoutput>
						</div>
						
						<div class="clear"></div>
					</div>
				</div>
			</div>
			<div class="clear"></div>
			<div id="footer">
				<div class="width">
					<cfinclude template="footer.cfm" />
				</div>
			</div>
		</div>
		<div id="modal"></div>		

		<script>

		</script> 

	</body>
</html>