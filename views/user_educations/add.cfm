<cfdiv id="left_site_column">

<cfsilent>
	<cfparam name="Form.date_start" default="#dateformat(now(), 'mm/dd/yyyy')#" />
	<cfparam name="Form.date_end" default="#dateformat(now(), 'mm/dd/yyyy')#" />
</cfsilent>

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Dodaj element do ścieżki edukacji</h3>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfif flashKeyExists("msg")>
				<span class="success"><cfoutput>#flash("msg")#</cfoutput></span>
			</cfif>

			<cfform name="user_education_add_form"
					action="#URLFor(controller='User_educations',action='add')#" >
				
				<ol class="uiList uiForm">
					<li>
						<label for="education_stageid">Typ szkoły</label>
						<cfselect
							name="education_stageid"
							query="stages"
							value="id"
							display="stage_name"
							class="select_box"
							queryPosition="below" >
						
							<option value="0">[Typ szkoły]</option>
						
						</cfselect>
					</li>
					<li>
						<label for="education_institutionid">Nazwa szkoły</label>
						<cfselect
							name="education_institutionid"
							query="institutions"
							value="id"
							display="institution"
							class="select_box_size"
							queryPosition="below"> 
							
							<option value="0">[Nazwa szkoły]</option>
							
						</cfselect>
						
						lub 
						
						<cfinput type="text"
								 name="institution_name"
								 class="input"
								 placeholder="Wpisz nazwę jeżeli nie ma jej na liście rozwijanej" />
					</li>
					<li>
						<label for="date_start">Data rozpoczęcia</label>
						<div class="uiFormElement">
							<cfinput 
								type="dateField" 
								name="date_start"  
								class="input"
								value="#Form.date_start#"
								mask="dd/mm/yyyy" />
						</div>
					</li>
					<li>
						<label for="date_end">Data zakończenia</label>
						<div class="uiFormElement">
							<cfinput 
								type="dateField" 
								name="date_end"  
								class="input"
								value="#Form.date_end#"
								mask="dd/mm/yyyy" />
						</div>
					</li>
					<li>
						<label for="course">Kierunek</label>
						<cfinput type="text"
								 class="input"
								 name="course"
								 placeholder="Np. Informatyka" />
					</li>
					<li>
						<label for="specialization">Specjalizacja</label>
						<cfinput type="text"
								 class="input"
								 name="specialization"
								 placeholder="Np. Inzynieria oprogramowania" />
					</li>
					<li>
						<label for="education_degreeid">Uzyskany tytuł</label>
						<cfselect name="education_degreeid"
								  query="degrees"
								  value="id"
								  display="degree_name"
								  class="select_box"
								  queryPosition="below">
								
							<option value="0">[Uzyskany tytuł]</option>
								
						</cfselect> 
					</li>
					<li>
						<cfinput type="submit" 
								 name="user_education_add_form_submit"
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