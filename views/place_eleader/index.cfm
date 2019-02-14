<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Integracja z eLeader</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<ol class="vertical inline">
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_eleader&action=formularz-sklepu', 'uiEleader')" class="web-button2 web-button--with-hover">Skojarz sklepy</a> 
				</li>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_eleader&action=formularz-parametrow', uiEleader)" class="web-button2 web-button--with-hover">Skojarz parametry sklepu</a>
				</li>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_eleader&action=pobrane-sklepy', 'uiEleader')" class="web-button2 web-button--with-hover">Pobrane sklepy z eLeader</a>
				</li>
			</ol>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<div id="uiEleader"></div>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>