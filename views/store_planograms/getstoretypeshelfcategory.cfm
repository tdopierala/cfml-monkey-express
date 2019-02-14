<cfprocessingdirective pageEncoding="utf-8" />

<tr>
	
	<td class="first">&nbsp;</td>
	<td class="admin_submenu_options">
		
		<table class="admin_table">
			<thead>
				<tr>
					<th class="first">&nbsp;</th>
					<th>Kategoria regału</th>
				</tr>
			</thead>
			<tbody>
				<cfloop query="myShelfCategories">
					<tr>
						<td>
							<a 
								href="index.cfm?controller=store_planograms&action=get-shelf-category-types&key=<cfoutput>#shelfcategoryid#</cfoutput>&storetypeid=<cfoutput>#storetypeid#</cfoutput>"
								class="expand_step_forms"
								title="Pobierz typy regałów">
							
								<span>Pobierz typy regałów</span>
									
							</a>
						</td>
						<td><cfoutput>#shelfcategoryname#</cfoutput></td>
					</tr>
				</cfloop>
			</tbody>
	</td>
	
</tr>