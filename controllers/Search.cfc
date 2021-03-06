<cfcomponent extends="Controller">

	<cffunction name="init">
		<cfset super.init() />
		<cfset filters(through="before") />
	</cffunction>

	<cffunction name="before">

		<!---
			Domyślne wartości atrybutów do paginowania wyników.
		--->
		<cfparam name="elements" default="15" />
		<cfparam name="workflow_page" default="1" />
		<cfparam name="user_page" default="1" />
		<cfparam name="instruction_page" default="1" />
		<cfparam name="workflow_order" 	default="data_wystawienia" />
		<cfparam name="user_order" default="sn" />
		<cfparam name="instruction_order" default="instruction_created" />
		<cfparam name="order" default="desc" />
		<cfparam name="result_type" default="1" />
		<cfparam name="search" default="" />

		<!---
			Sprawdzam, czy filtry paginacji są zdefiniowane w sesji.
			Jeżeli są to przepisuje je wewnątrz metody i robie odpowiednie
			zapytanie.
		--->
		<cfif structKeyExists(session, "search_filter") and
			structKeyExists(session.search_filter, "elements")>
			<cfset elements = session.search_filter.elements />
		</cfif>

		<cfif structKeyExists(session, "search_filter") and
			structKeyExists(session.search_filter, "workflow_page")>
			<cfset workflow_page = session.search_filter.workflow_page />
		</cfif>

		<cfif structKeyExists(session, "search_filter") and
			structKeyExists(session.search_filter, "user_page")>
			<cfset user_page = session.search_filter.user_page />
		</cfif>

		<cfif structKeyExists(session, "search_filter") and
			structKeyExists(session.search_filter, "instruction_page")>
			<cfset instruction_search = session.search_filter.instruction_page />
		</cfif>
		
		<cfif structKeyExists(session, "search_filter") and
			structKeyExists(session.search_filter, "workflow_order")>
			<cfset workflow_order = session.search_filter.workflow_order />
		</cfif>

		<cfif structKeyExists(session, "search_filter") and
			structKeyExists(session.search_filter, "user_order")>
			<cfset user_order = session.search_filter.user_order />
		</cfif>

		<cfif structKeyExists(session, "search_filter") and
			structKeyExists(session.search_filter, "instruction_order")>
			<cfset instruction_order = session.search_filter.instruction_order />
		</cfif>
		
		<cfif structKeyExists(session, "search_filter") and
			structKeyExists(session.search_filter, "order")>
			<cfset order = session.search_filter.order />
		</cfif>
		
		<cfif structKeyExists(session, "search_filter") and
			structKeyExists(session.search_filter, "result_type")>
			<cfset result_type = session.search_filter.result_type />
		</cfif>
		
		<cfif structKeyExists(session, "search_filter") and
			structKeyExists(session.search_filter, "search")>
			<cfset search = session.search_filter.search />
		</cfif>

		<!---
			Sprawdzam, czy zostały przekazane w formularzu ustawienia do wyszukiwania.
			Ustawieniami jest ilość elementów do wyświetlenia oraz strona wyników.
		--->
		<cfif structKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>

		<cfif structKeyExists(params, "workflow_page")>
			<cfset workflow_page = params.workflow_page />
		</cfif>

		<cfif structKeyExists(params, "user_page")>
			<cfset user_page = params.user_page />
		</cfif>

		<cfif structKeyExists(params, "instruction_page")>
			<cfset instruction_page = params.instruction_page />
		</cfif>
		
		<cfif structKeyExists(params, "workflow_order")>
			<cfset workflow_order = params.workflow_order />
		</cfif>

		<cfif structKeyExists(params, "user_order")>
			<cfset user_order = params.user_order />
		</cfif>

		<cfif structKeyExists(params, "instruction_order")>
			<cfset instruction_order = params.instruction_order />
		</cfif>
		
		<cfif structKeyExists(params, "order")>
			<cfset order = params.order />
		</cfif>
		
		<cfif structKeyExists(params, "result_type")>
			<cfset result_type = params.result_type />
		</cfif>

		<cfif structKeyExists(params, "search")>
			<cfset search = params.search />
		</cfif>

		<!---
			Zapisuje filtr w sesji.
		--->
		<cfset session.search_filter = {
			elements = elements,
			workflow_page = 1,
			user_page = 1,
			instruction_page = 1,
			workflow_order = workflow_order,
			user_order = user_order,
			instruction_order = instruction_order,
			order = order,
			result_type = result_type,
			search = search} />

		<!---
			Tutaj odbywa się cała metoda wyszukiwania danych w Intranecie.
			Do rozbudowania pozostaje wyszukiwanie po więcej niż jednym słowie...
		--->
		<cfset txt = URLDecode(search) />

		<!--- Oddzielam wyrazy po spacji. --->
		<cfparam name="arrayOfWhere" type="array" default=#ListToArray(txt, " ,", false)# />

	</cffunction>


	<!---
		9.04.2013
		Zmieniłem sposób wyszukiwania danych w systemie.
		Zakres przeszukiwania systemu jest zależny od uprawnień, które posiada
		użytkownik.
	--->
	<cffunction name="find" hint="Wyszukiwanie danych w intranecie" description="Metoda wyszukijąca dane wprowadzone w intranecie.">

		<cfif not StructKeyExists(params, "workflow_order")>
			<cfset workflow_order = 'data_wystawienia' />
		</cfif>

		<cfif not StructKeyExists(params, "user_order")>
			<cfset user_order = 'sn' />
		</cfif>

		<cfif not StructKeyExists(params, "instruction_order")>
			<cfset instruction_order = 'i.id' />
		</cfif>
		
		<cfif not StructKeyExists(params, "order")>
			<cfset order = 'desc' />
		</cfif>
		
		<cfif not StructKeyExists(params, "result_type")>
			<cfset result_type = 1 />
		</cfif>
		
		<!---
			Sprawdzam, czy użytkownik należy do grupy Centrala. Jak tak to
			szukam po fakturach, użytkownikach i Instrukcjach.
		--->

		<cfswitch expression="#params.SEARCH_CATEGORY#" >
			<!--- Wyszukiwanie w obiegu dokumentów. --->
			<cfcase value="WORKFLOWS">

				<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="privCentrala" >
					<cfinvokeargument name="groupname" value="Centrala" />
				</cfinvoke>

				<cfif privCentrala is not false>

					<cfset qWSearch = model("viewWorkflowSearch").search(
						search = arrayOfWhere,
						page = 1,
						elements = elements,
						userid = session.user.id,
						worder = workflow_order,
						order = order) />

					<cfset qWSearchCount = model("viewWorkflowSearch").searchCount(
						search = arrayOfWhere,
						userid = session.user.id) />
						
					<cfset renderPartial(partial="workflow") />

				</cfif>

			</cfcase>

			<!--- Wyszukiwanie w wewnętrznych aktach prawnych --->
			<cfcase value="INSTRUCTIONS">

				<cfset qISearch = model("instruction").search(
					userid = session.user.id,
					search = arrayOfWhere,
					page = 1,
					iorder = instruction_order,
					order = order,
					elements = elements,
					status = 1) />

				<cfset qISearchC = model("instruction").searchCount(
					userid = session.user.id,
					search = arrayOfWhere) />
				
				<cfset qISearchCount = {
					c = { c = 0 },
					a = { c = 0 }
				}/>
				
				<cfloop query="qISearchC">
					
					<cfswitch expression="#statusid#">
						<cfcase value="1">
							<cfset qISearchCount.c.c += c /> 
							
							<cfswitch expression="#documenttypeid#">
								<cfcase value="1">
									<cfset qISearchCount.c.i = c /> 
								</cfcase>
								<cfcase value="2">
									<cfset qISearchCount.c.w = c /> 
								</cfcase>
								<cfcase value="3">
									<cfset qISearchCount.c.r = c /> 
								</cfcase>
							</cfswitch>
						</cfcase>
						<cfcase value="2">
							<cfset qISearchCount.a.c += c />
							
							<cfswitch expression="#documenttypeid#">
								<cfcase value="1">
									<cfset qISearchCount.a.i = c /> 
								</cfcase>
								<cfcase value="2">
									<cfset qISearchCount.a.w = c /> 
								</cfcase>
								<cfcase value="3">
									<cfset qISearchCount.a.r = c /> 
								</cfcase>
							</cfswitch>
						</cfcase>
					</cfswitch>
					
				</cfloop>
				
				<cfset renderPartial(partial="instruction") />
			</cfcase>

			<!--- Wyszukiwanie użytkowników --->
			<cfcase value="USERS">

				<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
					<cfinvokeargument name="groupname" value="Centrala" />
				</cfinvoke>

				<cfif priv is not false>
					
					<cfset qUSearchCountP = 0 />
					<cfset qUSearchCount = 0 />

					<cfset qUSearch = model("user").search(
						search = arrayOfWhere,
						page = 1,
						elements = elements,
						uorder = user_order,
						order = 'asc',
						groupid = 9) />

					<cfset _qUSearchCount = model("user").searchCount(
						search = arrayOfWhere) />
						
					<cfloop query="_qUSearchCount">
						
						<cfswitch expression="#_qUSearchCount.groupid#">
							
							<cfcase value="8">
								<cfset qUSearchCountP =	_qUSearchCount.c />
							</cfcase>
							
							<cfcase value="9">
								<cfset qUSearchCount = _qUSearchCount.c />
							</cfcase>
								
						</cfswitch>

					</cfloop>

					<cfset renderPartial(partial="user") />

				</cfif>

			</cfcase>
			
			<!--- Przeszukuje dokumenty, które zostały błędnie wprowadzone --->
			<cfcase value="ARCHIVEDOCUMENTS">
				
				<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="grupaCentrala" >
					<cfinvokeargument name="groupname" value="Centrala" />
				</cfinvoke>
				
				<cfif grupaCentrala is true>
					
					<cfset bledneDokumenty = model("document_archive").search(search = arrayOfWhere) />
					<cfset renderPartial(partial="blednedokumenty") />
					
				</cfif>
				
			</cfcase>

		</cfswitch>

		<!---<cfset renderWith(data="",layout=false) />--->

	</cffunction>

	<cffunction
		name="findInstruction"
		hint="Wyszukiwanie Instrukcji w Intranecie."
		description="Wyszukiwanie instrukcji zawiera w sobie już uprawnienia
				uzytkownika do konkretnych dokumentów">

		<cfset qISearch = model("instruction").search(
			userid = session.user.id,
			search = arrayOfWhere,
			page = instruction_page,
			iorder = instruction_order,
			order = order,
			elements = elements,
			status = result_type
		)/>

		<cfset qISearchC = model("instruction").searchCount(
			userid = session.user.id,
			search = arrayOfWhere
		)/>
		
				<cfset qISearchCount = {
					c = { c = 0 },
					a = { c = 0 }
				}/>
				
				<cfloop query="qISearchC">
					
					<cfswitch expression="#statusid#">
						<cfcase value="1">
							<cfset qISearchCount.c.c += c /> 
							
							<cfswitch expression="#documenttypeid#">
								<cfcase value="1">
									<cfset qISearchCount.c.i = c /> 
								</cfcase>
								<cfcase value="2">
									<cfset qISearchCount.c.w = c /> 
								</cfcase>
								<cfcase value="3">
									<cfset qISearchCount.c.r = c /> 
								</cfcase>
							</cfswitch>
						</cfcase>
						<cfcase value="2">
							<cfset qISearchCount.a.c += c />
							
							<cfswitch expression="#documenttypeid#">
								<cfcase value="1">
									<cfset qISearchCount.a.i = c /> 
								</cfcase>
								<cfcase value="2">
									<cfset qISearchCount.a.w = c /> 
								</cfcase>
								<cfcase value="3">
									<cfset qISearchCount.a.r = c /> 
								</cfcase>
							</cfswitch>
						</cfcase>
					</cfswitch>
					
				</cfloop>

		<cfset renderWith(data="qISearch,qISearchCount",template="_instruction",layout=false) />

	</cffunction>

	<cffunction
		name="findWorkflow"
		hint="Wyszukiwanie faktur" >

		<cfset qWSearch = model("viewWorkflowSearch").search(
			search = arrayOfWhere,
			page = workflow_page,
			elements = elements,
			userid = session.user.id,
			worder = workflow_order,
			order = order) />

		<cfset qWSearchCount = model("viewWorkflowSearch").searchCount(
			search = arrayOfWhere,
			userid = session.user.id) />
		
			<cfset renderWith(data="qWSearch,qWSearchCount,workflow_page",template="_workflow",layout=false) />

	</cffunction>

	<cffunction
		name="findUsers"
		hint="Wyszukiwanie uytkowników">

		<cfset qUSearch = model("user").search(
			search = arrayOfWhere,
			page = user_page,
			elements = elements,
			uorder = user_order,
			order = order,
			groupid = 9) />
			
		<cfset qUSearchCountP = 0 />
		<cfset qUSearchCount = 0 />

		<cfset _qUSearchCount = model("user").searchCount(
			search = arrayOfWhere) />
			
		<cfloop query="_qUSearchCount">
						
			<cfswitch expression="#_qUSearchCount.groupid#">
							
				<cfcase value="8">
					<cfset qUSearchCountP =	_qUSearchCount.c />
				</cfcase>
							
				<cfcase value="9">
					<cfset qUSearchCount = _qUSearchCount.c />
				</cfcase>
								
			</cfswitch>

		</cfloop>
		
		<cfset renderWith(data="qUSearch,qUSearchCount,qUSearchCountP",template="_user",layout=false) />

	</cffunction>

</cfcomponent>