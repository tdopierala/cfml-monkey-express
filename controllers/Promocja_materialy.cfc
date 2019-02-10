<cfcomponent displayname="Promocja_materialy" output="false" extends="Controller" hint="">
	
	<cffunction name="init" output="false" access="public" hint="">
		<cfset super.init() />
		<cfset filters(through="loadLayout",type="before") />
		<cfset filters(through="loadJs",type="before") />
	</cffunction>
	
	<cffunction name="loadLayout" output="false" access="public" hint="">
		<cfset usesLayout("/layout") />
	</cffunction>
	
	<cffunction name="loadJs" output="false" access="public" hint="">
		<cfset APPLICATION.ajaxImportFiles &= ",initPromocja" />
	</cffunction>
	
	<cffunction name="materialy" output="false" access="public" hint="">
		<cfset typyMaterialow = model("promocja_material").pobierzTypyMaterialow() />
	</cffunction>
	
	<cffunction name="dodajTypMaterialu" output="false" access="public" hint="">
		
		<cfif IsDefined("FORM.FIELDNAMES")>
			<cfset var src = "" />
			<cfset result = model("promocja_material").dodajTypMaterialu(nazwaMaterialu=FORM.NAZWATYPUMATERIALU, srcMiniaturki=src, opisMaterialu=FORM.OPISMATERIALU) />			
			<!---<cflocation url="index.cfm?controller=promocja_materialy&action=materialy" addtoken="false" />--->
			
		</cfif>
		
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="dodajMiniature" output="false" access="public" hint="">
		<cfset src = "" />
		<cfif IsDefined("FORM.FIELDNAMES") and isDefined("URL.id")>
			<cfset src = "images/promocja/#DateFormat(Now(), 'yyyy-mm-dd')#_#TimeFormat(Now(), 'HH-mm-ss')#_" & randomText(length=11) />
			<cffile action="upload" fileField="srcMiniaturki" destination="#expandPath('images/promocja')#" nameConflict="MakeUnique" result="plikMiniaturki" />
				
			<cfset src &= "." & plikMiniaturki["CLIENTFILEEXT"] />
			<cffile action="rename" source="#expandPath('images/promocja')#/#plikMiniaturki['SERVERFILE']#" destination="#expandPath(src)#" />
			<cfimage action="resize" source="#expandPath(src)#" destination="#expandPath(src)#" overwrite="true" width="90" height="90" />
			
			<cfset aktualizacja = model("promocja_material").aktualizujMiniature(id=URL.id, srcMiniaturki=src) />
			
		</cfif>
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="pobierzDostepneMaterialyKampanii" output="false" access="public" hint="">
		<cfset typyMaterialow = model("promocja_material").pobierzDostepneTypyMaterialowKampanii(URL.idKampanii) />
		<cfset usesLayout(false) />
	</cffunction>
	
	<cffunction name="usunTypMaterialu" output="false" access="public" hint="">
		<cfset usun = model("promocja_material").usunTypMaterialuReklamowego(URL.idTypuMaterialuReklamowego) />
		<cflocation url="index.cfm?controller=promocja_materialy&action=materialy" addtoken="false" />
	</cffunction>
	
</cfcomponent>