<cfprocessingdirective pageencoding="utf-8" />

<cfsilent>
	<cfquery name="listaArkuszyAos" dbtype="query" >
		select * from listaAos, listaPivot where listaAos.idaktywnosci = listaPivot.idaktywnosci
	</cfquery>
</cfsilent>

<tr>
	<td colspan="7" class="leftBorder bottomBorder rightBorder">
		<div class="inside_table inside_table_padding">
			<table class="uiTable aosTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Data kontroli</th>
						<th class="topBorder rightBorder bottomBorder">Kontrolujący</th>
						<cfloop list="#listaArkuszyAos.columnList#" index="col">
							<cfif structKeyExists(structListaZagadnien, col)>
								<th class="topBorder rightBorder bottomBorder"><cfoutput>#structListaZagadnien[col]['nazwazadania']#</cfoutput></th>
								<th class="topBorder rightBorder bottomBorder"><cfoutput>#structListaZagadnien[col]['iloscpunktow']#</cfoutput></th>
							</cfif>
						</cfloop>
					</tr>
				</thead>
				<tbody>
					<cfloop query="listaArkuszyAos">
						<tr>
							<td class="leftBorder rightBorder bottomBorder whiteBackground"><cfoutput>#DateFormat(date_trunc, "dd/mm/yyyy")#</cfoutput></td>
							<td class="rightBorder bottomBorder whiteBackground">
								<!---<a href="javascript:void(0)" onclick="pokazDanyAos($(this), '<cfoutput>#idaktywnosci#</cfoutput>')" title="Pokaż arkusz">--->
									<cfoutput>#nazwiskopartnera# #imiepartnera#</cfoutput>
								<!---</a>--->
							</td>
							
							<cfloop list="#listaArkuszyAos.columnList#" index="col">
								<cfif structKeyExists(structListaZagadnien, col)>
									<td colspan="2" class="rightBorder bottomBorder whiteBackground">
										<a href="javascript:void(0)" onclick="pobierzPytania($(this), '<cfoutput>#idaktywnosci#</cfoutput>', '<cfoutput>#col#</cfoutput>')" class="<cfif structListaZagadnien[col]['iloscpunktow'] NEQ listaArkuszyAos[col][currentRow]>redText</cfif>" title="Pobierz pytania">
										<cfoutput>#listaArkuszyAos[col][currentRow]#</cfoutput>
										</a>
									</td>
								</cfif>
							</cfloop>
							
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</td>
</tr>