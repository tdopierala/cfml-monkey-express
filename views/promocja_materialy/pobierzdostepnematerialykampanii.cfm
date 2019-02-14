<cfprocessingdirective pageencoding="utf-8" />
	
<cfdiv id="refreshMaterialTypes">

<cfform name="dostepneMaterialyReklamoweForm" action="index.cfm?controller=promocja_kampanie&action=przypisz-typ-materialu-do-kampanii&idKampanii=#URL.idKampanii#">
	<table class="uiTable">
		<thead>
			<tr>
				<th class="leftBorder topBorder rightBorder bottomBorder"></th>
				<th class="topBorder rightBorder bottomBorder">Miniaturka</th>
				<th class="topBorder rightBorder bottomBorder">Nazwa materiału</th>
				<th class="topBorder rightBorder bottomBorder">Opis</th>
				<th class="topBorder rightBorder bottomBorder">&nbsp;</th>
			</tr>
		</thead>
		<tbody>
			<cfoutput query="typyMaterialow">
				<tr>
					<td class="leftBorder bottomBorder rightBorder"><input type="checkbox" name="idTypuMaterialuReklamowego" value="#idTypuMaterialuReklamowego#" /></td>
					<td class="bottomBorder rightBorder">
						<cfif Len(srcMiniaturki) GT 0 and fileExists(expandPath(srcMiniaturki))>
							<cfimage action="writeToBrowser" source="#expandPath(srcMiniaturki)#" />
						</cfif>
					</td>
					<td class="bottomBorder rightBorder l">#nazwaMaterialuReklamowego#</td>
					<td class="bottomBorder rightBorder l">#opisMaterialu#</td>
					<td class="bottomBorder rightBorder">
						<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=przypisz-typ-materialu-do-kampanii&idKampanii=#URL.idKampanii#&idTypuMaterialuReklamowego=#idTypuMaterialuReklamowego#', 'dostepneMaterialyReklamowe', initPlikMaterialuUpload, false)" class="btn" title="Przypisz typ materiału reklamowego">Dodaj</a>
					</td>
				</tr>
			</cfoutput>
		</tbody>
		<tfoot>
			<tr>
				<th colspan="5" class="leftBorder bottomBorder rightBorder l">
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=przypisz-typ-materialu-do-kampanii&idKampanii=<cfoutput>#URL.idKampanii#</cfoutput>', 'refreshMaterialTypes', initPlikMaterialuUpload, false, 'POST', 'dostepneMaterialyReklamoweForm')" class="btn">Dalej</a>
					<!---<cfinput type="submit" name="dostepneMaterialyReklamoweFormSubmit" value="Dalej" class="btn" />--->
				</th>
			</tr>
		</tfoot>
	</table>
</cfform>

<!---
<cfform name="dostepneMaterialyReklamoweForm" action="index.cfm?controller=promocja_kampanie&action=przypisz-typ-materialu-do-kampanii&idKampanii=#URL.idKampanii#">
<ol class="dostepneMaterialyReklamowe">
	<cfoutput query="typyMaterialow">
		<li>
			<span class="miniaturkaMaterialu">
				<cfif Len(srcMiniaturki) GT 0 and fileExists(expandPath(srcMiniaturki))>
					<cfimage action="writeToBrowser" source="#expandPath(srcMiniaturki)#" />
				<cfelse>
					<div class="dropArea id-#idTypuMaterialuReklamowego#" id="id-#idTypuMaterialuReklamowego#" data-id="#idTypuMaterialuReklamowego#">Drag & drop</div>
				</cfif>
			</span>
			<span class="nazwaMaterialu">#nazwaMaterialuReklamowego#</span>
			<span class="opisMaterialu">#opisMaterialu#</span>
			<span class="checkboxMaterialu"><input type="checkbox" name="idTypuMaterialuReklamowego" value="#idTypuMaterialuReklamowego#" /></span>
		</li>
	</cfoutput>
</ol>
<cfinput type="submit" name="dostepneMaterialyReklamoweFormSubmit" value="Dalej" class="btn" />
</cfform>
--->

</cfdiv>