<cfoutput>
	
	<div class="wrapper products">
	
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		<cfelseif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<div id="productDialogBox">
			<h4 id="stepname"></h4>
			
			#startFormTag(action="step", id="step-form")#
			
				#hiddenFieldTag(name="indexid", value="#index.id#")#
				#hiddenFieldTag(name="stepid")#
				
				<cfif index.step eq 10>
					<div class="label">
						#textFieldTag(name="indexcategory", label="Kategoria planogramu", labelPlacement="before", class="input category")#
						#hiddenFieldTag(name="indexcategoryid")#
					</div>
				</cfif>
				
				<cfif index.step eq 10>
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
		
		<div id="product-file-form" title="Formularz dodawania pliku z wyceną" style="display:none">
							
			<div id="products">
				<div class="intranet-tab-content">
									
					#startFormTag(action="update", multipart="true", id="product-file")#
									
						#hiddenFieldTag(name="indexid", value="#params.key#")#
						#hiddenFieldTag(name="product[id]", value="#product.id#")#
									
					#endFormTag()#
									
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
					
				</div>
			</div>
		</div>
		
		<div class="wrapper">
			
			<cfswitch expression="#index.type#">
				
				<cfcase value="1">
					
					<h3>Propozycja nowego produktu</h3>
					
					<div class="topLink">
						#linkTo(text="Powrót do listy indeksów", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu</h4>
						
						<ol class="productDetails show">
							<li><label>Nazwa produktu</label><span>#product.name#</span></li>
							<li><label>Kod kreskowy</label><span>#product.barcode#</span></li>
							<li><label>Kategoria</label><span>#product.category#</span></li>
							<li><label>Producent</label><span>#product.producer#</span></li>
							<li>
								<label>Wymiary (wys/szer/dłu)</label>
								<span class="size">#product.height#</span> / <span class="size">#product.width#</span> / <span class="size">#product.length#</span>
							</li>
							<li><label>Cena zakupu netto</label><span class="price">#product.netto#</span></li>
							<li><label>Stawka VAT</label><span class="">#product.vat#</span></li>
							<li><label>Cena sugerowana brutto</label><span class="price">#product.brutto#</span></li>
							
							<cfif product.datein neq '' and product.dateout neq ''>
								<li>
									<label>Data IN-OUT</label>
									
									<cfif StructKeyExists(product, "datein") and product.datein neq ''>
										<span>#DateFormat(product.datein, "yyyy-mm-dd")# - </span>
									</cfif>
									
									<cfif StructKeyExists(product, "dateout") and product.dateout neq ''>
										<span>#DateFormat(product.dateout, "yyyy-mm-dd")#</span>
									</cfif>
									
									<cfif StructKeyExists(product, "indexout") and product.indexout neq ''>
										<span>w zamian za #product.indexout#</span>
									</cfif>
								</li>
								<li>
									<label>Ilość per sklep</label>
									<span>#product.amount#</span>
								</li>
								<li>
									<label>Budżet wyprzedażowy</label>
									<span>#product.budget#</span>
								</li>
							</cfif>
							
							<li>
								<label>Ilość jednostek zbiorczych w opakowaniu</label>
								<span>#product.capacity#</span>
							</li>
							
							<li><label>Dadatkowe informacje</label><span>#product.comment#</span></li>
							
							<cfif product.productfile neq ''>
								<li>
									<label>Plik z wyceną</label>
									<span><a href="files/products/expo/#product.productfile#"><img src="images/#GetIconForFile(filename=product.productfile)#" alt="#product.productfile#" />&nbsp;#Right(product.productfile, Len(product.productfile)-20)#</a></span>
								</li>
							</cfif>
							
							<cfif product.productcard neq ''>
								<li>
									<label>Karta produktu</label>
									<span><a href="files/products/#product.productcard#"><img src="images/#GetIconForFile(filename=product.productcard)#" alt="#product.productcard#" />&nbsp;#Right(product.productcard, Len(product.productcard)-20)#</a></span>
								</li>
							</cfif>
							
							<!---<cfif StructKeyExists(index.category, "name")>--->
								<li>
									<label>Kategoria planogramu</label>
									<span>
										<cfif index.categoryname eq ''>
											--
										<cfelse>
											#index.categoryname#
										</cfif>
									</span>
								</li>
							<!---</cfif>--->
							
							<li>
								<label>Data wprowadzenia</label>
								<span>
									<cfif index.date eq ''>
										--
									<cfelse>
										#DateFormat(index.date, "dd.mm.yyyy")#
									</cfif>
								</span>
							</li>
						</ol>
						
						<cfif index.step lte 11 and product.productfile eq '' and index.version eq 2>
							<a href="##" class="formButton navigate" id="product-file-button" data-source="product-file-form">Dodaj plik z wyceną</a>
						</cfif>
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
						#linkTo(text="Powrót do listy indeksów", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu</h4>
						
						<ol class="productDetails show">
							<li><label>Nazwa produktu</label><span>#product.name#</span></li>
							<li><label>Kod kreskowy</label><span>#product.barcode#</span></li>
							<li><label>Kategoria</label><span>#product.category#</span></li>
							<li><label>Producent</label><span>#product.producer#</span></li>
							<li>
								<label>Wymiary (wys/szer/dłu)</label>
								<span class="size">#product.height#</span> / <span class="size">#product.width#</span> / <span class="size">#product.length#</span>
							</li>
							<li><label>Cena zakupu netto</label><span class="price">#product.netto#</span></li>
							<li><label>Stawka VAT</label><span class="">#product.vat#</span></li>
							<li><label>Cena sugerowana brutto</label><span class="price">#product.brutto#</span></li>
							
							<cfif product.datein neq '' and product.dateout neq ''>
								<li>
									<label>Data IN-OUT</label>
									
									<cfif StructKeyExists(product, "datein") and product.datein neq ''>
										<span>#DateFormat(product.datein, "yyyy-mm-dd")# - </span>
									</cfif>
									
									<cfif StructKeyExists(product, "dateout") and product.dateout neq ''>
										<span>#DateFormat(product.dateout, "yyyy-mm-dd")#</span>
									</cfif>
									
									<cfif StructKeyExists(product, "indexout") and product.indexout neq ''>
										<span>w zamian za #product.indexout#</span>
									</cfif>
								</li>
								<li>
									<label>Ilość per sklep</label>
									<span>#product.amount#</span>
								</li>
								<li>
									<label>Budżet wyprzedażowy</label>
									<span>#product.budget#</span>
								</li>
							</cfif>
							
							<li>
								<label>Ilość jednostek zbiorczych w opakowaniu</label>
								<span>#product.capacity#</span>
							</li>
							
							<li><label>Dadatkowe informacje</label><span>#product.comment#</span></li>
							
							<cfif product.productfile neq ''>
								<li>
									<label>Plik z wyceną</label>
									<span><a href="files/products/expo/#product.productfile#"><img src="images/#GetIconForFile(filename=product.productfile)#" alt="#product.productfile#" />&nbsp;#Right(product.productfile, Len(product.productfile)-20)#</a></span>
								</li>
							</cfif>
							
							<cfif product.productcard neq ''>
								<li>
									<label>Karta produktu</label>
									<span><a href="files/products/#product.productcard#"><img src="images/#GetIconForFile(filename=product.productcard)#" alt="#product.productcard#" />&nbsp;#Right(product.productcard, Len(product.productcard)-20)#</a></span>
								</li>
							</cfif>
							
							<!---<cfif StructKeyExists(index.category, "name")>--->
								<li>
									<label>Kategoria planogramu</label>
									<span>
										<cfif index.categoryname eq ''>
											--
										<cfelse>
											#index.categoryname#
										</cfif>
									</span>
								</li>
							<!---</cfif>--->
							
							<li>
								<label>Data wprowadzenia</label>
								<span>
									<cfif index.date eq ''>
										--
									<cfelse>
										#DateFormat(index.date, "dd.mm.yyyy")#
									</cfif>
								</span>
							</li>
						</ol>
						
						<cfif index.step lte 11 and product.productfile eq '' and index.version eq 2>
							<a href="##" class="formButton navigate" id="product-file-button" data-source="product-file-form">Dodaj plik z wyceną</a>
						</cfif>
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
						#linkTo(text="Powrót do listy indeksów", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu do odblokowania</h4>
						
						<ol class="productDetails show">
							<li><label>Nazwa produktu</label><span>#product.name#</span></li>
							<li><label>Kod kreskowy</label><span>#product.barcode#</span></li>
							<li><label>Indeks produktu (z naszej kartoteki)</label><span>#product.innerindex#</span></li>
							<li><label>Kategoria</label><span>#product.category#</span></li>
							<li><label>Producent</label><span>#product.producer#</span></li>
							<li>
								<label>Wymiary (wys/szer/dłu)</label>
								<span class="size">#product.height#</span> / <span class="size">#product.width#</span> / <span class="size">#product.length#</span>
							</li>
							<li><label>Cena zakupu netto</label><span class="price">#product.netto#</span></li>
							<li><label>Stawka VAT</label><span class="">#product.vat#</span></li>
							<li><label>Cena sugerowana brutto</label><span class="price">#product.brutto#</span></li>
							
							<cfif product.datein neq '' and product.dateout neq ''>
								<li>
									<label>Data IN-OUT</label>
									
									<cfif StructKeyExists(product, "datein") and product.datein neq ''>
										<span>#DateFormat(product.datein, "yyyy-mm-dd")# - </span>
									</cfif>
									
									<cfif StructKeyExists(product, "dateout") and product.dateout neq ''>
										<span>#DateFormat(product.dateout, "yyyy-mm-dd")#</span>
									</cfif>
									
									<cfif StructKeyExists(product, "indexout") and product.indexout neq ''>
										<span>w zamian za #product.indexout#</span>
									</cfif>
								</li>
								
								<li>
									<label>Ilość per sklep</label>
									<span>#product.amount#</span>
								</li>
								<li>
									<label>Budżet wyprzedażowy</label>
									<span>#product.budget#</span>
								</li>
							</cfif>
							
							<li>
								<label>Ilość jednostek zbiorczych w opakowaniu</label>
								<span>#product.capacity#</span>
							</li>
							
							<li><label>Dadatkowe informacje</label><span>#product.comment#</span></li>
							
							<cfif product.productfile neq ''>
								<li>
									<label>Plik z wyceną</label>
									<span><a href="files/products/expo/#product.productfile#"><img src="images/#GetIconForFile(filename=product.productfile)#" alt="#product.productfile#" />&nbsp;#Right(product.productfile, Len(product.productfile)-20)#</a></span>
								</li>
							</cfif>
							
							<cfif product.productcard neq ''>
								<li>
									<label>Karta produktu</label>
									<span><a href="files/products/#product.productcard#"><img src="images/#GetIconForFile(filename=product.productcard)#" alt="#product.productcard#" />&nbsp;#Right(product.productcard, Len(product.productcard)-20)#</a></span>
								</li>
							</cfif>
							
							<!---<cfif StructKeyExists(index.category, "name")>--->
								<li>
									<label>Kategoria planogramu</label>
									<span>
										<cfif index.categoryname eq ''>
											--
										<cfelse>
											#index.categoryname#
										</cfif>
									</span>
								</li>
							<!---</cfif>--->
							
							<li>
								<label>Data wprowadzenia</label>
								<span>
									<cfif index.date eq ''>
										--
									<cfelse>
										#DateFormat(index.date, "dd.mm.yyyy")#
									</cfif>
								</span>
							</li>
						</ol>
						
						<cfif index.step lte 11 and product.productfile eq '' and index.version eq 2>
							<a href="##" class="formButton navigate" id="product-file-button" data-source="product-file-form">Dodaj plik z wyceną</a>
						</cfif>
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
				
				<cfcase value="4">
					
					<h3>Wycofanie produktu w zamian za inny</h3>
					
					<div class="topLink">
						#linkTo(text="Powrót do listy indeksów", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu do odblokowania</h4>
						
						<ol class="productDetails show">
							<li><label>Nazwa produktu</label><span>#product.name#</span></li>
							<li><label>Kod kreskowy</label><span>#product.barcode#</span></li>
							<li><label>Indeks produktu (z naszej kartoteki)</label><span>#product.innerindex#</span></li>
							<li><label>Kategoria</label><span>#product.category#</span></li>
							<li><label>Producent</label><span>#product.producer#</span></li>
							<li>
								<label>Wymiary (wys/szer/dłu)</label>
								<span class="size">#product.height#</span> / <span class="size">#product.width#</span> / <span class="size">#product.length#</span>
							</li>
							<li><label>Cena zakupu netto</label><span class="price">#product.netto#</span></li>
							<li><label>Stawka VAT</label><span class="">#product.vat#</span></li>
							<li><label>Cena sugerowana brutto</label><span class="price">#product.brutto#</span></li>
							
							<cfif product.datein neq '' and product.dateout neq ''>
								<li>
									<label>Data IN-OUT</label>
									
									<cfif StructKeyExists(product, "datein") and product.datein neq ''>
										<span>#DateFormat(product.datein, "yyyy-mm-dd")# - </span>
									</cfif>
									
									<cfif StructKeyExists(product, "dateout") and product.dateout neq ''>
										<span>#DateFormat(product.dateout, "yyyy-mm-dd")#</span>
									</cfif>
									
									<cfif StructKeyExists(product, "indexout") and product.indexout neq ''>
										<span>w zamian za #product.indexout#</span>
									</cfif>
								</li>
								
								<li>
									<label>Ilość per sklep</label>
									<span>#product.amount#</span>
								</li>
								<li>
									<label>Budżet wyprzedażowy</label>
									<span>#product.budget#</span>
								</li>
							</cfif>
							
							
							<li>
								<label>Ilość jednostek zbiorczych w opakowaniu</label>
								<span>#product.capacity#</span>
							</li>
							
							<li><label>Dadatkowe informacje</label><span>#product.comment#</span></li>
							
							<cfif product.productfile neq ''>
								<li>
									<label>Plik z wyceną</label>
									<span><a href="files/products/expo/#product.productfile#"><img src="images/#GetIconForFile(filename=product.productfile)#" alt="#product.productfile#" />&nbsp;#Right(product.productfile, Len(product.productfile)-20)#</a></span>
								</li>
							</cfif>
							
							<cfif product.productcard neq ''>
								<li>
									<label>Karta produktu</label>
									<span><a href="files/products/#product.productcard#"><img src="images/#GetIconForFile(filename=product.productcard)#" alt="#product.productcard#" />&nbsp;#Right(product.productcard, Len(product.productcard)-20)#</a></span>
								</li>
							</cfif>
							
							<!---<cfif StructKeyExists(index.category, "name")>--->
								<li>
									<label>Kategoria planogramu</label>
									<span>
										<cfif index.categoryname eq ''>
											--
										<cfelse>
											#index.categoryname#
										</cfif>
									</span>
								</li>
							<!---</cfif>--->
							
							<li>
								<label>Data wprowadzenia</label>
								<span>
									<cfif index.date eq ''>
										--
									<cfelse>
										#DateFormat(index.date, "dd.mm.yyyy")#
									</cfif>
								</span>
							</li>
						</ol>
						
						<cfif index.step lte 11 and product.productfile eq '' and index.version eq 2>
							<a href="##" class="formButton navigate" id="product-file-button" data-source="product-file-form">Dodaj plik z wyceną</a>
						</cfif>
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
				
				<cfcase value="5">
					
					<h3>Propozycja produktu od Dep. Marketingu</h3>
					
					<div class="topLink">
						#linkTo(text="Powrót do listy indeksów", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu</h4>
						
						<ol class="productDetails show">
							<li><label>Nazwa produktu</label><span>#product.name#</span></li>
							<li><label>Kod kreskowy</label><span>#product.barcode#</span></li>
							<li><label>Kategoria</label><span>#product.category#</span></li>
							<li><label>Producent</label><span>#product.producer#</span></li>
							<li>
								<label>Wymiary (wys/szer/dłu)</label>
								<span class="size">#product.height#</span> / <span class="size">#product.width#</span> / <span class="size">#product.length#</span>
							</li>
							<li><label>Cena zakupu netto</label><span class="price">#product.netto#</span></li>
							<li><label>Stawka VAT</label><span class="">#product.vat#</span></li>
							<li><label>Cena sugerowana brutto</label><span class="price">#product.brutto#</span></li>
							
							<cfif product.datein neq '' and product.dateout neq ''>
								<li>
									<label>Data IN-OUT</label>
									
									<cfif StructKeyExists(product, "datein") and product.datein neq ''>
										<span>#DateFormat(product.datein, "yyyy-mm-dd")# - </span>
									</cfif>
									
									<cfif StructKeyExists(product, "dateout") and product.dateout neq ''>
										<span>#DateFormat(product.dateout, "yyyy-mm-dd")#</span>
									</cfif>
									
									<cfif StructKeyExists(product, "indexout") and product.indexout neq ''>
										<span>w zamian za #product.indexout#</span>
									</cfif>
								</li>
								<li>
									<label>Ilość per sklep</label>
									<span>#product.amount#</span>
								</li>
								<li>
									<label>Budżet wyprzedażowy</label>
									<span>#product.budget#</span>
								</li>
							</cfif>
							
							<li>
								<label>Ilość jednostek zbiorczych w opakowaniu</label>
								<span>#product.capacity#</span>
							</li>
							
							<li><label>Dadatkowe informacje</label><span>#product.comment#</span></li>
							
							<cfif product.productfile neq ''>
								<li>
									<label>Plik z wyceną</label>
									<span><a href="files/products/expo/#product.productfile#"><img src="images/#GetIconForFile(filename=product.productfile)#" alt="#product.productfile#" />&nbsp;#Right(product.productfile, Len(product.productfile)-20)#</a></span>
								</li>
							</cfif>
							
							<cfif product.productcard neq ''>
								<li>
									<label>Karta produktu</label>
									<span><a href="files/products/#product.productcard#"><img src="images/#GetIconForFile(filename=product.productcard)#" alt="#product.productcard#" />&nbsp;#Right(product.productcard, Len(product.productcard)-20)#</a></span>
								</li>
							</cfif>
							
							<!---<cfif StructKeyExists(index.category, "name")>--->
								<li>
									<label>Kategoria planogramu</label>
									<span>
										<cfif index.categoryname eq ''>
											--
										<cfelse>
											#index.categoryname#
										</cfif>
									</span>
								</li>
							<!---</cfif>--->
							
							<li>
								<label>Data wprowadzenia</label>
								<span>
									<cfif index.date eq ''>
										--
									<cfelse>
										#DateFormat(index.date, "dd.mm.yyyy")#
									</cfif>
								</span>
							</li>
						</ol>
						
						<cfif index.step lte 11 and product.productfile eq '' and index.version eq 2>
							<a href="##" class="formButton navigate" id="product-file-button" data-source="product-file-form">Dodaj plik z wyceną</a>
						</cfif>
						
						<cfif index.step eq 8>
							<a href="#URLFor(action='form', params='form=dm&key=#product.id#')#" class="formButton navigate" id="product-update" data-source="product-update-form">Aktualizuj dane</a>
						</cfif>
						
						<div id="product-update-form" title="Aktualizacja produktu" style="display:none">
							
							<div id="products">
								<div class="intranet-tab-content">
									
									#startFormTag(action="update", multipart="true", id="product-form")#
									
									#hiddenFieldTag(name="indexid", value="#params.key#")#
									#hiddenFieldTag(name="product[id]", value="#product.id#")#
									#hiddenFieldTag(name="product[productcard]")#
									
									<fieldset>
										<legend>Szczegóły produktu</legend>
										
										<ol class="product-form">
											<li>
												<label>Wymiary</label>
												wys: #textFieldTag(name="product[height]", class="input number product-height", placeholder="wysokość")#
												szer: #textFieldTag(name="product[width]", class="input number product-width", placeholder="szerokość")#
												dł: #textFieldTag(name="product[length]", class="input number product-length", placeholder="długość")#
											</li>
											<li>
												#textFieldTag(name="product[netto]", value=product.netto, label="Cena zakupu (netto)", labelPlacement="before", class="input number price product-netto required")#
											</li>
											<li>
												#textFieldTag(name="product[vat]", value=product.netto, label="Stawka VAT", labelPlacement="before", class="input price number product-vat required")#
											</li>
											<li>
												#textFieldTag(name="product[brutto]", value=product.brutto, label="Cena sugerowana sprzedaży brutto", labelPlacement="before", class="input number price product-brutto")#
											</li>
											<li class="">
												<label>IN-OUT</label>
												<input type="checkbox" name="inout" id="inout" />
											</li>
											
											<li class="product_date inout">
												<div class="fadeBackground"></div>
												#textFieldTag(name="product[datein]", label="Data wejścia", labelPlacement="before", class="input date_picker dateinout product-datein")#
												<div style="clear:both;" />
											</li>
											<li class="product_date inout">
												<div class="fadeBackground"></div>
												#textFieldTag(name="product[dateout]", label="Data wyjścia", labelPlacement="before", class="input date_picker dateinout product-dateout")#
												<div style="clear:both;" />
											</li>
											<li class="indexout" style="display:none">
												<div class="fadeBackground"></div>
												#textFieldTag(name="product[indexout]", label="Indeks do wycofania", labelPlacement="before", class="input product-indexout")#
												#hiddenFieldTag(name="product[indexoutid]", value="")#
											</li>
											<li class="inout">
												<div class="fadeBackground"></div>
												#textFieldTag(name="product[amount]", label="Ilość per sklep", labelPlacement="before", class="input number product-amount")#
											</li>
											<li class="inout">
												<div class="fadeBackground"></div>
												#textFieldTag(name="product[budget]", label="Budżet wyprzedażowy", labelPlacement="before", class="input number product-budget")#
											</li>
											<li>
												#textFieldTag(name="product[capacity]", label="Ilość jednostek w opakowaniu", labelPlacement="before", class="input number product-capacity")#
											</li>
											<li>
												#textAreaTag(name="product[comment]", value=product.comment, label="Dodatkowe informacje", labelPlacement="before", class="textarea product-comment")#
											</li>
										</ol>
										
									</fieldset>
									
									#endFormTag()#
									
									<cfform 
										action="#URLFor(action='uploadXls')#" 
										id="productcarduploadform" 
										method="post">
										<fieldset>
											<legend>Karta produktu</legend>
											<ol>
												<li class="invoiceForm">
													<label>Plik z kartą nowego produktu</label>
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
								</div>
							</div>
						</div>
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
				
				<cfcase value="6">
					
					<h3>KZ/OW wraca do sprzedaży</h3>
					
					<div class="topLink">
						#linkTo(text="Powrót do listy indeksów", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu</h4>
						
						<ol class="productDetails show">
							<li><label>Nazwa produktu</label><span>#product.name#</span></li>
							<li><label>Kod kreskowy</label><span>#product.barcode#</span></li>
							<li><label>Kategoria</label><span>#product.category#</span></li>
							<li><label>Producent</label><span>#product.producer#</span></li>
							<li>
								<label>Wymiary (wys/szer/dłu)</label>
								<span class="size">#product.height#</span> / <span class="size">#product.width#</span> / <span class="size">#product.length#</span>
							</li>
							<!---<li><label>Cena zakupu netto</label><span class="price">#product.netto#</span></li>--->
							<li><label>Stawka VAT</label><span class="price">#product.vat#</span></li>
							<li><label>Cena sugerowana brutto</label><span class="price">#product.brutto#</span></li>
							
							<cfif product.datein neq '' and product.dateout neq ''>
								<li>
									<label>Data IN-OUT</label>
									
									<cfif StructKeyExists(product, "datein") and product.datein neq ''>
										<span>#DateFormat(product.datein, "yyyy-mm-dd")# - </span>
									</cfif>
									
									<cfif StructKeyExists(product, "dateout") and product.dateout neq ''>
										<span>#DateFormat(product.dateout, "yyyy-mm-dd")#</span>
									</cfif>
									
									<cfif StructKeyExists(product, "indexout") and product.indexout neq ''>
										<span>w zamian za #product.indexout#</span>
									</cfif>
								</li>
								
								<li>
									<label>Ilość per sklep</label>
									<span>#product.amount#</span>
								</li>
								<li>
									<label>Budżet wyprzedażowy</label>
									<span>#product.budget#</span>
								</li>
							</cfif>
							
							<li>
								<label>Ilość jednostek zbiorczych w opakowaniu</label>
								<span>#product.capacity#</span>
							</li>
							
							<li><label>Dadatkowe informacje</label><span>#product.comment#</span></li>
							
							<cfif product.productfile neq ''>
								<li>
									<label>Plik z wyceną</label>
									<span><a href="files/products/expo/#product.productfile#"><img src="images/#GetIconForFile(filename=product.productfile)#" alt="#product.productfile#" />&nbsp;#Right(product.productfile, Len(product.productfile)-20)#</a></span>
								</li>
							</cfif>
							
							<cfif product.productcard neq ''>
								<li>
									<label>Karta produktu</label>
									<span><a href="files/products/#product.productcard#"><img src="images/#GetIconForFile(filename=product.productcard)#" alt="#product.productcard#" />&nbsp;#Right(product.productcard, Len(product.productcard)-20)#</a></span>
								</li>
							</cfif>
							
							<!---<cfif StructKeyExists(index.category, "name")>--->
								<li>
									<label>Kategoria planogramu</label>
									<span>
										<cfif index.categoryname eq ''>
											--
										<cfelse>
											#index.categoryname#
										</cfif>
									</span>
								</li>
							<!---</cfif>--->
						
							<li>
								<label>Data wprowadzenia</label>
								<span>
									<cfif index.date eq ''>
										--
									<cfelse>
										#DateForm(index.date, "yyyy-mm-dd")#
									</cfif>
								</span>
							</li>
						</ol>
						
						<cfif index.step lte 11 and product.productfile eq '' and index.version eq 2>
							<a href="##" class="formButton navigate" id="product-file-button" data-source="product-file-form">Dodaj plik z wyceną</a>
						</cfif>
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
				
				<cfcase value="7">
					
					<h3>Propozycja nowego produktu (złożonego z indeksów eksploatacyjnych)</h3>
					
					<div class="topLink">
						#linkTo(text="Powrót do listy indeksów", action="index")#
					</div>
					
					<div class="productBox">
						<h4 class="productBoxTitle">Propozycja produktu</h4>
						
						<ol class="productDetails show">
							<li><label>Nazwa produktu</label><span>#product.name#</span></li>
							<li><label>Kod kreskowy</label><span>#product.barcode#</span></li>
							<li><label>Kategoria</label><span>#product.category#</span></li>
							<li><label>Producent</label><span>#product.producer#</span></li>
							<li>
								<label>Wymiary (wys/szer/dłu)</label>
								<span class="size">#product.height#</span> / <span class="size">#product.width#</span> / <span class="size">#product.length#</span>
							</li>
							
							<!---<li><label>Cena zakupu netto</label><span class="price">#product.netto#</span></li>--->
								
							<li><label>Stawka VAT</label><span class="">#product.vat#</span></li>
							
							<li><label>Cena sugerowana sprzedaży netto</label><span class="price">#product.csn#</span></li>
							
							<li><label>Stawka VAT dla ceny sugerowanej sprzedaży netto</label><span class="">#product.csnvat#</span></li>
							
							<!---<li><label>Stawka VAT dla recepturowych</label><span class="percent">#product.recvat#</span></li>--->
							
							<cfif product.datein neq '' and product.dateout neq ''>
								<li>
									<label>Data IN-OUT</label>
									
									<cfif StructKeyExists(product, "datein") and product.datein neq ''>
										<span>#DateFormat(product.datein, "yyyy-mm-dd")# - </span>
									</cfif>
									
									<cfif StructKeyExists(product, "dateout") and product.dateout neq ''>
										<span>#DateFormat(product.dateout, "yyyy-mm-dd")#</span>
									</cfif>
									
									<cfif StructKeyExists(product, "indexout") and product.indexout neq ''>
										<span>w zamian za #product.indexout#</span>
									</cfif>
								</li>
								
								<li>
									<label>Ilość per sklep</label>
									<span>#product.amount#</span>
								</li>
								<li>
									<label>Budżet wyprzedażowy</label>
									<span>#product.budget#</span>
								</li>
							</cfif>
							
							<!---<li>
								<label>Ilość jednostek zbiorczych w opakowaniu</label>
								<span>#product.capacity#</span>
							</li>--->
							
							<!---<cfif StructKeyExists(index.category, "name")>--->
								<!---<li>
									<label>Kategoria planogramu</label>
									<span>
										<cfif index.categoryname eq ''>
											--
										<cfelse>
											#index.categoryname#
										</cfif>
									</span>
								</li>--->
							<!---</cfif>--->
							
							<li><label>Dadatkowe informacje</label><span>#product.comment#</span></li>
							
							<cfif product.productfile neq ''>
								<li>
									<label>Plik z wyceną</label>
									<span><a href="files/products/expo/#product.productfile#"><img src="images/#GetIconForFile(filename=product.productfile)#" alt="#product.productfile#" />&nbsp;#Right(product.productfile, Len(product.productfile)-20)#</a></span>
								</li>
							</cfif>
							
							<cfif product.productcard neq ''>
								<li>
									<label>Karta produktu</label>
									<span><a href="files/products/#product.productcard#"><img src="images/#GetIconForFile(filename=product.productcard)#" alt="#product.productcard#" />&nbsp;#Right(product.productcard, Len(product.productcard)-20)#</a></span>
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
			
			<!---<cfif index.step gt 1>
				<div class="productBox">
					<h4 class="productBoxTitle">Informacje dodatkowe:</h4>
					
					<ol class="indexDetails">
						<li><label>Data wprowadzenia:</label><span>#DateFormat(index.date, "yyyy.mm.dd")# #TimeFormat(index.date, "HH:mm")#</span></li>
					</ol>
				</div>
			</cfif>--->
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_merch" >
				<cfinvokeargument name="groupname" value="Analiza produktu - Merchandising" />
			</cfinvoke>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_anal" >
				<cfinvokeargument name="groupname" value="Analiza produktu - Dział Analiz i Polityki Cenowej" />
			</cfinvoke>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_acce" >
				<cfinvokeargument name="groupname" value="Akceptacja nowych indeksów" />
			</cfinvoke>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_arch" >
				<cfinvokeargument name="groupname" value="Archiwizowanie indeksów" />
			</cfinvoke>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_dh" >
				<cfinvokeargument name="groupname" value="Departament Handlowy" />
			</cfinvoke>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_ds" >
				<cfinvokeargument name="groupname" value="Akceptacja indeksow przez DS" />
			</cfinvoke>
			
			<div class="productActions">
				
				<!---#submitTag(value="Zaakceptuj", class="formButton button redButton product _confirm")#--->
				
				<cfif index.stepstatusid neq 3>
				
					<cfswitch expression="#index.step#">
					
						<cfcase value="8">
							<cfif _dh is true>
								#submitTag(value="Zaakceptuj", class="formButton button redButton product _confirm")#
								#submitTag(value="Odrzuć", class="formButton button redButton product _discard")#
							</cfif>
						</cfcase>
						
						<cfcase value="9">
							<cfif _acce is true>
								#submitTag(value="Zaakceptuj", class="formButton button redButton product _confirm")#
								#submitTag(value="Odrzuć", class="formButton button redButton product _discard")#
							</cfif>
						</cfcase>
						
						<cfcase value="10">
							<cfif _merch is true>
								#submitTag(value="Zaakceptuj", class="formButton button redButton product _accept")#
								#submitTag(value="Odrzuć", class="formButton button redButton product _reject")#
							</cfif>
						</cfcase>
						
						<cfcase value="11">
							<cfif _anal is true>
								#submitTag(value="Zaakceptuj", class="formButton button redButton product _accept")#
								#submitTag(value="Odrzuć", class="formButton button redButton product _reject")#
							</cfif>
						</cfcase>
						
						<cfcase value="12">
							<cfif _dh is true>
								#submitTag(value="Zaakceptuj", class="formButton button redButton product _archiv")#
							</cfif>
						</cfcase>
						
						<cfcase value="14">
							<cfif _ds is true>
								#submitTag(value="Zaakceptuj", class="formButton button redButton product _accept")#
								#submitTag(value="Odrzuć", class="formButton button redButton product _reject")#
							</cfif>
						</cfcase>
						
					</cfswitch>
				
				</cfif>
				
			</div>
			
			<cfloop query="steps">
				
				<div class="productstep">
					<div>#stepname#</div>
					<div class="steplabel">Utworzono: <strong>#DateFormat(stepstatusdatebegin, "yyyy.mm.dd")#</strong> o godzinie <strong>#TimeFormat(stepstatusdatebegin, "HH:mm")#</strong></div>
					<cfif stepid neq 13>
						<cfif stepstatusdateend eq ''>
							<div class="steplabel">Status: <strong>#stepstatusname#</strong></div>
						<cfelse>
							<div class="steplabel">Zmieniono status: <strong>#DateFormat(stepstatusdateend, "yyyy.mm.dd")#</strong> o godzinie <strong>#TimeFormat(stepstatusdateend, "HH:mm")#</strong> 
							na <strong>#stepstatusname#</strong> przez: <strong>#givenname# #sn#</strong></div>
						</cfif> 
						<div class="steplabel">z komentarzem: #comment#</div>
					</cfif>
				</div>
				
			</cfloop>
			
		</div>
		
	</div>
