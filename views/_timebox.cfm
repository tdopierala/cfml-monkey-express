		<div class="session-timebox">
			Twoja sesja wygaśnie za:
			<div id="session-timebox-clock">
				<span class="session-timebox-hur">00</span>:<span class="session-timebox-min">00</span>:<span class="session-timebox-sec">00</span>
			</div>
			
			<div id="session-timebox-progressbar"></div>
		</div>
		
		<script language="JavaScript">
			var _timebox;
			var length = sessionLength;
			var timecounter = sessionLength;
			$(function(){
				 $( "#session-timebox-progressbar" ).progressbar({ value: 100 });
				 
				 _timebox = setInterval(function(){
				 	 timecounter--;
				 	 
				 	 if (timecounter >= 0) {
						if (timecounter == 120)
							$("#session-timebox-clock").css("color", "#eb0f0f");
						
						min = Math.floor(timecounter / 60);
						sec = timecounter % 60;
								
						if(sec < 10) sec = '0' + sec;
						$(".session-timebox-sec").html(sec);
								
						if(min < 10) min = '0' + min;
						$(".session-timebox-min").html(min);
								
						width = Math.floor((timecounter * 100)/length);		
						
						$( "#session-timebox-progressbar" ).progressbar({ value: width });
					}
				 },1000);
				 
				 //setTimeout(function(){setTime( sessionLength, sessionLength )},1000);
				 
				 $(".session-timebox").on("click", function(){
				 	 $('#dialogWarning').dialog('open');
				 });
			});
			
		<!--- function setTime(time, length){
			time--;
			
			if (time >= 0) {
				if (time == 120) {
					$("#session-timebox-clock").css("color", "#eb0f0f");
				}
				min = Math.floor(time / 60);
				sec = time % 60;		
				if(sec < 10) sec = '0' + sec;
				$(".session-timebox-sec").html(sec);		
				if(min < 10) min = '0' + min;
				$(".session-timebox-min").html(min);		
				width = Math.floor((time * 100)/length);		
				$( "#session-timebox-progressbar" ).progressbar({ value: width });
				setTimeout(function(){ setTime(time,length) }, 1000);
			}
		} --->
		</script>