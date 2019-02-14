<cfoutput>

	<div class="wrapper">
		
		<h3>Dodatkowe ekspozycje produktów</h3>
		
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		<cfelseif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_index" >
			<cfinvokeargument name="groupname" value="Nowe indeksy" />Nowe indeksy
		</cfinvoke>
		
		<cfif _index is true>
			<ol class="productlinks">
				<li>#linkTo(text="Dodaj nową ekspozycję", action="expo-add")#</li>
			</ol>
		</cfif>
		
		<!---<div class="product-filter filter">
			<h5>Filtruj indeksy wg kryteriów</h5>
			<div class="product-filter-field">
				#textFieldTag(
					name="datefrom",
					
					class="input product_date",
					placeholder="data od")#
			</div>
			<div class="product-filter-field">
				#textFieldTag(
					name="dateto",
				
					class="input product_date",
					placeholder="data do")#
			</div>
			<div class="product-filter-field product-xls-export">
				#linkTo(
					text=imageTag("excel-icon.png")&" Eksport do pliku *.xls",
					href="##",
					class="product_xls")#
			</div>
			<div style="clear:both"></div>
			
			<div class="product-filter-field" style="width:300px;padding:10px 15px;">
				#selectTag(
					name="category",
					options=categories,
					includeBlank="-- wybierz --",
					label="Kategoria planogramu",
					labelPlacement="before", 
					class="product_select")#
			</div>
			
			<div style="clear:both"></div>
		</div>--->
		
		<table id="products-table" class="tables products-table">
			<thead>
				<tr>
					<th>Nr</th>
					<th>Cel wprowadzenia</th>
					<th>Indeks</th>
					<th>Producent</th>
					<th>Okres trwania</th>
					<th>Etap</th>
					<th></th>
				</tr>
				<!---<tr>
					<td colspan="2"></td>
					<td>#textFieldTag(name="pn")#</td>
					<td></td>
					<td>#selectTag(name="pt", options=productType, includeBlank=" - wszystkie - ")#</td>
					<td>#selectTag(name="pu", options=users, includeBlank=" - wszyscy - ")#</td>
					<td>#selectTag(name="ps", options=statuses, selected=params.ps, includeBlank=" - wszystkie - ")#</td>
					<td></td>
				</tr>--->
			</thead>
			<tbody>
				<!---#includePartial("index")#--->
				<cfloop query="expo">
					<tr>
						<td>#id#</td>
						<td>#purpose#</td>
						<td>#ean#</td>
						<td>#producer#</td>
						<td>#DateFormat(termbegin, "yyyy-mm-dd")# - #DateFormat(termend, "yyyy-mm-dd")#</td>
						<td>#stepname#</td>
						<td>#linkTo(text="Podgląd",action="expo-view",key=id)#</td>
					</tr>
				</cfloop>
			</tbody>
		</table>
		
		<div class="product-paginator"></div>
		
	</div>
	
</cfoutput>