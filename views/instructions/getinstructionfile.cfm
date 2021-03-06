<cfset tempDir  = getTempDirectory() />
<cfset tempFile = getFileFromPath(getTempFile(tempDir, "/")) />

<cfhttp url="#cgi.server_name#/#get('loc').intranet.directory#/files/uploaded/#myfile.filename#" 
        method="get" 
        getAsBinary="yes"
        path="#tempDir#" 
        file="#tempFile#" />

<cfheader name="Content-Disposition" value="attachment; filename=#myfile.id#-#myfile.filename#" />
<cfcontent type="application/pdf" file="#tempDir#/#tempFile#" />