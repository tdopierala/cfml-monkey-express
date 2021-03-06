<cfoutput>
	<div class="wrapper product_form">
		<h4 class="h4products">Odblokowanie produktu</h4>
		
		#startFormTag(action="actionNew", multipart="true", id="product-form")#
			
			#hiddenFieldTag(name="index", value="unlock")#
			#hiddenFieldTag(name="product[id]")#
			
			<fieldset>
				<legend>Produkt do odblokowania</legend>
				#textFieldTag(name="productSearch", label="Wyszukaj produkt do odblokowania", labelPlacement="before", class="input", autocomplete="off")#
				<div id="productList" class="productList"></div>
				<div class="productSelected"><a href="##">#imageTag("close.png")#</a></div>
				
				<ol class="productDetails" style="display:none;">
					<li><label>Nazwa produktu:</label><span id="productreplace-name"></span></li>
					<li><label>Kod kreskowy:</label><span id="productreplace-barcode"></span></li>
					<li><label>Kategoria:</label><span id="productreplace-cat"></span></li>
					<li><label>Producent:</label><span id="productreplace-producer"></span></li>
					<li><label>Wysokość:</label><span id="productreplace-height"></span></li>
					<li><label>Szerokość:</label><span id="productreplace-width"></span></li>
					<li><label>Głębokość:</label><span id="productreplace-length"></span></li>
					<!--- <li><label>Cena (brutto):</label><span id="productreplace-price"></span></li> --->
					<!--- <li><label>Dadatkowe informacje:</label><span id="productreplace-comment"></span></li> --->
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
	
	$("#productSearch").on("keyup", function(){
		$(".productList").hide().html('');
		var _this = $(this);
		if( _this.val().length > 2 ) {
			
			$("#flashMessages").show();
			clearTimeout(ajax_time);
			
			ajax_time = setTimeout(function(){
						
				$.get(<cfoutput>"#URLFor(controller='Asseco',action='getAllIndexesDetails')#"</cfoutput> + "&search=" + _this.val(), 
					function(data) {
						$.each(data.ROWS, function(i, item){
							$(".productList").append(
								'<p><span class="value">' + item.SYMKAR + 
								'</span>&nbsp;&nbsp;<span class="label">' + item.OPIKAR1 +
								'</span></p>'
							);
						});
						$(".productList").show();
						$("#flashMessages").hide();
					}, "json");
				
			},1000);
		}
		else {
			$("#productList").html('');
			clearTimeout(ajax_time);
			$("#flashMessages").hide();
		}
	});
	
	$('.productSubmit').on("click", function(){
		$('#product-form').submit();
	});
		
	$(document).on("mouseup", "#productList p", function(){
		$("#flashMessages").show();
		
		$.get(<cfoutput>"#URLFor(controller='Asseco',action='getAllIndexesDetails')#"</cfoutput> + "&search=" + $(this).children(".value").text(), 
			function(data) {
				
					$("#productreplace-name").text(data.ROWS[0].OPIKAR1);
					$("#productreplace-producer").text(data.ROWS[0].NAZWA1);
					$("#productreplace-barcode").text(data.ROWS[0].KODKRES);
					
					if(data.ROWS[0].SZEROKOSC != '')
						$("#productreplace-width").text(data.ROWS[0].SZEROKOSC + ' cm');
						
					if(data.ROWS[0].WYSOKOSC != '')
						$("#productreplace-height").text(data.ROWS[0].WYSOKOSC + ' cm');
					
					if(data.ROWS[0].DLUGOSC != '')	
						$("#productreplace-length").text(data.ROWS[0].DLUGOSC + ' cm');
						
					$("#productreplace-cat").text(
						data.ROWS[0].SUPERKATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].SUPERKATEGORIA.substr(1).toLowerCase() + ' > ' + 
						data.ROWS[0].KATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].KATEGORIA.substr(1).toLowerCase() + ' > ' + 
						data.ROWS[0].PODKATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].PODKATEGORIA.substr(1).toLowerCase()
					);
					
					$(".productDetails").slideDown();
				
				$("#flashMessages").hide();
			}, "json");
		
		$(".productList").hide();
		$("#productSearch").val('');
		$("#product-id").val( $(this).children(".value").html() );
	});
		
	$(document).on("click", ".productSelected a", function(){
		$("#productSearch").val('');
		$(this).parent().fadeOut("normal", function(){
			$(this).children("span").remove();		
		});
		return false;
	});
});
</script>