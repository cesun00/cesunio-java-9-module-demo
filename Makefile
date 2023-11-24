default: run

.PHONY: build package run clean link

build:
	javac -d out --module-source-path src -m com.foo,org.bar

package: build
	jar -c -f app.jar -e com.foo.app.App -C out/com.foo .
	jar -c -f lib.jar -C out/org.bar .

run: link
	myimage/bin/java -m com.foo

link: package
	jlink --module-path app.jar:lib.jar --add-modules com.foo,org.bar --output myimage

clean:
	rm -rf out *.jar myimage