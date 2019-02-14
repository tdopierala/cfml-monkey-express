<cfprocessingdirective pageEncoding="utf-8" />

<div class="cfwindow_container">
	<div class="inner">
		
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Dodaj użytkownika do struktury</h3>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			<cfform
				action="#URLFor(controller='Place_tree_privileges',action='addUser')#"
				name="place_tree_privilege_form"
				onsubmit="" >
					
			<ul class="uiList uiForm">
			
			<li>
				<label for="user">Użytkownik</label>
				<cfinput
					name="user"
					class="input"
					label="false" />
				
				<select name="userid" class="select_box user_select_box required" id="userid">
				</select>
			</li>
			
			<li>
				<label for="provinceid">Województwo</label>
				<cfselect
					name="provinceid"
					query="provinces"
					value="id"
					display="provincename"
					class="select_box required"
					queryPosition="below" >
				
					<option value="">[wybierz]</option>
				
				</cfselect>
			</li>
			
			<li>
				<label for="districtid">Powiat</label>
				<select id="districtid" name="districtid" class="select_box place_tree_privilege place_distincts required">
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
		
		</div>
	</div>

	<div class="footerArea">

	</div>
	
	</div>
</div>

<cfset ajaxOnLoad("searchUser") />
<cfset ajaxOnLoad("provinceChange") />
<cfset ajaxOnLoad("validatePrivileges") />