<cfprocessingdirective pageencoding="utf-8" />

<div id="refreshCampaignMaterials" class="materialyKampanii">
	<div class="uiTable divAsTable">
		<div class="row">
			<div class="cell bottomBorder"></div>
		</div>
		<cfloop array="#materialyKampanii#" index="el">
			<cfdiv class="row" id="wierszMaterialuKampanii#el['idMaterialuKampanii']#">
			<cfform name="zapiszMaterialyKampanii#el['idMaterialuKampanii']#" action="index.cfm?controller=promocja_kampanie&action=zapisz-material-kampanii&idMaterialuKampanii=#el['idMaterialuKampanii']#" class="formularz">
				<div class="cell leftBorder rightBorder bottomBorder smallCell checkboxCell">
					<cfinput type="checkbox" name="idMaterialuKampanii" value="#el['idMaterialuKampanii']#" />
				</div>
				<div class="cell rightBorder bottomBorder bigCell titleCell">
					<cfoutput>#el['nazwaTypuMaterialuReklamowego']#</cfoutput>
				</div>
				<div class="cell rightBorder bottomBorder mediumCell inputCell">
					<cfinput type="text" class="input" name="ilosc" placeholder="Ilość" value="#el['ilosc']#"/>
				</div>
				<div class="cell rightBorder bottomBorder mediumCell inputCell">
					<cfinput type="text" class="input" name="cenaJednostkowa" placeholder="Cena jedn." value="#el['cenaJednostkowa']#" />
				</div>
				<div class="cell rightBorder bottomBorder bigCell listCell">
					<cfset pliki = el['plikiMaterialuReklamowego'] />
					<cfloop query="pliki">
						<a href="<cfoutput>#srcMaterialu#</cfoutput>" target="blank" class="" title="Pobierz plik">Pobierz plik</a><br />
					</cfloop>
				</div>
				<div class="cell bottomBorder bigCell dragAndDropCell">
					<div id="id-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>
						
					<!---<div id="id-2-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>
						
					<div id="id-3-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>--->
				</div>
				<div class="cell rightBorder bottomBorder mediumCell submitCell">
					<cfoutput>
						<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=zapisz-material-kampanii&idMaterialuKampanii=#el['idMaterialuKampanii']#', 'wierszMaterialuKampanii#el['idMaterialuKampanii']#', initPlikMaterialuUpload, false, 'POST', 'zapiszMaterialyKampanii#el['idMaterialuKampanii']#')" class="btn" title="Zapisz">Zapisz</a>
					</cfoutput>
				</div>
			</cfform>
			</cfdiv>
		</cfloop>
	</div>
</div>



<!---	<ol class="olAsTable">
		<li class="olHeader">
			<span class="leftBorder topBorder rightBorder bottomBorder"></span>
			<span class="topBorder rightBorder bottomBorder">Nazwa materiału</span>
			<span class="topBorder rightBorder bottomBorder">Ilość</span>
			<span class="topBorder rightBorder bottomBorder">Cena jedn.</span>
			<span class="topBorder rightBorder bottomBorder">Pliki</span>
			<span class="topBorder bottomBorder"></span>
			<span class="topBorder rightBorder bottomBorder"></span>
		</li>
		<cfloop array="#materialyKampanii#" index="el">
			<li id="" class="olElement">
				<div id="wierszMaterialuKampanii<cfoutput>#el['idMaterialuKampanii']#</cfoutput>">
				<cfform name="zapiszMaterialyKampanii#el['idMaterialuKampanii']#" action="index.cfm?controller=promocja_kampanie&action=zapisz-material-kampanii&idMaterialuKampanii=#el['idMaterialuKampanii']#">
				<span class="leftBorder rightBorder bottomBorder">
					<cfinput type="checkbox" name="idMaterialuKampanii" value="#el['idMaterialuKampanii']#" />
				</span>
				<span class="rightBorder bottomBorder">
					<cfoutput>#el['nazwaTypuMaterialuReklamowego']#</cfoutput>
				</span>
				<span class="rightBorder bottomBorder">
					<cfinput type="text" class="input" name="ilosc" />
				</span>
				<span class="rightBorder bottomBorder">
					<cfinput type="text" class="input" name="cenaJednostkowa" />
				</span>
				<span class="rightBorder bottomBorder">Pliki</span>
				<span class="bottomBorder">
					<div id="id-1-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>
						
						<div id="id-2-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>
						
						<div id="id-3-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>
				</span>
				<span class="bottomBorder rightBorder">
					<cfoutput>
						<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=zapisz-material-kampanii&idMaterialuKampanii=#el['idMaterialuKampanii']#', 'wierszMaterialuKampanii#el['idMaterialuKampanii']#', false, false, 'POST', 'zapiszMaterialyKampanii#el['idMaterialuKampanii']#')" class="btn" title="Zapisz">Zapisz</a>
					</cfoutput>
				</span>
				</cfform>
				</div>
			</li>
		</cfloop>
	</ol>	
