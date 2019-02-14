<cfoutput>
			<div class="leftContent">
				<div id="leftCol">
					<div id="profilePhoto">
						<div class="photoContainer">
							<cfif FileExists(ExpandPath("images/avatars/thumbnail")&"/#myuser.photo#")>
								#imageTag(source="avatars/thumbnail/#myuser.photo#",alt="",title="")#
							<cfelse>
								#imageTag(source="avatars/monkeyavatar.png",alt="",title="")#
							</cfif>
							<div class="photoContainerOptionsCover hide">
								<div class="photoContainerOptions">#linkTo(text="edytuj",controller="Users",action="editPhoto",class="ajaxmodallink",key=session.userid)#</div>
							</div>
						</div> <!--- end photoContainer --->
					</div> <!--- profilePhoto --->
					
					<div id="profileAttributes">
						<h5>Użytkownik</h5>
						<ul>
							<li>Nazwa użytkownika <span>#mystore.nazwaajenta#</span></li>
							<li>Adres sklepu <span>#mystore.adressklepu#</span></li>
							<li>Tel <span>#mystore.telefon#</span></li>
							<li>Kom <span>#mystore.telefonkom#</span></li>
							<li>Email <span>#mailTo(mystore.email)#</span></li>
							
						</ul>
					</div> <!--- end profilettributes --->

				
					<div id="profileInformations">
						<h5>Opcje</h5>
						<ul>
							<li>
								
								<!---#linkTo(
									text="Zmień hasło do Intranetu",
									controller="Partners",
									action="changePassword")#--->
								<span class="lt">Zmień hasło do Intranetu</span>
								
							</li>
							
							<li>
								
								<!---#linkTo(
									text="Zmień zdjęcie",
									controller="Users",
									action="changePhoto")#--->
								<span class="lt">Zmień zdjęcie</span>
								
							</li>
						</ul>
					</div> <!--- end profileInformations --->

				</div> <!--- leftCol --->
			</div> <!--- leftContent --->
</cfoutput>
