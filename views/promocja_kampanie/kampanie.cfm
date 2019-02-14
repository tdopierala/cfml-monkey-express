<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Zdefiniowane kampanie reklamowe</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<ol class="vertical inline">
				<li class="fr">
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=dodaj-kampanie', 'promocjaKampanie')" class="web-button2 web-button--with-hover web-button-green" title="Dodaj kampanię">
						<span>Dodaj kampanię reklamową</span>
					</a>
				</li>
				<li class="">
					<a href="index.cfm?controller=promocja_materialy&action=materialy" class="web-button2 web-button--with-hover" title="Materiały reklamowe">
						<span>Materiały reklamowe</span>
					</a>
				</li>
				<li class="">
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=promocja_kampanie&action=lista-kampanii', 'promocjaKampanie')" class="web-button2 web-button--with-hover" title="Zdefiniowane kampanie">
						<span>Zdefiniowane kampanie</span>
					</a>
				</li>
			</ol>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfdiv id="promocjaKampanie" bind="url:index.cfm?controller=promocja_kampanie&action=lista-kampanii&reload=true"></cfdiv>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
