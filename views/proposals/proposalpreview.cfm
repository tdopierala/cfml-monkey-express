<cfoutput>

<div class="ajaxcontent">

	<div class="wrapper">
	
		<h3>Podgląd wniosku</h3>
		
		<div class="wrapper">

			<div class="proposalsteps">
				<ul class="step3">
					<li><span>1. Wybór rodzaju wniosku</span></li>
					<li><span>2. Wypełnienie wniosku</span></li>
					<li><span>3. Przekazanie do akceptacji</span></li>
				</ul>
			</div>
			
			<div class="wrapper proposalpreview">
			
				<h5>#proposaltype.proposaltypename#</h5>
				
				<ol>
					<cfloop query="proposalattributes">
					
						<li><span>#attributename#</span>#proposalattributevaluetext#</li>
					
					</cfloop>
				</ol>
				
				<div class="proposalpreviewsubnav">
					<ul>
						<li class="red">
							#linkTo(
								text="<span>Przekaż do akceptacji</span>",
								controller="Proposals",
								action="moveToAcceptation",
								key=proposal.id,
								title="Przekaż do akceptacji",
								class="")#
						</li>
						<li>
							#linkTo(
								text="<span>Zapisz do PDF</span>",
								controller="Proposals",
								action="proposalToPdf",
								key=proposal.id,
								target="_blank",
								title="Zapisz do PDF")#
						</li>
					</ul>
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
