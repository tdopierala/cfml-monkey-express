<cfprocessingdirective pageencoding="utf-8" />

<!---<cfdiv id="left_site_column">`--->

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Nowa notatka pokontrolna</h3>
		</div>
	</div>
	
	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfform name="note_notes_filter_form"
					action="#URLFor(controller='Note_notes',action='add')#"
					onsubmit="javascript:$('##notebody').val(CKEDITOR.instances['notebody'].getData())">
						
				<cfinput type="hidden" name="files" />
				<cfinput type="hidden" name="note_fileupload_url" value="index.cfm?controller=note_notes&action=upload-note-file" />
						
				<ol class="uiList uiForm">
					
					<li>
						<label for="title">Tytuł dokumentu</label>
						<cfinput type="text"
								 name="title"
								 class="input" />
					</li>
					<li>
						<label for="notetypeid">Typ notatki</label>
						<cfselect name="typeid"
								  class="select_box"
								  query="noteT"
								  display="typename"
								  value="id">
						
						</cfselect>
					</li>
					<li class="hdn">
						<label for="projekt">Numer sklepu</label>
						<cfinput type="text" name="projekt" value="" class="input" placeholder="Numer sklepu" />
					</li>
					<li class="hdn">
						<label for="inspection_date">Data kontroli</label>
						<div class="uiFormElement">
							<cfinput type="datefield" 
									 name="inspection_date"
									 placeholder="Data kontroli"
									 validate="eurodate" 
									 mask="dd/mm/yyyy" 
									 class="input"/> 
						</div>
					</li>
					<li>
						<label>Prywatna notatka</label>
						<label><input type="radio" name="isPrivate" value="0" checked="checked"> NIE</label>
						<label><input type="radio" name="isPrivate" value="1"> TAK</label>
					</li>
					<li>
						<cftextarea id="notebody" name="notebody" class="" style="resize:none;">
						</cftextarea>
					</li>
					
					<!--- Tutaj jest część, gdzie będę załączał pliki --->
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
					<!--- Koniec części, gdzie będę załączał pliki --->
					<li>
						<label for="score">Ocena wypadkowa</label>
						<cfselect name="score"
								  class="select_box"
								  query="scoreQuery"
								  display="key"
								  value="val">
								  	  
						</cfselect>
					</li>
					<li>
						<label for="tag">Tagi</label>
						<cfinput type="text"
								 name="tag"
								 class="input" />
								 
						<cfselect name="tagvalue"
								  class="select_box"
								  query="tags"
								  display="tagname"
								  value="tagname"
								  queryposition="below">
							
						</cfselect>
						<cfinput type="button" name="tag_add" value="+" class="admin_button green_admin_button" onclick="javascript:addTagToField();" /> 
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
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<cfset ajaxOnLoad("initNoteNotes") />

<!---</cfdiv>--->
