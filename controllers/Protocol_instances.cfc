<cfcomponent
	extends="mc">
		
	<cffunction
		name="init">
	
		<cfset super.init() />
		<cfset filters(through="beforeRender",except="add,newProtocol,save,removeRow") />
		
	</cffunction>
	
	<cffunction 
		name="beforeRender" >
		
		<cfset super.beforeRender() />
		
		<!---
			22.01.2013
			Tutaj pobieram wszystkie wartości do pól wyboru.
			Wartości zapisane są w strukturze.
		--->
		
		<!---
			Najpierw pobieram listę id pól, które są selectboxami
		--->
		<cfset my_selectboxes = model("protocol_fields").findAll(select="id",where="fieldtypeid=4") />
		
		<!---
			Tworzę strukturę do przechowywania wartości.
		--->
		<cfset my_selectbox_values = structNew() />
		<cfloop query="my_selectboxes" >
			<cfset my_selectbox_values[id] = model("protocol_fieldvalue").findAll(where="fieldid=#id#") />
		</cfloop>
		
	</cffunction>
	
	<cffunction
		name="add"
		output="false">
		
		<cfset mytypes = model("protocol_type").getTypes() />
		
	</cffunction>
	
	<cffunction
		name="newProtocol"
		output="false">
			
		<!---
			1.02.2013
			Tutaj generuje numer protokołu w postaci
			Cxxxxx/ROK/MIES/NR
		--->	
		
		<cfset protocol_number = session.user.login & "/" & DateFormat(Now(), "yyyy") & "/" & DateFormat(Now(), "mm") & "/" />
		
		<!---
			Pobieram numer protokołu.
		--->
		<cfset my_protocol_number = model("protocol_number").findOne(where="userid=#session.userid#") />
		<cfset protocol_number &= my_protocol_number.protocolnumber />
		
		<!---
			Inkrementuje numer protokołu
		--->
		<cfset my_protocol_number.update(
			protocolnumber	=	my_protocol_number.protocolnumber+1,
			callbacks		=	false) />
			 
		<cfset myinstance = model("protocol_instance").new() />
		<cfset myinstance.userid = session.userid />
		<cfset myinstance.instance_created = Now() />
		<cfset myinstance.typeid = params.key />
		<cfset myinstance.protocolnumber = protocol_number />
		<cfset myinstance.save(callbacks=false) />
		
		<cfset redirectTo(controller="Protocol_instances",action="view",key=myinstance.id,params="typeid=#myinstance.typeid#") />
					
	</cffunction>
	
	<!---
		Wyświetlenie formularza protokołu.
		
		TODO
		13.12.2012
		Dorobić przenoszenie protokołów do archiwum.
	--->
	<cffunction
		name="view"
		output="false">
		
		<cftry>
			
		<!---
			Tutaj pobieram podstawowe informacje o protokole
		--->
		<cfset myprotocolinfo = model("protocol_type").findByKey(params.typeid) />
			
		<!---
			Najpierw pobieram grupy, które muszą być wyświetlone.
		--->
		<cfset mygroups = model("protocol_group").getTypeGroups(typeid=params.typeid) />

		<!--- 
			Mając listę grup przechodzę przez wszystkie grupy i pobieram pola danej grupy.

			2.0.2013
			Zmieniłem sposób generowania danych do protokołu. Zamiast
			struktury używam tablicy - w tablicy można ustalić kolejność elementów.
		--->
		<cfset myprotocol_array = arrayNew(1) />
		<cfset myprotocol_array_item = 1 />
		
		<cfloop query="mygroups">
			<cfif access eq 1>
		
			<cfset myprotocol_array[myprotocol_array_item] = structNew() />
			<cfset myprotocol_array[myprotocol_array_item].repeat = grouprepeat />
			<cfset myprotocol_array[myprotocol_array_item].groupid = groupid />
			<cfset myprotocol_array[myprotocol_array_item].groupname = groupname />
			<cfset myprotocol_array[myprotocol_array_item].typeid = params.typeid />
			<cfset myprotocol_array[myprotocol_array_item].instanceid = params.key />
			<cfset tmpgroupid = groupid />
			
			<cfset myrows = model("protocol_instancevalue").getRows(select="distinct row",where="instanceid=#params.key# and typeid=#params.typeid# and groupid=#groupid# order by row asc") />
			<cfdump var=#myrows# />
 			
			<!---
				Przechodzę przez wszystkie wiersze i wyciągam elementy.
			--->
			<cfloop query="myrows">
					
					<!---<cfset arrayAppend(myprotocol_array[myprotocol_array_item].query, row) />---> 
					<!---<cfset myprotocol_array[myprotocol_array_item].query[tmp_counter] = "q" />--->
					<cfset myprotocol_array[myprotocol_array_item].query[row+1] = model("protocol_instancevalue").getRows(select="protocol_instancevalues.id,fieldname,fieldid,fieldvalue,protocol_fields.fieldtypeid,fieldclass,readonly",where="instanceid=#params.key# and typeid=#params.typeid# and groupid=#tmpgroupid# and row=#row#") />
					
					<!---<cfset arrayInsertAt(myprotocol_array[myprotocol_array_item].query, row+1, row) />--->
					<!---<cfset myprotocol_array[myprotocol_array_item].query[row+1] = row />--->
					
					<!---<cfdump var="#row#" />--->
					
					<!---<cfset arrayInsertAt(myprotocol_array[myprotocol_array_item].query, 1, tmp123) />--->
					<!---<cfset myprotocol_array[myprotocol_array_item].query[row + 1] = model("protocol_instancevalue").getRows(select="protocol_instancevalues.id,fieldname,fieldid,fieldvalue",where="instanceid=#params.key# and typeid=#params.typeid# and groupid=#tmpgroupid# and row=#row#") />--->
				
			</cfloop>
			
			<cfelse>
				
				<cfset myprotocol_array[myprotocol_array_item] = structNew() />
			
			</cfif>
			
			<cfset myprotocol_array_item++ />
			
		</cfloop> <!--- loop po mygroups --->
			
			
		<cfset myinstnceid = params.key />
			
		<cfif structKeyExists(params, "format")>
			<cfset protocol = model("protocol_instance").findByKey(params.key) />
			<cfset renderWith(data="myinstance,myprotocol_array,protocol,my_selectbox_values",layout=false) />
		</cfif>
		
		<cfcatch type="any">
			<cfset error = cfcatch />
	
				<cfset renderWith(data="error",template="/apperror") />
			
		</cfcatch>
		
		</cftry>
		
	</cffunction>
	
	<cffunction
		name="save"
		output="false">
		
		<!---
			2.01.2013
			W pętli zapisuje wartości protokołu. Po zapisaniu przenosze do pliku PDF.
		--->
		<cfloop collection="#params.instancevalue#" item="i" >
			<cfset myrow = model("protocol_instancevalue").findByKey(i) />
			<cfset myrow.update(
				fieldvalue		=		params.instancevalue[i],
				callbacks		=		false) />	
		</cfloop>
		
		<cfset redirectTo(controller="Protocol_instances",action="view",key=params.key,params="typeid=#params.typeid#&format=pdf") />
			
	</cffunction>
	
	<cffunction
		name="index"
		hint="Lista protokołów zdefiniowanych przez użytkownika">
			
		<cfparam
			name="page"
			default="1" />
			
		<cfparam
			name="elements"
			default="25" />
			
		<!--- 
			Sprawdzam, czy przesłano dane do paginacji
		--->
		<cfif structKeyExists(params, "page")>
			<cfset page = params.page />
		</cfif>
		
		<cfif structKeyExists(params, "elements")>
			<cfset elements = params.elements />
		</cfif>
		
		<!---
			Zapisuje w sesji dane niezbędne do paginacji.
		--->
		<cfset session.workflow_filter = {
			page		=	page,
			elements	=	elements
			} />
	
		<cfset myprotocols = model("protocol").getUserProtocols(
			userid		=	session.userid,
			elements	=	elements,
			page		=	page) />
		<cfset myprotocolscount = model("protocol").getUserProtocolsCount(userid=session.userid) />
	
	</cffunction>
	
	<cffunction
		name="addRow"
		hint="Dodanie nowego wiersza do protokołu">
	
		<cfset new_row = model("protocol_instancevalue").addRow(
			instanceid		=	params.instanceid,
			typeid			=	params.typeid,
			groupid			=	params.groupid) />
			
		<cfset groupid		=	params.groupid />
		<cfset typeid		=	params.typeid />
		<cfset instaceid	=	params.instanceid />
		
		<cfset row_number = 0 />
		<cfset row_number = model("protocol_instancevalue").getRows(select="max(row) as m",where="instanceid=#params.instanceid# and typeid=#params.typeid# and groupid=#groupid#") />
	
	</cffunction>
	
	<cffunction
		name="removeRow"
		hint="Usunięcie wiersza w protokołu">
	
		<cfset remove_row = model("protocol_instancevalue").deleteAll(where="instanceid=#params.instanceid# AND typeid=#params.typeid# AND groupid=#params.groupid# AND row=#params.row#",instantiate=false) />
	
	</cffunction>
	
	<cffunction
		name="summary"
		hint="Metoda generująca podsumowanie protokołów.">
			
		<cfset my_dates = model('protocol_instance').getDates() />
			
	</cffunction>
	
	<cffunction
		name="summaryDay"
		hint="Lista protokołów z danego dnia"
		description="Metoda pobiera listę protokołów na dany dzień. Dzień jest przekazywany jako parametr.">
	
		<cfset my_protocols = model('protocol_instance').getProtocols(
			day			=		params.day,
			month		=		params.month,
			year		=		params.year) />
			
	</cffunction>
	
	<!---
		26.02.2013
		Metoda pobierająca listę protokołów użytkownika.
		Protokoły są pobierane na podstawie identyfikatora użytkownika
		przechowywango w sesji.
	--->
	<cffunction
		name="getUserProtocols"
		hint="Pobieranie protokołów użytkownika">
			
		<!---
			Pobieram listę protokołów ajenta.
			Sposób pobierania protokołów uległe małej zmianie. Teraz pobieram pierwszą stronę wyników.
			Nie generuje paginacji. Aby mieć wszystko user musi przejść na stronę 
			wszystkich protokołów.
		--->
		<cfset myprotocols = model("protocol").getUserProtocols(
			userid		=	session.userid,
			elements	=	12,
			page		=	1) />
			
	</cffunction>
		
</cfcomponent>