<style type="text/css">
	#tabs { margin: 15px 0; min-height: 600px; background-repeat: no-repeat; background-position: center center; }
	div.divloader { width: 100%; height: 300px; background: url('./images/ajax-loader-3.gif') no-repeat center center; }
</style>
	<div class="ajaxcontent">
		<div class="wrapper">
			<h3>Wnioski pracowników firmy</h3>
			
			<!--- 23.04.2013 Zmiana sposobu wyświetlania wniosków na widok z 
			podziałem na typy wniosków w zakładkach ładowanych via Ajax --->
		
			<!---<div class="wrapper">
				<cfoutput>#includePartial(partial="/users/subnav",cache=0)#</cfoutput>
			</div>--->
			
			<!--- <cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
				<cfinvokeargument name="groupname" value="root" />
			</cfinvoke>
					
			<cfif priv is true>
				<div class="adminPanel">
					<button id="adminShow">Klick</button>
				</div>
			</cfif> --->
			
			<div id="tabs">
				<ul>
					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
						<cfinvokeargument name="groupname" value="Wnioski urlopowe" />
					</cfinvoke>
					
					<cfif priv is true>
						<li><a href="<cfoutput>#URLFor(controller='Proposals',action='companyUserProposals',key='1',params='type=1',anchor='holidayproposal')#</cfoutput>" data-type="1">Wnioski urlopowe</a></li>
					</cfif>
					
					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
						<cfinvokeargument name="groupname" value="Polecenia wyjazdu służbowego" />
					</cfinvoke>
					
					<cfif priv is true>
						<li><a href="<cfoutput>#URLFor(controller='Proposals',action='companyUserProposals',key='1',params='type=2',anchor='delegationproposal')#</cfoutput>" data-type="2">Polecenia wyjazdu służbowego</a></li>
					</cfif>
					
					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
						<cfinvokeargument name="groupname" value="Wnioski szkoleniowe" />
					</cfinvoke>
					
					<cfif priv is true>
						<li><a href="<cfoutput>#URLFor(controller='Proposals',action='companyUserProposals',key='1',params='type=3',anchor='trainingproposal')#</cfoutput>" data-type="3">Wnioski szkoleniowe</a></li>
					</cfif>
					
					<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="priv" >
						<cfinvokeargument name="groupname" value="Wnioski dla kandydata na PPS" />
					</cfinvoke>
					
					<cfif priv is true>
						<li><a href="<cfoutput>#URLFor(controller='Proposals',action='companyUserProposals',key='1',params='type=4',anchor='ppsproposal')#</cfoutput>" data-type="4">Wnioski dla kandydata na PPS</a></li>
					</cfif>
				</ul>
				
				<!---<div id="tabs-1">
					<p>Proin elit arcu, rutrum commodo, vehicula tempus, commodo a, risus. Curabitur nec arcu. Donec sollicitudin mi sit amet mauris. Nam elementum quam ullamcorper ante. Etiam aliquet massa et lorem. Mauris dapibus lacus auctor risus. Aenean tempor ullamcorper leo. Vivamus sed magna quis ligula eleifend adipiscing. Duis orci. Aliquam sodales tortor vitae ipsum. Aliquam nulla. Duis aliquam molestie erat. Ut et mauris vel pede varius sollicitudin. Sed ut dolor nec orci tincidunt interdum. Phasellus ipsum. Nunc tristique tempus lectus.</p>
				</div>--->
			</div>
			
			<!---<cfoutput>#includePartial(partial="proposaltypes")#</cfoutput>
			
			<div class="wrapper ajaxproposaltable">
				
				<cfoutput>
					<table class="newtables">
						<thead>
							
							<tr>
								<th class="bottomBorder"></th>
								<th class="bottomBorder"></th>
								<th class="bottomBorder"></th>
								<th class="bottomBorder"></th>
								<th class="bottomBorder"></th>
								<th class="bottomBorder"></th>
							</tr>
							
						</thead>
						
						<tbody>
							
							<cfloop query="userproposals">
								<tr>
									<td class="">
										
										#linkTo(
											text=proposaltypename,
											controller="Proposals",
											action="view",
											key=proposalid,
											title="Podgląd wniosku")#
										
									</td>
									<td class="proposalstatus">#proposalstatusname#</td>
									<td class="">#usergivenname#</td>
									<td class="">
										
										<cfif proposaltypeid eq 2 and proposalstep1status gt 1 and proposalstatusid gt 1>
											
											<cfswitch expression="#status#">
												<cfcase value="1">
													#linkTo(
														text=imageTag("icon_table.png"),
														controller="Proposals",
														action="getProposalCheckForm",
														key=proposalid,
														params="&view=view",
														title="Rozliczenie wyjazdu służbowego (w trakcie rozliczania)")#
												</cfcase>
												<cfcase value="2">
													#linkTo(
														text=imageTag("icon_table-accept.png"),
														controller="Proposals",
														action="getProposalCheckForm",
														key=proposalid,
														params="&view=view",
														title="Rozliczenie wyjazdu służbowego (rozliczony)")#
												</cfcase>
												<cfdefaultcase>
													#linkTo(
														text=imageTag("icon_table-blank.png"),
														controller="Proposals",
														action="getProposalCheckForm",
														key=proposalid,
														params="&view=edit",
														title="Rozliczenie wyjazdu służbowego (oczekuje na rozliczenie)")#
												</cfdefaultcase>
											</cfswitch>
										</cfif>
										
									</td>
									<td class="">
										
										#linkTo(
											text=imageTag("file-pdf.png"),
											controller="Proposals",
											action="proposalToPdf",
											key=proposalid,
											target="_blank",
											params="&format=pdf",
											title="Eksportuj do PDF")#
										
									</td>
									<td class="">
										
										#linkTo(
											text="<span>Usuń wniosek z listy</span>",
											controller="Proposals",
											action="hideProposal",
											key=proposalid,
											class="trash",
											title="Usuń wniosek z listy")#
										
									</td>
								</tr>
								<tr class="proposaldays">
									<td class="bottomBorder" colspan="6">
										W dniach: <span>#proposaldate#</span>
									</td>
								</tr>
							</cfloop>
							
						</tbody>
						
					</table>
				</cfoutput>
				
			</div>  <!--#ajaxproposaltable--> 
			--->
		<div class="clear"></div>
	</div>
