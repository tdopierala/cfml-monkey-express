<cfoutput>
	
	<div class="wrapper formbox concession-attributes license">
		
		<ol>
			<li>
				<label>Typ zezwolenia</label> <span>#concessionType['name'][license.typeid]#</span>
			</li>
			<li>
				<label>Nr zezwolenia</label> <span>#license.documentnr#</span>
			</li>
			<li>
				<label>Data wydania</label> <span>#DateFormat(license.dateofissue, 'yyyy-mm-dd')#</span>
			</li>
			<li>
				<label>Wydany przez</label> <span>#license.issuedby#</span>
			</li>
			<li>
				<label>Data obowiązywania od</label> <span>#DateFormat(license.datefrom, 'yyyy-mm-dd')#</span>
			</li>
			<li>
				<label>Data obowiązywania do</label> <span>#DateFormat(license.dateto, 'yyyy-mm-dd')#</span>
			</li>
			<li>
				<label>Załącznik</label> <span class="file">#license.file#</span>
			</li>
		</ol>
		
	</div>
	
</cfoutput>