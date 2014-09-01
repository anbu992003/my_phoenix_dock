FROM sequenceiq/hadoop-docker
MAINTAINER SequenceIQ

# hbase
RUN curl -s http://xenia.sote.hu/ftp/mirrors/www.apache.org/hbase/hbase-0.98.5/hbase-0.98.5-hadoop2-bin.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./hbase-0.98.5-hadoop2 hbase
ENV HBASE_HOME /usr/local/hbase
ENV PATH $PATH:$HBASE_HOME/bin
RUN rm $HBASE_HOME/conf/hbase-site.xml
ADD hbase-site.xml $HBASE_HOME/conf/hbase-site.xml

# zookeeper
RUN curl -s http://xenia.sote.hu/ftp/mirrors/www.apache.org/zookeeper/zookeeper-3.4.6/zookeeper-3.4.6.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./zookeeper-3.4.6 zookeeper
ENV ZOO_HOME /usr/local/zookeeper
ENV PATH $PATH:$ZOO_HOME/bin
RUN mv $ZOO_HOME/conf/zoo_sample.cfg $ZOO_HOME/conf/zoo.cfg
RUN mkdir /tmp/zookeeper

# phoenix
RUN curl -s https://s3-eu-west-1.amazonaws.com/seq-phoenix/phoenix-4.1.0-incubating-SNAPSHOT.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./phoenix-4.1.0-incubating-SNAPSHOT phoenix
RUN cp /usr/local/phoenix-4.1.0-incubating-SNAPSHOT/phoenix-4.1.0-incubating-SNAPSHOT-client.jar $HBASE_HOME/lib/

# bootstrap-phoenix
ADD bootstrap-phoenix.sh /etc/bootstrap-phoenix.sh
RUN chown root:root /etc/bootstrap-phoenix.sh
RUN chmod 700 /etc/bootstrap-phoenix.sh

# zookeeper
EXPOSE 2181
# HBase Master API port
EXPOSE 60000
# HBase Master Web UI
EXPOSE 60010
# Regionserver API port
EXPOSE 60020
# HBase Regionserver web UI
EXPOSE 60030

CMD ["/etc/bootstrap-phoenix.sh", "-bash"]
