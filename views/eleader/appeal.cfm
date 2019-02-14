<cfprocessingdirective pageencoding="utf-8" />

<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="uprawnieniaCentrala">
		<cfinvokeargument name="groupname" value="Centrala" />
	</cfinvoke>
</cfsilent>


<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Odwołanie od AOS</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<div class="uiMessage <cfif odwolanie.idstatusuodwolania EQ 2> uiConfirmMessage <cfelseif odwolanie.idstatusuodwolania EQ 3> uiErrorMessage </cfif> ">
				<cfoutput>#odwolanie.nazwastatusu#</cfoutput>
			</div>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform name="odwolanieOdAosForm#odwolanie.id#" action="index.cfm?controller=eleader&action=appeal">
				<cfinput type="hidden" name="idOdwolania" value="#odwolanie.id#" />
				<ol class="horizontal">
					<li>
						<label for="czesc">Część</label>
						<div class="formElementSpacer"><cfoutput>#odwolanie.nazwazadania#</cfoutput></div>
					</li>
					<li>
						<label for="pytanie">Pytanie</label>
						<div class="formElementSpacer"><cfoutput>#odwolanie.nazwapola#</cfoutput></div>
					</li>
					<li>
						<label for="odwolanie">Treść odwołania</label>
						<div class="formElementSpacer"><cfoutput>#odwolanie.trescodwolania#</cfoutput></div>
					</li>
					<li>
						<label for="uzasadnienie">Uzasadnienie</label>
						<textarea name="uzasadnienie" class="textarea" <cfif odwolanie.idstatusuodwolania NEQ 1 or uprawnieniaCentrala is false> readonly="readonly" </cfif>><cfoutput>#odwolanie.uzasadnienie#</cfoutput></textarea>
					</li>
					<cfif odwolanie.idstatusuodwolania EQ 1 and uprawnieniaCentrala is true>
						<li>
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=eleader&action=accept-appeal', 'odwolanie<cfoutput>#odwolanie.id#</cfoutput>', null, null, 'POST', 'odwolanieOdAosForm<cfoutput>#odwolanie.id#</cfoutput>')" class="btn btn-green" title="Zaakceptuj odwołanie">Zaakceptuj</a>
							<a href="javascript:ColdFusion.navigate('index.cfm?controller=eleader&action=decline-appeal', 'odwolanie<cfoutput>#odwolanie.id#</cfoutput>', null, null, 'POST', 'odwolanieOdAosForm<cfoutput>#odwolanie.id#</cfoutput>')" class="btn btn-red" title="Odrzuć odwołanie">Odrzuć</a>
						</li>
					</cfif>
				</ol>
			</cfform>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
