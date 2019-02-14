<cfoutput>

	<div class="wrapper documentAddForm">

		<h3>Wprowadzanie nowego dokumentu</h3>

		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>

		<cfif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<cfif IsDefined("URL.errortype") and URL.errortype EQ 3>
			<span class="error">Ups... Coś poszło nie tak ;). Spróbuj dodać ten dokument ponownie.</span>
		</cfif>

		<div class="forms invoiceForm">
			#startFormTag(action="ajaxFormUploadDocument",multipart=true,class="ajaxFormUploadDocument")#

				<ol>
					<li class="title">Dokument</li>
					<li>
						#fileFieldTag(
							name="documentinstancecontent",
							label="",
							class="documentinstancecontent",
							labelPlacement="before")#
					</li>
				</ol>

			#endFormTag()#
		</div>

			#startFormTag(action="actionAdd",multipart=true)#
			#hiddenFieldTag(name="documentInstance[file]",value="")#
			#hiddenFieldTag(name="documentInstance[thumbnail]",value="")#

				<!---
				Podawanie danych kontrahenta z faktury
				Dane są pobierane z Asseco. Jeśli znajdowały się w Intranecie to dodawane jest połączenie.
				Jeśli nie ma takiego kontrahenta to jest on zapisywane i dodawane połączenie.
				--->
				<div class="forms"> <!--- Dane kontrahenta --->
					<ol class="contractorSearchData">
						<li class="title">Wyszukaj kontrahenta</li>
						<li>
							#textAreaTag(
								name="documentInstanceAttributeValue[searchcontractor]",
								class="textarea searchcontractors")#
						</li>
						<li class="contractorSearchDataResults">

						</li>
					</ol>

					<ol class="contractorData">
						<li class="title">
							Kontrahent
							<!--- Ukryte pola formularza niezbędne do zapisania kompletu informacji w bazie --->
							#hiddenFieldTag(name="contractor[nazwa2]",value="")#
							#hiddenFieldTag(name="contractor[dzielnica]",value="")#
							#hiddenFieldTag(name="contractor[internalid]",value="")#
							#hiddenFieldTag(name="contractor[kli_kontrahenciid]",value="")#
							#hiddenFieldTag(name="contractor[logo]",value="")#
							#hiddenFieldTag(name="contractor[str_logo]",value="")#
							#hiddenFieldTag(name="contractor[miejscowosc]",value="")#
							#hiddenFieldTag(name="contractor[nrlokalu]",value="")#
							#hiddenFieldTag(name="contractor[nrdomu]",value="")#
							#hiddenFieldTag(name="contractor[typulicy]",value="")#
							#hiddenFieldTag(name="contractor[ulica]",value="")#
							<!--- Koniec ukrytych pól formularza --->
						</li>
						<li class="">
							#textFieldTag(
								name="contractor[nazwa1]"
								,label="Nazwa kontrahenta"
								,class="input required"
								,labelPlacement="before"
								,readonly="readonly")#
						</li>
						<li class="">
							#textFieldTag(
								name="contractor[nip]"
								,label="NIP"
								,class="input"
								,labelPlacement="before"
								,readonly="readonly")#
						</li>
						<li class="">
							#textFieldTag(
								name="contractor[regon]"
								,label="REGON"
								,class="input"
								,labelPlacement="before"
								,readonly="readonly")#
						</li>
						<li class="">
							#textFieldTag(
								name="contractor[kodpocztowy]"
								,label="Kod pocztowy"
								,class="input required"
								,labelPlacement="before"
								,readonly="readonly")#
						</li>
						<li>
							<div class="formfieldinformations">Pola oznaczone <span class="requiredfield">*</span> są wymagane.</div>
						</li>
					</ol>
					<div class="clear"></div>
				</div>

				<div class="clear"></div>

				<div class="forms documentAttributes horizontal"> <!--- Główny formularz dodawania dokumentu --->
					<ol>
						<li class="title">Dane na fakturze</li>

						<cfloop query="documentattributes">

							<cfif #attributerequired# is 1>

								<cfset requiredclass = " required" />

							<cfelse>

								<cfset requiredclass = "" />

							</cfif>

							<cfif #attributetypeid# is 1>

								<li>
									#textFieldTag(
										name="documentInstanceAttributeValue[#attributeid#]",
										label=attributename,
										class="input #requiredclass#",
										labelPlacement="before")#
									#hiddenFieldTag(name="documentInstanceAttribute[#attributeid#]",value=id)#
									#hiddenFieldTag(name="documentInstanceAttributeType[#attributeid#]",value=attributetypeid)#
								</li>
							<cfelseif #attributetypeid# is 2>
								<li>
									#textAreaTag(
										name="documentInstanceAttributeValue[#attributeid#]",
										label=attributename,
										class="textarea #requiredclass#",
										labelPlacement="before")#
									#hiddenFieldTag(name="documentInstanceAttribute[#attributeid#]",value=id)#
									#hiddenFieldTag(name="documentInstanceAttributeType[#attributeid#]",value=attributetypeid)#
								</li>
							<cfelseif #attributetypeid# is 4>
								<cfset defaultvalue = "" />
								<cfif #defaultdate# eq 1>
									<cfset defaultvalue = "#DateFormat(Now(), 'YYYY-mm-dd')#" />
								</cfif>

								<li>
									#textFieldTag(
										name="documentInstanceAttributeValue[#attributeid#]",
										label=attributename,
										class="input date_picker #requiredclass#",
										labelPlacement="before",
										value="#defaultvalue#")#
									#hiddenFieldTag(name="documentInstanceAttribute[#attributeid#]",value=id)#
									#hiddenFieldTag(name="documentInstanceAttributeType[#attributeid#]",value=attributetypeid)#
								</li>
							</cfif>

						</cfloop>

						<li> <!--- Użytkownik, do którego przekazuje dokument --->
							<input type="hidden" id="next" name="next" value="1" />
							#textFieldTag(
								name="document[searchuser]",
								class="searchusers inputSmall",
								label="Przekaż do",
								labelPlacement="before")#
							<select name="workflow[userid]" id="workflowuserid" class="required select_box">
								<cfloop query="users">
									<option value="#userid#">#givenname# #sn#</option>
								</cfloop>
							</select>
						</li> <!--- Koniec uzytkownika, do którego przekazuję fakturę --->

						<li>
							<div class="formfieldinformations">Pola oznaczone <span class="requiredfield">*</span> są wymagane.</div>
						</li>

					</ol>
				</div> <!--- Koniec głównego formularza dodawania dokumentu --->

				<div class="forms horizontal"> <!--- Informacje o dokumencie dodawanym do obiegu --->

					<ol>
						<li class="title">Dodatkowe informacje o dokumencie</li>
						<li>
							#checkBoxTag(
								name="delegation",
								value="1",
								label="Faktura do delegacji",
								labelPlacement="before")#
						</li>
					</ol>

				</div> <!--- Koniec informacji o dokumencie dodawanym do obiegu --->

				<ol class="formsubmit">
					<li class="l">#submitTag(value="Zapisz",class="formButton button redButton addWorkflow")#</li>
				</ol>

				<input
					id="VALIDATE_INVOICE_URL"
					type="hidden"
					value="#URLFor(controller='Workflows',action='validateInvoiceExistence')#" />

			#endFormTag()#

	</div>

