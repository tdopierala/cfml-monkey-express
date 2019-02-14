<cfoutput>
	<div class="preview-partial">
		<h4>#student.name#</h4>
		<ol>
			<li>
				<label>Status</label> <span>
					<!---#attributeoptions['name'][student.type]#--->
				</span></li>
			<li>
				<label>Email</label> <span>
					<cfif student.email neq ''>
						#student.email#
					<cfelse>
						--
					</cfif>
				</span></li>
			<li>
				<label>Telefon</label> <span>
					<cfif student.phone neq ''>
						#student.phone#
					<cfelse>
						--
					</cfif>
				</span></li>
			<li>
				<label>Adres</label> <span>
					<cfif student.adress neq ''>
						#student.adress#
					<cfelse>
						--
					</cfif>
				</span></li>
			<li>
				<label>Nr dowodu</label> <span>
					<cfif student.docid neq ''>
						#student.docid#
					<cfelse>
						--
					</cfif>
				</span></li>
			<li>
				<label>Pesel</label> <span>
					<cfif student.pesel neq ''>
						#student.pesel#
					<cfelse>
						--
					</cfif>
				</span></li>
			<li>
				<label>NIP</label> <span>
					<cfif student.nip neq ''>
						#student.nip#
					<cfelse>
						--
					</cfif>
				</span></li>
		</ol>
	</div>
</cfoutput>
