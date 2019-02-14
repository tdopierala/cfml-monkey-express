<cfsilent>
<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="privUsunieciePlanogramu" >
		<cfinvokeargument name="groupname" value="Usunięcie planogramu" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pTotalUnits" >
		<cfinvokeargument name="groupname" value="Total unit" />
	</cfinvoke>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			<table class="uiTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Pliki</th>
						<th class="topBorder rightBorder bottomBorder">Data obowiązywania od</th>
						<th class="topBorder rightBorder bottomBorder">Uwagi</th>
						<cfif pTotalUnits is true>
							<th class="topBorder rightBorder bottomBorder">Excel</th>
							<th class="topBorder rightBorder bottomBorder">&nbsp;</th>
						</cfif>
					</tr>
				</thead>
				<tbody>
					<cfloop array="#myPlanograms#" index="i">
						<tr>
							<td class="leftBorder bottomBorder rightBorder l">
								<ul class="vertical">
								<cfloop query="i.FILES">
									<li>
										<a href="files/planograms/<cfoutput>#filesrc#</cfoutput>" target="blank" title="Pobierz planogram"><cfoutput>#filename#</cfoutput></a>
										<cfif pTotalUnits is true and Len( xls )>
											<a href="files/planograms_totalunits/<cfoutput>#xls#</cfoutput>" target="blank" title="Pobierz excel"><cfoutput>#xls#</cfoutput></a>
										</cfif>
									</li>
								</cfloop>
								</ul>
							</td>
							<td class="bottomBorder rightBorder r">
								<!---<cfoutput>#DateFormat(i.date_from, "dd.mm.yyyy")#</cfoutput>--->
								<cfoutput>#DateFormat(i.date_from, "yyyy/mm/dd")#</cfoutput>
							</td>
							<td class="bottomBorder rightBorder l">
								<cfif Len(i.note)>
									<cfoutput>#i.note#</cfoutput>
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<cfif pTotalUnits is true>
								<td class="bottomBorder rightBorder r"><cfoutput>#i.xls#</cfoutput></td>
								<td class="bottomBorder rightBorder">
									<cfif privUsunieciePlanogramu is true>
										<a href="javascript:void(0);" title="Usuń" onclick="removeShelfPlanogram(<cfoutput>#i.PLANOGRAMID#</cfoutput>, $(this))" class="remove_shelf_planogram">
											<span>Usuń planogram</span>
										</a>
										
										<cfoutput>
										<a href="javascript:void(0)" class="icon-excel" title="Dodaj plik Excel z TU" onclick="javascript:initCfWindow('index.cfm?controller=store_planograms&action=xls-iframe&storetypeid=#i.storetypeid#&shelftypeid=#i.shelftypeid#&shelfcategoryid=#i.shelfcategoryid#&planogramid=#i.planogramid#', 'planograms_planograms_xls-#i.storetypeid#-#i.shelftypeid#-#i.shelfcategoryid#-#i.planogramid#', 535, 600, '', false, 100, 100)"><span>Dodaj plik Excel z TU</span></a>
										</cfoutput>
									</cfif>
								</td>
							</cfif>
						</tr>
					</cfloop>
				</tbody>
			</table>
	
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>