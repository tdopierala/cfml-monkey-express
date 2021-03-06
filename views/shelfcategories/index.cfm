<cfoutput>

	<div class="wrapper">
	
		<h3>Lista kategorii regałów</h3>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>
		
		<div class="wrapper">
		
			<table class="newtables">
				<thead>
					<tr class="top">
						<td colspan="3"></td>
					</tr>
				</thead>
				
				<tbody>
					<cfloop query="shelfcategories">
						<tr>
							<td class="bottomBorder">#id#</td>
							<td class="bottomBorder">#shelfcategoryname#</td>
							<td class="bottomBorder">
								#linkTo(
									text="usuń",
									controller="shelfCategories",
									action="delete",
									key=id,
									class="deleteShelfCategory",
									confirm="Czy na pewno chcesz usunąć kategorię regału?")#
								|
								#linkTo(
									text="zobacz przypisane typy",
									controller="shelfCategories",
									action="shelfTypes",
									key=id,
									class="shelfTypes")#
								|
								#linkTo(
									text="przypisz typ",
									controller="shelfCategories",
									action="addSheftType",
									key=id,
									class="addShelfType")#
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		
		</div>
		
	</div>
	
</cfoutput>