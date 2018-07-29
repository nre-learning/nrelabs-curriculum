FROM guacamole/guacamole
ADD target/antidote-web.war /usr/local/tomcat/webapps/
ADD logging.properties /usr/local/tomcat/conf/logging.properties

#TODO secure me
ADD tomcat-users.xml /usr/local/tomcat/conf/tomcat-users.xml