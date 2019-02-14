<cfprocessingdirective pageencoding="utf-8" />
	
<cfdiv id="left_site_column">

<cfsilent>
</cfsilent>

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Dodaj element do kursów i szkoleń</h3>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfif flashKeyExists("msg")>
				<span class="success"><cfoutput>#flash("msg")#</cfoutput></span>
			</cfif>

			<cfform name="user_course_add_form"
					action="#URLFor(controller='User_educations',action='addCourse')#"
					enctype="multipart/form-data" >
				
				<cfinput type="hidden" name="file_name" />
				<cfinput type="hidden" name="file_src" /> 
				
				<ol class="uiList uiForm">
					<li>
						<label for="course_name">Nazwa kursu/szkolenia</label>
						<cfinput type="text"
								 name="course_name"
								 class="input"
								 placeholder="" />
						
					</li>
					<li>
						<label for="course_certificate_name">Nazwa certyfikatu</label>
						<cfinput type="text"
								 name="course_certificate_name"
								 class="input"
								 placeholder="" />
					</li>
					<li>
						<label for="course_stand_from">Data ważności certyfikatu</label>
						<div class="uiFormElement">
							<cfinput 
								type="dateField" 
								name="course_stand_from"  
								class="input"
								placeholder="od:"/>
							
							<cfinput 
								type="dateField" 
								name="course_stand_to"  
								class="input"
								placeholder="do:"/>
						</div>
					</li>
					<li>
						<label for="course_date_from">Data odbycia kursu/szkolenia</label>
						<div class="uiFormElement">
							<cfinput 
								type="dateField" 
								name="course_date_from"  
								class="input"
								placeholder="od:"/>
							
							<cfinput 
								type="dateField" 
								name="course_date_to"  
								class="input"
								placeholder="do:" />
						</div>
					</li>
					<li>
						<label for="course_certificate_number">Numer certyfikatu</label>
						<cfinput type="text"
							 class="input"
							 name="course_certificate_number"
							 placeholder="" />
					</li>
					<li>
						<label for="course_file">Certyfikat</label>
						<cfinput type="file" name="file" /> 
						<cfinput type="button" 
								 name="submit_course_file" 
								 value="Dodaj"
								 onclick="return initAjaxFileUpload()" /> 
					</li>
					<li class="coursePreview" style="display:none;"></li>
					<li>
						<cfinput type="submit"
								 name="user_course_add_form"
								 class="admin_button green_admin_button"
								 value="Zapisz" />
					</li>
				</ol>
				
			</cfform>

			<div class="uiFooter">
				<a href="<cfoutput>#URLFor(controller='User_educations',action='index')#</cfoutput>" title="Zobacz ścieżkę edukacji">Zobacz ścieżkę edukacji</a>.
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>



</cfdiv>