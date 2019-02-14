<cfoutput>
	
	<div class="wrapper">
		
		<cfif flashKeyExists("success")>
	    	<span class="success">#flash("success")#</span>
		</cfif>
		
		<h3>Zmiana statusu pomysłu</h3>
		
		#startFormTag(action="change-status")#
		
			#hiddenField(objectName="idea", property="id")#
		
			<div class="forms ideaForm">
				<ol>
					<li class="title">Formularz zmiany statusu</li>
					<li>
						#select(objectName="idea", property="statusid", options=statuses, label="Status:", labelPlacement="before")#
					</li>
					<li>
						#textArea(objectName="idea", property="statusdesc", label="Komentarz do zmiany (opcjonalny)", labelPlacement="before", class="textarea ckeditor")#
					</li>
					<li>
						#submitTag(value="Zapisz", class="formButton button redButton")#
					</li>
				</ol>
			</div>
		
		#endFormTag()#
	</div>
	
</cfoutput>