<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Asortyment do wykluczenia</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<cfoutput>
			<ul class="uiBlankList">
				<li>#dostawca.contractor_name#</li>
				<li>#dostawca.contractor_street#, #dostawca.contractor_postal_code# #dostawca.contractor_city#</li>
				<li>#dostawca.contractor_telephone#</li>
			</ul>
			<ul class="uiBlankList">
				<li>Sklep: #projekt#</li>
			</ul>
			</cfoutput>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<table class="uiTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Lp.</th>
						<th class="topBorder rightBorder bottomBorder">Nazwa produktu</th>
						<th class="topBorder rightBorder bottomBorder">Indeks</th>
						<th class="topBorder rightBorder bottomBorder"></th>
					</tr>
				</thead>
				<tbody>
					<cfset indeks = 1 />
					<cfoutput query="produktyDoWykluczenia">
						<tr>
							<td class="leftBorder bottomBorder rightBorder">#indeks#</td>
							<td class="bottomBorder rightBorder l">#index_name#</td>
							<td class="bottomBorder rightBorder r">#index_index#</td>
							<td class="bottomBorder rightBorder">
								<cfset excluded = false />
								<cfloop query="produktyWykluczone">
									<cfif produktyWykluczone.contractor_index_id EQ produktyDoWykluczenia.id>
										<cfset excluded = true />
										<cfcontinue />
									</cfif>
								</cfloop>
								
								<cfif excluded is true>
									<input type="checkbox" name="excluded-contractor-#id#" id="excluded-contractor-#id#" value="1" checked="checked" class="exclude {id:#produktyDoWykluczenia.id#, contractorid:#contractorid#, store: '#store#'}" />
								<cfelse>
									<input type="checkbox" name="excluded-contractor-#id#" id="excluded-contractor-#id#" value="1" class="exclude {id:#produktyDoWykluczenia.id#, contractorid:#contractorid#, store: '#store#'}" />
								</cfif>
							</td>
						</tr>
						<cfset indeks++ />
					</cfoutput>
				</tbody>
			</table>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<cfset ajaxOnLoad("initWykluczIndeks") />