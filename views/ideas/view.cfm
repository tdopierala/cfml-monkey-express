<style>
	#user345 { height: 100px; width: 100%; }
	.col345 { width: 20px; height: 10px; background-color: #EB0F0F; float: left; margin: 0 1px; }
</style>
<script language="JavaScript">
	$(document).ready(function() {
		$(".a_response").click(function(){
			$(this).parent().parent().next().toggle();
			return false;
		});
		$(".a_history").click(function() {
			$("li.nostate").slideToggle("fast");
			$("li.state .idea-statustext").toggle().last().show();
			if($(this).html()=='zobacz całość') $(this).html('ukryj');
			else $(this).html('zobacz całość');
			return false;
		});
		$(".idea-comments-menu a").click(function() {
			$(this).parent().next().toggle();
			return false;
		});
		$("li.state .idea-statustext").last().css("display","block");
		
		$(".comment-link").on("click", function(){
			$(".idea-comments-menu").next().show();
		});
	});
</script>

<cfoutput>
	
	<div class="wrapper">
	
		<h3>Podgląd pomysłu: <i>#idea.title#</i></h3>
		
		<cfif flashKeyExists("success")>
	    	<span class="success">#flash("success")#</span>
		</cfif>
		
		<cfif flashKeyExists("error")>
	    	<span class="error">#flash("error")#</span>
		</cfif>
		
		<div class="topLink">
			#linkTo(text="Powrót do Sprytnych małpek", controller="ideas", action="index")#
		</div>
		
		<!---<cfif session.user.id eq 345>
			<div id="user345"></div>
		</cfif>--->
		
		<div class="wrapper forms">
			
			<h4><strong>#idea.title#</strong> (#idea.idea_status.name#)</h4>
			
			<div class="idea-left">
			
				<cfset counter = 0 />
				<cfloop query="texts">
					<cfset counter = counter + 1 />
					<div class="idea-text">
						<div class="idea-details">
							Dodał: #texts.givenname# #texts.sn#
							<cfif texts.partner_prowadzacy_sklep eq 1>
								(#texts.login#)
							</cfif>
							, #DateFormat(texts.date, "yyyy.mm.dd")# #TimeFormat(texts.date, "HH:mm:ss")#
							
							<cfif DateCompare(DateAdd("n",30,texts.date), Now()) eq 1 and texts.userId eq session.user.id>
								<span class="idea-editlink">#linkTo(controller="ideas", action="edit", key=texts.id, text="edytuj")#</span>
							</cfif>
						</div>
						<p>#texts.text#</p>
						
						<cfif counter lte 1>
							<p style="font-weight:bold;">Uzasadnienie pomysłu:</p>
							<p>#texts.reason#</p>
						</cfif>
						
						<div class="idea-details-files">
							<cfloop query="files">
								<cfif files.textid eq texts.id>
									
									<cfswitch expression="#files.ext#" >
										
										<cfcase value="pdf" >
											<a href="files/ideas/#files.file#" title="#files.file#"><img width="100" src="files/ideas/thumb_#Left(files.file, Len(files.file)-3)#png" alt="#files.file#" /></a>
										</cfcase>
										
										<cfcase value="jpg" >
											<a href="files/ideas/#files.file#" title="#files.file#"><img width="100" src="files/ideas/thumb_#files.file#" alt="#files.file#" /></a>
										</cfcase>
										
										<cfcase value="png" >
											<a href="files/ideas/#files.file#" title="#files.file#"><img width="100" src="files/ideas/thumb_#files.file#" alt="#files.file#" /></a>
										</cfcase>
										
									</cfswitch>
									
								</cfif>
							</cfloop>
							<div style="clear:both;"></div>
						</div>
					</div>				
				</cfloop>
			</div>

			<div class="idea-right">
			
				<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_vippriv" >
					<cfinvokeargument name="groupname" value="Komisja ds. Pomysłów" />
				</cfinvoke>
				
				<ol class="idea-menu">
					<li class="idea-menutitle">Akcje</li>
					<li>&raquo; #linkTo(key="#params.key#", anchor="comments", text="Dodaj komentarz", class="comment-link")#</li>
					<li>
						<cfif (idea.statusid lte 3 and access lte 2) or (idea.statusid eq 1 and access lte 3)>
							&raquo; #linkTo(controller="ideas", action="new-text", key=idea.id, text="Dodaj treść do pomysłu")#
						<cfelse>
							&raquo; Dodaj treść do pomysłu
						</cfif>
					</li>
					
					<li>
						<cfif _vippriv is true>
							&raquo; #linkTo(action="edit-status", key=idea.id, text="Zmień status pomysłu")#
						<cfelse>
							&nbsp;&nbsp; status: <strong>#idea.idea_status.name#</strong>
						</cfif>
					</li>
					
					<cfif _vippriv is true>
						<li>						
							&raquo; #linkTo(action="view", key=idea.id, params="view=pdf", text="Wydruk w pliku *.pdf")#
						</li>
					</cfif>
				</ol>		
				
				<cfif _vippriv is true and idea.statusid eq 3>
					<ol class="idea-menu votebox">
						<li class="idea-menutitle">Głosowanie</li>
						<li class="idea-votebox">
							
							<cfif StructKeyExists(vote, "votes")>
								<cfif vote.vt[1] eq 0>
									<cfset vote1 = "0" />
									<cfset vote2 = vote.votes[1] />
								<cfelse>
									<cfset vote1 = vote.votes[1] />
									<cfset vote2 = vote.votes[2] />
								</cfif>
							</cfif>
							
							<div class="idea-vote vote1" title="Lubie to"><span id="vote1count">#vote1#</span></div> 
							<div class="idea-vote vote0" title="Nie podoba mi sie"><span id="vote0count">#vote2#</span></div>
							<div style="clear:both;"></div>
						</li>
					</ol>
				</cfif>
				
				<ol class="idea-statuses">
					<li class="idea-statustitle">Historia zmian __<span class="small-link"><a href="" title="Pokaż pełną historie" class="a_history">zobacz całość</a></span></li>
					<cfloop query="history">
						<cfif history.activity neq 1>
							<cfset class = "nostate" />
						<cfelse>
							<cfset class = "state" />
						</cfif>
						
						<cfif history.activity lt 5 or (history.activity gte 5 and _vippriv is true)>
							<li class="#class#">
								<span class="idea-statusdetails">[#DateFormat(history.date, "yyyy.mm.dd")# #TimeFormat(history.date, "HH:mm:ss")#]</span><br /> 
								#history.givenname# #history.sn# #history.name# <strong>#history.idea_statusName#</strong>
								<div class="idea-statustext">#history.descript#</div>
							</li>
						</cfif>
					</cfloop>
				</ol>
				
			</div>
			
			<div style="clear:both"></div>
		</div>
		
		<a name="comments"></a>
		<div class="idea-commentscontainer forms">
			<p class="idea-commenttitle">Komentarze do pomysłu</p>
			
			<p class="idea-comments-menu">#linkTo(key="#params.key#", anchor="comments", text="Nowy wątek")#</p>
			<div class="add-comment-form">
				#startFormTag(action="add-comment")#
					
					#hiddenField(objectName="comment", property="ideaid")#
					#hiddenField(objectName="comment", property="ctype")#
					#textArea(objectName="comment", property="text", label="Treść komentarza", labelPlacement="before", class="textarea")#
					<br />
					#submitTag(value="Dodaj", class="formButton")#
					
				#endFormTag()#
			</div>
			
			<cfloop query="comments">
				
				<cfif comments.parent eq 0 >
					
						<div class="idea-comment">
							<span class="idea-commentdetails">[#DateFormat(comments.date, "yyyy.mm.dd")# #TimeFormat(comments.date, "HH:mm:ss")#]</span>
							<strong>#comments.givenname# #comments.sn#</strong> (#userStatus(comments)# )<br /> 
							#comments.text#
							<div class="response-link"><a href="./" class="a_response">Odpowiedz</a></div>
						</div>
						
						<div class="response-form">
							#startFormTag(action="add-comment")#
								#hiddenField(objectName="comment", property="ideaid")#
								#hiddenField(objectName="comment", property="ctype")#
								
								<cfset comment.parent = comments.id />
								#hiddenField(objectName="comment", property="parent")#
								
								#textArea(objectName="comment", property="text",  label="Treść komentarza", labelPlacement="before", class="textarea")#
								<br />
								#submitTag(value="Dodaj", class="formButton")#
							#endFormTag()#
						</div>
						
						<cfset tmp_id = comments.id />
						<cfloop query="subcomments">
								
								<cfif subcomments.parent eq tmp_id>
									<div class="idea-comment subcomment">
										<span class="idea-commentdetails">[#DateFormat(subcomments.date, "yyyy.mm.dd")# #TimeFormat(subcomments.date, "HH:mm:ss")#]</span>
										<strong>#subcomments.givenname# #subcomments.sn#</strong> (#userStatus(subcomments)# )<br /> 
										#subcomments.text#
									</div>						
								</cfif>
							
						</cfloop>
						
				</cfif>
				
			</cfloop>
		</div>
		
	<cfinvoke component="controllers.Tree_groupusers" method="checkUserTreeGroup" returnvariable="_priv" >
		<cfinvokeargument name="groupname" value="Komisja ds. Pomysłów" />
	</cfinvoke>
		
	<cfif _priv is true>
		<a name="comments"></a>
		<div class="idea-commentscontainer forms">
			<p class="idea-commenttitle">Komentarze komisji ds. pomysłów <br /><span style="color:##EB0F0F;font-style:italic;font-size:10px;">(widoczne tylko dla członków komisji!)</span></p>
			
			<p class="idea-comments-menu">#linkTo(key="#params.key#", anchor="comments", text="Nowy wątek")#</p>
			<div class="add-comment-form">
				#startFormTag(action="add-comment")#
					
					#hiddenField(objectName="vipcomment", property="ideaid")#
					#hiddenField(objectName="vipcomment", property="ctype")#
					#textArea(objectName="vipcomment", property="text", label="Treść komentarza", labelPlacement="before", class="textarea")#
					<br />
					#submitTag(value="Dodaj", class="formButton")#
					
				#endFormTag()#
			</div>
			
			<cfloop query="vipcomments">
				
				<cfif vipcomments.parent eq 0 >
					
						<div class="idea-comment">
							<span class="idea-commentdetails">[#DateFormat(vipcomments.date, "yyyy.mm.dd")# #TimeFormat(vipcomments.date, "HH:mm:ss")#]</span>
							<strong>#vipcomments.givenname# #vipcomments.sn#</strong> (#userStatus(vipcomments)# )<br /> 
							#vipcomments.text#
							<div class="response-link"><a href="./" class="a_response">Odpowiedz</a></div>
						</div>
						
						<div class="response-form">
							#startFormTag(action="add-comment")#
								#hiddenField(objectName="vipcomment", property="ideaid")#
								
								<cfset vipcomment.parent = vipcomments.id />
								#hiddenField(objectName="vipcomment", property="parent")#
								#hiddenField(objectName="vipcomment", property="ctype")#
								
								#textArea(objectName="vipcomment", property="text",  label="Treść komentarza", labelPlacement="before", class="textarea")#
								<br />
								#submitTag(value="Dodaj", class="formButton")#
							#endFormTag()#
						</div>
						
						<cfset tmp_id = vipcomments.id />
						<cfloop query="vipsubcomments">
								
								<cfif vipsubcomments.parent eq tmp_id>
									<div class="idea-comment subcomment">
										<span class="idea-commentdetails">[#DateFormat(vipsubcomments.date, "yyyy.mm.dd")# #TimeFormat(vipsubcomments.date, "HH:mm:ss")#]</span>
										<strong>#vipsubcomments.givenname# #vipsubcomments.sn#</strong> (#userStatus(vipsubcomments)# )<br /> 
										#vipsubcomments.text#
									</div>
								</cfif>
							
						</cfloop>
						
				</cfif>
				
			</cfloop>
		</div>
	</cfif>
		
	</div>
	
</cfoutput>

<cfif StructKeyExists(voted, "vote") and voted.vote neq ''>
	<script>
		$(function(){
			var vote = <cfoutput>#voted.vote#</cfoutput>;
			
			switch(vote) {
				case 0: $(".vote0").addClass("selected"); break;
				case 1: $(".vote1").addClass("selected"); break;
			}
		});
	</script>
</cfif>
<script>
	$(function(){
		
		var active = <cfoutput>#voted.RecordCount#</cfoutput>;
		if(active>0){
			$(".idea-vote").addClass("inactive");
		}
		
		$(".idea-vote").find("span").each(function(){
			if($(this).text() == '') $(this).text("0");
		});
		
		$(".idea-vote").on("mouseenter", function(){
			
			if (!$(this).hasClass("inactive")) {
				$(this).css({"background-position": "20px -25px"});
			}
		});
		
		$(".idea-vote").on("mouseleave", function(){
			
			if (!$(this).hasClass("selected")) {
				$(this).css({"background-position": "20px 0px"});
			}
		});
		
		$(".idea-vote").on("click", function(){
			
			var _this = $(this);
			
			if (!_this.hasClass("inactive")){
				$("#flashMessages").show();
			
				if(_this.hasClass("vote1"))
					var vote = 1;
				else
					var vote = 0;
				
				$.ajax({
					type		:	'get',
					dataType	:	'json',
					url		:	<cfoutput>"#URLFor(controller='ideas',action='vote')#&ideaid=#params.key#"</cfoutput> + "&vote=" + vote,
					success	:	function(data) {
						
						$.each(data.ROWS, function(i, item){
							switch(item.VT){
								case 0: $("#vote0count").text(item.VOTES); break;
								case 1: $("#vote1count").text(item.VOTES); break;
							}
						});
						_this.addClass("selected");
						$(".idea-vote").addClass("inactive");
						$("#flashMessages").hide();
					}
				});
			}
			
			return false;
		});
		
		for(var i=0; i<=5; i++){
			$("#user345").append('<div class="col345"></div>');
		}
		
		var timeout;
		$("#user345").on("click", function(){
			var _this = $(this);
			if(_this.hasClass("animate")){
				
				clearInterval(timeout);
				_this.removeClass("animate");
				
			} else {
				
				_this.addClass("animate");
				
				timeout = setInterval(function(){
					_this.find('.col345').each(function(i){
						$(this)
						.animate({height: "80px"},200)
						.animate({height: Math.floor((Math.random()*70)+1) + "px"},200);
					});
				},400);
				
			}
			
		});
		
	});
</script>