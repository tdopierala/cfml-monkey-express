<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="pps">
		<cfinvokeargument name="groupname" value="Partner prowadzacy sklep" />
	</cfinvoke>
</cfsilent>

<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Wewnętrzne akty prawne</h3>
	</div>
</div>

<div class="headerNavArea">
	<div class="headerNavArea uiHeaderNavArea">
		<div class="workflow_filter_div">
			<cfform 
				name="instruction_index_form"
				action="#URLFor(controller="Instructions",action="index")#">
				<table class="workflow_filter_table">
					<tbody>
						<tr>
							<td class="label_column">Departament</td>
							<td class="value_column">
								<cfselect
									name="department_name"
									query="departments"
									value="selectvalue"
									display="selectvalue"
									class="select_box"
									queryPosition="below"
									selected="#session.instruction_filter.department_name#">
								
									<option value="">[wybierz]</option>
								
								</cfselect>
									
							</td>
							<td class="label_column">Dokument</td>
							<td class="value_column">
								
								<select
									name="documenttypeid"
									class="select_box">
								
									<option value="">[wybierz]</option>
									<cfloop query="documenttypes">
										<option value="<cfoutput>#id#</cfoutput>" <cfif session.instruction_filter.documenttypeid EQ documenttypes.id> selected="selected" </cfif>><cfoutput>#documenttypename#</cfoutput></option>
									</cfloop>
										
								</select>
								
							</td>
							
							<cfif pps is false>
							
								<td class="label_column">Typ</td>
								<td class="value_column">
									
									<select
										name="typeid"
										class="select_box">
										
										<option value="0">[wybierz]</option>
										
										<cfloop query="instruction_types">
											<option value="<cfoutput>#id#</cfoutput>" <cfif session.instruction_filter.typeid EQ instruction_types.id> selected="selected" </cfif>><cfoutput>#typename#</cfoutput></option>
										</cfloop>
											
									</select>
									
								</td>
							
							</cfif>
							
							<td class="label_column">
								<cfinput
									name="instruction_filter_form_submit"
									type="submit"
									class="admin_button small_green_admin_button"
									value="Filtruj" />
							</td>
						</tr>
					</tbody>
				</table>
			</cfform>
		</div>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		<ul class="uiList">
			<cfloop query="myinstructions">
				<li>


					<a
						href="<cfoutput>#URLFor(controller='Instructions',action='view',key=instruction_id)#</cfoutput>"
						title="Pobierz plik <cfoutput>#instruction_number#</cfoutput>"
						class="uiListLink clearfix"
						target="_blank">
						<h3 class="uiListItemLabel">
							<cfoutput>#instruction_number#</cfoutput>
						</h3>

						<span class="uiListItemContent i">
							<cfoutput>#documenttypename#</cfoutput>
						</span>

						<span class="uiListItemContent">
							<cfoutput>#instruction_about#</cfoutput>
						</span>

						<span class="uiListItemIcon uiListItemRight">
							<cfoutput>#DateFormat(instruction_created, "dd.mm.yyyy")#</cfoutput>
						</span>

					</a>
						
					<!---<a href="javascript:void(0)"
						onclick="javascript:showCFWindow('instruction-<cfoutput>#instruction_id#</cfoutput>', 'Podgląd dokumentu', 'index.cfm?controller=instructions&action=preview&key=<cfoutput>#instruction_id#</cfoutput>', 600, 320);"
						title="Podgląd dokumentu <cfoutput>#instruction_number#</cfoutput>"
						class="clearfix uiListLink preview {key:<cfoutput>#instruction_id#</cfoutput>}">
						
						<span class="uiListItemPreview prevInstruction {key:<cfoutput>#instruction_id#</cfoutput>}">
							Podgląd
						</span>
						
					</a>--->
					
					<a href="<cfoutput>#URLFor(controller='instructions',action='preview',key=instruction_id)#</cfoutput>" title="Podgląd dokumentu <cfoutput>#instruction_number#</cfoutput>" class="clearfix uiListLink preview {key:<cfoutput>#instruction_id#</cfoutput>}" target="_blank">
							
						<span class="uiListItemPreview prevInstruction {key:<cfoutput>#instruction_id#</cfoutput>}">
							Podgląd
						</span>
							
					</a>

				</li>
			</cfloop>
		</ul>

		<div class="uiFooter">

			<div> <!--- okienko paginacji --->

				<cfset paginator = 1 />
				<cfset pages_count = Ceiling(instructionsCount.c/session.instruction_filter.elements) />
				<cfloop condition="paginator LESS THAN OR EQUAL TO pages_count" >

					<a
						href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller='Instructions',action='index',params='page=#paginator#&elements=#session.instruction_filter.elements#')#</cfoutput>', 'user_profile_cfdiv');"
					title="<cfoutput>#paginator#</cfoutput>"
					class="uiPaginatorLink clearfix <cfif paginator eq session.instruction_filter.page> active </cfif>">
						<span class="uiListItemLabel">
							<cfoutput>#paginator#</cfoutput>
						</span>
					</a>

					<cfset paginator++ />

				</cfloop>

			</div> <!--- koniec okienka paginacji --->

			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
				<cfinvokeargument name="groupname" value="Dodawanie aktów prawnych" />
			</cfinvoke>
			
			<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaDyrektor" >
				<cfinvokeargument name="groupname" value="Dyrektorzy" />
			</cfinvoke>

			<cfif (priv is true) OR (uprawnieniaDyrektor is true)>

			<a
				href="<cfoutput>#URLFor(controller='Instructions',action='add')#</cfoutput>"
				title="Dodaj nowy dokument"
				class="">

					Dodaj nowy dokument do Wewnętrznych aktów prawnych.

			</a>

			</cfif>

		</div>
	</div>
</div>

<div class="footerArea">

</div>
