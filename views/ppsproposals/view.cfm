<cfoutput>
	
	<div class="wrapper proposalpps">
	
		<cfif flashKeyExists("success")>
			<span class="success">#flash("success")#</span>
		<cfelseif flashKeyExists("error")>
			<span class="error">#flash("error")#</span>
		</cfif>
		
		<div class="wrapper">
				
			<h3>Wniosek o zmianę PPS na sklepie #proposal.projekt#</h3>
					
			<div class="topLink">
				#linkTo(text="Powrót do listy", action="index")#
			</div>
					
			<div class="wrapper proposalform">
				<ol>
					<li>
						<label>Numer wniosku:</label>
						<span>###proposal.lp#</span>
					</li>
					<li>
						<label>Projekt:</label>
						<span>#proposal.projekt#</span>
					</li>
					<li>
						<label>Adres sklepu:</label>
						<span>#store.ulica#, #store.miasto#</span>
					</li>
					<li>
						<label>Data złożenia wniosku:</label>
						<span>#DateFormat(proposal.createddate,"yyyy-mm-dd")#</span>
					</li>
					<li>
						<label>KOS:</label>
						<span>#proposal.kos.givenname# #proposal.kos.sn#</span>
					</li>
					<li>
						<label>Sposób rozwiązania umowy:</label>
						<span>#methods['name'][proposal.methodid]#</span>
					</li>
					<li>
						<label>Planowany termin wymiany PPS:</label>
						<span>#DateFormat(proposal.changedate,"yyyy-mm-dd")#</span>
					</li>
					<li>
						<label>Powód zmiany PPS:</label>
						<span>#proposal.reasons.reasonname#</span>
					</li>
					<cfif proposal.reasonid eq 10>
						<li>
							<label>Inny powód wymiany PPS:</label>
							<span>#proposal.reason#</span>
						</li>
					</cfif>
				</ol>
				
				<ol>
					<li>
						<label>Status wniosku:</label>
						<cfswitch expression="#proposal.statusid#">
							<cfcase value="1">
								<span class="proposal_status">oczekuje na akceptację</span>
							</cfcase>
							<cfcase value="2">
								<span class="proposal_status status_accepted">zaakceptowany</span>
							</cfcase>
							<cfcase value="3">
								<span class="proposal_status status_rejected">odrzucony</span>
							</cfcase>
						</cfswitch>
					</li>
					<cfif proposal.statusid gt 1>
						<li>
							<label>Uzasadnienie decyzji:</label>
							<span>#proposal.statusnote#</span>
						</li>
					</cfif>
				</ol>
			</div>
			<!---#proposal.directorid#--->
			<cfif proposal.statusid eq 1 and (proposal.directorid eq session.user.id or _root is true)>
				<div class="wrapper proposalform">
					<h4>Decyzja dyrektora regionalnego</h4>
					<ol>
						<li>
							<span>Uzasadnienie:</span><br />
							#textAreaTag(name="proposal-accept", class="textarea")#
							#hiddenFieldTag(name="proposal-key",value="#params.key#")#
						</li>
						<li>
							#submitTag(value="Zatwierdź",class="smallButton greenSmallButton submitButton _accept")#
							#submitTag(value="Odrzuć",class="smallButton redSmallButton submitButton _discard")#
						</li>
					</ol>
					
				</div>
			</cfif>
			
		</div>
		
	</div>
</cfoutput>
<cfif session.user.id eq 345>
<!---<cfdump var="#proposal#">--->
<!---<cfdump var="#store#">--->
</cfif>
<script>
	$(function(){
		
		$(".submitButton").on("click",function(){
			
			var note = $("#proposal-accept").val();
			
			if(note.trim() != ''){
				$("#flashMessages").show();
				
				$.ajax({
					type: "POST",
					url: <cfoutput>"#URLFor(action='accept')#"</cfoutput>,
					data: {
						key: $("#proposal-key").val(),
						statusnote: note,
						statusid: $(this).hasClass("_accept") ? 2 : 3
					},
					success: function(){
						$("#flashMessages").hide();
						location.reload();
					},
					error: function(){
						alert("Wystąpił błąd przy zapisywaniu. Spróbuj ponownie później.");
						$("#flashMessages").hide();
					}
				});
			
			} else {
				alert("Musisz podać uzasadnienie decyzji.");
			}
		});
	});
</script>