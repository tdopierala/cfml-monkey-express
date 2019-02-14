<cfoutput>

	<div class="wrapper">
		
		<h3>Brak dostępu</h3>
		
		
		<div class="wrapper">
			#imageTag(source="stop.png",class="accessdeny")#
			
			<div class="autherrorinfo">
				Nie masz uprawnień do przeglądania tej strony. #linkTo(text="Przejdź do swojego profilu",controller="users",action="view",key=session.userid)#.
				<br/>
				W przypadku pytań prosimy o kontakt z #mailTo(emailAddress="intranet@monkey.xyz", name="Departamentem Informatyki")#.
			</div>
		</div>
	</div>
	

	
</cfoutput>