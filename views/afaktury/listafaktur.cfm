<cfsilent>

</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Lista faktur do przypisania z afaktury.pl</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<cfif IsDefined("session.result")>
				<div class="uiMessage <cfif session.result.success is true> uiConfirmMessage <cfelse> uiErrorMessage </cfif>">
					<cfoutput>#session.result.message#</cfoutput>
				</div>
				<cfset structDelete(session, "result") />
			</cfif>
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<cfform name="afaktury_form" action="index.cfm?controller=afaktury&action=przekaz-dokument">
				
			<table class="uiTable">
				<thead>
					<tr>
						<th rowspan="2" colspan="2" class="topBorder rightBorder bottomBorder leftBorder">#</th>
						<th colspan="2" class="topBorder rightBorder bottomBorder">Intranet</th>
						<th colspan="4" class="topBorder rightBorder bottomBorder">Faktura</th>
						<th rowspan="2" class="topBorder rightBorder bottomBorder">&nbsp;</th>
					</tr>
					<tr>
						<th class="bottomBorder rightBorder">Data wpływu</th>
						<th class="bottomBorder rightBorder">Nr Intranet</th>
						<th class="bottomBorder rightBorder">Kontrahent</th>
						<th class="bottomBorder rightBorder">Nr fv</th>
						<th class="bottomBorder rightBorder">Netto</th>
						<th class="bottomBorder rightBorder">Brutto</th>
					</tr>
				</thead>
				<tbody>
					<cfset indeks = 1 />
					<cfoutput query="faktury">
						<tr>
							<td class="leftBorder bottomBorder rightBorder"><input type="checkbox" name="afaktury" value="#DOCUMENTID#" /></td>
							<td class="bottomBorder rightBorder">#indeks#</td>
							<td class="bottomBorder rightBorder r">#DATA_WPLYWU#</td>
							<td class="bottomBorder rightBorder l">#NUMER_FAKTURY#</td>
							<td class="bottomBorder rightBorder l">#NAZWA2#</td>
							<td class="bottomBorder rightBorder l">#NUMER_FAKTURY_ZEWNETRZNY#</td>
							<td class="bottomBorder rightBorder r">#NETTO#</td>
							<td class="bottomBorder rightBorder r">#BRUTTO#</td>
							<td class="bottomBorder rightBorder">
								<a href="index.cfm?controller=documents&action=get-document&key=#DOCUMENTID#" target="blank" title="Pobierz PDF" class="icon-pdf"><span>Pobierz PDF</span></a>
								<a href="index.cfm?controller=afaktury&action=usun-dokument&id=#DOCUMENTID#" title="Usuń dokument" class="icon-remove"><span>Usuń dokument</span></a>
							</td>
						</tr>
						<cfset indeks++ />
					</cfoutput>
				</tbody>
				<tfoot>
					<tr>
						<th colspan="9" class="leftBorder bottomBorder rightBorder l">
							<input type="text" class="input userSearch" name="userSearch" placeholder="Wyszukaj użytkownika..." />
							<select name="userid" class="userId" class="select_box">
							</select>
						</th>
					</tr>
				</tfoot>
			</table>
			
			
			
			<ol class="vertical inline">
				<li><cfinput type="submit" name="afaktury_form_submit" value="Przekaż zaznaczone faktury" class="web-button2 web-button--with-hover" />
			</ol>
				
			<div class="uiFooter">
			</div>
			
			</cfform>
			
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<!---<cfset ajaxOnLoad("initAfaktury") />--->

<script type="text/javascript">
$(function(){
	var s = document.createElement("script");
	s.type = "text/javascript";
	s.src = "javascripts/ajaximport/initAfaktury.js";
	$("body").append(s);

	<!---var len = $('script').filter(function () {
		return /^.*intranet\/javascripts\/ajaximport\/initAfaktury.*/.test( $(this).attr('src') );
	}).length;
	
	if (len === 0) {
		$.getScript("javascripts/ajaximport/initAfaktury.js");
	}--->
});
</script>
