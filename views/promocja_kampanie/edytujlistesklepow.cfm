<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Edytuj listę sklepów</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<cfoutput>
				<ol>
					<li>Nazwa kampanii: #daneKampanii.nazwaKampanii#</li>
					<li>Przewidziany budżet: #daneKampanii.przewidzianyBudzet#</li>
					<li>Data rozpoczęcia: #daneKampanii.dataKampaniiOd#</li>
					<li>Data zakończenia: #daneKampanii.dataKampaniiDo#</li>
				</ol>
			</cfoutput>
			<ol>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=edytuj-liste-sklepow&idKampanii=<cfoutput>#daneKampanii.idKampani#</cfoutput>', 'promocjaKampanie')" class="" title="Edytuj listę sklepów">Edytuj listę sklepów</a>
				</li>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=edytuj-liste-materialow&idKampanii=<cfoutput>#daneKampanii.idKampani#</cfoutput>', 'promocjaKampanie')" class="" title="Edytuj listę materiałów">Edytuj listę materiałów</a>
				</li>
			</ol>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfdiv class="leftTable" id="paginacjaListySklepow" bind="url:index.cfm?controller=promocja_kampanie&action=lista-sklepow-do-przypisania&idKampanii=#daneKampanii.idKampani#" bindonload="true" >
			</cfdiv>
			
			<cfdiv class="rightTable" id="paginacjaListyPrzypisanychSklepow" bind="url:index.cfm?controller=promocja_kampanie&action=lista-przypisanych-sklepow&idKampanii=#daneKampanii.idKampani#" bindonload="true" >
			</cfdiv>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
