<cfoutput>	
		
<!---
	<table class="newtables placestable">

		<thead>
			<tr class="top">
				<th class="bottomBorder" colspan="6">
					<span class="selectall">
						#checkBoxTag(
							name="places")#
					</span>
					
					#linkTo(
					text="<span>Do archiwum</span>",
					controller="Places",
					action="archive",
					class="archiveplace",
					title="Do archiwum")#
					
				</th>
			</tr>
		</thead>

		<tbody>
--->
			<!---
			7.09.2012
			Sposób wyświetlania nieruchomości uległ zmianie. Do wyników wyszukiwania jest dołączona lista z krokami i ich statusami.
			W każdym kroku wyświetlam tylko to, co ma status 1 (w trakcie).
			Nad tabelką trzeba umieścić podsumowanie, ile czego jest.
			--->
			<h4>Partner ds sprzedaży</h4>
			<table class="newtables placestable">
				<tbody>
					<cfloop query="places">
						<cfif step1status eq 1> <!--- Sprawdzam, czy pierwszy krok jwst "w trakcie" --->
							
							<tr>
								<td class="bottomBorder">
								
									#checkBoxTag(
										name="place-#id#")#
								
								</td>
								
								<th class="bottomBorder">
									<span class="graystar">&nbsp;</span>
								</th>
								
								<th class="bottomBorder">
									<cfif priority eq 0>
									
										<span class="importantplace {placeid:#id#}">&nbsp;</span>
									
									<cfelseif priority eq 1>
									
										<span class="highimportantplace {placeid:#id#}">&nbsp;</span>
									
									</cfif>
								</th>
								
								<td class="bottomBorder">
								
									#linkTo(
										text="#cityname#, #address#, #provincename#",
										controller="Places",
										action="view",
										key=id)#
								
								</td>
								<td class="bottomBorder">#DateFormat(placecreated, "dd-mm-yyyy")# godz. #TimeFormat(placecreated, "HH:mm")#</td>
								<td class="bottomBorder">#givenname# #sn#</td>
								
								<td class="bottomBorder"><span class="yellow">&nbsp;</span></td>
							</tr>
							
						</cfif> <!--- Koniec sprawdzania warunku, czy jest to pierwszy krok w trakcie --->
					</cfloop> <!--- Koniec przechodzenia przez wyniki wyszukiwania --->
				</tbody>
			</table>
			
			<h4>Weryfikacja</h4>
			<!--- Przechodzenie przez wyniki wyszukiwania i prezentowanie drugiego kroku obiegu nieruchomości --->
			<table class="newtables placestable">
			
				<tbody>
					
					<cfloop query="places"> <!--- Przechodzenie przez wyniki wyszukiwania --->
						<cfif step2status eq 1> <!--- Sprawdzam, czy pierwszy krok jwst "w trakcie" --->
							
							<tr>
								<td class="bottomBorder">
								
									#checkBoxTag(
										name="place-#id#")#
								
								</td>
								
								<th class="bottomBorder">
									<span class="graystar">&nbsp;</span>
								</th>
								
								<th class="bottomBorder">
									<cfif priority eq 0>
									
										<span class="importantplace {placeid:#id#}">&nbsp;</span>
									
									<cfelseif priority eq 1>
									
										<span class="highimportantplace {placeid:#id#}">&nbsp;</span>
									
									</cfif>
								</th>
								
								<td class="bottomBorder">
								
									#linkTo(
										text="#cityname#, #address#, #provincename#",
										controller="Places",
										action="view",
										key=id)#
								
								</td>
								<td class="bottomBorder">#DateFormat(placecreated, "dd-mm-yyyy")# godz. #TimeFormat(placecreated, "HH:mm")#</td>
								<td class="bottomBorder">#givenname# #sn#</td>
								
								<td class="bottomBorder"><span class="purple">&nbsp;</span></td>
							</tr>
							
						</cfif> <!--- Koniec sprawdzania warunku, czy jest to pierwszy krok w trakcie --->
					</cfloop> <!--- Koniec przechodzenia przez wyniki wyszukiwania --->
					
				</tbody>
			
			</table>
			<!--- Koniec wyświetlania drugiego kroku obiegu dokumentów --->
			
			<h4>Uzupełnienie danych</h4>
			<!--- Przechodzenie przez wyniki wyszukiwania i prezentowanie trzeciego kroku obiegu nieruchomości --->
			<table class="newtables placestable">
			
				<tbody>
					
					<cfloop query="places"> <!--- Przechodzenie przez wyniki wyszukiwania --->
						<cfif step3status eq 1> <!--- Sprawdzam, czy trzeci krok jest "w trakcie" --->
							
							<tr>
								<td class="bottomBorder">
								
									#checkBoxTag(
										name="place-#id#")#
								
								</td>
								
								<th class="bottomBorder">
									<span class="graystar">&nbsp;</span>
								</th>
								
								<th class="bottomBorder">
									<cfif priority eq 0>
									
										<span class="importantplace {placeid:#id#}">&nbsp;</span>
									
									<cfelseif priority eq 1>
									
										<span class="highimportantplace {placeid:#id#}">&nbsp;</span>
									
									</cfif>
								</th>
								
								<td class="bottomBorder">
								
									#linkTo(
										text="#cityname#, #address#, #provincename#",
										controller="Places",
										action="view",
										key=id)#
								
								</td>
								<td class="bottomBorder">#DateFormat(placecreated, "dd-mm-yyyy")# godz. #TimeFormat(placecreated, "HH:mm")#</td>
								<td class="bottomBorder">#givenname# #sn#</td>
								
								<td class="bottomBorder"><span class="blue">&nbsp;</span></td>
							</tr>
							
						</cfif> <!--- Koniec sprawdzania warunku, czy jest to trzeci krok w trakcie --->
					</cfloop> <!--- Koniec przechodzenia przez wyniki wyszukiwania --->
					
				</tbody>
			
			</table>
			<!--- Koniec wyświetlania trzeciego kroku obiegu dokumentów --->
			
			<h4>Komitet</h4>
			<!--- Przechodzenie przez wyniki wyszukiwania i prezentowanie czwartego kroku obiegu nieruchomości --->
			<table class="newtables placestable">
			
				<tbody>
					
					<cfloop query="places"> <!--- Przechodzenie przez wyniki wyszukiwania --->
						<cfif step4status eq 1> <!--- Sprawdzam, czy cwarty krok jest "w trakcie" --->
							
							<tr>
								<td class="bottomBorder">
								
									#checkBoxTag(
										name="place-#id#")#
								
								</td>
								
								<th class="bottomBorder">
									<span class="graystar">&nbsp;</span>
								</th>
								
								<th class="bottomBorder">
									<cfif priority eq 0>
									
										<span class="importantplace {placeid:#id#}">&nbsp;</span>
									
									<cfelseif priority eq 1>
									
										<span class="highimportantplace {placeid:#id#}">&nbsp;</span>
									
									</cfif>
								</th>
								
								<td class="bottomBorder">
								
									#linkTo(
										text="#cityname#, #address#, #provincename#",
										controller="Places",
										action="view",
										key=id)#
								
								</td>
								<td class="bottomBorder">#DateFormat(placecreated, "dd-mm-yyyy")# godz. #TimeFormat(placecreated, "HH:mm")#</td>
								<td class="bottomBorder">#givenname# #sn#</td>
								
								<td class="bottomBorder"><span class="green">&nbsp;</span></td>
							</tr>
							
						</cfif> <!--- Koniec sprawdzania warunku, czy jest to czwarty krok w trakcie --->
					</cfloop> <!--- Koniec przechodzenia przez wyniki wyszukiwania --->
					
				</tbody>
			
			</table>
			<!--- Koniec wyświetlania czwartego kroku obiegu dokumentów --->
			
			<h4>Umowa</h4>
			<!--- Przechodzenie przez wyniki wyszukiwania i prezentowanie piąty kroku obiegu nieruchomości --->
			<table class="newtables placestable">
			
				<tbody>
					
					<cfloop query="places"> <!--- Przechodzenie przez wyniki wyszukiwania --->
						<cfif step5status eq 1> <!--- Sprawdzam, czy piąty krok jest "w trakcie" --->
							
							<tr>
								<td class="bottomBorder">
								
									#checkBoxTag(
										name="place-#id#")#
								
								</td>
								
								<th class="bottomBorder">
									<span class="graystar">&nbsp;</span>
								</th>
								
								<th class="bottomBorder">
									<cfif priority eq 0>
									
										<span class="importantplace {placeid:#id#}">&nbsp;</span>
									
									<cfelseif priority eq 1>
									
										<span class="highimportantplace {placeid:#id#}">&nbsp;</span>
									
									</cfif>
								</th>
								
								<td class="bottomBorder">
								
									#linkTo(
										text="#cityname#, #address#, #provincename#",
										controller="Places",
										action="view",
										key=id)#
								
								</td>
								<td class="bottomBorder">#DateFormat(placecreated, "dd-mm-yyyy")# godz. #TimeFormat(placecreated, "HH:mm")#</td>
								<td class="bottomBorder">#givenname# #sn#</td>
								
								<td class="bottomBorder"><span class="red">&nbsp;</span></td>
							</tr>
							
						</cfif> <!--- Koniec sprawdzania warunku, czy jest to piąty krok w trakcie --->
					</cfloop> <!--- Koniec przechodzenia przez wyniki wyszukiwania --->
					
				</tbody>
			
			</table>
			<!--- Koniec wyświetlania piątego kroku obiegu dokumentów --->
			
			
			
<!---
		</tbody>
	</table>
--->
		
</cfoutput>

<script>

$(function() {
	$('.importantplace').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		var id = $(this).metadata().placeid;
		var el = $(this);
		
		$.ajax({
			type: 'post',
			dataType: 'html',
			data: {key:id},
			url: <cfoutput>"#URLFor(controller='Places',action='changePriority',params='cfdebug')#"</cfoutput>,
			success: function(data) { 
				el.removeClass('importantplace').addClass('highimportantplace');
				$('#flashMessages').hide();
			}
		});
	});
	
	$('.highimportantplace').live('click', function(e) {
		e.preventDefault();
		$('#flashMessages').show();
		
		var id = $(this).metadata().placeid;
		var el = $(this);
		
		$.ajax({
			type: 'post',
			dataType: 'html',
			data: {key:id},
			url: <cfoutput>"#URLFor(controller='Places',action='changePriority',params='cfdebug')#"</cfoutput>,
			success: function(data) { 
				el.removeClass('highimportantplace').addClass('importantplace');
				$('#flashMessages').hide();
			}
		});
	});
});

</script>