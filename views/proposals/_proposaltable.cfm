<cfoutput>
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
					<td class="proposaltypename">

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
					<td class="bottomBorder" colspan="7">Urlop w dniach: <span>#proposaldate#</span></td>
				</tr>
			</cfloop>

		</tbody>

	</table>
</cfoutput>