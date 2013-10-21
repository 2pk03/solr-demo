
Cloudera Search Demo
===================

### Editing
Edit the variables in solrpdf.sh and edit the zk-host in loadPDFintoSolr.conf

Start the script: ./solrpdf.sh and add the collection in Hue / Search 

### Search template:

	Ticker Symbol: {{file_name}}
	Industry Category/FilePath: {{file_path}}
	Text of earnings call {{text}} 
