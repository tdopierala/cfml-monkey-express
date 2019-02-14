<cfprocessingdirective pageencoding="utf-8" />

<div class="new_material_description">
	
	<span class="close_curtain">[zamknij]</span>

	<h5>Nowe pytanie</h5>
	<cfform name="insurance_new_question_form"
		action="#URLFor(controller='Insurance_questions',action='add')#">
	
		<ol class="vertical">
			<li>
				<label for="question">Pytanie</label>
				<cfinput type="text"
					 name="question"
					 class="input" />
			</li>
			<li>
				<label for="questiontypeid">Typ pytania</label>
				<select name="questiontypeid" id="questiontypeid" class="select_box">
					<cfoutput query="questiontypes">
						<option value="#id#">#questiontypename#</option>"
					</cfoutput>
				</select>
			</li>
			<li>
				<label for="categoryid">Kategoria zgłoszenia</label>
				<select name="categoryid" id="categoryid" class="select_box">
					<cfoutput query="categories">
						<option value="#id#">#categoryname#</option>
					</cfoutput>
				</select>
			</li>
			<li>
				<cfinput type="submit" name="insurance_new_question_form_submit" class="admin_button green_admin_button" value="Zapisz" />
			</li>
		</ol>
	
	</cfform>

</div>