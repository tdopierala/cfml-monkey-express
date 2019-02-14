<cfprocessingdirective pageencoding="utf-8" />

<tr class="expand-child">
	<td class="bottomBorder szary leftBorder rightBorder">&nbsp;</td>
	<td colspan="<cfoutput>#5+ccount#</cfoutput>" class="bottomBorder bialy rightBorder">
		
		<cfif notatka.recordCount GT 0>
			<div class="aosNotatkaDoArkusza">
			<a href="javascript:void(0)" onclick="podgladNotatkiDoArkusza(<cfoutput>#notatka.id#</cfoutput>)" title="Zobacz notatkę pokontrolną">Do tego AOS jest sporządzona notatka. Ocena wypadkowa: <span><cfoutput>#notatka.score#</cfoutput></span></a>
			</div>
		</cfif>
		
		<table class="uiTable aosTable">
			<thead>
				<tr>
					<th class="leftBorder topBorder rightBorder bottomBorder"><span>Treść pytania</span></th>
					<th class="topBorder rightBorder bottomBorder"><span>Odpowiedź</span></th>
					<th class="topBorder rightBorder bottomBorder"><span>Punkty</span></th>
					<th class="topBorder rightBorder bottomBorder"><span>Odwołanie PPS</span></th>
					<th class="topBorder rightBorder bottomBorder"><span>Decyzja Centrali</span></th>
				</tr>
			</thead>
			<tbody>
				
				<!---<cfdump var="#structListaZagadnien#" />
				<cfabort />--->

				<cfloop collection="#structListaZagadnien#" item="i">
					<tr>
						<td colspan="5" class="leftBorder rightBorder bottomBorder jasnoFioletowy">
							<cfoutput>#structListaZagadnien["#i#"]["nazwazadania"]#</cfoutput>
							<cfloop query="odpowiedzi">
								<cfif Compare("#iddefinicjizadania#", "#i#") EQ 0
									and Compare(UCase("#nazwapola#"), UCase("Ocena")) EQ 0>
									(<cfoutput>#nazwapola#: #wartoscpola# / #structListaZagadnienWersjami[structListaZagadnien["#i#"]["wersja"]][structListaZagadnien["#i#"]["nazwazadania"]]#</cfoutput>)
								<cfelse>
									<cfcontinue />
								</cfif>
							</cfloop>
						</td>
					</tr>

					<cfloop query="odpowiedzi">
						<cfif Compare("#iddefinicjizadania#", "#i#") EQ 0
							and Compare(UCase("#nazwapola#"), UCase("Ocena")) NEQ 0>
							<tr <cfif Compare(UCase("#wartoscpola#"), UCase("Nie")) EQ 0> class="redText" </cfif>>
								<td class="leftBorder rightBorder bottomBorder l"><cfoutput>#nazwapola#</cfoutput></td>
								<td class="rightBorder bottomBorder l">
									<cfif Compare(UCase("#wartoscpola#"), UCase("Wykonane")) EQ 0>
										
										<cfinvoke component="controllers.Eleader" method="pobierzZdjecie" returnvariable="zdj" >
											<cfinvokeargument name="idaktywnosci" value="#idaktywnosci#" />
											<cfinvokeargument name="idpola" value="#iddefinicjipola#" />
											<cfinvokeargument name="idzadania" value="#iddefinicjizadania#" />
										</cfinvoke>
										
										<cfset notatka = zdj.notatka />
										
										<cfscript>
											if (
											(not fileExists(expandPath("files/eleader/min_thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg")) or
												not fileExists(expandPath("files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg")))
											and Len( zdj.wartoscbinaria )
											) {
												myImage = ImageNew(zdj.wartoscbinaria);
												
												// Zapisanie normalnego zdjęcia							
												imageWrite(myimage, expandPath("files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"));
											
												// Zapisanie miniaturki
												imageResize(myImage, 50, 50, "highestperformance");
												imageWrite(myimage, expandPath("files/eleader/min_thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"));
												
												theImage = ImageRead(expandPath("files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"));
												
												
												// Obrócenie normalnego zdjęcia
												theImage = ImageRead(expandPath("files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"));
												
												// Pobieram orientacje zdjęcia
												orientation = imageGetEXIFTag(theImage, 'orientation');
												
												// Sprawdzam, czy istnieje atrybut orientacji zdjęcia
												if ( !isNull( orientation ) ){
													hasRotate = findNoCase('rotate', orientation);
													
													// Sprawdzam, czy muszę obrócić zdjęcie
													if ( hasRotate ){
														// Wyciągam stopnie do obrotu zdjęcia
														rotateValue = reReplace(orientation, '[^0-9]', '', 'all');
														
														// Obracam zdjęcie
														ImageRotate(theImage, rotateValue);
														ImageWrite(theImage, expandPath("files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"), true, 1);
													}
												}
												
												// Obrócenie miniaturki
												// Obrócenie normalnego zdjęcia
												theImageThumb = ImageRead(expandPath("files/eleader/min_thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"));
												
												// Pobieram orientacje zdjęcia
												orientation = imageGetEXIFTag(theImageThumb, 'orientation');
												
												// Sprawdzam, czy istnieje atrybut orientacji zdjęcia
												if ( !isNull( orientation ) ){
													hasRotate = findNoCase('rotate', orientation);
													
													// Sprawdzam, czy muszę obrócić zdjęcie
													if ( hasRotate ){
														// Wyciągam stopnie do obrotu zdjęcia
														rotateValue = reReplace(orientation, '[^0-9]', '', 'all');
														
														// Obracam zdjęcie
														ImageRotate(theImageThumb, rotateValue);
														ImageWrite(theImageThumb, expandPath("files/eleader/min_thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"), true, 1);
													}
												}
												
											
											}
										</cfscript>
										<a href="<cfoutput>files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg</cfoutput>" title="<cfoutput>#notatka#</cfoutput>" target="_blank" class="fancybox" rel="gallery<cfoutput>#idaktywnosci#</cfoutput>">
											<cfif fileExists( expandPath( "files/eleader/min_thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg" ) )>
												<cfimage action="writeToBrowser" source="#expandPath('files/eleader/min_thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg')#" /> 
											</cfif>
										</a>
										
									<cfelse>
										<cfoutput>#wartoscpola#</cfoutput>
									</cfif>
								</td>
								<td class="rightBorder bottomBorder r">
									<cfif Compare(UCase("#wartoscpola#"), UCase("Nie")) NEQ 0>
										<cfoutput>#punkty#</cfoutput>
									</cfif>
								</td>
								<td class="rightBorder bottomBorder l">
									<cfif Compare(UCase("#wartoscpola#"), UCase("Nie")) EQ 0>
										<cfset endDate = DateAdd("d", 5, poczatekaktywnosci) />
										<cfif DateCompare( endDate, Now() ) EQ 1>
										<cfoutput><a href="javascript:void(0)" onclick="odwolanieOdOceny('#idaktywnosci#', '#iddefinicjizadania#', '#iddefinicjipola#', '#kodsklepu#')" title="Odwołaj się od oceny" class="odwolanieOdOceny">
											<span>Odwołaj się</span>
										</a></cfoutput>
										<cfelse>
											<span class="koniecOdwolania">
												Termin składania odwołania upłynął.
											</span>
										</cfif>
									</cfif>
								</td>
								<td class="rightBorder bottomBorder l">
									<a href="javascript:showCFWindow('uzasadnienie<cfoutput>#idodwolania#</cfoutput>', 'Uzasadnienie decyzji', 'index.cfm?controller=eleader&action=appeal&id=<cfoutput>#idodwolania#</cfoutput>')" title="Pokaż uzasadnienie" class="odwolanieOdOceny"><span><cfoutput>#nazwastatusu#</cfoutput></span></a>
								</td>
							</tr>
						<cfelse>
							<cfcontinue />
						</cfif>
					</cfloop>
				</cfloop>
				
			</tbody>
			
		</table>
		
	</td>
</tr>