</cfoutput>

<script type="text/javascript">
// <![CDATA[
$(function() {

$('.date_picker').datepicker({
				showOn: "both",
				numberOfMonths: 3,
				selectOtherMonths: true,
				showOtherMonths: true,
				showCurrentAtPos: 1,
				buttonImage: "images/schedule.png",
				buttonImageOnly: true,
				dateFormat: 'yy-mm-dd',
				monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
				dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
				firstDay: 1
			});

	// Wstawienie domyślnego numeru faktury
	$('#documentInstanceAttributeValue-100').css('color', '#eb0f0f').attr('readonly', 'readonly').attr('placeholder', 'Numer zostanie wygenerowany po zapisaniu dokumentu');

	// Przesyłanie pliku na serwer
	$('.documentinstancecontent').uploadify({
		'uploader'  	:	<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/uploadify/uploadify.swf"</cfoutput>,
		'script'    	:	<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/upload.cfm"</cfoutput>,
		'cancelImg' 	:	<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/uploadify/cancel.png"</cfoutput>,
		'folder'    	:	<cfoutput>"#ExpandPath('files/')#"</cfoutput>,
		'auto'      	:	true,
		'buttonText'	:	'Wybierz plik',
		'displayData'	:	'percentage',
		'fileExt'		:	'*.pdf',
		'fileDesc'		:	'Tylko pliki PDF',
		'onError'		:	function (event, ID, fileObj, errorObj) {
      		$('.invoiceForm').append('<div class="documentUploadStatus ok">' + errorObj.type + ' Błąd ' + errorObj.info + '</div>');
		},
		'onComplete'  : function(event, ID, fileObj, response, data) {
			var json = jQuery.parseJSON(response);
			var file = (json != null) ? json.file : '';
			var thumbnail = (json != null) ? json.thumbnail : '';

			$('.invoiceForm').append('<div class="documentUploadStatus ok">Plik ' + file + ' został prawidłowo zapisany na serwerze.</div>');
			$('#documentInstance-file').val(file);
			$('#documentInstance-thumbnail').val(thumbnail);

			window.open(<cfoutput>"http://#cgi.server_name#/#get('loc').intranet.directory#/files/"</cfoutput> + file, 'Podgląd dokumentu', 'width=800', 'height=600');
		}
    }); // Koniec przesyłania pliku na serwer

	var timeout = null;
	$('.searchusers').live('keypress', function () {
		if (timeout) {
			clearTimeout(timeout);
			timeout = null;
		}
		timeout = setTimeout(getUserToWorkflowStep, 500)
	});

    /**********************************************************************************
     * Sprawdzam, czy wybrano użytkownika, do którego zostanie przekazany dokument.
     * Jeśli go nie ma to zwracam błąd.
     *********************************************************************************/
     $('.addWorkflow').live('click', function(e) {

     	// Usuwam komunikaty błędów
     	$('.validationerror').remove();

     	// Zmieniam kolor ramki na poprzedni
     	$('.required').removeClass('redborder');

     	if (!$('#workflowuserid option:selected').length) {
    		e.preventDefault();
    		var errorMessage = "<span class=\"validationerror\">Musisz wybrać użytkownika, do którego zostanie przekazany dokument.</span>";
			$('#workflowuserid').parent().append(errorMessage);

    		$('#flashMessages').hide();
    	}

    	$('.required').each(function (index) {
    		if(!$(this).attr('value') != '') {
    			e.preventDefault();
    			$(this).addClass('redborder');

    			$('#flashMessages').hide();
    		}
    	});
     });

	/**********************************************************************************
	 * Dodaje gwiazdki przy wymaganych polach formularza.
	 *********************************************************************************/
	$('.required').each(function (index) {
		$(this).parent().append("<span class=\"requiredfield\">*</span>");
	});

	/**********************************************************************************
	 * Pobieranie listy Kontrahentów z Asseco.
	 * Lista jest tworzona dynamicznie.
	 *********************************************************************************/

	var timeout = null;

	$('.searchcontractors').live('keypress', function () {

		if (timeout) {
	        clearTimeout(timeout);
	        timeout = null;
		}

		timeout = setTimeout(getContractors, 500);
		$('#flashMessages').show();

	});

	/**********************************************************************************
	 * Pobieranie danych konkretnego kontrahenta i wpisanie ich do formularza.
	 *********************************************************************************/
	$('.contranctorSelect').live('change', function() {
		$('#flashMessages').show();

		var searchValue = $(this).attr('value');

		if (searchValue != ""){
			$.ajax({
				type		:		'post',
				dataType	:		'json',
				data		:		{logo:searchValue},
				url			:		<cfoutput>"#URLFor(controller='Asseco',action='getContractors',params='cfdebug')#"</cfoutput>,
				success		:		function(data) {
					/* Czyszczenie formularza */
					$('.contractorData input').each(function (i) {
						$(this).val("");
					});

					/* Autouzupełnianie nazwy Kontrahenta */
					/* widoczne pola */
					$('#contractor-nazwa1').val(data.ROWS[0].NAZWA1);
					$('#contractor-nip').val(data.ROWS[0].NIP);
					$('#contractor-regon').val(data.ROWS[0].REGON);
					$('#contractor-kodpocztowy').val(data.ROWS[0].KODPOCZTOWY);

					/* ukryte pola */
					$('#contractor-nazwa2').val(data.ROWS[0].NAZWA2);
					$('#contractor-dzielnica').val(data.ROWS[0].DZIELNICA);
					$('#contractor-internalid').val(data.ROWS[0].INTERNALID);
					$('#contractor-kli_kontrahenciid').val(data.ROWS[0].KLI_KONTRAHENCIID);
					$('#contractor-logo').val(data.ROWS[0].LOGO);
					$('#contractor-str_logo').val(pad(data.ROWS[0].LOGO, 6));
					$('#contractor-miejscowosc').val(data.ROWS[0].MIEJSCOWOSC);
					$('#contractor-nrlokalu').val(data.ROWS[0].NRLOKALU);
					$('#contractor-nrdomu').val(data.ROWS[0].NRDOMU);
					$('#contractor-typulicy').val(data.ROWS[0].TYPULICY);
					$('#contractor-ulica').val(data.ROWS[0].ULICA);
					$('#flashMessages').hide();
				}
			});
		}
	});

	/**********************************************************************************
	 * Sprawdzanie, czy istnieje faktura o danym numerze i danym kontrahencie
	 *********************************************************************************/
	$('#documentInstanceAttributeValue-108').live("keypress", function(e){
		try{
			startTimer(e, $(this));
		}catch(err){
			console.log(err.message);
		}
	});





});