</div>

--->
<!---		</table>
		
			<cfloop array="#materialyKampanii#" index="el">
				<cfform name="zapiszMaterialyKampanii#el['idMaterialuKampanii']#" action="index.cfm?controller=promocja_kampanie&action=zapisz-material-kampanii&idMaterialuKampanii=#el['idMaterialuKampanii']#">

					<td class="bottomBorder rightBorder l"><cfoutput>#el['nazwaTypuMaterialuReklamowego']#</cfoutput></td>
					<td class="bottomBorder rightBorder">
						<cfinput type="text" class="input" name="ilosc" />
					</td>
					<td class="bottomBorder rightBorder">
						<cfinput type="text" class="input" name="cenaJednostkowa" />
					</td>
					<td class="bottomBorder rightBorder l"></td>
					<td class="bottomBorder">
						
						<div id="id-1-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>
						
						<div id="id-2-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>
						
						<div id="id-3-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>
						
					</td>
					<td class="bottomBorder rightBorder">
						<cfoutput>
						<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=zapisz-material-kampanii&idMaterialuKampanii=#el['idMaterialuKampanii']#', 'wierszMaterialuKampanii#el['idMaterialuKampanii']#', false, false, 'POST', 'zapiszMaterialyKampanii#el['idMaterialuKampanii']#')" class="btn" title="Zapisz">Zapisz</a>
						</cfoutput>
					</td>
				</tr>
				</tbody></table>
				</cfform>
			</cfloop>
		
	
	</div>
</div>--->


<!---
<div id="refreshCampaignMaterials">

	<cfloop array="#materialyKampanii#" index="el" >
		<cfdiv id="materialKampanii#el['idMaterialuKampanii']#" class="materialyKampanii">
			<div class="naglowekMaterialu">
				<h5><cfoutput>#el['nazwaTypuMaterialuReklamowego']#</cfoutput></h5>
			</div>
			
			<div class="formularzMaterialu">
				<cfoutput>
				<form name="materialKampanii#el['idMaterialuKampanii']#Form" action="index.cfm?controller=promocja_kampanie&action=zapisz-material-kampanii&idKampanii=#el['idKampanii']#">
				<ol class="horizontal">
					<li>
						<label for="ilosc">Ilość</label>
						<input type="text" class="input" name="ilosc" />
					</li>
					<li>
						<label for="cenaJednostkowa">Cena jednostkowa</label>
						<input type="text" class="input" name="cenaJednostkowa" />
					</li>
					<li>
						<label for="załączonePliki">Załączone pliki</label>
					</li>
					<li>
						<label for="pliki">Pliki</label>
						<div id="id-<cfoutput>#el['idKampanii']#-#el['idMaterialuKampanii']#</cfoutput>" class="dragAndDrop" data-idkampanii="<cfoutput>#el['idKampanii']#</cfoutput>" data-idmaterialukampanii="<cfoutput>#el['idMaterialuKampanii']#</cfoutput>" data-idtypumaterialureklamowego="<cfoutput>#el['idTypuMaterialuReklamowego']#</cfoutput>">Drop</div>
					</li>
					<li>
						<span class="labelSpacer"></span>
						<input type="submit" name="materialKampanii#el['idMaterialuKampanii']#FormSubmit" value="Zapisz" class="btn" />
					</li>
				</ol>
				</form>
				</cfoutput>
			</div>
			
			<!---<cfset ajaxOnLoad("initPlikMaterialuUpload") />--->
			
		</cfdiv>
		
		<!---<cfset ajaxOnLoad("initPlikMaterialuUpload") />--->
		
	</cfloop>

<!---<cfset ajaxOnLoad("initPlikMaterialuUpload") />--->

</div>
--->

<!---<cfset ajaxOnLoad("initPlikMaterialuUpload") />--->