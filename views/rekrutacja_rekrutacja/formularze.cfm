<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaIt" >
		<cfinvokeargument name="groupname" value="Departament Informatyki" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaPersonalny">
		<cfinvokeargument name="groupname" value="Departament Personalny" />
	</cfinvoke>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Formularze rekrutacji</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<ol class="vertical inline">
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_rekrutacja&action=lista-kandydatow', 'rekrutacja_rekrutacja')" class="web-button-blue web-button--with-hover" title="Lista kandydatów">Lista kandydatow</a>
				</li>
				
				<cfif uprawnieniaIt is true>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_pola&action=definicje-pol', 'rekrutacja_rekrutacja')" class="web-button2 web-button--with-hover" title="Definicje pól">Definicje pól</a>
				</li>
				</cfif>
				
				<cfif uprawnieniaIt is true>
				<li>
					<a href="javascript:void(0)" class="web-button2 web-button--with-hover" title="Typy plików">Typy plików</a>
				</li>
				</cfif>
				
				<cfif uprawnieniaIt is true>
				<li>
					<a href="javascript:void(0)" class="web-button2 web-button--with-hover" title="Typy plików">Pola formularza</a>
				</li>
				</cfif>
				
				<cfif uprawnieniaIt is true>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_pola&action=pola-ankiet', 'rekrutacja_rekrutacja')" class="web-button2 web-button--with-hover" title="Typy plików">Pola ankiet</a>
				</li>
				</cfif>
				
				<cfif uprawnieniaIt is true or uprawnieniaPersonalny is true>
				<li>
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_rekrutacja&action=raporty', 'rekrutacja_rekrutacja')" class="web-button2 web-button--with-hover" title="Raporty">Raporty</a>
				</li>
				</cfif>
				
				<li class="fr">
					<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_rekrutacja&action=nowy-formularz', 'rekrutacja_rekrutacja')" class="web-button-green web-button--with-hover" title="Dodaj kandydata">Dodaj kandydata</a>
				</li>
			</ol>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfdiv id="rekrutacja_rekrutacja"></cfdiv>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>