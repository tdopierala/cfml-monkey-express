<cfprocessingdirective pageencoding="utf-8" />
	
<cfloop array="#materialyKampanii#" index="el">
	<!---<cfdiv class="row" id="wierszMaterialuKampanii#el['idMaterialuKampanii']#">--->
	<cfform name="zapiszMaterialyKampanii#el['idMaterialuKampanii']#" action="index.cfm?controller=promocja_kampanie&action=zapisz-material-kampanii&idMaterialuKampanii=#el['idMaterialuKampanii']#" class="formularz">
		<div class="cell leftBorder rightBorder bottomBorder smallCell checkboxCell">
			<cfinput type="checkbox" name="idMaterialuKampanii" value="#el['idMaterialuKampanii']#" />
		</div>
		<div class="cell rightBorder bottomBorder bigCell titleCell">
			<cfoutput>#el['nazwaTypuMaterialuReklamowego']#</cfoutput>
		</div>
		<div class="cell rightBorder bottomBorder mediumCell inputCell">
			<cfinput type="text" class="input" name="ilosc" placeholder="Ilość" value="#el['ilosc']#" />
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
	<!---</cfdiv>--->
</cfloop>