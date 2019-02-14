<cfsilent></cfsilent>

<cfscript>
	myImage=ImageRead(img.url);
	ImageWrite(myImage, "#expandPath('files/brandbank_images/#img.gtin#.png')#");
</cfscript>