<cfoutput>
	<div class="wrapper product_form">
		<h4 class="h4products">Propozycja nowego produktu od DM</h4>
		
		<!---<cfform 
			action="#URLFor(action='uploadXls')#" 
			id="productcarduploadform" 
			method="post">
			<fieldset>
				<legend>Automatyczne ładowanie z karty produktów</legend>
				<ol>
					<li class="invoiceForm">
						<label>Plik z kartą nowego produktu (*.xls)</label>
						<div class="_button">Wybierz plik
							<cfinput 
								name="filedata" 
								type="file"
								class="documentinstancecontent input_file"
								label="Plik z kartą produktu (*.xls)"
								size="1" />
						</div>
						<div id="productprogressbar" class="progressbar"></div>
					</li>
				</ol>
			</fieldset>
		</cfform>--->
		
		<!---#includePartial("form")#--->
			
		#startFormTag(action="actionAdd", multipart="true", id="product-form", class="product-form")#
				
				#hiddenFieldTag(name="index", value="#params.form#")#
				
				<fieldset>
					<legend>Szczegóły produktu</legend>
					
					<ol class="product-form">
						<li>
							#textFieldTag(name="product[name]", label="Nazwa produktu", labelPlacement="before", class="input product-name required")#
						</li>
						<li>
							#textFieldTag(name="product[barcode]", label="Kod kreskowy", labelPlacement="before", class="input product-barcode")#
						</li>
						<li>
							#textFieldTag(name="product[category]", label="Kategoria produktu", labelPlacement="before", class="input product-category required", autocomplete="off")#
						</li>
						<li>
							#textFieldTag(name="product[producer]", label="Producent", labelPlacement="before", class="input product-producer")#
						</li>
					</ol>
					
				</fieldset>
			
			#endFormTag()#
				
		<div class="product_submit">
			#submitTag(value="Wyślij", class="formButton button redButton productSubmit")#
		</div>
		
	</div>
</cfoutput>
<script>
	$(function(){
		
		var product_category_timeout;
		var product_category_options = {
			source	:
				function( request, response ) {
					clearTimeout(product_category_timeout);
					product_category_timeout = setTimeout(function() {
						$.ajax({
							url			: <cfoutput>"#URLFor(action='searchCategory')#"</cfoutput> + "&qstr=" + request.term,
							type		: "get",
							dataType	: "json",
							success		: function( data ) {
								response( $.map( data.ROWS, function( item ) {
									return {
										label: item.SUPERKATEGORIA.toLowerCase() + ' > ' + item.KATEGORIA.toLowerCase() + ' > ' + item.PODKATEGORIA.toLowerCase(),
										value: item.SUPERKATEGORIA.toLowerCase() + ' > ' + item.KATEGORIA.toLowerCase() + ' > ' + item.PODKATEGORIA.toLowerCase()
									}
								}));
							}
						});
					}, 500);
				}
			,minLength: 2
			,select: function( event, ui ) {
				var _text = ui.item.value;
				$('#product-category').val(_text.toLowerCase());
			}
		};		
		$("#product-category").autocomplete(product_category_options);
		
		$(document).on("click", ".productSubmit", function(){
			var flag = 0;
			
			$(document).find(".required").each(function(){
				
				$(this).removeClass("invalid").next(".invalidmsg").remove();
				
				if($(this).val() == ''){
					$(this).addClass("invalid").after('<span class="invalidmsg">&laquo;&nbsp;pole wymagane</span>');
					flag = 1;
				}
			});
			
			$(document).find("#product-form").find("ol").children("li").find("input.input").each(function(idx){
				var _this = $(this);
				if (_this.val() != 'undefined') {
					if(_this.hasClass("price")){ _this.val(_this.val().replace(",",".")); }
					
					if (_this.val().indexOf("CONCATENATE") > -1) {
						_this.addClass('invalid').after('<span class="invalidmsg">&laquo;&nbsp;nieprawidłowa wartość pola</span>');
						flag = 1;
					}					
				}
			});
			
			if (flag != 1) {
				$(document).find("#product-form").submit(); 
			}
			else { 
				$(document).find("#product-form")[0].scrollIntoView(true); 
				$("#flashMessages").hide();
			}
				
			return false;
		});
		
		$(document).find('.required').each(function(i, element) {
			var toAppend = "<span class=\"requiredfield\"> *</span>";
			$(this).parent().find('label').append(toAppend);
		});
	});
</script>