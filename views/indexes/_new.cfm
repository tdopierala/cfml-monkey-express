<cfoutput>
	<div class="wrapper product_form">
		<h4 class="h4products">Propozycja nowego produktu</h4>
		
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
				
		<div class="product_submit">
			#submitTag(value="Wyślij", class="formButton button redButton productSubmit")#
		</div>
		
	</div>
</cfoutput>
<script>
	$(function(){
		
		/*$(".product_date").find("label").on("click", "input", function(){
			
			if($(this).is(":checked"))
				$(this).parent().nextAll().show();
			else
				$(this).parent().nextAll().hide();
		});*/
		
		/*var ajax_time=0;
		$('#product-category').on("keyup",function(){
			
			var $_this = $(this);
			if( $_this.val().length > 2 ) {
									
				$("#flashMessages").show();
				clearTimeout(ajax_time);
				
				ajax_time = setTimeout(function(){
					
					$.get(<cfoutput>"#URLFor(action='searchCategory')#"</cfoutput> + '&qstr=' + $_this.val(),
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
		});*/
		
	});
</script>