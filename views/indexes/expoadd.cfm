	<cfoutput>
    	<div class="wrapper">
			
			<h3>Propozycja dodatkowej ekspozycji produktów</h3>
			
			<div id="products" class="warpper products">
				
				<div class="intranet-tab-content" style="border:none;">
					#startFormTag(action="expoAdd", multipart="true", id="product-form")#
					
					<fieldset>
						<legend>Szczegóły produktu</legend>
						<ol class="product-form">
							<li>
								#textFieldTag(name="product[purpose]", label="Cel wprowadzenia", labelPlacement="before", class="input")#
							</li>
							<li>
								<!---#textFieldTag(name="product[ean]", label="Indeks", labelPlacement="before", class="input")#--->
								<!---#textAreaTag(name="product[ean]", label="Indeksy produktów", labelPlacement="before", placeholder="Indeksy odzielone przecinkiem", class="textarea smalltextarea")#--->
								<label>Produkty</label>
								<div class="expoproductbox">
									<table class="expoproducttable">
										<thead>
											<tr>
												<th>Indeks</th>
												<th>Ean</th>
												<th>Ilość</th>
												<th>Nazwa</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td><input type="text" value="" name="product[index]" class="input productindex" /></td>
												<td><input type="text" value="" name="product[ean]" class="input productean" /></td>
												<td><input type="text" value="" name="product[amount]" class="input productamount" /></td>
												<td><input type="text" value="" name="product[name]" class="input productname" /></td>
											</tr>
										</tbody>
									</table>
									<a href="##" id="extendtable"><img src="images/extend-table.png" alt="dodaj" />&nbsp;Dodaj wiersz</a>
								</div>
								<div style="clear:both;"></div>
							</li>
							<li>
								#textFieldTag(name="product[producer]", label="Producent", labelPlacement="before", class="input")#
							</li>
							<!---<li>
								#textFieldTag(name="product[amount]", label="Ile produktów", labelPlacement="before", class="input number")#
							</li>--->
							<li>
								<label>Wymiary standu</label>
								wys: #textFieldTag(name="product[height]", class="input number", placeholder="wysokość")#
								szer: #textFieldTag(name="product[width]", class="input number", placeholder="szerokość")#
								dł: #textFieldTag(name="product[length]", class="input number", placeholder="długość")#
							</li>
							<li>
								<label>Okres trwania</label>
								#textFieldTag(name="product[termbegin]", class="input date_picker", placeholder="od")#
								#textFieldTag(name="product[termend]", class="input date_picker second_datepicker", placeholder="do")#
							</li>
							<li>
								#textFieldTag(name="product[startdate]", label="Data startu akcji na sklepie", labelPlacement="before", class="input date_picker")#
							</li>
							<li>
								#textFieldTag(name="product[deliverydate]", label="Data dostawy prototypu do Działu Merchandisingu", labelPlacement="before", class="input date_picker")#
							</li>
							<li>
								<!---#textFieldTag(name="product[delivery]", label="Dostawa", labelPlacement="before", class="input")#--->
								<cfset delivery = [ "CL", "Producent" ] />
								#selectTag(name="product[delivery]", label="Dostawa do sklepów", labelPlacement="before", options=delivery, includeBlank="-- wybierz --", class="")#
							</li>
							<li>
								#textAreaTag(name="product[additionalinfo]", label="Dodatkowe informacje o sposobie montażu", labelPlacement="before", class="textarea")#
							</li>
							<li>
								#textFieldTag(name="product[contact]", label="Dane kontaktowe", labelPlacement="before", class="input")#
							</li>
							
							<li>
								#textAreaTag(name="product[actionend]", label="Informacja o sposobie zakończenia akcji", labelPlacement="before", class="textarea")#
								<!---#textFieldTag(name="product[actionend]", label="Informacja o sposobie zakończenia akcji", labelPlacement="before", class="input")#--->
							</li>
							<li>
								<label>Miejsce na etykietę cenową</label>
								<!---#textFieldTag(name="product[label]", label="Miejsce na etykietę cenową", labelPlacement="before", class="input")#--->
								#radioButtonTag(name="product[label]", value="tak", label="Tak")#
								#radioButtonTag(name="product[label]", value="nie", label="Nie")#
							</li>
							
						</ol>
					</fieldset>
					
					#endFormTag()#
					
					<cfform 
						action="#URLFor(action='uploadFile',key='file')#" 
						id="fileuploadform" 
						method="post">
						<fieldset>
							<legend>Dane kontaktowe</legend>
							<ol>
								<li class="fileForm">
									<label>Dane kontaktowe</label>
									<div class="_button">Wybierz plik
										<cfinput 
											name="filedata" 
											type="file"
											class="fileinstancecontent input_file"
											label="Plik"
											size="1" />
									</div>
									<div id="fileprogressbar" class="progressbar"></div>
								</li>
							</ol>
						</fieldset>
					</cfform>
					
					<cfform 
						action="#URLFor(action='uploadImage')#" 
						id="productimguploadform" 
						method="post">
						<fieldset>
							<legend>Zdjęcia</legend>
							<ol>
								<li class="imageForm">
									<label>Zdjęcia (*.jpg, *.png)</label>
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
						<input type="submit" name="submitbutton" id="submitbutton" value="Wyślij" class="formButton button redButton productSubmit" />
					</div>
				</div>
				
			</div>
			
		</div>
    </cfoutput>
    
