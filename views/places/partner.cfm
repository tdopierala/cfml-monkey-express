<cfoutput>
	
	<div class="wrapper">
	
		<h4>Partner ds. ekspansji</h4>
		
		<div class="forms partnerform">
		
			<h5>Formularz nieruchomości</h5>
		
			#startFormTag(
				method="post",
				controller="Places",
				action="actionUpdateAttributes",
				id="partnerform")#
			#hiddenFieldTag(name="placeid",value=place.id)#
			
			<cfset disabled = 'false' />
			<cfif workflow.step1status neq 1>
				<cfset disabled = 'true' />
			</cfif>
			
				<ol class="horizontal">
					
					<cfloop query="attributes">
						<cfparam name="required" default="" />
						<cfparam name="inputvalue" default="" />
						
						<cfif attributerequired eq 1>
						
							<cfset required = "required" />
						
						<cfelse>
						
							<cfset required = "" />
						
						</cfif>
						
						<!---
						10.09.2012
						Dodaje imię i nazwisko partnera, który dodał nieruchomość.
						--->
						
						<cfif attributeid eq 142>
						
							<cfset inputvalue = "#userplace.givenname# #userplace.sn#" />
						
						</cfif>
						
						<cfif attributeid eq 146>
						
							<cfset inputvalue = "#place.address#, #place.cityname#, #place.provincename#" />
						
						</cfif>
						
						<li>
						
							<cfif (attributetypeid eq 1 and attributeid eq 142) or (attributetypeid eq 1 and attributeid eq 146)> 
							<!--- 
								10.09.2012
								Wyjątek przy polach formularza 
								Sprawdzanie imienia i nazwiska partnera. 
								
								TODO
								Wstawianie imienia i nazwiska ma się odbywać automatycznie w modelu lub Controllerze!!!
								--->
							
								<cfif Len(placeattributevaluetext) eq 0> 
								<!--- Sprawdzam, czy imię i nazwisko partnera jest już zapisane.
									Jeżeli go nie ma to wstawiam imię i nazwisko z krotki tabeli places. Jeżeli imię i nazwisko jest
									to wstawiam je.
								 --->
								
									#textFieldTag(
										name="placeattributevalue[#placeattributevalueid#]",
										value=inputvalue,
										label=attributename,
										class="input #required#",
										labelPlacement="before",
										disabled=disabled)#
									
								<cfelse>
								
									#textFieldTag(
										name="placeattributevalue[#placeattributevalueid#]",
										value=placeattributevaluetext,
										label=attributename,
										class="input #required#",
										labelPlacement="before",
										disabled=disabled)#
								
								</cfif>
							
							<cfelseif attributetypeid eq 1>
							
								#textFieldTag(
									name="placeattributevalue[#placeattributevalueid#]",
									value=placeattributevaluetext,
									label=attributename,
									class="input #required#",
									labelPlacement="before",
									disabled=disabled)#
							
							<cfelseif (attributetypeid eq 2 and attributeid eq 142) or (attributetypeid eq 2 and attributeid eq 146)>
							
								<!--- 
								10.09.2012
								Wyjątek przy polach formularza 
								Sprawdzanie imienia i nazwiska partnera. 
								
								TODO
								Wstawianie imienia i nazwiska ma się odbywać automatycznie w modelu lub Controllerze!!!
								--->
							
								<cfif Len(placeattributevaluetext) eq 0> 
								<!--- Sprawdzam, czy imię i nazwisko partnera jest już zapisane.
									Jeżeli go nie ma to wstawiam imię i nazwisko z krotki tabeli places. Jeżeli imię i nazwisko jest
									to wstawiam je.
								 --->
								
									#textAreaTag(
										name="placeattributevalue[#placeattributevalueid#]",
										content=inputvalue,
										label=attributename,
										class="textarea #required#",
										labelPlacement="before",
										disabled=disabled)#
									
								<cfelse>
								
									#textAreaTag(
										name="placeattributevalue[#placeattributevalueid#]",
										content=placeattributevaluetext,
										label=attributename,
										class="textarea #required#",
										labelPlacement="before",
										disabled=disabled)#
								
								</cfif>
							
							<cfelseif attributetypeid eq 2>
							
								#textAreaTag(
									name="placeattributevalue[#placeattributevalueid#]",
									content=placeattributevaluetext,
									label=attributename,
									class="textarea #required#",
									labelPlacement="before",
									disabled=disabled)#
							
							<cfelseif attributetypeid eq 5>
							
								#selectTag(
									name="placeattributevalue[#placeattributevalueid#]",
									label=attributename,
									labelPlacement="before",
									options=options[attributeid],
									selected="#placeattributevaluetext#",
									disabled=disabled,
									class=required)#
							
							</cfif>
							
						
						</li>
					
					</cfloop>
					
					<li>
						<cfif workflow.step1status neq 1>
						
							#submitTag(value="Zapisz formularz",class="button darkGrayButton",disabled=disabled)#
							
						<cfelse>
							
							#submitTag(value="Zapisz formularz",class="button redButton",disabled=disabled)#
						
						</cfif>
						
						
					</li>
					
				</ol>
			
			#endFormTag()#
		
		</div>
		
		#includePartial(partial="changestatus")#
	
	</div>

</cfoutput>

<script>

$(function() {
	$('#partnerform').submit(function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		$.ajax({
			data		:		$(this).serialize(),
			type		:		"post",
			dataType	:		"html",
			url			:		$(this).attr('action'),
			success		:		function(data) {
				$('.ajaxcontent').html(data);
				$('#flashMessages').hide();
			}
		});
	
<!--- 		return false; --->
	});
	
	<!---
	17.08.2012
	Dodaje walidacje formularza. Pola obowiązkowe oznaczone są gwiazdką.
	--->
	$('.required').each(function (index) {
		$(this).parent().append("<span class=\"requiredfield\">*</span>");
	});
	
});

</script>