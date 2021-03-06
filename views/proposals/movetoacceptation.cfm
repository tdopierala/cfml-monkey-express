<cfoutput>

<div class="ajaxcontent">

	<div class="wrapper">
	
		<h3>Przekaż do akceptacji</h3>
		
		<div class="wrapper">

			<div class="proposalsteps">
				<ul class="step3">
					<li><span>1. Wybór rodzaju dokumentu</span></li>
					<li><span>2. Wypełnienie dokumentu</span></li>
					<li><span>3. Potwierdzenie</span></li>
					<li class="selected"><span>4. Przekazanie do akceptacji</span></li>
				</ul>
			</div>
			
			<div class="wrapper proposalpreview">
				
				<cfif IsObject(proposalstep) and StructKeyExists(proposalstep, "proposaltypeid")>
					
					<cfswitch expression="#proposalstep.proposaltypeid#">
						
						<cfcase value="4">
							
							<div class="proposalmovetoinfo ok">
								Wniosek został przekazany i oczekuje na akceptację.
							</div>
								
						</cfcase>
						
						<cfdefaultcase>
							<cfif user.RecordCount eq 0>
					
								<div class="proposalmovetoinfo">
									System nie znalazł Twojego przełożonego w bazie… :(
								</div>
							
							<cfelse>
							
								<div class="proposalmovetoinfo ok">
									Wniosek został przekazany do Twojego przełożonego <span>#user.givenname# #user.sn#</span> i oczekuje na jego akceptację.
								</div>
							
							</cfif>
						</cfdefaultcase>
						
					</cfswitch>
					
				</cfif>
				
				<div class="proposaluserprofile">
					#linkTo(
						text="<span>mój profil</span>",
						controller="Users",
						action="view",
						key=session.userid)#
				</div> 	
									
			</div>

		</div><!-- /wrapper -->
	
	</div><!-- /wrapper -->

</div><!-- /ajaxcontent -->

</cfoutput>

<script type="text/javascript">

$(function() {

	
});

</script>
