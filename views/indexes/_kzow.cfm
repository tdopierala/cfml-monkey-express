<cfoutput>
	<div class="wrapper product_form">
		<h4 class="h4products">KZ/OW wraca do sprzedaży</h4>
		
		<cfform 
			action="#URLFor(action='uploadXls')#" 
			id="productcarduploadform" 
			method="post">
			<fieldset>
				<legend>Automatyczne ładowanie z karty produktów</legend>
				<ol>
					<li class="invoiceForm">
						<label>Plik z kartą produktu</label>
						<div class="_button">Wybierz plik
							<cfinput 
								name="filedata" 
								type="file"
								class="documentinstancecontent input_file"
								label="Plik z kartą produktu"
								size="1" />
						</div>
						<div id="productprogressbar" class="progressbar"></div>
					</li>
				</ol>
			</fieldset>
		</cfform>
		
		<div class="productSerachForm">
			<fieldset>
				<legend>Produkt do odblokowania</legend>
					
				#textFieldTag(name="productSearchToUnlock", label="Wyszukaj produkt do odblokowania", labelPlacement="before", class="input productsearch", autocomplete="off")#
			</fieldset>
		</div>
		
		#includePartial("form")#
		
		<div class="product_submit">
			#submitTag(value="Wyślij", class="formButton button redButton productSubmit")#
		</div>
		
	</div>
</cfoutput>