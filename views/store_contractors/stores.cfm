<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Sklepy</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform action="index.cfm?controller=store_contractors&action=stores&contractorid=#contractorid#"
					name="store_contractors_stores_form" >
			
			<cfinput type="hidden" name="contractor_id" value="#contractorid#" />
				
			<table class="uiTable">
				<thead>
					<tr>
						<th class="topBorder rightBorder bottomBorder leftBorder"></th>
						<th class="topBorder rightBorder bottomBorder">Numer</th>
						<th class="topBorder rightBorder bottomBorder">Miasto</th>
						<th class="topBorder rightBorder bottomBorder">Ulica</th>
						<th class="topBorder rightBorder bottomBorder">Kod pocztowy</th>
					</tr>
					<tr>
						<th colspan="5" class="leftBorder bottomBorder rightBorder">
							<cfinput type="text" class="input" name="searchval" value="#searchVal#" />
							<cfinput type="submit" name="store_contractors_stores_form_filter"
									 class="admin_button green_admin_button" value="Filtruj" />
						</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="sklepy">
						<tr>
							<td class="leftBorder bottomBorder rightBorder"><cfinput type="checkbox" name="projekt" value="#projekt#" /></td>
							<td class="bottomBorder rightBorder l"><cfoutput>#projekt#</cfoutput></td>
							<td class="bottomBorder rightBorder l"><cfoutput>#miasto#</cfoutput></td>
							<td class="bottomBorder rightBorder l"><cfoutput>#ulica#</cfoutput></td>
							<td class="bottomBorder rightBorder l"><cfoutput>#kodpsklepu#</cfoutput></td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
			<cfinput type="submit" name="store_contractors_stores_form_submit"
					 class="admin_button green_admin_button" value="Zapisz" />
			
			</cfform>
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
