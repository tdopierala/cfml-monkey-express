<cfoutput>
	
	<div class="wrapper">
		<div class="admin_wrapper">
			
			<h2 class="admin_planograms">Lista planogramów</h2>
			
			<div class="admin_submenu_bar">
				
				<cfform
					name="storeplanogramsform"
					action="" >
				
				<ul class="store_filters">
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
					
					<li>
						<cfselect
							name="location"
							class="select_box"
							query="my_locations"
							display="loc_mall_name"
							value="loc_mall_name"
							queryPosition="below" >
								
							<option value="0">[Lokalizacja]</option>
								
						</cfselect>
					</li>
					
					<li>
						<cfselect
							name="shelfcategoryid"
							class="select_box"
							query="myShelfCategories"
							display="shelfcategoryname"
							value="id"
							queryPosition="below" >
								
							<option value="0">[Kategoria regału]</option>
								
						</cfselect> 
					</li>
					
					<li>
						<cfselect
							name="shelftypeid"
							class="select_box"
							query="myShelfTypes"
							display="shelftypename"
							value="id"
							queryPosition="below">
								
							<option value="0">[Typ regału]</option>
								
						</cfselect>
					</li>

					<!---<li class="title">Regał</li>
					<li>
						<select name="shelfid" class="select_box">
							<option value="0">-- wszystkie --</option>
							<cfloop query="shelfs">
								<option value="#id#" <cfif id eq session.store_filter.shelfid>selected="selected"</cfif>>#shelfcategoryname# - #shelftypename#</option>
							</cfloop>
						</select>
					</li>--->
				</ul>

				<div class="clear"></div>
				
				<ul class="store_filters">
					<li class="title">Wyszukaj</li>
					<li>
						<cfinput
							type="text"
							class="input"
							name="search"
							value="#session.store_filter.search#" />
					</li>
					<li>
						<cfinput
							type="submit"
							name="storeplanogramsubmit"
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
					</tr>
				</thead>
				<tbody>
					<cfloop query="myStoreTypes">
						<tr>
							<td>
								<a 
									href="index.cfm?controller=store_planograms&action=get-store-type-shelf-category&key=#id#"
									class="expand_step_forms"
									title="Pobierz kategorie regałów">
										
									<span>Pobierz kategorie regałów</span>
											
								</a>

							</td>
							<td>
								#store_type_name#
							</td>
						</tr>
					</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="2">
							Raporty: 
							<a href="#URLFor(controller='Store_planograms',action='reportAllStores')#" title="Raport ze wszystkich sklepów" target="_blank">Wszystkie sklepy</a>
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
		return /^.*intranet\/javascripts\/bodyimport\/store_planograms.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/bodyimport/store_planograms.js");
	}
});
</script>