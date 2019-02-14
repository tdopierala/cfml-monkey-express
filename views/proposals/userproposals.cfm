<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Wnioski do akceptacji</h3>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">
		
		<cfform
			name="proposals_filter_form"
			action="#URLFor(controller='Proposals',action='userProposals')#"
			method="post"
			onsubmit="" >
				 
		<ul class="uiList uiForm">
			<!--- 
			<li>
				<p>Data urlopu</p>
				<cfinput
					name="proposal_from"
					type="text"
					class="small_input date_picker"
					placeholder="od" />
					
				<cfinput
					name="proposal_to"
					type="text"
					class="leftSpace small_input date_picker"
					placeholder="do" />
			</li>
			--->
			<li>
				<p>Status wniosku</p>
				<cfselect
					name="proposalstatusid"
					query="proposalstatuses"
					display="proposalstatusname"
					class="select_box"
					selected="#session.proposals.proposalstatusid#"
					value="id" >
				
				</cfselect>
			</li>
			<li>
				<cfinput
					type="submit"
					name="proposal_filter_form_submit"
					class="admin_button green_admin_button"
					value="Filtruj" />
			</li>
		</ul>
		
		</cfform>
		
		<cfdiv id="uer_proposals">
		
		<ul class="uiList">
			<cfloop query="userproposals">
				<li>
					<a
						href="<cfoutput>#URLFor(controller='Proposals',action='proposalToPdf',key=proposalid,params='format=pdf')#</cfoutput>"
						title="Pobierz jako PDF"
						target="_blank"
						class="uiListLink clearfix">
							<h3 class="uiListItemLabel">
								<cfoutput>#proposaltypename#</cfoutput>
							</h3>

							<span class="uiListItemContent"><cfoutput>#usergivenname#</cfoutput></span>
							<span class="uiListItemContent">Od <span class="uiRed"><cfoutput>#proposaldatefrom#</cfoutput></span> do <span class="uiRed"><cfoutput>#proposaldateto#</cfoutput></span></span>
							<span class="uiListItemContent">Zastępowany(a) przez <span class="i"><cfoutput>#substitutename#</cfoutput></span></span>
					</a>

					<div class="uiListOptions">

						<!--- 
							16.06.2013
							Kiedy status wniosku jest inny niż W trakcie, to usuwam 
							opcje Akceptacji/Odrzucenia i zastępuję je możliwością
							usunięcia wniosku z listy.
						--->
						<cfif proposalstep2status EQ 1>

							<a
							href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller='Proposals',action='discard',key=proposalid)#</cfoutput>', 'user_profile_cfdiv');"
								class="discardproposal"
								title="Odrzucam wniosek">
								<span>Odrzucam</span>
							</a>

							<a
							href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller='Proposals',action='accept',key=proposalid)#</cfoutput>', 'user_profile_cfdiv');"
								class="acceptproposal"
								title="Akceptuje wniosek">
								<span>Akceptuje</span>
							</a>
							
						<cfelse>
							
							<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller='Proposals',action='hide',key=proposalid)#</cfoutput>', 'user_profile_cfdiv');"
							class="hideproposal"
							title="Ukryj wniosek">
								
								<span>Ukryj</span>
								
							</a>

						</cfif>

					</div>
				</li>
			</cfloop>
		</ul>
		
		</cfdiv>

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


<!---<cfoutput>
	<div class="">
		<div class="wrapper">
			<h3>Wnioski pracowników departamentu</h3>

			<div class="wrapper">

				<cfoutput>#includePartial(partial="/users/subnav",cache=0)#</cfoutput>

			</div>

			<cfoutput>#includePartial(partial="proposaltypes")#</cfoutput>

			<div class="wrapper ajaxproposaltable">
				<table class="newtables">
					<thead>

						<tr>
							<th class="bottomBorder"></th>
							<th class="bottomBorder"></th>
							<th class="bottomBorder"></th>
							<th class="bottomBorder"></th>
							<th class="bottomBorder"></th>
							<th class="bottomBorder" colspan="2"></th>
						</tr>

					</thead>

					<tbody>

						<cfloop query="userproposals">
							<tr>
								<td class="">

									#linkTo(
										text=proposaltypename,
										controller="Proposals",
										action="view",
										key=proposalid,
										title="Podgląd wniosku")#

								</td>
								<td class="proposalstatus">#proposalstatusname#</td>
								<td class="">#usergivenname#</td>
								<td class="">

									#linkTo(
										text=imageTag("file-pdf.png"),
										controller="Proposals",
										action="proposalToPdf",
										key=proposalid,
										target="_blank",
										params="&format=pdf",
										title="Eksportuj do PDF")#

								</td>
								<td class="c" colspan="2">

									<cfif proposalstep2status eq 1>

										#linkTo(
											text="<span>Odrzucam</span>",
											controller="Proposals",
											action="discard",
											key=proposalid,
											class="discardproposal ajaxproposallink",
											title="Odrzucam wniosek")#

										#linkTo(
											text="<span>Akceptuje</span>",
											controller="Proposals",
											action="accept",
											key=proposalid,
											class="acceptproposal ajaxproposallink",
											title="Akceptuje wniosek")#

									</cfif>

								</td>
							</tr>
							<tr class="proposaldays">
								<td class="bottomBorder" colspan="7">W dniach: <span>#proposaldate#</span></td>
							</tr>
						</cfloop>

					</tbody>

				</table>

			</div>

			<div class="clear"></div>
		</div>
	</div>
</cfoutput>

<script type="text/javascript">
$(function() {
	$('.ajaxproposallink').live('click', function(e) {
		e.preventDefault();
		var tr = $(this).parent().parent();
		var links = $(this).parent().parent().find('.ajaxproposallink');
		$('#flashMessages').show();

		$.ajax({
			type		:		'get',
			dataType	:		'html',
			url			:		$(this).attr('href'),
			success		:		function(data) {
				tr.next().remove();
				tr.remove();
				$('#flashMessages').hide();
			},
			error		:		function(xhr, ajaxOptions, throwError) {}
		});
	});

	$('#proposalstatusid').live('change', function (e) {
		$('#flashMessages').show();
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url			:	<cfoutput>"#URLFor(controller='Proposals',action='userProposals')#"</cfoutput> + "&key=" + $('#proposalstatusid :selected').val(),
			success		:	function(data) {
				$('.ajaxproposaltable').html(data);
				$('#flashMessages').hide();
			}
		});
	});

});
</script>--->