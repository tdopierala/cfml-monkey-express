<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Edytuj listę materiałów reklamowych</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<cfoutput>
				<ol class="">
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
			
			<cfdiv class="topBlock" id="dostepneMaterialyReklamowe" bind="url:index.cfm?controller=promocja_materialy&action=pobierz-dostepne-materialy-kampanii&idKampanii=#daneKampanii.idKampani#"></cfdiv>
			
			<!---<cfdiv class="bottomBlock" id="przypisaneMaterialyReklamowe"></cfdiv>--->
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
