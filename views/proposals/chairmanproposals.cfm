<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Wnioski do akceptacji</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfform name="note_notes_filter_form"
					action="#URLFor(controller='Proposals',action='chairmanProposals')#">
						
				<ul class="uiList uiForm">
					<li>
						<label for="typeid">Typ wniosku</label> 
						<select name="typeid" class="select_box">
							<option value="0">[wszystkie]</option>
							<cfoutput query="typy">
								<option value="#id#" <cfif session.proposal.typeid EQ id> selected="selected"</cfif>>#proposaltypename#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<label for="proposalstatusid">Status</label>
						<select name="proposalstatusid" class="select_box">
							<option value="0">[wszystkie]</option>
							<cfoutput query="statusy">
								<option value="#id#" <cfif session.proposal.proposalstatusid EQ id> selected="selected"</cfif>>#proposalstatusname#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<label for="managerid">Osoba akceptująca</label>
						<select name="managerid" class="select_box">
							<option value="0">[wszystkie]</option>
							<cfloop query="uzytkownicy">
								<cfif Len(managergivenname) EQ 0>
									<cfcontinue />
								</cfif>
								<option value="<cfoutput>#managerid#</cfoutput>" <cfif session.proposal.managerid EQ managerid> selected="selected"</cfif>><cfoutput>#managergivenname#</cfoutput></option>
							</cfloop>
						</select>
					</li>
					<li>
						<cfinput type="submit"
							 name="note_notes_filter_form_submit"
							 value="Filtruj"
							 class="admin_button green_admin_button" />
					</li>
				</ul>
				
			</cfform>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<table class="uiTable aosTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder c">Lp.</th>
						<th class="topBorder rightBorder bottomBorder c">Typ wniosku</th>
						<th class="topBorder rightBorder bottomBorder c">Status wniosku</th>
						<th class="topBorder rightBorder bottomBorder c">Składający/a</th>
						<th class="topBorder rightBorder bottomBorder c">Akceptujący/a</th>
						<th class="topBorder rightBorder bottomBorder c">W dniach</th>
						<th class="topBorder rightBorder bottomBorder c">&nbsp;</th>
					</tr>
				</thead>
				<tbody>
					<cfset indeks = 1 />
					<cfloop query="wnioski">
						<tr>
							<td class="leftBorder bottomBorder rightBorder c"><cfoutput>#indeks#</cfoutput></td>
							<td class="bottomBorder rightBorder l"><cfoutput>#proposaltypename#</cfoutput></td>
							<td class="bottomBorder rightBorder l"><cfoutput>#proposalstatusname#</cfoutput></td>
							<td class="bottomBorder rightBorder l"><cfoutput>#usergivenname#</cfoutput></td>
							<td class="bottomBorder rightBorder l"><cfoutput>#managergivenname#</cfoutput></td>
							<td class="bottomBorder rightBorder l">
								<cfoutput>
									#listQualify("#proposaldate#", " ", ",")#
								</cfoutput>
							</td>
							<td class="bottomBorder rightBorder r">
								<cfif proposalstep2status NEQ 1>
									<cfcontinue />
								</cfif>
								
								<cfswitch expression="#proposaltypeid#" >
									<cfdefaultcase>
										<a href="index.cfm?controller=proposals&action=accept-no-user&key=<cfoutput>#proposalid#</cfoutput>" title="Zaakceptuj wniosek" class="accept aLink"><span>Zaakceptuj</span></a>
										<a href="index.cfm?controller=proposals&action=discard-no-user&key=<cfoutput>#proposalid#</cfoutput>" title="Odrzuć wniosek" class="decline aLink"><span>Odrzuć</span></a>
									</cfdefaultcase>
								</cfswitch>
								
							</td>
						</tr>
						<cfset indeks += 1 />
					</cfloop>
				</tbody>
			</table>

			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<cfset ajaxOnLoad("initProposals") />

</cfdiv>