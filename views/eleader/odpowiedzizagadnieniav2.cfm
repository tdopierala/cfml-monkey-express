<cfprocessingdirective pageencoding="utf-8" />

<tr class="expand-child">
	<td class="bottomBorder leftBorder">&nbsp;</td>
	<td colspan="3" class="bottomBorder rightBorder bialy">
		
		<!---<cfif notatka.recordCount GT 0>
			<div class="aosNotatkaDoArkusza">
			<a href="javascript:void(0)" onclick="podgladNotatkiDoArkusza(<cfoutput>#notatka.id#</cfoutput>)" title="Zobacz notatkę pokontrolną">Do tego AOS jest sporządzona notatka. Ocena wypadkowa: <span><cfoutput>#notatka.score#</cfoutput></span></a>
			</div>
		</cfif>--->
		
		<table class="uiTable">
			<thead>
				<tr>
					<th class="topBorder rightBorder bottomBorder leftBorder">Pytanie</th>
					<th class="topBorder rightBorder bottomBorder">Odpowiedź</th>
					<th class="topBorder rightBorder bottomBorder">Odwołanie</th>
					<th class="topBorder rightBorder bottomBorder">Status odwołania</th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="odpowiedzi">
					<cfif Compare(UCase("#nazwapola#"), UCase("Ocena")) NEQ 0 >
						<!---<tr class="#LCase(wartoscpola)#">--->
						<tr class="<cfif UCase(wartoscpola) is UCase("Nie")> nie </cfif>" >
							<td class="bottomBorder rightBorder leftBorder l">#nazwapola#</td>
							<td class="bottomBorder rightBorder r">
								<cfif Compare(UCase("#wartoscpola#"), UCase("Wykonane")) EQ 0>
										
									<cfinvoke
										component="controllers.Eleader"
										method="pobierzZdjecie"
										returnvariable="zdj" >
										<cfinvokeargument name="idaktywnosci" value="#idaktywnosci#" />
										<cfinvokeargument name="idpola" value="#iddefinicjipola#" />
										<cfinvokeargument name="idzadania" value="#iddefinicjizadania#" />
									</cfinvoke>
										
									<cfset notatka = zdj.notatka />
										
									<cfscript>
										if (
										not fileExists(expandPath("files/eleader/min_thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg")) or
											not fileExists(expandPath("files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"))
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
									<a href="files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg" title="#notatka#" target="_blank" class="fancybox" rel="gallery#idaktywnosci#">
										<cfimage action="writeToBrowser" source="#expandPath('files/eleader/min_thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg')#" /> 
									</a>
										
								<cfelse>
									#wartoscpola#
								</cfif>
							</td>
							<td class="bottomBorder rightBorder l">
								<cfif Compare(UCase("#wartoscpola#"), UCase("Nie")) EQ 0>
									<cfset endDate = DateAdd("d", 10, poczatekaktywnosci) />
									<cfif DateCompare( endDate, Now() ) EQ 1>
										<a href="javascript:void(0)" onclick="odwolanieOdOceny('#idaktywnosci#', '#iddefinicjizadania#', '#iddefinicjipola#', '#kodsklepu#')" title="Odwołaj się od oceny" class="odwolanieOdOceny">
											<span>Odwołaj się</span>
										</a>
									<cfelse>
										<span class="koniecOdwolania">
											Termin składania odwołania upłynął.
										</span>
									</cfif>
								</cfif>
							</td>
							<td class="bottomBorder rightBorder l">#statusodwolania#</td>
						</tr>
					</cfif>
				</cfoutput>
			</tbody>
		</table>
		
	</td>
</tr>