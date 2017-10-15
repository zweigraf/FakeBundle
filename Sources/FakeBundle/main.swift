import Foundation

let baseUrl = URL(fileURLWithPath: "/Users/zweigraf/Development/gnosis/bivrost-swift/Sources/BivrostHelper")
let outputUrlCode = URL(fileURLWithPath: "/Users/zweigraf/Development/gnosis/BivrostHelperExport.swift")

let fm = FileManager.default

func directoryAsCode(of url: URL) throws -> String {
    let children = try fm.contentsOfDirectory(at: url, includingPropertiesForKeys: [], options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles])
    
    var childrenTypes = [String]()
    let childrenClassesString = try children.map { url -> String in
        var isDirectory: ObjCBool = false
        guard fm.fileExists(atPath: url.path, isDirectory: &isDirectory) else {
            return ""
        }
        
        let filename = url.lastPathComponent
        let type = makeTypeName(filename: filename)

        // Add Children Type so we correctly add it to the children lazy var
        guard !isDirectory.boolValue else {
            let code = try directoryAsCode(of: url)
            if !code.isEmpty {
                // Only add to children if we could actually generate the type for the dir
                childrenTypes.append("\(type)()")
            }
            return code
        }
        
        // Single file
        guard let data = fm.contents(atPath: url.path) else {
            return ""
        }
        
        let code = makeFile(name: type, filename: filename, contentsBase64: data.base64EncodedString())
        if !code.isEmpty {
            // Only add to children if we could actually generate the type for the file
            childrenTypes.append("\(type)()")
        }
        return code
    }.joined(separator: "\n\n")
    
    let filename = url.lastPathComponent
    let name = makeTypeName(filename: filename)
    let childrenCreation = childrenTypes.joined(separator: ", ")
    return makeDirectory(name: name, filename: filename, childrenCreation: childrenCreation, childrenClasses: childrenClassesString)
}

func makeTypeName(filename: String) -> String {
    return filename.replacingOccurrences(of: ".", with: "_").replacingOccurrences(of: " ", with: "__").replacingOccurrences(of: "-", with: "___").capitalized
}

try (try directoryAsCode(of: baseUrl)).data(using: .utf8)?.write(to: outputUrlCode)
