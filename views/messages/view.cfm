<cfoutput>

	<div class="wrapper">
	
		<h3>#message.messagetitle#</h3>
		
		<div class="wrapper">
			<cfoutput>#includePartial(partial="/users/subnav")#</cfoutput>
		</div>
		
		<div class="wrapper">
			<h4>Treść komunikatu</h4>
			<div class="messagebody">
				#message.messagebody#
			</div>
			
			<div class="messagesummary">
<!--- 					<li class="title"></li> --->
<!--- 					<li><span>Data utworzenia</span>#DateFormat(message.messagecreated, "dd/mm/yyyy")# #TimeFormat(message.messagecreated, "HH:mm")#</li> --->
<!--- 					<li><span>Data ważności</span>#DateFormat(message.messagestartdate, "dd/mm/yyyy")# - #DateFormat(message.messagestopdate, "dd/mm/yyyy")#</li> --->
<!--- 					<li><span>Ilość kliknięć</span>#message.clicked#</li> --->
			</div>
			
		</div>
	
	</div>

</cfoutput>