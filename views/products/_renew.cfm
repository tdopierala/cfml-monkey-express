<style>
	.productDetails { display: none; margin-top: 20px; }
	.productDetails li { padding: 5px 0; min-height: 15px; margin: 0; }
	.productDetails label { float: left; width: 200px; font-weight: bold; margin: 0; }
</style>
<cfoutput>
	<div class="wrapper product_form">
		<h4 class="h4products">Odblokowanie produktu w zamian za inny</h4>
		
		#startFormTag(action="actionNew", multipart="true", id="product-form")#
			
			#hiddenFieldTag(name="index", value="renew")#
			
			<fieldset>
				<legend>Produkt do odblokowania</legend>
				
				#hiddenFieldTag(name="product[unlock]", class="productid productunlock")#
				#textFieldTag(name="productSearchToUnlock", label="Wyszukaj produkt do odblokowania", labelPlacement="before", class="input productsearch", autocomplete="off")#
				
				<div class="productList" id="productunlock"></div>
				<div class="productSelected"><a href="##">#imageTag("close.png")#</a></div>
				
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
			
			<fieldset>
				<legend>Produkt do zablokowania</legend>
				
				#hiddenFieldTag(name="product[lock]", class="productid productlock")#
				#textFieldTag(name="productSearchToLock", label="Wyszukaj produkt do zablokowania", labelPlacement="before", class="input productsearch", autocomplete="off")#
				
				<div class="productList" id="productlock"></div>
				<div class="productSelected"><a href="##">#imageTag("close.png")#</a></div>
				
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
			
		#endFormTag()#
		
		<div class="product_submit">
			#submitTag(value="Wyślij", class="formButton button redButton productSubmit")#
		</div>
	</div>
</cfoutput>
<script>
$(function(){
	
	var ajax_time;
	
	$(".productsearch").on("keyup", function(){
		$(this).next(".productList").hide().html('');
		var _this = $(this);
		if( _this.val().length > 2 ) {
			
			$("#flashMessages").show();
			clearTimeout(ajax_time);
			
			ajax_time = setTimeout(function(){
				
				switch( _this.attr('name') ){
								
					case 'productSearchToUnlock':
						$.get(<cfoutput>"#URLFor(controller='Asseco',action='getAllIndexesDetails')#"</cfoutput> + "&search=" + _this.val(), 
							function(data) {
								$.each(data.ROWS, function(i, item){
									$("#productSearchToUnlock").next(".productList").append(
										'<p><span class="value">' + item.SYMKAR + 
										'</span>&nbsp;&nbsp;<span class="label">' + item.OPIKAR1	+ 
										'</span></p>'
									);
								});
								$("#productSearchToUnlock").next(".productList").show();
							}, "json");
					break;
					
					case 'productSearchToLock':
					
						$.get(<cfoutput>"#URLFor(controller='Asseco',action='getIndexesDetails')#"</cfoutput> + "&search=" + _this.val(), 
							function(data) {
								$.each(data.ROWS, function(i, item){
									$("#productSearchToLock").next(".productList").append(
										'<p><span class="value">' + item.SYMKAR + 
										'</span>&nbsp;&nbsp;<span class="label">' + item.OPIKAR1 + 
										'</span></p>'
									);
								});
								$("#productSearchToLock").next(".productList").show();
							}, "json");
					break;
				}
				$("#flashMessages").hide();
			},1000);
		}
		else {
			$(this).next(".productList").html('');
			clearTimeout(ajax_time);
			$("#flashMessages").hide();
		}
	});
		
	$(document).on("mouseup", ".productList p", function(){
		
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
		
		$(this).closest("fieldset").find(".productid").val( $(this).children(".value").html() );
		$(this).parent().hide();
	});
	
	$(".productSelected a").on("click", function(){
		$(this).parent().fadeOut("normal", function(){
			$(this).children("span").remove();
		});
		return false;
	});
		
	$('.productSubmit').on("click", function(){
		$('#product-form').submit();
	});
});
</script>