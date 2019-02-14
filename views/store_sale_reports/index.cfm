<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Raport sprzedaży na sklepach</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfform name="raport_sprzedazy_form" action="index.cfm?controller=store_sale_reports&action=index">
				
				<div class="form-inline">
					<div class="form-group">
						<select name="partnerid" class="select_box">
							<option value="">[KOS]</option>
							<cfoutput query="kos">
								<option value="#id#" <cfif id EQ session.raport_sprzedazy.partnerid> selected="selected" </cfif>>#givenname# #sn#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<cfinput type="text" name="sklep" class="input" placeholder="Numer sklepu" value="#session.raport_sprzedazy.sklep#" />
					</div>
				</div>
				
				<div class="form-inline">
					<div class="form-group">
						<label class="date-label" for="dzienOd">Data od</label>
						<cfinput type="datefield" name="dzienOd" validate="eurodate" mask="dd-mm-yyyy" class="input" placeholder="Data od" value="#DateFormat(session.raport_sprzedazy.dzienOd, "dd/mm/yyyy")#" />
					</div>
					<div class="form-group">
						<label class="date-label" for="dzienDo">Data do</label>
						<cfinput type="datefield" name="dzienDo" validate="eurodate" mask="dd-mm-yyyy" class="input" placeholder="Data do" value="#DateFormat(session.raport_sprzedazy.dzienDo, "dd/mm/yyyy")#" />
					</div>
					<div class="form-group">
						<cfinput type="submit" name="raport_sprzedazy_form_submit" class="btn" value="Generuj" />
					</div>
				</div>
				
			</cfform>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfif IsDefined("session.raport_sprzedazy.sklep") and Len(session.raport_sprzedazy.sklep) GT 3>
				
				<cfquery name="sklepy" dbtype="query">
					select distinct NAZWA1 from raport order by NAZWA1;
				</cfquery>
				
				<cfloop query="sklepy">
			
					<cfquery name="elementy" dbtype="query">
						select * from raport where NAZWA1 = '#sklepy.NAZWA1#' order by DZIEN DESC;
					</cfquery>
					
					<cfchart format="png" scalefrom="0" scaleto="50" chartwidth="720" chartheight="300" showborder="true" title="Raport dla Sklepu #sklepy.NAZWA1#" >
						
						<cfscript>
							odstep = Int(255 / (elementy.RecordCount+1));
							listaKolorow = "";
							for (i = 0; i < elementy.RecordCount; i++) {
								randomNumber = formatBaseN(abs(255-(i*odstep)), 16);
								if (Len("#randomNumber#") EQ 1) {
									randomNumber = "#randomNumber##randomNumber#";
								}
								listaKolorow = listAppend(listaKolorow, "0000#randomNumber#");
							}
						</cfscript>
						
						<cfchartseries type="bar" serieslabel="Obroty" colorlist="#listaKolorow#" >
							<cfloop query="elementy">
								<cfchartdata item="#DateFormat(DZIEN, "dd/mm/yyyy")#" value="#NumberFormat(s-z, 9.99)#" />
							</cfloop>
						</cfchartseries>
						
					</cfchart> 
				
				</cfloop>
			
			<cfelse>
			
				<cfquery name="sklepy" dbtype="query" >
					select distinct DZIEN from raport order by DZIEN DESC
				</cfquery>
				
				
				<cfloop query="sklepy">
					
					<cfchart format="png" scalefrom="0" scaleto="50" chartwidth="720" chartheight="600" showborder="true" title="Raport za okres #DateFormat(sklepy.DZIEN, "dd/mm/yyyy")# #TimeFormat(sklepy.DZIEN, "HH:mm")# do #DateFormat(sklepy.DZIEN, "dd/mm/yyyy")# #TimeFormat(DateAdd("n", -1, sklepy.DZIEN), "HH:mm")#">
						
						<cfquery name="elementy" dbtype="query">
							select * from raport where DZIEN = '#sklepy.DZIEN#' 
							order by s DESC;
						</cfquery>
						
						<cfscript>
							odstep = Int(255 / (elementy.RecordCount+1));
							listaKolorow = "";
							for (i = 0; i < elementy.RecordCount; i++) {
								randomNumber = formatBaseN(abs(255-(i*odstep)), 16);
								if (Len("#randomNumber#") EQ 1) {
									randomNumber = "#randomNumber##randomNumber#";
								}
								listaKolorow = listAppend(listaKolorow, "#randomNumber#0000");
							}
						</cfscript>
						
						<cfchartseries type="horizontalbar" serieslabel="Obroty" colorlist="#listaKolorow#" >
							<cfloop query="elementy">
								<cfchartdata item="#NAZWA1#" value="#NumberFormat(s-z, 9.99)#" />
							</cfloop>
						</cfchartseries>
						
					</cfchart>
					
				</cfloop>
			
			</cfif>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>