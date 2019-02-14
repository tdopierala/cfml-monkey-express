<cfoutput>

	<div class="wrapper">
	
		<h3>Dodaj nowy regał</h3>
	
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		</cfif>
	
		<div class="forms">
		
			#startFormTag(action="actionAdd")#
			
				<ol class="horizontal">
					<li>
						#select(
							objectName="shelf",
							property="shelftypeid",
							options=shelftypes,
							label="Typ regału",
							labelPlacement="before")#
					</li>
					
					<li>
						#select(
							objectName="shelf",
							property="shelfcategoryid",
							options=shelfcategories,
							label="Kategoria regału",
							labelPlacement="before")#
					</li>
					
					<li>
						#submitTag(value="Zapisz",class="button redButton")#
					</li>	
				</ol>
			
			#endFormTag()#
		
		</div>
	
	</div>
	
</cfoutput>