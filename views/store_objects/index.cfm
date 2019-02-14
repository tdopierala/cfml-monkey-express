<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Obiekty przypisane do sklepu</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<ol class="vertical inline">
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_objects&action=add-object-to-store', 'uiObjectsContainer')" title="Przypisz obiekt do sklepu" class="web-button2 web-button--with-hover">Przypisz obiekt do sklepu</a>
				</li>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_objects&action=list-objects', 'uiObjectsContainer')" title="Lista obiektów" class="web-button2 web-button--with-hover">Lista obiektów</a>
				</li>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_attributes&action=list-attributes', 'uiObjectsContainer')" title="Lista atrybutów" class="web-button2 web-button--with-hover">Lista atrybutów</a>
				</li>
			</ol>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<div id="uiObjectsContainer"></div>

			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>
