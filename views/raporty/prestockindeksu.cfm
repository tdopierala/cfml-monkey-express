<cfprocessingdirective pageencoding="utf-8" />

<cfsilent>
	<cfdirectory action="list" directory="#expandPath( 'files/raport_prestock' )#" name="plikiPrestock" filter="RaportSieci[*]*.zip" sort="datelastmodified desc" type="all" />
</cfsilent>


<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Raport prestock indeksu w sieci</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=raporty&action=prestock-indeksu', 'user_profile_cfdiv')" title="Odśwież" class="icon-refresh"><span>Odśwież</span></a>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<table class="uiTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Nazwa pliku</th>
						<th class="topBorder rightBorder bottomBorder">Data modyfikacji</th>
						<th class="topBorder rightBorder bottomBorder">Wielkość</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="plikiPrestock">
						<tr>
							<td class="leftBorder bottomBorder rightBorder l">
								<a href="files/raport_prestock/#name#">#name#</a>
							</td>
							<td class="bottomBorder rightBorder r">#DateFormat(datelastmodified, "yyyy/mm/dd")# #TimeFormat(datelastmodified, "HH:mm")#</td>
							<td class="bottomBorder rightBorder r">#NumberFormat( size/1024/1024, "0.00" )# MB</td>
						</tr>
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
