<cfoutput>

	<div class="wrapper">
		
		<h3>Wyszukiwarka zdjęć indeksów</h3>
		
		<div id="products" class="warpper">
			
			<fieldset>
				<legend>Wyszukaj zdjęcie</legend>
				
				<label>Kod EAN</label>
				<input type="text" name="search" id="qSearch" class="input" />
			</fieldset>
			
			<div id="searchResult">
				
			</div>
			
			<!---<cfloop query="images">
				<div>#file#</div>
			</cfloop>--->
			
		</div>
		
	</div>
</cfoutput>
<script>
	$(function(){
		
		var timeout;
		$("#qSearch").on("keyup", function(){
			
			var qSearch = $(this).val();
			if(qSearch.length > 2){
				
				$("#flashMessages").show();
				clearTimeout(timeout);
				
				timeout = setTimeout(function(){
					
					$.ajax({
						type		:	'get',
						dataType	:	'json',
						url		:	<cfoutput>"#URLFor(action='images')#"</cfoutput> + '&q=' + qSearch,
						success	:	function(response, statusText, xhr, $form) {
							
							$("#searchResult").empty();
							
							$.each(response.DATA, function(idx){
								var src = response.DATA[idx].toString().split(",")[1];
								var ean = response.DATA[idx].toString().split(",")[4];
								$("#searchResult").append(
									$("<div>").addClass("ean-image")
										.data("url","files/products/images/"+src)
										//.append($("<img>").prop("src","files/products/images/thumb_"+src).prop("alt",ean))
										.append($("<div>").addClass("imgdiv").css({"background-image": "url('files/products/images/thumb_"+src+"')"}))
										.append($("<span>").text(ean)));
							});
							
							$("#flashMessages").hide();
						},
						error : function(){
							$("#flashMessages").hide();
						}
					});
					
				},1000);
			} else {
				clearTimeout(timeout);
				$("#searchResult").empty();
				$("#flashMessages").hide();
			}
		});
		
		$("#searchResult").on("click", ".ean-image", function(){
			
			//window.location.href = $(this).data("url");
			window.open($(this).data("url"));
		});
		
	});
</script>