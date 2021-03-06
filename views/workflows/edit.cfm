<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="privZmianaKontrahenta" >
		<cfinvokeargument name="groupname" value="Zmiana kontrahenta" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="dfk" >
		<cfinvokeargument name="groupname" value="Departament Finansowy" />
	</cfinvoke>
	
	
</cfsilent>

<div class="headerArea">
	<div class="headerArea uiHeader">
		<h3 class="uiHeaderTitle">Dokument</h3>
	</div>
</div>

<!---<div class="headerArea">
	<div class="headerArea uiHeader">
		<a
			href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Users",action="getUserActiveWorkflow",key=session.user.id)#</cfoutput>', 'intranet_left_content');"
			title="Lista faktur">
				<span>Lista faktur</span>
		</a>
	</div>
</div>--->

<div class="headerNavArea">
	<div class="headerNavArea uiHeaderNavArea">
		<ul class="uiHeaderNavAreaList">
			<li>
				<a
					href="<cfoutput>#URLFor(controller='Documents',action='getDocument',key=workflow.documentid)#</cfoutput>"
					title="Pobierz PDF"
					target="_blank">
						<span>Pobierz PDF</span>
				</a>
			</li>

			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="privUsunDokument" >

				<cfinvokeargument
					name="groupname"
					value="Usuń dokument z obiegu" />

			</cfinvoke>

			<cfif privUsunDokument is true>

			<li>
				<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="delete",key=workflow.workflowid,params="documentid=#workflow.documentid#&cfdebug=true")#</cfoutput>', 'intranet_left_content');"
					title="Usuń dokument">
					<span>Usuń dokument</span>
				</a>
			</li>

			</cfif>


			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="privRoot" >

				<cfinvokeargument
					name="groupname"
					value="root" />

			</cfinvoke>

			<cfif privRoot is true>

			<li>
				<a href="javascript:ColdFusion.Window.create('edit-document-<cfoutput>#workflow.documentid#</cfoutput>', 'Edytuj dokument', '<cfoutput>#URLFor(controller="Documents",action="edit",key=workflow.documentid)#</cfoutput>', {height:400,width:500,modal:true,closable:true,draggable:true,resizable:true,center:true,initshow:true})"
					title="Edytuj dokumnt"
					class="">

					<span>Edytuj dokument</span>

				</a>
			</li>
			
			</cfif>
			
			<cfif privZmianaKontrahenta is true or privRoot is true>
				
			<li>
				<a href="javascript:ColdFusion.Window.create('change-contractor-<cfoutput>#DateFormat(Now(), 'yyyy-mm-dd-HH-mm-ss')#</cfoutput>', 'Zmień kontrahenta', 'index.cfm?controller=documents&action=change-contractor&documentid=<cfoutput>#workflow.documentid#</cfoutput>', {height:400,width:600,modal:true,closable:true,draggable:true,resizable:true,center:true,initshow:true})" title="Zmień kontrahenta" class="">
					<span>Zmień kontrahenta</span>
				</a>
			</li>

			</cfif>

			<cfinvoke
				component="models.WorkflowStep"
				method="isEditStep"
				returnvariable="priv" >

				<cfinvokeargument
					name="userid"
					value="#session.user.id#" />
				
				<cfinvokeargument
					name="workflowid"
					value="#workflow.workflowid#" />

			</cfinvoke>

			<cfif priv is true>

			<li>
				<a href="<cfoutput>#URLFor(controller="Workflows",action="moveInvoice", key=workflow.workflowid)#</cfoutput>"
					title="Przekaż dokument"
					class="moveWorkflow">

					<span>Przekaż dokument</span>

				</a>
			</li>
			
			</cfif>

			<cfinvoke
				component="controllers.Tree_groupusers"
				method="checkUserTreeGroup"
				returnvariable="privDekret" >

				<cfinvokeargument
					name="groupname"
					value="Dekret" />

			</cfinvoke>

			<cfif privDekret is true>

			<li>
				<a href="<cfoutput>#URLFor(controller="Workflows",action="decreenote",key=workflow.workflowid,params="format=pdf")#</cfoutput>"
					title="Dekret dokumentu"
					class=""
					target="_blank">

					<span>Dekret</span>

				</a>
			</li>

			</cfif>

			<li class="rborder">
				<a href="javascript:ColdFusion.navigate('<cfoutput>#URLFor(controller="Workflows",action="edit",key=workflow.workflowid)#</cfoutput>', 'intranet_left_content');"
					title="Odśwież">
					<span>Odśwież</span>
				</a>
			</li>

		</ul>
	</div>
