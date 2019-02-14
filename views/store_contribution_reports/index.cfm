<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Raport wpłat</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfform name="raport_wplat_form" action="index.cfm?controller=store_contribution_reports&action=index">
				<div class="form-inline">
					<div class="form-group">
						<select name="partnerid" class="select_box">
							<option value="">[KOS]</option>
							<cfoutput query="kos">
								<option value="#id#">#givenname# #sn#</option>
							</cfoutput>
						</select>
					</div>
					<div class="form-group">
						<cfinput type="text" class="input" name="sklep" placeholder="Numer sklepu" />
					</div>
				</div>
				
				<div class="form-inline">
					<div class="form-group">
						<label class="date-label" for="dzienOd">Data od</label>
						<cfinput type="datefield" name="dzienOd" validate="eurodate" mask="dd-mm-yyyy" class="input" placeholder="Data od" value="#DateFormat(session.raport_sprzedazy.dzienOd, "dd/mm/yyyy")#" />
					</div>
					
					<div class="form-group">
						<label class="date-label" for="dzienDo">Data do</label>
						<cfinput type="datefield" name="dzienDo" validate="eurodate" mask="dd-mm-yyyy" class="input" placeholder="Data do" value="#DateFormat(session.raport_sprzedazy.dzienDo, "dd/mm/yyyy")#" />
					</div>
				</div>
				
				<div class="form-inline">
					<div class="form-group">
						<label><cfinput type="radio" name="grupowanie" value="none" />Brak grupowania</label>
					</div>
					<div class="form-group">
						<label><cfinput type="radio" name="grupowanie" value="week" />Grupuj tygodniami</label>
					</div>
					<div class="form-group">
						<label><cfinput type="radio" name="grupowanie" value="month" />Grupuj miesiącami</label>
					</div>
					
					<div class="form-group">
						<cfinput type="submit" name="raport_wplat_form_submit" value="Filtruj" class="btn btn-default" />
					</div>
				</div>
			</cfform>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfif isDefined("FORM")>
				<cfdump var="#FORM#" />
			</cfif>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>
