<cfsilent>
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="root" >
		<cfinvokeargument name="groupname" value="root" />
	</cfinvoke>
	
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="dephandl" >
		<cfinvokeargument name="groupname" value="Departament Handlowy" />
	</cfinvoke>
</cfsilent>

<cfprocessingdirective pageencoding="utf-8" />

<cfdiv id="left_site_column">

<div class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Lista plików</h3>
		</div>
	</div>
	
	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">
			
			<table class="uiTable listCell">
				<thead>
					<tr>
						<th class="leftBorder topBorder rightBorder bottomBorder">Lp.</th>
						<th class="topBorder rightBorder bottomBorder">Nazwa pliku</th>
						<th class="topBorder rightBorder bottomBorder"></th>
					</tr>
				</thead>
				<tbody>
					<cfset indeks = 1 />
					<cfoutput query="files">
						<tr>
							<td class="leftBorder bottomBorder rightBorder">#indeks#</td>
							<td class="bottomBorder rightBorder l"><a href="/intranet/files/contractors/#filesrc#" target="blank" id="fileid_#id#">#filename#</a></td>
							<td class="bottomBorder rightBorder r" style="text-align:center;">
								<cfif root is true or dephandl is true>
									<a href="javascript:removeFile(#id#)" data-fileid="#id#"><img src="/intranet/images/delete_icon.png" alt="" /></a>
								</cfif>
							</td>
						</tr>
						<cfset indeks++ />
					</cfoutput>
				</tbody>
			</table>
			
			<cfif root is true or dephandl is true>
				<cfoutput>
					<div id="id-1" class="dragAndDrop" data-contractorid="#params.contractorid#" style="border:1px solid ##e1e1e1;padding:30px;text-align:center">Przeciągnij i upuść tutaj plik</div>
				</cfoutput>
			</cfif>
			
			<div class="uiFooter">
			</div>
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

</cfdiv>

<cfset ajaxOnLoad("initContractorsUpload") />