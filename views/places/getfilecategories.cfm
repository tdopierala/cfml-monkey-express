<div class="fileplaceform horizontal">
	<cfoutput>
		#startFormTag(controller="Places",action="actionAddFile",key=fileid,class="filetoplaceform",id="filetoplace-#fileid#")#
		#hiddenFieldTag(name="placeid",value=placeid,id="placeid-#placeid#")#
		#hiddenFieldTag(name="fileid",value=fileid,id="fileid-#fileid#")#
		<ol class="">
			<li>
				
				<label for="placefilecategories">Kategoria pliku</label>
				<select class="placefilecategories" name="placefilecategories">	
					<cfloop query="filecategories">
						<option value="#id#">#placefilecategoryname#</option>
					</cfloop>
				</select>
			
			</li>
			<li>
				
				#textAreaTag(
					name="comment",
					value="",
					class="textarea",
					label="Komentarz do pliku",
					labelPlacement="before")#
				
			</li>
			<li>
				#submitTag(value="Dodaj",class="smallButton redSmallButton submitfiletoplace")#
			</li>
		</ol>
		#endFormTag()#
	</cfoutput>
</div>
<div class="clear"></div>