<!---<cfdump var="#params#">--->
<!---<cfdump var="#form#">--->
<script>
   	$(function(){
		
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
										value: item.SYMKAR, //request.term,
										ean: item.KODKRES,
										name: item.OPIKAR1
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
				$(event.target).closest("tr").find(".productean").val(ui.item.ean);
				$(event.target).closest("tr").find(".productname").val(ui.item.name);
			}
		};		
		$(".productindex").autocomplete(product_indexout_options);
		
		$("#submitbutton").on("click",function(){
						
			$("#product-form").append(
				$("<input>").prop("type","hidden").prop("name","submitbutton"));
				
			$(".productean, .productname, .productindex, .productamount").each(function(){
				if($(this).val() == '')
					$(this).val('?');
				
				$(this).val($(this).val().replace(',', '.'));
			});
			
			$("#product-form").submit();
			return false;
		});
		
		$(".progressbar").progressbar({ value: 0 });
		
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
		
		$(".imageinstancecontent").on("change", function(){
			time=0;
			$("#imageprogressbar").progressbar({ value: 0 });
			var ext = $(this).val().split(".");
			if( ext[ ext.length - 1 ] != 'jpg' && ext[ ext.length - 1 ] != 'jpeg' && ext[ ext.length - 1 ] != 'png' )
				alert('Nieprawidłowy format pliku! Tylko *.jpg lub *.png');
			else
				$("#productimguploadform").submit();
		});
		
		$("#product-ean").on("keypress", function(e){			
			if($.inArray(e.keyCode, [46,8,37,39]) === -1 && (!e.key.match(/^[0-9, ]$/) || $("#product-ean").val().length > 255)){
				e.preventDefault();
			} 
		});
		
		$("#extendtable").on("click", function(){
			
			$(".expoproducttable").find("tbody").append(
				$("<tr>")
					.append(
						$("<td>").html('<input type="text" value="" name="product[index]" class="input productindex" />'))
					.append(
						$("<td>").html('<input type="text" value="" name="product[ean]" class="input productean" />'))
					.append(
						$("<td>").html('<input type="text" value="" name="product[amount]" class="input productamount" />'))
					.append(
						$("<td>").html('<input type="text" value="" name="product[name]" class="input productname" />')));
			
			$(".expoproducttable tbody tr").last().children("td").first().children(".productindex").autocomplete(product_indexout_options);
			return false;
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
	
	function progress(obj){time += 5;if(time<90){obj.progressbar("option","value",time);}else{obj.progressbar( "option", "value", false );clearInterval(timebox);}}
	
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