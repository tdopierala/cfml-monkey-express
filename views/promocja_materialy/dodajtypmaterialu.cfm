<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitleSmall">Dodaj nowy typ materiału reklamowego</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform name="dodawanieTypuMaterialuForm" id="dodawanieTypuMaterialuForm" action="index.cfm?controller=promocja_materialy&action=dodaj-typ-materialu" enctype="multipart/form-data">
				<ol class="horizontal">
					<li>
						<label for="nazwaTypuMaterialu">Nazwa typu materiału</label>
						<cfinput type="text" name="nazwaTypuMaterialu" class="input" />
					</li>
					<li>
						<label for="opisMaterialu">Opis typu materiału reklamowego</label>
						<textarea name="opisMaterialu" class="textarea"></textarea>
					</li>
					<!---<li>
						<label for="srcMiniaturki">Miniaturka</label>
						<input type="file" id="srcMiniaturki" name="srcMiniaturki" /> 
					</li>--->
					<li>
						<cfinput type="submit" class="web-button2 web-button-green web-button--with-hover" value="Zapisz" name="dodawanieTypuMaterialuFormSubmit" />
						<a href="index.cfm?controller=promocja_materialy&action=materialy" title="Wróc do listy typów">Wróć do listy typów</a>
					</li>
				</ol>
			</cfform>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<!---<cfset ajaxOnLoad("initPromocja") />--->