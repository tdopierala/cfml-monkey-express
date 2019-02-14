<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="contentArea">
	<div class="contentArea uiContent">
		
		<cfoutput query="plikiFormularza">
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=rekrutacja_rekrutacja&action=pobierz-pliki-kategorii&idTypuPliku=#idTypuPliku#&idFormularza=#idFormularza#', 'rekrutacja_pliki')" title="#nazwaTypuPliku#">#nazwaTypuPliku# (#iloscPlikow#)</a>
		</cfoutput>
		
		<cfdiv id="rekrutacja_pliki"></cfdiv>
		
		<div class="uiFooter">
			
			<form name="plikiFormularza" id="plikiFormularza" action="index.cfm?controller=rekrutacja_rekrutacja&action=dodaj-plik" 
					enctype="multipart/form-data" onsubmit="">
				<input type="hidden" name="idFormularza" value="<cfoutput>#idFormularza#</cfoutput>" />
				<ol class="horizontal_right">
					<li>
						<label for="formFile">Plik</label>
						<input type="file" name="formFile" id="formFile" /> 
					</li>
					<li>
						<label for="idTypuPliku">Typ pliku</label>
						<select name="idTypuPliku" class="select_box">
							<cfoutput query="typyPlikow">
								<option value="#idTypuPliku#">#nazwaTypuPliku#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<span class="labelBlock">&nbsp;</span>
						<input name="plikiFormularzaSubmit" type="submit" value="Zapisz" class="btn btn-green" />
					</li>
				</ol>
			</form>
			
		</div>
	</div>
</div>

<cfset ajaxOnLoad("initRekrutacja") />