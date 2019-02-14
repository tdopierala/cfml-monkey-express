<cfprocessingdirective pageencoding="utf-8" />

<tr class="expand-child">
	<td class="bottomBorder czerwony">&nbsp;</td>
	<td colspan="<cfoutput>#5+ccount#</cfoutput>" class="bottomBorder bialy">
		
		<cfif notatka.recordCount GT 0>
			<div class="aosNotatkaDoArkusza">
			<a href="javascript:void(0)" onclick="podgladNotatkiDoArkusza(<cfoutput>#notatka.id#</cfoutput>)" title="Zobacz notatkę pokontrolną">Do tego AOS jest sporządzona notatka. Ocena wypadkowa: <span><cfoutput>#notatka.score#</cfoutput></span></a>
			</div>
		</cfif>
		
		<cfloop query="odpowiedzi">
			<cfif wartoscpola IS "Nie">
				
				<div class="aosOdpowiedz">
					<h6><cfoutput>#structListaZagadnien["#IDDEFINICJIZADANIA#"]["nazwazadania"]#</cfoutput></h6>
					<table class="uiTable">
						<tbody>
							<tr>
								<td class="l p60"><cfoutput>#nazwapola#</cfoutput></td>
								<td class="l p20"><cfoutput>#wartoscpola#</cfoutput></td>
								<td class="l p20">
									<cfset endDate = DateAdd("d", 6, poczatekaktywnosci) />
									<cfif DateCompare( endDate, Now() ) EQ 1>
									<cfoutput><a href="javascript:void(0)" onclick="odwolanieOdOceny('#idaktywnosci#', '#iddefinicjizadania#', '#iddefinicjipola#', '#kodsklepu#')" title="Odwołaj się od oceny" class="odwolanieOdOceny">
										<span>Odwołaj się</span>
									</a></cfoutput>
									<cfelse>
										<span class="koniecOdwolania">
											Termin składania odwołania upłynął.
										</span>
									</cfif>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
			</cfif>
		</cfloop>
		
		<div class="aosOdpowiedz">
			<ul class="aosListaZdjec prettyGallery">
			<cfloop query="odpowiedzi">
				<cfif wartoscpola IS "Wykonane">
				
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
						not fileExists(expandPath("files/eleader/thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg")) or
							not fileExists(expandPath("files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"))
						) {
							myImage = ImageNew(zdj.wartoscbinaria);
							
							// Zapisanie normalnego zdjęcia							
							imageWrite(myimage, expandPath("files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"));
						
							// Zapisanie miniaturki
							imageResize(myImage, 100, 100, "highestperformance");
							imageWrite(myimage, expandPath("files/eleader/thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"));
							
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
							theImageThumb = ImageRead(expandPath("files/eleader/thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"));
							
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
									ImageWrite(theImageThumb, expandPath("files/eleader/thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg"), true, 1);
								}
							}
							
						
						}
					</cfscript>
					<a href="<cfoutput>files/eleader/#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg</cfoutput>" title="<cfoutput>#notatka#</cfoutput>" target="_blank" class="fancybox" rel="gallery<cfoutput>#idaktywnosci#</cfoutput>">
						<cfimage action="writeToBrowser" source="#expandPath('files/eleader/thumb_#iddefinicjipola#_#idaktywnosci#_#iddefinicjizadania#.jpg')#" /> 
					</a>
				
				</cfif>
			</cfloop>
			</ul>
		</div>
		
	</td>
</tr>