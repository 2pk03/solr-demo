Cloudera Search Demo
===================

Edit the variables in solrpdf.sh and edit the zk-host in loadPDFintoSolr.conf
Start the script: ./solrpdf.sh

Add the collection in Hue, I used this template:

Ticker Symbol: {{file_name}}
Industry Category/FilePath: {{file_path}}
Text of earnings call {{text}} 
========================================
