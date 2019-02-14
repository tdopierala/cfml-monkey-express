<cfprocessingdirective pageencoding="utf-8" />

<!---<cfdiv id="left_site_column">`--->

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle"><cfoutput>#note.title#</cfoutput></h3>
		</div>
	</div>
	
	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfif flashKeyExists("msg")>
				<span class="success"><cfoutput>#flash("msg")#</cfoutput></span>
			</cfif>

			<cfform name="note_notes_filter_form"
					action="#URLFor(controller='Note_notes',action='edit',key=params.key)#"
					onsubmit="javascript:$('##notebody').val(CKEDITOR.instances['notebody'].getData())">
						
				<cfinput type="hidden" name="files" />
				<cfinput type="hidden" name="note_fileupload_url" value="index.cfm?controller=note_notes&action=upload-note-file" />
						
				<ol class="uiList uiForm">
					
					<li>
						<label for="title">Tytuł dokumentu</label>
						<cfinput type="text"
								 name="title"
								 class="input"
								 value="#note.title#" />
					</li>
					<li>
						<cftextarea id="notebody" name="notebody" class="" value="#note.notebody#" >
							
						</cftextarea>
					</li>
					<li>
						<p>Załączone pliki</p>
						<cfoutput query="files">
							<a href="files/note_files/#filename#" title="Otwórz plik" target="_blank">
								<div class="noteImageFile">
									<cfimage action="writeToBrowser" source="#filesrc#/#filethumbsrc#" />
									
									<div class="NoteImageHideDeleteCover">
										<a href="index.cfm?controller=note_notes&action=remove-file-from-note&key=#id#" onclick="return removeNoteFile($(this));" title="Usuń plik">Usuń plik</a>
									</div>
								</div>
							</a>
						</cfoutput>
					</li>
					<li class="noteFiles">
						<label for="file">Załącz plik</label>
						<cfinput type="file" name="file" /> 
						<cfinput type="button" 
								 name="submit_course_file" 
								 value="Dodaj"
								 onclick="return initAjaxFileUpload()" />
					</li>
					<li class="noteFilePreview">
						<p>Podgląd plików</p>
					</li>
					<li>
						<p>Przypisane tagi</p>
						<cfoutput query="tags">
							<span class="noteSingleTag">
								#tagname#
								
								<a href="index.cfm?controller=note_notes&action=remove-tag-from-note&key=#id#" onclick="return removeNoteTag($(this))" title="Usuń plik">x</a>
								
							</span>
						</cfoutput>
					</li>
					<li>
						<label for="tag">Dopisz tagi</label>
						<cfinput type="text"
								 name="tag"
								 class="input" />
								 
						<cfselect name="tagvalue"
								  class="select_box"
								  query="allTags"
								  display="tagname"
								  value="tagname"
								  queryposition="below">
							
						</cfselect>
						<cfinput type="button" name="tag_add" value="+" class="admin_button green_admin_button" onclick="javascript:addTagToField();" />
					</li>
					<li>
						<label for="score">Ocena wypadkowa</label>

						<select name="score" id="score" class="select_box">
							<cfoutput query="scoreQuery">
								<option value="#val#" <cfif note.score EQ val> selected="selected" </cfif>>#key#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<p>Hitoria zmian</p>
						<ul>
						<cfoutput query="history">
							<li>W dniu #DateFormat(modified, "dd/mm/yyyy")# o godz #TimeFormat(modified, "HH:mm")# użytkownik #givenname# #sn# edytował/a notatkę.</li>
						</cfoutput>
						</ul>
					</li>
					<li>
						<cfinput type="submit"
								 class="admin_button green_admin_button"
								 value="Zapisz"
								 name="note_notes_filter_form_submit" />
					</li>
					
				</ol>
			</cfform>

			<div class="uiFooter">
				Idź do <a href="index.cfm?controller=note_notes&action=index" title="Lista notatek">listy notatek</a>.
				<a href="index.cfm?controller=note_notes&action=add" title="Dodaj nową notatkę">Dodaj nową notatkę</a>.
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<cfset ajaxOnLoad("initNoteNotes") />

<!---</cfdiv>--->
