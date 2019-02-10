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
		<cfset params.rows = 20 />
		
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
			rows	= params.rows,
			version = 2
		)/>
		
		<!--- Ilość wszystkich wyników zapytania wg kryteriów --->
		<cfset query_count = model('Product_index').findAllIndexCount(
			pn 	= params.pn,
			ps 	= params.ps,
			pt 	= params.pt,
			pu	= params.pu,
			pc	 = params.pc,
			dfrom = params.dfrom,
			dto = params.dto,
			version = 2
		)/>
		
		<cfset count = query_count.RecordCount />
		
		<!--- Ilość stron --->
		<cfset pages = Ceiling(count/params.rows) />
		
		<!--- Imiona i nazwiska użytkowników którzy dodawali indeksy --->
			
		<cfset users = model('Product_index').listUsers(version=2) />
		
		<cfset categories = model('Product_index').findAllCategories() />
		<cfset statuses = model('Product_stepnames').findAll(where="version=2") />
		
		<cfset productType = model("Product_type").findAll(where="version2=1") /> 
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_arch" >
			<cfinvokeargument name="groupname" value="Archiwizowanie indeksów" />
		</cfinvoke>
		
		<cfif StructKeyExists(params, "view") and params.view eq 'xls'>
			
			<cfset queryresult = QueryNew(
				"Lp, Nazwa_produktu, Kod_kreskowy, Producent, Typ, Uzytkownik, Data, Status, Kategoria", 
				"Integer, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar") /> 
			
			<cfset qcount = 0 />
			<cfloop query="query_count">
				<cfset QueryAddRow(queryresult, 1) />
				
				<cfset qcount++ />
				
				<cfset QuerySetCell(queryresult, "Lp", qcount) />
				
				<cfif ListContains("1,2,5,6,7", type)>
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
				
				<cfset QuerySetCell(queryresult, "Typ", productType["producttypename"][type]) />
				
				<cfset QuerySetCell(queryresult, "Uzytkownik", username) />
				
				<cfset QuerySetCell(queryresult, "Data", DateFormat(acceptdate, "yyyy-mm-dd")) />
				
				<cfset QuerySetCell(queryresult, "Status", step) />
				
				<cfset QuerySetCell(queryresult, "Kategoria", category) />
				
			</cfloop>
			
			<cfset renderWith(data=queryresult, template="xls", layout=false) />
			
		<cfelseif IsAjax()>
			
			<cfset renderPartial("index") />
			
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="view">
		
		<cfif StructKeyExists(params, "key")>
				
			<cfset index = model("Product_index").findIndex(key=params.key) />
				
			<cfif ListContains("1,2,3,4,5,6,7", index.type)>
				<cfset product = model("Product").findOne(where="id=#index.productid#") >
				<cfset images = model('Product_image').findAll(where="productid=#index.productid# AND cat=1")>
			</cfif>
				
			<cfset steps = model("Product_step").findSteps(indexid=params.key) />
			
			<cfif index.version eq 1>
				<cfset struct = { index = index, steps = steps } />
				<cfset variable = struct />
				
				<cfset renderWith(data=struct, template="_viewold") />
				<!---<cfset renderWith(data="variable",template="/dump",layout=false) />--->
			</cfif>
			<!---<cfset variable = product />
			<cfset renderWith(data="variable",template="/dump",layout=false) />--->
			
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="add">
			
	</cffunction>
	
	<cffunction 
		name="actionAdd"
		hint="Zapisanie nowego indeksu" 
		description="Metoda zapisuje nowy produkt i jego zdjęcia w bazie">
			
			<cfif StructKeyExists(params, "index") >
			
				<cfset index = model('Product_index') />
				
				<!---<cfset var step = 1 />--->
				
				<cfswitch expression="#params.index#">
					
					<!--- Dodanie noweg produktu --->
					<cfcase value="new">
						<cfif StructKeyExists(params, "product") >
							
							<!---<cfset _product = model('Product').new() />--->
							<cfset _product = {} />
							
							<cfset _product.name 		= params.product.name />
							<cfset _product.barcode 	= params.product.barcode />
							<cfset _product.category	= params.product.category />
							<cfset _product.producer	= params.product.producer />
							<cfset _product.height		= params.product.height />
							<cfset _product.width		= params.product.width />
							<cfset _product.length		= params.product.length />
					 		<cfset _product.vat			= params.product.vat />
							<cfset _product.brutto		= params.product.brutto />
							<cfset _product.netto		= params.product.netto />
							<cfset _product.comment		= params.product.comment />
							
							<cfif StructKeyExists(params.product, "productcard")>
								<cfset _product.productcard = params.product.productcard />
							</cfif>
							
							<cfif StructKeyExists(params.product, "productfile")>
								<cfset _product.productfile = params.product.productfile />
							</cfif>
							
							<cfset _product.amount		= params.product.amount />
							<cfset _product.budget		= params.product.budget />
							<cfset _product.capacity	= params.product.capacity />
								
							<!--- _product.printed_price = params.product.printed_price --->
							<!--- _product.new = params.product.new --->
							<!--- _product.alt = params.product.alt --->
							
							<cfset _product.datein = params.product.datein />
							<cfset _product.dateout = params.product.dateout />
							
							<cfif params.product.indexoutid neq ''>
								<cfset _product.indexout = params.product.indexoutid />
							</cfif>
							
							<cfloop collection="#_product#" item="idx">
								<cfif StructFind(_product, idx) eq "">
									<cfset StructDelete(_product, idx) />
								<cfelse>
									<cfset StructUpdate(_product, idx, cf_escape_string(StructFind(_product, idx))) />
								</cfif>
							</cfloop>
							
							<cfset product = _product />
							<cfset product = model("Product").insert(params=_product) />
							
							<cfif StructKeyExists(params.product, "image") >
								<cfset images = listToArray(params.product.image)>
								
								<cfif IsArray(images)>
									<cfloop index="i" from="1" to="#ArrayLen(images)#">
										<cfset img = model('Product_image').create(file = images[i], productid = product.generatedkey)/>
									</cfloop>
								</cfif>
							</cfif>
							
							<cfset index = model('Product_index').new() />
							<cfset index.type = 1 />
							<cfset index.step = 8 />
							<cfset index.userid = session.user.id />
							<cfset index.createddate = Now() />
							<cfset index.version = 2 />
							<cfset index.productid = product.generatedkey />
							<cfset index.save(reload=true) />
							
						</cfif>
						
					</cfcase>
					
					<!--- Dodanie nowego produktu w zamian za inny --->
					<cfcase value="replace">
						<cfif StructKeyExists(params, "product") >
							
							<cfset _product = {} />
							
							<cfset _product.name 		= params.product.name />
							<cfset _product.barcode 	= params.product.barcode />
							<cfset _product.category	= params.product.category />
							<cfset _product.producer	= params.product.producer />
							<cfset _product.height		= params.product.height />
							<cfset _product.width		= params.product.width />
							<cfset _product.length		= params.product.length />
							<cfset _product.vat			= params.product.vat />
							<cfset _product.brutto		= params.product.brutto />
							<cfset _product.netto		= params.product.netto />
							<cfset _product.comment		= params.product.comment />
							
							<cfif StructKeyExists(params.product, "productcard")>
								<cfset _product.productcard = params.product.productcard />
							</cfif>
							
							<cfif StructKeyExists(params.product, "productfile")>
								<cfset _product.productfile = params.product.productfile />
							</cfif>
								
							<cfset _product.amount		= params.product.amount />
							<cfset _product.budget		= params.product.budget />
							<cfset _product.capacity	= params.product.capacity />
							
							<cfset _product.datein = params.product.datein />
							<cfset _product.dateout = params.product.dateout />
							
							<cfif params.product.indexoutid neq ''>
								<cfset _product.indexout = params.product.indexoutid />
							</cfif>
							
							<cfloop collection="#_product#" item="idx">
								<cfset StructUpdate(_product, idx, cf_escape_string(StructFind(_product, idx))) />
    						</cfloop>
							
							<cfset product = model("Product").insert(params=_product) />
							
							<cfif StructKeyExists(params.product, "image") >
								<cfset images = listToArray(params.product.image)>
								
								<cfif IsArray(images)>
									<cfloop index="i" from="1" to="#ArrayLen(images)#">
										<cfset img = model('Product_image').create(file = images[i], productid = product.generatedkey)/>
									</cfloop>
								</cfif>
							</cfif>
							
							<cfset index = model('Product_index').new() />
							<cfset index.type = 2 />
							<cfset index.step = 8 />
							<cfset index.userid = session.user.id />
							<cfset index.createddate = Now() />
							<cfset index.version = 2 />
							<cfset index.productid = product.generatedkey />
							<cfset index.productreplace = params.product.symkar />
							<cfset index.save(reload=true) />
							
						</cfif>
					</cfcase>
					
					<!--- Odblokowanie produktu --->
					<cfcase value="unlock">
						<cfif StructKeyExists(params, "product") >
							
							<cfset _product = {} />
							
							<cfset _product.name 		= params.product.name />
							<cfset _product.barcode 	= params.product.barcode />
							<cfset _product.innerindex 		= params.product.index />
							<cfset _product.category	= params.product.category />
							<cfset _product.producer	= params.product.producer />
							<cfset _product.height		= params.product.height />
							<cfset _product.width		= params.product.width />
							<cfset _product.length		= params.product.length />
							<cfset _product.vat			= params.product.vat />
							<cfset _product.brutto		= params.product.brutto />
							<cfset _product.netto		= params.product.netto />
							<cfset _product.comment		= params.product.comment />
							
							<cfif StructKeyExists(params.product, "productcard")>
								<cfset _product.productcard = params.product.productcard />
							</cfif>
							
							<cfif StructKeyExists(params.product, "productfile")>
								<cfset _product.productfile = params.product.productfile />
							</cfif>
								
							<cfset _product.amount		= params.product.amount />
							<cfset _product.budget		= params.product.budget />
							<cfset _product.capacity	= params.product.capacity />
							
							<cfset _product.datein = params.product.datein />
							<cfset _product.dateout = params.product.dateout />
							
							<cfif params.product.indexoutid neq ''>
								<cfset _product.indexout = params.product.indexoutid />
							</cfif>
							
							<cfloop collection="#_product#" item="idx">
								<cfset StructUpdate(_product, idx, cf_escape_string(StructFind(_product, idx))) />
    						</cfloop>
							
							<cfset product = model("Product").insert(params=_product) />
							
							<cfif StructKeyExists(params.product, "image") >
								<cfset images = listToArray(params.product.image)>
								
								<cfif IsArray(images)>
									<cfloop index="i" from="1" to="#ArrayLen(images)#">
										<cfset img = model('Product_image').create(file = images[i], productid = product.generatedkey)/>
									</cfloop>
								</cfif>
							</cfif>
							
							<cfset index = model('Product_index').new() />
							<cfset index.type = 3 />
							<cfset index.step = 8 />
							<cfset index.userid = session.user.id />
							<cfset index.createddate = Now() />
							<cfset index.version = 2 />
							<cfset index.productid = product.generatedkey />
							<cfset index.save(reload=true) />
							
						</cfif>
					</cfcase>
					
					<!--- Odblokowanie produktu w zamian za inny --->
					<cfcase value="renew">
						<cfif StructKeyExists(params, "product") >
							
							<cfset _product = {} />
							
							<cfset _product.name 		= params.product.name />
							<cfset _product.barcode 	= params.product.barcode />
							<cfset _product.innerindex 		= params.product.index />
							<cfset _product.category	= params.product.category />
							<cfset _product.producer	= params.product.producer />
							<cfset _product.height		= params.product.height />
							<cfset _product.width		= params.product.width />
							<cfset _product.length		= params.product.length />
							<cfset _product.vat			= params.product.vat />
							<cfset _product.brutto		= params.product.brutto />
							<cfset _product.netto		= params.product.netto />
							<cfset _product.comment		= params.product.comment />
							
							<cfif StructKeyExists(params.product, "productcard")>
								<cfset _product.productcard = params.product.productcard />
							</cfif>
							
							<cfif StructKeyExists(params.product, "productfile")>
								<cfset _product.productfile = params.product.productfile />
							</cfif>
								
							<cfset _product.amount		= params.product.amount />
							<cfset _product.budget		= params.product.budget />
							<cfset _product.capacity	= params.product.capacity />
							
							<cfset _product.datein = params.product.datein />
							<cfset _product.dateout = params.product.dateout />
							
							<cfif params.product.indexoutid neq ''>
								<cfset _product.indexout = params.product.indexoutid />
							</cfif>
							
							<cfloop collection="#_product#" item="idx">
								<cfset StructUpdate(_product, idx, cf_escape_string(StructFind(_product, idx))) />
							</cfloop>
							
							<cfset product = model("Product").insert(params=_product) />
							
							<cfif StructKeyExists(params.product, "image") >
								<cfset images = listToArray(params.product.image)>
								
								<cfif IsArray(images)>
									<cfloop index="i" from="1" to="#ArrayLen(images)#">
										<cfset img = model('Product_image').create(file = images[i], productid = product.generatedkey)/>
									</cfloop>
								</cfif>
							</cfif>
							
							<cfset index = model('Product_index').new() />
							<cfset index.type = 4 />
							<cfset index.step = 8 />
							<cfset index.userid = session.user.id />
							<cfset index.createddate = Now() />
							<cfset index.version = 2 />
							<cfset index.productid = product.generatedkey />
							<cfset index.productreplace = params.product.symkar />
							<cfset index.save(reload=true) />
							
						</cfif>
					</cfcase>
					
					<!--- KZ/OW wraca do sprzedaży --->
					<cfcase value="kzow">
						<cfif StructKeyExists(params, "product") >
							
							<cfset _product = {} />
							
							<cfset _product.name 		= params.product.name />
							<cfset _product.barcode 	= params.product.barcode />
							<cfset _product.category	= params.product.category />
							<cfset _product.producer	= params.product.producer />
							<cfset _product.height		= params.product.height />
							<cfset _product.width		= params.product.width />
							<cfset _product.length		= params.product.length />
							<cfset _product.vat			= params.product.vat />
							<cfset _product.brutto		= params.product.brutto />
							<cfset _product.netto	= params.product.netto />
							<cfset _product.comment		= params.product.comment />
							
							<cfif StructKeyExists(params.product, "productcard")>
								<cfset _product.productcard = params.product.productcard />
							</cfif>
							
							<cfif StructKeyExists(params.product, "productfile")>
								<cfset _product.productfile = params.product.productfile />
							</cfif>
								
							<cfset _product.amount		= params.product.amount />
							<cfset _product.budget		= params.product.budget />
							<cfset _product.capacity	= params.product.capacity />
							
							<cfset _product.datein = params.product.datein />
							<cfset _product.dateout = params.product.dateout />
							
							<cfif params.product.indexoutid neq ''>
								<cfset _product.indexout = params.product.indexoutid />
							</cfif>
							
							<cfloop collection="#_product#" item="idx">
								<cfset StructUpdate(_product, idx, cf_escape_string(StructFind(_product, idx))) />
    						</cfloop>
							
							<cfset product = model("Product").insert(params=_product) />
							
							<cfif StructKeyExists(params.product, "image") >
								<cfset images = listToArray(params.product.image)>
								
								<cfif IsArray(images)>
									<cfloop index="i" from="1" to="#ArrayLen(images)#">
										<cfset img = model('Product_image').create(file = images[i], productid = product.generatedkey)/>
									</cfloop>
								</cfif>
							</cfif>
							
							<cfset index = model('Product_index').new() />
							<cfset index.type = 6 />
							<cfset index.step = 8 />
							<cfset index.userid = session.user.id />
							<cfset index.createddate = Now() />
							<cfset index.version = 2 />
							<cfset index.productid = product.generatedkey />
							<cfset index.save(reload=true) />
							
						</cfif>
						
					</cfcase>
					
					<!--- Propozycja nowego produktu złożonego z indeksów eksploatacyjnych --->
					<cfcase value="explo">
						<cfif StructKeyExists(params, "product") >
							
							<cfset _product = {} />
							
							<cfset _product.name 		= params.product.name />
							<cfset _product.barcode 	= params.product.barcode />
							<cfset _product.category	= params.product.category />
							<cfset _product.producer	= params.product.producer />
							<cfset _product.height		= params.product.height />
							<cfset _product.width		= params.product.width />
							<cfset _product.length		= params.product.length />
							<cfset _product.vat			= params.product.vat />
							<cfset _product.csn			= params.product.csn />
							<cfset _product.csnvat		= params.product.csnvat />
							<cfset _product.comment		= params.product.comment />
							
							<cfif StructKeyExists(params.product, "productcard")>
								<cfset _product.productcard = params.product.productcard />
							</cfif>
							
							<cfif StructKeyExists(params.product, "productfile")>
								<cfset _product.productfile = params.product.productfile />
							</cfif>
							
							<cfset _product.amount		= params.product.amount />
							<cfset _product.budget		= params.product.budget />
							<cfset _product.capacity	= params.product.capacity />
							
							<cfset _product.datein = params.product.datein />
							<cfset _product.dateout = params.product.dateout />
							
							<cfif params.product.indexoutid neq ''>
								<cfset _product.indexout = params.product.indexoutid />
							</cfif>
							
							<cfloop collection="#_product#" item="idx">
								<cfset StructUpdate(_product, idx, cf_escape_string(StructFind(_product, idx))) />
							</cfloop>
							
							<cfset product = model("Product").insert(params=_product) />
							
							<cfif StructKeyExists(params.product, "image") >
								<cfset images = listToArray(params.product.image)>
								
								<cfif IsArray(images)>
									<cfloop index="i" from="1" to="#ArrayLen(images)#">
										<cfset img = model('Product_image').create(file = images[i], productid = product.generatedkey)/>
									</cfloop>
								</cfif>
							</cfif>
							
							<cfset index = model('Product_index').new() />
							<cfset index.type = 7 />
							<cfset index.step = 8 />
							<cfset index.userid = session.user.id />
							<cfset index.createddate = Now() />
							<cfset index.version = 2 />
							<cfset index.productid = product.generatedkey />
							<cfset index.save(reload=true) />
							
						</cfif>
						
					</cfcase>
					
					<!--- Dodanie propozycji noweg produktu przez DM --->
					<cfcase value="dm">
						<cfif StructKeyExists(params, "product") >
							
							<cfset _product = {} />
							
							<cfset _product.name 		= params.product.name />
							<cfset _product.barcode 	= params.product.barcode />
							<cfset _product.category	= params.product.category />
							<cfset _product.producer	= params.product.producer />
							
							<cfloop collection="#_product#" item="idx">
								<cfset StructUpdate(_product, idx, cf_escape_string(StructFind(_product, idx))) />
    						</cfloop>
							
							<cfset product = model('Product').insert(_product) />
								
							<cfset index = model('Product_index').new() />
							<cfset index.type = 5 />
							<cfset index.step = 7 />
							<cfset index.userid = session.user.id />
							<cfset index.createddate = Now() />
							<cfset index.version = 2 />
							<cfset index.productid = product.generatedkey />
							<cfset index.save(reload=true) />
							
						</cfif>
						<cfset step = 7 />
					</cfcase>
					
				</cfswitch>
				
				<cfif StructKeyExists(index, "id")>
					<!---<cfset step = model('Product_step').create(
						step	= step,
						date	= Now(),
						userid	= session.user.id,
						indexid	= index.id
					)/>--->
					
					<cfif index.hasErrors()>
						<cfset renderPage(action="index") />
					<cfelse>
					
						<cfset flashInsert(success="Dodano nowy indeks.") />
					
					</cfif>
				</cfif>
				
			</cfif>
			
		<cfset redirectTo(action="index") />
		<!---<cfset variable = product />
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->
	</cffunction>
	
	<cffunction 
		name="update">
			
		<cfif StructKeyExists(params, "product") >
			
				<cfset _product = {} />
				
				<cfset _product.id			= params.product.id />
				<cfset _product.height		= params.product.height />
				<cfset _product.width		= params.product.width />
				<cfset _product.length		= params.product.length />
				
				<cfif StructKeyExists(params.product, "productcard")>
					<cfset _product.productcard = params.product.productcard />
				</cfif>
				
				<cfset _product.amount		= params.product.amount />
				<cfset _product.budget		= params.product.budget />
				<cfset _product.capacity	= params.product.capacity />
				
				<cfset _product.netto	= params.product.netto />
				<cfset _product.vat		= params.product.vat />
				<cfset _product.brutto	= params.product.brutto />
				<cfset _product.comment	= params.product.comment />
				
				<cfset _product.datein = params.product.datein />
				<cfset _product.dateout = params.product.dateout />
							
				<cfif params.product.indexoutid neq ''>
					<cfset _product.indexout = params.product.indexoutid />
				</cfif>
				
				<cfloop collection="#_product#" item="idx">
					<cfset StructUpdate(_product, idx, cf_escape_string(StructFind(_product, idx))) />
				</cfloop>
				
				<cfset product = model("Product").update(params=_product, id=_product.id) />
							
				<cfif StructKeyExists(params.product, "image") >
					<cfset images = listToArray(params.product.image)>
								
					<cfif IsArray(images)>
						<cfloop index="i" from="1" to="#ArrayLen(images)#">
							<cfset img = model('Product_image').create(file = images[i], productid = _product.id)/>
						</cfloop>
					</cfif>
				</cfif>
		</cfif>
		
		<cfset redirectTo(action="view",key=params.indexid) />
		<!---<cfset variable = params />
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->
	</cffunction>
	
	<cffunction 
		name="step">
		
		<cfif StructKeyExists(FORM, "indexid")>
			<!---<cfif StructKeyExists(params, "indexcategoryid") and StructKeyExists(params, "indexdate")>--->
			
			<cfif StructKeyExists(params, "indexcategoryid") and StructKeyExists(params, "indexdate")
				and params.indexcategoryid neq '' and params.indexdate neq ''>
				
				<cfset step = model("Product_index").updateStep(
					indexid		= params.indexid,
					stepstatus	= params.stepid,
					indexcategoryid= params.indexcategoryid,
					indexdate	= params.indexdate, 
					comment		= params.stepcomment
				) />
				
			<cfelse>
				
				<cfset step = model("Product_index").updateStep(
					indexid		= params.indexid, 
					stepstatus	= params.stepid,
					comment		= params.stepcomment
				) />
			
			</cfif>
		</cfif>
		
		<!---<cfset renderNothing() />--->
		<cfset json = params />
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction 
		name="form"
		hint="Formularz dodający nowy produkt">
			
		<cfset product = {
			name="", barcode="", index="", category="", producer="", height="", width="", length="", netto="", csn="", 
			csnvat="", recvat="", brutto="", datein="", dateout="", indexout="", amount="", budget="", capacity="", comment=""} />
		
		<!---<cfif StructKeyExists(params, "key")>
			<cfset _product = model("Product").findByKey(key) />
			
			<cfif _product is not false>
				<cfset product.name = _product.name />
				<cfset product.barcode = _product.barcode />
				<cfset product.category = _product.category />
				<cfset product.producer = _product.producer />
				<cfset product.height = _product.height />
				<cfset product.width = _product.width />
				<cfset product.length = _product.length />
				<cfset product.netto = _product.netto />
				<cfset product.csn = _product.csn />
				<cfset product.csnvat = _product.csnvat />
				<cfset product.recvat = _product.recvat />
				<cfset product.brutto = _product.brutto />
				<cfset product.datein = _product.datein />
				<cfset product.dateout = _product.dateout />
				<cfset product.indexout = _product.indexout />
				<cfset product.amount = _product.amount />
				<cfset product.budget = _product.budget />
				<cfset product.capacity = _product.capacity />
				<cfset product.comment = _product.comment />
			</cfif>
		</cfif>--->
		
		<cfif IsAjax() and StructKeyExists(params, "form") and params.form neq ''>
			
			<cfset renderPartial(params.form) />
			
		<cfelse>
			
			<cfset renderNothing() />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="cardIndex">
		
		<!--- Ilość wierszy na stronie --->
		<cfset params.rows = 20 />
		
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
			rows	= params.rows,
			version = 2
		)/>
		
		<!--- Ilość wszystkich wyników zapytania wg kryteriów --->
		<cfset query_count = model('Product_index').findAllIndexCount(
			pn 	= params.pn,
			ps 	= params.ps,
			pt 	= params.pt,
			pu	= params.pu,
			pc	 = params.pc,
			dfrom = params.dfrom,
			dto = params.dto,
			version = 2
		)/>
		
		<cfset count = query_count.RecordCount />
		
		<!--- Ilość stron --->
		<cfset pages = Ceiling(count/params.rows) />
		
		<!--- Imiona i nazwiska użytkowników którzy dodawali indeksy --->
			
		<!---<cfset users = model('Product_index').listUsers(version=2) />--->
		
		<cfset categories = model('Product_index').findAllCategories() />
		<cfset statuses = model('Product_stepnames').findAll(where="version=2") />
		
		<cfset productType = model("Product_type").findAll(where="version2=1") /> 
		
		<cfif IsAjax()>
			
			<cfset renderPartial("cardindex") />
			
		</cfif>
		
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
						action="read"
						src="#pathToXls#"
						query=result
						sheetname="DEF" />
					
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
		name="updateFile" 
		hint="Dodanie pliku z wyceną">
		
		<cfif StructKeyExists(params, "productid")>
			
			<cfset product = model("Product").findByKey(params.productid) />
			
			<cfif IsObject(product)>			
				<cfset product.productfile=form.productfile />
				
				<cfset product.save() />
			</cfif>
			<cfset json = product />
		<cfelse>
			
			<cfset json = params />
		</cfif>
		
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction 
		name="uploadFile"
		hint="Zapisywanie pliku" 
		description="Metoda zapisuje plik na serwerze">
		
		<cfparam 
			name="strField" 
			default="filedata"/>
			
		<cfif (StructKeyExists(FORM, strField) AND Len(FORM[strField]))>
				
			<cfset myfile = APPLICATION.cfc.upload.SetDirName(dirName="products/expo") />
			<cfset myfile = APPLICATION.cfc.upload.upload(file_field="filedata") />
			<cfset myfile.binarycontent = false />
				
			<cfscript> 
				response = StructNew();
				StructInsert(response, "cfilename", myfile.clientfilename & "." & myfile.clientfileext); 
				StructInsert(response, "sfilename", myfile.newservername);
				StructInsert(response, "fileext", myfile.clientfileext);
			</cfscript>
				
			<cfset result='' />
		
		</cfif>
			
		<cfset renderPartial('upload') />
	</cffunction>
	
	<cffunction 
		name="removeFile">
		
		<cfset result={} />
		<cfif StructKeyExists(params, "filename")>
			<cfset StructAppend(result, params) />
			
			<cfset fullpathname = ExpandPath("./files/products/" & params.filename) />
			<cfif FileExists(fullpathname)>
				<cffile 
					action="delete"
					file="#fullpathname#">
				<cfset StructInsert(result, "success", "productcard_removed", "true") />
			</cfif>
			
			<cfset fullpathname = ExpandPath("./files/products/images/" & params.filename) />
			<cfif FileExists(fullpathname)>
				<cffile 
					action="delete"
					file="#fullpathname#">
				<cfset StructInsert(result, "success", "image_removed", "true") />
			</cfif>
			
			<cfset fullpathname = ExpandPath("./files/products/images/thumb_" & params.filename) />
			<cfif FileExists(fullpathname)>
				<cffile 
					action="delete"
					file="#fullpathname#">
				<cfset StructInsert(result, "success", "image_removed", "true") />
			</cfif>
			
			<cfset fullpathname = ExpandPath("./files/products/expo/" & params.filename) />
			<cfif FileExists(fullpathname)>
				<cffile 
					action="delete"
					file="#fullpathname#">
				<cfset StructInsert(result, "success", "file_removed", "true") />
			</cfif>
		</cfif>
		
		<cfset json = result />
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction 
		name="searchCategory">
		
		<cfset category = model("Index").getCategoryTree(params.qstr) />
		
		<cfset json = QueryToStruct(Query=category) />
		<cfset renderWith(data="json",template="/json",layout=false) />
		
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
		name="remainder">
		
		<cfset datetime = DateFormat(DateAdd('d', -2, Now()),'yyyy-mm-dd') />
		
		<cfset statuses = model("Product_step").findLastStatuses(date="#datetime#",version=2)/>
		
		<cfset variable = statuses />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
		
	</cffunction>
	
	<cffunction 
		name="expo">
			
		<cfset expo = model("Product_expo").findAllExpo() />
		
		<!---<cfset variable = expo />
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->
	</cffunction>
	
	<cffunction 
		name="expoAdd">
		
		<cfif StructKeyExists(FORM, "submitbutton")>
			
			<!---<cfset expo = model("Product_expo").new() />--->
			<cfset expo = {} />
			
			<cfset expo.purpose		= params.product.purpose />
			<cfset expo.producer	= params.product.producer />
			<!---<cfset expo.ean			= Replace(params.product.ean, " ", "", "all") />--->
			<!---<cfset expo.amount		= params.product.amount />--->
			<cfset expo.height		= params.product.height />
			<cfset expo.width		= params.product.width />
			<cfset expo.length		= params.product.length />
			<cfset expo.termbegin 		= params.product.termbegin />
			<cfset expo.termend 		= params.product.termend />
			<cfset expo.deliverydate = params.product.deliverydate />
			<cfset expo.startdate = params.product.startdate />
			<cfset expo.delivery 	= params.product.delivery />
			<cfset expo.contact		= params.product.contact />
			<cfset expo.actionend	= params.product.actionend />
			<cfset expo.label		= params.product.label />
			<cfset expo.additionalinfo = params.product.additionalinfo />
			
			<cfif StructKeyExists(params.product, "productfile")>
				<cfset expo.productfile = params.product.productfile />
			</cfif>
			
			<!---<cfset expo.createddate = Now() />--->
			<cfset expo.userid = session.user.id />			
			<!---<cfset expo.save() />--->
				
			<cfloop collection="#expo#" item="idx">
				<cfif StructFind(expo, idx) eq "">
					<cfset StructDelete(expo, idx) />
				<cfelse>
					<cfset StructUpdate(expo, idx, cf_escape_string(StructFind(expo, idx))) />
				</cfif>
    		</cfloop>
			
			<cfset expo = model("Product_expo").insert(expo) />
			
			<cfset productindex = ListToArray(params.product.index) />
			<cfset productean = ListToArray(params.product.ean) />
			<cfset productname = ListToArray(params.product.name) />
		 	<cfset productamount = ListToArray(params.product.amount) />
					
			<cfloop index="i" from="1" to="#ArrayLen(productean)#">
				<cfif productindex[i] eq '?'>
					<cfset productindex[i] = '' />
				</cfif>
				<cfif productname[i] eq '?'>
					<cfset productname[i] = '' />
				</cfif>
				<cfif productean[i] eq '?'>
					<cfset productean[i] = '' />
				</cfif>
				<cfif productamount[i] eq '?'>
					<cfset productamount[i] = '' />
				</cfif>
				<cfset indexes = model("Product_standindex").create(productname=productname[i], productean=productean[i], productindex=productindex[i], productamount=productamount[i], standid=expo.generatedkey) />
			</cfloop>
			
			<cfif StructKeyExists(params.product, "image") >
				<cfset images = listToArray(params.product.image)>
								
				<cfif IsArray(images)>
					<cfloop index="i" from="1" to="#ArrayLen(images)#">
						<cfset img = model('Product_image').create(file=images[i], productid=expo.generatedkey, cat=2)/>
					</cfloop>
				</cfif>
			</cfif>
			
			<!---<cfset variable = params />
			<cfset renderWith(data="variable",template="/dump",layout=false) />--->
			<cfset redirectTo(action="expo") />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="expoView">
		
		<cfif StructKeyExists(params, "key")>
			
			<cfset expo = model("Product_expo").findOneExpo(key=params.key) />
			<cfset products = model("Product_standindex").findAll(where="standid=#params.key#") />
			 
			<cfset steps = model("Product_expostep").findSteps(expoid=params.key) />
			<cfset images = model('Product_image').findAll(where="productid=#params.key# AND cat=2")>
		<cfelse>
			<cfset renderNothing() />
		</cfif>
		
		<!---<cfset variable = expo />	
		<cfset renderWith(data="variable",template="/dump",layout=false) />--->
		
	</cffunction>
	
	<cffunction 
		name="expoStep">
			
		<cfif StructKeyExists(params, "expoid")>			
			<cfset step = model("Product_expo").updateStep(expoid=params.expoid, stepstatus=params.stepid, stepcomment=params.stepcomment) />
			<cfset params.test = "asd" />
		</cfif>
		
		<cfset variable = params />	
		<cfset renderWith(data="variable",template="/dump",layout=false) />
		<!---<cfset renderNothing() />--->
	</cffunction>
	
	<cffunction 
		name="test">
		
		<!--- Ilość wierszy na stronie --->
		<cfset params.rows = 20 />
		
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
			rows	= params.rows,
			version = 2
		)/>
		
		<!--- Ilość wszystkich wyników zapytania wg kryteriów --->
		<cfset query_count = model('Product_index').findAllIndexCount(
			pn 	= params.pn,
			ps 	= params.ps,
			pt 	= params.pt,
			pu	= params.pu,
			pc	 = params.pc,
			dfrom = params.dfrom,
			dto = params.dto,
			version = 2
		)/>
		
		<cfset count = query_count.RecordCount />
		
		<!--- Ilość stron --->
		<cfset pages = Ceiling(count/params.rows) />
		
		<!--- Imiona i nazwiska użytkowników którzy dodawali indeksy --->
			
		<cfset users = model('Product_index').listUsers(version=2) />
		
		<cfset categories = model('Product_index').findAllCategories() />
		<cfset statuses = model('Product_stepnames').findAll(where="version=2") />
		
		<cfset productType = model("Product_type").findAll(where="version2=1") /> 
		
		<!---<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_arch" >
			<cfinvokeargument name="groupname" value="Archiwizowanie indeksów" />
		</cfinvoke>--->
		
		<cfset queryresult = QueryNew(
			"Lp, Nazwa_produktu, Kod_kreskowy, Producent, Typ, Uzytkownik, Data, Status, Kategoria", 
			"Integer, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar, VarChar") /> 
		
		<cfset qcount = 0 />
		<!---<cfloop query="query_count">
			<cfset QueryAddRow(queryresult, 1) />
			
			<cfset qcount++ />
			
			<cfset QuerySetCell(queryresult, "Lp", qcount) />
			
			<cfif ListContains("1,2,5,6,7", type)>
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
			
			<cfset QuerySetCell(queryresult, "Typ", productType["producttypename"][type]) />
			
			<cfset QuerySetCell(queryresult, "Uzytkownik", username) />
			
			<cfset QuerySetCell(queryresult, "Data", DateFormat(acceptdate, "yyyy-mm-dd")) />
			
			<cfset QuerySetCell(queryresult, "Status", step) />
			
			<cfset QuerySetCell(queryresult, "Kategoria", category) />
			
		</cfloop>--->
		
		<cfset variable = products />
		<cfset renderWith(data="variable",template="/dump",layout=false) />
		
	</cffunction>
	
</cfcomponent>