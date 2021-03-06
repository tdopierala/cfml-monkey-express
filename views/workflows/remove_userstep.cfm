<div class="ajaxcontent">

<cfoutput>
	<div class="wrapper">

		<h3>Podgląd dokumentu</h3>

		<div class="wrapper">

			<cfoutput>#includePartial(partial="/workflows/subnav")#</cfoutput>

		</div>

		<div class="wrapper">

			#linkTo(
				controller="Documents",
				action="getDocument",
				key=workflowstep.documentid,
				text="<img src='images/file-pdf.png' title='Kliknij aby pobrać dokument PDF' />",
				target="_blank",
				class="fltr",
				title="Kliknij any pobrać dokument PDF")#

			#linkTo(
				controller="Workflows",
				action="decreeNote",
				key=workflowstep.workflowid,
				text="<span>Pobierz dekret</span>",
				class="decreeNote fltr ajaxlink",
				title="Dekret dokumentu")#

			#linkTo(
				controller="Workflows",
				action="decreeNote",
				key=workflowstep.workflowid,
				text="<span>Pobierz dekret jako PDF</span>",
				class="decreeNoteToPdf fltr",
				title="Pobierz dekret jako PDF",
				params="format=pdf")#

			<div class="clear"></div>

			<!--- Kontrahent na fakturze --->
			<div class="documentBasicInformation">
				<div class="documentDetailsElements"> <!--- podgląd faktury i wpisanych informacji --->

					<!--- Numer faktury wyświetlany w nagłówku --->
					<div class="documentDetailsElementName">Kontrahent</div>

					<div class="documentDetailsElementItems">
						<ul>
							<li><span class="">#contractor.nazwa1#</span></li>
							<li><span class="">#contractor.typulicy# #contractor.ulica# <cfif Len(contractor.nrdomu)>nr. domu #contractor.nrdomu#</cfif> <cfif Len(contractor.nrlokalu)> nr. lokalu #contractor.nrlokalu#</cfif></span></li>
							<li><span class="">#contractor.kodpocztowy# #contractor.miejscowosc#</span></li>
							<li><span class="">#contractor.nip#</span></li>
							<li><span class="">#contractor.regon#</span></li>
						</ul>
					</div>
				</div>
			</div>
			<!--- Koniec danych kontrachenta --->

			<!--- Zamawiajązy na fakturze --->
			<div class="buyer">
				<h5>Zamawiający</h5>
			</div>
			<!--- Koniec danych zamawiajcego --->

			<div class="clear"></div>

			<!--- Informacje o dokumencie, cena, daty dodania, wystawienia, itp --->
			<div class="documentBasicInformation">
				<div class="documentDetailsElements"> <!--- podgląd faktury i wpisanych informacji --->

					<!--- Numer faktury wyświetlany w nagłówku --->
					<div class="documentDetailsElementName">Faktura numer
						<cfloop query="documentattributes">
							<cfif attributename eq 'Numer faktury'>
								#documentattributetextvalue#
								<cfbreak>
							</cfif>
						</cfloop>
						<div class="edit_invoice">
							#linkTo(
								text="edytuj",
								controller="Documents",
								action="edit",
								key=document.id,
								class="ajaxmodallink")#
						</div>
					</div>

					<div class="documentDetailsElementItems">
						<cfset index = 1>
						<ul>
						<cfloop query="documentattributes">

							<cfif attributename eq 'Numer faktury'>
								<cfcontinue>
							</cfif>

								<li><span class="b">#attributename#</span> #documentattributetextvalue# </li>

						<cfset index++>
						</cfloop>
						</ul>
					</div>
				</div><!--- koniec podglądu faktury i wszystkich wpisanych informacji --->
			</div>
			<!--- Koniec informacji o dokumencie --->



			<!--- Tabelka z mpk, projekt i netto --->
			<div class="description">
				<table class="smallTable" id="descriptionTable">
					<thead>
						<tr>
							<th class="leftBorder bottomBorder topBorder c">MPK</th>
							<th class="leftBorder bottomBorder topBorder c">Projekt</th>
							<th class="leftBorder bottomBorder rightBorder topBorder c">Kwota netto</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="workflowstepdescription">
							<tr class="workflowstepdescription-#id#">
								<td class="leftBorder bottomBorder">#mpk# - #m_nazwa#</td>
								<td class="leftBorder bottomBorder">#projekt# - #p_nazwa#; #p_opis#; #miejscerealizacji#</td>
								<td class="leftBorder bottomBorder rightBorder">#workflowstepdescription#</td>
							</tr>
						</cfloop>
					</tbody>
					<tfoot></tfoot>
				</table>
			</div>
			<!--- Koniec tabelki mpk, projekt, netto --->

			<div class="clear"></div>

			<!--- Opis faktury dodany w pierwszym kroku --->
			<div class="description" style="width: 100%">
				<table class="smallTable" id="descriptionNoteTable">
					<thead>
						<tr>
							<th class="c leftBorder rightBorder topBorder bottomBorder">Opis merytoryczny</th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td class="leftBorder rightBorder bottomBorder">
								<cfif Len(workflowstepdecreenote.workflowstepnote)>
									#workflowstepdecreenote.workflowstepnote#
								</cfif>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<!--- Koniec opisu dodanego w pierwszym kroku --->

			<div class="clear"></div>

			<div class="wrapper">

				<h3>#workflowstep.workflowstepstatusname#</h3>

			</div>

			<!---
				29.01.2013
				Zestaw funkcjonalności mających przyspieszyć proces opisywania faktur
				w Intranecie.
			--->
			<div class="invoice_helper">
				<div class="wrapper">

					<ol class="invoice_helper_nav">
						<li>
							#linkTo(
								text="<span>Zapisz szablon</span>",
								controller="Documents",
								action="saveInvoiceTemplate",
								title="Zapisz szablon",
								class="save_invoice_template")#
						</li>

						<li>
							#linkTo(
								text="<span>Załaduj szablon</span>",
								controller="Documents",
								action="getUserTemplates",
								key=session.userid,
								title="Załaduj szablon",
								class="get_invoice_template")#
						</li>

						<li class="update_button">
							#linkTo(
								text="<span>Uaktualnij szablon</span>",
								controller="Documents",
								action="updateUserTemplate",
								key=session.userid,
								title="Aktualizuj szablon",
								class="update_invoice_template")#
						</li>

					</ol>

					<div class="clear"></div>

					<div class="invoice_helper_content">
						<div class="invoice_helper_add">
							<cfform
								action="#URLFor(controller='Documents',action='saveTemplate')#"
								name="save_invoice_template_form">
								<ol>
									<li>
										<cfinput
											name="invoice_helper_template_name"
											type="text"
											class="input"
											placeholder="Proszę podać nazwę szablonu" />
									</li>
									<li>
										<cfinput
											name="submit_invoice_template_name"
											type="submit"
											class="admin_button green_admin_button"
											value=">>" />
									</li>
								</ol>
							</cfform >
						</div>

						<div class="invoice_helper_list">
						</div>
					</div>

				</div>
			</div>

			<div class="clear"></div>
			<!---
				Koniec funkcjonalności mających przyspieszyć proces opisywania
				faktur w Intranecie.
			--->

			<div class="wrapper">

			<!--- <h4 class="mtop">#workflowstep.workflowstepstatusname#</h4> --->

				#startFormTag(action="actionStep",id="stepForm")#
				#hiddenFieldTag(
					class="workflownextstatusid",
					name="workflow[next]",
					value="#workflowstep.next#")#
				#hiddenFieldTag(
					class="workflowprevstatusid",
					name="workflow[prev]",
					value="#workflowstep.prev#")#
				#hiddenFieldTag(
					class="workflowcurrentstatusid",
					name="workflow[current]",
					value="#workflowstep.workflowstepstatusid#")#
				#hiddenFieldTag(
					class="workflowid",
					name="workflow[workflowid]",
					value="#workflowstep.workflowid#")#
				#hiddenFieldTag(
					class="workflowstepid",
					name="workflow[workflowstepid]",
					value="#workflowstep.id#")#
				#hiddenFieldTag(
					class="workflowtoken",
					name="workflow[workflowtoken]",
					value="#workflowstep.token#")#
				#hiddenFieldTag(
					class="documentid",
					name="workflow[documentid]",
					value="#workflowstep.documentid#")#
				#hiddenFieldTag(
					class="invoicetemplateid",
					name="invoicetemplateid")#

					<ol>

						<!---
						6.09.2012
						Dodaje dodatkowe pole dla perwszego kroku obiegu dokumentów - opisywania
						--->
						<cfif workflowstep.workflowstepstatusid eq 1> <!--- Sprawdzam czy jestem na etapie opisywania --->

							<li>
								#textFieldTag(
									name="workflow[invoicedefaultnumber]",
									class="input required",
									label="Zewnętrzny numer faktury",
									labelPlacement="before",
									value=defaultinvoicenumber.documentattributetextvalue)#
							</li>


							<cfif types.RecordCount neq 0> <!--- Sprawdzam, czy istnieją typy do pokazania --->
								<li>
									#selectTag(
										name="typeid",
										options=types,
										label="Typ dokumentu",
										labelPlacement="before")#
								</li>
							</cfif>

						</cfif> <!--- Koniec sprawdzania, czy jestem na etapie opisywania dokumentu --->


						<cfif workflowstep.workflowstepstatusid eq 1>

							<cfif Len(workflowstepdecreenote.workflowstepnote)>

								<li>
									#textAreaTag(
										name="workflow[workflowstepnote]",
										class="textareaBig required",
										label="Notatka merytoryczna",
										labelPlacement="before",
										content=workflowstepdecreenote.workflowstepnote)#
								</li>

							<cfelse>

								<li>
									#textAreaTag(
										name="workflow[workflowstepnote]",
										class="textareaBig required",
										label="Notatka merytoryczna",
										labelPlacement="before",
										content=workflowstep.workflowstepnote)#
								</li>

							</cfif>

						</cfif>

						<!---
						--------------------------------------------------------------------------------------------
						Jeśli opisuje dokument pokazuje tabelkę z mpk, projekt i netto.
						Dane są autousupełniane z bazy.

						Jeśli etapem jest controlling to daje możliwość edycji opisu.
						--------------------------------------------------------------------------------------------
						--->
						<cfif workflowstep.workflowstepstatusid eq 1 or workflowstep.workflowstepstatusid eq 2>

						<li>
							<div id="workflowStepDesc">

								<table class="tables" id="workflowStepDescTable">

									<thead>
										<tr>
											<th class="c">Mpk</th>
											<th class="c">Projekt</th>
											<th class="c">Netto</th>
											<th class="c"></th>
										</tr>
									</thead>
									<tbody>
										<cfloop query="workflowstepdescription">
											<tr class="#id# workflowstepdescription-#id#">
												<td class="leftBorder bottomBorder">
													<!--- #selectTag(name="workflow[table[#id#][mpk]]",options=mpks,selected=mpkid)# --->
													#textFieldTag(
														name="workflow[table[#id#][mpk]]",
														class="input searchmpk",
														value="#mpk# - #m_nazwa#")#
													#hiddenFieldTag(
														name="workflow[table[#id#][mpkid]]",
														class="input")#
												</td>
												<td class="leftBorder bottomBorder">
													<!--- #selectTag(name="workflow[table[#id#][project]]",options=projects,selected=projectid)# --->
													#textFieldTag(
														name="workflow[table[#id#][project]]",
														class="input searchproject",
														value="#projekt# - #p_nazwa#; #p_opis#; #miejscerealizacji#")#
													#hiddenFieldTag(
														name="workflow[table[#id#][projectid]]",
														class="input")#
												</td>
												<td class="leftBorder rightBorder bottomBorder">
													<input type="text" class="smallInput c priceelement" name="workflow[table[#id#][price]]" value="#workflowstepdescription#"/>
												</td>
												<td class="rightBorder bottomBorder">
													#linkTo(
														text=imageTag(source="delete.png",alt="Usuń wiersz z opisu dokumentu"),
														controller="Workflows",
														action="ajaxDeleteDescriptionById",
														key=id,
														class="permanentlyDeleteRow",
														title="Usuń wiersz z opisu dokumentu")#

													#hiddenFieldTag(
														name="workflowstepdecriptionid-#id#",
														class="workflowstepdecriptionid",
														value=id)#

												</td>
											</tr>
										</cfloop>
										<tr class="last">
											<td colspan="2" class="leftBorder bottomBorder r" style="text-align: right;">
												Kwota na fakturze: <span class="finallprice">#price.documentattributetextvalue#</span>
											</td>
											<td class="leftBorder rightBorder bottomBorder">
												<input type="text" class="smallInput c pricesum" name="price" value="0" readonly="readonly" />
											</td>
											<td class="rightBorder bottomBorder">
												<input type="text" class="smallInput c priceodd" name="priceodds" value="0" readonly="readonly" />
											</td>
										</tr>
									</tbody>
									<tfoot>
										<tr>
											<td colspan="4">
												#linkTo(
													text="<span>+ wiersz</span>",
													controller="Workflows",
													action="getTableRow",
													params="workflowid=#workflowstep.workflowid#&workflowstepid=#workflowstep.id#",
													class="newRow fltr")#
											</td>
										</tr>
									</tfoot>
								</table>
							</div>
						</li>
						<script type="text/javascript" src="http://#cgi.server_name#/#get('loc').intranet.directory#/javascripts/workflows/userstep.js"></script>
						</cfif>
						<!---
						--------------------------------------------------------------------------------------------
						koniec sprawdzania, czy krokiem obiegu dokumentów jest opis
						--------------------------------------------------------------------------------------------
						--->

						<!---
						Jeśli krokiem jest księgowość lub prezes to dodaje okienko z komunikatem dla kolejnego użytkownika
						lub inforację o zaksięgowaniu dokumentu.
						--->
						<cfif workflowstep.workflowstepstatusid eq 5 or workflowstep.workflowstepstatusid eq 4>
							<li>
								#textAreaTag(
									name="workflow[workflowsteptransfernote]",
									class="textareaBig",
									label="Twoje uwagi",
									labelPlacement="before")#
							</li>
						</cfif>
						<!--- Koniec sprawdzania, czy to księgowość --->

						<li class="buttonsList">
							<cfif workflowstep.workflowstepstatusid eq 1>

								<cfif workflowstep.moveto neq 0>

									#submitTag(value="Do księgowości",class="button redButton toAccounting fltr ajaxmodalloader")#

								<cfelse>

									#submitTag(value="Zapisz",class="button redButton saveDescription fltr ajaxmodalloader")#
									#submitTag(value="Anuluj",class="button grayButton cancelDescription fltr ajaxmodalloader")#
									#submitTag(value="Przekaż",class="button darkGrayButton moveDescription fltl ajaxmodalloader")#

								</cfif>

							<cfelseif workflowstep.workflowstepstatusid eq 2>

								#submitTag(value="Odrzucam",class="button darkGrayButton refuseDecree fltl ajaxmodalloader")#
								#submitTag(value="Prawidłowy dekret", class="button redButton acceptDecree fltr ajaxmodalloader")#
								#submitTag(value="Poprawiono dekret",class="button grayButton modifiedDecree fltr ajaxmodalloader")#

							<cfelseif workflowstep.workflowstepstatusid eq 3>

								#submitTag(value="Zatwierdzam",class="button redButton acceptInvoice fltr")#
								#submitTag(value="Odrzucam",class="button grayButton refuseInvoice fltr")#

							<cfelseif workflowstep.workflowstepstatusid eq 5>

								#submitTag(value="Akceptuje",class="button redButton closeInvoice fltr")#
								#submitTag(value="Odrzucam",class="button grayButton refuseInvoice fltr")#

							<cfelseif workflowstep.workflowstepstatusid eq 4>

								<!--- #submitTag(value="Zamykam",class="button redButton closeInvoice fltr")# --->
								#submitTag(value="Księguje",class="button redButton toAccount fltr")#
								#submitTag(value="Przekaż do opisu",class="button grayButton describeInvoice fltr")#

							</cfif>
						</li>
					</ol>

				#endFormTag()#

			</div>

		</div> <!-- koniec wrapper dla formularza --->

	</div> <!--- koniec wrapper dla całego widoku --->

	<div class="ajaxtmp"></div>

