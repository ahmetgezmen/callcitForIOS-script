#!/bin/bash

read -p "Proje dizinini girin: " PROJECT_DIR
IOS_PROJECT_DIR="$PROJECT_DIR/ios"
APP_DELEGATE_PATH="$IOS_PROJECT_DIR/Runner/AppDelegate.swift"

# AppDelegate.swift dosyasına kodu ekle
cat <<EOF >> "$APP_DELEGATE_PATH"

import CallKit

let callKitChannel = FlutterMethodChannel(name: "callKitChannel", binaryMessenger: flutterViewController as! FlutterBinaryMessenger)

callKitChannel.setMethodCallHandler { (call: FlutterMethodCall, result: FlutterResult) in
    if call.method == "getCallInformation" {
        if let call = CXCallDirectoryManager.sharedInstance.currentCalls.first {
            let callInfo: [String: Any] = [
                "phoneNumber": call.directoryPhoneNumber,
                // Diğer çağrı bilgilerini buraya ekleyin
            ]
            result(callInfo)
        } else {
            result(nil)
        }
    }
}
EOF

# CocoaPods bağımlılıklarını yükle
cd "$IOS_PROJECT_DIR"
pod install

echo "iOS changes applied successfully!"
