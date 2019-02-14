<cfcomponent 
	extends="Controller">

	<cffunction 
		name="init">
		
		<cfset super.init() />
		<!--- <cfset usesLayout(template="/layout",only="index") /> --->
	</cffunction>
	
	<cffunction 
		name="index">
		
		<!--- Ilość wierszy na stronie --->
		<cfset params.rows = 30 />
		
		<cfif not StructKeyexists(params, "pn")>
			<cfset params.pn = '' />
		</cfif>
		
		<cfif not StructKeyExists(params, "ps")>
			<cfset params.ps = 1 />
		<cfelseif params.ps eq ''>
			<cfset params.ps = 0 />
		</cfif>
		
		<cfif not StructKeyExists(params, "pt") or params.pt eq ''>
			<cfset params.pt = 0 />
		</cfif>
		
		<cfif not StructKeyExists(params, "pu") or params.pu eq ''>
			<cfset params.pu = 0 />
		</cfif>
		
		<cfif not StructKeyExists(params, "pc") or params.pc eq ''>
			<cfset params.pc = 0 />
		</cfif>
		
		<cfif not StructKeyExists(params, "page") or params.page eq ''>
			<cfset params.start = 0 />
			<cfset params.page = 0 />
		<cfelse>
			<cfset params.start = params.rows * params.page />
		</cfif>
		
		<cfif not StructKeyExists(params, "dfrom") or params.dfrom eq ''>
			<cfset params.dfrom = 0 />
		</cfif>
		
		<cfif not StructKeyExists(params, "dto") or params.dto eq ''>
			<cfset params.dto = 0 />
		</cfif>
		
		<!--- Zapytanie główne --->
		<cfset products = model('Product_index').findAllIndex(
			pn	 = params.pn,
			ps	 = params.ps,
			pt	 = params.pt,
			pu	 = params.pu,
			pc	 = params.pc,
			dfrom = params.dfrom,
			dto = params.dto,
			start = params.start,
			rows	= params.rows
		)/>
		
		<!--- Ilość wszystkich wyników zapytania wg kryteriów --->
		<cfset query_count = model('Product_index').findAllIndexCount(
			pn 	= params.pn,
			ps 	= params.ps,
			pt 	= params.pt,
			pu	= params.pu,
			pc	 = params.pc,
			dfrom = params.dfrom,
			dto = params.dto
		)/>
		
		<cfset count = query_count.RecordCount />
		
		<!--- Ilość stron ---> 
		<cfset pages = Ceiling(count/params.rows) />
		
		<!--- Imiona i nazwiska użytkowników którzy dodawali indeksy --->
			
		<cfset users = model('Product_index').listUsers() />
		<!---<cfset users = model('Product_index').findAll(
			select="userid as id, concat(givenname, ' ', sn) as username",
			include="Product_step(User)",
			where="product_steps.step=1",
			group="userid"
		)/>--->
		
		<cfset categories = model('Product_index').findAllCategories() />
		<cfset statuses = model('Product_stepnames').findAll(where="version=1") />
		
		<cfset productType = QueryNew("id, name", "Integer, VarChar") /> 
		<cfset QueryAddRow(productType, 5) />
		<cfset QuerySetCell(productType, "id", 1, 1) />
		<cfset QuerySetCell(productType, "name", "Propozycja nowego produktu", 1) />
		<cfset QuerySetCell(productType, "id", 2, 2) />
		<cfset QuerySetCell(productType, "name", "Propozycja produktu z zamian za inny", 2) />
		<cfset QuerySetCell(productType, "id", 3, 3) />
		<cfset QuerySetCell(productType, "name", "Odblokowanie produktu", 3) />
		<cfset QuerySetCell(productType, "id", 4, 4) />
		<cfset QuerySetCell(productType, "name", "Wycofanie produktu w zamian za inny", 4) />
		<cfset QuerySetCell(productType, "id", 5, 5) />
		<cfset QuerySetCell(productType, "name", "Propozycja produktu od DM", 5) />
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_arch" >
			<cfinvokeargument name="groupname" value="Archiwizowanie indeksów" />
		</cfinvoke>
		
		<cfset queryresult = QueryNew(
			"Lp, Nazwa_produktu, Kod_kreskowy, Producent, Typ, Uzytkownik, Data, Status, Kategoria", 
			"Integer, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar") /> 
		
		<cfset qcount = 0 />
		<cfloop query="query_count">
			<cfset QueryAddRow(queryresult, 1) />
			
			<cfset qcount++ />
			
			<cfset QuerySetCell(queryresult, "Lp", qcount) />
			
			<cfif type eq 1 or type eq 2 or type eq 5>
				<cfset QuerySetCell(queryresult, "Nazwa_produktu", productname) />
			<cfelse>
				<cfset QuerySetCell(queryresult, "Nazwa_produktu", productid) />
			</cfif>
			
			<cfset product = model("Product").findByKey(productid) />
			<cfif IsObject(product)>
				<cfset QuerySetCell(queryresult, "Kod_kreskowy", product.barcode) />
				
				<cfset QuerySetCell(queryresult, "Producent", product.producer) />
			<cfelse>
				<cfset QuerySetCell(queryresult, "Kod_kreskowy", '--') />
				
				<cfset QuerySetCell(queryresult, "Producent", '--') />
			</cfif>
			
			<cfset QuerySetCell(queryresult, "Typ", productType.name[type]) />
			
			<cfset QuerySetCell(queryresult, "Uzytkownik", username) />
			
			<cfset QuerySetCell(queryresult, "Data", DateFormat(acceptdate, "yyyy-mm-dd")) />
			
			<cfset QuerySetCell(queryresult, "Status", step) />
			
			<cfset QuerySetCell(queryresult, "Kategoria", category) />
			
		</cfloop>
		
		<cfif StructKeyExists(params, "view") and params.view eq 'xls'>
			
			<cfset renderWith(data=queryresult, template="xls", layout=false) />
			
		<cfelseif IsAjax()>
			
			<cfset renderPartial("index") />
			
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="searchCategory">
		
		<cfset category = model("Index").getCategoryTree(params.qstr) />
		
		<cfset json = QueryToStruct(Query=category) />
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction 
		name="view">
		
		<!---<cftry>--->
			<cfif StructKeyExists(params, "key")>
				
				<cfset index = model("Product_index").findOne(where="id=#params.key#", include="Category") />
				
				<cfif index.type eq 1 or index.type eq 2 or index.type eq 5>
					
					<cfset product = model("Product").findOne(where="id=#index.productid#") >
					<cfset images = model('Product_image').findAll(where="productid=#index.productid#")>
					
				</cfif>
				
				<cfset steps = model("Product_step").findAll(where="indexid=#params.key#", order="date DESC", include="User,Product_stepname") />
				
			</cfif>
			
			<!---<cfcatch type="any">
				
				<cfset flashInsert(error = cfcatch.message) />
				
			</cfcatch>
		</cftry>--->
		
	</cffunction>
	
	<cffunction 
		name="new"
		hint="Formularz dodający nowy produkt">
		
		<!---<cfif IsAjax() and StructKeyExists(params, "form") and params.form neq ''>
			
			<!--- <cfset prod = model('Product').new() /> --->
			
			<cfset renderPartial(params.form) />
			
		</cfif>--->
		
		<cfset redirectTo(action="index") />
	</cffunction>
	
	<cffunction 
		name="prepare"
		hint="Formularz akceptacji nowego produktu od Dep. Marketingu">
	
		<cfif StructKeyExists(params, "key") >
			
			<cfset index = model("Product_index").findByKey(params.key) />
			
			<cfif index.type eq 5>
					
				<cfset product = model("Product").findByKey(index.productid) />
				<cfset images = model('Product_image').findAll(where="productid=#index.productid#") />
					
			</cfif>
			
		</cfif>
		
		<cfset productType = QueryNew("id, name", "Integer, VarChar") /> 
		<cfset QueryAddRow(productType, 2) />
		<cfset QuerySetCell(productType, "id", 1, 1) />
		<cfset QuerySetCell(productType, "name", "Propozycja nowego produktu", 1) />
		<cfset QuerySetCell(productType, "id", 2, 2) />
		<cfset QuerySetCell(productType, "name", "Propozycja produktu z zamian za inny", 2) />

	</cffunction>
	
	<cffunction 
		name="update"
		hint="Metoda aktualizuje nowo dodany produkt przez DM oraz przekazuje go do standardowego obiegu">
		
		<!---<cftry>--->
			
			<cfif StructKeyExists(params, "product") and StructKeyExists(params, "index")>
				
				<cfset idx = model("Product_index").findByKey(params.index.id) />
				<cfset idx.update(
					type = params.index.type,
					step = 1,
					productreplace = params.index.replaced
				)/>
				
				<cfset product = model("Product").findByKey(params.product.id) />
				<cfset product.update(
					name		= params.product.name,
					barcode		= params.product.barcode,
					category	= params.product.category,
					producer	= params.product.producer,
					height		= params.product.height,
					width		= params.product.width,
					length		= params.product.length,
					netto		= params.product.netto,
					brutto		= params.product.brutto,
					printed_price = params.product.printed_price,
					new			= params.product.new,
					alt			= params.product.alt,
					comment		= params.product.comment,
					productcard	= params.product.productcard 
				) />
				
				<cfif StructKeyExists(params.product, "image") >
					<cfset images = listToArray(params.product.image) >
							
					<cfif IsArray(images)>
						<cfloop index="i" from="1" to="#ArrayLen(images)#">
									
							<cfset img = model('Product_image').create(
								file		= images[i],
								productid	= params.product.id
							)/>
											
						</cfloop>
					</cfif>
				</cfif>
				
				<cfset step = model('Product_step').create(
					step	= 1,
					date	= Now(),
					userid	= session.user.id,
					indexid	= params.index.id,
					comment = params.status.comment
				)/>
				
				<cfif idx.hasErrors() or product.hasErrors()>
					<cfset renderPage(action="index") />
				<cfelse>					
					<cfset flashInsert(success="Zaktualizowano indeks.") />
				</cfif>
				
			</cfif>
			
			<!---<cfcatch type="any">
					
				<cfset flashInsert(error = 'Próba zmiany indeksu zakończyła się niepowodzeniem.') />
				<!--- <cfset flashInsert(error = cfcatch.message) /> --->
					
				<cfmail
					to="webmaster@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					replyto="intranet@monkey.xyz"
					subject="#cfcatch.message#"
					type="html">
	
					<cfdump var="#cfcatch#" />
					<cfdump var="#session#" />
					<cfif isDefined("Request")>
						<cfdump var="#Request#" />
					</cfif>
				</cfmail>
					
			</cfcatch>
		</cftry>--->
		
		<cfset redirectTo(action="index") />
	</cffunction>
	
	<cffunction 
		name="actionNew"
		hint="Zapisanie nowego indeksu" 
		description="Metoda zapisuje nowy produkt i jego zdjęcia w bazie">
		
		<!---<cftry>--->
			
			<cfif StructKeyExists(params, "index") >
			
				<!---<cfset _product = model('Product') />--->
				<cfset index = model('Product_index') />
				
				<cfset var step = 1 />
				
				<cfswitch expression="#params.index#">
					
					<!--- Dodanie propozycji noweg produktu przez DM --->
					<cfcase value="proposal">
						<cfif StructKeyExists(params, "product") >
							
							<!---<cfset _product = model('Product').new() />
							<cfset _product.name	 = params.product.name />
							<cfset _product.barcode  = params.product.barcode />
							<cfset _product.category = params.product.category />
							<cfset _product.producer = params.product.producer />
							<cfset result = _product.save(reload=true) />--->
							
							<cfset _product = model('Product').insert2(
								name = params.product.name,
								barcode = params.product.barcode,
								category = params.product.category,
								producer = params.product.producer,
								comment = params.product.comment
							) />
							
							<!---<cfset result = _product.save(reload=true) />--->
							
							<!---<cfif result is true>--->
							
								<cfif StructKeyExists(params.product, "image") >
									<cfset images = listToArray(params.product.image) >
									
									<cfif IsArray(images)>
										<cfloop index="i" from="1" to="#ArrayLen(images)#">
											
											<cfset img = model('Product_image').create(
												file		= images[i],
												productid	= _product.generatedkey
											)/>
											
										</cfloop>
									</cfif>
								</cfif>
								
								<cfset index = model('Product_index').new() />
								<cfset index.type = 5 />
								<cfset index.step = 7 />
								<cfset index.createddate = Now() />
								<cfset index.userid = session.user.id />
								<cfset index.productid = _product.generatedkey />
								<cfset index.save(reload=true) />
							
							</cfif>
							
						<!---</cfif>--->
						
						<cfset step = 7 />
					</cfcase>
					
					<!--- Dodanie noweg produktu --->
					<cfcase value="new">
						<cfif StructKeyExists(params, "product") >
							
							<cfset _product = model('Product').new() />
							<cfscript>
								_product.name 		= params.product.name;
								_product.barcode 	= params.product.barcode;
								_product.category	= params.product.category;
								_product.producer	= params.product.producer;
								_product.height		= params.product.height;
								_product.width		= params.product.width;
								_product.length		= params.product.length;
								_product.brutto		= params.product.brutto;
								_product.netto		= params.product.netto;
								_product.comment		= params.product.comment;
								_product.productcard 	= params.product.productcard;
								_product.printed_price 	= params.product.printed_price;
								_product.new 		= params.product.new;
								_product.alt 		= params.product.alt;
							</cfscript>
							
							<cfif StructKeyExists(params.product, "dateincheckbox")>
								<cfset _product.datein 		= params.product.datein />
							</cfif>
							
							<cfif StructKeyExists(params.product, "dateoutcheckbox")>
								<cfset _product.dateout 		= params.product.dateout />
							</cfif>
							
							<cfset _product.save(reload=true) />
							
							<cfif StructKeyExists(params.product, "image") >
								<cfset images = listToArray(params.product.image) >
								
								<cfif IsArray(images)>
									<cfloop index="i" from="1" to="#ArrayLen(images)#">
										
										<cfset img = model('Product_image').create(
											file		= images[i],
											productid	= _product.id
										)/>
										
									</cfloop>
								</cfif>
							</cfif>
							
							<cfset index = model('Product_index').new() />
							<cfset index.type = 1 />
							<cfset index.createddate = Now() />
							<cfset index.userid = session.user.id />
							<cfset index.productid = _product.id />
							<cfset index.save(reload=true) />
							
						</cfif>
						
					</cfcase>
					
					<!--- Dodanie nowego produktu w zamian za inny --->
					<cfcase value="replace">
						<cfif StructKeyExists(params, "product") >
							
							<cfset _product = model('Product').new() />
							<cfscript>
								_product.name 		= params.product.name;
								_product.barcode 	= params.product.barcode;
								_product.category	= params.product.category;
								_product.producer	= params.product.producer;
								_product.height		= params.product.height;
								_product.width		= params.product.width;
								_product.length		= params.product.length;
								_product.brutto		= params.product.brutto;
								_product.netto		= params.product.netto;
								_product.comment	= params.product.comment;
								_product.productcard= params.product.productcard;
								_product.printed_price = params.product.printed_price;
								_product.new 		= params.product.new;
								_product.alt 		= params.product.alt;
							</cfscript>
							
							<cfif StructKeyExists(params.product, "dateincheckbox")>
								<cfset _product.datein 		= params.product.datein />
							</cfif>
							
							<cfif StructKeyExists(params.product, "dateoutcheckbox")>
								<cfset _product.dateout 		= params.product.dateout />
							</cfif>
							
							<cfset _product.save(reload=true) />
							
							<cfif StructKeyExists(params.product, "image") >
								<cfset images = listToArray(params.product.image) >
								
								<cfif IsArray(images)>
									<cfloop index="i" from="1" to="#ArrayLen(images)#">
										
										<cfset img = model('Product_image').create(
											file		= images[i],
											productid	= _product.id
										)/>
										
									</cfloop>
								</cfif>
							</cfif>
							
							<cfset index = model('Product_index').new() />
							<cfset index.type = 2 />
							<cfset index.productid = _product.id />
							<cfset index.createddate = Now() />
							<cfset index.userid = session.user.id />
							<cfset index.productreplace = params.product.replaced />
							<cfset index.save(reload=true) />
							
						</cfif>
					</cfcase>
					
					<!--- Odblokowanie produktu --->
					<cfcase value="unlock">
						<cfif StructKeyExists(params, "product") >
							
							<cfset index = model('Product_index').new() />
							<cfset index.type = 3 />
							<cfset index.createddate = Now() />
							<cfset index.userid = session.user.id />
							<cfset index.productid = params.product.id />
							<cfset index.save(reload=true) />
							
						</cfif>
					</cfcase>
					
					<!--- Odblokowanie produktu w zamian za inny --->
					<cfcase value="renew">
						<cfif StructKeyExists(params, "product") >
							
							<cfset index = model('Product_index').new() />
							<cfset index.type = 4 />
							<cfset index.createddate = Now() />
							<cfset index.userid = session.user.id />
							<cfset index.productid = params.product.unlock />
							<cfset index.productreplace = params.product.lock />
							<cfset index.save(reload=true) />
							
						</cfif>
					</cfcase>
					
				</cfswitch>
				
				<cfif StructKeyExists(index, "id")>
					<cfset step = model('Product_step').create(
						step		= step,
						date		= Now(),
						userid	= session.user.id,
						indexid	= index.id
					)/>
					
					<cfif index.hasErrors()>
						<cfset renderPage(action="index") />
					<cfelse>
					
						<cfset flashInsert(success="Dodano nowy indeks.") />
					
					</cfif>
				</cfif>
				
			</cfif>
			
			<!---<cfcatch type="any">
				
				<cfset flashInsert(error = 'Próba dodania indeksu zakończyła się niepowodzeniem.') />
				<!--- <cfset flashInsert(error = cfcatch.message) /> --->
				
				<cfmail
					to="webmaster@monkey.xyz"
					from="BŁĄD - Monkey<intranet@monkey.xyz>"
					replyto="intranet@monkey.xyz"
					subject="#cfcatch.message#"
					type="html">

					<cfdump var="#cfcatch#" />
					<cfdump var="#session#" />
					<cfif isDefined("Request")>
						<cfdump var="#Request#" />
					</cfif>

				</cfmail>
				
			</cfcatch>
		</cftry>--->
		
		<!--- <cfset renderWith(data=params, controller="Products", action="index") /> --->
		<cfset redirectTo(action="index") />
	</cffunction>
	
	<cffunction 
		name="uploadXls"
		hint="Zapisywanie i przetwarzanie karty produktu na serwerze" 
		description="Metoda zapisuje plik *.xls na serwerze, a następnie odczytuje z niego konkretne dane">
		
		<!--- 
			Metoda zapisuje plik *.xls na serwerze, a następnie wyszukuje z niego dane z arkusza DEF
			
			@param	file strField	Plik *.xls zawierający kartę produktów
			
			@access	public
			@author	Tomasz Dopierała
			@date	2013-06-20
		--->
		
		<cftry>
        	<cfparam 
				name="strField" 
				default="filedata"/>
			
			<cfif (StructKeyExists(FORM, strField) AND Len(FORM[strField]))>
				
				<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="products") />
				<cfset myfile = APPLICATION.cfc.upload.upload(file_field="filedata") />
				<cfset myfile.binarycontent = false />
				
				<cfscript> 
					response = StructNew();
					StructInsert(response, "cfilename", myfile.clientfilename & "." & myfile.clientfileext); 
					StructInsert(response, "sfilename", myfile.newservername);
					StructInsert(response, "fileext", myfile.clientfileext);
				</cfscript>
				
				<cfset result='' />
				<cfset pathToXls = ExpandPath("./files/products/" & myfile.newservername) />
				<cfif FileExists(pathToXls)>
					<cfspreadsheet 
						action	= "read"
						src		= "#pathToXls#"
						query	= result
						sheetname	= "DEF" />
					
					<cfloop query="result">
						
						<cfswitch expression="#col_1#">
							
							<cfcase value="Opikar">
								<cfset StructInsert(response, "product_name", col_2) />
							</cfcase>
							
							<cfcase value="ProducentNazwa">
								<cfset StructInsert(response, "product_producer", col_2) />
							</cfcase>
							
							<cfcase value="WJMPoddl">
								<cfset StructInsert(response, "product_length", col_2) />
							</cfcase>
							
							<cfcase value="WJMPodszer">
								<cfset StructInsert(response, "product_width", col_2) />
							</cfcase>
							
							<cfcase value="WJMPodwys">
								<cfset StructInsert(response, "product_height", col_2) />
							</cfcase>
							
							<cfcase value="EANszt">
								<cfset StructInsert(response, "product_barcode", col_2) />
							</cfcase>
							
							<cfcase value="StawkaVat0">
								<cfset StructInsert(response, "product_0", col_2) />
								<cfif trim(col_2) neq 0>
									<cfset vat = 0 />
									<cfif not StructKeyExists(response, "product_vat")>
										<cfset StructInsert(response, "product_vat", 0) />
									</cfif>
								</cfif>
							</cfcase>
							
							<cfcase value="StawkaVat5">
								<cfset StructInsert(response, "product_5", col_2) />
								<cfif trim(col_2) neq 0>
									<cfset vat = 0.05 />
									<cfif not StructKeyExists(response, "product_vat")>
										<cfset StructInsert(response, "product_vat", 0.05) />
									</cfif>
								</cfif>
							</cfcase>
							
							<cfcase value="StawkaVat8">
								<cfset StructInsert(response, "product_8", col_2) />
								<cfif trim(col_2) neq 0>
									<cfset vat = 0.08 />
									<cfif not StructKeyExists(response, "product_vat")>
										<cfset StructInsert(response, "product_vat", 0.08) />
									</cfif>
								</cfif>
							</cfcase>
							
							<cfcase value="StawkaVat23">
								<cfset StructInsert(response, "product_23", col_2) />
								<cfif trim(col_2) neq 0>
									<cfset vat = 0.23 />
									<cfif not StructKeyExists(response, "product_vat")>
										<cfset StructInsert(response, "product_vat", 0.23) />
									</cfif>
								</cfif>
							</cfcase>
							
							<cfcase value="CenaZak100">
								<cfset StructInsert(response, "product_pricenetto", col_2) />
							</cfcase>
							
						</cfswitch>
	
					</cfloop>
				</cfif>
			</cfif>
			
			<cfset renderPartial('upload') />
			
	        <cfcatch type="Any" >
				
				<!---<cfif find("DEF", cfcatch.message)>
					<cfset json = { error = "Błąd w karcie produktu. Nie można odczytać danych z powodu braku arkusza DEF." } />
					
					<cfset renderWith(data="json",template="/json",layout=false) />
					
				<cfelse>--->
					<cfset json = { error = "Błędna karta produktu." } />
					
					<cfthrow 
						detail="#cfcatch.detail#" 
						message="#cfcatch.message#" 
						errorCode="#cfcatch.ErrorCode#" 
						type="#cfcatch.type#" 
						extendedinfo="#cfcatch.ExtendedInfo#" />
				<!---</cfif>--->
				
	        </cfcatch>
        
        </cftry>

	</cffunction>
	
	<cffunction 
		name="uploadImage" 
		hint="Zapisywanie zdjęć produktów" 
		description="Zapisywanie zdjęcia produktu oraz miniaturki na serwerze w katalogu files/products/images">
		
		<!--- 
			Zapisywanie zdjęcia produktu oraz miniaturki na serwerze w katalogu files/products/images
			
			@param	file strField	Plik *.jpg lub *.png zawierający zdjęcie produktu
			
			@access	public
			@author	Tomasz Dopierała
			@date	2013-06-20
		--->
		
		<cfparam 
			name="strField" 
			default="imagedata"/>
		
		<cfif (StructKeyExists(FORM, strField) AND Len(FORM[strField]))>
			
			<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="products/images") />
			<cfset myfile = APPLICATION.cfc.upload.upload(file_field="imagedata") />
			<cfset myfile.binarycontent = false />
			
			<cfscript> 
				response = StructNew();
				StructInsert(response, "cfilename", myfile.clientfilename & "." & myfile.clientfileext); 
				StructInsert(response, "sfilename", myfile.newservername);
				StructInsert(response, "thumbnail", myfile.thumbfilename);
				StructInsert(response, "fileext", myfile.clientfileext);
			</cfscript>
		</cfif>
		
		<cfset renderPartial('upload') />
	</cffunction>
	
	<cffunction 
		name="newstep">
		
			<cfif StructKeyExists(params, "indexid")>
				
				<!---<cfset index = model("Product_index").findOne(where="id=#params.indexid#")>--->
				
				<cfset set = "step = #params.stepid#" />
				<!---<cfset index.update(step = params.stepid) />--->
				
				<cfif StructKeyExists(params, "indexmm")>
					<cfset set &= ",mm = #params.indexmm#" />
					<!---<cfset index.update(mm = params.indexmm) />--->
				</cfif>
				
				<cfif StructKeyExists(params, "indexms")>
					<cfset set &= ",ms = #params.indexms#" />
					<!---<cfset index.update(ms = params.indexms) />--->
				</cfif>
				
				<cfif StructKeyExists(params, "indexmp")>
					<cfset set &= ",mp = #params.indexmp#" />
					<!---<cfset index.update(mp = params.indexmp) />--->
				</cfif>
				
				<cfif StructKeyExists(params, "indexmpp")>
					<cfset set &= ",mpp = #params.indexmpp#" />
					<!---<cfset index.update(mpp = params.indexmpp) />--->
				</cfif>
				
				<cfif StructKeyExists(params, "indexcategoryid")  and params.indexcategoryid neq ''>
					<cfset set &= ",category = #params.indexcategoryid#" />
					<!---<cfset index.update(mpp = params.indexmpp) />--->
				</cfif>
				
				<cfif StructKeyExists(params, "indexdate") and params.indexdate neq ''>
					<cfset set &= ",date = ""#params.indexdate#""" />
					<!---<cfset index.update(date = params.indexdate) />--->
				</cfif>
				
						<!---<cfmail
							to="webmaster@monkey.xyz"
							from="SMS - Monkey<intranet@monkey.xyz>"
							subject="dump"
							type="html">
							
							<cfdump var="#index#" showUDFs="false" />
						
						</cfmail>--->
				
				<!---<cfset index.save() />--->
				<cfset index = model("Product_index").updateIndex(
					set	= set,
					where = params.indexid) />
				
				<cfset step = model("Product_step").create(
					step 	= params.stepid,
					date 	= Now(),
					userid 	= session.user.id,
					comment 	= params.stepcomment,
					indexid 	= params.indexid
				)>
				
			</cfif>
			
			<cfset renderNothing() />

	</cffunction>
	
	<cffunction 
		name="checkpriv">
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="marketing" >
			<cfinvokeargument name="groupname" value="Departament Marketingu" />
		</cfinvoke>
		
		<cfif marketing is true>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="index" >
				<cfinvokeargument name="groupname" value="Akceptacja nowych indeksów" />
			</cfinvoke>
			
			<cfif index is true>
				
				<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="manager" >
					<cfinvokeargument name="groupname" value="Dyrektorzy" />
				</cfinvoke>
				
				<cfif manager is true>
					<cfreturn 3 />
				<cfelse>
					<cfreturn 3 /> <!--- tymczsowo 3 zamiast 2 w celach przeprowadzania testów marketingu --->
				</cfif>
				
			<cfelse>
				<cfreturn 1 />
			</cfif>
			
		<cfelse>
			<cfreturn 0 />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="planogramCategories">
		
		<cfif StructKeyExists(params, "search")>
			
			<cfset categories = model("product_category").findAll(where="name LIKE '%#params.search#%'")>
			
			<cfset json = categories />
			<cfset renderWith(data="json",template="/json",layout=false) />
			
		<cfelse>			
			<cfset renderNothing() />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="images">
	
		<cfif IsAjax()>
			<cfif StructKeyExists(params, "q")>
				<cfset images = model("Product_image").findAll(where="ean LIKE '%#params.q#%'", maxRows=100) />
			
				<cfset json = images />
				<cfset renderWith(data="json",template="/json",layout=false) />
			<cfelse>
				<cfset renderNothing() />
			</cfif>			
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="clearImages">
		
		<cfset qImages = model("Product_image").findAll() />
		<cfset imgTab = ArrayNew(1) />
		<cfloop query="qImages">
			<cfset ArrayAppend(imgTab,file) />
		</cfloop>
		
		<!---<cfset filepath = ExpandPath('files/products/') & filename />--->
		<cfdirectory
			directory="#ExpandPath('files/products/images/')#" 
			action="list" 
			name="dImages">
			
		<!---<cfset imgTab = ArrayNew(1) />
		<cfloop query="dImages">
			<cfset ArrayAppend(imgTab,name) />
		</cfloop>--->
		
		<cfset images = ArrayNew(1) />
		<cfloop query="dImages">
			<cfif not ArrayContains(imgTab,name) and Left(name,6) neq "thumb_">
				<cfset ArrayAppend(images,name) />
				<cfif FileExists(ExpandPath('files/products/images/') & name)>
					<cffile action="delete" file="#ExpandPath('files/products/images/')##name#" >
				</cfif>
				<cfif FileExists(ExpandPath('files/products/images/') & 'thumb_' & name)>
					<cffile action="delete" file="#ExpandPath('files/products/images/')#thumb_#name#" >
				</cfif>
			</cfif>
		</cfloop>
		
		<cfset variable = images />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
	</cffunction>
	
	<cffunction 
		name="clearImages3">
		
		<cfdirectory
			directory="#ExpandPath('files/products/images/')#" 
			action="list" 
			name="dImages">
		
		<cfloop query="dImages">
			
			<cfset _name = ReplaceNoCase(name, "%", "", "all") /> />
			
			<cffile 
				action="rename" 
				source="#ExpandPath('files/products/images/')##name#" 
				destination="#ExpandPath('files/products/images/')##_name#">
				
			<!---<cffile 
				action="rename" 
				source="#ExpandPath('files/products/images/')#thumb_#name#" 
				destination="#ExpandPath('files/products/images/')#thumb_#_name#">--->
			
		</cfloop>
		
		<cfset variable = dImages />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
	</cffunction>
	
	<cffunction 
		name="clearCards">
		
		<cfset qCards = model("Product").findAll() />
		<cfset imgTab = ArrayNew(1) />
		<cfloop query="qCards">
			<cfset ArrayAppend(imgTab,productcard) />
		</cfloop>
		
		<!---<cfset filepath = ExpandPath('files/products/') & filename />--->
		<cfdirectory
			directory="#ExpandPath('files/products/')#" 
			action="list" 
			name="dImages">
			
		<!---<cfset imgTab = ArrayNew(1) />
		<cfloop query="dImages">
			<cfset ArrayAppend(imgTab,name) />
		</cfloop>--->
		
		<cfset images = ArrayNew(1) />
		<cfloop query="dImages">
			<cfif not ArrayContains(imgTab,name) and (Right(name,4) eq '.xls' or Right(name,4) eq 'xlsx')>
				<cfset ArrayAppend(images,name) />
				<cfif FileExists(ExpandPath('files/products/') & name)>
					<cffile action="delete" file="#ExpandPath('files/products/')##name#" >
				</cfif>
				<!---<cfif FileExists(ExpandPath('files/products/images/') & 'thumb_' & name)>
					<cffile action="delete" file="#ExpandPath('files/products/images/')#thumb_#name#" >
				</cfif>--->
			</cfif>
		</cfloop>
		
		<cfset variable = images />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
	</cffunction>
</cfcomponent>