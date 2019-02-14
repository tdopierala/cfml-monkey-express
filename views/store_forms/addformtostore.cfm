<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfform name="add_object_to_store_form"
					action="index.cfm?controller=store_forms&action=add-form-to-store-action">
			
			<cfinput type="submit" name="add_form_to_store_action_submit"
					 class="admin_button green_admin_button" value="Dodaj" />
			
			<div class="instance_form_ol_bg">
				<table class="uiTable aosTable leftTable halfWidth">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">&nbsp;</th>
							<th class="topBorder rightBorder bottomBorder">Sklep</th>
							<th class="topBorder rightBorder bottomBorder">Miasto</th>
							<th class="topBorder rightBorder bottomBorder">Ulica</th>
						</tr>
						<tr>
							<th class="leftBorder rightBorder bottomBorder">
								<!---<cfinput type="checkbox" name="allstores" />--->
							</th>
							<th colspan="3" class="rightBorder bottomBorder">
								<cfinput name="form_search" type="text" class="input" placeholder="Szukaj" />
							</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="sklepy">
							<cfif IsDefined("strid") and Len(strid) GT 0 and sklepy.id eq strid>
								<tr>
									<td class="leftBorder bottomBorder rightBorder">
										<cfinput type="radio" name="storeid" value="#id#" checked="checked" />
										<cfinput type="hidden" name="projekt" value="#projekt#" />
									</td>
									<td class="bottomBorder rightBorder l"><cfoutput>#projekt#</cfoutput></td>
									<td class="bottomBorder rightBorder l"><cfoutput>#miasto#</cfoutput></td>
									<td class="bottomBorder rightBorder l"><cfoutput>#ulica#</cfoutput></td>
								</tr>
							<cfelseif not IsDefined("strid")>
								<tr>
									<td class="leftBorder bottomBorder rightBorder">
										<cfinput type="radio" name="storeid" value="#id#" checked="checked" />
									</td>
									<td class="bottomBorder rightBorder l"><cfoutput>#projekt#</cfoutput></td>
									<td class="bottomBorder rightBorder l"><cfoutput>#miasto#</cfoutput></td>
									<td class="bottomBorder rightBorder l"><cfoutput>#ulica#</cfoutput></td>
								</tr>
							</cfif>
						</cfloop>
					</tbody>
				</table>
				
				<table class="uiTable aosTable rightTable halfWidth">
					<thead>
						<tr>
							<th class="leftBorder topBorder rightBorder bottomBorder">&nbsp;</th>
							<th class="topBorder rightBorder bottomBorder">Nazwa formularza</th>
							<th class="topBorder rightBorder bottomBorder">Ilość atrybutów</th>
						</tr>
						<tr>
							<th class="leftBorder bottomBorder rightBorder">
								<cfinput type="checkbox" name="allforms" />
							</th>
							<th colspan="2" class="bottomBorder rightBorder">
								<cfinput type="text" name="form_search" class="input" placeholder="Szukaj" />
							</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="formularze">
							<tr>
								<td class="leftBorder bottomBorder rightBorder">
									<cfinput type="checkbox" name="formid" value="#id#" />
								</td>
								<td class="bottomBorder rightBorder l"><cfoutput>#form_name#</cfoutput></td>
								<td class="bottomBorder rightBorder r">-</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
			
			</cfform>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<div id="uiObjectsContainer"></div>

			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
