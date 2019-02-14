<cfsilent>
	<cfdirectory action="list" directory="#expandPath( "files/raport_pokrycia_produktow/" )#" name="raportySieci" filter="*.zip" type="all" sort="datelastmodified desc" />

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Raporty pokrycia sieci</h3>
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
						<th class="leftBorder topBorder rightBorder bottomBorder">Nazwa pliku</th>
						<th class="topBorder rightBorder bottomBorder">Data modyfikacji</th>
						<th class="topBorder rightBorder bottomBorder">Wielkość</th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="raportySieci">
					<tr>
						<td class="leftBorder bottomBorder rightBorder l">
							<a href="files/raport_pokrycia_produktow/#name#">#name#</a>
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

</cfdiv>