<cfsilent>
	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="raporty">

	<div class="leftWrapper">
		
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Ilość wprowadzonych faktur</h3>
			</div>
		</div>
		
		<div class="headerNavArea">
			<div class="headerNavArea uiHeaderNavArea">
				
				<cfform name="raport_ilosc_wprowadzonych_faktur" action="index.cfm?controller=raporty&action=ilosc-wprowadzonych-faktur&t=true">
					<div class="form-inline">
						<div class="form-group">
							<label for="miesiac_od">Miesiąc od</label>
							<select name="miesiac_od" class="select_box">
								<cfloop from="1" to="#arraylen(miesiace)#" index="m">
									<cfoutput><option value="#m#" <cfif m eq session.ilosc_faktur.miesiac_od> selected="selected" </cfif>>#miesiace[m]#</option></cfoutput>
								</cfloop>
							</select>
						</div>
						<div class="form-group">
							<label for="miesiac_do">Miesiąc do</label>
							<select name="miesiac_do" class="select_box">
								<cfloop from="1" to="#arraylen(miesiace)#" index="m">
									<cfoutput><option value="#m#" <cfif m eq session.ilosc_faktur.miesiac_do> selected="selected" </cfif>>#miesiace[m]#</option></cfoutput>
								</cfloop>
							</select>
						</div>
						<div class="form-group">
							<label for="rok">Rok</label>
							<select name="rok" class="select_box">
								<cfloop collection="#lata#" item="l">
									<cfoutput><option value="#l#" <cfif l eq session.ilosc_faktur.rok> selected="selected" </cfif>>#lata[l]#</option></cfoutput>
								</cfloop> 
							</select>
						</div>
						<div class="form-group">
							<cfinput name="raport_ilosc_wprowadzonych_faktur_submit" type="submit" class="btn" value="Generuj" />
						</div>
					</div>
				</cfform>
				
			</div>
		</div>
	
		<div class="contentArea">
			<div class="contentArea uiContent">
				
				<cfchart format="png" scalefrom="0" scaleto="50" chartwidth="925" chartheight="320">
					
					<cfloop from="#session.ilosc_faktur.miesiac_od#" to="#session.ilosc_faktur.miesiac_do#" index="m" >
						<cfchartseries type="bar" serieslabel="#miesiace[m]#" >
							<cfquery name="elementy" dbtype="query" >
								select * from raport 
								where m = <cfqueryparam value="#m#" cfsqltype="cf_sql_integer" />
							</cfquery>
							
							<cfif elementy.RecordCount GT 0>
								<cfloop query="elementy">
									<cfchartdata item="#givenname# #sn#" value="#ilosc#"  />
								</cfloop>
							</cfif>
						</cfchartseries>
					</cfloop>
					
				</cfchart>
				
				<div class="uiFooter">
					
					<table class="uiTable">
						<thead>
							<tr>
								<th class="leftBorder topBorder rightBorder bottomBorder">Rok</th>
								<th class="topBorder rightBorder bottomBorder">Miesiąc</th>
								<th class="topBorder rightBorder bottomBorder">Uzytkownik</th>
								<th class="topBorder rightBorder bottomBorder">Ilość dokumentów</th>
							</tr>
						</thead>
						<tbody>
							<cfoutput query="raport">
								<tr>
									<td class="leftBorder bottomBorder rightBorder r">#y#</td>
									<td class="bottomBorder rightBorder l">#miesiace[m]#</td>
									<td class="bottomBorder rightBorder l">#givenname# #sn#</td>
									<td class="bottomBorder rightBorder r">#ilosc#</td>
								</tr>
							</cfoutput>
						</tbody>
					</table>
					
				</div>
			</div>
		</div>
	
		<div class="footerArea">
		</div>
	
	</div>


</cfdiv>
