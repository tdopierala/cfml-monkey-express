<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Wnioski</h3>
		<cfif session.user.id eq 345>
			<span>przybliżona ilość wykorzystanych dni urlopu: <cfoutput>#proposal_days.days#</cfoutput></span>
		</cfif>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
	
		<ul class="uiList">
			<cfloop query="uProposals">
				<cfif proposalstep1status eq 1>
					<cfinclude template="_uproposals.cfm"> 
				</cfif>
			</cfloop>
		</ul>
		
		<ul class="uiList" style="border-top: none;">
			<cfloop query="uProposals">
				<cfif proposalstep1status eq 2>
					<cfinclude template="_uproposals.cfm"> 
				</cfif>
			</cfloop>
		</ul>

		<div class="uiFooter">
			<cfoutput>
			<a
				href="#URLFor(controller='Proposals',action='add')#"
				title="Dodaj nowy wniosek"
				class="">

					Złóż wniosek

			</a> w Intranecie
			</cfoutput>
		</div>
	</div>
</div>

<div class="footerArea">

</div>

<script language="JavaScript">
	$(function(){
		$(document).on("click", ".uiListLink", function(){
			var href = $(this).attr("href");
			$('#flashMessages').show();
			$.ajax({
				url		: href,
				type		: "get",
				dataType	: "html",
				success: function( data ) 
				{
					$( "#user_profile_cfdiv" ).html(data);
					$('#flashMessages').hide();
				}
			});
			return false;
		});
	});
</script>

<!--- <cfif session.user.id eq 345>
	<cfdump var="#uProposals#" />
</cfif> --->