APP := bin/BluetoothHelper.app
BIN := $(APP)/Contents/MacOS/bluetooth-helper

$(BIN): main.swift Info.plist
	mkdir -p $(APP)/Contents/MacOS
	cp Info.plist $(APP)/Contents/Info.plist
	swiftc -O main.swift -o $(BIN)
	codesign --force --sign - $(APP)

# Bluetooth access is granted per app; this triggers the system prompt.
authorize: $(BIN)
	./bluetooth-helper.sh --power >/dev/null

clean:
	rm -rf bin

.PHONY: authorize clean
