<cfcomponent displayname="Brandbank" output="false" extends="Controller">
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		
	</cffunction>
	
<!---	<cffunction name="getProduct" output="false" access="public" hint="">
		
		<cfscript>
			var guidStr = "54F84FB5-73D5-4FC8-ABF2-5C3B1E386839";
		</cfscript>
		
		<!---
			We are going to subscribe to Campaing Monitor using the
			AddAndResubscribe actions. This is a SOAP-based method that
			requires the following XML body.
		--->
		<cfsavecontent variable="soapBody">
			<cfoutput>	
				

				<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Header>
    <ExternalCallerHeader xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
      <ExternalCallerId>#guidStr#</ExternalCallerId>
    </ExternalCallerHeader>
  </soap:Header>
  <soap:Body>
    <GetProductDataForGTINs xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
      <gtins>
        <gtin>50168286</gtin>
      </gtins>
    </GetProductDataForGTINs>
  </soap:Body>
</soap:Envelope>
			</cfoutput>
		</cfsavecontent>
 
 
		<!---
			Now that we have our SOAP body defined, we need to post it as
			a SOAP request to the Campaign Monitor website. Notice that
			when I POST the SOAP request, I am NOT required to append the
			"WSDL" flag to the target URL (this is only required when you
			actually want to get the web service definition).
		--->
		<cfhttp
			url="https://www.i-label.net/partners/webservices/datafeedbasic/extractdata.asmx"
			method="post"
			result="httpResponse" >
 
			<!---
				Most SOAP action require some sort of SOAP Action header
				to be used.
			--->
			<cfhttpparam
				type="header"
				name="SOAPAction"
				value="""http://www.i-label.net/Partners/WebServices/DataFeed/2005/11/GetProductDataForGTINs"""
				/>
	 
			<!---
				I typically use this header because CHTTP cannot handle
				GZIP encoding. This "no-compression" directive tells the
				server not to pass back GZIPed content.
			--->
			<cfhttpparam
				type="header"
				name="accept-encoding"
				value="no-compression"
				/>
			
			<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
	 
			<!---
				When posting the SOAP body, I use the CFHTTPParam type of
				XML. This does two things: it posts the XML as a the BODY
				and sets the mime-type to be XML.
		 
				NOTE: Be sure to Trim() your XML since XML data cannot be
				parsed with leading whitespace.
			--->
			<cfhttpparam
				type="xml"
				value="#trim( soapBody )#"
				/>
 
		</cfhttp>
		
		<cfdump var="#httpResponse#" />
		<cfabort />
		
		<!---
			When the HTTP response comes back, our SOAP response will be
			in the FileContent atribute. SOAP always returns valid XML,
			even if there was an error (assuming the error was NOT in the
			communication, but rather in the data).
		--->
		<cfif find( "200", httpResponse.statusCode )>
		 
			<!--- Parse the XML SOAP response. --->
			<cfset soapResponse = xmlParse( httpResponse.fileContent ) />
		 
			<!---
				Query for the response nodes using XPath. Because the
				SOAP XML document has name spaces, querying the document
				becomes a little funky. Rather than accessing the node
				name directly, we have to use its local-name().
			--->
			<cfset responseNodes = xmlSearch(
				soapResponse,
				"//*[ local-name() = 'Subscriber.AddAndResubscribeResult' ]"
				) />
		 
			<!---
				Once we have the response node, we can use our typical
				ColdFusion struct-style XML node access.
			--->
			<cfoutput>
		 
				Code: #responseNodes[ 1 ].Code.xmlText#
				<br />
				Success: #responseNodes[ 1 ].Message.xmlText#
		 
			</cfoutput>
		 
		</cfif>
	</cffunction>--->
	
	<cffunction name="coverageReport" output="false" access="public" hint="">
		<cfsetting requesttimeout="540" />
		
		<cfset var guidStr = "54F84FB5-73D5-4FC8-ABF2-5C3B1E386839" />
		<cfset var fileName = "#DateFormat(Now(), 'yyyy-mm-dd')#_#TimeFormat(Now(), 'HH-mm-ss')#" />
		<cfset var dane = createObject("component", "cfc.winapp").towaryWSieci() />

		<cfsavecontent variable="exportXml" >
			<cfoutput>
				<RetailerFeedbackReport xmlns="http://www.brandbank.com/schemas/CoverageFeedback/2005/11">
					<Message DateTime="#DateFormat(Now(), 'yyyy-mm-dd')#T#TimeFormat(Now(), 'HH:mm:ss')#.000" Domain="MAL" />
						
					<cfloop query="dane">
						
						<cfif Len(Trim(dane.NAZWA1)) EQ 0>
							<cfcontinue />
						</cfif>
						
						<Item HasLabelData="true" HasImage="true">
							<RetailerID>#dane.MG_KARID#</RetailerID>
							<Description>#REReplace(dane.OPIKAR, "&", " ", "all")#</Description>
							<GTINs>
								<GTIN Value="#Trim(dane.KODKRES)#">
									<Suppliers>
										<Supplier>
											<SupplierCode>#dane.SYMKAR#</SupplierCode>
											<SupplierName>#REReplace(dane.NAZWA1, "&", " ", "all")#</SupplierName>
										</Supplier>
									</Suppliers>
								</GTIN>
							</GTINs>
							<OwnLabel>false</OwnLabel>
							<Categories>
								<Category>#dane.KATEGORIA#</Category>
							</Categories>
						</Item>
					</cfloop>
						
				</RetailerFeedbackReport>
			</cfoutput>
		</cfsavecontent>
		
		<cffile action="write" file="#expandPath('files/brandbank/#fileName#.xml')#" output="#exportXml#" />
		<cfzip file = "#expandPath('files/brandbank/#fileName#.zip')#" 
			   source = "#expandPath('files/brandbank/#fileName#.xml')#" 
			   action = "zip" overwrite = "yes" />
		
		<cffile action="readbinary" file="#expandPath('files/brandbank/#fileName#.zip')#" variable="binaryZipFile" /> 
		
		<cfsavecontent variable="soapBody">
			<cfoutput>	
			<?xml version="1.0" encoding="utf-8"?>
			<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
						   xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
						   xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
				<soap:Header>
					<ExternalCallerHeader xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
						<ExternalCallerId>#guidStr#</ExternalCallerId>
					</ExternalCallerHeader>
				</soap:Header>
				<soap:Body>
					<SupplyCompressedCoverageReport xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
						<rawFileData>#toBase64(binaryZipFile, "utf-8")#</rawFileData>
					</SupplyCompressedCoverageReport>
				</soap:Body>
			</soap:Envelope>
			</cfoutput>
		</cfsavecontent>
		
		<cfhttp url="https://www.i-label.net/partners/webservices/datafeedbasic/reportdata.asmx?op=SupplyCompressedCoverageReport" 
				method="post" result="httpResponse" >

			<cfhttpparam type="header" name="SOAPAction" 
						 value="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11/SupplyCompressedCoverageReport" />
			<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
			<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
			<cfhttpparam type="xml" value="#trim( soapBody )#" />
 
		</cfhttp>

		<cfdump var="#httpResponse#" format="text" output="#expandPath('files/brandbank/#fileName#.txt')#" />
		
		<cfif find( "200", httpResponse.statusCode )>
			
			<cfset integrationStatus = structNew() />
			<cfset integrationStatus.success = true />
			<cfset integrationStatus.message = "Przesłałem raport Coverage Report." />
			<cfset integrationStatus.fileContent = httpResponse.Filecontent />
			
		<cfelse>
			
			<cfset integrationStatus = structNew() />
			<cfset integrationStatus.success = false />
			<cfset integrationStatus.message = "Nie mogłem przesłać raportu Coverage Report." />
			<cfset integrationStatus.fileContent = httpResponse.Filecontent />
			
		</cfif>
	</cffunction>
	
	<cffunction name="getProductDataForGtin" output="false" access="public" hint="">
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfset var guidStr = "54F84FB5-73D5-4FC8-ABF2-5C3B1E386839" />
			<cfsavecontent variable="soapBody">
				<cfoutput>	
				<?xml version="1.0" encoding="utf-8"?>
				<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
							   xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
							   xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
					<soap:Header>
						<ExternalCallerHeader xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
						<ExternalCallerId>#guidStr#</ExternalCallerId>
					</ExternalCallerHeader>
					</soap:Header>
					<soap:Body>
						<GetProductDataForGTINs xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
							<gtins>
								<gtin>#Trim(FORM.EAN)#</gtin>
							</gtins>
						</GetProductDataForGTINs>
					</soap:Body>
				</soap:Envelope>
				</cfoutput>
			</cfsavecontent>
			
			<cfhttp url="https://www.i-label.net/partners/webservices/datafeedbasic/extractdata.asmx?op=GetProductDataForGTINs" 
					method="post" result="httpResponse" >
	
				<cfhttpparam type="header" name="SOAPAction" 
							 value="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11/GetProductDataForGTINs" />
				<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
				<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
				<cfhttpparam type="xml" value="#trim( soapBody )#" />
	 
			</cfhttp>
			
			<cfdump var="#httpResponse#" />
			<cfabort />
			
		</cfif>
		
		<cfset usesLayout(false) />
		
	</cffunction>
	
	<cffunction name="getUnsentProductData" output="false" access="public" hint="">
		<cfsetting requesttimeout="540" />
		<cfset var guidStr = "54F84FB5-73D5-4FC8-ABF2-5C3B1E386839" />
		
		<cfsavecontent variable="soapBody">
			<cfoutput>	
				<?xml version="1.0" encoding="utf-8"?>
				<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
							   xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
							   xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
					<soap:Header>
						<ExternalCallerHeader xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
							<ExternalCallerId>#guidStr#</ExternalCallerId>
						</ExternalCallerHeader>
					</soap:Header>
					<soap:Body>
						<GetUnsentProductData xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11" />
					</soap:Body>
				</soap:Envelope>
			</cfoutput>
		</cfsavecontent>
			
		<cfhttp url="https://www.i-label.net/partners/webservices/datafeedbasic/extractdata.asmx?op=GetUnsentProductData" 
				method="post" result="httpResponse" >
	
			<cfhttpparam type="header" name="SOAPAction" 
						 value="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11/GetUnsentProductData" />
			<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
			<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
			<cfhttpparam type="xml" value="#trim( soapBody )#" />
	 
		</cfhttp>
		
		<cfset response = structNew() />
		<cfset response.success = true />
		<cfset response.message = "Brakujące produkty zostały pobrane i są przetwarzane przez system" />
		
		<cfset var fileName = "#DateFormat(Now(), "yyyy-mm-dd")#_#TimeFormat(Now(), 'HH-mm-ss')#" />
		
		<cfif find("200", httpResponse.statusCode)>
			<cfset soapResponse = xmlParse( httpResponse.fileContent ) />
			<cffile action="write" file="#expandPath('files/brandbank_productdata/#fileName#.xml')#" output="#soapResponse#" />
			
			<cfset var requestDataFile = xmlParse(httpResponse.fileContent) />
			<cfset var requestDataFileResult = xmlSearch(requestDataFile,"//*[local-name()='Message']") />
			<cfset var requestDataFileMessageId = requestDataFileResult[1].XmlAttributes.id />
			
			<cfsavecontent variable="acknowledgment">
				<cfoutput>	
				<?xml version="1.0" encoding="utf-8"?>
					<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
						xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
						xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
						<soap:Header>
							<ExternalCallerHeader xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
								<ExternalCallerId>#guidStr#</ExternalCallerId>
							</ExternalCallerHeader>
						</soap:Header>
						<soap:Body>
							<AcknowledgeMessage xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
								<messageGuid>#requestDataFileMessageId#</messageGuid>
							</AcknowledgeMessage>
						</soap:Body>
					</soap:Envelope>
				</cfoutput>
			</cfsavecontent>
			
			<cfhttp url="https://www.i-label.net/partners/webservices/datafeedbasic/extractdata.asmx?op=AcknowledgeMessage" 
					method="post" result="httpAcknowledgment" >
		
				<cfhttpparam type="header" name="SOAPAction" 
							 value="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11/AcknowledgeMessage" />
				<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
				<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
				<cfhttpparam type="xml" value="#trim( acknowledgment )#" />
		 
			</cfhttp>
				
			<cfdump var="#httpAcknowledgment#" format="text" output="#expandPath('files/brandbank/#fileName#_acknowledgment.txt')#" />
		
		<cfelse>
				<cfset response.success = false />
				<cfset response.message = "Nie można wykonać zapytania :(" />
				<cfdump var="#httpResponse#" format="text" output="#expandPath('files/brandbank_errors/#fileName#_getUnsentProductData.txt')#" />
 		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="processingData" output="false" access="public" hint="">
		<cfsetting requesttimeout="540" />
		
		<cfset processingInformation = structNew() />
		<cfset processingInformation.success = true />
		<cfset processingInformation.message = "Zapisałem w bazie danych wszystkie informacje o produktach" />
		
		
		<cfset var katalogZDanymi = expandPath("files/brandbank_productdata") />
		<cfif directoryExists(katalogZDanymi)>
			<cfset var res = DirectoryList(katalogZDanymi, true, "query") />
			
			<cfloop query="res">
				<cfset objParser = CreateObject("component", "cfc.SubNodeXmlParser").Init(
					"Product",
					"#res.DIRECTORY#/#res.NAME#"
					)
				/>
				
				<cfset var soapResponse = xmlParse("#res.DIRECTORY#/#res.NAME#") />
				<cfset var results = xmlSearch(soapResponse,"//*[local-name()='Message']") />
				<cfset var messageId = results[1].XmlAttributes.id />
				
				<!---
					Tutaj zaczynam budować plik XML, który następnie wyślę do
					BrandBanku jako komunikat zwrotny.
				--->
				<cfset var feedbackRequest = "" />
				
				<cfset var i = 0 />
				<cfsavecontent variable="feedbackRequest" >
				<cfloop condition="true">
	 
					<!--- Get the next node. --->
					<cfset VARIABLES.Node = objParser.GetNextNode() />
					 
					<!---
					Check to see if the node was found. If not, then the
					variable, Node, will have been destroyed and will no
					longer exist in its parent scope.
					--->
					<cfif StructKeyExists( VARIABLES, "Node" )>
						
						<cfset var tmpIdentity = xmlSearch(Variables.Node["Identity"], "ProductCodes/Code") />
						<cfset var tmpDescription = xmlSearch(Variables.Node["Identity"], "DiagnosticDescription") />
						
						<!---
							Pobieram numer gtin (ean)
						--->
						<cfset var gtin = "" />
						<cfset var brandbankid = "" />
						<cfloop array="#tmpIdentity#" index="idn" >
							<cfif UCase(idn['XmlAttributes']['Scheme']) is 'GTIN'>
								<cfset gtin = idn['XmlText'] />
							</cfif>
								
							<cfif UCase(idn['XmlAttributes']['Scheme']) is 'BRANDBANK:PVID'>
								<cfset brandbankid = idn['XmlText'] />
							</cfif>
						</cfloop>
							
						<!---
							Pobieram opis produktu
						--->
						<cfset var desc = "" />
						<cfloop array="#tmpDescription#" index="ds" >
							<cfif UCase(ds['XmlAttributes']['Code']) is 'PL'
								and Len(ds['XmlText'] GT 0)>
								<cfset desc = ds['XmlText'] />
							</cfif>
						</cfloop>
						
						<!---
							Sprawdzam, czy istnieja grafiki.
						--->
						<cfif StructKeyExists(VARIABLES.Node, "Assets") and StructKeyExists(VARIABLES.Node['Assets'], "Image")>
							<cfset var tmpImage = xmlSearch(VARIABLES.Node["Assets"], "Image") />
							
							<cfset var bProduct = structNew() />
							<cfset bProduct.success = true />
							<cfset bProduct.message = "Dodałem produkt z BrandBanku" />
							<cfset bProduct.id = "" />
							
							<cfset bProduct = model("brandbank").createProduct(
								messageid = messageId,
								gtin = gtin,
								brandbankid = brandbankid,
								description = desc ) />
							
							<cfloop array="#tmpImage#" index="img" >
								<cfset var bImage = structNew() />
								<cfset bImage.success = true />
								<cfset bImage.message = "Dodałem zdjęcie z BrandBanku" />
								<cfset bImage.id = "" />
								
								<cfset bImage = model("brandbank").createImage(
									gtin = gtin,
									url = img.Url.XmlText,
									quality = img.Specification.Quality.XmlText,
									resolution = img.Specification.Resolution.XmlText,
									width = img.Specification.RequestedDimensions.Width.XmlText,
									height = img.Specification.RequestedDimensions.Height.XmlText) />
							</cfloop>
							
							<!---<cfsavecontent variable="feedbackRequest" >--->
								<cfoutput>
								<Item Status="Matched">
									<RetailerID />
									<MessageGUID>{#messageId#}</MessageGUID>
									<BrandbankID>#brandbankid#</BrandbankID>
									<Description>#Trim(desc)#</Description>
									<Comment />
								</Item>
								</cfoutput>
							<!---</cfsavecontent>--->
								
						
						<cfelse>

							<!---<cfsavecontent variable="feedbackRequest" >--->
								<cfoutput>
								<Item Status="Not Sold">
									<RetailerID />
									<MessageGUID>{#messageId#}</MessageGUID>
									<BrandbankID>#brandbankid#</BrandbankID>
									<Description>#Trim(desc)#</Description>
									<Comment />
								</Item>
								</cfoutput>
							<!---</cfsavecontent>--->
	
						</cfif>
					 
					<cfelse>
					 
						<!--- We are done finding nodes so break out. --->
						<cfbreak />
					 
					</cfif>
					
				 	<cfset i++ />
				</cfloop>
				</cfsavecontent>
				
				<!---
					Po zasileniu bazy wysyłam Request do BrandBanku
					4) Product Processing Results
				--->
				<cfset var guidStr = "54F84FB5-73D5-4FC8-ABF2-5C3B1E386839" />
				<cfset var fileName = "#DateFormat(Now(), 'yyyy-mm-dd')#_#TimeFormat(Now(), 'HH-mm-ss')#" />
					
				<cfsavecontent variable="feedback" >
					<cfoutput>
						<RetailerProcessFeedback xmlns="http://www.brandbank.com/schemas/rpf/2005/11">
							<Message DateTime="#DateFormat(Now(), 'yyyy-mm-dd')#T#TimeFormat(Now(), 'HH:mm:ss')#.000" />
							#feedbackRequest#
						</RetailerProcessFeedback>
					</cfoutput>
				</cfsavecontent>
					
				<cffile action="write" file="#expandPath('files/brandbank/#fileName#_extraction_feedback.xml')#" output="#feedback#" />
					
				<cfzip file = "#expandPath('files/brandbank/#fileName#_extraction_feedback.zip')#" 
					   source = "#expandPath('files/brandbank/#fileName#_extraction_feedback.xml')#" 
					   action = "zip" overwrite = "yes" />
		
				<cffile action="readbinary" 
						file="#expandPath('files/brandbank/#fileName#_extraction_feedback.zip')#" 
						variable="binaryZipFile" /> 
		
				<cfsavecontent variable="soapBody">
					<cfoutput>
						<?xml version="1.0" encoding="utf-8"?>
						<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
							xmlns:xsd="http://www.w3.org/2001/XMLSchema" 
							xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
							<soap:Header>
								<ExternalCallerHeader xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
									<ExternalCallerId>#guidStr#</ExternalCallerId>
								</ExternalCallerHeader>
							</soap:Header>
							<soap:Body>
								<SupplyCompressedExtractionFeedback xmlns="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11">
									<rawFileData>#toBase64(binaryZipFile, "utf-8")#</rawFileData>
								</SupplyCompressedExtractionFeedback>
							</soap:Body>
						</soap:Envelope>
					</cfoutput>
				</cfsavecontent>
		
				<cfhttp url="https://www.i-label.net/partners/webservices/datafeedbasic/reportdata.asmx?op=SupplyCompressedExtractionFeedback" 
					method="post" result="httpResponse" >

					<cfhttpparam type="header" name="SOAPAction" 
								 value="http://www.i-label.net/Partners/WebServices/DataFeed/2005/11/SupplyCompressedExtractionFeedback" />
					<cfhttpparam type="header" name="accept-encoding" value="no-compression" />
					<cfhttpparam type="header" name="Content-Type" value="text/xml; charset=utf-8" />
					<cfhttpparam type="xml" value="#trim( soapBody )#" />
 
				</cfhttp>

				<cfdump var="#httpResponse#" format="text" output="#expandPath('files/brandbank/#fileName#_extraction_feedback.txt')#" />
					
				<cffile action = "move" 
						destination = "#res.DIRECTORY#_bak/#res.NAME#" 
						source = "#res.DIRECTORY#/#res.NAME#" />
				
				<cfset processingInformation.success = true />
				<cfset processingInformation.message = "Zapisałem w bazie danych wszystkie informacje o produktach" />
				<cfset processingInformation.fileContent = httpResponse.fileContent />
		
			</cfloop>
		
		<cfelse>
			
			<cfset processingInformation.success = false />
			<cfset processingInformation.message = "Nie ma katalogu z plikami do pobrania" />
			 
		</cfif>
		
	</cffunction>
	
	<cffunction name="processingImages" output="false" access="public" hint="">
		<cfsetting requesttimeout="3600" />
		<cfset img = model("brandbank").getImage(20) />
		
		<cfloop query="img">
			<cfscript>
				myImage=ImageRead(img.url);
				ImageWrite(myImage, "#expandPath('files/brandbank_images/#img.gtin#.#img.width#.#img.height#.png')#");
			</cfscript>
			
			<cfset imgImported = model("brandbank").imageImported(id) />
		</cfloop>
		
		<cfset renderNothing() />
	</cffunction>
	
	<cffunction name="zmienNazwy" output="false" access="public" hint="">
		<cfsetting requesttimeout="540" />
		
		<cfset var katalogZDanymi = "/mnt/brandbank" />
		<cfif directoryExists(katalogZDanymi)>
			<cfset var res = DirectoryList(katalogZDanymi, true, "query") />
			<cfset var res2 = "" />
			<cfquery name="res2" dbtype="query">
				select * from res 
				where NAME like <cfqueryparam value="%.300.300.png" cfsqltype="cf_sql_varchar" />  
			</cfquery>
			<cfloop query="res2">
				<cfset var newName = ListToArray(NAME, ".") />
				<cfscript>
					fileMove("#res2.DIRECTORY#/#res2.NAME#", "#res2.DIRECTORY#/#newName[1]#.png");
				</cfscript>
			</cfloop>
		</cfif>
		<cfset renderNothing() />
	</cffunction>

</cfcomponent>