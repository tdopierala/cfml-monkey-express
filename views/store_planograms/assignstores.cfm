<cfoutput>
	
	<div class="wrapper">
		<div class="admin_wrapper">
			
			<h2>Przypisz planogram do sklepów</h2>
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Atrybut</th>
						<th>Wartość</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td class="first">&nbsp;</td>
						<td>Notatka</td>
						<td>#my_planogram.note#</td>
					</tr>
					<tr>
						<td class="first">&nbsp;</td>
						<td>Data utworzenia</td>
						<td>#my_planogram.created#</td>
					</tr>
					<tr>
						<td colspan="3" class="c b">Pliki do pobrania</td>
					</tr>
					<cfloop query="my_planogram_files">
						<tr>
							<td class="first">&nbsp;</td>
							<td>Link</td>
							<td>
								#linkTo(
									text=filename,
									href="files/planograms/#filename#",
									target="_blank")#
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
			
			<div class="admin_submenu_bar">
				
				<cfform
					action="#URLFor(controller='Store_planograms',action='assignStores',key=my_planogram.id)#" >
				
				<ul class="store_filters">
					<li class="title">Lokalizacja</li>
					<li>
						<cfselect
							name="location"
							class="select_box"
							query="my_locations"
							display="loc_mall_name"
							value="loc_mall_name"
							selected="#session.store_filter.location#" >
								
						</cfselect>		  
					</li>
				</ul>
				
				<ul class="store_filters">
					<li class="title">Regał</li>
					<li>
						<select name="shelfid" class="select_box">
							<option value="0">-- wszystkie --</option>
							<cfloop query="shelfs">
								<option value="#id#" <cfif id eq session.store_filter.shelfid>selected="selected"</cfif>>#shelfcategoryname# - #shelftypename#</option>
							</cfloop>
						</select>
					</li>
				</ul>
				
				<ul class="store_filters">
					<li class="title">Wyszukaj</li>
					<li>
						<cfinput
							type="text"
							name="search"
							class="input" />
					</li>
					<li>
						<cfinput
							type="submit"
							name="planogramstoresubmit"
							value="Wyszukaj"
							class="admin_button green_admin_button" />
					</li>
				</ul>
				
				</cfform>
				
			</div>
			
			<cfform
				action="#URLFor(controller='Store_planograms',action='actionAssignStores')#" >
			
			<cfinput 
				name="planogramid" 
				value="#my_planogram.id#" 
				type="hidden" />
			
			<table class="admin_table">
				<thead>
					<tr>
						<th class="first">&nbsp;</th>
						<th>Sklep</th>
						<th>Adres sklepu</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="stores">
						<tr>
							<td class="first">
								<cfinput
									type="checkbox" 
									name="storeid[#id#]"
									value="#id#" /> 
							</td>
							<td>#projekt#</td>
							<td>#adressklepu#</td>
						</tr>
					</cfloop>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="3" class="r">
							<cfinput
								name="assignstoressubmit"
								type="submit"
								class="admin_button green_admin_button"
								value="Zapisz" />
						</th>
					</tr>
				</tfoot>
			</table>
			
			</cfform>
			
		</div>
	</div>
	
</cfoutput>