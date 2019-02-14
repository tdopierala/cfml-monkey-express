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
					action="index.cfm?controller=store_objects&action=add-object-to-store-form-fill">
			
			<cfinput type="submit" name="add_object_to_store_form_submit"
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
								<cfinput name="object_search" type="text" class="input" placeholder="Szukaj" />
							</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="sklepy">
							<cfif IsDefined("strid") and Len(strid) GT 0 and sklepy.id eq storeid>
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
							<th class="topBorder rightBorder bottomBorder">Nazwa obiektu</th>
							<th class="topBorder rightBorder bottomBorder">Ilość</th>
						</tr>
						<tr>
							<th class="leftBorder bottomBorder rightBorder">
								<cfinput type="checkbox" name="allobjects" />
							</th>
							<th colspan="2" class="bottomBorder rightBorder">
								<cfinput type="text" name="attribute_search" class="input" placeholder="Szukaj" />
							</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="obiekty">
							<tr>
								<td class="leftBorder bottomBorder rightBorder">
									<cfinput type="checkbox" name="objectid" value="#id#" />
								</td>
								<td class="bottomBorder rightBorder l"><cfoutput>#object_name#</cfoutput></td>
								<td class="bottomBorder rightBorder r"><cfinput type="text" name="obj#id#" value="1" class="inputVSmall" /></td>
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
