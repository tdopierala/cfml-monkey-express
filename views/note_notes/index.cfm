<cfsilent>
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="uprawnieniaPps" >
			
		<cfinvokeargument name="groupname" value="Partner prowadzący sklep" />
	</cfinvoke>
	
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Notatki pokontrolne</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfform name="note_notes_filter_form"
					action="#URLFor(controller='Note_notes',action='index')#">
						
				<ol class="filters">
					<cfif uprawnieniaPps is false and
						uprawnieniaKos is false>
				
						<li>
							<cfinput type="text"
									 class="input"
									 name="projekt"
									 placeholder="Numer sklepu"
									 value="#session.noteFilter.projekt#" />
						</li>
						<li>
							<select name="partnerid" class="select_box">
								<option value="">[Nazwisko KOS]</option>
								<cfoutput query="kos">
									<option value="#userid#" <cfif userid EQ session.noteFilter.partnerid>selected="selected"</cfif>>#usr#</option>
								</cfoutput>
							</select>
						</li>
					
					</cfif>
					
					<li>
						<select name="userid" class="select_box">
							<option value="">[Twórca notatki]</option>
							<cfoutput query="authors" >
								<option value="#userid#" <cfif userid EQ session.noteFilter.userid>selected="selected"</cfif>>#usr#</option>
								
							</cfoutput>
						</select>
					</li>
					<li>
						<select name="score" class="select_box">
							<option value="">[Ocena wypadkowa]</option>
							<cfoutput query="scores">
								<option value="#val#" <cfif val EQ session.noteFilter.score>selected="selected"</cfif>>#key#</option>
							</cfoutput>
						</select>
						
					</li>
					<li>
						<select name="miasto" class="select_box">
							<option value="">[Miasto]</option>
							<cfoutput query="cities">
								<option value="#miasto#" <cfif miasto EQ session.noteFilter.miasto> selected="selected"</cfif>>#miasto#</option>
							</cfoutput>
						</select>
					</li>
					<li class="clear">
						<cfinput type="radio" name="date_type" value="note_created" checked="#iif( CompareNoCase(session.noteFilter.date_type, "note_created") EQ 0, DE("checked"), DE("false"))#" /> Data utworzenia
						<cfinput type="radio" name="date_type" value="inspection_date" checked="#iif( CompareNoCase(session.noteFilter.date_type, "inspection_date") EQ 0, DE("checked"), DE("false"))#" /> Data kontroli
					</li>
					<li>
						<cfinput type="datefield" 
							 name="date_from" 
							 class="input"
							 placeholder="Data od"
							 validate="eurodate" 
							 mask="dd/mm/yyyy"
							 value="#DateFormat(session.noteFilter.date_from,"dd/mm/yyyy")#" /> 
					</li>
					<li>
						<cfinput type="datefield" 
							 name="date_to" 
							 class="input"
							 placeholder="Data do"
							 value="#DateFormat(session.noteFilter.date_to,"dd/mm/yyyy")#"
							 validate="eurodate"
							 mask="dd/mm/yyyy"/>
					</li>
					<li>
						<cfinput type="text"
								 name="str"
								 class="input normalinput"
								 placeholder="Wyszukaj w tekście"
								 value="#session.noteFilter.str#" />
					</li>
					<li class="clear">
						<cfset tablicaTagow = ListToArray(session.noteFilter.tagid, ",") />
						<select name="tagid" multiple="multiple">
							<option value=""></option>
							<cfoutput query="tags">
								<option value="#id#" <cfif arrayContains(tablicaTagow, id) EQ "Yes">selected="selected"</cfif>>#tagname#</option>
							</cfoutput>
						</select>
					</li>
					<li>
						<cfinput type="submit"
								 name="note_notes_filter_form_submit"
								 value=">>"
								 class="admin_button green_admin_button" />
					</li>
				</ol>
				
			</cfform>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<cfif IsDefined("session.flash.message")>
				<div class="uiMessage uiErrorMessage">
					<cfoutput>#session.flash.message#</cfoutput>
				</div>
			</cfif>

			<cfinclude template="_notes.cfm" />

			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">
		<cfset paginator = 1 />
		<cfset pages_count = Ceiling(notesCount.ilosc/session.noteFilter.elements) />
		<cfloop condition="paginator LESS THAN OR EQUAL TO pages_count" >

			<cfif paginator eq session.noteFilter.page>
				<cfoutput>
				<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&page=#paginator#&elements=#session.noteFilter.elements#&t=1', 'left_site_column')" class="active">#paginator#</a>
				</cfoutput>
			<cfelse>
				<cfoutput>
				<a href="javascript:ColdFusion.navigate('index.cfm?controller=note_notes&action=index&page=#paginator#&elements=#session.noteFilter.elements#&t=1', 'left_site_column')">#paginator#</a>
				</cfoutput>
			</cfif>
			
			<cfset paginator++ />

		</cfloop>

	</div>

</div>


</cfdiv>
