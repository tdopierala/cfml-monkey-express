<!---
Set the file name of the inline graphic to be the name
of the hottie record.
--->
<cfheader name="content-disposition" value="inline; filename=#document.documentfilename#" />
 
<!--- Stream the binary image data to the user. --->
<cfcontent type="binary" variable="#document.documentcontent#" />