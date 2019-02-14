<cfoutput>
	<div class="wrapper product_form">
		<h4 class="h4products">Odblokowanie produktu w zamian za inny</h4>
		
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
		
		<h4 class="h4products">W zamian za:</h4>
		
		<fieldset>
			<legend>Produkt do zablokowania</legend>
				
			<div class="productSerachForm">
				#hiddenFieldTag(name="product[lock]", class="productid productlock product-input")#
				#textFieldTag(name="productSearchToLock", label="Wyszukaj produkt do zablokowania", labelPlacement="before", class="input productsearch required", autocomplete="off")#
			</div>
				
			<div class="product-form">
				<ol class="productDetails">
					<li>
						<label>Nazwa produktu:</label>
						<input type="text" name="productreplace-name" class="product-name input" value="" disabled="true" />
					</li>
					<li>
						<label>Kod kreskowy:</label>
						<input type="text" name="productreplace-barcode" class="product-barcode input" value="" disabled="true" />
					</li>
					<li>
						<label>Kategoria:</label>
						<input type="text" name="productreplace-cat" class="product-category input" value="" disabled="true" />
					</li>
					<li>
						<label>Producent:</label>
						<input type="text" name="productreplace-producer" class="product-producer input" value="" disabled="true" />
					</li>
					<li>
						<label>Wysokość:</label>
						<input type="text" name="productreplace-height" class="product-height input" value="" disabled="true" />
					</li>
					<li>
						<label>Szerokość:</label>
						<input type="text" name="productreplace-width" class="product-width input" value="" disabled="true" />
					</li>
					<li>
						<label>Głębokość:</label>
						<input type="text" name="productreplace-length" class="product-length input" value="" disabled="true" />
					</li>
				</ol>
			</div>
		</fieldset>
		
		<div class="product_submit">
			#submitTag(value="Wyślij", class="formButton button redButton productSubmit")#
		</div>
	</div>
</cfoutput>
<script>
	$(function(){
		
		$(".productSelected a").on("click", function(){
			$(this).parent().fadeOut("normal", function(){
				$(this).children("span").remove();
			});
			return false;
		});
		
	});
</script>