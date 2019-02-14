<cfsilent>

	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Struktura obiektów</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=objects&action=list-objects', 'uiObjectsContainer')" title="Struktura obiektów" class="web-button web-button--with-hover">Struktura obiektów</a>
			
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=objects&action=new-object-def', 'uiObjectsContainer')" title="Nowa definicja obiektu" class="web-button web-button--with-hover">Nowa definicja obiektu</a>
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=objects&action=new-attr-def', 'uiObjectsContainer')" title="Nowy Atrybut" class="web-button web-button--with-hover">Nowy atrybut</a>
			
			<a href="index.cfm?controller=objects&action=add" title="Dodaj instancje" class="web-button web-button--with-hover">Dodaj instancje</a>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfdiv id="uiObjectsContainer" bind="url:index.cfm?controller=objects&action=list-objects"></cfdiv>

			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>


</cfdiv>
