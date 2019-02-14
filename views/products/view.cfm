<cfoutput>
	
	<div class="wrapper">
	
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		<cfelseif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<div id="productDialogBox">
			<h4 id="stepname"></h4>
			
			#startFormTag(action="actionNew", id="step-form")#
			
				#hiddenFieldTag(name="indexid", value="#index.id#")#
				#hiddenFieldTag(name="stepid")#
				
				<cfif index.step eq 1>
					<div class="label">
						#textFieldTag(name="indexcategory", label="Kategoria planogramu", labelPlacement="before", class="input category")#
						#hiddenFieldTag(name="indexcategoryid")#
					</div>
				</cfif>
				
				<cfif index.step eq 1>
					<!---#checkBoxTag(name="indexmm", value="1", label="MM", class="destination")#--->
					<!---#checkBoxTag(name="indexms", value="1", label="MS", class="destination")#--->
					<!---#checkBoxTag(name="indexmp", value="1", label="MP", class="destination")#--->
					<!---#checkBoxTag(name="indexmpp", value="1", label="MP+", class="destination")#--->
					<div class="label">
						#textFieldTag(name="indexdate", label="Data wprowadzenia", labelPlacement="before", class="input date")#
					</div>
				</cfif>
				
				<label class="label">
					Powód / komentarz:
					#textAreaTag(name="stepcomment")#
				</label>
				
			#endFormTag()#
			
		</div>
		
		<div class="wrapper">
			
			<cfswitch expression="#index.type#">
				
				<cfcase value="1">
					
					<h3>Propozycja nowego produktu</h3>
					
					<div class="topLink">
						#linkTo(text="Powrót do listy indeksów", controller="products", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu</h4>
						
						<ol class="productDetails show">
							<li><label>Nazwa produktu:</label><span>#product.name#</span></li>
							<li><label>Kod kreskowy:</label><span>#product.barcode#</span></li>
							<li><label>Kategoria:</label><span>#product.category#</span></li>
							<li><label>Producent:</label><span>#product.producer#</span></li>
							<li><label>Wysokość:</label><span class="size">#product.height#</span></li>
							<li><label>Szerokość:</label><span class="size">#product.width#</span></li>
							<li><label>Głębokość:</label><span class="size">#product.length#</span></li>
							<li><label>Cena zakupu netto:</label><span class="price">#product.netto#</span></li>
							<li><label>Cena sugerowana brutto:</label><span class="price">#product.brutto#</span></li>
							<li>
								<label>Cena na opakowaniu:</label>
								<span>
									<cfif product.printed_price eq 1>
										<img src="./images/yes.png" alt="tak" />
									<cfelse>
										<img src="./images/no.png" alt="nie" />
									</cfif>
								</span>
							</li>
							<li>
								<label>Nowość na rynku:</label>
								<span>
									<cfif product.new eq 1>
										<img src="./images/yes.png" alt="tak" />
									<cfelse>
										<img src="./images/no.png" alt="nie" />
									</cfif>
								</span>
							</li>
							<li>
								<label>Wsparcie ATL:</label>
								<span>
									<cfif product.alt eq 1>
										<img src="./images/yes.png" alt="tak" />
									<cfelse>
										<img src="./images/no.png" alt="nie" />
									</cfif>
								</span>
							</li>
							
							<li>
								<label>Data wprowadzenia (IN):</label>
								<span>
									<cfif StructKeyExists(product, "datein") and product.datein neq ''>
										#DateFormat(product.datein, "yyyy-mm-dd")#
									<cfelse>
										--
									</cfif>
								</span>
							</li>
							<li>
								<label>Data wycofania (OUT):</label>
								<span>
									<cfif StructKeyExists(product, "dateout") and product.dateout neq ''>
										#DateFormat(product.dateout, "yyyy-mm-dd")#
									<cfelse>
										--
									</cfif>
								</span>
							</li>
							
							<cfif StructKeyExists(index.category, "name")>
								<li>
									<label>Kategoria planogramu:</label>
									<span>
										<cfif index.category.name eq ''>
											--
										<cfelse>
											#index.category.name#
										</cfif>
									</span>
								</li>
							</cfif>
							
							<li><label>Dadatkowe informacje:</label><span>#product.comment#</span></li>
							
							<cfif product.productcard neq ''>
								<li>
									<label>Karta produktu:</label>
									<span><a href="files/products/#product.productcard#"><img src="images/excel-icon.png" alt="excel" />&nbsp;#product.productcard#</a></span>
								</li>
							</cfif>
						</ol>
					</div>
					
					<div class="product-images">
						<cfif images.RecordCount gt 0>
							<cfloop query="images">
								<div class="product-image">
									<a href="./files/products/images/#images.file#"><img src="./files/products/images/thumb_#images.file#" alt="#images.file#"></a>
								</div>
							</cfloop>
						</cfif>
						<div style="clear:both"></div>
					</div>
					
				</cfcase>
				
				<cfcase value="2">
					
					<h3>Propozycja nowego produktu w zamian za inny</h3>
					
					<div class="topLink">
						#linkTo(text="Powrót do listy indeksów", controller="products", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu</h4>
						
						<ol class="productDetails show">
							<li><label>Nazwa produktu:</label><span>#product.name#</span></li>
							<li><label>Kod kreskowy:</label><span>#product.barcode#</span></li>
							<li><label>Kategoria:</label><span>#product.category#</span></li>
							<li><label>Producent:</label><span>#product.producer#</span></li>
							<li><label>Wysokość:</label><span class="size">#product.height#</span></li>
							<li><label>Szerokość:</label><span class="size">#product.width#</span></li>
							<li><label>Głębokość:</label><span class="size">#product.length#</span></li>
							<li><label>Cena zakupu netto:</label><span class="price">#product.netto#</span></li>
							<li><label>Cena sugerowana brutto:</label><span class="price">#product.brutto#</span></li>
							<li>
								<label>Cena na opakowaniu:</label>
								<span>
									<cfif product.printed_price eq 1>
										<img src="./images/yes.png" alt="tak" />
									<cfelse>
										<img src="./images/no.png" alt="nie" />
									</cfif>
								</span>
							</li>
							<li>
								<label>Nowość na rynku:</label>
								<span>
									<cfif product.new eq 1>
										<img src="./images/yes.png" alt="tak" />
									<cfelse>
										<img src="./images/no.png" alt="nie" />
									</cfif>
								</span>
							</li>
							<li>
								<label>Wsparcie ATL:</label>
								<span>
									<cfif product.alt eq 1>
										<img src="./images/yes.png" alt="tak" />
									<cfelse>
										<img src="./images/no.png" alt="nie" />
									</cfif>
								</span>
							</li>
							
							<li>
								<label>Data wprowadzenia (IN):</label>
								<span>
									<cfif StructKeyExists(product, "datein") and product.datein neq ''>
										#DateFormat(product.datein, "yyyy-mm-dd")#
									<cfelse>
										--
									</cfif>
								</span>
							</li>
							<li>
								<label>Data wycofania (OUT):</label>
								<span>
									<cfif StructKeyExists(product, "dateout") and product.dateout neq ''>
										#DateFormat(product.dateout, "yyyy-mm-dd")#
									<cfelse>
										--
									</cfif>
								</span>
							</li>
							
							<cfif StructKeyExists(index.category, "name")>
								<li>
									<label>Kategoria planogramu:</label>
									<span>
										<cfif index.category.name eq ''>
											--
										<cfelse>
											#index.category.name#
										</cfif>
									</span>
								</li>
							</cfif>
							
							<li><label>Dadatkowe informacje:</label><span>#product.comment#</span></li>
							
							<cfif product.productcard neq ''>
								<li>
									<label>Karta produktu:</label>
									<span><a href="files/products/#product.productcard#"><img src="images/excel-icon.png" alt="excel" />&nbsp;#product.productcard#</a></span>
								</li>
							</cfif>
						</ol>
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Produkt do wycofania</h4>
						
						
						<div id="#index.productreplace#" class="productreplace"></div>
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
					</div>
					
					<div class="product-images">
						<cfif images.RecordCount gt 0>
							<cfloop query="images">
								<div class="product-image">
									<a href="./files/products/images/#images.file#"><img src="./files/products/images/thumb_#images.file#" alt="#images.file#"></a>
								</div>
							</cfloop>
						</cfif>
						<div style="clear:both"></div>
					</div>
				</cfcase>
				
				<cfcase value="3">
					
					<h3>Odblokowanie produktu</h3>
					
					<div class="topLink">
						#linkTo(text="Powrót do listy indeksów", controller="products", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu do odblokowania</h4>
						
						<div id="#index.productid#" class="productreplace"></div>
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
					</div>
				
				</cfcase>
				
				<cfcase value="4">
					
					<h3>Wycofanie produktu w zamian za inny</h3>
					
					<div class="topLink">
						#linkTo(text="Powrót do listy indeksów", controller="products", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu do odblokowania</h4>
						
						<div id="#index.productid#" class="productreplace"></div>
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
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu do wycofania</h4>
						
						<div id="#index.productreplace#" class="productreplace"></div>
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
					</div>
					
				</cfcase>
				
				<cfcase value="5">
					
					<h3>Propozycja produktu od Dep. Marketingu</h3>
					
					<div class="topLink">
						#linkTo(text="Powrót do listy indeksów", controller="products", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu</h4>
						
						<ol class="productDetails show">
							<li><label>Nazwa produktu:</label><span>#product.name#</span></li>
							<li><label>Kod kreskowy:</label><span>#product.barcode#</span></li>
							<li><label>Kategoria:</label><span>#product.category#</span></li>
							<li><label>Producent:</label><span>#product.producer#</span></li>
							<!---<li><label>Wysokość:</label><span class="size">#product.height#</span></li>--->
							<!---<li><label>Szerokość:</label><span class="size">#product.width#</span></li>--->
							<!---<li><label>Długość:</label><span class="size">#product.length#</span></li>--->
							<!---<li><label>Cena zakupu netto:</label><span class="price">#product.netto#</span></li>--->
							<!---<li><label>Cena sugerowana brutto:</label><span class="price">#product.brutto#</span></li>--->
							<!---<li>
								<label>Cena na opakowaniu:</label>
								<span>
									<cfif product.printed_price eq 1>
										<img src="./images/yes.png" alt="tak" />
									<cfelse>
										<img src="./images/no.png" alt="nie" />
									</cfif>
								</span>
							</li>--->
							<!---<li>
								<label>Nowość na rynku:</label>
								<span>
									<cfif product.new eq 1>
										<img src="./images/yes.png" alt="tak" />
									<cfelse>
										<img src="./images/no.png" alt="nie" />
									</cfif>
								</span>
							</li>--->
							<!---<li>
								<label>Wsparcie ATL:</label>
								<span>
									<cfif product.alt eq 1>
										<img src="./images/yes.png" alt="tak" />
									<cfelse>
										<img src="./images/no.png" alt="nie" />
									</cfif>
								</span>
							</li>--->
							
							<li><label>Dadatkowe informacje:</label><span>#product.comment#</span></li>
							
							<cfif product.productcard neq ''>
								<li>
									<label>Karta produktu:</label>
									<span><a href="files/products/#product.productcard#"><img src="images/excel-icon.png" alt="excel" />&nbsp;#product.productcard#</a></span>
								</li>
							</cfif>
						</ol>
					</div>
					
					<div class="product-images">
						<cfif images.RecordCount gt 0>
							<cfloop query="images">
								<div class="product-image">
									<a href="./files/products/images/#images.file#"><img src="./files/products/images/thumb_#images.file#" alt="#images.file#"></a>
								</div>
							</cfloop>
						</cfif>
						<div style="clear:both"></div>
					</div>
					
				</cfcase>
				
			</cfswitch>
			
			<cfif index.step gt 1>
				<div class="productBox">
					<h4 class="productBoxTitle">Informacje dodatkowe:</h4>
					
					<ol class="indexDetails">
						<li><label>Data wprowadzenia:</label><span>#DateFormat(index.date, "yyyy.mm.dd")# #TimeFormat(index.date, "HH:mm")#</span></li>
						<!---<li>
							<label>MM</label>
							<span>
								<cfif index.mm eq 1>
									<img src="./images/yes.png" alt="tak" />
								<cfelse>
									<img src="./images/no.png" alt="nie" />
								</cfif>
							</span>
						</li>--->
						<!---<li>
							<label>MS</label>
							<span>
								<cfif index.ms eq 1>
									<img src="./images/yes.png" alt="tak" />
								<cfelse>
									<img src="./images/no.png" alt="nie" />
								</cfif>
							</span>
						</li>--->
						<!---<li>
							<label>MP</label>
							<span>
								<cfif index.mp eq 1>
									<img src="./images/yes.png" alt="tak" />
								<cfelse>
									<img src="./images/no.png" alt="nie" />
								</cfif>
							</span>
						</li>--->
						<!---<li>
							<label>MP+</label>
							<span>
								<cfif index.mpp eq 1>
									<img src="./images/yes.png" alt="tak" />
								<cfelse>
									<img src="./images/no.png" alt="nie" />
								</cfif>
							</span>
						</li>--->
					</ol>
				</div>
			</cfif>
			
			<!---<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_verify" >
				<cfinvokeargument name="groupname" value="Weryfikacja nowych indeksów" />
			</cfinvoke>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_acce" >
				<cfinvokeargument name="groupname" value="Akceptacja nowych indeksów" />
			</cfinvoke>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_arch" >
				<cfinvokeargument name="groupname" value="Archiwizowanie indeksów" />
			</cfinvoke>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_dh" >
				<cfinvokeargument name="groupname" value="Departament Handlowy" />
			</cfinvoke>--->
			
			<div class="productActions">
				
				<!---<cfswitch expression="#index.step#">
					
					<cfcase value="1">
						<cfif _verify is true>
							#submitTag(value="Zaakceptuj", class="formButton button redButton product _confirm")#
							#submitTag(value="Odrzuć", class="formButton button redButton product _discard")#
						</cfif>
					</cfcase>
					
					<cfcase value="2,3">
						<cfif _acce is true>
							#submitTag(value="Zaakceptuj", class="formButton button redButton product _accept")#
							#submitTag(value="Odrzuć", class="formButton button redButton product _reject")#
						</cfif>
					</cfcase>
					
					<cfcase value="4,5">
						<cfif _arch is true>
							#submitTag(value="Przenieś do archiwum", class="formButton button redButton product _archiv")#
						</cfif>
					</cfcase>
					
					<cfcase value="7">
						<cfif _dh is true>
							#submitTag(value="Zatwierdź", class="formButton button redButton product dh_accept")#
							#submitTag(value="Odrzuć", class="formButton button redButton product dh_discard")# 
						</cfif>
					</cfcase>
					
				</cfswitch>--->
				
				<!---<cfif index.step eq 1 and _verify is true>
					#submitTag(value="Zaakceptuj", class="formButton button redButton product confirm")#
					#submitTag(value="Odrzuć", class="formButton button redButton product discard")#
				<cfelseif (index.step eq 2 or index.step eq 3) and _acce is true>
					#submitTag(value="Zaakceptuj", class="formButton button redButton product accept")#
					#submitTag(value="Odrzuć", class="formButton button redButton product reject")#
				<cfelseif (index.step eq 4 or index.step eq 5) and _arch is true>
					#submitTag(value="Przenieś do archiwum", class="formButton button redButton product archiv")#
				</cfif>--->
				
			</div>
			
			<cfloop query="steps">
				
				<div class="productstep">
					Użytkownik: <strong>#steps.givenname# #steps.sn#</strong> ustanowił w dniu <strong>#DateFormat(steps.date, "yyyy.mm.dd")# #TimeFormat(steps.date, "HH:mm")#</strong> status <strong>#steps.product_stepnamename#</strong>.
					<p>#steps.comment#</p>
				</div>
				
			</cfloop>
			
		</div>
		
	</div>
