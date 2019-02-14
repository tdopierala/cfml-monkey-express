<cfoutput>
	<div class="wrapper product_form">
		<h4 class="h4products">Propozycja nowego produktu w zamian za inny</h4>
						
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
		
		#includePartial("form")#
		
		<h4 class="h4products">w zamian za:</h4>
		
		<fieldset>
			<legend>Produkt do wycofania</legend>
			
			<div class="productSerachForm">
				#hiddenFieldTag(name="replaced",class="product-input")#
			
				#textFieldTag(name="productSearch", label="Wyszukaj produkt do wycofania", labelPlacement="before", class="productsearch input required", autocomplete="off")#
			</div>
			
			<div class="product-form">				
				<ol class="productDetails">
					<li>
						<label>Nazwa produktu:</label>
						<input type="text" name="productreplace-name" id="productreplace-name" class="product-name input" value="" disabled="true" />
					</li>
					<li>
						<label>Kod kreskowy:</label>
						<input type="text" name="productreplace-barcode" id="productreplace-barcode" class="product-barcode input" value="" disabled="true" />
					</li>
					<li>
						<label>Kategoria:</label>
						<input type="text" name="productreplace-cat" id="productreplace-cat" class="product-category input" value="" disabled="true" />
					</li>
					<li>
						<label>Producent:</label>
						<input type="text" name="productreplace-producer" id="productreplace-producer" class="product-producer input" value="" disabled="true" />
					</li>
					<li>
						<label>Wysokość:</label>
						<input type="text" name="productreplace-height" id="productreplace-height" class="product-height input" value="" disabled="true" />
					</li>
					<li>
						<label>Szerokość:</label>
						<input type="text" name="productreplace-width" id="productreplace-width" class="product-width input" value="" disabled="true" />
					</li>
					<li>
						<label>Głębokość:</label>
						<input type="text" name="productreplace-length" id="productreplace-length" class=" product-length input" value="" disabled="true" />
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
				
		$(document).on("click", "#productSelected a", function(){
			$("#productSearch").val('');
			$(this).parent().fadeOut("normal", function(){
				$(this).children("span").remove();		
			});
			return false;
		});
		
	});
</script>