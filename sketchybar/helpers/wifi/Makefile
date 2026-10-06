APP := bin/WiFiHelper.app
BIN := $(APP)/Contents/MacOS/wifi-helper

$(BIN): main.swift Info.plist
	mkdir -p $(APP)/Contents/MacOS
	cp Info.plist $(APP)/Contents/Info.plist
	swiftc -O main.swift -o $(BIN)
	codesign --force --sign - $(APP)

# Location access is granted per app; this triggers the system prompt.
authorize: $(BIN)
	open $(APP)

clean:
	rm -rf bin

.PHONY: authorize clean
