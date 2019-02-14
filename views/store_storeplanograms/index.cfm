<cfdiv id="left_site_column">

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Lista planogramów</h3>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<table class="uiTable">
				<thead>
					<tr>
						<th class="leftBorder rightBorder topBorder bottomBorder">Lp.</th>
						<th class="rightBorder topBorder bottomBorder">Kategoria regału</th>
						<th class="rightBorder topBorder bottomBorder">Typ regału</th>
						<th class="rightBorder topBorder bottomBorder">&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<cfset lp = 1 />
					<cfloop query="myShelfs">
						<cfif p EQ 0>
							<cfcontinue />
						</cfif>
						<tr <cfif (not Len(created)) or (not Len(session.user.date_from)) or (DateCompare(ParseDateTime(created), ParseDateTime(session.user.date_from)) EQ 1)>class="redRow"</cfif>>
							<td class="leftBorder rightBorder bottomBorder"><cfoutput>#lp#</cfoutput></td>
							<td class="rightBorder bottomBorder l"><cfoutput>#shelfcategoryname#</cfoutput></td>
							<td class="rightBorder bottomBorder l"><cfoutput>#shelftypename#</cfoutput></td>
							<td class="rightBorder bottomBorder l">
								<cfoutput>
								<a href="javascript:void(0);" onclick="javascript:showCFWindow('planograms_list-#storetypeid#-#shelftypeid#-#shelfcategoryid#', 'Lista planogramów', 'index.cfm?controller=store_planograms&action=shelf-store-planograms&storetypeid=#storetypeid#&shelftypeid=#shelftypeid#&shelfcategoryid=#shelfcategoryid#', 300, 500);" title="Pobierz planogram" class="">Pobierz planogram</a>
								</cfoutput>
							</td>
						</tr>
					<cfset lp = lp + 1 />
					</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="4" class="leftBorder rightBorder bottomBorder">
							<a href="index.cfm?controller=store_storeplanograms&action=get-floor-plan&key=<cfoutput>#myStore.id#</cfoutput>" title="Pobierz aktualny floor plan" target="_blank">Pobierz aktualny floor plan</a>
						</th>
					</tr>
				</tfoot>
			</table>

			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>