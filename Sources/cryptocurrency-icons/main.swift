import Foundation

print("Compile icon..")

let fileManager = FileManager.default
let currentUrl = URL(fileURLWithPath: fileManager.currentDirectoryPath, isDirectory: true)
let outputUrl  = currentUrl.appendingPathComponent("cryptocurrency-icons.plist")
let icon32PxUrl = currentUrl.appendingPathComponent("32/color", isDirectory: true)
let icon32Px2xUrl = currentUrl.appendingPathComponent("32@2x/color", isDirectory: true)

if !fileManager.fileExists(atPath: icon32PxUrl.path)  {
    print("Icon directory not found", icon32PxUrl.path)
    exit(1)
}

if !fileManager.fileExists(atPath: icon32Px2xUrl.path)  {
    print("Icon directory not found", icon32Px2xUrl.path)
    exit(1)
}

var dict: [String:Data] = [:]

for iconUrl in fileManager.enumerator(at: icon32PxUrl, includingPropertiesForKeys: nil)! {
    if let iconUrl = iconUrl as? URL {
        if iconUrl.pathExtension == "png" {
            let iconName = iconUrl.deletingPathExtension().lastPathComponent
            let icon2xUrl = icon32Px2xUrl.appendingPathComponent(iconName + "@2x.png")
            if fileManager.fileExists(atPath: icon2xUrl.path) {
                dict[iconName] = try! Data(contentsOf: iconUrl)
                dict[iconName + "@2x"] = try! Data(contentsOf: icon2xUrl)
            }
        }
        
    }
}

let plistData = try! PropertyListSerialization.data(fromPropertyList: dict, format: .binary, options:0)
try! plistData.write(to: outputUrl)

print("Written to \(outputUrl.path), entries: \(dict.count)")
