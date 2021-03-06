<cfoutput>

	<div class="wrapper">
	
		<h3>Lista typów regałów</h3>
		
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
					<cfloop query="shelftypes">
						<tr>
							<td class="bottomBorder">#id#</td>
							<td class="bottomBorder">#shelftypename#</td>
							<td class="bottomBorder">
								#linkTo(
									text="usuń",
									controller="shelfTypes",
									action="delete",
									key=id,
									class="deleteShelfType",
									confirm="Czy na pewno chcesz usunć typ regału?")#
								|
								#linkTo(
									text="zobacz przypisane kategorie",
									controller="shelfTypes",
									action="shelfCategories",
									key=id,
									class="shelfCategories")#
								|
								#linkTo(
									text="przypisz kategorie",
									controller="shelfTypes",
									action="addSheftCategory",
									key=id,
									class="addShelfCategory")#
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		
		</div>
		
	</div>
	
</cfoutput>