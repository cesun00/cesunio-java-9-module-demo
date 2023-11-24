default: run-with-my-jdk

.PHONY: build package-jar run clean link

build:
	javac -d out --module-source-path src -m com.foo,org.bar

package-jar: build
	jar -c -f app.jar -e com.foo.app.App -C out/com.foo .
	jar -c -f lib.jar -C out/org.bar .

package-jmod: build
	jmod create --class-path out/com.foo --main-class com.foo.app.App app.jmod
	jmod create --class-path out/org.bar lib.jmod

run-with-std-jdk: package-jar
	java -p app.jar:lib.jar -m com.foo

run-with-my-jdk: link
	myimage/bin/java -m com.foo

link: package-jmod
	jlink --module-path app.jmod:lib.jmod --add-modules com.foo,org.bar --output myimage

clean:
	rm -rf out *.jar *.jmod myimage