<cfprocessingdirective pageencoding="utf-8" />

<cfsilent>
	
</cfsilent>

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Wersje systemu MMarket</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<cfform name="store_stores_mmarket_form"
					action="index.cfm?controller=store_stores&action=mmarket&t=true">
						
				<ol class="filters" style="height:25px;">
					<li>
						<cfinput type="text"
								 class="input"
								 name="projekt"
								 placeholder="Numer sklepu"
								 value="#session.storeFilter.mmarket.projekt#" />
					</li>
					<li>
						<cfinput type="submit"
								 name="store_stores_mmarket_form_submit"
								 value=">>"
								 class="admin_button green_admin_button" />
					</li>
				</ol>
				
			</cfform>
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<table class="uiTable aosTable">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder"><span>Sklep</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>Data pliku wersji</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>IP</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>MMarket</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>Manag. kas</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>IP</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>Kasa #1</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>IP</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>Kasa #2</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>IP</span></th>
						<th class="topBorder rightBorder bottomBorder"><span>Kasa #3</span></th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="wersje">
						<cfset ip = listToArray(IPHOSTA, ",", true) />
						<cfset id = listToArray(IDAPLIKACJI, ",", true) />
						<cfset aplikacje = listToArray(NAZWAAPLIKACJI, ",", true) />
						<cfset ver = listToArray(WERSJAAPLIKACJI, ",", true) />
						
						<tr>
							<td class="leftBorder bottomBorder rightBorder l"><cfoutput>#kodSklepu#</cfoutput></td>
							<td class="bottomBorder rightBorder r"><cfoutput>#dateFormat(dataWersji, "yyyy/mm/dd")#</cfoutput></td>
								
								<!--- MMarket --->
								<cfset wykluczone = [] />
								<cfloop from="1" to="#arraylen(id)#" index="i">
									<cfif id[i] eq 1 and not arrayFind(wykluczone, "#ip[i]#")>
										<cfset arrayAppend(wykluczone, ip[i]) />
										<td class="bottomBorder rightBorder r"><cfoutput>#ip[i]#</cfoutput></td>
										<td class="bottomBorder rightBorder r">
											<cfoutput>#ver[i]#</cfoutput>
										</td>
										<cfbreak />
									</cfif>
								</cfloop>
								
								<!--- Maganer kas --->
								<cfset wykluczone = [] />
								<cfloop from="1" to="#arraylen(id)#" index="i">
									<cfif id[i] eq 2 and not arrayFind(wykluczone, "#ip[i]#")>
										<cfset arrayAppend(wykluczone, ip[i]) />
										<td class="bottomBorder rightBorder r">
											<cfoutput>#ver[i]#</cfoutput>
										</td>
										<cfbreak />
									</cfif>
								</cfloop> 

								<!--- Kasy --->
								<cfset wykluczone = [] />
								<cfloop from="1" to="#arraylen(id)#" index="i">
									<cfif id[i] eq 3 and Right(ip[i], 2) eq '10' and not arrayFind(wykluczone, "#ip[i]#")>
										<cfset arrayAppend(wykluczone, ip[i]) />
										<td class="bottomBorder rightBorder r"><cfoutput>xx#Right(ip[i], 3)#</cfoutput></td>
										<td class="bottomBorder rightBorder r">
											<cfoutput>#ver[i]#</cfoutput>
										</td>
										<cfbreak />
									</cfif>
								</cfloop>
								<cfloop from="1" to="#arraylen(id)#" index="i">
									<cfif id[i] eq 3 and Right(ip[i], 2) eq '11' and not arrayFind(wykluczone, "#ip[i]#")>
										<cfset arrayAppend(wykluczone, ip[i]) />
										<td class="bottomBorder rightBorder r"><cfoutput>xx#Right(ip[i], 3)#</cfoutput></td>
										<td class="bottomBorder rightBorder r">
											<cfoutput>#ver[i]#</cfoutput>
										</td>
										<cfbreak />
									</cfif>
								</cfloop>
								<cfloop from="1" to="#arraylen(id)#" index="i">
									<cfif id[i] eq 3 and Right(ip[i], 2) eq '12' and not arrayFind(wykluczone, "#ip[i]#")>
										<cfset arrayAppend(wykluczone, ip[i]) />
										<td class="bottomBorder rightBorder r"><cfoutput>xx#Right(ip[i], 3)#</cfoutput></td>
										<td class="bottomBorder rightBorder r">
											<cfoutput>#ver[i]#</cfoutput>
										</td>
										<cfbreak />
									</cfif>
								</cfloop>
 							
 								<cfif arraylen(wykluczone) gt 0>
								 	<td colspan="<cfoutput>#(3-arrayLen(wykluczone))*2#</cfoutput>" class="bottomBorder rightBorder emptyCell"></td>
								 </cfif>
							<!---</cfloop>--->
						</tr>
							
						
					</cfloop>
					
					<!---<cfoutput query="wersje">
						<tr>
							<td class="leftBorder bottomBorder">
								<a href="javascript:void(0)" class="extend" onclick="pokazWersjeOprogramowania(#idMmarket#, $(this))" title="Pokaż wersje oprogramowania"><span>&nbsp;</span></a>
							</td>
							<td class="bottomBorder rightBorder l">#kodSklepu#</td>
							<td class="bottomBorder rightBorder r">#dateFormat(dataWersji, "yyyy/mm/dd")#</td>
							<td class="bottomBorder rightBorder r">#dateFormat(dataImportu, "yyyy/mm/dd")#</td>
						</tr>
					</cfoutput>--->
				</tbody>
			</table>
				
			

			<div class="uiFooter">
				
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<script type="text/javascript">
$(function(){
	$("table").tablesorter({selectorHeaders: '> thead > tr > th'});
	var len = $('script').filter(function () {
		return /^.*intranet\/javascripts\/ajaximport\/initStoreMmarket.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/ajaximport/initStoreMmarket.js");
	}
});
</script>
