<cfsilent>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Uprawnienia w teczkach dokumentów</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			<div class="folderContent">
				<table class="uiTable aosTable">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">Katalog</th>
							<th colspan="2" class="topBorder rightBorder bottomBorder">Uprawnienia</th>
						</tr>
						<tr>
							<th class="bottomBorder leftBorder rightBorder l">
								<cfform name="folder_users_privilege_form"
										action="##">
									<ol class="vertical">
										<li>
											<cfinput type="text" class="usersearch input" name="usersearch"
													 placeholder="Wyszukaj użytkownika" />
											<select
												name="userid"
												id="userid"
												class="select_box">
											</select>
										</li>
									</ol>
								</cfform>
							</th>
							<th class="bottomBorder rightBorder">Odczyt</th>
							<th class="bottomBorder rightBorder">Zapis</th>
						</tr>
					</thead>
					<tbody>
						<cfoutput query="foldery">
							<tr>
								<td class="leftBorder bottomBorder rightBorder l table-icon-folder">
									<span class="level-#level#">
										#folder_name#
									</span>
								</td>
								<td class="bottomBorder rightBorder">
									<input type="checkbox" class="folder_access privilege_read {id:#id#, lft:#lft#, rgt:#rgt#}" 
										   value="1" name="privilege_read-#id#" />
								</td>
								<td class="bottomBorder rightBorder">
									<input type="checkbox" class="folder_access privilege_write {id:#id#, lft:#lft#, rgt:#rgt#}" 
										   value="1" name="privilege_write-#id#" />
								</td>
							</tr>
						</cfoutput>
					</tbody>
				</table>
			</div>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>

<cfset ajaxOnLoad("initFolders") />