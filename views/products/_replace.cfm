<style>
	.productDetails { display: none; margin-top: 20px; }
	.productDetails li { padding: 5px 0; min-height: 15px; margin: 0; }
	.productDetails label { float: left; width: 200px; font-weight: bold; margin: 0; }
</style>
<cfoutput>
	<div class="wrapper product_form">
		<h4 class="h4products">Propozycja nowego produktu w zamian za inny</h4>
		
		<fieldset>
			<legend>Produkt do wycofania</legend>
			#textFieldTag(name="productSearch", label="Wyszukaj produkt do wycofania", labelPlacement="before", class="input", autocomplete="off")#
			<div id="productList"></div>
			<div id="productSelected"><a href="##">#imageTag("close.png")#</a></div>
			
			<ol class="productDetails">
				<li><label>Nazwa produktu:</label><span class="productreplace-name"></span></li>
				<li><label>Kod kreskowy:</label><span class="productreplace-barcode"></span></li>
				<li><label>Kategoria:</label><span class="productreplace-cat"></span></li>
				<li><label>Producent:</label><span class="productreplace-producer"></span></li>
				<li><label>Wysokość:</label><span class="productreplace-height"></span></li>
				<li><label>Szerokość:</label><span class="productreplace-width"></span></li>
				<li><label>Głębokość:</label><span class="productreplace-length"></span></li>
				<!--- <li><label>Cena (brutto):</label><span class="productreplace-price"></span></li> --->
				<!--- <li><label>Dadatkowe informacje:</label><span class="productreplace-comment"></span></li> --->
			</ol>
		</fieldset>
		
		<cfform 
			action="#URLFor(controller='products',action='uploadXls')#" 
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
		</cfform>
		
		#startFormTag(action="actionNew", multipart="true", id="product-form")#
			
			#hiddenFieldTag(name="index", value="replace")#
			#hiddenFieldTag(name="product[productcard]")#
			#hiddenFieldTag(name="product[replaced]")#
			
			<fieldset>
				<legend>Szczegóły produktu</legend>
				<ol>
					<li>
						#textFieldTag(name="product[name]", label="Nazwa produktu", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="product[barcode]", label="Kod kreskowy", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="product[category]", label="Kategoria produktu", labelPlacement="before", class="input", autocomplete="off")#
						<div class="category_list"></div>
					</li>
					<li>
						#textFieldTag(name="product[producer]", label="Producent", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="product[height]", label="Wysokość", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="product[width]", label="Szerokość", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="product[length]", label="Głębokość", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="product[netto]", label="Cena zakupu netto", labelPlacement="before", class="input price")#
					</li>
					<li>
						#textFieldTag(name="product[brutto]", label="Cena sugerowana brutto", labelPlacement="before", class="input price")#
					</li>
					<li>
						<!--- <label>Czy sugerowana cena jest wydrukowana na opakowaniu?</label>
						#radioButtonTag(name="product[printed_price]", value="0", label="Tak")#
						#radioButtonTag(name="product[printed_price]", value="1", label="Nie")# --->
						#checkBoxTag(name="product[printed_price]", value=1, uncheckedValue=0, label="Sugerowana cena jest wydrukowana na opakowaniu", class="checkbox")#
					</li>
					<li>
						#checkBoxTag(name="product[new]", value=1, uncheckedValue=0, label="Nowość na runku", class="checkbox")#
					</li>
					<li>
						#checkBoxTag(name="product[alt]", value=1, uncheckedValue=0, label="Wsparcie ATL", class="checkbox")#
					</li>
					<li class="product_date">
						#checkBoxTag(name="product[dateincheckbox]", value=1, uncheckedValue=0, label="Data wprowadzenia (IN)", class="checkbox")#
						
						#textFieldTag(name="product[datein]", class="input date_picker")#
						
						<div style="clear:both;" />
					</li>
					<li class="product_date">
						#checkBoxTag(name="product[dateoutcheckbox]", value=1, uncheckedValue=0, label="Data wycofania (OUT)", class="checkbox")#
						
						#textFieldTag(name="product[dateout]", class="input date_picker")#
						
						<div style="clear:both;" />
					</li>
					<li>
						#textAreaTag(name="product[comment]", label="Dodatkowe informacje o produkcie", labelPlacement="before", class="textarea")#
					</li>
				</ol>
			</fieldset>
		
		#endFormTag()#
		
		<cfform 
			action="#URLFor(controller='products',action='uploadImage')#" 
			id="productimguploadform" 
			method="post">
			<fieldset>
				<legend>Zdjęcia produktu</legend>
				<ol>
					<li class="imageForm">
						<label>Zdjęcia produktu (*.jpg, *.png)</label>
						<div class="_button">Wybierz plik
							<cfinput 
								name="imagedata" 
								type="file"
								class="imageinstancecontent input_file"
								label="Zdjęcia produktu (*.jpg, *.png)"
								size="1"
								multiple="multiple" />
						</div>
						<div id="imageprogressbar" class="progressbar"></div>
					</li>
				</ol>
			</fieldset>
		</cfform>
		
		<div class="product_submit">
			#submitTag(value="Wyślij", class="formButton button redButton productSubmit")#
		</div>
	</div>
