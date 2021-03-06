<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Dodaj nową aktualność</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		<cfform
			action="#URLFor(controller='Posts',action='actionAdd')#"
			name="new_post_form"
			enctype="multipart/form-data"
			onsubmit="javascript:$('##postcontent').val(CKEDITOR.instances['postcontent'].getData())" >
		<ul class="uiList uiForm">
			
			<li>
				<label for="posttitle">Nagłówek aktualności</label>
				<cfinput
					name="posttitle"
					class="input"
					label="false" />
			</li>
			
			<li>
				<label for="file">Plik do pobrania</label>
				<cffileupload
					url="#URLFor(controller='Posts',action='addFile')#"
					progressbar="true"
					name="file"
					addButtonLabel="Dodaj plik"
					clearButtonlabel="Wyczyść" 
					hideUploadButton="false"
					oncomplete="postAfterUploadFile"
					height=200
					width=720
					title="Załączniki" 
					maxuploadsize="1"
					extensionfilter="*.pdf,*.png"
					bgcolor="##ffffff"
					MAXFILESELECT=10
					UPLOADBUTTONLABEL="Zapisz pliki"
					deletebuttonlabel="Usuń"/>
			</li>
			
			<li>
				<label for="postcontent">Treść aktualności</label>
				<cftextarea 
					name="postcontent"
					class="textarea ckeditor" >
								
				</cftextarea>
			</li>
			
			<li>
				<cfset dir = DirectoryList(ExpandPath("files/posts/thumb/"), false, "name", "", "datelastmodified DESC") />
				<cfloop array="#dir#" index="singlefile" >
					<cfset tmp_img = imageNew("#ExpandPath("files/posts/thumb/#singlefile#")#") />
					<cfset imageResize(tmp_img, "", "50", "highestperformance") />
					<div class="postimage c">
						<cfimage action="writeToBrowser" source="#tmp_img#" /> <br />
						<cfinput 
							name="filename"
							type="radio"
							value="#singlefile#" />
					</div>
				</cfloop>
			</li>
			
			<li>
				<p>Widoczność aktualności</p>
				
				<ol class="darkFrame">
					<cfloop query="privileges">
						<cfoutput>
							<li class="level-#level#">
								<cfinput type="checkbox" name="groupid" value="#id#" class="instructionGroupPrivilege {level: #level#}" /> #groupname#
							</li>
						</cfoutput>
					</cfloop>
						<cfif session.user.id eq 345> 
							<li class="level-4">
								<cfinput type="checkbox" name="groupid" value="21" class="instructionGroupPrivilege {level: 4}" /> root
							</li>
						</cfif>
				</ol>
				
				<!---<p class="instruction_group_checkbox">
					<cfinput
						type="checkbox"
						name="centrala"
						value="1" />
					<label for="centrala">Centrala</label>
				</p>--->

				<!---<p class="instruction_group_checkbox">
					<cfinput
						name="partner_prowadzacy_sklep"
						type="checkbox"
						value="1" />
					<label for="partner_prowadzacy_sklep">Partner prowadzący sklep</label>
				</p>--->
	
			</li>
			
			<li>
				<cfinput
					type="submit"
					name="new_post_form_submit"
					value="Zapisz"
					class="admin_button green_admin_button" />
			</li>
			
		</ul>
		</cfform>

		<div class="uiFooter">
			<a
				href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Posts",action="add")#</cfoutput>', 'user_profile_cfdiv');"
				class="inactive"
				title="Dodaj nową aktualność">

				<span>Dodaj zdjęcie do aktualności</span>
			</a>
		</div>
	</div>
</div>

<div class="footerArea">

</div>

<cfset ajaxOnLoad("initPosts") />