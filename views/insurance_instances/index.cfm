<cfprocessingdirective pageencoding="utf-8" />
	
<div class="leftWrapper">
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Ubezpieczenia</h3>
		</div>
	</div>
	
	<cfinclude template="_top.cfm" />
	
	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<table class="uiTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Rodzaj zgłoszenia</th>
						<th class="topBorder rightBorder bottomBorder">Data szkody</th>
						<th class="topBorder rightBorder bottomBorder">Data zgłoszenia</th>
						<th class="topBorder rightBorder bottomBorder">Aktualny status</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="insurances">
						<tr>
							<td class="leftBorder bottomBorder rightBorder">#categoryname#</td>
							<td class="bottomBorder rightBorder">#DateFormat(data_szkody, "dd.mm.yyyy")#</td>
							<td class="bottomBorder rightBorder">#DateFormat(data_zgloszenia, "dd.mm.yyyy")#</td>
							<td class="bottomBorder rightBorder"></td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
			
		</div>
	</div>
	
</div>