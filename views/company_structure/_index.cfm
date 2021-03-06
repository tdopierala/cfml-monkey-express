<cfoutput>
				<cfset last_rgt = 1 />
				<cfset first_rgt = 0 />
				<cfset counter = 0 />
				<!--- <cfset lenght = root.RecordCount /> --->
				<cfset background = '' />
				<cfset border = '' />
				<cfset root = struct />
				
				<cfloop query="root">
					<cfscript>
						counter++;
						
						if(first_rgt == 0) first_rgt = root.rgt;
						
						switch(root.type){
							case 0: class = ' root'; break;
							case 1: class = ' employee'; break;
							case 2: class = ' department'; break;
							case 3: class = ' section'; break;
						}
						
						if(root.lft > last_rgt){
							for(i=0; i<root.lft-last_rgt-1; i++){
								WriteOutput('
									</ol></li><!-- userStructTreeBranch end -->');
							}
						}
						</cfscript>
							
							<!--- <cfif root.type eq 2>
								<cfset background = '##' & root.color2 />
								<cfset border = '##000000' />
							<cfelseif root.type eq 3 and root.depth lte 3>
								<cfset background = '##cccccc' >
							<cfelseif root.type eq 3 and root.depth gt 3>
								<cfset background = '##' & root.color2 >
							</cfif> --->
							
							<li class="userStructTreeBranch lvl#root.depth#">
								<div id="id_#root.sid#" class="userStructTreeLeaf #class#" <!--- style="background-color:#background#; border-color:#border#" --->>
								
									<div class="userdetails" style="position:static;">
										<div class="_userdetails">
											<div class="__userdetails"></div>
										</div>
									</div>
									
									<div class="userthumbnail">
										<cfif fileExists(expandPath("images/avatars/thumbnailsmall/#root.photo#"))>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/avatars/thumbnailsmall/#root.photo#')#" title="#root.name#">
										<cfelseif root.type eq 1>
											<cfimage action="writeToBrowser" source="#ExpandPath('images/avatars/thumbnailsmall/monkeyavatar.png')#" title="#root.name#">
										</cfif>
									</div>
									
									<cfif StructKeyExists(params, 'edit') and params.edit eq 'true'>
										<div class="delete"><a href="##"><img src="./images/delete.png" alt="usuń" /></a></div>
									</cfif>
									
									<p class="title"><!--- id_#root.sid# ---> #root.name# <!--- (#root.uid#) ---></p>
									
									<!--- <cfif root.type eq 0 or root.type eq 2 or root.type eq 3> --->
									<cfif root.type eq 1>
										<span class="userid">#root.uid#</span>
										<span>#root.position#</span><br />
										<span><a href="mailto:#root.mail#">#root.mail#</a></span>
									</cfif>
									
									<div style="clear:both;"></div>
								</div>
								
							<!--- <cfif root.type eq 2 or (root.type eq 3 and root.depth gt 3)>
								<cfset background = '##' & root.color1 />
								<cfset border = '##' & root.color2 />
							</cfif> --->
								
						<cfscript>
						if(root.rgt - root.lft > 1){
							WriteOutput('
								<ol class="userStructTreeBranchOl lvl#root.depth#"
							');
							if(StructKeyExists(params, 'edit') and params.edit == 'true'){
								WriteOutput(' style="display:block;" ');
							}
							WriteOutput(' >');
						}
						else{
							WriteOutput('
							</li><!-- userStructTreeBranch end -->');
						}
						
						last_rgt = root.rgt;
						
						/*if(counter == lenght){
							for(j=0; j<first_rgt-root.rgt; j++){
								WriteOutput('
									</div><!-- userStructTreeBranch end! -->');
							}
						}*/
					</cfscript>
				</cfloop>
</cfoutput>