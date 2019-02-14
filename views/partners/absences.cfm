<cfsilent>
	<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="dyrektorzy">
		<cfinvokeargument name="groupname" value="Dyrektorzy" />
	</cfinvoke>
	
	<cfinvoke method="checkUserTreeGroup" component="controllers.Tree_groupusers" returnvariable="wnioskiEkspansji">
		<cfinvokeargument name="groupname" value="Wnioski urlopowe partnerow ekspansyjnych" />
	</cfinvoke>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Nieobecności</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<div class="l clearfix" style="margin-bottom: 20px;">
				<a href="javascript:ColdFusion.navigate('index.cfm?controller=partners&action=new-absence', 'left_site_column')" title="Dodaj nieobecność" class="linkButton"><span>+ Nieobecność</span></a>
			</div>
			
			<ul class="partner_absence_calendar">
				<cfloop from="#mostRecentMonday#" to="#dateAdd('d', 6, mostRecentMonday)#" index="day" step="#createTimespan(1, 0, 0, 0)#">
					<cfset maxWidth = 925 />
					<li style="width:<cfoutput>#Int((maxWidth-21)/7)#</cfoutput>px;" class="<cfif DayOfWeek(day) EQ 1> sunday </cfif><cfif DayOfWeek(day) EQ 7> saturday </cfif>
					<cfif DateCompare(DateFormat(day, "yyyy-mm-dd"), DateFormat(Now(), "yyyy-mm-dd")) EQ 0> currentday </cfif>
					">
						<div class="day_top">
							<span class="calendar_day_number"><cfoutput>#DateFormat(day, "dd")#</cfoutput></span>
							<span class="calendar_day_string"><cfoutput>#DayOfWeekAsString(dayOfWeek(day), "pl_PL")#</cfoutput></span>
							<span class="calendar_date"><cfoutput>#DateFormat(day, 'yyyy-mm-dd')#</cfoutput></span>
						</div>
						<div class="day_container">
							
							<cfset tmpDate = day />
							<cfloop query="nieobecnosci">
								<cfloop from="#absence_from#" to="#absence_to#" index="abs" step="#createTimespan(1, 0, 0, 0)#">
									<cfif dateCompare(DateFormat(day, 'yyyy/mm/dd'), DateFormat(abs, 'yyyy/mm/dd')) EQ 0>
										<div class="day_absence">
											<cfoutput>#givenname# #sn#</cfoutput>
										</div>
									</cfif>
								</cfloop>
							</cfloop>
							
						</div>
					</li>
				</cfloop>
			</ul>
			
			<div class="uiFooter">
				<cfif dyrektorzy is true OR wnioskiEkspansji is true>
					<cfdiv id="partner_absences_acceptation" bind="url:index.cfm?controller=partners&action=acceptation&t=true" />
				</cfif>
			</div>
		</div>
	</div>

	<div class="footerArea">

	</div>

</div>
</cfdiv>