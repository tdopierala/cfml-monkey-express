<cfoutput>
	<div class="wrapper concessions">
		
		<div class="wrapper">
			#linkTo(
				text="&laquo; wróć do wniosku",
				action="edit-proposal",
				key=document.proposalid)#
		</div>
		
		<div class="wrapper proposalform">
			<h4>Szczegóły dokumentu</h4>
					
			<ol class="concession-proposal-details">
				<li>
					<label>Imie i nazwisko</label>
					<span>#user.givenname# #user.sn#</span>
				</li>
				<li>
					<label>Data utworzenia dokumentu</label>
					<span>#DateFormat(document.created, "dd.mm.yyyy")# r.</span>
				</li>
				<li>
					<label>Status dokumentu</label>
					<span>
						<cfswitch expression="#document.status#">
							<cfcase value="1">
								<span style="color:##ff0000">niewypełniony</span>
							</cfcase>
							<cfcase value="2">
								<span style="color:##e1e100">niedokończony</span>
							</cfcase>
							<cfcase value="3">
								<span style="color:##00b900">wypełniony</span>
							</cfcase>
						</cfswitch>
					</span>
				</li>
			</ol>
		</div>
		
		<div class="wrapper proposalform">
			<h4>Szczegóły dokumentu</h4>
			
			<div class="concesssion-document-content">
				<cfswitch expression="#document.type#">
					<cfcase value="1">
						#includePartial("concession_proposal")#
					</cfcase>
					<cfcase value="2">
						#includePartial("concession_biling")#
					</cfcase>
					<cfcase value="3">
						#includePartial("concession_statement")#
					</cfcase>
				</cfswitch>
			</div>
		</div>
		
		<div class="wrapper proposalform">
			#submitTag(value="Zapisz",class="smallButton redSmallButton submitdocument")#
		</div>
	</div>
</cfoutput>
<!---<cfdump var="#documentattributevalues#" >--->
<script>
	$(function(){
		
		$(".submitdocument").on("click", function(){
			
			$("#flashMessages").show();
			$(".concesssion-document-content").find("#document-form").submit();
			
			return false;
		});
		
	});
</script>