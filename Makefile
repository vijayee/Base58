build:
	mkdir -p build
test: build
	mkdir -p build/test
test/Base58: test Base58/*.pony Base58/test/*.pony
	ponyc Base58/test -o build/test --debug
test/execute: test/Base58
	./build/test/test
clean:
	rm -rf build

.PHONY: clean test
