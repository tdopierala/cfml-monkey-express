<cfprocessingdirective pageencoding="utf-8" />
<cfsilent>

</cfsilent>

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Hasła do kanału audio</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_audio&action=lista&t=1', 'left_site_column')" class="icon-refresh" title="Odśwież">
				<span>Odśwież</span>
			</a>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<table class="uiTable aosTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">#</th>
						<th class="topBorder bottomBorder rightBorder">Sklep</th>
						<th class="topBorder bottomBorder rightBorder">Login</th>
						<th class="topBorder bottomBorder rightBorder">Login mobilny</th>
						<th class="topBorder bottomBorder rightBorder">Hasło</th>
						<th class="topBorder bottomBorder rightBorder"></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="listaAudio">
						<tr>
							<td class="leftBorder bottomBorder rightBorder r">#idStoreAudio#</td>
							<td class="bottomBorder rightBorder l">#mpk#</td>
							<td class="bottomBorder rightBorder l">#login#</td>
							<td class="bottomBorder rightBorder l">#loginMobilny#</td>
							<td class="bottomBorder rightBorder l">#haslo#</td>
							<td class="bottomBorder rightBorder"></td>
						</tr>
					</cfoutput>
				</tbody>
				
			</table>

			<div class="uiFooter">
				<input type="file" name="audio" id="audio" />
				<input type="text" name="nazwaarkusza" id="nazwaArkusza" class="admin_input" placeholder="Nazwa arkusza w dokumencie"/>
				<a href="javascript:void(0)" class="admin_button green_admin_button" title="Załaduj plik z hasłami audio" id="zaladujPlik">Zapisz</a>
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<cfset ajaxOnLoad("initStoreAudio") />
</cfdiv>