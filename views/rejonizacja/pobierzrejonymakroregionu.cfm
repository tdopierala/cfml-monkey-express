<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />
	
<tr>
	<td class="leftBorder bottomBorder rightBorder" colspan="3">
		<div class="inside_table inside_table_padding">
			<table class="uiTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder expandCell">&nbsp;</th>
						<th class="topBorder rightBorder bottomBorder">Rejon</th>
						<th class="topBorder rightBorder bottomBorder">Użytkownik</th>
						<!---<th class="topBorder rightBorder bottomBorder">Ilość powiatów</th>--->
						<th class="topBorder rightBorder bottomBorder">Powiaty</th>
						<th class="topBorder rightBorder bottomBorder"></th>
					</tr>
				</thead>
				<tbody>
					<cfoutput query="rejony">
						<tr class="whiteBackground">
							<td class="leftBorder rightBorder bottomBorder">&nbsp;</td>
							<td class="rightBorder bottomBorder l">#nazwa#</td>
							<td class="rightBorder bottomBorder l box" style="width:350px;">
								<cfset qUsers = rejony.usersid />
								
								<cfif IsQuery(qUsers)>							
									<cfloop query="qUsers">
										<!---<a href="#URLFor(controller='User', action='view', key=qUsers.id)#">--->
											<span class="powiat_item">#qUsers.givenname# #qUsers.sn#<a href="##" class="bclose" onclick="usunUzytkownika(#rejony.rejon_def_id#,#qUsers.id#,this); return false;">x</a></span>
										<!---</a> <br />--->
									</cfloop>									
								</cfif>
							</td>
							<!---<td class="rightBorder bottomBorder r">#iloscpowiatow#</td>--->
							<td class="rightBorder bottomBorder l box" style="width:350px;">
								<cfset qPowiat = rejony.powiatid />
								
								<cfif IsQuery(qPowiat)>									
									<cfloop query="qPowiat">
										<span class="powiat_item">#qPowiat.powiat# <a href="#URLFor(controller='rejonizacja',action='usun-powiat-action')#" class="bclose" onclick="usunPowiat(#rejony.rejon_def_id#,#qPowiat.id#,this); return false;">x</a></span>
									</cfloop>									
								</cfif>
							</td>
							<td class="rightBorder bottomBorder l buttonCell">								
								<a href="##" class="aButton" onclick="usunRejonMakroregionu(#url.key#,#rejony.rejon_def_id#,$(this)); return false;">x</a>
							</td>
						</tr>
					</cfoutput>
				</tbody>
			</table>
		</div>
	</td>
</tr>
