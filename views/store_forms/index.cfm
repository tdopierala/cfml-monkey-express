<cfsilent>



</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Formularze na sklepach</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<ol class="vertical inline">
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_forms&action=stores-forms', 'uiStoreForms')" title="Formularze sklepów" class="web-button2 web-button--with-hover">Formularze skepów</a>
				</li>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_forms&action=form-list', 'uiStoreForms')" title="Lista formularzy" class="web-button2 web-button--with-hover">Lista formularzy</a>
				</li>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=store_attributes&action=list-attributes', 'uiStoreForms')" title="Lista atrybutów" class="web-button2 web-button--with-hover">Lista atrybutów</a>
				</li>
			</ol>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<div id="uiStoreForms"></div>
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>