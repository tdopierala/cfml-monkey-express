<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Zgłoszenie nowej szkody</h3>
		</div>
	</div>
	
	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfform name="insurance_instances_add_form"
					action="#URLFor(controller='Insurance_instances',action='add')#"
					onsubmit="">
								
				<ol class="uiList uiForm">
					
					<li>
						<label for="title">Data szkody</label>
						<div class="uiFormElement">
							<cfinput type="datefield" 
								 name="data_szkody"
								 class="input" />
						</div>
					</li>
					<li>
						<label for="notetypeid">Data zgłoszenia szkody</label>
						<div class="uiFormElement">
							<cfinput type="datefield"
								 name="data_zgloszenia"
								 class="input" />
						</div>
					</li>
					<li>
						<label for="categoryid">Kategoria zgłoszenia</label>
						<select name="categoryid" class="select_box">
							<cfoutput query="categories">
								<option value="#id#">#categoryname#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<cfinput type="submit"
								 class="admin_button green_admin_button"
								 value="Zapisz"
								 name="insurance_instances_add_form_submit" />
					</li>
					
				</ol>
			</cfform>

			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>