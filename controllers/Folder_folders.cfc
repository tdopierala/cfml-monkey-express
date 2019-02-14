<cfcomponent displayname="Place_places" output="false" hint="" extends="Controller">

	<cffunction name="init" access="public" output="false" hint="" >
		<cfset super.init() />
		<cfset filters(through="before",type="before") />
	</cffunction> 
	
	<cffunction name="before" access="public" output="false" hint=""> 
		<cfset APPLICATION.bodyImportFiles &= ",folders" />
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="index" output="false" access="public" hint="">
		
		
		<cfparam name="folderid" type="numeric" default="#model('folder_folder').getRoot()#" />
		<cfparam name="foldername" type="string" default="Katalog główny" />
		
		<!--- Sprawdzam, czy parametry są zawarte w sesji --->
		<cfif StructKeyExists(session, "folder_folders") and
			StructKeyExists(session.folder_folders, "folderid")>
			<cfset folderid = session.folder_folders.folderid />
		</cfif>
		
		<cfif StructKeyExists(session, "folder_folders") and
			StructKeyExists(session.folder_folders, "foldername")>
			<cfset foldername = session.folder_folders.foldername />
		</cfif>
		
		<!--- Sprawdzam, czy parametry zostały przesłane i znajdują 
			się w zmiennej params --->
		<cfif StructKeyExists(params, "folderid")>
			<cfset folderid = params.folderid />
		</cfif>
		
		<cfif StructKeyExists(params, "foldername")>
			<cfset foldername = params.foldername />
		</cfif>
		
		<!--- Pobieram katalogi --->
		<cfset folders = model("folder_folder").getFolders(
			folderid = folderid,
			foldername = foldername) />
		
		<!--- Pobieram dokumenty --->
		<cfset documents = model("folder_document").getDocuments(
			folderid = folderid) />
		
		<cfset parentid = model("folder_folder").getParentId(folderid) />
		<cfset folderPrivileges = model("folder_user").getUserPrivilege(session.user.id) />
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="back" output="false" access="public" hint="">
		<cfif IsDefined("params.folderid")>
			
			<cfset folders = model("folder_folder").getParentFolders(params.folderid) />
			<cfset documents = model("folder_document").getParentDocuments(params.folderid) />
			
			<cfset folderid = model("folder_folder").getParentId(params.folderid) />
			<cfset parentid = model("folder_folder").getParentId(folderid) />
		</cfif>
		
		<cfset usesLayout(false) />
		<cfset renderPartial(partial="_folders") />
	</cffunction>
	
	<cffunction name="add" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			
			<cfset newFolder = model("folder_folder").insert(
				foldername = FORM.FOLDERNAME,
				folderdescription = FORM.FOLDERDESCRIPTION,
				nodeParent = FORM.FOLDERID) />
				
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="iframe" output="false" access="public" hint="">
		<cfset folderid = params.folderid />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="addFile" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES") >
			
			<cfset var newFloorplan = structNew() />
			<cfset my_file = APPLICATION.cfc.upload.SetDirName(dirName="folders") />
			<cfset my_file = APPLICATION.cfc.upload.upload(file_field="filedata") />
			
			<cfif isStruct(my_file) AND StructKeyExists(my_file, "SUCCESS")> <!--- Plik został zapisany na serwerze --->
				
				<cfset newDocument.folderid = FORM.FOLDERID />
				<cfset newDocument.document_name = my_file.CLIENTFILENAME />
				<cfset newDocument.document_src = my_file.NEWSERVERNAME />
				<cfset newDocument.document_blob = my_file.BINARYCONTENT />
				<cfif IsDefined("my_file.THUMBFILENAME")>
					<cfset newDocument.document_thumb = my_file.THUMBFILENAME />
				</cfif>
				<cfset newDocument.userid = session.user.id />
				<cfset newDocument.created = Now() />
				
				
				<cfswitch expression="#FORM.FOLDERID#">
					
					<cfcase value="394">
						
						<cfset pathToXls = ExpandPath("./files/folders/" & my_file.newservername) />
						<cfif FileExists(pathToXls)>
							
							<cfset qxls = '' />
							<cfspreadsheet 
								action = "read"
								src = "#pathToXls#"
								headerrow = "1"
								excludeHeaderRow = true
								columns="1,2,4-7,9-38"
								columnnames = "nr_projektu,sygn_intranet,przychody_docelowe,bep_ebitda_z,bep_ebitda_bez,bep_ebitda_bez_plus,plan_typ,m1,m2,m3,m4,m5,m6,m7,m8,m9,m10,m11,m12,m13,m14,m15,m16,m17,m18,m19,m20,m21,m22,m23,m24,m25,status_sklepu,naklady_razem,kaucja,czynsz_oplaty"
								query = qxls
								sheet = "1" />
								
							<cfmail
								to="webmaster@monkey.xyz"
								from="BŁĄD - Monkey<intranet@monkey.xyz>"
								replyto="intranet@monkey.xyz"
								subject="BEP"
								type="html">
				
								<cfdump var="#qxls#" />
								
							</cfmail>
							
							<cfif IsQuery(qxls)>
								
								<cfloop query="qxls">
									
									<cfset bep = model("Bep").new() />
									<cfset bep.projekt = qxls.nr_projektu />
									<cfset bep.placeid = qxls.sygn_intranet />
									
									<cfset bep.przychody_docelowe = qxls.przychody_docelowe />									
									<cfset bep.bep_ebitda_z = qxls.bep_ebitda_z />
									<cfset bep.bep_ebitda_bez = qxls.bep_ebitda_bez />
									<cfset bep.plan_typ = qxls.plan_typ />
									
									<cfset bep.naklady_razem = qxls.naklady_razem />
									<cfset bep.kaucja = qxls.kaucja />
									<cfset bep.czynsz_oplaty = qxls.czynsz_oplaty />
									<cfset bep.status_sklepu = qxls.status_sklepu />
									
									<cfset bep.m1 = qxls.m1 />
									<cfset bep.m2 = qxls.m2 />
									<cfset bep.m3 = qxls.m3 />
									<cfset bep.m4 = qxls.m4 />
									<cfset bep.m5 = qxls.m5 />
									<cfset bep.m6 = qxls.m6 />
									<cfset bep.m7 = qxls.m7 />
									<cfset bep.m8 = qxls.m8 />
									<cfset bep.m9 = qxls.m9 />
									<cfset bep.m10 = qxls.m10 />
									<cfset bep.m11 = qxls.m11 />
									<cfset bep.m12 = qxls.m12 />
									<cfset bep.m13 = qxls.m13 />
									<cfset bep.m14 = qxls.m14 />
									<cfset bep.m15 = qxls.m15 />
									<cfset bep.m16 = qxls.m16 />
									<cfset bep.m17 = qxls.m17 />
									<cfset bep.m18 = qxls.m18 />
									<cfset bep.m19 = qxls.m19 />
									<cfset bep.m20 = qxls.m20 />
									<cfset bep.m21 = qxls.m21 />
									<cfset bep.m22 = qxls.m22 />
									<cfset bep.m23 = qxls.m23 />
									<cfset bep.m24 = qxls.m24 />
									<cfset bep.m25 = qxls.m25 />									
									<cfset bep.createdate = Now() />
									
									<cfset bep.save() />
									
								</cfloop>
								
							</cfif>
							
						</cfif>
						
					</cfcase>
					
				</cfswitch>
			
			</cfif>
			
			<cfif not structIsEmpty(newDocument)>
				<cfset savedDocument = model("folder_document").create(newDocument) />
				
				<cfif not structIsEmpty(savedDocument)>
					<cfset flashInsert(success="Plik zostal zapisany prawidlowo.") />
				</cfif>
				
			</cfif>
			
		</cfif>
		
		<cfset usesLayout(template="/layout_cfwindow") />
	</cffunction>
	
	<cffunction name="folder" output="false" access="public" hint="">
		
		<cfif IsDefined("params.key")>
			<cfset folders = model("folder_folder").getChildreen(
				folderId = params.key) />
				
			<cfset documents = model("folder_document").getDocuments(
				folderid = params.key) />
			
			<cfset folderid = params.key />
			<cfset parentid = model("folder_folder").getParentId(folderid) />
			<cfset renderPartial(partial="_folders") />
		</cfif>
		
	</cffunction>

	<cffunction name="remove" output="false" access="public" hint="">
		
		<cfset json = {
			STATUS = "OK",
			MESSAGE = "Usunięto"} />
		
		<cfif IsDefined("params.key")>
			<cfset toRemove = model("folder_folder").delete(params.key) />
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction name="removeFile" output="false" access="public" hint="">
		
	</cffunction>
	
	<cffunction name="move" output="false" access="public" hint="">
		<cfset json = {
			STATUS = "OK",
			MESSAGE = "Przeniosłem folder"} />
		
		<cfset toMove = model("folder_folder").move(params.MYID, params.NEWROOT) />
		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction name="moveDocument" output="false" access="public" hint="">
		<cfset json = {
			STATUS = "OK",
			MESSAGE = "Przeniosłem dokument"} />
		
		<cfset toMove = model("folder_folder").moveDocument(params.MYID, params.NEWROOT) />
		
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
</cfcomponent>