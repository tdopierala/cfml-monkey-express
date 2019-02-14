<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Materiały promocyjne</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<ol class="vertical inline">
				<li class="">
					<a href="index.cfm?controller=promocja_kampanie&action=kampanie" class="web-button2 web-button--with-hover" title="Kampanie reklamowe">
						<span>Kampanie reklamowe</span>
					</a>
				</li>
			</ol>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfdiv id="promocjaMaterialy">
				
			<table class="uiTable">
				<thead>
					<tr>
						<th class="topBorder rightBorder bottomBorder leftBorder"></th>
						<th class="topBorder rightBorder bottomBorder">Miniaturka</th>
						<th class="topBorder rightBorder bottomBorder">Nazwa typu materiału</th>
						<th class="topBorder rightBorder bottomBorder">Opis</th>
						<th class="topBorder rightBorder bottomBorder"></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="typyMaterialow">
						<tr>
							<td class="leftBorder bottomBorder rightBorder"><input type="checkbox" name="idTypuMaterialuReklamowego" value="#idTypuMaterialuReklamowego#" /></td>
							<td class="bottomBorder rightBorder c">
								<cfif Len(srcMiniaturki) GT 0 and fileExists(expandPath(srcMiniaturki))>
									<cfimage action="writeToBrowser" source="#expandPath(srcMiniaturki)#" />
								<cfelse>
									<div class="dropArea id-#idTypuMaterialuReklamowego#" id="id-#idTypuMaterialuReklamowego#" data-id="#idTypuMaterialuReklamowego#">Drag & drop</div>
								</cfif>
							</td>
							<td class="bottomBorder rightBorder l">#nazwaMaterialuReklamowego#</td>
							<td class="bottomBorder rightBorder l">#opisMaterialu#</td>
							<td class="bottomBorder rightBorder">
								<a href="javascript:void(0)" class="icon-edit" title="Edytuj"><span>Edytuj</span></a>
								<a href="index.cfm?controller=promocja_materialy&action=usun-typ-materialu&idTypuMaterialuReklamowego=#idTypuMaterialuReklamowego#" class="icon-remove" title="Usuń"><span>Usuń</span></a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="5" class="leftBorder bottomBorder rightBorder">
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_materialy&action=dodaj-typ-materialu', 'promocjaMaterialy')" title="Dodaj nowy typ materiału reklamowego">Dodaj nowy typ materiału reklamowego</a>
						</th>
					</tr>
				</tfoot>
			</table>
			
			</cfdiv>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<cfset ajaxOnLoad("initPromocjaUpload") />