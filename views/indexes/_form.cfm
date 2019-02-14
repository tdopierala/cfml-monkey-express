<cfoutput>
	
			#startFormTag(action="actionAdd", multipart="true", id="product-form", class="product-form")#
				
				#hiddenFieldTag(name="index", value="#params.form#")#
				#hiddenFieldTag(name="product[productcard]")#
				
				<fieldset>
					<legend>Szczegóły produktu</legend>
					
					<p style="margin:0 5px 15px 5px;">Pola oznaczone gwiazdką <span class="requiredfield">*</span> są wymagane!</p>
					
					<cfswitch expression="#params.form#">
						<cfcase value="replace">
							#hiddenFieldTag(name="product[replaced]",class="product-input")#
						</cfcase>
					</cfswitch>
					
					<ol class="product-form">
						
						<cfif params.form neq 'dm'>
							<li>
								#textFieldTag(name="product[name]", value=product.name, label="Nazwa produktu", labelPlacement="before", class="input product-name required")#
							</li>
							<li>
								#textFieldTag(name="product[barcode]", value=product.barcode, label="Kod kreskowy", labelPlacement="before", class="input product-barcode required")#
							</li>
							<cfif params.form eq 'unlock' or params.form eq 'renew'>
								<li>
									#textFieldTag(name="product[index]", value=product.index, label="Indeks produktu", labelPlacement="before", class="input product-index")#
								</li>
							</cfif>
							<li>
								#textFieldTag(name="product[category]", value=product.category, label="Kategoria produktu", labelPlacement="before", class="input product-category required", autocomplete="off")#
							</li>
							<li>
								#textFieldTag(name="product[producer]", value=product.producer, label="Producent", labelPlacement="before", class="input product-producer required")#
							</li>
						</cfif>
						
						<li>
							<label>Wymiary</label>
							wys: #textFieldTag(name="product[height]", value=product.height, class="input number size product-height required", placeholder="wysokość")#
							szer: #textFieldTag(name="product[width]", value=product.width, class="input number size product-width required", placeholder="szerokość")#
							dł: #textFieldTag(name="product[length]", value=product.length, class="input number size product-length required", placeholder="długość")#
						</li>
						
						<li>
							#textFieldTag(name="product[netto]", value=product.netto, label="Cena zakupu (netto)", labelPlacement="before", class="input number price product-netto required")#
						</li>
						<li>
							#textFieldTag(name="product[vat]", value=product.netto, label="Stawka VAT", labelPlacement="before", class="input price number product-vat required")#
						</li>
						
						<cfif params.form eq 'explo'>
							<li>
								#textFieldTag(name="product[csn]", value=product.csn, label="Cena sugerowana sprzedaży netto", labelPlacement="before", class="input number price product-csn")#
							</li>
							<li>
								#textFieldTag(name="product[csnvat]", value=product.csnvat, label="Stawka VAT dla ceny sugerowanej sprzedaży netto", labelPlacement="before", class="input number price product-csnvat")#
							</li>
							<!---<li>
								#textFieldTag(name="product[recvat]", value=product.recvat, label="Stawka VAT dla recepturowych", labelPlacement="before", class="input number price product-recvat")#
							</li>--->
						<cfelse>
							<li>
								#textFieldTag(name="product[brutto]", value=product.brutto, label="Cena sugerowana sprzedaży brutto", labelPlacement="before", class="input number price product-brutto")#
							</li>
						</cfif>
						
						<!---<li>
							#checkBoxTag(name="product[printed_price]", value=1, uncheckedValue=0, label="Sugerowana cena jest wydrukowana na opakowaniu", labelPlacement="before", class="checkbox")#
						</li>--->
						<!---<li>
							#checkBoxTag(name="product[new]", value=1, uncheckedValue=0, label="Nowość na rynku", labelPlacement="before", class="checkbox")#
						</li>--->
						<!---<li>
							#checkBoxTag(name="product[alt]", value=1, uncheckedValue=0, label="Wsparcie ATL", labelPlacement="before", class="checkbox")#
						</li>--->
						
						<li class="">
							<label>IN-OUT</label>
							<input type="checkbox" name="inout" id="inout" />
						</li>
						
						<li class="product_date inout">
							<div class="fadeBackground"></div>
							#textFieldTag(name="product[datein]", value=product.datein, label="Data wejścia", labelPlacement="before", class="input date_picker dateinout product-datein")#							
							<div style="clear:both;" />
						</li>
						<li class="product_date inout">
							<div class="fadeBackground"></div>
							#textFieldTag(name="product[dateout]", value=product.dateout, label="Data wyjścia", labelPlacement="before", class="input date_picker dateinout product-dateout")#
							<div style="clear:both;" />
						</li>
						<li class="indexout" style="display:none">
							<div class="fadeBackground"></div>
							#textFieldTag(name="product[indexout]", label="Indeks do wycofania", labelPlacement="before", class="input product-indexout")#
							#hiddenFieldTag(name="product[indexoutid]", value="")#
						</li>
						<li class="inout">
							<div class="fadeBackground"></div>
							#textFieldTag(name="product[amount]", value=product.amount, label="Ilość per sklep", labelPlacement="before", class="input number product-amount")#
						</li>
						<li class="inout">
							<div class="fadeBackground"></div>
							#textFieldTag(name="product[budget]", value=product.budget, label="Budżet wyprzedażowy", labelPlacement="before", class="input number product-budget")#
						</li>
						
						<!---<cfif params.form neq 'explo'>--->
							<li>
								#textFieldTag(name="product[capacity]", value=product.capacity, label="Ilość jednostek w opakowaniu", labelPlacement="before", class="input number product-capacity required")#
							</li>
						<!---</cfif>--->
						
						<li>
							#textAreaTag(name="product[comment]", value=product.comment, label="Dodatkowe informacje", labelPlacement="before", class="textarea product-comment")#
						</li>
					</ol>
				</fieldset>
			
			#endFormTag()#
			
			<cfif params.form eq 'explo'>
				
				<cfform 
					action="#URLFor(action='uploadFile',key='file')#" 
					id="fileuploadform" 
					method="post">
					<fieldset>
						<legend>Plik receptura</legend>
						<ol>
							<li class="fileForm">
								<label>Plik receptura</label>
								<div class="_button">Wybierz plik
									<cfinput 
										name="filedata" 
										type="file"
										class="fileinstancecontent input_file"
										label="Plik receptura"
										size="1" />
								</div>
								<div id="fileprogressbar" class="progressbar"></div>
							</li>
						</ol>
					</fieldset>
				</cfform>
			
			<cfelse>
			
				<cfform 
					action="#URLFor(action='uploadFile',key='file')#" 
					id="fileuploadform" 
					method="post">
					<fieldset>
						<legend>Plik z wyceną</legend>
						<ol>
							<li class="fileForm">
								<label>Plik z wyceną</label>
								<div class="_button">Wybierz plik
									<cfinput 
										name="filedata" 
										type="file"
										class="fileinstancecontent input_file"
										label="Plik z wyceną"
										size="1" />
								</div>
								<div id="fileprogressbar" class="progressbar"></div>
							</li>
						</ol>
					</fieldset>
				</cfform>
			
			</cfif>
			
			<cfform 
				action="#URLFor(action='uploadImage')#" 
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
</cfoutput>
<script>
	var timebox, time=0;
	
	$(function(){
		
		$('.date_picker').datepicker({
			showOn: "both",
			buttonImage: "images/schedule.png",
			buttonImageOnly: true,
			dateFormat: 'yy-mm-dd',
			monthNames: ['Styczeń', 'Luty', 'Marzec', 'Kwiecień', 'Maj', 'Czerwiec', 'Lipiec', 'Sierpień', 'Wrzesień', 'Październik', 'Listopad', 'Grudzień'],
			dayNamesMin: ['Ni', 'Po', 'Wt', 'Śr', 'Cz', 'Pt', 'So'],
			firstDay: 1,
			onSelect: function(){
				if($(this).hasClass("dateinout")){
					var datein = $("#product-datein").datepicker("getDate");
					var dateout = $("#product-dateout").datepicker("getDate");
					var difference = Math.round((dateout-datein)/(1000*60*60*24));
					
					if(difference>30){
						$(this).closest("li").next(".indexout").show();
						$(this).closest("li").next(".indexout").find(".fadeBackground").fadeOut('slow');
					} else {
						$(this).closest("li").next(".indexout").hide();
						$(this).closest("li").next(".indexout").find(".fadeBackground").show();
					}
				}
			}
		});
		
		
		var product_search_timeout;
		var product_search_options = {
			source	: function( request, response ) {
				clearTimeout(product_search_timeout);
				$("#flashMessages").show();
				
				product_search_timeout = setTimeout(function() {
					$.get(<cfoutput>"#URLFor(controller='Asseco',action='getAllIndexesDetails')#"</cfoutput> + "&search=" + request.term,
						function( data ) {
							$("#flashMessages").hide();
							response( $.map( data.ROWS, function( item ){
								return {
									label: item.OPIKAR1 + " (" + item.SYMKAR + ") " + item.STATUS,
									id: item.SYMKAR
								}
							}));
						},'json');
				}, 500);
			}
			,minLength: 2
			,select: function( event, ui ) {
				
				var $obj = $(this).closest(".productSerachForm").next(".product-form");
				
				$.get(<cfoutput>"#URLFor(controller='Asseco',action='getAllIndexesDetails')#"</cfoutput> + "&search=" + ui.item.id, 
					function(data) {
						
						if($obj.prop("id") == '')
							$("#product-form").prepend(
								$("<input>").prop("type", "hidden").prop("name", "product[symkar]").prop("id", "product-symkar").val(data.ROWS[0].SYMKAR));
					
						if($obj.find(".product-name").val() == ''){
							if(data.ROWS[0].OPIKAR != '') $obj.find(".product-name").val(data.ROWS[0].OPIKAR1);
							else $obj.find(".product-name").val(data.ROWS[0].OPIKAR1);
						}
						
						if($obj.find(".product-producer").val() == '')
							$obj.find(".product-producer").val(data.ROWS[0].NAZWA1);
							
						if($obj.find(".product-index").val() == '')
							$obj.find(".product-index").val(data.ROWS[0].SYMKAR);
						
						if($obj.find(".product-barcode").val() == '')
							$obj.find(".product-barcode").val(data.ROWS[0].KODKRES);
							
						if($obj.find(".product-width").val() == '' && data.ROWS[0].SZEROKOSC != '')
							$obj.find(".product-width").val(data.ROWS[0].SZEROKOSC);
						
						if($obj.find(".product-height").val() == '' && data.ROWS[0].WYSOKOSC != '')
							$obj.find(".product-height").val(data.ROWS[0].WYSOKOSC);
						
						if($obj.find(".product-length").val() == '' && data.ROWS[0].DLUGOSC != '')
							$obj.find(".product-length").val(data.ROWS[0].DLUGOSC);
						
						if($obj.find(".product-category").val() == '')
							$obj.find(".product-category").val(
								data.ROWS[0].SUPERKATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].SUPERKATEGORIA.substr(1).toLowerCase() + ' > ' + 
								data.ROWS[0].KATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].KATEGORIA.substr(1).toLowerCase() + ' > ' + 
								data.ROWS[0].PODKATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].PODKATEGORIA.substr(1).toLowerCase()
							);
						
						if(!$obj.children("ol").is(":visible")){
							$obj.children("ol").slideDown();
						}
						
						$("#flashMessages").hide();
					},"json");
			}
		};
		$(document).find(".productsearch").autocomplete(product_search_options);
		
		
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
		
		
		var product_indexout_timeout;
		var product_indexout_options = {
			source	: 
				function( request, response ) {
					clearTimeout(product_indexout_timeout);
					$("#flashMessages").show();
					product_indexout_timeout = setTimeout(function() {
						$.ajax({
							url			: <cfoutput>"#URLFor(controller='Asseco',action='getAllIndexesDetails')#"</cfoutput> + "&search=" + request.term,
							type		: "get",
							dataType	: "json",
							success		: function( data ) {
								$("#flashMessages").hide();	
								response( $.map( data.ROWS, function( item ) {
									return {
										label: item.OPIKAR1 + " (" + item.SYMKAR + ") " + item.STATUS,
										id: item.SYMKAR
									}
								}));
							},
							error: function(){
								$("#flashMessages").hide();
								alert("Błąd wyszukiwania. Spróbuj ponownie później.");
							}
						});
					}, 500);
				}
			,minLength: 2
			,select: function( event, ui ) {
				$("#product-indexoutid").val(ui.item.id);
			}
		};
		$("#product-indexout").autocomplete(product_indexout_options);
		
		
		$(".imageinstancecontent").on("change", function(){
			time=0;
			$("#imageprogressbar").progressbar({ value: 0 });
			var ext = $(this).val().split(".");
			if( ext[ ext.length - 1 ] != 'jpg' && ext[ ext.length - 1 ] != 'jpeg' && ext[ ext.length - 1 ] != 'png' )
				alert('Nieprawidłowy format pliku! Tylko *.jpg lub *.png');
			else
				$("#productimguploadform").submit();
		});
		
		$('#productimguploadform').ajaxForm({
			dataType	: 'json',
			type		: 'post',
			url		: "<cfoutput>#URLFor(action='uploadImage')#</cfoutput>",
			beforeSubmit: function(arr, $form, options){
				$("#imageprogressbar").show();
				timebox = setInterval( function(){ 
					progress( $("#imageprogressbar") ); 
				} ,100);
			},
			success: function (responseText, statusText, xhr, $form){
				clearInterval(timebox);
				$("#imageprogressbar").progressbar( "option", "value", 100 );
				$('.imageForm').append(
					$("<div>").addClass("productimg")
					.append(
						$("<img>").addClass("removeimg").prop("src","images/close.png").prop("alt","usuń zdęjcie"))
					.append(
						$("<a>").prop("href", "files/products/images/" + responseText.sfilename).data("image",responseText.sfilename).append(
							$("<img>").addClass("thumbimg").prop("src","files/products/images/" + responseText.thumbnail).prop("alt", responseText.cfilename)
						).fancybox({openEffect:'none',closeEffect:'none'})));
					
				$('.imageForm').children(".productimg").fadeIn("slow");
				$("#imageprogressbar").slideUp();
				$("#product-form").append(
					$("<input>").prop("type", "hidden").prop("name", "product[image]").val(responseText.sfilename));
			},
			error: function (jqXHR, text, error){
				console.log(error);
				clearInterval(timebox);	
				$("#productprogressbar").progressbar( "option", "value", 0 );
				alert('Zapisanie zdjęcia niepowiodło się. Spróbuj ponownie.');
			}
		});
		
		$("#productimguploadform").on("click", ".removeimg", function(){
			
			var value = $(this).next("a").data("image");
			
			$.get("<cfoutput>#URLFor(action='remove-file')#</cfoutput>" + "&filename=" + value, function( data ) {
				console.log(data);
			});
			
			$("#product-form").find("input[type='hidden']").each(function(idx){
				if($(this).val() == value)
					$(this).remove();
			});
				
			$(this).closest(".productimg").remove();
		});
		
		
		$(".documentinstancecontent").on("change", function(){
			time=0;
			$("#productprogressbar").progressbar({ value: 0 });
			var ext = $(this).val().split(".");
			
			if( ext[ ext.length - 1 ] != 'xls' && ext[ ext.length - 1 ] != 'xlsx' )
				alert('Nieprawidłowy format pliku! Akceptowaalne pliki w formacie *.xls lub *.xlsx');
			else
				$("#productcarduploadform").submit();
		});
		
		$("#productcarduploadform").ajaxForm({
			dataType	: 'json',
			type		: 'post',
			url		: "<cfoutput>#URLFor(action='uploadXls')#</cfoutput>",
			beforeSubmit: function(arr, $form, options){
				$("#productprogressbar").show();
				timebox = setInterval( function(){ 
					progress( $("#productprogressbar") ); 
				} ,100);
			},
			success: function (responseText, statusText, xhr, $form){
				clearInterval(timebox);
				$("#productprogressbar").progressbar( "option", "value", 100 );
				$('.invoiceForm').append(
					$("<div>").addClass("productcard")
						.append(
							$("<a>")
								.prop("href","files/products/" + responseText.sfilename)
								.append(
									$("<img>").prop("src","images/excel-icon.png").prop("alt","excel"))
								.append("&nbsp;" + responseText.cfilename))
						.append(
							$("<img>").addClass("removefile").prop("src", "images/delete_icon.png").prop("alt", "[usuń plik]").data("filename", responseText.sfilename)));
				
				$("#productprogressbar").slideUp();
				
				$("#product-productcard").val(responseText.sfilename);
				
				$("#product-name").val(responseText.product_name);
				$("#product-producer").val(responseText.product_producer);
				$("#product-width").val(responseText.product_width);
				$("#product-height").val(responseText.product_height);
				$("#product-length").val(responseText.product_length);
				$("#product-barcode").val(responseText.product_barcode);
				$("#product-netto").val(responseText.product_pricenetto);
				
				$.get(<cfoutput>"#URLFor(controller='Asseco',action='getAllIndexesDetails')#"</cfoutput> + "&search=" + responseText.product_barcode, 
					function(data) {
						$("#product-index").val(data.ROWS[0].SYMKAR);
						//$("#flashMessages").hide();
					},"json");
				
				var price = responseText.product_pricenetto + (responseText.product_pricenetto * responseText.product_vat);
				price = Number(price.toFixed(2));
				if(price.toString() != 'NaN')
					$("#product-brutto").val(price);
			},
			error: function(jqXHR, text, error){
				clearInterval(timebox);				
				$("#productprogressbar").progressbar( "option", "value", 0 );				
				alert('Błąd arkusza. Prawdopodobnie karta produktu jest błędna.');
			}
		});
		
		
		$(".fileinstancecontent").on("change", function(){
			time=0;
			$("#fileprogressbar").progressbar({ value: 0 });
			$("#fileuploadform").submit();
		});
		
		$('#fileuploadform').ajaxForm({
			dataType	: 'json',
			type		: 'post',
			url		: "<cfoutput>#URLFor(action='uploadFile',key='file')#</cfoutput>",
			beforeSubmit: function(arr, $form, options){
				$("#fileprogressbar").show();
				timebox = setInterval( function(){ 
					progress( $("#fileprogressbar") ); 
				} ,100);
			},
			success: function (responseText, statusText, xhr, $form){
				clearInterval(timebox);
				
				$("#fileprogressbar").progressbar( "option", "value", 100 );
				$('.fileForm').find(".productfile").remove();
				$('.fileForm').append(
					$("<div>").addClass("productfile")
						.append(
							$("<a>").prop("href","files/products/expo/" + responseText.sfilename)
								.append(
									$("<img>").addClass("iconimage").prop("src","images/"+getIcon(responseText.sfilename)).prop("alt","plik"))
								.append(
									"&nbsp;" + responseText.cfilename))
						.append(
							$("<img>").addClass("removefile").prop("src", "images/delete_icon.png").prop("alt", "[usuń plik]").data("filename", responseText.sfilename)));
					
				$(".fileForm").children(".productimg").fadeIn("slow");
				$("#fileprogressbar").slideUp();
				$("#product-form").find("input[name='productfile']").remove();
				$("#product-form").append(
					$("<input>").prop("type", "hidden").prop("name", "product[productfile]").val(responseText.sfilename));
			}
		});
		
		$(".fileForm").on("click", ".removefile", function(){
			var value = $(this).data("filename");
			$.get("<cfoutput>#URLFor(action='remove-file')#</cfoutput>" + "&filename=" + value, function(data) {
				console.log(data);
			});
			
			$('.fileForm').find(".productfile").remove();
			$("#product-form").find("input[name='product[productfile]']").remove();
			$("#fileprogressbar").show().progressbar({ value: 0 });
		});
		
		$(".invoiceForm").on("click", ".removefile", function(){
			var value = $(this).data("filename");
			
			$.get("<cfoutput>#URLFor(action='remove-file')#</cfoutput>" + "&filename=" + value, function(data) {
				console.log(data);
			});
			
			$('.invoiceForm').find(".productcard").remove();
			$("#product-form").find("input[name='product[productcard]']").val('');
			
			$("#product-name").val('');
			$("#product-producer").val('');
			$("#product-width").val('');
			$("#product-height").val('');
			$("#product-length").val('');
			$("#product-barcode").val('');
			$("#product-netto").val('');
			$("#product-brutto").val('');
			$("#product-index").val('');
			
			$("#productprogressbar").show().progressbar({ value: 0 });
		});
		
		
		$(".progressbar").progressbar({ value: 0 });
		
		$(".none_button").on("click", function(){
			return false;
		});
		
		$("input.price").on("focusout", function(){
			var value = $(this).val();
			value = value.replace(",",".");
			$(this).val(value);
		});
		
		$("#inout").on("click", function(){
			if($(this).is(':checked')){
				$(".inout").show();
				$(".inout").find(".fadeBackground").fadeOut('slow');
			} else {
				$(".inout").hide();
				$(".inout").find(".fadeBackground").show();
				$(".indexout").hide();
			}
		});
		
		$(document).find('.required').each(function(i, element) {
			$(this).parent().find(".requiredfield").remove();
			var toAppend = "<span class=\"requiredfield\"> *</span>";
			$(this).parent().find('label').append(toAppend);
		});
	});
	
	function progress(obj){time+=5;if(time<90){obj.progressbar("option","value",time);}else{obj.progressbar("option","value",false);clearInterval(timebox);}}
	
	function getIcon(filename){
		var arr=filename.split("."), ext=arr[arr.length-1];
		switch(ext){
			case 'xls': case 'xlsx': var ico = "excel-icon.png"; break;
			case 'doc': case 'docx': var ico = "file-word.png"; break;
			case 'jpg': case 'jpeg': var ico = "file-img.png"; break;
			case 'pdf': var ico = "file-pdf.png"; break;
			default: var ico = "blank.png";
		}
		return ico;
	}
</script>