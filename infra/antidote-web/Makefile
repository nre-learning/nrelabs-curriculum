all: package

package:
	rm -rf target/
	mvn package

	# Requirements - jdk 10.0.1, maven 3.5.4
	# Don't forget to set the right JDK in JAVA_HOME in ~/.mavenrc
	# on Mac this is /Library/Java/JavaVirtualMachines/jdk-10.0.1.jdk/Contents/Home
	# You can see which version maven is using with mvn -v

	./push.sh