var timeOutId = 0,
	delay = 1, // in seconds
	ajaxActive = false
	url = $("#VALIDATE_INVOICE_URL").val() || false;

var startTimer = function(event, obj){
	if(timeOutId){
		clearTimeout(timeOutId);
		removeLoader();
	}
	timeOutId = setTimeout(onTimer, delay*1000, event, obj);
};

var removeLoader = function(){ $('.invoice_loading_image').remove(); };

var onTimer = function(event, obj){
	if(ajaxActive){
		startTimer(event, obj);
	} else {
		var e = event;
		ajaxActive = true;

		if ($.trim($("#contractor-logo").val()).length == 0){
			ajaxActive = false;
		} else {

			obj.after("<img class=\"invoice_loading_image\" src=\"images/ajax-loader-3.gif\" />");

			$.ajax({
				type:		'post',
				dataType:	'json',
				data:		{
					invoice:e.currentTarget.value,
					logo:$("#contractor-logo").val(),
					nip:$("#contractor-nip").val(),
					nazwa1:$("#contractor-nazwa1").val()},
				url:		url,
				success:	function(response){
					ajaxActive = false;
					
					$('.invoice_loading_image').remove();
					$('.workflow_validation').remove();
					
					if (response.ROWSCOUNT != 0){
						var _myMessage = "<span class=\"workflow_validation uiRed\">";
						$.each(response.ROWS, function(item,i){
							_myMessage += i.NUMER_FAKTURY + ", ";
						});
						_myMessage += "</span>";
						obj.after(_myMessage);
					} else {
						obj.after("<span class=\"workflow_validation uiGreen\">Nie ma takiej faktury</span>");	
					}

				},
				error:	function(){
					$('.invoice_loading_image').remove();
					$('.workflow_validation').remove();
				}
			});
		}

	}
};