</cfoutput>

<script type="text/javascript">
$(function() {

	$('.required').each(function(i, element) {
		var toAppend = "<span class=\"requiredfield\"> *</span>";
		$(this).parent().find('label').append(toAppend);
	});


	<cfif workflowstep.workflowstepstatusid eq 1 or workflowstep.workflowstepstatusid eq 2>

		validateinvoicetable(); // Przeliczenie wartości w tabelce opisującej fakturę

		$('.deleteRow').live('click', function(e) {
			e.preventDefault();

			var element = $(this).parent().parent();
			element.remove();

			validateinvoicetable();
		});

		$('.priceelement').live('keyup', function() {
			validateinvoicetable();
		});

		$('.permanentlyDeleteRow').live('click', function(e) {
			e.preventDefault();

			var _tr = $(this).closest("tr");

			// Wywołuje Ajaxowo usunięcie tego wpisu w bazie
			$.ajax({
				type		:		'post',
				dataType	:		'html',
				url			:		$(this).attr('href'),
				success		:		function(data) {
					_tr.remove();
					validateinvoicetable();
				},
				error		:		function(xhr, ajaxOptions, throwError) {
					alert("Wystąpił błąd w aplikacji.");
				}
			});

			// Jeśli usunięto element prawidłowo to usuwam go z tabelek w widoku.

		});

		/*
	     * Wyszukiwanie mpków i projektów w bazie Asseco
	     */

		$('.searchmpk').live('keyup', function(e) {
			$(this).autocomplete({
				source: <cfoutput>#mpkautocomplete#</cfoutput>,
				select: function(event, ui) {
					$('#flashMessages').show();
					var _workflowdescid = $(this).closest('tr').find('.workflowstepdecriptionid').val();
					$.ajax({
						type		:		'post',
						dataType	:		'html',
						data		:		{workflowstepdescriptionid:_workflowdescid,mpk:ui.item.value},
						url			:		"<cfoutput>#URLFor(controller='Workflows',action='updateDescriptionRow')#</cfoutput>",
						success		:		function(data) {
							$('#flashMessages').hide();
						}
					});
				}
			});
		});

		$('.searchproject').live('keyup', function(e) {
			$(this).autocomplete({
				source: <cfoutput>#projectsautocomplete#</cfoutput>,
				select: function(event, ui) {
					$('#flashMessages').show();
					var _workflowdescid = $(this).closest('tr').find('.workflowstepdecriptionid').val();
					$.ajax({
						type		:		'post',
						dataType	:		'html',
						data		:		{workflowstepdescriptionid:_workflowdescid,project:ui.item.value},
						url			:		"<cfoutput>#URLFor(controller='Workflows',action='updateDescriptionRow')#</cfoutput>",
						success		:		function(data) {
							$('#flashMessages').hide();
						}
					});
				}
			});
		});

		$('.priceelement').live('change', function(e) {
			$('#flashMessages').show();
			var _workflowdescid = $(this).closest('tr').find('.workflowstepdecriptionid').val();
			$.ajax({
				type		:		'post',
				dataType	:		'html',
				data		:		{workflowstepdescriptionid:_workflowdescid,price:$(this).val()},
				url			:		"<cfoutput>#URLFor(controller='Workflows',action='updateDescriptionRow')#</cfoutput>",
				success		:		function(data) {
					$('#flashMessages').hide();
				}
			});
		});

	</cfif>

<cfif workflowstep.workflowstepstatusid eq 2>
		$('.hide').removeClass('hide');
	</cfif>


	/*
     * Zapisanie formulatza z opisem dokumentu. Po zapisaniu zostanie wyświetlona strona z wyborem osoby,
     * do której ma zostać przekazany dokument.
     *
     * Jeśli nie wypełniono pola z opisem faktury system zgłasza błąd i nie pozwala na zapisanie formularza.
     */
    $('.saveDescription').live('click', function(e) {
    	e.preventDefault();

    	/*
    	 * Usunięcie poprzednich komunikatów walidacji.
    	 */
    	 $('.validationerror').remove();

    	/*
    	 * Walidacja - sprawdzenie czy wypełniono wszystkie wymagane pola formularza
    	 */
		var error = false;
		var errorsArray = new Array();
		var errorRequired = "<span class=\"validationerror\">Nie uzupełniłeś tego pola. Jest ono wymagane aby zapisać formularz.</span>";
		var errorPrice = "<span class=\"validationerror\">Opis faktury musi być prawidłowy. Sprawdź, czy kwoty, które podałeś się zgadzają.</span>";

		$('.required').each(function(i) {
			if (!$(this).attr('value').length) {
				$(this).parent().append(errorRequired);
				error = true;
			}
		});

    	/*
    	 * Walidacja - sprawdzenie, czy podane w opisie kwoty zgadzają się
    	 */
    	var priceOdd = parseFloat($('.priceodd').val().replace(',', '.')).toFixed(2);

    	if (priceOdd != 0) {
    		$('#workflowStepDesc').append(errorPrice);
				error = true;
    	}

    	if (!error) {

    		var formData = $('#stepForm').serialize();

	    	$.ajax({
	    		type		:		'post',
	    		dataType	:		'html',
	    		data		:		formData,
	    		url			:		<cfoutput>"#URLFor(controller='Workflows',action='saveDescription',params='cfdebug')#"</cfoutput>,
	    		success		:		function(data) {
	    			$('.ajaxcontent').html(data);
	    			$('#flashMessages').hide();
	    		}
	    	});

	    } else
	    	$('#flashMessages').hide();
    });

    $('.cancelDescription').live('click', function(e) {
    	e.preventDefault();

    	window.history.back(-1);

    });

    /*
     * Przekazanie opisu do innego użytkownika.
     * Nie jest zapisany jest status Przekazano przy danym użytkowniku
     */
    $('.moveDescription').live('click', function(e){
    	e.preventDefault();
    	var formData = $('#stepForm').serialize();

    	$.ajax({
    		type			:		'post',
    		dataType		:		'html',
    		data			:		formData,
    		url				:		<cfoutput>"#URLFor(controller='Workflows',action='moveDescription',params='cfdebug')#"</cfoutput>,
    		success			:		function(data) {
    			$('.ajaxcontent').html(data);
    			$('#flashMessages').hide();
    		}
    	});
    });

    /*
     * Zatwierdzenie dekretu dokumentu. Po zatwierdzeniu generowany jest widok z formularzem przekazania dla
     * nowego użytkownika.
     * Jeśli jest błąd w opisie system zwraca błąd i nie pozwala zapisać zmian.
     * Nie jest wymagane pole z opisem. Jest wymagane tylko dla pierwszego kroku.
     */
    $('.acceptDecree').live('click', function(e) {
    	e.preventDefault();

    	/*
    	 * Usunięcie poprzednich komunikatów walidacji.
    	 */
    	 $('.validationerror').remove();

    	/*
    	 * Walidacja - sprawdzenie czy wypełniono wszystkie wymagane pola formularza
    	 */
		var error = false;
		var errorsArray = new Array();
		var errorRequired = "<span class=\"validationerror\">Nie uzupełniłeś tego pola. Jest ono wymagane aby zapisać formularz.</span>";
		var errorPrice = "<span class=\"validationerror\">Opis faktury musi być prawidłowy. Sprawdź, czy kwoty, które podałeś się zgadzają.</span>";

    	/*
    	 * Walidacja - sprawdzenie, czy podane w opisie kwoty zgadzają się
    	 */
    	var priceOdd = parseFloat($('.priceodd').val().replace(',', '.')).toFixed(2);

    	if (priceOdd != 0) {
    		$('#workflowStepDesc').append(errorPrice);
				error = true;
    	}

    	if (!error) {

    		var formData = $('#stepForm').serialize();

	    	$.ajax({
	    		type		:		'post',
	    		dataType	:		'html',
	    		data		:		formData,
	    		url			:		<cfoutput>"#URLFor(controller='Workflows',action='acceptDecree',params='cfdebug')#"</cfoutput>,
	    		success		:		function(data) {
	    			$('.ajaxcontent').html(data);
	    			$('#flashMessages').hide();
	    		}
	    	});

	    } else
	    	$('#flashMessages').hide();
    });

	/*
     * Dekret został poprawiony.
     * Jeśli jest błąd w opisie system zwraca błąd i nie pozwala zapisać zmian.
     * Nie jest wymagane pole z opisem. Jest wymagane tylko dla pierwszego kroku.
     */
    $('.modifiedDecree').live('click', function(e) {
    	e.preventDefault();

    	/*
    	 * Usunięcie poprzednich komunikatów walidacji.
    	 */
    	 $('.validationerror').remove();

    	/*
    	 * Walidacja - sprawdzenie czy wypełniono wszystkie wymagane pola formularza
    	 */
		var error = false;
		var errorsArray = new Array();
		var errorRequired = "<span class=\"validationerror\">Nie uzupełniłeś tego pola. Jest ono wymagane aby zapisać formularz.</span>";
		var errorPrice = "<span class=\"validationerror\">Opis faktury musi być prawidłowy. Sprawdź, czy kwoty, które podałeś się zgadzają.</span>";

    	/*
    	 * Walidacja - sprawdzenie, czy podane w opisie kwoty zgadzają się
    	 */
    	var priceOdd = parseFloat($('.priceodd').val().replace(',', '.')).toFixed(2);

    	if (priceOdd != 0) {
    		$('#workflowStepDesc').append(errorPrice);
				error = true;
    	}

    	if (!error) {

    		var formData = $('#stepForm').serialize();

	    	$.ajax({
	    		type		:		'post',
	    		dataType	:		'html',
	    		data		:		formData,
	    		url			:		<cfoutput>"#URLFor(controller='Workflows',action='modifiedDecree',params='cfdebug')#"</cfoutput>,
	    		success		:		function(data) {
	    			$('.ajaxcontent').html(data);
	    			$('#flashMessages').hide();
	    		}
	    	});

	    } else
	    	$('#flashMessages').hide();
    });

    /*
     * Odrzucenie dekretu i przekazanie go do innego użytkownika.
     */
    $('.refuseDecree').live('click', function(e) {
    	e.preventDefault();

      		var formData = $('#stepForm').serialize();

	    	$.ajax({
	    		type		:		'post',
	    		dataType	:		'html',
	    		data		:		formData,
	    		url			:		<cfoutput>"#URLFor(controller='Workflows',action='refuseDecree',params='cfdebug')#"</cfoutput>,
	    		success		:		function(data) {
	    			$('.ajaxcontent').html(data);
	    			$('#flashMessages').hide();
	    		}
	    	});

	    	$('#flashMessages').hide();
    });

    /*
     * Zaakceptowanie faktury przez.
     */
    $('.acceptInvoice').live('click', function(e) {
    	e.preventDefault();
    	var formData = $('#stepForm').serialize();
    	$.ajax({
    		type		:		'post',
    		dataType	:		'html',
    		data		:		formData,
    		url			:		<cfoutput>"#URLFor(controller='Workflows',action='acceptInvoice',params='cfdebug')#"</cfoutput>,
    		success		:		function(data) {
    			$('.ajaxcontent').html(data);
    			$('#flashMessages').hide();
    		}
    	});
    });

    /*
     * Odrzucenie faktury.
     */
    $('.refuseInvoice').live('click', function(e) {
    	e.preventDefault();
		var formData = $('#stepForm').serialize();
    	$.ajax({
    		type		:		'post',
    		dataType	:		'html',
    		data		:		formData,
    		url			:		<cfoutput>"#URLFor(controller='Workflows',action='refuseInvoice',params='cfdebug')#"</cfoutput>,
    		success		:		function(data) {
    			$('.ajaxcontent').html(data);
    			$('#flashMessages').hide();
    		}
    	});
    });

	<!---
    /*
     * Zamknięcie obiegu dokumentów.
     * TODO 23.03.2012
     * Teraz obieg będzie zamykał tylko prezes
     */
	--->
	$('.closeInvoice').live('click', function(e) {
    	e.preventDefault();
    	$('#flashMessages').show();
    	$('html, body').animate({scrollTop:0}, 'slow');

		var formData = $('#stepForm').serialize();
    	$.ajax({
    		type		:		'post',
    		dataType	:		'html',
    		data		:		formData,
    		url			:		<cfoutput>"#URLFor(controller='Workflows',action='closeInvoice',key=workflowstep.workflowid,params='cfdebug')#"</cfoutput>,
    		success		:		function(data) {
    			$('.ajaxcontent').html(data);
    			$('#flashMessages').hide();
    		}
    	});
    });

    /*
     * Księgowość księguje fakturę
     */
    $('.toAccount').live('click', function(e) {
    	e.preventDefault();
    	var formData = $('#stepForm').serialize();
    	$.ajax({
    		type		:		'post',
    		dataType	:		'html',
    		data		:		formData,
    		url			:		<cfoutput>"#URLFor(controller='Workflows',action='toAccount',params='cfdebug')#"</cfoutput>,
    		success		:		function(data) {
    			$('.ajaxcontent').html(data);
    			$('#flashMessages').hide();
    		}
    	});
    });

    /*
     * Przekazanie dokumentu do dodatkowego opisu. Opcja dostępna jest tylko dla księgowości.
     * Po dodatkowym opisie dokument znowu powraca do księgowości bez ponownej akceptacji, controllingu, itp.
     */
    $('.describeInvoice').live('click', function(e) {
    	e.preventDefault();
    	var formData = $('#stepForm').serialize();
    	$.ajax({
    		type		:		'post',
    		dataType	:		'html',
    		data		:		formData,
    		url			:		<cfoutput>"#URLFor(controller='Workflows',action='moveToDescription',params='cfdebug')#"</cfoutput>,
    		success		:		function(data) {
    			window.history.back(-1);
    			$('#flashMessages').hide();
    		}
    	});

    });

    /*
     * Przekazanie faktury zpowrotem do księgowości po usupełnieniu opisu.
     */
    $('.toAccounting').live('click', function(e) {
    	e.preventDefault();
    	var formData = $('#stepForm').serialize();
    	$.ajax({
    		type		:		'post',
    		dataType	:		'html',
    		data		:		formData,
    		url			:		<cfoutput>"#URLFor(controller='Workflows',action='toAccounting',params='cfdebug')#"</cfoutput>,
    		success		:		function(data) {
    			window.history.back(-1);
    			$('#flashMessages').hide();

    		}
    	});
    });

	$('.ajaxmodalloader').live('click', function() {
		$('#flashMessages').show();
	});

	$('.newRow').live('click', function (e) {
		e.preventDefault();

		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('#workflowStepDescTable tbody tr.last').before(data);
			}
		});

		validateinvoicetable();
	});

	<!---
		Obsługa szablonów opisu faktur.
	--->
	<!---
		Pokazanie formulara nazwy szablonu.
		Zapisanie szablonu.
	--->
	$('.save_invoice_template').live('click', function(e) {
		e.preventDefault();
		$('.invoice_helper_list').hide('slow');
		$('.invoice_helper_add').toggle('slow');
	});

	<!---
		Pobranie listy dostępnych szablonów.
	--->
	$('.get_invoice_template').live('click', function(e) {
		e.preventDefault();
		$('.invoice_helper_add').hide('slow');
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url			:	$(this).attr('href'),
			success		:	function(data) {
				$('.invoice_helper_list').html(data).toggle('slow');
			}
		});
	});

	<!---
		Pobranie konkretnego szablonu i załadowanie go
	--->
	$('.user_template').live('click', function(e) {
		e.preventDefault();

		$('#flashMessages').show();
		$.ajax({
			type		:	'get',
			contentType	:	"application/json; charset=utf-8",
			dataType	:	'json',
			url			:	$(this).attr('href'),
			success		:	function(data) {
				var tmpJSON = jQuery.parseJSON(data);

				<!---
					Usuwam tabelkę, która teraz znajduje się przy fakturze.
				--->
				$('#workflowStepDescTable > tbody > tr').not('.last').remove();

				<!---
					Wstawiam opis faktury z szablonu.
				--->
				$.each(data.ROWS, function(i, item) {

					var _newrow = "<tr class=\"" + i + "\">"
						+ "<td class=\"leftBorder bottomBorder\">"
						+ "<input class=\"input searchmpk\" id=\"workflow-table-" + i + "-mpk\" name=\"workflow[table[" + i + "][mpk]]\" type=\"text\" value=\"" + item.MPK + " - " + item.M_NAZWA + "\" />"
						+ "<input class=\"input\" id=\"workflow-table-" + i + "-mpkid\" name=\"workflow[table[" + i + "][mpkid]]\" type=\"hidden\" value=\"\" />"
						+ "</td>"
						+ "<td class=\"leftBorder bottomBorder\">"
						+ "<input class=\"input searchproject\" id=\"workflow-table-" + i + "-project\" name=\"workflow[table[" + i + "][project]]\" type=\"text\" value=\"" + item.PROJEKT + " - " + item.P_NAZWA + "; " + item.P_OPIS + "; " + item.MIEJSCEREALIZACJI + "\" />"
						+ "<input class=\"input\" id=\"workflow-table-" + i + "-projectid\" name=\"workflow[table[" + i + "][projectid]]\" type=\"hidden\" value=\"\" />"
						+ "</td>"
						+ "<td class=\"leftBorder rightBorder bottomBorder\">"
						+ "<input type=\"text\" class=\"smallInput c priceelement\"  name=\"workflow[table[" + i + "][price]]\" /></td>"
						+ "<td class=\"rightBorder bottomBorder\">"
						+ "<a class=\"deleteRow\" href=\"\"><img alt=\"Delete\" height=\"16\" src=\"/dev/images/delete.png\" width=\"16\" /></a>"
						+ "</td>"
						+ "</tr>";

					$('#workflowStepDescTable tbody tr.last').before(_newrow);

				});
				<!---
					Dodałem już tabelkę, teraz dodaje notke merytoryczną i tworzę pole
					z identyfikatorem szablonu.
				--->
				$('#workflow-workflowstepnote').val(data.DECREE_NOTE);
				$('#invoicetemplateid').val(data.TEMPLATEID);
				$('.update_button').show();

				<!---
					Waliduje tabelkę opisującą fakturę
				--->
				validateinvoicetable();

				$('#flashMessages').hide();

			}
		});
		<!---
			Koniec pobierania Ajaxowego tabelki opisującej fakture
		--->



	});

	<!---
		Zapis szablonu
	--->
	$('#submit_invoice_template_name').live('click', function(e) {
		e.preventDefault();

		var formdata = $('#stepForm').serializeObject();

		$.ajax({
			type		:	'post',
			dataType	:	'html',
			url			:	$('#save_invoice_template_form').attr('action'),
			data		:	{template_name:$('#invoice_helper_template_name').val(),template_data:formdata},
			success		:	function(data) {
				alert('Szablon został zapisany prawidłowo.');
			}
		});
	});
	<!---
		Koniec obsługi opisu faktur.
	--->

	<!---
		Aktualizacja szablonu już wybranego.
		Aktualizacja odbywa się w następujący sposób: Usuwane są wszystkie poprzednie
		dane i dodawane nowe.
	--->
	$('.update_invoice_template').live('click', function(e) {
		e.preventDefault();

		var formdata = $('#stepForm').serializeObject();

		$.ajax({
			type		:	'post',
			dataType	:	'html',
			url			:	$(this).attr('href'),
			data		:	{template_id:$('#invoicetemplateid').val(),template_data:formdata},
			success		:	function(data) {
				alert('Szablon został zaktualizowany prawidłowo.');
			}
		});
	});
	<!---
		Koniec aktualizowania zapisanego szablonu.
	--->

	<!---
		Usunięcie szablonu przez użytkownika.
		Usunięcie odbywa się poprzez kliknięcie w x obok nazwy szablonu.
	--->
	$('.delete_invoice_template').live('click', function(e) {
		var _li = $(this).parent();
		$('#flashMessages').show();
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url			:	'<cfoutput>#URLFor(controller="Documents",action="deleteTemplate")#</cfoutput>',
			data		:	{key:$(this).attr('id')},
			success		:	function(data) {
				_li.fadeOut("slow").remove();
				$('#flashMessages').hide();
			}
		});
	});

});

