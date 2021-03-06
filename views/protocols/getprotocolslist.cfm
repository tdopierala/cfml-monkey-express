<cfoutput>

	<div class="wrapper">
	
		<h3>Protokoły użytkownika <span>#session.user.givenname# #session.user.sn#</span></h3>
	
		<div class="wrapper">
		
			<cfoutput>#includePartial(partial="/protocols/subnav")#</cfoutput>
		
		</div>
		
		<div class="wrapper">
			<table class="tables" id="userProtocolsTable">
				<thead></thead>
				<tbody>
					<tr class="top">
						<td colspan="5" class="bottomBorder"></td>
					</tr>
					<cfloop query="protocols">
						<tr>
							<td class="bottomBorder">
								<cfif DateFormat(Now(), "dd-mm-yyyy") eq DateFormat(protocolcreated, "dd-mm-yyyy")>
									<span class="newprotocol"></span>
								</cfif>
							</td>
							<td class="bottomBorder">
								#linkTo(
									text=protocolnumber,
									controller="Protocols",
									action="getProtocolPdf",
									title="Pobierz PDF",
									key=protocolid,
									params="format=pdf",
									target="_blank")#
							</td>
							<td class="bottomBorder">#DateFormat(protocolcreated, "dd/mm/yyyy")# #TimeFormat(protocolcreated, "HH:mm")#</td>
							<td class="bottomBorder">#protocoltypename#</td>
							<td class="bottomBorder">
								#linkTo(
									text="<span>Pobierz protokół</span>",
									controller="Protocols",
									action="getProtocolPdf",
									key=protocolid,
									title="Pobierz protokół",
									class="getProtocolPdf",
									params="format=pdf",
									target="_blank")#
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	
	</div>

</cfoutput>

<script type="text/javascript">

	Ext.onReady(function() {
	
		Ext.define('Protocol', {
			extend	:	'Ext.data.Model',
			fields	:	[
				{name:'userid', type:'int'},
				{name:'protocoltypeid', type:'int'},
				{name:'protocolcreated', type:'string'}
			]
		});
		
		var myProtocols = Ext.create('Ext.data.Store', {
			model	:	'Protocol',
			proxy	:	{
				type	:	'ajax',
				url		:	'index.cfm?controller=protocols&action=getUserProtocolsJson&format=jsos&cfdebug=',
				render	:	{
					type	:	'json',
					root	:	'ROWS'
				}
			},
			autoload	:	true
		});
	
	});

</script>