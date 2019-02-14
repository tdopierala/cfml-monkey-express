<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="usuwanie" >
		<cfinvokeargument name="groupname" value="Usuwanie teczek" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="wszystkie" >
		<cfinvokeargument name="groupname" value="Wszystkie teczki" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="dokumenty" >
		<cfinvokeargument name="groupname" value="Dodawanie dokumentów" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="katalogi" >
		<cfinvokeargument name="groupname" value="Dodawanie katalogów" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="struktura" >
		<cfinvokeargument name="groupname" value="Struktura katalogów" />
	</cfinvoke>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<!--- Podstawowe akcje w teczkach dokumentów --->
<div class="folder_actions">
	<ul class="folder_nav">
		<li>
			<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Folder_folders",action="index")#</cfoutput>', 'user_profile_cfdiv');" title="Katalog domowy" class="folder_options folder_home_folder">
				<span>Katalog domowy</span>
			</a>
		</li>
		<li>
			<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Folder_folders",action="back",params="folderid=#folderid#")#</cfoutput>', 'folder_folders_index');" title="Wstecz" class="folder_options folder_back_button">
				<span>Wstecz</span>
			</a>
		</li>
		<cfinvoke component="models.Folder_user" method="checkUserFolderPrivilege" returnvariable="dodawanieTeczki" >
			<cfinvokeargument name="userid" value="#session.user.id#" />
			<cfinvokeargument name="folderid" value="#folderid#" />
		</cfinvoke>
		<cfif (katalogi is true) or (dodawanieTeczki.privilege_write EQ 1)>
			<li>
				<a href="javascript:void(0)" onclick="javascript:showCFWindow('insertNewFolder', 'Dodaj nową teczkę', 'index.cfm?controller=folder_folders&action=add<cfif IsDefined("folderid")>&folderid=<cfoutput>#folderid#</cfoutput></cfif>', 500, 770);" title="Dodaj teczkę" class="folder_options folder_add_folder">
					<span>Dodaj teczkę</span>
				</a>
			</li>
		</cfif>
		
		<cfinvoke component="models.Folder_user" method="checkUserFolderPrivilege" returnvariable="dodawanieDokumentu" >
			<cfinvokeargument name="userid" value="#session.user.id#" />
			<cfinvokeargument name="folderid" value="#folderid#" />
		</cfinvoke>
		<cfif (dokumenty is true) or (dodawanieDokumentu.privilege_write EQ 1)>
			<li>
				<a href="javascript:void(0)" onclick="javascript:showCFWindow('addNewFile', 'Dodaj nowy plik', 'index.cfm?controller=folder_folders&action=iframe<cfif IsDefined("folderid")>&folderid=<cfoutput>#folderid#</cfoutput></cfif>', 250, 755);" title="Dodaj Plik" class="folder_options folder_add_file">
					<span>Dodaj plik</span>
				</a>
			</li>
		</cfif>
		<li>
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=folder_folders&action=folder&key=<cfoutput>#folderid#</cfoutput>', 'folder_folders_index')"  title="Odśwież" class="folder_options folder_refresh_folder">
				<span>Odśwież</span>
			</a>
		</li>
	</ul>
</div>

<ul id="folder_directory_listing" class="display_dir">
<!--- Listuje wszystkie katalogi --->
<cfloop query="folders">
	<cfinvoke component="models.Folder_user" method="checkUserFolderPrivilege" returnvariable="fp" >
		<cfinvokeargument name="userid" value="#session.user.id#" />
		<cfinvokeargument name="folderid" value="#folders.id#" />
	</cfinvoke>
	
	<cfif (fp.RecordCount EQ 1 and fp.privilege_read EQ 1) or (wszystkie is true)>
		<li class="folder_element {folderId:<cfoutput>#id#</cfoutput>}">
			<a href="javascript:ColdFusion.navigate('index.cfm?controller=folder_folders&action=folder&key=<cfoutput>#id#</cfoutput>', 'folder_folders_index');" title="Przejdź do folderu" class="folder_item folder">
				<span>
					<cfoutput>#foldername#</cfoutput>
				</span>
			</a>
			
			<cfif usuwanie is true>
				<a href="javascript:void(0)" onclick="delF(<cfoutput>#id#</cfoutput>, $(this))" title="Usuń katalog" class="folder_remove">
					x
				</a>
			</cfif>
			
		</li>
	</cfif>
</cfloop>
			 
<!--- Listuje wszystkie pliki --->
<cfoutput query="documents">
 	 <li class="document_element {documentId:#id#}">
 	 	
 	 	<cfset tab = listToArray(documentsrc, ".") />
		<cfset l = ArrayLen(tab) />
 	 	<cfset ext = tab[l] />
 	 	
 	 	<cfswitch expression="#ext#">
		  	
			<cfcase value="pdf">
				<cfset ext_class="pdfico" />
			</cfcase>
			
			<cfcase value="doc">
				<cfset ext_class="word" />
			</cfcase>
			
			<cfcase value="docx">
				<cfset ext_class="word" />
			</cfcase>
			
			<cfcase value="xls">
				<cfset ext_class="excel" />
			</cfcase>
			
			<cfcase value="xlsx">
				<cfset ext_class="excel" />
			</cfcase>
			
			<cfcase value="jpg">
				<cfset ext_class="image" />
			</cfcase>
			
			<cfcase value="png">
				<cfset ext_class="image" />
			</cfcase>
			
			<cfdefaultcase>
				<cfset ext_class="file" />
			</cfdefaultcase>
		  	
 	 	</cfswitch>
 	 	
 	 	<a href="files/folders/#documentsrc#" title="Pobierz dokument - #documentname#" class="folder_item #ext_class#" target="_blank">
			<span>
				#documentname#
			</span>
		</a>
		
		<cfif usuwanie is true>
			<a href="javascript:void(0)" onclick="delD(#id#, $(this))" title="Usuń dokument" class="document_remove">
				x
			</a>
		</cfif>
 	 </li>
</cfoutput>
 
<!--- Katalog wyżej --->
<li class="folder_element {folderId:<cfoutput>#parentid#</cfoutput>}">
	<a href="javascript:void(0);" title="Przejdź do folderu" class="folder_item folder gray">
		<span>

		</span>
	</a>
</li>
<!--- Koniec katalogu wyżej --->
 
</ul>

<!--- Informacja o ilości podkatalogów i plików --->
<div class="folder_summary"></div>

<cfif struktura is true>
	<cfset ajaxOnLoad("dragdrop") />
</cfif>