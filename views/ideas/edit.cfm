<cfoutput>
	
	<div class="wrapper">
		
		<cfif flashKeyExists("success")>
	    	<span class="success">#flash("success")#</span>
		</cfif>
		
		<h3>Edycja treści pomysłu</h3>
		
		#startFormTag(action="update")#
		
			#hiddenField(objectName="text", property="id")#
			
			<div class="forms ideaForm">
				<ol>
					<li class="title">Edycja treści</li>
					<li>
						<span>Nazwa pomysłu</span>
						<h4>#text.idea.title#</h4>
					</li>
					<li>
						#textArea(objectName="text", property="text", label="Treść pomysłu", labelPlacement="before", class="textarea ckeditor")#
					</li>
					<li>
						#textArea(objectName="text", property="reason", label="Treść pomysłu", labelPlacement="before", class="textarea ckeditor")#
					</li>
					<li>
						#submitTag(value="Wyślij", class="formButton button redButton")#
					</li>
				</ol>
			</div>
		
		#endFormTag()#
	</div>
	
</cfoutput>