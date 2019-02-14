<cfoutput>
	<div class="wrapper product_form">
		<h4 class="h4products">Propozycja produktu od DM</h4>
		
		#startFormTag(action="actionNew", multipart="true", id="product-form")#
			
			#hiddenFieldTag(name="index", value="proposal")#
			
			<fieldset>
				<legend>Szczegóły produktu</legend>
				<ol>
					<li>
						#textFieldTag(name="product[name]", label="Nazwa produktu", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="product[barcode]", label="Kod EAN", labelPlacement="before", class="input")#
					</li>
					<li>
						#textFieldTag(name="product[category]", label="Kategoria produktu", labelPlacement="before", class="input", autocomplete="off")#
						<div class="category_list"></div>
					</li>
					<li>
						#textFieldTag(name="product[producer]", label="Producent", labelPlacement="before", class="input")#
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
	
	$(function(){
		
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
					+ responseText.sfilename + '">'
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
		
	});
</script>