function getContractors(){
    var searchValue = $('.searchcontractors').attr('value');
	$.ajax({
		type		:		'post',
		dataType	:		'json',
		data		:		{searchvalue:searchValue},
		url			:		<cfoutput>"#URLFor(controller='Asseco',action='getContractors',params='cfdebug')#"</cfoutput>,
		success		:		function(data) {
			$('.contractorSearchDataResults').children().remove();
			var select = $("<select size=\"8\" class=\"contranctorSelect\" name=\"contractorsSelect\"></select>");
			$.each(data.ROWS, function(i, item) {
			var nazwaKontrah = item.NAZWA2;
			
				select.append('<option value="' + item.LOGO + '">' + nazwaKontrah.substring(0, 48) + '</option>');
			});
			$('.contractorSearchDataResults').html(select);
			$('#flashMessages').hide();
		}
	});
}

function getUserToWorkflowStep() {
	var searchValue = $( '.searchusers' ).attr( 'value' ),
		nextStepId = $( '#next' ).attr( 'value' );
	
	$.ajax({
		type		: 'post',
		dataType	: 'json',
		data		: {
			search : searchValue,
			step : nextStepId
		},
		url			: 'index.cfm?controller=workflow_stepusers&action=step-users',
		success		: function(data){
			var myOPTIONS = "";
			$.each(data.ROWS, function(i, item){
				myOPTIONS += "<option value=\""+item.USERID+"\">"+item.GIVENNAME+" "+item.SN+"</option>";
			});

			$('#workflowuserid > option').remove();
			$('#workflowuserid').append(myOPTIONS);
		}
   	});
}

// ]]>
</script>