</cfoutput>
<script>
	$(function(){
		var ajax_time;
		
		$("#productSearch").on("keyup", function(){
			$("#productList").hide().html('');
			if( $(this).val().length > 2 ) {
						
				$("#flashMessages").show();
				clearTimeout(ajax_time);
				
				ajax_time = setTimeout(function(){
					//console.log($("#product-name").val());
					
					$.get(<cfoutput>"#URLFor(controller='Asseco',action='getAllIndexesDetails')#"</cfoutput> + "&search=" + $("#productSearch").val(), 
					function(data) {
						$.each(data.ROWS, function(i, item){
							$("#productList").append(
								'<p><span class="value">' + item.SYMKAR + 
								'</span>&nbsp;&nbsp;<span class="label">' + item.OPIKAR1 +
								'</span></p>'
							);							
						});
						$("#productList").show();
						$("#flashMessages").hide();
					}, "json");
					
					/*
					$.ajax({
						type		:	'get',
						dataType	:	'html',
						url		:	<cfoutput>"#URLFor(controller='Asseco',action='getIndexes')#"</cfoutput> + "&search=" + $("#productSearch").val(),
						success	:	function(data) {
							
							var response = $.parseJSON(data);
							
							$.each(response, function(i, item){
								$("#productList").append('<p><span class="value">'+ item.value + '</span>&nbsp;&nbsp;<span class="label">' + item.label + '</span></p>').show();
							});
							$("#productList p").last().remove();
							$("#flashMessages").hide();
						}
					});
					*/
				},1000);
			}
			else {
				$("#productList").html('');
				clearTimeout(ajax_time);
				$("#flashMessages").hide();
			}
		});
		
		$(".product_date").find("label").on("click", "input", function(){
			
			if($(this).is(":checked"))
				$(this).parent().nextAll().show();
			else
				$(this).parent().nextAll().hide();
		});
		
		var timebox, time=0;
		
		function progress(obj){
			time += 5;
			
			if( time < 90 ){ 
				obj.progressbar( "option", "value", time ); } 
			else { 
				obj.progressbar( "option", "value", false ); 
				clearInterval(timebox); 
			}
		}
		
		$('#productcarduploadform').ajaxForm({
			dataType	: 'json',
			type		: 'post',
			url		: "<cfoutput>#URLFor(controller='products',action='uploadXls')#</cfoutput>",
			beforeSubmit: function(arr, $form, options){
				$("#productprogressbar").show();
				timebox = setInterval( function(){ 
					progress( $("#productprogressbar") ); 
				} ,100);
			},
			success: function (responseText, statusText, xhr, $form){
				clearInterval(timebox);
				$("#productprogressbar").progressbar( "option", "value", 100 );
				$('.invoiceForm').append('<div class="productcard"><a href="files/products/' 
					+ responseText.sfilename + '">'
					+ '<img src="images/excel-icon.png" alt="excel" />&nbsp;' 
					+ responseText.cfilename +'</a></div>');
				
				$("#productprogressbar").slideUp();
				
				$("#product-productcard").val(responseText.sfilename);
				
				$("#product-name").val(responseText.product_name);
				$("#product-producer").val(responseText.product_producer);
				$("#product-width").val(responseText.product_width);
				$("#product-height").val(responseText.product_height);
				$("#product-length").val(responseText.product_length);
				$("#product-barcode").val(responseText.product_barcode);
				$("#product-netto").val(responseText.product_pricenetto);
				
				var price = responseText.product_pricenetto + (responseText.product_pricenetto * responseText.product_vat);
				price = Number(price.toFixed(2));
				if(price.toString() != 'NaN')
					$("#product-brutto").val(price);
			}
		});
		
		$(".progressbar").progressbar({ value: 0 });
		
		$(".none_button").on("click", function(){
			return false;
		});
		
		$(".documentinstancecontent").on("change", function(){
			time=0;
			$("#productprogressbar").progressbar({ value: 0 });
			var ext = $(this).val().split(".");
			if( ext[ ext.length - 1 ] != 'xls' )
				alert('Nieprawidłowy format pliku! Wybierz plik *.xls');
			else
				$("#productcarduploadform").submit();
		});
		
		$('#productimguploadform').ajaxForm({
			dataType	: 'json',
			type		: 'post',
			url		: "<cfoutput>#URLFor(controller='products',action='uploadImage')#</cfoutput>",
			beforeSubmit: function(arr, $form, options){
				$("#imageprogressbar").show();
				timebox = setInterval( function(){ 
					progress( $("#imageprogressbar") ); 
				} ,100);
			},
			success: function (responseText, statusText, xhr, $form){
				clearInterval(timebox);
				$("#imageprogressbar").progressbar( "option", "value", 100 );
				$('.imageForm').append('<div class="productimg"><a href="files/products/images/' 
					+ responseText.sfilename + '" target="_blank">'
					+ '<img src="files/products/images/' + responseText.thumbnail + '" alt="' 
					+ responseText.cfilename + '" /></a></div>');
					
				$('.imageForm').children(".productimg").fadeIn("slow");
				$("#imageprogressbar").slideUp();
				$("#product-form").append('<input type="hidden" name="product[image]" value="' + responseText.sfilename + '" />');
			}
		});
		
		$(".imageinstancecontent").on("change", function(){
			time=0;
			$("#imageprogressbar").progressbar({ value: 0 });
			var ext = $(this).val().split(".");
			if( ext[ ext.length - 1 ] != 'jpg' && ext[ ext.length - 1 ] != 'jpeg' && ext[ ext.length - 1 ] != 'png' )
				alert('Nieprawidłowy format pliku! Tylko *.jpg lub *.png');
			else
				$("#productimguploadform").submit();
		});
		
		$("input.price").on("focusout", function(){
			var value = $(this).val();
			value = value.replace(",",".");
			$(this).val(value);
		});
		
		$('.productSubmit').on("click", function(){
			
			var flag = 0;
			
			if ($("#product-category").val() == '') {
				
				$("#product-category")
					.addClass('invalid')
					.after('<span class="invalidmsg">&laquo;&nbsp;wybierz kategorie</span>');
				flag = 1;
				console.log('category error');
			}
			else {
				$("#product-category").removeClass("invalid").next(".invalidmsg").remove();
				console.log('category OK');
			}
			
			$("#product-form").find("ol").children("li").find("input.input").each(function(idx){
				
				//console.log($("#product-form").find("ol").children("li").find("input.input").length);
				
				var _this = $(this);
				
				if (_this.val() != 'undefined') {
					//console.log(_this.val());
					
					if(_this.hasClass("price")){
						_this.val(_this.val().replace(",","."));
					}
					
					if (_this.val().indexOf("CONCATENATE") > -1) {
						_this.addClass('invalid').after('<span class="invalidmsg">&laquo;&nbsp;nieprawidłowa wartość pola</span>');
						flag = 1;
						console.log('element error');
					}
					else {
						//_this.removeClass("invalid").next(".invalidmsg").remove();
						console.log('element OK');
					}					
				}
			});
			
			//console.log(flag);
			
			if (flag != 1) {
				$('#product-form').submit();
				//console.log('wysyłanie');
			}
			else {
				$("#product-form")[0].scrollIntoView(true);
			}
				
			return false;
			
			//$('#product-form').submit();			
			//return false;
		});
		
		$(document).on("mouseup", "#productList p", function(){
				
		var $obj = $(this).closest("fieldset").find(".productDetails");
		
		$.get(<cfoutput>"#URLFor(controller='Asseco',action='getAllIndexesDetails')#"</cfoutput> + "&search=" + $(this).children(".value").text(), 
			function(data) {
				
				if(data.ROWS[0].OPIKAR != '')
					$obj.find(".productreplace-name").text(data.ROWS[0].OPIKAR);
				else
					$obj.find(".productreplace-name").text(data.ROWS[0].OPIKAR1);
					
				$obj.find(".productreplace-producer").text(data.ROWS[0].NAZWA1);
				$obj.find(".productreplace-barcode").text(data.ROWS[0].KODKRES);
					
				if(data.ROWS[0].SZEROKOSC != '')
					$obj.find(".productreplace-width").text(data.ROWS[0].SZEROKOSC + ' cm');
						
				if(data.ROWS[0].WYSOKOSC != '')
					$obj.find(".productreplace-height").text(data.ROWS[0].WYSOKOSC + ' cm');
					
				if(data.ROWS[0].DLUGOSC != '')	
					$obj.find(".productreplace-length").text(data.ROWS[0].DLUGOSC + ' cm');
						
				$obj.find(".productreplace-cat").text(
					data.ROWS[0].SUPERKATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].SUPERKATEGORIA.substr(1).toLowerCase() + ' > ' + 
					data.ROWS[0].KATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].KATEGORIA.substr(1).toLowerCase() + ' > ' + 
					data.ROWS[0].PODKATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].PODKATEGORIA.substr(1).toLowerCase()
				);
					
				$(this).parent().hide();
				$obj.slideDown();
				
				$("#flashMessages").hide();
			}, "json");
			
			//$("#productSelected").children("span").remove();
			//$("#productSelected").prepend('<span>' + $(this).children(".label").html() + '</span>&nbsp;<span>[' + $(this).children(".value").html() + ']</span>').fadeIn("slow");
			//$("#productSearch").val( $(this).children(".label").html() );
			//$("#product-replaced").val($(this).children(".value").html());
			
			$("#product-replaced").val( $(this).children(".value").html() );
			$(this).parent().hide();
		});
		
		$(document).on("click", "#productSelected a", function(){
			$("#productSearch").val('');
			$(this).parent().fadeOut("normal", function(){
				$(this).children("span").remove();		
			});
			return false;
		});
		
		var ajax_time=0;
		$('#product-category').on("keyup",function(){
			
			var $_this = $(this);
			if( $_this.val().length > 2 ) {
									
				$("#flashMessages").show();
				clearTimeout(ajax_time);
				
				ajax_time = setTimeout(function(){
					
					$.get(<cfoutput>"#URLFor(controller='Products',action='searchCategory')#"</cfoutput> + '&qstr=' + $_this.val(),
						function(data) {
							$(".category_list").find("p").remove();
							$.each(data.ROWS, function(i, item){
								$(".category_list").append(
									'<p><span class="value">' + item.SUPERKATEGORIA + ' > ' + item.KATEGORIA + ' > ' + item.PODKATEGORIA + '</span></p>'
								);
							});
							$("#flashMessages").hide();
							$(".category_list").show();
						}, "json");
					
				},1000);
			}
			else {
				$(".category_list").html('');
				clearTimeout(ajax_time);
				$("#flashMessages").hide();
			}
		});
		
		$('.category_list').on("click", "p", function(){
			var _text = $(this).find(".value").text();
			$(".category_list").hide();
			$('#product-category').val(_text.toLowerCase());
		});
		
		$('.date_picker').datepicker({
			showOn: "both",
			buttonImage: "images/schedule.png",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
			dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
			firstDay: 1
		});
	});
</script>