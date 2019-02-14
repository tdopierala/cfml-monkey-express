<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Lista zdefiniowanych kampanii</h3>
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
						<th class="topBorder rightBorder bottomBorder leftBorder"></th>
						<th class="topBorder rightBorder bottomBorder">Nazwa kampanii</th>
						<th class="topBorder rightBorder bottomBorder">Data rozpoczęcia</th>
						<th class="topBorder rightBorder bottomBorder">Data zakończenia</th>
						<th class="topBorder rightBorder bottomBorder">Budżet</th>
						<th class="topBorder rightBorder bottomBorder">Ilość sklepów</th>
						<th class="topBorder rightBorder bottomBorder"></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="listaKampanii">
						<tr>
							<td class="leftBorder bottomBorder rightBorder"><input type="checkbox" name="idKampanii" value="#idKampani#" /></td>
							<td class="bottomBorder rightBorder l">#nazwaKampanii#</td>
							<td class="bottomBorder rightBorder r">#dataKampaniiOd#</td>
							<td class="bottomBorder rightBorder r">#dataKampaniiDo#</td>
							<td class="bottomBorder rightBorder r">#przewidzianyBudzet#</td>
							<td class="bottomBorder rightBorder r">#iloscSklepow#</td>
							<td class="bottomBorder rightBorder">
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=edytuj-liste-sklepow&idKampanii=#idKampani#', 'promocjaKampanie')" class="icon-shopping-bag" title="Edytuj listę sklepów">
									<span>Edytuj listę sklepów</span>
								</a>
								
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=edytuj-liste-materialow&idKampanii=#idKampani#', 'promocjaKampanie')" class="icon-documents" title="Edytuj listę materiałów reklamowych">
									<span>Edytuj listę materiałów reklamowych</span>
								</a>
								
								<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=usun-kampanie&idKampanii=#idKampani#', 'promocjaKampanie')" class="icon-remove" title="Usuń kampanię reklamową">
									<span>Usuń kampanię reklamową</span>
								</a>
								
								<cfif isDefined("czyAktywna") and czyAktywna EQ 1>
									
									<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=zmien-status&idKampanii=#idKampani#', 'promocjaKampanie')" class="icon-stop" title="Zmień status kampanii">
										<span>Zmień status kampanii</span>
									</a>
										
								<cfelseif isDefined("czyAktywna")>
										
									<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=zmien-status&idKampanii=#idKampani#', 'promocjaKampanie')" class="icon-start" title="Zmień status kampanii">
										<span>Zmień status kampanii</span>
									</a>
										
								</cfif>
								
							</td>
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
