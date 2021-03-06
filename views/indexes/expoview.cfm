<cfoutput>
	
	<div class="wrapper">
		
		<div id="productDialogBox">
			<h4 id="stepname"></h4>
			
			#startFormTag(action="expo-step", id="step-form")#
			
				#hiddenFieldTag(name="expoid", value="#expo.id#")#
				#hiddenFieldTag(name="stepid")#
				
				<label class="label">
					Powód / komentarz:
					#textAreaTag(name="stepcomment")#
				</label>
				
			#endFormTag()#
			
		</div>
	
		<h3>Szczegóły dodatkowej ekspozycji</h3>
					
			<div class="topLink">
				#linkTo(text="Powrót do listy", action="expo")#
			</div>
					
			<div class="productBox">
				<!---<h4 class="productBoxTitle">Propozycja produktu do odblokowania</h4>--->
						
				<ol class="productDetails" style="display:block;">
					<li>
						<label>Cel wprowadzenia:</label>
						<span class="">#expo.purpose#</span>
					</li>
					<li>
						<label>Produkty:</label>
						<table class="expoproducttab">
							<tr>
								<td>Index</td><td>Ean</td><td>Ilość</td><td>Nazwa</td>
							</tr>
							<cfloop query="products">
								<tr>
									<td>#productindex#</td><td>#productean#</td><td>#productamount#</td><td>#productname#</td>
								</tr>
							</cfloop>
						</table>
						<div style="clear:both"></div>
					</li>
					<li>
						<label>Producent:</label>
						<span class="">#expo.producer#</span>
					</li>
					<!---<li>
						<label>Ilość produktów:</label>
						<span class="">#expo.amount#</span>
					</li>--->
					<li>
						<label>Wymiary (wys/szer/dłu)</label>
						<span class="size">#expo.height#</span> / <span class="size">#expo.width#</span> / <span class="size">#expo.length#</span>
					</li>
					<li>
						<label>Okres trwania:</label>
						<span class="">od #DateFormat(expo.termbegin, "yyyy-mm-dd")#, do #DateFormat(expo.termend, "yyyy-mm-dd")#</span>
					</li>
					<li>
						<label>Data startu akcji na sklepie:</label>
						<span class="">#DateFormat(expo.startdate, "yyyy-mm-dd")#</span>
					</li>
					<li>
						<label>Data dostawy prototypu do Działu Merchandisingu:</label>
						<span class="">#DateFormat(expo.deliverydate, "yyyy-mm-dd")#</span>
					</li>
					<li>
						<label>Dostawa do sklepów:</label>
						<span class="">#expo.delivery#</span>
					</li>
					<li>
						<label>Dodatkowe informacje o sposobie montażu:</label>
						<span class="">#expo.additionalinfo#</span>
					</li>
					<li>
						<label>Dane kontaktowe:</label>
						<span class="">#expo.contact#</span>
					</li>
					<cfif expo.productfile neq ''>
						<li>
							<label>Plik z danymi kontaktowymi</label>
							<span><a href="files/products/expo/#expo.productfile#"><img src="images/#GetIconForFile(filename=expo.productfile)#" alt="#expo.productfile#" />&nbsp;#expo.productfile#</a></span>
						</li>
					</cfif>
					<li>
						<label>Informacja o sposobie zakończenia akcji:</label>
						<span class="">#expo.actionend#</span>
					</li>
					<li>
						<label>Miejsce na etykietę cenową:</label>
						<span class="">#expo.label#</span>
					</li>
				</ol>
			</div>
			
			<div class="product-images">
				<cfif images.RecordCount gt 0>
					<cfloop query="images">
						<div class="product-image">
							<a href="./files/products/images/#images.file#" class="fancybox" rel="productgallery"><img src="./files/products/images/thumb_#images.file#" alt="#images.file#"></a>
						</div>
					</cfloop>
				</cfif>
				<div style="clear:both"></div>
			</div>
			
			<cfif expo.stepid gte 9 and expo.stepid lte 11 and expo.stepstatusid eq 1> 
				<div class="productActions">
					#submitTag(value="Zaakceptuj", class="formButton button redButton product _confirm")#
					#submitTag(value="Odrzuć", class="formButton button redButton product _discard")#
				</div>
			</cfif>
			
			<cfloop query="steps">
				
				<div class="productstep">
					<h5>#stepname#</h5>
					<br />
					<cfif stepend eq ''>
						Rozpoczęty: <strong>#DateFormat(stepbegin, "yyyy.mm.dd")# #TimeFormat(stepbegin, "HH:mm")#</strong><br />
						Status: <strong>#stepstatusid#</strong>
					<cfelse>
						Rozpoczęty: <strong>#DateFormat(stepbegin, "yyyy.mm.dd")# #TimeFormat(stepbegin, "HH:mm")#</strong><br />
						Zakończony: <strong>#DateFormat(stepend, "yyyy.mm.dd")# #TimeFormat(stepend, "HH:mm")#</strong> 
						przez użytkownika: <strong>#givenname# #sn# <!---#userid#---></strong> ze statusem: <strong>#stepstatusname#</strong>
						<p>#comment#</p>
					</cfif>
				</div>
				
			</cfloop>
	</div>
</cfoutput>
<!---<cfdump var="#steps#" />--->
<script>
	$(function(){
		$("#productDialogBox").dialog({
			autoOpen: false,
			resizable: false,
			height: 400,
			width: 400,
			modal: true,
			buttons: {
				"Potwierdź": function( event, ui ) {
					$("#step-form").submit();
					$("#productDialogBox").dialog("close");
					$("#flashMessages").hide();
						
				},
				Cancel: function() {
					$("#flashMessages").hide();
					$( this ).dialog( "close" );
				}
			}
		});
		
		$(".button").filter(".product").on("click",function(){
				
			if ($(this).hasClass("_confirm")) {
				$("#stepid").val(2);
				$("#stepname").text("Akceptacja");						
			} else {
				$("#stepid").val(3);
				$("#stepname").text("Odrzucenie");
			}		
			
			$("#productDialogBox").dialog({
				title: $("#stepname").text()
			});
			$("#productDialogBox").dialog("open");
				
			return false;
		});
			
		$("#step-form").ajaxForm({
			dataType	: 'html',
			type		: 'post',
			url		: "<cfoutput>#URLFor(action='expo-step')#</cfoutput>",
			success: function (responseText, statusText, xhr, $form){
				
				console.log(<cfoutput>"#URLFor(action='expo-view')#"</cfoutput> + "&key=" + <cfoutput>"#expo.id#"</cfoutput>);
				document.location=<cfoutput>"#URLFor(action='expo-view')#"</cfoutput> + "&key=" + <cfoutput>"#expo.id#"</cfoutput>;
				
			}
		});
		
		$(".fancybox").fancybox({
			openEffect	: 'none',
			closeEffect	: 'none'
		});
	});
</script>