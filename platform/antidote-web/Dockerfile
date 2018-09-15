FROM guacamole/guacamole
RUN rm -rf /usr/local/tomcat/webapps/ROOT/
ADD target/antidote-web.war /usr/local/tomcat/webapps/ROOT.war
ADD logging.properties /usr/local/tomcat/conf/logging.properties

RUN cd /usr/local/tomcat/webapps && rm -rf docs/ examples/ guacamole/ guacamole.war host-manager/ manager/
