<cfsilent>
	<cfinvoke
		component="controllers.Tree_groupusers"
		method="checkUserTreeGroup"
		returnvariable="edycjaNotatki" >
		
		<cfinvokeargument name="groupname" value="Edycja notatki" />
	</cfinvoke>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<!---<cfdiv id="left_site_column">`--->

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle"><cfoutput>#note.title#</cfoutput></h3>
		</div>
	</div>
	
	<cfif not IsDefined("url.t")>
		<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			<ul class="uiHeaderNavAreaList">
				<li>
					<a href="index.cfm?controller=note_notes&action=prev&noteId=<cfoutput>#note.id#</cfoutput>"
						title="Poprzednia notatka">
						Poprzednia notatka
						<span></span>
					</a>
				</li>
				<li>
					<a
						href="index.cfm?controller=note_notes&action=index"
						title="Lista notatek">
						Lista notatek
						<span></span>
					</a>
				</li>
				<li>
					<a href="index.cfm?controller=note_notes&action=next&noteId=<cfoutput>#note.id#</cfoutput>"
						title="Następna notatka">
						Następna notatka
						<span></span>
					</a>
				</li>
			</ul>
		</div>
		</div>
	</cfif>
	
	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<div class="contentText">
				<cfoutput>
				<table cellpadding="0" cellspacing="0" style="width:100%;">
						<thead></thead>
						<tbody>
							<tr>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Numer sklepu</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;">#note.projekt#</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Adres sklepu</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;">#note.adressklepu#</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Nazwisko KOS</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;border-right:1px solid ##000000;padding:4px;">#note.partner_givenname# #note.partner_sn#</td>
							</tr>
							<tr>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Data powstania</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;">#DateFormat(note.notecreated, "dd/mm/yyyy")#</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Tytuł dok</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;">#note.title#</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;padding:4px;background-color:##eeeeee;">Ocena wypadkowa</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;border-right:1px solid ##000000;padding:4px;">#note.score#</td>
							</tr>
							<tr>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;border-bottom:1px solid ##000000;padding:4px;background-color:##eeeeee;">Osoba kontrolująca</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;border-bottom:1px solid ##000000;padding:4px;">#note.user_givenname# #note.user_sn#</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;border-bottom:1px solid ##000000;padding:4px;background-color:##eeeeee;">Data kontroli</td>
								<td style="border-left:1px solid ##000000;border-top:1px solid ##000000;border-bottom:1px solid ##000000;padding:4px;">#DateFormat(note.inspectiondate, "dd/mm/yyyy")#</td>
								<td colspan="2" style="border-left:1px solid ##000000;border-top:1px solid ##000000;">&nbsp;</td>
							</tr>
						</tbody>
					</table>
				</cfoutput>
			</div>
		
			<div class="contentText">
				<h4 class="contentTextHeader">Treść notatki</h4>
				<cfoutput>#note.notebody#</cfoutput>
			</div>
			
			<div class="contentText">
				<h4 class="contentTextHeader">Załączone pliki</h4>
				<ul class="prettyGallery">
				<cfset randNumber = RandRange(1, 10, 'SHA1PRNG') />
				<cfoutput query="files">
					<li>
					<a href="files/note_files/#filename#" title="Otwórz plik" target="_blank" class="fancybox" rel="gallery#randNumber#">
						<div class="noteImageFile">
							<cfimage action="writeToBrowser" source="#filesrc#/#filethumbsrc#" />
						</div>
					</a>
					</li>
				</cfoutput>
				</ul>
			</div>
			
			<div class="contentText">
				<h4 class="contentTextHeader">Przypisane tagi</h4>
				<cfoutput query="tags">
					<span class="noteSingleTag">
						#tagname#
				</cfoutput>
			</div>
			
			<div class="contentText">
				<h4 class="contentTextHeader">Ocena wypadkowa: <cfoutput>#note.score#</cfoutput></h4>
			</div>
			
			<div class="uiFooter c">
				<cfif edycjaNotatki is true>
					<a href="index.cfm?controller=note_notes&action=edit&key=<cfoutput>#note.id#</cfoutput>" title="edytuj notatkę" class="linkButton c"><span>Edytuj notatkę</span></a>
				</cfif>
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<!---</cfdiv>--->

<script type="text/javascript">
$(document).ready(function() {
	$(".fancybox").fancybox({
		openEffect	: 'none',
		closeEffect	: 'none'
	});
});
</script>