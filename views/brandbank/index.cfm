<cfsilent>



</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Brandbank</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<ol class="vertical inline">
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=brandbank&action=coverage-report', 'uiBrandBank')" class="web-button2 web-button2--with-hover" title="Wyślij raport Coverage Report">Coverage Report</a>
				</li>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=brandbank&action=get-product-data-for-gtin', 'uiBrandBank')" class="web-button2 web-button2--with-hover" title="Pobierz dane produktu">Pobierz dane produktu</a>
				</li>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=brandbank&action=get-unsent-product-data', 'uiBrandBank')" class="web-button2 web-button2--with-hover" title="Pobierz brakujące produkty">Pobierz brakujące produkty</a>
				</li>
				
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=brandbank&action=processing-data', 'uiBrandBank')" class="web-button2 web-button2--with-hover" title="Przetwarzaj dane">Przetwarzaj dane</a>
				</li>
				
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=brandbank&action=processing-images', 'uiBrandBank')" class="web-button2 web-button2--with-hover" title="Przetwarzaj grafiki">Przetwarzaj grafiki</a>
				</li>
			</ol>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<div id="uiBrandBank"></div>
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
