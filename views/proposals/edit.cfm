<cfoutput>

<div class="ajaxcontent">

	<div class="wrapper">
	
		<h3>Wypełnienie dokumentu</h3>
		
		<div class="wrapper">

			<div class="proposalsteps">
				<ul class="step2">
					<li><span>1. Wybór rodzaju dokumentu</span></li>
					<li class="selected"><span>2. Wypełnienie dokumentu</span></li>
					<li><span>3. Potwierdzenie</span></li>
					<li><span>4. Przekazanie do akceptacji</span></li>
				</ul>
			</div>
			
			<div class="wrapper proposalform">
				
				<cfif flashKeyExists("error")>
					<span class="error">#flash("error")#</span>
				</cfif>
			
				<h5>#proposalinformations.proposalType.proposaltypename#</h5>
				
				#startFormTag(controller="Proposals",action="confirmProposal",multipart="true")#
				
				#hiddenFieldTag(name="proposalid",value=params.key)#
				#hiddenFieldTag(name="proposaltypeid",value=proposalinformations.proposaltypeid)#
				
				<cfloop query="proposalfields">
				
					<!---
					9.07.2012
					Zmieniony został sposób wyznaczania dni urlopu. Teraz jest zakres od-do
					--->
					<cfif attributeid eq 127>
									
						#hiddenFieldTag(name="proposalholidayfrom",value=id)#
					
					</cfif>
					
					<cfif attributeid eq 128>
					
						#hiddenFieldTag(name="proposalholidayto",value=id)#
					
					</cfif> 
					
					<cfif attributeid eq 134>
					
						#hiddenFieldTag(name="holidaydates",value=id)#
					
					</cfif>
					
					
				</cfloop>

				<ol class="proposalfields">
					<cfloop query="proposalfields">

						<cfif attributeid neq 129 and attributeid neq 127 and attributeid neq 128 and attributeid neq 134>
							
							<cfif proposalattributevisible eq 0>
								
								<li style="display:none;">
								
								#hiddenFieldTag(
									name="proposalattributevalue[#id#]",
									value=proposalattributevaluetext)#
									
								<!---<cfbreak />--->
								<cfcontinue />
							
							<cfelseif attributeid eq 200>
								
								<li style="display:none;">
							
							<cfelse>
								
								<li>
								
							</cfif>
							
							<!--- 
							Wybieram klasy dla pól z datą. 
							Pola z datą muszą się odejmować od siebie aby wyliczyć ilość dni roboczych urlopu 
							--->
							
							<!---
								16.04.2013 - Tomek
								Zmieniam sposób prezentacji typów pól z bloków if na blok switch
							--->
							
							<cfif attributerequired eq 1 >
								<cfset required = ' required' />
							<cfelse>
								<cfset required = ' notrequired' />
							</cfif>
							
							<cfswitch expression="#attributetypeid#" >
								
								<cfcase value="1" >
									
									#textFieldTag(
										name="proposalattributevalue[#id#]",
										value=proposalattributevaluetext,
										label=attributename,
										labelPlacement="before",
										class="input #required#")#
									
								</cfcase>
								
								<cfcase value="2" >
									
									#textAreaTag(
										name="proposalattributevalue[#id#]",
										content=proposalattributevaluetext,
										label=attributename,
										labelPlacement="before",
										class="textarea #required#")#
									
								</cfcase>
								
								<cfcase value="3" >
									
									#fileFieldTag(
										name="proposalattributefile[#id#]",
										label=attributename,
										labelPlacement="before",
										class="filefield #required#")#
									
								</cfcase>
								
								<cfcase value="4" >
									
									<!---<cfparam name="cls" default="required" />
									<cfif attributeid eq 200>
										<cfset cls = "" />
									</cfif>--->
									
									<!---<cfif attributeid eq 200>--->
									#textFieldTag(
										name="proposalattributevalue[#id#]",
										value=proposalattributevaluetext,
										label=attributename,
										labelPlacement="before",
										class="input date_picker #required#",
										placeholder=attributename)#
									
									#hiddenFieldTag(
										name="attribute[#attributeid#]",
										value=id)#
									
								</cfcase>
								
								<cfcase value="5" >
									<cfif attributeid eq 200>
										<cfset ggg />
									</cfif>
									
									#selectTag(
										name="proposalattributevalue[#id#]",
										options=VARIABLES['options' & attributeid],
										selected="#proposalattributevaluetext#",
										includeBlank=false,
										label=attributename,
										labelPlacement="before",
										class=required & " attributeid"&attributeid)#
									<!-- #proposalattributevaluetext# -->
								</cfcase>
								
							</cfswitch>
							
							<!---<cfif attributetypeid eq 1>
	
								#textFieldTag(
									name="proposalattributevalue[#id#]",
									value=proposalattributevaluetext,
									label=attributename,
									labelPlacement="before",
									class="input required")#
	
							</cfif>
							
							<cfif attributetypeid eq 2>
	
								#textAreaTag(
									name="proposalattributevalue[#id#]",
									value=proposalattributevaluetext,
									label=attributename,
									labelPlacement="before",
									class="textarea")#
	
							</cfif>
							
							<cfif attributetypeid eq 3>
	
								#fileFieldTag(
									name="proposalattributevalue[#id#]",
									label=attributename,
									labelPlacement="before",
									class="filefield")#
	
							</cfif>
							
							<cfif attributetypeid eq 4>
	
								<cfparam name="cls" default="required" />
								<cfif attributeid eq 200>
									<cfset cls = "" />
								</cfif>
	
								#textFieldTag(
									name="proposalattributevalue[#id#]",
									value=proposalattributevaluetext,
									label=attributename,
									labelPlacement="before",
									class="input date_picker #cls#",
									placeholder=attributename)#
								
								#hiddenFieldTag(
									name="attribute[#attributeid#]",
									value=id)#
									
							</cfif>
							
							<cfif attributetypeid eq 5>
								
								#selectTag(
									name="proposalattributevalue[#id#]",
									options=VARIABLES['options' & attributeid],
									includeBlank=false,
									label=attributename,
									labelPlacement="before",
									class="required")#
							
							</cfif>--->
							
							<!---
							9.07.2012
							Zmieniam sposób zaznaczania daty urlopu.
							--->
							<!---
							<cfif attributeid eq 134>
							
								#textFieldTag(
									name="proposalholidaydate[#id#][0]",
									value=proposalattributevaluetext,
									label=attributename,
									labelPlacement="before",
									class="input date_pick_up required",
									placeholder=attributename)#
							
							</cfif>
						
							<cfif attributeid eq 134>
							
								<span class="newproposaldate">dodaj pole</span>
								<span class="deleterow">usuń pole</span>
							
							</cfif>
							--->
							
							</li>
							
						</cfif>
						
					</cfloop>
					
					<!--- Umieszczam pola z datą od-do urlopu --->
					<cfif proposalinformations.proposaltypeid eq 1>
					
						<li class="proposaldates">
						<label>Urlop w dniach</label>
							<cfloop query="proposalfields">
								
								<cfparam name="class" default="" />
								<cfif attributeid eq 127 or attributeid eq 128>
								
									<cfif attributeid eq 127>
									
										<cfset class = "proposalfrom" />
									
									</cfif>
									
									<cfif attributeid eq 128>
									
										<cfset class = "proposalto" />
									
									</cfif>
								
									#textFieldTag(
										name="proposalholidaydate[#id#][0]",
										value=proposalattributevaluetext,
										label=false,
										class="smallInput date_pick_up required fltl #class#",
										placeholder=attributename)#
								
								</cfif>
							
							</cfloop>
							
							<!---
							<span class="newproposaldate">dodaj wiersz</span>
							<span class="deleterow">usuń wiersz</span>
							--->
							
						</li>
					
					</cfif>
					
					<cfif proposalinformations.proposaltypeid eq 2>
					
						<li class="proposaldates">
						<label>Data wyjazdu</label>
							<cfloop query="proposalfields">
								
								<cfparam name="class" default="" />
								<cfif attributeid eq 127 or attributeid eq 128>
								
									#textFieldTag(
										name="proposalattributevalue[#id#]",
										value=proposalattributevaluetext,
										label=false,
										class="smallInput date_pick_up required fltl #class#",
										placeholder=attributename)#
									
									#hiddenFieldTag(name="attribute[#attributeid#]",value=id)#
								
								</cfif>
							
							</cfloop>
							
							<!---
							<span class="newproposaldate">dodaj wiersz</span>
							<span class="deleterow">usuń wiersz</span>
							--->
							
						</li>
					
					</cfif>
					
					<cfif proposalinformations.proposaltypeid eq 3>
					
						<li class="proposaldates">
						<label>Wyjazd w dniach</label>
							<cfloop query="proposalfields">
								
								<cfparam name="class" default="" />
								<cfif attributeid eq 127>
								
									#textFieldTag(
										name="proposalattributevalue[#id#]",
										value=proposalattributevaluetext,
										label=false,
										class="smallInput date_pick_up required proposalfrom fltl #class#",
										placeholder=attributename)#
										
									#hiddenFieldTag(name="attribute[#attributeid#]",value=id)#
									
								<cfelseif attributeid eq 128>
								
									#textFieldTag(
										name="proposalattributevalue[#id#]",
										value=proposalattributevaluetext,
										label=false,
										class="smallInput date_pick_up required proposalto fltl #class#",
										placeholder=attributename)#
										
									#hiddenFieldTag(name="attribute[#attributeid#]",value=id)#
								
								
								</cfif>
							
							</cfloop>
							
						</li>
					
					</cfif>
					
				</ol>
				
				<div class="clear"></div>
					
				<ol><li>
					<cfloop query="proposalfields">
						<!--- 
						Wybieram klasy dla pól z datą. 
						Pola z datą muszą się odejmować od siebie aby wyliczyć ilość dni roboczych urlopu 
						--->
							<cfset attributeclas = "" />
							
							<cfif attributeid eq 129>
								<cfset attributeclas = "dayscount" />
							</cfif>
						
							<cfif proposaltypeid eq 1 and attributeid eq 129>
								<cfif proposalattributevisible eq 0>
									
									<div style="display:none;">
										#textFieldTag(
											name="proposalattributevalue[#id#]",
											value=proposalattributevaluetext,
											label=attributename,
											labelPlacement="before",
											class="smallInput #attributeclas# required")#
									</div>
								
								<cfelse>
									
									#textFieldTag(
											name="proposalattributevalue[#id#]",
											value=proposalattributevaluetext,
											label=attributename,
											labelPlacement="before",
											class="smallInput #attributeclas# required")#

								</cfif>
								
							</cfif>							
					</cfloop>
				</li></ol>
				
				<cfif proposalinformations.proposaltypeid eq 1>
					<div class="substitution">
						<h5>Zastępstwo</h5>
						
						<ol>
							<li>
							
								#textFieldTag(
									name="substitutionsearchtext",
									value="",
									label="Wyszukaj pracownika",
									labelPlacement="before",
									class="input substitutionsearchtext",
									placeholder="Wyszukaj")#
							
							</li>

						</ol>
						
						<div class="informations">Możesz wybrać pracownika, który będzie Ciebie zastępował podczas Twojej nieobecności. W polu tekstowym wpisz początek imienia lub nazwiska a następnie wybierz właściwą osobę z listy.</div>
					
					</div>
				</cfif>
				
				<ol>
					<li>
						#submitTag(value="Zapisz",class="smallButton redSmallButton editProposal")#
					</li>
				</ol>
				
				#endFormTag()#
							
			</div>
			
		</div><!-- /wrapper -->
	
	</div><!-- /wrapper -->

