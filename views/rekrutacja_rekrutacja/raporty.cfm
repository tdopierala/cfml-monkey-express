<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Raporty</h3>
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
						<th class="leftBorder topBorder rightBorder bottomBorder">Nazwa raportu</th>
						<th class="topBorder rightBorder bottomBorder"></th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="leftBorder bottomBorder rightBorder l">Ilość osób zaproszonych na rozmowy</td>
						<td class="bottomBorder rightBorder">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_raporty&action=raport-zaproszonych', 'rekrutacja_raporty')" class="icon-html" title="Raport HTML"><span>Ilość osób zaproszonych na rozmowy</span></a>
						</td>
					</tr>
					<tr>
						<td class="leftBorder bottomBorder rightBorder l">Ilość rozmów</td>
						<td class="bottomBorder rightBorder">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_raporty&action=raport-rozmow', 'rekrutacja_raporty')" class="icon-html" title="Raport HTML"><span>Ilość rozmów</span></a>
						</td>
					</tr>
					<tr>
						<td class="leftBorder bottomBorder rightBorder l">Ilość osób zainteresowanych</td>
						<td class="bottomBorder rightBorder">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_raporty&action=raport-zainteresowanych', 'rekrutacja_raporty')" class="icon-html" title="Raport HTML"><span>Ilość osób zainteresowanych</span></a>
						</td>
					</tr>
					<tr>
						<td class="leftBorder bottomBorder rightBorder l">Ilość rezygnacji</td>
						<td class="bottomBorder rightBorder">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_raporty&action=raport-rezygnacji', 'rekrutacja_raporty')" class="icon-html" title="Raport HTML"><span>Ilość rezygnacji</span></a>
						</td>
					</tr>
					<tr>
						<td class="leftBorder bottomBorder rightBorder l">Ilość skierowanych na szkolenie</td>
						<td class="bottomBorder rightBorder">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_raporty&action=raport-szkolenie', 'rekrutacja_raporty')" class="icon-html" title="Raport HTML"><span>Ilość skierowanych na szkolenie</span></a>
						</td>
					</tr>
				</tbody>
			</table>
			
			<div class="uiFooter">
				<cfdiv id="rekrutacja_raporty"></cfdiv>
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>