<cfcomponent 
	extends="Controller">
	
	<cffunction 
		name="init">
		
		<cfset super.init() />
		<cfset filters(through="authentication,setParameters") />
		
	</cffunction>
	
	<cffunction 
		name="authentication">
			
		<cfinvoke 
			component="controllers.Tree_groupusers" 
			method="checkUserTreeGroup" 
			returnvariable="priv" >
			
			<cfinvokeargument 
				name="groupname" 
				value="Koncesje" />
				
		</cfinvoke>
		
		<cfinvoke 
			component="controllers.Tree_groupusers" 
			method="checkUserTreeGroup" 
			returnvariable="root" >
			
			<cfinvokeargument 
				name="groupname" 
				value="root" />
				
		</cfinvoke>
		
		<cfif priv is false>
			<cfset renderPage(template="/autherror") />
		</cfif>
	
	</cffunction>
	
	<cffunction 
		name="setParameters">
			
			<cfset statuses = QueryNew("id, name", "Integer, VarChar") /> 
			
			<cfset QueryAddRow(statuses, 4) />
			
			<cfset QuerySetCell(statuses, "id", 1, 1) />
			<cfset QuerySetCell(statuses, "name", "oczekuje na przelew", 1) />
			
			<cfset QuerySetCell(statuses, "id", 2, 2) />
			<cfset QuerySetCell(statuses, "name", "opłacone", 2) />
			
			<cfset QuerySetCell(statuses, "id", 3, 3) />
			<cfset QuerySetCell(statuses, "name", "obowiązuje", 3) />
			
			<cfset QuerySetCell(statuses, "id", 4, 4) />
			<cfset QuerySetCell(statuses, "name", "wygasło", 4) />
			
			<cfset concessionType = QueryNew("id, name", "Integer, VarChar") /> 
			
			<cfset QueryAddRow(concessionType, 3) />
			
			<cfset QuerySetCell(concessionType, "id", 1, 1) />
			<cfset QuerySetCell(concessionType, "name", "Koncesja typ A (alkohol do 4,5% i piwo)", 1) />
			
			<cfset QuerySetCell(concessionType, "id", 2, 2) />
			<cfset QuerySetCell(concessionType, "name", "Koncesja typ B (alkohol od 4,5% do 18%)", 2) />
			
			<cfset QuerySetCell(concessionType, "id", 3, 3) />
			<cfset QuerySetCell(concessionType, "name", "Koncesja typ C (alkohol powyżej 18%)", 3) />
			
	</cffunction>
	
	<cffunction 
		name="concession">
			
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps" >
			<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
		</cfinvoke>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="kos" >
			<cfinvokeargument name="groupname" value="KOS" />
		</cfinvoke>
		
		<cfif pps is true>
			<cfset concessionproposals = model("Concession_proposal").findUserProposals(session.user.id) />
		<cfelseif kos is true>
			<cfset concessionproposals = model("Concession_proposal").findProposalsByKos(session.user.id) />
		</cfif>
	
	</cffunction>
	
	<cffunction 
		name="listAll">
			
		<cfset concessionproposals = model("Concession_proposal").findAllProposals() />
		
		<cfset renderPage(action="index") />
	
	</cffunction>
	
	<cffunction 
		name="new">
	
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps" >
				<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
			</cfinvoke>
			
			<cfif pps is true or root is true>
				
				<cfset user = model("User").findByKey(session.user.id) />
				<cfset store = model("Store_store").findOne(where="ajent=#user.logo#") />
				
				<cfif IsObject(store)>
				
					<cfset proposal = model("Concession_proposal").new() />
					
					<cfset proposal.type = 2 />
					<cfset proposal.status = 1 />
					<cfset proposal.step = 1 />
					<cfset proposal.userid = session.user.id />
					
					<cfset proposal.created = Now() />
					
					<cfset proposal.save(reload=true) />
					
					<cfset store_root_folder = model("folder_folder").findOne(where="folder_name LIKE 'Sklepy'") />
			
					<cfif IsObject(store_root_folder)>
						
						<cfset store_folder = model("folder_folder").findOne(
							where="lft > #store_root_folder.lft# AND rgt < #store_root_folder.rgt# AND folder_name LIKE '#store.projekt#'"
						)/>
						
						<cfif IsObject(store_folder)>
							<cfset storefolder = store_folder.id />
						<cfelse>
							
							<cfset newFolder = model("folder_folder").insert(
								foldername = store.projekt,
								folderdescription = '',
								nodeParent = store_root_folder.id) />
								
							<cfset storefolder = newFolder />

						</cfif>
						
						<cfset store_folder = model("folder_folder").findByKey(storefolder)/>
						
						<cfset concession_folder = model("folder_folder").findOne(
							where="lft > '#store_folder.lft#' AND rgt < '#store_folder.rgt#' AND folder_name LIKE 'Koncesje'"
						)/>
						
						<cfif !IsObject(concession_folder)>
							
							<cfset newFolder = model("folder_folder").insert(
								foldername = 'Koncesje',
								folderdescription = '',
								nodeParent = store_folder.id
							)/>
							
						</cfif>
						
					</cfif>
					
					<cfset redirectTo(controller="Concessions",action="create-document",key=proposal.id) />
					
				<cfelse>
					<cfset flashInsert(error="Brak przypisanego sklepu dla użytkownika") />
					<cfset redirectTo(controller="Concessions",action="index") />
				</cfif>
				
			<cfelse>
				<cfset renderPage(template="/autherror") />
			</cfif>
			
	</cffunction>
	
	<cffunction 
		name="createProposal">
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
				<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
			</cfinvoke>
			
			<cfif pps is true or root is true>
				
				<cfif StructKeyExists(params, "key")>
					
					<cfset proposal = model("Concession_proposal").findByKey(params.key) />
					
					<!---<cfset proposalattributes = model("Concession_attribute_old").findAll(where="document=1 AND type=#proposal.type#") />--->
					<cfset documentattributes = model("Concession_attribute_old").findAll(where="document=2 AND type=#proposal.type#") />
					
					<!---<cfloop query="proposalattributes">
						
						<cfset proposalattrvalue = model("Concession_attributevalue").create(
							documentid = proposal.id,
							attributeid = proposalattributes.id
						) />
						
						<cfset proposalattrvalue.save(callbacks=false) />
						
					</cfloop>--->
					
					
					
					<cfloop query="proposalattributes">
						
						<cfset proposalattrvalue = model("Concession_attributevalue").create(
							documentid = proposal.id,
							attributeid = proposalattributes.id
						) />
						
						<cfset proposalattrvalue.save(callbacks=false) />
						
					</cfloop>
					
					<cfset redirectTo(controller="Concessions",action="edit-proposal",key=proposal.id) />
					
				<cfelse>
					<cfset redirectTo(controller="Concessions",action="new") />
				</cfif>
				
			<cfelse>
				<cfset renderPage(template="/autherror") />
			</cfif>
			
	</cffunction>
	
	<cffunction 
		name="createDocument">
		
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
				<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
			</cfinvoke>
			
			<cfif pps is true or root is true>
				
				<cfif StructKeyExists(params, "key")>
					
					<cfset proposal = model("Concession_proposal").findByKey(params.key) />
					
					<cfloop index="idx" from="1" to="3">
					
						<cfset document = model("Concession_document").new() />
						<cfset document.proposalid = proposal.id />
						<cfset document.type = idx />
						<cfset document.userid = proposal.userid />
						<cfset document.created = Now() />
						<cfset document.save() />
						
						<cfset documentattributes = model("Concession_attribute_old").findAll(where="documenttype=2 AND attributetype=#document.type#") />
						
						<cfloop query="documentattributes">
							
							<cfset documentattrvalue = model("Concession_attributevalue").create(
								documentid = document.id
								,documenttype = 2
								,attributeid = documentattributes.id
							)/>
							
							<cfset documentattrvalue.save(callbacks=false) />
							
						</cfloop>
						
					</cfloop>
					
					<cfset redirectTo(controller="Concessions",action="edit-proposal",key=proposal.id) />
					
				<cfelse>
					<cfset redirectTo(controller="Concessions",action="new") />
				</cfif>
				
			<cfelse>
				<cfset renderPage(template="/autherror") />
			</cfif>
			
		
	</cffunction>
	
	<cffunction 
		name="editProposal">
							
				<cfset proposal = model("Concession_proposal").findByKey(
					key=params.key, 
					include="concession_stepname"
				)/>
				<cfset user = model("User").findByKey(proposal.userid) />
				<cfset store = model("Store_store").findOne(where="ajent=#user.logo#") />
				
				<cfset store_folder = model("folder_folder").findOne(
					where="folder_name LIKE '#store.projekt#'"
				)/>
									
				<cfset concession_folder = model("folder_folder").findOne(
					where="lft > '#store_folder.lft#' AND rgt < '#store_folder.rgt#' AND folder_name LIKE 'Koncesje'"
				)/>
				
				<cfset concession_documents = model("folder_document").findAll(
					where="folderid=#concession_folder.id#"
				)/>
				
				<cfif proposal.step gte 2>
					
					<cfset concession = model("Concession").findOne(where="concessionproposalid=#proposal.id#") />
					
					<cfif not IsObject(concession)>
						
						<cfset concession = model("Concession").new()/>
						<cfset concession.storeid = store.id />
						<cfset concession.concessionproposalid = proposal.id />
						<cfset concession.userid = session.user.id />					
						<cfset concession.save()/>
						
						<cfset documentattributes = model("Concession_attribute_old").findAll(where="documenttype=1 AND attributetype=1") />
						
						<cfloop query="documentattributes">
							
							<cfset documentattributevalue = model("Concession_attributevalue").create(
								documentid = concession.id,
								attributeid = documentattributes.id,
								documenttype = 1
							)/>
							
							<cfset documentattributevalue.save(callbacks=false) />
							
						</cfloop>
					
					</cfif>
					
					<cfset attributefields = model("Concession_attributevalue").getFormFields(
						documentid = concession.id,
						documenttype = 1
					)/>
						
				</cfif>
				
				<cfset documents = model("Concession_document").findAll(where="proposalid=#proposal.id#") />
		
	</cffunction>
	
	<cffunction 
		name="editDocument">
			
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
		</cfinvoke>
			
		<cfif pps is true  or root is true>
			
			<cfif StructKeyExists(params, "key")>
				
				<cfset document = model("Concession_document").findByKey(params.key) />
				
				<cfif document.status eq 1>
					<cfset document.status = 2 />
				</cfif>
				
				<cfset user = model("User").findByKey(document.userid) />
				<cfset store = model("Store_store").findOne(where="ajent=#user.logo#") />
				
				<cfif IsObject(document)>
					
					<cfset documentattributevalues = model("Concession_attributevalue").getFormFields(
						documentid = document.id,
						documenttype = 2
					)/>
					
					<cfset attributes = ArrayNew(1) />
					
					<cfloop query="documentattributevalues">
						
						<cfswitch 
							expression="#attributeid#">
							
							<cfcase value="10">
								<cfif IsNull(value)>
									<cfset val = store.projekt />
								<cfelse>
									<cfset val = value />
								</cfif>	
							</cfcase>
							
							<cfcase value="11">
								<cfif IsNull(value)>
									<cfset val = user.givenname & " " & user.sn />
								<cfelse>
									<cfset val = value />
								</cfif>	
							</cfcase>
							
							<cfdefaultcase>
								<cfset val = value />
							</cfdefaultcase>
							
						</cfswitch>
						
						<cfset attributes[attributeid] = {
							id = "attribute[#id#]",
							value = val
						}/>
					</cfloop>
					
				</cfif>
				
				<cfset attributeoptions = QueryNew("id, name", "Integer, VarChar") /> 
				<cfset QueryAddRow(attributeoptions, 3) />
				<cfset QuerySetCell(attributeoptions, "id", 1, 1) />
				<cfset QuerySetCell(attributeoptions, "name", "jednorazowo", 1) />
				<cfset QuerySetCell(attributeoptions, "id", 2, 2) />
				<cfset QuerySetCell(attributeoptions, "name", "w 2 ratach", 2) />
				<cfset QuerySetCell(attributeoptions, "id", 3, 3) />
				<cfset QuerySetCell(attributeoptions, "name", "w 3 ratach", 3) />
				
				<cfset document.save() />
			</cfif>
		
		<cfelse>
			<cfset renderPage(template="/autherror") />
		</cfif>
			
	</cffunction>
	
	<cffunction 
		name="viewDocument">
			
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
		</cfinvoke>
			
		<cfif pps is true or root is true>
			
			<cfif StructKeyExists(params, "key")>
				
				<cfset document = model("Concession_document").findByKey(params.key) />				
				<cfset user = model("User").findByKey(document.userid) />
				<cfset store = model("Store_store").findOne(where="ajent=#user.logo#") />
				
				<cfif IsObject(document)>
					
					<cfset documentattributevalues = model("Concession_attributevalue").getFormFields(
						documentid = document.id, 
						documenttype = 2
					)/>
					
					<cfset attributes = ArrayNew(1) />
					
					<cfloop query="documentattributevalues">
						
						<cfswitch 
							expression="#attributeid#">
							
							<cfcase value="10">
								<cfif IsNull(value)>
									<cfset val = store.projekt />
								<cfelse>
									<cfset val = value />
								</cfif>	
							</cfcase>
							
							<cfcase value="11">
								<cfif IsNull(value)>
									<cfset val = user.givenname & " " & user.sn />
								<cfelse>
									<cfset val = value />
								</cfif>	
							</cfcase>
							
							<cfdefaultcase>
								<cfset val = value />
							</cfdefaultcase>
							
						</cfswitch>
						
						<cfset attributes[attributeid] = {
							id = "attribute[#id#]",
							value = val
						}/>
					</cfloop>
					
				</cfif>
				
				<cfset attributeoptions = QueryNew("id, name", "Integer, VarChar") /> 
				<cfset QueryAddRow(attributeoptions, 3) />
				<cfset QuerySetCell(attributeoptions, "id", 1, 1) />
				<cfset QuerySetCell(attributeoptions, "name", "jednorazowo", 1) />
				<cfset QuerySetCell(attributeoptions, "id", 2, 2) />
				<cfset QuerySetCell(attributeoptions, "name", "w 2 ratach", 2) />
				<cfset QuerySetCell(attributeoptions, "id", 3, 3) />
				<cfset QuerySetCell(attributeoptions, "name", "w 3 ratach", 3) />
							
			</cfif>				
			
		<cfelse>
			<cfset renderPage(template="/autherror") />
		</cfif>
			
	</cffunction>
	
	<cffunction 
		name="saveDocument">
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
			<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
		</cfinvoke>
			
		<cfif pps is true or root is true>
			
			<cfif StructKeyExists(params, "document") and StructKeyExists(params, "attribute")>
				
				<cfset document = model("Concession_document").findBykey(params.document.id) />
				
				<cfset status_flag = 0 />
				
				<cfloop collection="#params.attribute#" item="i">
					
					<cfset documentattributevalue = model("Concession_attributevalue").findByKey(i) />
					
					<cfif params.attribute[i] eq '' and documentattributevalue.attributeid neq 15>
						<cfset status_flag = 1 />
					</cfif>
					
					<cfset documentattributevalue.attributevalue = params.attribute[i] />
					<cfset documentattributevalue.save(callbacks=false) />
					
				</cfloop>
				
				<cfif status_flag eq 0>
					
					<!---<cffile
						action="readbinary"
						file="#ExpandPath('files/concessions/')#document-proposal-#document.id#_created-#DateFormat(document.created, 'dd-mm-yyyy')#.pdf"
						variable="file_blob">--->
						
					<cfset document.update(
						status = 3,
						enddate = Now()
					)/>
						
				</cfif>
				
			</cfif>
			
			<cfset json = 'ok' />
			<cfset renderWith(data="json",template="/json",layout=false) /> 
		
		<cfelse>
			<cfset renderPage(template="/autherror") />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="acceptProposal">
		
		<cfif StructKeyExists(params, "proposalid")>
		
			<cfset proposal = model("Concession_proposal")
				.findByKey(params.proposalid)
			/>
			
			<cfswitch expression="#proposal.step#">
				
				<!--- Zatwierdzanie wypełnionych wniosków --->
				<cfcase value="1">
					<cfset documents = model("Concession_document")
						.findAll(where="proposalid=#proposalid#")
						 />
					
					<cfloop query="documents">
												
						<cfswitch expression="#documents.type#">
							<cfcase value="1">
								<cfset _type = 'proposal' />
								<cfset name = "Załącznik nr 1 - Wniosek o refundację #DateFormat(documents.created, 'yyyy')#" />
							</cfcase>
											
							<cfcase value="2">
								<cfset _type = 'biling' />
								<cfset name = "Załącznik nr 2 - Naliczenie opłat #DateFormat(documents.created, 'yyyy')#" />
							</cfcase>
											
							<cfcase value="3">
								<cfset _type = 'statement' />
								<cfset name = "Załącznik nr 3 - Oświadczenie" />
							</cfcase>
						</cfswitch>
						
						<cfset src = "document-#_type#-#documents.id#_created-#DateFormat(documents.created, 'dd-mm-yyyy')#.pdf" />
						<cfset path = "#ExpandPath('files/concessions/')#" & src />
						<!---<cfset name = "document-#_type#-#documents.id#_created-#DateFormat(documents.created, 'dd-mm-yyyy')#" />--->
						
						<cffile
							action = "readbinary"
							file = "#path#"
							variable = "file_blob">
							
						<cfset doc = model("Concession_document").findByKey(documents.id) />
						
						<cfset doc.update(
							document_blob = file_blob,
							document_src = src,
							document_name = name,
							document_icon = 'concession-document-pdf.png' 
						)/>
						
						<cfset doc.save() />
					</cfloop>
					
					<cfset proposal.update(step=2, status=1) />
					
					<cfset newStep(2, proposal.id, '') />
					
					<cfset redirectTo(action="index") />
				</cfcase>
				
				<!--- Weryfikacja wniosków przez KOS'a i wypełnianie wniosku KOS'a --->
				<cfcase value="2">
					
					<cfset proposal.update(step=3, status=1) />
					
					<cfset newStep(3, proposal.id, '') />
					
					<cfset redirectTo(action="list-all") />
				</cfcase>
				
				<!--- Akceptacja koncesji przez Dział rozliczeń z ajentami --->
				<cfcase value="3">
					
					<cfset user = model("User").findByKey(proposal.userid) />
					<cfset store = model("Store_store").findOne(where="ajent=#user.logo#") />
					
					<cfset store_folder = model("folder_folder").findOne(
						where="folder_name LIKE '#store.projekt#'"
					)/>					
					<cfset concession_folder = model("folder_folder").findOne(
						where="lft > '#store_folder.lft#' AND rgt < '#store_folder.rgt#' AND folder_name LIKE 'Koncesje'"
					)/>
					
					<cfset documents = model("Concession_document").findAll(where="proposalid=#proposal.id#") />
					
					<cfloop 
						query="documents">
						
						<cfset folder_document = model("folder_document").new() />
						<cfset folder_document.folderid = concession_folder.id />
						<cfset folder_document.document_name = documents.document_name />
						<cfset folder_document.document_src = documents.document_src />
						<cfset folder_document.document_blob = documents.document_blob />
						<cfset folder_document.document_icon = documents.document_icon />
						<cfset folder_document.userid = documents.userid />
						<cfset folder_document.created = documents.created />
						<cfset folder_document.save() />
						
						<cffile  
							action="copy"
							destination = "#ExpandPath('files/folders/')#"
							source = "#ExpandPath('files/concessions/')##documents.document_src#"
							mode="777" />
						
					</cfloop>
					
					<cfset proposal.update(step=4, status=3) />
					
					<cfset newStep(4, proposal.id, '') />
					
					<cfset redirectTo(action="list-all") />
				</cfcase>
				
				<cfdefaultcase>
					
					<!---<cfset redirectTo(action="index") />--->
					
				</cfdefaultcase>
				
			</cfswitch>
			
		</cfif>

	</cffunction>
	
	<cffunction 
		name="verifyProposal">
			
		<!---<cftry>--->
		
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="kos">
				<cfinvokeargument name="groupname" value="KOS" />
			</cfinvoke>
			
			<cfif kos is true or root is true>
				
				<cfif StructKeyExists(params, "key")>
					
					<cfset concession = model("Concession").findByKey(params.key) />
					
					<cfif IsObject(concession)>
					
						<cfset documentattributevalues = model("Concession_attributevalue").getFormFields(
							documentid = concession.id,
							documenttype = 1
						)/>
						
					</cfif>
					
				</cfif>
				
			<cfelse>
				<cfset renderPage(template="/autherror") />
			</cfif>
			
	</cffunction>
	
	<cffunction 
		name="saveProposal">
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="kos">
			<cfinvokeargument name="groupname" value="KOS" />
		</cfinvoke>
			
		<cfif kos is true or root is true>
			
			<cfif StructKeyExists(params, "attributevalue")>
				
				<cfloop collection="#params.attributevalue#" item="i">
					
					<cfset documentattributevalue = model("Concession_attributevalue").findByKey(i) />
					<cfset documentattributevalue.attributevalue = params.attributevalue[i] />
					<cfset documentattributevalue.save(callbacks=false) />
					
				</cfloop>
				
			</cfif>
			
			<cfset json = 'ok' />
			<cfset renderWith(data="json",template="/json",layout=false) /> 
		
		<cfelse>
			<cfset renderPage(template="/autherror") />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="newStep"
		hint="Dodaje wpis o zmianie statusu"
		access="private">
		
		<cfargument 
			name="stepid" 
			required="true" 
			type="numeric" />
			
		<cfargument 
			name="proposalid" 
			required="true"
			type="numeric" />
			
		<cfargument 
			name="comment"
			required="true" 
			type="string"
			default="" />
		
		<cfset step = model("Concession_step").new() />
		<cfset step.userid = session.user.id />
		<cfset step.stepid = arguments.stepid />
		<cfset step.proposalid = arguments.proposalid />
		<cfset step.datetime = Now() />
		<cfset step.comment = arguments.comment />
		<cfset step.save() />
			
	</cffunction> 
	
	<cffunction 
		name="uploadFile">
		
		<cfset json = 'ok' />
		
		<cfif IsDefined("FORM.FIELDNAMES") >
		
			<cfif (StructKeyExists(params, "projekt") and params.projekt neq '') or (StructKeyExists(params, "loc") and params.loc neq '')>
				
				<cfif params.projekt eq ''>
					<cfset projekt = params.loc />
				<cfelse>
					<cfset projekt = params.projekt />
				</cfif>
				
			<cfelse>
				
				<cfset user = model("User").findByKey(session.userid) />
				<cfset store = model("Store_store").findOne(where="ajent=#user.logo#") />
				<cfset projekt = store.projekt />
				
			</cfif>
			
			<cfset concession_folder = createStoreFolder(projekt) />
						
			<!---<cfset store_folder = model("folder_folder").findOne(
				where="folder_name LIKE '#projekt#'"
			)/>	--->
			
			<!---<cfset concession_folder = model("folder_folder").findOne(
				where="lft > '#store_folder.lft#' AND rgt < '#store_folder.rgt#' AND folder_name LIKE 'Koncesje'"
			)/>--->
			
			<cfset my_file = APPLICATION.cfc.upload.SetDirName(dirName="folders") />
			<cfset my_file = APPLICATION.cfc.upload.upload(file_field="filedata") />
			
			<cfset response = {
				cfilename = my_file.CLIENTFILENAME,
				sfilename = my_file.NEWSERVERNAME,
				thumbfilename = my_file.THUMBFILENAME,
				createdate = DateFormat(Now(), "dd.mm.yyyy")
			} />
			
			<cfif isStruct(my_file) AND StructKeyExists(my_file, "SUCCESS")> <!--- Plik został zapisany na serwerze --->
				
				<cfset folder_document = model("folder_document").new() />
				<cfset folder_document.folderid = concession_folder.id />
				<cfset folder_document.document_name = my_file.CLIENTFILENAME />
				<cfset folder_document.document_src = my_file.NEWSERVERNAME />
				<cfset folder_document.document_blob = my_file.BINARYCONTENT />
				<cfif IsDefined("my_file.THUMBFILENAME")>
					<cfset folder_document.document_thumb = my_file.THUMBFILENAME />
				</cfif>
				<cfset folder_document.userid = session.user.id />
				<cfset folder_document.created = Now() />
				<cfset folder_document.save() />
			
			</cfif>
			
			<cfset json = response />
		</cfif>
		
		<cfset renderWith(data="json",template="/json",layout=false) />
	</cffunction>
	
	<cffunction 
		name="index">
		
		<cfset params.where = "1=1" />
		
		<cfif StructKeyExists(params, "status")>
			<cfset params.where &= " AND statusid = #params.status#" />
		</cfif> 
		
		<cfif StructKeyExists(params, "projekt")>
			<cfset params.where &= " AND projekt LIKE ""%#params.projekt#%""" />
		</cfif>
			
		<cfif not StructKeyExists(params, "order")
			or (StructKeyExists(params, "order") and params.order eq 'undefined')>
			<cfset params.order = 'desc' />
		</cfif>
		
		<cfif not StructKeyExists(params, "orderby") 
			or (StructKeyExists(params, "orderby") and params.orderby eq 'undefined')>
			<cfset params.orderby = 'createdate' />
		</cfif>
		
		<cfif not StructKeyExists(params, "page")>
			<cfset params.page = 1 />
		</cfif>
		
		<cfif not StructKeyExists(params, "amount")>
			<cfset params.amount = 40 />
		</cfif>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="kos">			
			<cfinvokeargument name="groupname" value="KOS" />
		</cfinvoke>
		
		<cfif kos is true>
			<cfset params.where &= " AND userid = #session.user.id#" />
		</cfif>
		
		<cfset concessions =  model("Concession_concession").findConcessions(
			 where = params.where
			,orderby = params.orderby
			,order = UCase(params.order)
			,page = params.page
			,amount = params.amount
		)/>
		
		<cfset concessions_count =  model("Concession_concession").findConcessionsCount(
			 where = params.where
		)/>
		
		<cfset count = concessions_count.RecordCount />
		
		<cfset pages = Ceiling(count/params.amount) />
		
		<cfif IsAjax()>
			<cfset renderPartial("index") />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="licenses">
			
		<cfset params.where = "1=1" />
		
		<cfif StructKeyExists(params, "documentnr")>
			<cfset params.where &= " AND documentnr LIKE ""%#URLDecode(params.documentnr)#%""" />
		</cfif>
		
		<cfif StructKeyExists(params, "projekt")>
			<cfset params.where &= " AND projekt LIKE ""%#params.projekt#%""" />
		</cfif>
			
		<cfif not StructKeyExists(params, "order")>
			<cfset params.order = 'desc' />
		</cfif>
		
		<cfif not StructKeyExists(params, "orderby")>
			<cfset params.orderby = 'createdate' />
		</cfif>
		
		<cfif not StructKeyExists(params, "page")>
			<cfset params.page = 1 />
		</cfif>
		
		<cfif not StructKeyExists(params, "amount")>
			<cfset params.amount = 20 />
		</cfif>
			
		<cfset licenses = model("Concession_license").findLicenses(
			 where = params.where
			,orderby = params.orderby
			,order = UCase(params.order)
			,page = params.page
			,amount = params.amount
		) />
		
		<cfif IsAjax()>
			<cfset renderPartial("licenses") />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="view">
			
		<cfinvoke 
			component="controllers.Tree_groupusers" 
			method="checkUserTreeGroup" 
			returnvariable="etap2">
			
			<cfinvokeargument name="groupname" value="Potwierdzenie przelewu za koncesje" />
				
		</cfinvoke>
		
		<cfinvoke 
			component="controllers.Tree_groupusers" 
			method="checkUserTreeGroup" 
			returnvariable="etap3">
			
			<cfinvokeargument name="groupname" value="Weryfikacja koncesji" />
				
		</cfinvoke>
			
		<cfif StructKeyExists(params, "key") >
				
			<cfset concession = model("Concession_concession").findByKey(params.key) />
			
			<cfif IsObject(concession) >
				
				<cfset store = model("Store_store").findByKey(concession.storeid) />
				
				<cfset attributes = model("Concession_attribute").findAll(where="concessionid=#concession.id#", order="attributeid ASC") />
				
				<cfset steps = model("Concession_step").findAll(where="concessionid=#concession.id#", include="User") />
				
				<cfset license = model("Concession_license").findAll(where="concessionid=#concession.id#") />
			
			<cfelse>
				
				<cfset flashInsert(message="Koncesja o numerze #params.key# nie istnieje.") />
				<cfset redirectTo(action="index") />
			
			</cfif>
		
		<cfelse>
				
			<cfset redirectTo(action="index") />
				
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="update">
			
		<cfif 
				StructKeyExists(params, "concessionid") 
			and StructKeyExists(params, "license_type")
			and StructKeyExists(params, "storeid")>
			
			<cfset license = model("Concession_license").create(
				createdate = Now(),
				storeid = params.storeid,
				statusid = 1,
				typeid = params.license_type,
				concessionid = params.concessionid,
				documentnr = params.license_nr,
				dateofissue = params.license_issue,
				datefrom = params.license_from,
				dateto = params.license_to,
				issuedby = params.license_issuedby,
				file = params.concession_file) />
				
				
			<cfset step = model("Concession_step").create(
				concessionid = params.concessionid,
				stepid = 3,
				userid = session.user.id,
				stepdate = Now()
			)/>
			
		</cfif>
		
		<cfset json = license />
		<cfset renderWith(data="json",template="/json",layout=false) />
		
	</cffunction>
	
	<cffunction 
		name="license">
			
		<cfif StructKeyExists(params, "key")>
			
			<cfset license = model("Concession_license").findByKey(params.key) />
			
			<!---<cfset type = concessionType['name'][license.typeid] />
			<cfset documentnr = license.documentnr />
			<cfset dateofissue = license.dateofissue />
			<cfset issuedby = license.issuedby />
			<cfset datefrom = license.datefrom />
			<cfset dateto = license.dateto />
			<cfset file = license.file />--->
			
			<cfset renderPartial("license") />
		<cfelse>
			<cfset renderNothing() />
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="confirm">
			
		<cfif StructKeyExists(params, "concession") and StructKeyExists(params, "attribute") and StructKeyExists(params, "value")>
			
			<cfset attr = model("Concession_attribute").findOne(where="concessionid=#params.concession# AND attributeid=#params.attribute#") />
			
			<cfif IsObject(attr)>
				<cfset attr.update(attributevalue=params.value) />
			<cfelse>
				<cfset attr = model("Concession_attribute").new() />
				<cfset attr.concessionid = params.concession />
				<cfset attr.attributeid = params.attribute />
				<cfset attr.attributevalue = params.value />
				<cfset attr.save() />
			</cfif>
			
			<cfswitch expression="#params.attribute#">
				
				<cfcase value="5">
					<cfset concession = model("Concession_concession").findByKey(params.concession).update(statusid=2) />
					
					<cfset step = model("Concession_step").create(
						concessionid = params.concession,
						stepid = 2,
						userid = session.user.id,
						stepdate = Now()
					)/>
				</cfcase>
				
				<cfcase value="6">
					<cfset concession = model("Concession_concession").findByKey(params.concession).update(statusid=3) />
				</cfcase>
				
			</cfswitch>
			
			<cfset json = attr />
			<cfset renderWith(data="json",template="/json",layout=false) />
			
		<cfelse>
			
			<cfset json = false />
			<cfset renderWith(data="json",template="/json",layout=false) />
			
		</cfif>
		
		<cfif not IsAjax()>
			
			<cfset redirectTo(action="view", key=params.concession) />
			
		</cfif>
		
	</cffunction>
	
	<cffunction 
		name="create">
		
		<!---<cfset concession = model("Concession_license").new() />--->
		
	</cffunction>
	
	<cffunction 
		name="createAction">
			
		<cfif StructKeyExists(params, "concession_projekt") and StructKeyExists(params, "concession_storeid")>
			
			<cfset concession = model("Concession_concession").new() />
			<cfset concession.storeid = params.concession_storeid />
			<!---<cfset concession.typeid = params.concession_typeid />--->
			<cfset concession.createdate = Now() />
			<cfset concession.statusid = 1 /> <!--- 1 - nowa instancja koncesji (wpłynęło polecenie zapłaty) --->
			<cfset concession.userid = session.user.id />
			<cfset concession.save() />
			
			<cfset step = model("Concession_step").create(
				concessionid = concession.id,
				stepid = 1,
				userid = session.user.id,
				stepdate = Now()
			) />
			
			<cfset attributes = model("Concession_attribute").create(
				concessionid = concession.id,
				attributeid = 1,
				attributevalue = Trim(params.concession_nrb)
			) />
			
			<cfset attributes = model("Concession_attribute").create(
				concessionid = concession.id,
				attributeid = 2,
				attributevalue = ReplaceNoCase(Trim(params.concession_brutto), ' ', '')
			) />
			
			<cfset attributes = model("Concession_attribute").create(
				concessionid = concession.id,
				attributeid = 3,
				attributevalue = Trim(params.concession_description)
			) />
			
			<cfset attributes = model("Concession_attribute").create(
				concessionid = concession.id,
				attributeid = 4,
				attributevalue = params.concession_file
			) />
			
			<cfset attributes = model("Concession_attribute").create(
				concessionid = concession.id,
				attributeid = 7,
				attributevalue = Trim(params.concession_adress)
			) />
			
		</cfif>
		
		<cfset redirectTo(action="view", key=concession.id) />

	</cffunction>
	
	<cffunction 
		name="storesearch">
		
		<cfif StructKeyExists(params, "q")>
		
			<cfset stores = model("Store_store").findAll(
				select="id, projekt, ajent, nazwaajenta, miasto, ulica",
				where="projekt LIKE '%#params.q#%' AND is_active=1",
				maxRows="20"
			) />
			
			<cfset json = stores />
			<cfset renderWith(data="json",template="/json",layout=false) />
		<cfelse>
			
			<cfset renderNothing() />
			
		</cfif>	
		
	</cffunction>
	
	<cffunction 
		name="createStoreFolder" 
		access="private" 
		hint="Sprawdza czy istnieje katalog z teczką z koncesjami dla danego sklepu">
			
			<cfargument name="projekt" type="string" required="true" /> 
			
			<cfset store_root_folder = model("folder_folder").findOne(where="folder_name LIKE 'Sklepy'") />
			
			<cfif IsObject(store_root_folder)>
						
				<cfset store_folder = model("folder_folder").findOne(
					where="lft > #store_root_folder.lft# AND rgt < #store_root_folder.rgt# AND folder_name LIKE '#arguments.projekt#'"
				)/>
						
				<cfif IsObject(store_folder)>
					<cfset storefolder = store_folder.id />
				<cfelse>
							
					<cfset newFolder = model("folder_folder").insert(
						foldername = arguments.projekt,
						folderdescription = '',
						nodeParent = store_root_folder.id) />
								
					<cfset storefolder = newFolder />
					
				</cfif>
						
				<cfset store_folder = model("folder_folder").findByKey(storefolder)/>
						
				<cfset concession_folder = model("folder_folder").findOne(
					where="lft > '#store_folder.lft#' AND rgt < '#store_folder.rgt#' AND folder_name LIKE 'Koncesje'"
				)/>
				
				<cfif !IsObject(concession_folder)>
							
					<cfset newFolder = model("folder_folder").insert(
						foldername = 'Koncesje',
						folderdescription = '',
						nodeParent = store_folder.id
					)/>
					
					<cfset concession_folder = model("folder_folder").findByKey(newFolder) />
					
				</cfif>
				
				<cfreturn concession_folder />
				
			<cfelse>
				
				<cfreturn false />
						
			</cfif>
		
	</cffunction>
	
</cfcomponent>