<cfcomponent displayname="User_educations" extends="Controller" output="false">

	<cffunction name="init" access="public" output="false" hint="">
		<cfset super.init() />
		
		<cfset filters(through="before",type="before") />
	</cffunction>
	
	<cffunction name="before" access="package" output="false">
		<cfset usesLayout("/layout") />
		<cfset APPLICATION.ajaxImportFiles &= ",fileupload" />
	</cffunction> 
	
	<cffunction name="index" access="public" output="false" hint="Ścieżka edukacji użytkownika">
		<cfset userEducation = model("user_education").getEducation(session.user.id) />
	</cffunction>
	
	<cffunction name="uploadCourseFile" access="public" output="false" hint="">
		
		<cfset json = {} />
		<cfset json["msg"] = "" />
		<cfset json["error"] = "" />

		<cfif structKeyExists(form, "file") and len(form.file)>
			<cfset myFile = APPLICATION.cfc.upload.SetDirName(dirName="courses") />
			<cfset myFile = APPLICATION.cfc.upload.upload(file_field="file") />

			<cfset json["filename"] = myFile.NEWSERVERNAME />
			<cfset json["filesrc"] = myFile.SERVERDIRECTORY />
			<cfset json["msg"] = "#myFile.CLIENTFILENAME# - #myFile.FILESIZE#" />
			<cfset json["thumb"] = myFile.THUMBFILENAME />
		<cfelse>
			<cfset json["error"] = "No file was uploaded.">
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction name="add" access="public" output="false" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset newEducation = structNew() />
			<cfset newEducation = FORM />
			
			<cfif Len(FORM.INSTITUTION_NAME)>
				<cfset newEducation.institution_name = FORM.INSTITUTION_NAME />
			</cfif>
			
			<cfset newEducation.userid = session.user.id />
			<cfset insertEducation = model("user_education").create(newEducation) />
			
			<cfset flashInsert(msg = "Element został dodany. Możesz dodać kolejny.") />
			
		</cfif>
		
		<cfset stages = model("education_stage").getStages() />
		<cfset institutions = model("education_institution").getInstitutions() />
		<cfset degrees = model("education_degree").getDegrees() />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="addCourse" access="public" output="false" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfset newCourse = structNew() />
			<cfset newCourse = FORM />
			<cfset newCourse.userid = session.user.id />
			
			<cfset insertCourse = model("user_course").create(newCourse) />
			<cfset flashInsert(msg = "Element został dodany. Mozesz dodac kolejny.") />
			
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="education" access="public" output="false" hint="">
		<cfset userEducation = model("user_education").getEducation(session.user.id) />
		<cfset renderWith(data="userEducation",template="_education",layout=false) />
	</cffunction>
	
	<cffunction name="courses" access="public" output="false" hint="">
		<cfset userCourses = model("user_course").getCourses(session.user.id) />
		<cfset renderWith(data="userCourses",template="_courses",layout=false) />
	</cffunction>
	
	<cffunction name="export" access="public" hint="">
		
		<cfset userEducation = model("user_education").getEducation(session.user.id) />

		<cfsavecontent variable="strXmlData">
			<cfoutput>
				<?xml version="1.0"?>
				<?mso-application progid="Excel.Sheet"?>
				
				<Workbook
					xmlns="urn:schemas-microsoft-com:office:spreadsheet"
					xmlns:o="urn:schemas-microsoft-com:office:office"
					xmlns:x="urn:schemas-microsoft-com:office:excel"
					xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
					xmlns:html="http://www.w3.org/TR/REC-html40">

					<DocumentProperties xmlns="urn:schemas-microsoft-com:office:office">
						<Author>TD</Author>
						<Company></Company>
					</DocumentProperties>

					<Styles>
						<Style ss:ID="Default" ss:Name="Normal">
							<Alignment ss:Vertical="Top"/>
							<Borders/>
							<Font/>
							<Interior/>
							<NumberFormat/>
							<Protection/>
						</Style>
					</Styles>

					<Worksheet ss:Name="#session.user.givenname# #session.user.sn#">
 
					<Table ss:ExpandedColumnCount="#ListLen( userEducation.ColumnList )#"
						   ss:ExpandedRowCount="#(userEducation.RecordCount + 1)#"
						   x:FullColumns="1"
						   x:FullRows="1">

					<Row>
						<Cell>
							<Data ss:Type="String">Imię</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">Nazwisko</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">Typ szkoły</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">Nazwa szkoły</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">Data rozpoczęcia</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">Data zakończenia</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">Kierunek/Specjalizacja</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">Uzyskany/obroniony tytuł</Data>
						</Cell>
					</Row>
 
					<cfloop query="userEducation">
					<Row>
						<Cell>
							<Data ss:Type="String">#userEducation.givenname#</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">#UCase(userEducation.sn)#</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">#userEducation.stage_name#</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">
								<cfif Len(userEducation.institution_name)>
									#userEducation.institution_name#
								<cfelse>
									#userEducation.ei_institution_type# #userEducation.ei_institution_name#
								</cfif>
							</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">#DateFormat(userEducation.date_start, "yyyy-mm-dd")#</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">#DateFormat(userEducation.date_end, "yyyy-mm-dd")#</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">#userEducation.course# / #userEducation.specialization#</Data>
						</Cell>
						<Cell>
							<Data ss:Type="String">#userEducation.degree_name#</Data>
						</Cell>
					</Row>
					</cfloop>
					</Table>
					</Worksheet>
				</Workbook>
			</cfoutput>
		</cfsavecontent>
		
		<cfheader name="content-disposition" 
				  value="attachment; filename=SCIEZKA_EDUKACJI[#session.user.givenname#-#session.user.sn#].xml" />
				  
		<cfcontent type="application/msexcel" variable="#ToBinary( ToBase64( strXmlData.Trim().ReplaceAll( '>\s+', '>' ).ReplaceAll( '\s+<', '<' ) ) )#"/>
		
	</cffunction>

</cfcomponent>