</div>

<div class="contentArea">
	<div class="contentArea uiContent">

		<div class="uiWorkflow">

			<!---
				Okienko z kontrahentem na fakturze.
			--->
			<div class="uiWorkflowBox left">
				<div class="inner">
					<h3>Kontrahent</h3>
					<ul class="uiWorkflowList">
						<li><cfoutput>#contractor.str_logo#</cfoutput></li>
						<li><cfoutput>#contractor.nazwa2#</cfoutput></li>
						<li><cfoutput>#contractor.ulica# nr domu #contractor.nrdomu#</cfoutput></li>
						<li><cfoutput>#contractor.kodpocztowy#&nbsp;#contractor.miejscowosc#</cfoutput></li>
						<li><cfoutput>#contractor.nip#</cfoutput></li>
					</ul>
				</div>
			</div>

			<!---
				Okienko z danymi na fakturze.
			--->
			<div class="uiWorkflowBox right">
				<div class="inner">
					<h3>Faktura numer <cfoutput>#workflow.numer_faktury#</cfoutput></h3>
					<ul class="uiWorkflowList">
						<li><span>Zew nr faktury</span><cfoutput>#workflow.numer_faktury_zewnetrzny#</cfoutput></li>
						<li><span>Data wpływu</span><cfoutput>#workflow.data_wplywu#</cfoutput></li>
						<li><span>Data płatności</span><cfoutput>#workflow.data_platnosci#</cfoutput></li>
						<li><span>Data sprzedaży</span><cfoutput>#workflow.data_sprzedazy#</cfoutput></li>
						<li><span>Data wystawienia</span><cfoutput>#workflow.data_wystawienia#</cfoutput></li>
						<li><span>Brutto</span><cfoutput>#workflow.brutto#</cfoutput></li>
						<li><span>Netto</span><cfoutput><span class="finallprice">#workflow.netto#</span></cfoutput></li>
					</ul>
				</div>
			</div>
			
			<div class="clearfix"></div>
			
			<div class="uiWorkflowBox left">
				<div class="inner">
					Dokument wprowadził/a <span><cfoutput>#basicInformations.givenname# #basicInformations.sn#</cfoutput></span> dnia <span><cfoutput>#DateFormat(basicInformations.documentcreated, "yyyy/mm/dd")#</cfoutput></span> o godzinie <span><cfoutput>#TimeFormat(basicInformations.documentcreated, "HH:mm")#</cfoutput></span>.
					
					<div class="zalacznikDoFaktury">
						<ul>
							<li>
								<a href="javascript:void(0);" onclick="initCfWindow('index.cfm?controller=documents&action=document-attachment&documentid=<cfoutput>#workflow.documentid#</cfoutput>', 'Załączniki do faktury')" class="zalacznikDoFakturyLink" title="Załączniki do faktury">
									<span>Załączniki do faktury (<cfoutput>#numberOfAttachments#</cfoutput>)</span>
								</a>

							</li>
							<cfloop query="workflowSteps">
								<cfif workflowstatusid EQ 1 AND userid EQ session.user.id AND workflowstepstatusid EQ 1>
									<li>
										<a href="javascript:ColdFusion.Window.create('document-archive-<cfoutput>#workflow.documentid#</cfoutput>', 'Przenieś doarchiwum', 'index.cfm?controller=documents&action=move-to-archive&documentid=<cfoutput>#workflow.documentid#</cfoutput>', {height:400,width:600,modal:true,closable:true,draggable:true,resizable:true,center:true,initshow:true})" class="archiwumDokumentuLink" title="Przenieś do archiwum">
											<span>Przenieś do archiwum</span>
										</a>
									</li>
								</cfif>
							</cfloop>
							<cfif IsDefined("document") AND document.paid EQ 0 AND IsDefined("dfk") AND dfk is true>
							<li>
								<a href="javascript:void(0)" onclick="paidDocument(<cfoutput>#workflow.documentid#</cfoutput>, $(this))" class="paidDocumentLink" title="Oznacz fakturę jako opłaconą">
									<span>Znacz jako opłaconą</span>
								</a>
							</li>
							</cfif>
						</ul>
					</div>
				</div>
			</div>
			
			<!---<cfif privRoot is true>
				<div class="uiWorkflowBox right">
					<div class="inner">
						<ul class="uiWorkflowList">
							<li><span>documentid</span><cfoutput>#workflow.documentid#</cfoutput></li>
							<li><span>workflowid</span><cfoutput>#workflow.workflowid#</cfoutput></li>
						</ul>
					</div>
				</div>
			</cfif>--->
			
			<cfif IsDefined("archiwum")>
				
				<div class="uiWorkflowBox right" style="margin-top:20px;">
					<div class="inner">
						Korekta do faktury <span><cfoutput>#archiwum.nr#</cfoutput></span>.
						Przeniesiono do archiwum przez <span><cfoutput>#archiwum.givenname# #archiwum.sn#</cfoutput></span> dnia <span><cfoutput>#DateFormat(archiwum.created, "yyyy/mm/dd")#</cfoutput></span> o godzinie <span><cfoutput>#TimeFormat(archiwum.created, "HH:mm")#</cfoutput></span>.
						<br /><br />
						<span>Komentarz</span><br />
						<cfoutput>#archiwum.reason#</cfoutput>
					</div>
				</div>
				
			</cfif>
			
			<div class="clearfix"></div>
			
			<!---
				Obieg dokumentu finansowo księgowego.
			--->
			<div class="uiWorkflowBigBox clearfix">
				<!---<div class="inner">--->
					<h3>Obieg dokumentu</h3>
					<cfloop query="workflowSteps">
						<!---
							Sprawdzam, czy dany etap jest w trakcie.
							W przeważającej ilości przypadków etap, który jest w
							trakcie będzie u góry.

							Dla etapu, który jest w trakcie trochę inaczej
							będzie wyglądał formularz.
						--->
						<cfif workflowstatusid EQ 1 AND userid EQ session.user.id> <!--- W trakcie --->

							<div class="uiWorkflowBigBoxStepContent">

							<cfswitch expression="#workflowstepstatusid#">

								<cfcase value="1"> <!--- Opisywanie --->
									<h4><cfoutput>#workflowstepstatusname#</cfoutput></h4>
									<h5 class="workflowStepSummary">
										Utworzono <span><cfoutput>#DateFormat(workflowstepcreated, "dd.mm.yyyy")#</cfoutput></span> o godzinie <span><cfoutput>#TimeFormat(workflowstepcreated, "HH:mm")#</cfoutput></span>. Osoba odpowiedzialna <span><cfoutput>#givenname# #sn#</cfoutput></span>
									</h5>

									<cfinclude template="steps/opisywanie.cfm" />
								</cfcase>

								<cfcase value="2"> <!--- Controlling --->
									<h4><cfoutput>#workflowstepstatusname#</cfoutput></h4>
									<h5 class="workflowStepSummary">
										Utworzono <span><cfoutput>#DateFormat(workflowstepcreated, "dd.mm.yyyy")#</cfoutput></span> o godzinie <span><cfoutput>#TimeFormat(workflowstepcreated, "HH:mm")#</cfoutput></span>. Osoba odpowiedzialna <span><cfoutput>#givenname# #sn#</cfoutput></span>
									</h5>

									<!---<cfinclude template="steps/controlling.cfm" />--->
									
									<!---<cfif session.user.id eq 345>--->
										
										<div>
											<a
												href="<cfoutput>#URLFor(controller='Workflows',action='rejectInvoice', key=workflow.workflowid, params='workflowstep=controlling')#</cfoutput>"
												title="Odrzucam"
												class="uiSubmitInvoice submitGray rejectInvoice">
													<span>Odrzucam</span>
											</a>
											<a
												href="<cfoutput>#URLFor(controller='Workflows',action='acceptInvoice', key=workflow.workflowid, params='workflowstep=controlling')#</cfoutput>"
												title="Prawidłowy dekret"
												class="uiSubmitInvoice submitRed acceptInvoice">
													<span>Prawidłowy dekret</span>
											</a>
										</div>
										
									<!---</cfif>--->
									
								</cfcase>

								<cfcase value="3"> <!--- Akceptacja dyrektora --->
									<h4><cfoutput>#workflowstepstatusname#</cfoutput></h4>
									<h5 class="workflowStepSummary">
										Utworzono <span><cfoutput>#DateFormat(workflowstepcreated, "dd.mm.yyyy")#</cfoutput></span> o godzinie <span><cfoutput>#TimeFormat(workflowstepcreated, "HH:mm")#</cfoutput></span>. Osoba odpowiedzialna <span><cfoutput>#givenname# #sn#</cfoutput></span>
									</h5>

									<cfset tmp = workflowstepstatusid />
									<!---<cfinclude template="steps/dyrektor.cfm" />--->
									
									<!---<cfif session.user.id eq 345>--->
										<div>
											<a
												href="<cfoutput>#URLFor(controller='Workflows',action='rejectInvoice', key=workflow.workflowid, params='workflowstep=dyrektor&workflowstepstatusid=#workflowstepstatusid#')#</cfoutput>"
												title="Odrzucam"
												class="uiSubmitInvoice submitGray rejectInvoice">
													<span>Odrzucam</span>
											</a>
											<a
												href="<cfoutput>#URLFor(controller='Workflows',action='acceptInvoice', key=workflow.workflowid, params='workflowstep=dyrektor&workflowstepstatusid=#workflowstepstatusid#')#</cfoutput>"
												title="Zatwierdzam"
												class="uiSubmitInvoice submitRed acceptInvoice">
													<span>Zatwierdzam</span>
											</a>
										</div>
									<!---</cfif>--->
									
								</cfcase>

								<cfcase value="4"> <!--- Księgowość --->
									<h4><cfoutput>#workflowstepstatusname#</cfoutput></h4>
									<h5 class="workflowStepSummary">
										Utworzono <span><cfoutput>#DateFormat(workflowstepcreated, "dd.mm.yyyy")#</cfoutput></span> o godzinie <span><cfoutput>#TimeFormat(workflowstepcreated, "HH:mm")#</cfoutput></span>. Osoba odpowiedzialna <span><cfoutput>#givenname# #sn#</cfoutput></span>
									</h5>

									<cfset tmp = workflowstepstatusid />
									<!---<cfinclude template="steps/ksiegowosc.cfm" />--->
									
									<!---<cfif session.user.id eq 345>--->
										<div>
											<a
												href="<cfoutput>#URLFor(controller='Workflows',action='rejectInvoice', key=workflow.workflowid, params='workflowstep=ksiegowosc&workflowstepstatusid=#workflowstepstatusid#')#</cfoutput>"
												title="Odrzucam"
												class="uiSubmitInvoice submitGray rejectInvoice">
													<span>Odrzucam</span>
											</a>
											<a
												href="<cfoutput>#URLFor(controller='Workflows',action='acceptInvoice', key=workflow.workflowid, params='workflowstep=ksiegowosc&workflowstepstatusid=#workflowstepstatusid#')#</cfoutput>"
												title="Księguje"
												class="uiSubmitInvoice submitRed acceptInvoice">
													<span>Księguje</span>
											</a>
										</div>
									<!---</cfif>--->
								</cfcase>

								<cfcase value="5"> <!--- Akceptacja Prezesa --->
									<h4><cfoutput>#workflowstepstatusname#</cfoutput></h4>
									<h5 class="workflowStepSummary">
										Utworzono <span><cfoutput>#DateFormat(workflowstepcreated, "dd.mm.yyyy")#</cfoutput></span> o godzinie <span><cfoutput>#TimeFormat(workflowstepcreated, "HH:mm")#</cfoutput></span>. Osoba odpowiedzialna <span><cfoutput>#givenname# #sn#</cfoutput></span>
									</h5>

									<cfset tmp = workflowstepstatusid />
									<cfinclude template="steps/prezes.cfm" />
								</cfcase>

								<cfdefaultcase>

								</cfdefaultcase>

							</cfswitch>

							</div> <!--- end .uiWorkflowBigBoxStepContent --->

						<cfelse> <!--- Etap inny niż W trakcie --->

							<div class="uiWorkflowBigBoxStep">
								<h4><cfoutput>#workflowstepstatusname#</cfoutput></h4>
								<h5 class="workflowStepSummary <cfif workflowstatusid EQ 2> uiWorkflowGreen <cfelseif workflowstatusid EQ 3> uiWorkflowRed</cfif>">
									Utworzono <span><cfoutput>#DateFormat(workflowstepcreated, "dd.mm.yyyy")#</cfoutput></span> o godzinie <span><cfoutput>#TimeFormat(workflowstepcreated, "HH:mm")#</cfoutput></span>. Osoba odpowiedzialna <span><cfoutput>#givenname# #sn#</cfoutput></span>
								</h5>
								<h5 class="workflowStepSummary <cfif workflowstatusid EQ 2> uiWorkflowGreen <cfelseif workflowstatusid EQ 3> uiWorkflowRed</cfif>">
									Zmieniono status <span><cfoutput>#DateFormat(workflowstepended, "dd.mm.yy")#</cfoutput></span> o godzinie <span><cfoutput>#TimeFormat(workflowstepended, "HH:mm")#</cfoutput></span> na <span><cfoutput>#workflowstatusname#</cfoutput></span> z komentarzem <span class="redText italicText normalText"><cfoutput>#workflowsteptransfernote#</cfoutput></span>
								</h5>

								<!---
									Sprawdzam, czy jestem na kroku opisywania.
									Jeżeli tak to generuje listę z MPKami i
									Projektami.
								--->
								<cfswitch expression="#workflowstepstatusid#">

									<cfcase value="1"> <!--- Wyświetlam listę z mpkami i projektami --->

										<div class="uiWorkflowBox left">
											<div class="inner">
												<h3>Opis faktury</h3>
												<ul class="uiWorkflowList">
													<cfloop query="workflowDescription">
														<li>
															<span><cfoutput>#mpk#</cfoutput></span>
															<span><cfoutput>#projekt#</cfoutput></span>
															<span><cfoutput>#workflowstepdescription#</cfoutput></span>
														</li>
													</cfloop>
												</ul>
											</div>
										</div>

										<div class="uiWorkflowBox right">
											<div class="inner">
												<h3>Notka merytoryczna</h3>
												<cfoutput>#workflowstepnote#</cfoutput>
											</div>
										</div>

										<div class="clearfix"></div>

									</cfcase>

									<cfdefaultcase>

									</cfdefaultcase>

								</cfswitch>

							</div>

						</cfif>

					</cfloop>
				<!---</div>--->
			</div> <!--- end .uiWorkflowBigBox --->

		</div>

		<div class="uiFooter">
			<cfoutput>

			</cfoutput>
		</div>
	</div>
</div>

<div class="footerArea">

</div>
<cfset AjaxOnLoad("initWorkflow") />
<cfset AjaxOnLoad("initWorkflowActions") />