</div>


<!---<cfdump var="#userproposals#" >--->

<script type="text/javascript">
$(function() {
	 $( "#tabs" ).tabs({
	 	/*show: { 
			effect: "blind", duration: 800 
		},*/
		activate: function( event, ui ) {
			$("#tabs").tabs("refresh");
		},
		load: function( event, ui ){
			$('#flashMessages').hide();
		},
		beforeActivate: function( event, ui ){
			//location.hash='asd';
			$('#flashMessages').show();
			$("#tabs div").html('<div class="divloader"></div>');
		}
	});

	$("#tabs").on('change', '.proposalstat', function() {
		
		$('#flashMessages').show();
		
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url		:	<cfoutput>"#URLFor(controller='Proposals',action='companyUserProposals')#"</cfoutput> + "&key=" + $('#proposalstatusid :selected').val() + "&type=" + ($("#type").html()),
			success	:	function(data) {
				$('.proposalstat').closest(".ui-tabs-panel").html(data);
				$('#flashMessages').hide();
			}
		});
	});
	
	$("#tabs").on('click', '.trash', function() {
		//e.preventDefault();
		$('#flashMessages').show();
		var el = $(this).parent().parent();
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url		:	$(this).attr('href'),
			success	:	function(data) {
				el.next().remove();
				el.remove();
				$('#flashMessages').hide();
			},
			error	:	function(xhr, ajaxOptions, throwError) {}
		});
		
		return false;
	});
	
	$("#tabs").on('click', '.paginationlink', function() {
		
		var givenname = $('#proposalusername').val();
		var url = $(this).attr("href") + "&user=" + givenname;
		
		//$(".ui-tabs-active").find("a").attr("href",url);
		
		var tab = $(".ui-tabs-active").find("a").data("type");
		//console.log(tab);
			
		//$("#tabs").tabs({ active: (tab-1) });
		//$("#tabs").tabs("refresh");
		
		$('#flashMessages').show();
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url			:	url,
			success		:	function(data) {
				$('#ui-tabs-'+tab).html(data);
				$('#flashMessages').hide();
			}
		});
		
		return false;
	});
	
	$("#tabs").on('click', '.pokaz_wszystkie_wnioski', function() {	
		var givenname = $('#proposalusername').val();
		var url = $(this).attr("href") + "&user=" + givenname;
		var tab = $(".ui-tabs-active").find("a").data("type");

		$('#flashMessages').show();
		$.ajax({
			type: 'get',
			dataType: 'html',
			url: url,
			success: function(data) {
				$('#ui-tabs-'+tab).html(data);
				$('#flashMessages').hide();
			}
		});
		
		return false;
	});
	
	$("#tabs").on('click', '.usun_zaznaczone_wnioski', function() {
		$(':checkbox:checked').each(function(item, i) {
			$('#flashMessages').show();
			var el = $(i).parent().parent();
			$.ajax({
				type: 'get',
				dataType: 'html',
				url: 'index.cfm?controller=proposals&action=hide-proposal&key=' + $(i).val(),
				success	:	function(data) {
					el.next().remove();
					el.remove();
					$('#flashMessages').hide();
				},
				error: function(xhr, ajaxOptions, throwError) {}
			});
		}); 
		return false;
	});
	
	$("#tabs").on('click', '.proposalview', function() {
		
		var url = $(this).attr("href");
		
		$('#proposalPreviewDialog').empty();
		
		$.get(url, function(data) {			
			$('#proposalPreviewDialog').html(data);			
		});
		
		$("#proposalPreviewDialog").dialog({
			autoOpen: false,
			draggable: true,
			width: 700,
			dialogClass: "dialogstyle"
		}).dialog("open");
		
		return false;
	});
	
	/*$('#proposalstatusid').live('change', function (e) {
		$('#flashMessages').show();
		$.ajax({
			type		:	'get',
			dataType	:	'html',
			url			:	<cfoutput>"#URLFor(controller='Proposals',action='companyUserProposals')#"</cfoutput> + "&key=" + $('#proposalstatusid :selected').val(),
			success		:	function(data) {
				$('.ajaxproposaltable').html(data);
				$('#flashMessages').hide();
			}
		});
	});*/
});
</script>