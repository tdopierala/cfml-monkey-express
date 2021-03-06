<!---  Protocols.cfc --->
<!--- @@Created By: TD Monkey Group 2012 --->
<!---
Komponent obsługujący protokoły w systemie.
Ajenci mogą generować dokumenty jak na przykład Protokół rozbieżności. Dokumenty są zapisywane
--->
<cfcomponent extends="Controller">

	<cffunction name="init">
	
		<cfset super.init() />
		<cfset provides("html,json,xml,pdf") />
	
	</cffunction>
	
	<!---
	index
	---------------------------------------------------------------------------------------------------------------
	Widok, który ajaxowo pobiera listę wszystkich protokołów Ajenta.
	
	--->
	<cffunction 
		name="index"
		hint="Lista dostępnych protokołów"
		description="Widok który Ajaxowo pobiera listę wszystkich protokołów Ajenta.">
	
	
	
	</cffunction>
	
	<!---
	getProtocolsList
	---------------------------------------------------------------------------------------------------------------
	Lista wszystkich protokołów Ajenta. Widok jest renderowany Ajaxowo przez co nie ma szablonu (layout=false).
	
	--->
	<cffunction
		name="getProtocolsList"
		hint="Pobieram listę protokołów użytkownika"
		description="Metoda pobierająca listę wszystkich protokołów użytkownika. Listę można filtrować/sortować">
	
		<cfset protocols = model("viewProtocolHeader").findAll(where="userid=#session.userid#",order="protocolcreated DESC") />
		<cfset renderWith(data="protocols",layout=false) />
	
	</cffunction>

	<!---
	addProtocol
	---------------------------------------------------------------------------------------------------------------
	Dodanie nowego protokołu do systemu.
	
	--->
	<cffunction 
		name="addProtocol"
		hint="Dodawanie nowego protokołu przez Ajenta"
		description="Metoda generująca widok z formularzem dodawania nowego protokołu.">
		
		<!--- Ustawiam w sesji Lp. dla protokołu. Ta wartość będzie inkrementowana w metodzie pobierającej wiersz --->
		<cfset session.protocol = {} />
		<cfset session.protocol.lp = 1 />
		
		<!--- Pobranie typów protokołow --->
		<cfset protocoltypes = model("protocolType").findAll() />
		
		<cfset renderWith(data="protocoltypes",layout=false) />
	
	</cffunction>
	
	<!---
	getProtocolHeader
	---------------------------------------------------------------------------------------------------------------
	Metoda wyszukuje w bazie pola opisujące nagłowek protokołu i zwraca odpowiednią strukturę do widoku.
	
	--->
	<cffunction
		name="getProtocolHeader"
		hint="Metoda zwraca nagłówek protokołu"
		description="Metoda wyszukuje w bazie pola opisujące nagłówek protokołu i zwraca odpowiednią strukturę do widoku.">
	
		<cfset protocolattributes = model("protocolTypeAttribute").findAll(where="protocoltypeid=#params.key# AND header=1",include="attribute(attributeType)") />
		<cfset renderWith(data="protocolattributes",layout=false) />
	
	</cffunction>
	
	<!---
	getProtocolContent
	---------------------------------------------------------------------------------------------------------------
	Metoda pobierająca treść protokołu. Utworzone są statyczne widoki. 
	Metoda na podstawie przesłanego parametru wybiera, który widok ma wyrenderować.
	
	--->
	<cffunction 
		name="getProtocolContent"
		hint="Pobranie treści protokołu"
		description="Metoda pobierająca treść protokołu. Utworzone są statyczne widoku. Metoda na podstawie przesłanego parametru wybiera, który widok ma wyrenderować.">
		
		<cftry>
		
			<!--- Pobieram stosowne pola protokołu w zależności od jego typu --->
			<cfset protocolfields = model("protocolTypeAttribute").findAll(where="protocoltypeid=#params.key# AND content=1",include="attribute",order="ord asc") />
		
			<cfswitch expression="#params.key#">
		
				<cfcase value="1">
					<cfset selectoptions = model("selectValue").findAll(select="selectvalue,selectlabel",where="protocoltypeid=#params.key# AND attributeid=116") />
					<cfset returnselectoptions = model("selectValue").findAll(select="selectvalue,selectlabel",where="protocoltypeid=#params.key# AND attributeid=119") />
					<!---
					19.07.2012
					Pobieram część footer protokołu
					--->
					
					<cfset protocolfooter = model("protocolTypeAttribute").findAll(where="protocoltypeid=#params.key# AND footer=1",include="attribute") />
			
					<cfset renderWith(data="protocolfields,selectoptions,protocolfooter",layout=false,template="differenceprotocol") />
				</cfcase>
			
				<cfdefaultcase>
				
				</cfdefaultcase>
		
			</cfswitch>
		
		<cfcatch type="any"> <!--- Przechwytuje wyjątek strony i wyświetlam komunikat błędu --->
		
			<cfset renderWith(data="",layout=false,template="/apperror") /> <!--- Komunikat błędu aplikacji --->
		
		</cfcatch>
		
		</cftry>
	
	</cffunction>
	
	<!---
	getProtocolContentRow
	---------------------------------------------------------------------------------------------------------------
	Metoda pobierająca pojedyńczy nowy wiersz do protokołu. Przekazywany jest id typu protokołu aby pobrać odpowiednie pola.
	Metoda generuje losowy ciąg znaków aby pola były unikalne.
	
	--->
	<cffunction
		name="getProtocolContentRow"
		hint="Pobranie jednego wiersza do protokołu"
		description="Metoda pobierająca pojedyńczy nowy wiersz do protokołu. Przekazywany jest id typu protokołu aby pobrać odpowiednie pola">
		
		<!--- Zwiększam licznik Lp. dla protokołu --->
		<cfset session.protocol.lp++ />
		
		<!--- Lista pół protokołu --->
		<cfset protocolfields = model("protocolTypeAttribute").findAll(where="protocoltypeid=#params.protocoltypeid# AND content=1",include="attribute",order="ord asc") />
		
		<cfset selectoptions = model("selectValue").findAll(select="selectvalue,selectlabel",where="protocoltypeid=#params.protocoltypeid# AND attributeid=116") />
		<cfset returnselectoptions = model("selectValue").findAll(select="selectvalue,selectlabel",where="protocoltypeid=#params.protocoltypeid# AND attributeid=119") />
		
		<!--- Losowy ciąg znaków --->
		<cfset random = randomText(length=6) />
		
		<cfset renderWith(data="protocolfields,random,selectoptions,returnselectoptions",layout=false) />
	
	
	</cffunction>
	
	<!---
	actionAddProtocol
	---------------------------------------------------------------------------------------------------------------
	Metoda zapisuje protokół w systemie. Po zapisaniu użytkownik jest przenoszony do strony, która generuje dokument PDF do wydruku.
	Dane przekazane do metody są dość zagmatwaną strukturą. Można wydzielić dwie jej częsi: protocolheader i protocolcontent.
	
	protocolheader - nagłówek protokołu, w którym są pojedyńcze wartości
	protocolcontent - treść protokołu, w której znajduje się wiele wartości tych samych parametrów
	
	26.04.2012
	Metoda została zmodyfikowana o zapisywanie nowego formatu numeru protokołu: NR/ROK/NR AJENTA.
	Atrybut z numerem protokołu ma ID w bazie 121
	--->
	<cffunction
		name="actionAddProtocol"
		hint="Metoda zapisująca protokół w systemie"
		description="Metoda zapisuje protokół w systemie. Po zapisaniu użytkownik jest przenoszony do strony, która generuje dokument PDF do wydruku.">
		
		<!--- Tworze nowy protokół w bazie --->
		<cfset protocol = model("protocol").new() />
		<cfset protocol.userid = session.userid />
		<cfset protocol.protocolcreated = Now() />
		<cfset protocol.protocoltypeid = params.protocoltypeid />
		<cfset protocol.save(callbacks=false) />
		
		<!--- Zapisanie numeru protokołu jako nowego atrybutu --->
		<cfset protocolnumber = model("protocolAttributeValue").new() />
		<cfset protocolnumber.attributeid = 121 /> <!--- Identyfikator atrybutu do przechowywania numeru protokołu --->
		<cfset protocolnumber.protocolid = protocol.id />
		<cfset protocolnumber.protocolattributevalue = "#protocol.id#/#DateFormat(Now(), 'yyyy')#/#session.user.login#" /> <!--- Numer protokołu --->
		<cfset protocolnumber.protocoltypeid = params.protocoltypeid />
		<cfset protocolnumber.save(callbacks=false) />
		
		<!--- Pętla przechodząca przez wszystkie pola nagłówka protokołu --->
		<cfloop collection="#params.protocolheader#" item="j">
			
			<cfset protocolattributevalue = model("protocolAttributeValue").new() />
			<cfset protocolattributevalue.attributeid = j />
			<cfset protocolattributevalue.protocoltypeid = params.protocoltypeid />
			<cfset protocolattributevalue.protocolattributevalue = params.protocolheader[j] />
			<cfset protocolattributevalue.protocolid = protocol.id />
			<cfset protocolattributevalue.save(callbacks=false) />
			
		</cfloop>
		
		<!--- Główna pętla, która przechodzi wrzez wszystkie pola treści protokołu --->
		<cfloop collection="#params.protocolcontent#" item="i">
			
			<!--- Zmienna z tymczasową strukturą --->
			<cfset loc.tmpstruct = params.protocolcontent[i] />
			
			<!--- Teraz będę przechodził przez wszystkie pola ze zmiennej tymczasowej i zapisywał je w bazie --->
			<cfloop collection="#loc.tmpstruct#" item="tmpi">
				<cfset protocolattributevalue = model("protocolAttributeValue").new() />
				<cfset protocolattributevalue.attributeid = tmpi />
				<cfset protocolattributevalue.protocoltypeid = params.protocoltypeid />
				<cfset protocolattributevalue.protocolattributevalue = loc.tmpstruct[tmpi] />
				<cfset protocolattributevalue.protocolid = protocol.id />
				<cfset protocolattributevalue.row = i />
				<cfset protocolattributevalue.save(callbacks=false) />
			</cfloop>
			
		</cfloop>
	
		<!--- Przekierowanie użytkownika do strony generującej plik PDF protokołu --->
		<cfset redirectTo(controller="Protocols",action="getProtocolPdf",key=protocol.id,params="format=pdf") />
	
	</cffunction>
	
	<cffunction 
		name="getProtocolPdf"
		hint="Metoda generująca protokół do pliku PDF"
		description="Metoda generująca protokół do pliku PDF">
	
		<!--- Pobieram protokół --->
		<cfset protocol = model("protocol").findOne(where="id=#params.key#") />
		
		<!--- Pobieram nagłówek protokołu --->
		<cfset protocolheader = model("protocolAttributeValue").findAll(where="protocolid=#params.key# AND header=1",include="attribute",order="ord asc") />
		
		<!--- Pobieram zawartość protokołu --->
		<cfset protocolcontent = model("protocolContent").findAll(where="protocolid=#params.key#",order="lp asc") />
		
		<!--- 
		19.07.2012
		Pobieram stopkę (dodatkowe pola) protokołu
		--->
		<cfset protocolfooter = model("protocolAttributeValue").findAll(where="protocolid=#params.key# AND footer=1",include="attribute") />
		
		<cfset renderWith(data="protocol,protocolheader,protocolcontent,protocolfooter",layout=false) />
	
	</cffunction>

</cfcomponent>