</cfoutput>

<!---<cfdump var="#steps#" />--->

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
				$(this).text(value + ' cm');
		});
		
		$(".price").each(function(index){
			var value = $(this).text();
			if(value != '')
				$(this).text(value + ' zł');
		});
		
		$(".percent").each(function(index){
			var value = $(this).text();
			if(value != '')
				$(this).text(value + ' %');
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
					
					//$.post(<cfoutput>"#URLFor(action='step')#"</cfoutput>, { indexid: $("#productid").val(), stepid: $("#stepid").val(), stepcomment: $("#stepcomment").val() } );
					
					$("#step-form").submit();
					
					//console.log($("#step-form"));
					
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
				
				$("#stepid").val(2);
				$("#stepname").text("Przeniesienie do archiwum");
				$("#step-form").submit();
			
			}
			else
			if ($(this).hasClass("dh_accept")) {
				document.location = <cfoutput>"#URLFor(action='prepare')#"</cfoutput> + "&key=" + $('#indexid').val();
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
					
					//console.log($("#productDialogBox").find("input.category"));
					//$("#productDialogBox").find("input.category").closest(".label").remove();
					//$("#productDialogBox").find("input.date").closest(".label").remove();	
					$(".destination").parent().remove();
					$(".date").parent().remove();
							
				}
				else 
				if ($(this).hasClass("_accept")) {
							
					$("#stepid").val(2);
					$("#stepname").text("Akceptacja");
					
					$("#productDialogBox").find("input.category").closest(".label").show();
					$("#productDialogBox").find("input.date").closest(".label").show();
								
				}
				else 
				if ($(this).hasClass("_reject")) {
					$("#stepid").val(3);
					$("#stepname").text("Brak akceptacji");
					
					$("#productDialogBox").find("input.category").closest(".label").hide();
					$("#productDialogBox").find("input.date").closest(".label").hide();	
				}
				else
				if ($(this).hasClass("dh_discard")) {
					$("#stepid").val(3);
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
			url		: "<cfoutput>#URLFor(action='step')#</cfoutput>",
			success: function (responseText, statusText, xhr, $form){
				document.location=<cfoutput>"#URLFor(action='view')#"</cfoutput> + "&key=" + <cfoutput>"#index.id#"</cfoutput>;
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
							url			: <cfoutput>"#URLFor(action='planogram-categories')#"</cfoutput> + "&search=" + request.term,
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
		
		$(".product-image").find("a").fancybox({openEffect:'none',closeEffect:'none'});
		
		$(".products").on("click", ".navigate", function(){
			var $this = $(this);
			var source = $this.data("source");
			
			var url =  $this.attr("href");
			
			$("#flashMessages").show();
			
			$("#flashMessages").hide();
			$("#"+source).dialog("open");
			
			/*$.get(
				url,
				function(data){
					//$("#"+source).html(data);
					$("#flashMessages").hide();
					$("#"+source).dialog("open");
				}
			);*/
			
			return false;
		});
		
		$("#product-update-form").dialog({
			autoOpen: false,
			height: 700,
			width: 800,
			modal: true,
			buttons: {
				"Wyślij": function() {
					$("#product-form").submit();
					$(this).dialog("close");
				}
			},
			Cancel: function() {
				$(this).dialog("close");
			}
		});
		
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
		
		$(".progressbar").progressbar({ value: 0 });
		
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
					$("<div>").addClass("productimg").append(
						$("<a>").prop("href", "files/products/images/" + responseText.sfilename).append(
							$("<img>").prop("src","files/products/images/" + responseText.thumbnail).prop("alt", responseText.cfilename)
						).fancybox({openEffect:'none',closeEffect:'none'})));
					
				$('.imageForm').children(".productimg").fadeIn("slow");
				$("#imageprogressbar").slideUp();
				$("#product-form").append(
					$("<input>").prop("type", "hidden").prop("name", "product[image]").val(responseText.sfilename));
			}
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
					$("<div>").addClass("productcard").append(
						$("<a>").prop("href","files/products/" + responseText.sfilename).append(
							$("<img>").prop("src","images/excel-icon.png").prop("alt","excel")
						).append("&nbsp;" + responseText.cfilename)));
				
				$("#productprogressbar").slideUp();
				
				$("#product-productcard").val(responseText.sfilename);
				
				$("#product-width").val(responseText.product_width);
				$("#product-height").val(responseText.product_height);
				$("#product-length").val(responseText.product_length);
			},
			error: function(jqXHR, text, error){
				clearInterval(timebox);
				$("#productprogressbar").progressbar( "option", "value", 0 );
				alert('Błąd arkusza. Prawdopodobnie karta produktu jest błędna.');
			}
		});
		
		$("#product-file-form").dialog({
			autoOpen: false,
			height: 500,
			width: 800,
			modal: true,
			buttons: {
				"Wyślij": function() {
					
					$.ajax({
						url		:<cfoutput>"#URLFor(action='update-file')#"</cfoutput>,
						type	: "post",
						dataType: "json",
						data	: { 
							productid: $("#product-file").find("#product-id").val(),
							productfile: $("#product-file").find("#product-productfile").val()
						},
						success	: function( data ) {
							
							var arr = data.productfile.split("."), ext = arr[arr.length-1];
							switch(ext){
								case 'xls': case 'xlsx': var ico = "excel-icon.png"; break;
								case 'doc': case 'docx': var ico = "file-word.png"; break;
								case 'pdf': var ico = "file-pdf.png"; break;
								default: var ico = "blank.png";
							}
							
							$("ol.productDetails").append(
								$("<li>")
									.append($("<label>").text("Plik z wyceną"))
									.append(
										$("<span>").append(
											$("<a>").prop("href","files/products/expo/"+data.productfile).append(
												$("<img>").prop("src","images/"+ico).prop("alt","file")).append("&nbsp;"+data.productfile))));
												
							//$("#product-file").find("#product-id").val('');
							//$("#product-file").find("#product-productfile").remove();
						},
						error: function(){
							$("#flashMessages").hide();
							alert("Błąd zapisu. Spróbuj ponownie później.");
						}
					});
					
					$(this).dialog("close");
				}
			},
			Cancel: function() {
				$(this).dialog("close");
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
				$('.fileForm').append(
					$("<div>").addClass("productfile").append(
						$("<a>").prop("href","files/products/expo/" + responseText.sfilename).append(
							$("<img>").prop("src","images/proposals.png").prop("alt","plik")
						).append("&nbsp;" + responseText.cfilename)));
					
				$('.fileForm').children(".productimg").fadeIn("slow");
				$("#fileprogressbar").slideUp();
				$("#product-file").append(
					$("<input>").prop("type", "hidden").prop("id", "product-productfile").prop("name", "product[productfile]").val(responseText.sfilename));
			}
		});
		
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
	});
	function progress(obj){time+=5;if(time<90){obj.progressbar("option","value",time);}else{obj.progressbar("option","value",false);clearInterval(timebox);}}
</script>