$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name] !== undefined) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

function roundNumber(num, dec) {
	var result = Math.round(num*Math.pow(10,dec))/Math.pow(10,dec);
	return result;
}

function validateinvoicetable() {
	<!---
	/*
	 * Zliczanie kwoty netto w opisie faktury
	 * Kalkulator składa się z dwóch pół. Jedno pole zawiera sumę wpisanych opisów.
	 * Drugie pole zawiera kwotę pozostałą do rozpisania.
	 */

	/*
	 * Zmienne używane w kalkulatorze netto
	 */
	--->
	 var priceSum = roundNumber(0, 2);
	 var priceOdd = parseFloat($('.finallprice').html().replace(',', '.')).toFixed(2);

	<!---
	/*
	 * Zliczanie kwoty opisu i obliczanie ile kwoty pozostało.
	 */
	--->
	 $('.priceelement').each(function (i) {
	 	var tmpPrice = ($(this).attr('value') == "") ? roundNumber(0, 2) : roundNumber(parseFloat($(this).attr('value').replace(',', '.')), 2);
	 	priceSum += roundNumber(tmpPrice, 2);
	 	priceOdd -= roundNumber(tmpPrice, 2);
	 });

	<!---
	/*
	 * Umieszczenie danych na formularzu.
	 */
	--->
	 $('.pricesum').val(roundNumber(priceSum, 2).toString());
	 $('.priceodd').val(roundNumber(priceOdd, 2).toString());

	<!---
	/*
	 * Koloruje pola z tekstem
	 */
	--->
	if (priceSum != parseFloat($('.finallprice').html().replace(',', '.')).toFixed(2)) {
		$('.pricesum').css('color','#eb0f0f');
	} else {
		$('.pricesum').css('color','#9eca29');
	}

	if (priceOdd == 0) {
		$('.priceodd').css('color', '#9eca29');
	} else {
		$('.priceodd').css('color', '#eb0f0f');
	}

}

</script>

</div> <!--- end ajaxcontent --->