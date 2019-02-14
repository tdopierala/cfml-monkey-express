<cfprocessingdirective pageEncoding="utf-8" />

<div class="cfwindow_container">
	<div class="inner">
		
		<div class="headerArea">
			<div class="headerArea uiHeader">
				<h3 class="uiHeaderTitle">Przypisz powiaty</h3>
			</div>
		</div>
		
		<div class="contentArea">
			<div class="contentArea uiContent">
				<cfform
					action="#URLFor(controller='Place_tree_privileges',action='userDistricts',key=userid)#"
					name="place_tree_privilege_form"
					onsubmit="" >
						
				<cfinput 
					type="hidden"
					name="userid"
					value="#userid#" />
					
				<ul class="uiList uiForm">
			
				<li>
					<label for="provinceid">Województwo</label>
					<cfselect
						name="provinceid"
						query="provinces"
						value="id"
						display="provincename"
						class="select_box"
						queryPosition="below" >
				
						<option value="0">[wybierz]</option>
				
					</cfselect>
				</li>
			
				<li>
					<label for="districtid">Powiat</label>
					<select id="districtid" name="districtid" class="select_box place_tree_privilege place_distincts">
					</select>
				</li>
			
				<li>
					<cfinput
						type="submit"
						name="place_tree_privilege_form_submit"
						value="Zapisz"
						class="admin_button green_admin_button" />
				</li>
			
				</ul>
				</cfform>

				<div class="uiFooter">
				
				</div>
			
			</div> <!--- end contentArea uiContent --->
		</div><!--- end contentArea --->

		<div class="footerArea">

			<ul class="uiList placeTreeList">

				<cfscript>
					for(
						i = 1;
						i LTE userDistricts.RecordCount;
						i = i + 1) {
					
						writeOutput("
							<li>
								<span class=""uiListElement"">
									#userDistricts['provincename'][i]# #userDistricts['districtname'][i]#
								</span>
								<a href=""#URLFor(controller='Place_tree_privileges',action='removeUserDistrict',key=userDistricts['id'][i])#"" class=""remove remove_distinct"">x</a>
							</li>
						");
							
					}
				</cfscript>

			</ul>

		</div> <!--- end footerArea --->

	</div> <!--- end inner --->
</div>

<cfset ajaxOnLoad("provinceChange") />
<cfset ajaxOnLoad("removeUserDistrict") />