<cfcomponent extends="Controller">

	<cffunction name="init" output="false" access="public" hint="">
		<cfscript>
			super.init();
			provides("html,json,xls");
			
			filters(through="before", type="before");
		</cfscript>
	
	</cffunction>
	
	<cffunction name="before" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction 
		name="index"
		hint="Strona główna raportów faktury w obiegu"
		description="Metoda generująca widok z raportem o fakturach w obiegu">
			
			<cfif isDefined("FORM.FieldNames")>
				
				<cfset myInvoiceReport = model("viewInvoiceReport").getReport(
					invoice_payment_date_from 	= Form.invoice_payment_date_from,
					invoice_payment_date_to 	= Form.invoice_payment_date_to,
					invoice_income_date_from 	= Form.invoice_income_date_from,
					invoice_income_date_to 		= Form.invoice_income_date_to,
					invoice_sold_date_from 		= Form.invoice_sold_date_from,
					invoice_sold_date_to 		= Form.invoice_sold_date_to,
					group_by_contractor			= Form.group_by_contractor) />
					
				<cfswitch expression="#FORM.invoice_export_to#" >
					
					<cfcase value="xls" > <!--- Generowanie pliku Excel --->
						
						<cfsavecontent variable="strXmlData">
							<cfoutput>

							<!---
								Define this document as both an XML doucment and a
								Microsoft Excel document.
							--->
							<?xml version="1.0"?>
							<?mso-application progid="Excel.Sheet"?>
 
							<!---
								This is the Workbook root element. This element
								stores characteristics and properties of the
								workbook, such as the namespaces used in
								SpreadsheetML.
							--->
							<Workbook
								xmlns="urn:schemas-microsoft-com:office:spreadsheet"
								xmlns:o="urn:schemas-microsoft-com:office:office"
								xmlns:x="urn:schemas-microsoft-com:office:excel"
								xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
								xmlns:html="http://www.w3.org/TR/REC-html40">
 
							<!---
								The first child element of the WorkBook element
								is DocumentProperties. Office documents store
								metadata related to the document—for example,
								the author name, company, creation date, and
								more in the DocumentProperties element.
							--->
							<DocumentProperties
								xmlns="urn:schemas-microsoft-com:office:office">
								<Author>TD</Author>
								<Company>Monkey Group</Company>
							</DocumentProperties>
 
							<!---
								The Styles node represents information related
								to individual styles that can be used to format
								components of the workbook.
							--->
							<Styles>
 
							<!--- Basic format used by all cells. --->
								<Style ss:ID="Default" ss:Name="Normal">
									<Alignment ss:Vertical="Top"/>
									<Borders/>
									<Font/>
									<Interior/>
									<NumberFormat/>
									<Protection/>
								</Style>
 
							<!---
								This is the movie rating style. We are going to
								format the number so that it goes to one
								decimal place.
							--->
								<Style ss:ID="Rating">
									<NumberFormat ss:Format="0.0" />
								</Style>
 
								<!---
									This is the date of the movie viewing. It is
									going to be a short date in the format of
									d-mmm-yyyy (ex. 15-Mar-2007).
								--->
								<Style ss:ID="ShortDate">
									<NumberFormat ss:Format="[ENG][$-409]d\-mmm\-yyyy;@" />
								</Style>
 
								<!---
									This is the boolean format of the has
									fighting and has boobies columns. We are
									going to display these values in Yes /
									No format.
								--->
								<Style ss:ID="YesNo">
									<NumberFormat ss:Format="Yes/No" />
								</Style>

							</Styles>

							<!---
								This defines the first worksheeet and it's name.
								We are only using one worksheet in this example,
								but you could add more Worksheet nodes after
								this one for multiple tabs. The "Name" attribute
								here is the name that shows up in the tab.
							--->
							<Worksheet ss:Name="Obieg dokumentów">
								<Table
								<!---
									We need a column for each column of the
									query. This attribute is required to be
									correct. If the value here does NOT
									match the data in Excel file, the
									document will not render properly.
									
									We need a row for every query record
									plus one for the header row. Again, if
									this value does not match what is in the
									document, the excel file will not
									render properly.
								--->
									ss:ExpandedColumnCount="#ListLen( myInvoiceReport.ColumnList )#"
									ss:ExpandedRowCount="#(myInvoiceReport.RecordCount + 1)#"
									x:FullColumns="1"
									x:FullRows="1">
 
								<!---
									Here, we can define general properties
									regarding each column in the data output.
								--->
								<!---
								<Column ss:Index="1" ss:Width="30" />
								<Column ss:Index="2" ss:Width="100" />
								<Column ss:Index="3" ss:Width="42" />
								<Column ss:Index="4" ss:Width="84" />
								<Column ss:Index="5" ss:Width="66" />
								<Column ss:Index="6" ss:Width="70" />
								--->
 
								<!---
									This is our header row. All cells in the
									header row will be of type string.
								--->
								<Row>
									<Cell>
										<Data ss:Type="String">Nazwa krótka</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Nazwa długa</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Netto</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Brutto</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Data wystawienia</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Data sprzedaży</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Data płatności</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Data wpływu</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Departament</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">NIP</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Numer faktury</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Zewnętrzny numer faktury</Data>
									</Cell>
									<Cell>
										<Data ss:Type="String">Kategoria faktury</Data>
									</Cell>
								</Row>
 
								<!--- Loop over the query. --->
								<cfloop query="myInvoiceReport">

									<!---
										When we output the excel XML row / cell
										data, we can put the format the tabbing
										/ returning of the Cell and data cells
										in relation to each other; however, we
										cannot freely move around the values
										within the Data cells as it may change
										the ability to convert the data type.
										For instance, we cannot put any white
										space in front of a numeric value or it
										will not be parsed as a number and will
										error out.
									--->
									<Row>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.nazwa1#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.nazwa2#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="Number">#myInvoiceReport.netto#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="Number">#myInvoiceReport.brutto#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.data_wystawienia#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.data_sprzedazy#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.data_platnosci#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.data_wplywu#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.departmentname#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.nip#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.numer_faktury#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.numer_faktury_zewnetrzny#</Data>
										</Cell>
										<Cell>
											<Data ss:Type="String">#myInvoiceReport.categoryname#</Data>
										</Cell>
									</Row>

								</cfloop>

								</Table>
								</Worksheet>
								</Workbook>

							</cfoutput>
						</cfsavecontent>
			

						<!---
							Define the way in which the browser should interpret
							the content that we are about to stream.
						--->
						<cfheader
							name="content-disposition"
							value="attachment; filename=Raport_obiegu_dokumentow_#DateFormat(Now(), 'dd_mm_yyyy')#.xml" />
 
						<!---
							When streaming the Excel XML data, trim the data and
							replace all the inter-tag white space. No need to stream
							any more content than we have to.
						--->
						<cfcontent
							type="application/msexcel"
							variable="#ToBinary( ToBase64( strXmlData.Trim().ReplaceAll( '>\s+', '>' ).ReplaceAll( '\s+<', '<' ) ) )#" />
						
						
					</cfcase> <!--- Koniec generowania pliku Excel --->
						
					<cfcase value="csv"> <!--- Generowanie pliku csv --->
						
						<cfset strOutput = QueryToCSV(
							myInvoiceReport,
							"nazwa1, nazwa2, netto, brutto, data_wystawienia, data_sprzedazy, data_platnosci, data_wplywu, departmentname, nip, numer_faktury, numer_faktury_zewnetrzny, categoryname") />
							
						<cfheader
							name="content-disposition"
							value="attachment; filename=Raport_obiegu_dokumentow_#DateFormat(Now(), 'dd_mm_yyyy')#.csv"
							charset="utf-8" />
							
						<cfcontent
							type="text/plain"
							variable="#ToBinary( ToBase64( strOutput.Trim() ) )#">
						
					</cfcase> <!--- Koniec generowania pliku csv --->
					
					
				</cfswitch>
				
			</cfif>
			
			<cfset usesLayout(false) />
			
	</cffunction>
	

</cfcomponent>