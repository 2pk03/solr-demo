# (c) copyright 2013 Martin Lurie and Cloudera
# sample code not supported
# source from  example by Mark Brooks
# adapted to be fully scripted
# long instead of int for faceted salary search

HOSTNAME=hadoop1
USER=alexander

  export PROJECT_HOME=/home/alexander/solrpdf-demo
rm -rf $PROJECT_HOME
mkdir $PROJECT_HOME
  export SOLR_HOME=/opt/cloudera/parcels/SOLR-0.9.3-1.cdh4.3.0.p0.366/lib/solr
  solrctl --zk $HOSTNAME:2181/solr instancedir --generate $PROJECT_HOME/pdf_config
  cp solrPDF.xml $PROJECT_HOME/pdf_config/conf/schema.xml
  cp loadPDFintoSolr.conf $PROJECT_HOME/
  cp -r EarningsCalls $PROJECT_HOME/
  cp log4j.props.solr $PROJECT_HOME/log4j.properties
  solrctl --zk $HOSTNAME:2181/solr instancedir --delete PDFCollection 
  solrctl --zk $HOSTNAME:2181/solr instancedir --create PDFCollection $PROJECT_HOME/pdf_config
  #start solr in CM
  # fails since only one node so one shard solrctl --zk $HOSTNAME:2181/solr collection --create Collection -s 2
  solrctl --zk $HOSTNAME:2181/solr collection --delete PDFCollection 
  solrctl --zk $HOSTNAME:2181/solr collection --create PDFCollection -s 1
  hadoop fs -rm -r  /user/$USER/solrpdf/outdir
  hadoop fs -rm -r  /user/$USER/EarningsCalls
  hadoop fs -mkdir -p  /user/$USER/solrpdf/outdir
  hadoop fs -put $PROJECT_HOME/EarningsCalls  /user/$USER/
  # hadoop jar /opt/cloudera/parcels/SOLR-0.9.3-1.cdh4.3.0.p0.366/lib/solr/contrib/mr/search-mr-0.9.3-cdh4.3.0-SNAPSHOT-job.jar org.apache.solr.hadoop.MapReduceIndexerTool -D 'mapred.child.java.opts=-Xmx500m' --log4j $PROJECT_HOME/log4j.properties --morphline-file $PROJECT_HOME/loadPDFintoSolr.conf --output-dir hdfs://$HOSTNAME:8020/user/$USER/solrpdf/outdir --verbose --go-live --zk-host $HOSTNAME:2181/solr --collection PDFCollection --dry-run   hdfs://$HOSTNAME:8020/user/$USER/EarningsCalls
# remove --dry-run
  hadoop jar /opt/cloudera/parcels/SOLR-0.9.3-1.cdh4.3.0.p0.366/lib/solr/contrib/mr/search-mr-0.9.3-cdh4.3.0-SNAPSHOT-job.jar org.apache.solr.hadoop.MapReduceIndexerTool -D 'mapred.child.java.opts=-Xmx2G' --log4j $PROJECT_HOME/log4j.properties --morphline-file $PROJECT_HOME/loadPDFintoSolr.conf  --output-dir hdfs://$HOSTNAME:8020/user/$USER/solrpdf/outdir --verbose --go-live --zk-host $HOSTNAME:2181/solr --collection PDFCollection hdfs://$HOSTNAME:8020/user/$USER/EarningsCalls
echo 
echo go to gui and import samples
echo SEARCH TIPS: 
echo wildcard syntax 'file*' 
echo proximity '"first managers" ~5'
echo or condition 'file manage*'

