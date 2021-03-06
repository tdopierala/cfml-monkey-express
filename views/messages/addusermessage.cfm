<cfoutput>

	<div class="wrapper">
	
		<h3>Dodaj nowy komunikat</h3>
	
		<div class="wrapper">
			<cfoutput>#includePartial(partial="/users/subnav")#</cfoutput>
		</div>
		
		<div class="forms">
			#startFormTag(controller="Messages",action="actionAddUserMessage")#
				#hiddenFieldTag(name="createdforuserid",value=user.id)#
				<ol class="horizontal">
					<li>
						#select(
							objectName="message",
							property="messagepriorityid",
							options=messagepriorities,
							label="Priorytet komunikatu",
							labelPlacement="before")#
					</li>
					<li>
						#textField(
							objectName="message",
							property="messagetitle",
							class="input",
							label="Nagłówek komunikatu",
							labelPlacement="before")#
					</li>
					<li>
						#textArea(
							objectName="message",
							property="messagebody",
							class="textarea",
							label="Treść komunikatu",
							labelPlacement="before")#
					</li>
					<li>#submitTag(value="Zapisz",class="button redButton fltl")#</li>
				</ol>
			#endFormTag()#
			
			<div class="clear"></div>
			
		</div>
	
	</div>

</cfoutput>