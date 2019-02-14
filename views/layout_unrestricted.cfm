<!DOCTYPE html>
<html lang="pl">
	<head>
		<meta charset=utf-8>
		<meta name="viewport" content="width=1200">
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		
		<cfoutput>#styleSheetLinkTag("reset,style,main,jquery.Jcrop,prettyPhoto")#</cfoutput>
		
	<cfcache timespan="#createTimespan(0, 1, 0, 1)#" >
	
		<cfoutput>#styleSheetLinkTag("blitzer/jquery-ui.min.css,jquery-ui-timepicker-addon,flexigrid,flexigrid.pack,basic,uploadify")#</cfoutput>		

		<cfoutput>#javaScriptIncludeTag("jquery-1.8.0.min,jquery-ui-1.10.1.custom.min,globalize,globalize.culture.pl-PL,jquery.filter_input,jquery-ui-timepicker-addon,jquery.metadata,jquery.dataTables.min,flexigrid,flexigrid.pack,jquery.simplemodal.1.4.3.min,intranet,picnet.table.filter.min,jquery.form,jquery.Jcrop,jquery.prettyPhoto,jquery.simple.class.creation,jquery.tablesorter")#</cfoutput>
		
		        <cfoutput>#javaScriptIncludeTag("uploadify/swfobject,uploadify/jquery.uploadify.v2.1.4.min")#</cfoutput>
		<!--- okienko modalne z komunikatem o ładowaniu strony --->
		<cfoutput>#javaScriptIncludeTag("flashmessages,ajaxlinks")#</cfoutput>
		<!--- walidacja pól formularza --->
		<cfoutput>#javaScriptIncludeTag("validation")#</cfoutput>
		<!--- Zakładki rozwiązujące problem guzika wstecz --->
		<cfoutput>#javaScriptIncludeTag("bookmarks")#</cfoutput>
		
		<!--- Funkcje js wykorzystywane w aplikacji --->
		<cfoutput>#javaScriptIncludeTag("functions")#</cfoutput>

		<!--- Ajax File Upload --->
		<cfoutput>#javaScriptIncludeTag("ajaxfileupload")#</cfoutput>

	</cfcache>

	<cfcache timespan="#createTimespan(0, 1, 0, 16)#" >

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
		
		<!-- Latest compiled and minified CSS -->
		<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap.min.css">
		
		<!-- Optional theme -->
		<link rel="stylesheet" href="//netdna.bootstrapcdn.com/bootstrap/3.1.1/css/bootstrap-theme.min.css">
		
		<!-- Latest compiled and minified JavaScript -->
		<script src="//netdna.bootstrapcdn.com/bootstrap/3.1.1/js/bootstrap.min.js"></script>

		
	</cfcache>

		<title>Monkey Express</title>
		
		
		<!--- dopiet Tooltip --->
		<cfoutput>#javaScriptIncludeTag('jquery.dopiettooltip')#</cfoutput>
		<script type="text/javascript">
		$(function () {
			$('.ajaxdisable').on('click', function(e) { e.preventDefault(); });
		});
		</script>

		<cfif isDefined("APPLICATION.ajaxImportFiles")>
			<cfloop list="#APPLICATION.ajaxImportFiles#" index="toLoad" delimiters="," >
				<script src="/<cfoutput>#get('loc').intranet.directory#</cfoutput>/javascripts/ajaximport/<cfoutput>#toLoad#</cfoutput>.js?<cfoutput>#DateFormat(Now(), "ddmmyyyy")##TimeFormat(Now(), "HHmmssll")#</cfoutput>" type="text/javascript"></script>
			</cfloop>
		</cfif>

	</head>
	<body>
		<div id="flashMessages" style="display: none;"><cfoutput>#imageTag('ajax-loader-1.gif')#</cfoutput>Pobieram dane…</div>

		<div id="container">

			<div id="nav">
				<div class="width">
					<div class="stretcher">
						<ul class="ul_bar">

							<li class="monkeylogo">
								<cfoutput>
				                	#linkTo(
										text="<span>Monkey Express</span>",
										controller="sales-contest",
										action="index",
										title="Monkey Express")#
				                </cfoutput>
							</li>
							
						</ul>
					</div>
					
				</div>
			</div>
			<div id="content">
				<div class="width">
					
					<div class="wrapAll">

						<div id="left" style="width:1150px;">
							<cfdiv
								id="intranet_left_content">

								<cfoutput>#includeContent()#</cfoutput>

							</cfdiv>
						</div>

						<!---<div id="right">
							<cfoutput>#includePartial(partial="/timebox")#</cfoutput>
							<cfoutput>#includePartial(partial="/subnav")#</cfoutput>
						</div>--->
						<div class="clear"></div>
					</div>
				</div>
			</div>
			<div class="clear"></div>
			<div id="footer">
				<div class="width">
					<div class="wrapper">

						<ul class="left">
							<li class="title">Szybkie linki</li>
							<li>
								<cfoutput>
                                	#linkTo(
										text="Monkey Express",
										href="http://monkey.xyz")#
                                </cfoutput>
							</li>
					
							<li>
								<cfoutput>
                                	#linkTo(
										text="Strona korporacyjna",
										href="http://monkey.xyz")#
                                </cfoutput>
							</li>
						</ul>
					
						<ul class="right">
							<cfoutput>
                            	<li>Skontaktuj się z #mailTo(
										name="administratorem serwisu",
										emailAddress="intranet@monkey.xyz")#
								</li>
                            </cfoutput>
						</ul>
					
						<div class="clear"></div>
				
					</div>
				</div>
			</div>

		</div>
		<div id="modal"></div>

	<script type="text/javascript">
		$(function() {

			$('.date_picker').datepicker({
				showOn: "both",
				buttonImage: "images/schedule.png",
				buttonImageOnly: true,
				dateFormat: 'yy-mm-dd',
				monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
				dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
				firstDay: 1
			});

			$('.time_picker').timepicker({
				showOn: "button",
				buttonImage: "images/clock_red.png",
				buttonImageOnly: true
			});

			$(document).on('click', '.inactive', function (e) {
				e.preventDefault();
			});
			
			
		});
		</script>
		<!---
		<script type="text/javascript">
			window.onload = function(){
				bookmarks.initialize();
			}
		</script>
		--->

	</body>
</html>