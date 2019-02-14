<div id="refreshCampaignMaterials" class="materialyKampanii">
	<div class="formularzMaterialu">
	<table class="uiTable">
		<thead>
			<tr>
				<th class="leftBorder topBorder rightBorder bottomBorder"></th>
				<th class="topBorder rightBorder bottomBorder">Nazwa materiału</th>
				<th class="topBorder rightBorder bottomBorder">Ilość</th>
				<th class="topBorder rightBorder bottomBorder">Cena jedn.</th>
				<th class="topBorder rightBorder bottomBorder">Pliki</th>
				<th class="topBorder rightBorder bottomBorder"></th>
			</tr>
		</thead>
		<tbody>
			<cfloop array="#materialyKampanii#" index="el">
				<tr>
					<td class="leftBorder bottomBorder rightBorder"></td>
					<td class="bottomBorder rightBorder l"><cfoutput>#el['nazwaTypuMaterialuReklamowego']#</cfoutput></td>
					<td class="bottomBorder rightBorder l">
						<input type="text" class="input" name="ilosc" />
					</td>
					<td class="bottomBorder rightBorder l">
						<input type="text" class="input" name="cenaJednostkowa" />
					</td>
					<td class="bottomBorder rightBorder l"></td>
					<td class="bottomBorder rightBorder">
						<div id="id-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>
						</td>
				</tr>
			</cfloop>
		</tbody>
	</table>
	</div>
</div>