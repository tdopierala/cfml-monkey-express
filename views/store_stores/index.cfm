<cfoutput>

	<div class="wrapper">
		<div class="admin_wrapper">
			
			<h2 class="store_index">Sklepy</h2>
			
			<cfif flashKeyExists("success")>
			    <span class="success">#flash("success")#</span>
			</cfif>
			
			<div class="admin_submenu_bar">
				
				<cfform 
					action="#URLFor(controller='store_stores',action='index',params='page=1')#">
				
					<ul class="store_filters">
						<li class="title">Typ sklepu</li>
						<li>
							<cfselect
								name="storetype_id"
								query="myStoreTypes"
								display="store_type_name"
								value="id"
								selected="#session.store_filter.storetype_id#"
								queryPosition="below"
								class="select_box" >
								
								<option value="0">[Typ sklepu]</option>
								
							</cfselect>
						</li>
						<li class="title">Lokalizacja</li>
						<li>
							<cfselect
								name="location"
								class="select_box"
								query="my_localizations"
								display="loc_mall_name"
								value="loc_mall_name"
								selected="#session.store_filter.location#"
								queryPosition="below" >
									
								<option value="0">[Lokalizacja]</option>
									
							</cfselect>
						</li>
						<li class="title">Regał</li>
						<li>
							<select name="shelfid" class="select_box">
								<option value="0">[Regał]</option>
								<cfloop query="shelfs">
									<option value="#id#" <cfif id eq session.store_filter.shelfid>selected="selected"</cfif>>#storetypename# - #shelfcategoryname# - #shelftypename#</option>
								</cfloop>
							</select>
						</li>
					</ul>
				
					<div class="clear"></div>
				
					<ul class="store_filters">
						<li class="title">Wyszukaj</li>
						<li>
							<cfinput
								name="storesearch"
								type="text"
								class="input"
								value="#session.store_filter.search#" />
						</li>
						<li>
							<cfinput
								type="submit" 
								name="submit_storefilter"
								class="admin_button green_admin_button"
								value="Znajdź" /> 
						</li>
					</ul>
				</cfform>
			</div>
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Typ sklepu</th>
						<th>Projekt</th>
						<th>Adres sklepu</th>
						<th>Lokalizacja</th>
						<th>KOS</th>
						<th class="">Typ</th>
						<th class="first">&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="stores">
						<tr>
							<td class="first">
								#linkTo(
								text="<span>pobierz dane sklepu</span>",
								controller="Store_stores",
								action="getStore",
								key=id,
								class="expand_step_forms")#
							</td>
							<td>
								<select name="storetype_id-#id#" class="select_box_small update_store_type">
									<option value="0" <cfif storetype_id EQ 0> selected</cfif>>[Typ sklepu]</option>
									<cfset tmp = storetype_id />
									<cfloop query="myStoreTypes">
										<option value="#id#" <cfif id EQ tmp> selected</cfif>>#store_type_name#</option>
									</cfloop>
								</select>
							</td>
							<td>#projekt#</td>
							<td>#adressklepu#</td>
							<td>
								<cfif Len(loc_mall_name)>
									#loc_mall_name#
								<cfelse>
									&nbsp;
								</cfif>
							</td>
							<td>
								<select name="partnerid-#id#" class="select_box_small update_store_partner">
									<option value="0" <cfif partnerid EQ 0> selected</cfif>>[KOS]</option>
									<cfset tmp = partnerid />
									<cfloop query="myStorePartners">
										<option value="#id#" <cfif id EQ tmp> selected</cfif>>#givenname# #sn#</option>
									</cfloop>
								</select>
							</td>
							
							<td>
								<select name="typeid-#id#" class="select_box_small update_store_typeid">
									<option value="0" <cfif typeid EQ 0> selected</cfif>>[TYP]</option>
									<cfset tmp2 = typeid />
									<cfloop query="instruction_types">
										<option value="#id#" <cfif id EQ tmp2> selected</cfif>>#typename#</option>
									</cfloop> 
								</select>
							</td>
							<td>
								
								<!--- Sprawdzam, czy mam uprawnienia do dodania floorplanu --->
								<a href="javascript:void(0)" class="store_add_floorplan" onclick="javascript:showCFWindow('add_floorplan-<cfoutput>#id#</cfoutput>', 'Dodaj floor plan', '<cfoutput>#URLFor(controller='Store_stores',action='iframe',key=id)#</cfoutput>', 435, 615)" title="Dodaj floor plan">
									<span>Dodaj floor plan</span>
								</a>
								
							</td>
						</tr>
					</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<th class="first">&nbsp;</th>
						<th colspan="4">
							
							<div class="places_pagination_box"> <!--- okienko paginacji --->
			
								<cfset paginator = 1 />
								<cfset count = Ceiling(stores_count.c/session.store_filter.elements) />
								<cfloop condition="paginator LESS THAN OR EQUAL TO count" >
					
									<cfif paginator eq session.store_filter.page>
				
										#linkTo(
											text="<span>#paginator#</span>",
											controller="Store_stores",
											action="index",
											key=session.user.id,
											class="active",
params="page=#paginator#&elements=#session.store_filter.elements#")#
				
									<cfelse>
					
										#linkTo(
											text="<span>#paginator#</span>",
											controller="Store_stores",
											action="index",
											key=session.user.id,
params="page=#paginator#&elements=#session.store_filter.elements#")#
					
									</cfif>
				
									<cfset paginator++ />
				
								</cfloop>
			
							</div> <!--- koniec okienka paginacji --->
							
						</th>
						
						<th colspan="3">
							Wszystkich: #stores_count.c#
							<input type="file" name="listaKos" id="listaKos" />
							<a href="javascript:void(0)" class="btn btn-green" title="Przypisz KOS do sklepu" id="przypiszKos">Zapisz</a>
						</th>
					</tr>
				</tfoot>
			</table>
			
		</div>
	</div>

</cfoutput>

<script type="text/javascript">
$(function(){
	var len = $('script').filter(function () {
		return /^.*intranet\/javascripts\/bodyimport\/store_stores.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/bodyimport/store_stores.js");
	}
});
</script>