</cfoutput>

<script>
	$(function(){		
		$(".productDetails").filter(".show").show();
		
		$(".destination").parent("label").css({
			"float"	: "left",
			"margin"	: "3px 5px"
		});
		
		$("#indexdate").parent("label").addClass("label");
		
		$("#indexdate").datepicker({ dateFormat: "yy-mm-dd" });
		
		$(".size").each(function(index){
			var value = $(this).text();
			if(value != '')
				$(this).text(value + ' cm')
				
		});
		
		$(".price").each(function(index){
			var value = $(this).text();
			if(value != '')
				$(this).text(value + ' zł')
				
		});
		
		$(".productreplace").each(function(){
			
			var $obj = $( "#" + $(this).attr("id") );
			$("#flashMessages").show();
			
			$.get(<cfoutput>"#URLFor(controller='Asseco',action='getIndexesDetails')#"</cfoutput> + "&search=" + $(this).attr("id"), 
				function(data) {
					
					$obj.next().find(".productreplace-name").text(data.ROWS[0].OPIKAR1);
					$obj.next().find(".productreplace-producer").text(data.ROWS[0].NAZWA1);
					//$obj.next().find(".productreplace-cat").text(data.ROWS[0].GRUPA);
					$obj.next().find(".productreplace-cat").text(
						data.ROWS[0].SUPERKATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].SUPERKATEGORIA.substr(1).toLowerCase() + ' > ' + 
						data.ROWS[0].KATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].KATEGORIA.substr(1).toLowerCase() + ' > ' + 
						data.ROWS[0].PODKATEGORIA.substr(0,1).toUpperCase() + data.ROWS[0].PODKATEGORIA.substr(1).toLowerCase()
					);
					$obj.next().find(".productreplace-barcode").text(data.ROWS[0].KODKRES);
					
					if(data.ROWS[0].SZEROKOSC != '')
						$obj.next().find(".productreplace-width").text(data.ROWS[0].SZEROKOSC + ' cm');
						
					if(data.ROWS[0].WYSOKOSC != '')
						$obj.next().find(".productreplace-height").text(data.ROWS[0].WYSOKOSC + ' cm');
					
					if(data.ROWS[0].DLUGOSC != '')	
						$obj.next().find(".productreplace-length").text(data.ROWS[0].DLUGOSC + ' cm');
					
					$obj.next().show();
					
					$("#flashMessages").hide();
				}, "json");
			
		});
		
		$( "#productDialogBox" ).dialog({
		 	autoOpen: false,
			resizable: false,
			height: 400,
			width: 400,
			modal: true,
			buttons: {
				"Potwierdź": function( event, ui ) {
					
					<!--- $.post(<cfoutput>"#URLFor(controller='Products',action='newstep')#"</cfoutput>, { indexid: $("#productid").val(), stepid: $("#stepid").val(), stepcomment: $("#stepcomment").val() } ); --->
					
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
			
			/*setTimeout(function(){
				$("#flashMessages").hide();
			}, 50);*/
			
			if ($(this).hasClass("_archiv")) {
				
				$("#stepid").val(6);
				$("#stepname").text("Przeniesienie do archiwum");
				$("#step-form").submit();
			
			}
			else
			if ($(this).hasClass("dh_accept")) {
				document.location = <cfoutput>"#URLFor(controller='Products',action='prepare')#"</cfoutput> + "&key=" + $('#indexid').val();
			}
			else { 
				if ($(this).hasClass("_confirm")) {
					
					$("#stepid").val(2);
					$("#stepname").text("Pomyślna weryfikacja");
						
				}
				else 
				if ($(this).hasClass("_discard")) {
						
					$("#stepid").val(3);
					$("#stepname").text("Odrzucony na etapie weryfikacji");
							
					$(".destination").parent().remove();
					$(".date").parent().remove();
							
				}
				else 
				if ($(this).hasClass("_accept")) {
							
					$("#stepid").val(4);
					$("#stepname").text("Akceptacja");
								
				}
				else 
				if ($(this).hasClass("_reject")) {
					$("#stepid").val(5);
					$("#stepname").text("Brak akceptacji");
				}
				else
				if ($(this).hasClass("dh_discard")) {
					$("#stepid").val(5);
					$("#stepname").text("Brak akceptacji");
				}
					
				$("#productDialogBox").dialog({
					title: $("#stepname").text()
				});
				$("#productDialogBox").dialog("open");
			}
			
			return false;
		});
		
		$("#step-form").ajaxForm({
			dataType	: 'json',
			type		: 'post',
			url		: "<cfoutput>#URLFor(controller='Products',action='newstep')#</cfoutput>",
			success: function (responseText, statusText, xhr, $form){
				document.location=<cfoutput>"#URLFor(controller='Products',action='index')#"</cfoutput>; //+ "&key=" + $('#indexid').val();
			}
		});
		
		var t_timeout;
		var _options = {
			source	: 
				function( request, response ) {
					clearTimeout(t_timeout);
					$("#flashMessages").show();
					
					t_timeout = setTimeout(function() {
						
						$.ajax({
							url			: <cfoutput>"#URLFor(controller='products',action='planogram-categories')#"</cfoutput> + "&search=" + request.term,
							type		: "get",
							dataType	: "json",
							success		: function( data ) {
								
								$("#flashMessages").hide();
								
								response( $.map( data.DATA, function( item ) {
									return { label: item[1], id: item[0] }
								}));
							},
							error: function(){
								alert("Błąd wyszukiwania. Spróbuj ponownie później.");
							}
						});
						
					}, 500);
				}
			,minLength: 2
			,select: function( event, ui ) {
				$("#indexcategory").val(ui.item.label);
				$("#indexcategoryid").val(ui.item.id);
			}
		};
		
		$("#indexcategory").autocomplete(_options);
	});
</script>