</div><!-- /ajaxcontent -->

<!---<cfif session.user.id eq 345>
	<cfdump var="#proposalfields#"/>
</cfif>--->


</cfoutput>
<!---<cfdump var="#proposalfields#" />
<cfdump var="#proposalinformations#">--->
<script type="text/javascript">
$(function() {
	
	$(".attributeid135").on("change", function(){
		console.log($(this).val());
		if($(this).val() == "Urlop za nadgodziny"){
			$(this).closest("li").next("li").find("label").append("<span class=\"requiredfield\"> *</span>");
			$(this).closest("li").next("li").find(".date_picker").removeClass("notrequired").addClass("required");
			$(this).closest("li").next("li").show();
		} else {
			$(this).closest("li").next("li").hide();
			$(this).closest("li").next("li").find(".date_picker").removeClass("required").addClass("notrequired");
			$(this).closest("li").next("li").find("label").children("span").remove();
		}
	});

	// Dodanie nowej daty urlopu
	$('.newproposaldate').live('click', function() {
		$('#flashMessages').show();
		
		var jlink = $(this);
		var jdatefrom = $('#proposalholidayfrom').val();
		var jdateto = $('#proposalholidayto').val();
		
		$.ajax({
			type		:		'get',
			dataType	:		'html',
			data		:		{datefrom:jdatefrom,dateto:jdateto},
			url			:		"<cfoutput>#URLFor(controller='Proposals',action='getProposalHolidayDate')#</cfoutput>",
			success		:		function(data) {
				$(data).insertAfter('.proposalfields li:last');
				jlink.parent().find('.deleterow').show();
				jlink.remove();
				
				$('.requiredfield').remove();
				$('.required').each(function(i, element) {
					var toAppend = "<span class=\"requiredfield\"> *</span>";
					$(this).parent().find('label').append(toAppend);
				});
		
				$('#flashMessages').hide();
			},
			error		:		function(xhr, ajaxOptions, throwError) {}
		});
	});
	

	
	$('.required').each(function(i, element) {
		var toAppend = "<span class=\"requiredfield\"> *</span>";
		$(this).parent().find('label').append(toAppend);
	});
	
	// Format daty
	$('.date_pick_up').datepicker({
	
	<cfoutput>
	
		<cfif proposalinformations.proposaltypeid eq 1 or
			proposalinformations.proposaltypeid eq 2 or
			proposalinformations.proposaltypeid eq 3>
			
			showOn: "focus",
			
		<cfelse>
		
			showOn: "both",
			buttonImage: "images/schedule.png",
		
		</cfif>
	
	</cfoutput>
	
		buttonImageOnly: true,
		dateFormat: 'dd-mm-yy',
		monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
		dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
		firstDay: 1
	});
	
	// Walidacja formularza
	$('.editProposal').on('click', function(e) {
	
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
		
		$('.required').each(function(i) {
			
			$(this).css('borderColor', '#D7D7D7');
			
			if (!$(this).attr('value').length) {
				$(this).parent().append(errorRequired);
				$(this).css('borderColor', '#EB0F0F');
				//alert($(this).parent().html());
				error = true;
			}
		});
		
		if (error) e.preventDefault();
	
	});
	
	<!--- Skrypt JavaScript tylko dla wniosków urlopowych --->
	<cfif proposalinformations.proposaltypeid eq 1>
	
		<!--- Autouzupełnianie użytkowników --->
		$('.substitutionsearchtext').live('keyup', function(e) {
			$(this).autocomplete({
				source		:		function(request, response) {
					$.getJSON(<cfoutput>"#URLFor(controller='Users',action='getUsersList')#"</cfoutput>, {search: request.term}, response);				
				},
				select		:		function(element, ui) {
					
				}
			});
		});
		
	</cfif>
	
	<!--- Skrypt JavaScript tylko dla wniosków urlopowych i wniosków uczestnictwa --->
	<cfif proposalinformations.proposaltypeid eq 1 or proposalinformations.proposaltypeid eq 3>
	
		<!--- Pobieranie ilości dni w urlopie --->
		$('.proposalto').live('change', function(e) {
			$('#flashMessages').show();
			$.ajax({
				type		:		'post',
				dataType	:		'json',
				data		:		{from:$('.proposalfrom').val(),to:$('.proposalto').val()},
				url			:		<cfoutput>"#URLFor(controller='Proposals',action='countProposalDays',params='&format=json')#"</cfoutput>,
				success		:		function(data) {
					$('.dayscount').val(data.COUNT);
					$('#flashMessages').hide();
				}
			});
		});
		
		$('.proposalfrom').live('change', function(e) {
			$('#flashMessages').show();
			$.ajax({
				type		:		'post',
				dataType	:		'json',
				data		:		{from:$('.proposalfrom').val(),to:$('.proposalto').val()},
				url			:		<cfoutput>"#URLFor(controller='Proposals',action='countProposalDays',params='&format=json')#"</cfoutput>,
				success		:		function(data) {
					$('.dayscount').val(data.COUNT);
					$('#flashMessages').hide();
				}
			});
		});
		
	</cfif>
	
});
</script>
