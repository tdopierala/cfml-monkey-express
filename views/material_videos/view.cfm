<cfset bgColorTheme = "ffffff"> 
<cfset titleColorTheme = "888888"> 
<cfset controlsColorTheme = titleColorTheme> 
<cfset progressColorTheme = "cccccc"> 
<cfset progressbgColorTheme = "eeeeee">

<cfmediaplayer 
	name="#my_video.videoname#" 
	style="bgcolor:#bgColorTheme#; 
titletextcolor:#titleColorTheme#;titlebgcolor:#bgColorTheme#;controlbarbgcolor:#bgColorTheme#;controlscolor:#controlsColorTheme#;progressbgcolor:#progressbgColorTheme#;progresscolor:#progressColorTheme#;borderleft:20;borderright:20;bordertop:10;borderbottom:13" 
	hideborder="false" 
	hideTitle=false 
	controlbar="true" 
	source="files/materials/#my_video.videosrc#"
	align="center" >

</cfmediaplayer>
