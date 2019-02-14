<cfprocessingdirective pageencoding="utf-8" />
	
<cfdiv id="left_site_column">

<div id="jcrop" class="leftWrapper">
	
	<div class="headerArea">
		<div class="headerArea uiHeader">
			<h3 class="uiHeaderTitle">Zdjęcia</h3>
		</div>
	</div>

	<div class="headerNavArea">
		<div class="headerNavArea uiHeaderNavArea">
			
			<div class="imageContainer">
			<!--- 
				The event handler from the JCrop plugin populates these
				values for us. Required to obtain the X Y coords and persist
				the image location for cropping and reverting the image. 
			--->  
			<form action="#URLFor(controller='User_photos',action='crop')#" method="post" name="user_photo_crop_form">
				<input type="hidden" size="4" id="x" name="x" />
				<input type="hidden" size="4" id="y" name="y" />
				<input type="hidden" size="4" id="x2" name="x2" />
				<input type="hidden" size="4" id="y2" name="y2" />
				<input type="hidden" size="4" id="w" name="w" />
				<input type="hidden" size="4" id="h" name="h" />
				
				<input type="hidden" name="imageFile" id="imageFile" value="" />
				<input type="button" name="imageCrop_btn" id="imageCrop_btn" value="Przytnij obraz" class="admin_button green_admin_button" />
				<input type="button" name="revert_btn" id="revert_btn" value="Przywróć" class="admin_button gray_admin_button" />
				<input type="button" name="loadImages_btn" id="loadImages_btn" value="Załaduj plik" class="admin_button gray_admin_button" /> 
			</form>

			<!-- This is the image we're attaching Jcrop to -->  
			<div id="croppedImage">
				<img src="images/jcrop/ZamakRobots1.jpg" id="cropbox" />
			</div> <!--- /end croppedImage --->
		
			<div id="thumbs">
				<ul class="thumb">
					<!--- Listowanie katalogu ze zdjęciami --->
					<cfset dir = DirectoryList(ExpandPath("images/jcrop/"), false, "name", "", "datelastmodified DESC") />
					
					<cfloop array="#dir#" index="singlefile" >
						<cfif isImageFile(singlefile)>
							<cfset tmp_img = imageNew("#ExpandPath("images/jcrop/thumbs/#singlefile#")#") />
							<cfset imageResize(tmp_img, "", "50", "highestperformance") />
							<li>
								<a href="images/jcrop/<cfoutput>#singlefile#</cfoutput>" >
									<cfimage action="writeToBrowser" source="#tmp_img#" />
								</a>
							</li>
						</cfif>
					</cfloop>
				</ul>
			</div> <!--- /end thumb --->  
			
			</div> <!--- /end imageContainer --->
			
		</div>
	</div>

	<div class="contentArea">
		<div class="contentArea uiContent">

			<div class="uiFooter">
				
			</div>
			
		</div>
	</div>

	<div class="footerArea">
	</div>

</div>

<script language="Javascript">
jQuery(document).ready(function() {
	// obtain original image dimensions
	var originalImgHeight 	= jQuery('#cropbox').height();
	var originalImgWidth 	= jQuery('#cropbox').width();
	
	// set the padding for the crop-selection box
	var padding = 10;
	
	// set the x and y coords using the image dimensions
	// and the padding to leave a border
	var setX = originalImgHeight-padding;
	var setY = originalImgWidth-padding;

	// create variables for the form field elements
	var imgX 		= jQuery('input[name=x]');
	var imgY 		= jQuery('input[name=y]');
	var imgHeight 	= jQuery('input[name=h]');
	var imgWidth 	= jQuery('input[name=w]');
	var imgLoc 		= jQuery('input[name=imageFile]');

	// get the current image source in the main view
	var currentImage = jQuery("#croppedImage img").attr('src');
	setImageFileValue(currentImage);

	// instantiate the jcrop plugin
	buildJCrop();
	
	// selecting revert will create the img html tag complete with
	// image source attribute, read from the imageFile form field
	jQuery("#revert_btn").click(function() {
		var htmlImg = '<img src="' + jQuery('input[name=imageFile]').val() + '" id="cropbox" />';
		jQuery('#croppedImage').html(htmlImg);
		
		// instantiate the jcrop plugin
		buildJCrop();
	});

	jQuery("#imageCrop_btn").click(function(){					
		// organise data into a readable string
		var data = 'imgX=' + imgX.val() + '&imgY=' + imgY.val() + 
				'&height=' + imgHeight.val() + '&width=' + imgWidth.val() + 
				'&imgLoc=' + encodeURIComponent(imgLoc.val());

		jQuery('#croppedImage').load('index.cfm?controller=user_photos&action=crop', data);

		// disable the image crop button and
		// enable the revert button
		jQuery('#imageCrop_btn').attr('disabled', 'disabled');
		jQuery('#revert_btn').removeAttr('disabled');
				
		// do not submit the form using the default behaviour
		return false;
	});

	// add the jQuery invocation into a separate function,
	// which we will need to call more than once
	function buildJCrop() {
		jQuery('#cropbox').Jcrop({
			aspectRatio: 0,
			onChange: showCoords,
			onSelect: showCoords,
			setSelect: [padding,padding,setY,setX]
		});
		
		// enable the image crop button and
		// disable the revert button
		jQuery('#imageCrop_btn').removeAttr('disabled');
		jQuery('#revert_btn').attr('disabled', 'disabled');
	}

	// set the imageFile form field value to match
	// the new image source
	function setImageFileValue(imageSource) {
		imgLoc.val(imageSource);
	}
			
	jQuery("ul.thumb li").hover(function() {
		// increase the z-index to ensure element stays on top
		jQuery(this).css({'z-index' : '10'});
	
		// add hover class and stop animation queue
		jQuery(this).find('img').addClass("hover").stop()
			.animate({
				// vertically align the image
				marginTop: '-110px', 
				marginLeft: '-110px',
				top: '50%',
				left: '50%',
				// set width
				width: '174px',
				// set height
				height: '174px',
				padding: '20px'
			}, 
			// set hover animation speed
			200);
	}, function() {
		// set z-index back to zero
		jQuery(this).css({'z-index' : '0'});
		// remove the hover class and stop animation queue
		jQuery(this).find('img').removeClass("hover").stop()
			.animate({
				// reset alignment to default
				marginTop: '0',
				marginLeft: '0',
				top: '0',
				left: '0',
				// reset width
				width: '100px',
				// reset height
				height: '100px',
				padding: '5px'
			}, 400);
	});

	// onclick action for the thumbnails
	jQuery("ul.thumb li a").click(function() {
		// check to see if  id="cropbox" attribute exists
		// in the img html
		if (!jQuery("#croppedImage img").attr('id')) {
			// no attribute exists. add it in
			jQuery("#croppedImage img").attr('id', 'cropbox')
		}
		
		// instantiate the jcrop plugin
		buildJCrop();
		
		 // Get the image name
		var mainImage = $(this).attr("href");
		jQuery("#croppedImage img").attr({ src: mainImage });
			
		setImageFileValue(mainImage);
			
		return false;		
	});
	
	jQuery("#loadImages_btn").click(function() {
		showCFWindow('user_photos', 'Załaduj plik', 'index.cfm?controller=user_photos&action=iframe', 300, 500);
	});
});

// Our simple event handler, called from onChange and onSelect
// event handlers, as per the Jcrop invocation above
function showCoords(c) {
	jQuery('#x').val(c.x);
	jQuery('#y').val(c.y);
	jQuery('#x2').val(c.x2);
	jQuery('#y2').val(c.y2);
	jQuery('#w').val(c.w);
	jQuery('#h').val(c.h);		
};
</script>

</cfdiv>