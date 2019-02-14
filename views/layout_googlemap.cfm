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

		<!--- Główne style --->
		<cfoutput>#styleSheetLinkTag("reset,style,main,jquery.Jcrop,prettyPhoto")#</cfoutput>
		
		<!--- jquery-ui-1.10.1.custom.min <==> blitzer/jquery-ui-1.8.16.custom --->
		<cfoutput>#styleSheetLinkTag("blitzer/jquery-ui.min.css")#</cfoutput>
		
<cfcache
	timespan="#createTimespan(0, 1, 0, 1)#" >

	<cfoutput>#javaScriptIncludeTag("jquery-1.8.0.min,jquery-ui-1.10.1.custom.min,jquery.metadata,jquery.simple.class.creation")#</cfoutput>
		
	<!--- Funkcje js wykorzystywane w aplikacji --->
	<cfoutput>#javaScriptIncludeTag("functions")#</cfoutput>

</cfcache>

<cfcache
	timespan="#createTimespan(0, 1, 0, 16)#" >
		
		<!--- Google maps --->
		<script src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false&libraries=visualization"></script>
		
</cfcache>

	<title><cfoutput>#title#</cfoutput></title>
		
	<cfif isDefined("APPLICATION.ajaxImportFiles")>
		<cfloop list="#APPLICATION.ajaxImportFiles#" index="toLoad" delimiters="," >
			<script src="/<cfoutput>#get('loc').intranet.directory#</cfoutput>/javascripts/ajaximport/<cfoutput>#toLoad#</cfoutput>.js?<cfoutput>#DateFormat(Now(), "ddmmyyyy")##TimeFormat(Now(), "HHmmssll")#</cfoutput>" type="text/javascript"></script>
		</cfloop>
	</cfif>

	<cfif StructKeyExists(session, "userid")>
		<cfoutput>#javaScriptIncludeTag("usernotice")#</cfoutput>
	</cfif>

	<!--- Session --->
		<script type="text/javascript">
		$(function(){
		// jQuery UI Dialog
		$('#dialogWarning').dialog({
			autoOpen: false,
			width: 400,
			modal: true,
			resizable: false,
			buttons: {
				"Przedłuż sesję": function() {
					//reset session on server
					$.post("index.cfm?controller=users&action=restart-session");
					
					//reset the variables
					requestTime = new Date();
					warningStarted = false;
					countdownTime = warning;
					
					//clear current checkSessionTimeEvent and start a new one
					clearInterval(checkSessionTimeEvent);
					checkSessionTimeEvent = "";
					checkSessionTimeEvent = setInterval("checkSessionTime(requestTime)",10*1000);
					
					timecounter = sessionLength;
					$("#session-timebox-clock").css("color", "#444444");
					
					$('#dialogWarning').dialog('close');
				}
			}
		});

		$('#dialogExpired').dialog({
			autoOpen: false,
			width: 400,
			modal: true,
			resizable: false,
			close: function() {
				window.location="index.cfm?controller=users&action=log-out&expired=true";
			},
			buttons: {
				"Zaloguj": function() {
					window.location="index.cfm?controller=users&action=log-out&expired=true";
				}
			}
		});
		});

		//Your timing variables in number of seconds
		//total length of session in seconds
		var sessionLength = 3540;

		//time warning shown (10 = warning box shown 10 seconds before session starts)
		var warning = 60;

		//time redirect forced (10 = redirect forced 10 seconds after session ends)
		var forceRedirect = 10;

		$(document).ready(function() {
			//event to check session time left (times 1000 to convert seconds to milliseconds)
			checkSessionTimeEvent = setInterval("checkSessionTime(requestTime)",10*1000);
		});

		//event to check session time variable declaration
		var checkSessionTimeEvent = "";

		//time session started
		var requestTime = new Date();

		//initial set of number of seconds to count down from for countdown ticker (10,9,8,7...you get the idea)
		var countdownTime = warning;

		//create event to start/stop countdownTicker
		var countdownTickerEvent = "";

		//initially set to false. if true - warning dialog open; countdown underway
		var warningStarted = false;

		function checkSessionTime(reqTime) {
			//get time now
			var timeNow = new Date();

			//clear any countdownTickerEvents that may be running
			clearInterval(countdownTickerEvent);

			//difference between time now and time session started variable declartion
			var timeDifference = 0;

			//session timeout length
			var timeoutLength = sessionLength*1000;

			//set time for first warning, ten seconds before session expires
			var warningTime = timeoutLength - (warning*1000);

			//force redirect to log in page length (session timeout plus 10 seconds)
			var forceRedirectLength = timeoutLength + (forceRedirect*1000);

			timeDifference = timeNow - reqTime;

			if (timeDifference > warningTime && warningStarted === false) {

				//reset number of seconds to count down from for countdown ticker
				countdownTime = warning;

				//call now for initial dialog box text (time left until session timeout)
				countdownTicker();

				//set as interval event to countdown seconds to session timeout
				countdownTickerEvent = setInterval("countdownTicker()", 1000);

				$('#dialogWarning').dialog('open');
				warningStarted = true;
			} else if (timeDifference > timeoutLength) {

				//close warning dialog box if open
				if ($('#dialogWarning').dialog('isOpen')) $('#dialogWarning').dialog('close');

				$('#dialogExpired').dialog('open');
			}

			if (timeDifference > forceRedirectLength) {

				//clear (stop) checksession event
				clearInterval(checkSessionTimeEvent);

				//force relocation
				window.location="index.cfm?controller=users&action=log-out&expired=true";
			}
		}

		function countdownTicker() {

			//put countdown time left in dialog box for 10, 9, 8...
			$("span#dialogText-warning").html(countdownTime);

			//decrement countdownTime
			countdownTime--;

		}
	</script>
	
	</head>
	<body>
		<div id="flashMessages" style="display: none;"><cfoutput>#imageTag('ajax-loader-1.gif')#</cfoutput>Pobieram dane…</div>
		
		<div id="dialogExpired" title="Wygaśnięcie sesji aplikacji!">
			<p>
				<span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 0 0;"></span>
				Twoja sesja wygasła!
				<p id="dialogText-expired"></p>
			</p>
		</div>

		<div id="dialogWarning" title="Wygaśnięcie sesji aplikacji!">
			<p>
				<span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 0 0;"></span>
				Twoja sesja wygaśnie za
				<span id="dialogText-warning"></span>
				 sekund!
			</p>
		</div>

		<div id="container">
			<div id="nav">
				<div class="width">
					<div class="stretcher">
						<cfoutput>#includePartial(partial="/nav")#</cfoutput>
						
						<div id="slide-down-content">						
							<cfdiv id="search_result_cfdiv" />
							<div class="search-result-button">Wyniki wyszukiwania - rozwiń</div>
						</div>

					</div>
					
				</div>
			</div>
			<div id="content">
				<div class="width">
					
					<div class="wrapAll">

						<div id="left">
							<cfdiv
								id="intranet_left_content">

								<cfoutput>#includeContent()#</cfoutput>

							</cfdiv>
						</div>

						<div id="right">
							<cfoutput>#includePartial(partial="/timebox")#</cfoutput>
							<cfoutput>#includePartial(partial="/subnav")#</cfoutput>
						</div>
						<div class="clear"></div>
					</div>
				</div>
			</div>
			<div class="clear"></div>
			<div id="footer">
				<div class="width">
					<cfinclude template="footer.cfm" >
				</div>
			</div>

		</div>
		<div id="modal"></div>

	</body>
</html>