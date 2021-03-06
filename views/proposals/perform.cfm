<cfoutput>

<div class="ajaxcontent">

	<div class="wrapper">
	
		<h3>Wypełnienie wniosku</h3>
		
		<div class="wrapper">

			<div class="proposalsteps">
				<ul class="step2">
					<li><span>1. Wybór rodzaju wniosku</span></li>
					<li class="selected"><span>2. Wypełnienie wniosku</span></li>
					<li><span>3. Przekazanie do akceptacji</span></li>
				</ul>
			</div>
			
			<div class="wrapper proposalform">
			
				<h5>#proposalinformations.proposalType.proposaltypename#</h5>
				#startFormTag(controller="Proposals",action="proposalPreview")#
				<ol>
					<cfloop query="proposalfields">
					
						<!--- 
						Wybieram klasy dla pól z datą. 
						Pola z datą muszą się odejmować od siebie aby wyliczyć ilość dni roboczych urlopu 
						--->
						<cfset attributeclas = "" />
						
						<cfif attributeid eq 127>
							<cfset attributeclas = "datefrom" />
						</cfif>
						<cfif attributeid eq 128>
							<cfset attributeclas = "dateto" />
						</cfif>
						<cfif attributeid eq 129>
							<cfset attributeclas = "dayscount" />
						</cfif>
					
						<li>
						
							<cfif attributetypeid eq 1>
							
								#textFieldTag(
									name="proposalattributevalue[#id#]",
									value=proposalattributevaluetext,
									label=attributename,
									labelPlacement="before",
									class="input #attributeclas#")#
							
							</cfif>
							
							<cfif attributetypeid eq 4>
							
								#textFieldTag(
									name="proposalattributevalue[#id#]",
									value=proposalattributevaluetext,
									label=attributename,
									labelPlacement="before",
									class="input date_picker #attributeclas#",
									placeholder=attributename)#
							
							</cfif>
						
						</li>
					
					</cfloop>
					
					<li>
						#submitTag(value="Podgląd wniosku",class="smallButton redSmallButton")#
					</li>
					
				</ol>
				#endFormTag()#
							
			</div>

		</div><!-- /wrapper -->
	
	</div><!-- /wrapper -->

</div><!-- /ajaxcontent -->

</cfoutput>

<script type="text/javascript">

$(function() {
	$('.date_picker').datepicker({

		dateFormat: 'yy/mm/dd',
		monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
		dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So']
	});
	
	/*
	 * Obsługa zmiany pola z datą
	 */
	$('.date_picker').live('change', function () {
		var datefromtext = $('.datefrom').attr('value');
		var datetotext = $('.dateto').attr('value');
		
		var datefrom = (datefromtext) ? new Date(datefromtext) : new Date();
		var dateto = (datetotext) ? new Date(datetotext) : new Date();
		
		$('.dayscount').val((Math.abs(dateto-datefrom)/(1000*60*60*24)+1).toFixed(0));
		
	});
	
});

</script>
