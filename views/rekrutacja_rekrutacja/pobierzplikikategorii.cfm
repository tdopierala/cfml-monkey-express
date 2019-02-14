<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />


<div class="contentArea">
	<div class="contentArea uiContent">
		
		<ol>
		<cfoutput query="pliki">
			<li><a href="files/rekrutacja_pliki/#nazwaPliku#" target="_blank" title="Pobierz plik">#nazwaPliku#</a></li>
		</cfoutput>
		</ol>
		
		<div class="uiFooter">
		</div>
	</div>
</div>

