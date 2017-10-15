# FakeBundle

🗄 Use Resources in your Swift Package Manager executable

## Description

As Swift Package Manager does not support Resources or `Bundle` for Swift executables, I needed a way to integrate generic file resources (including folder structure) in my binary.

`FakeBundle` takes an input folder and generates a single file of code, which can be used to export the complete folder, or single files, onto the file system during runtime.

## Usage with [Mint](https://github.com/yonaskolb/mint) 🌱

    $ mint run zweigraf/FakeBundle "fakebundle --input ./Resources --output ./Resources.swift"

## Use Case

Say you have a folder of templates but want to distribute your app as a single binary (or otherwise simplify installation). You could add all of these templates to your code as strings, but maintaining this gets cumbersome. 
In this case you could run `FakeBundle` as a pre-compile script phase and generate a class that contains all of your templates, automatically.
During runtime you can then export the templates back to the file system or use them directly from code.

## Exported Code

My main use case was directly exporting the whole input folder back onto the file system. This can be done like this (`Resources` here is the name of the top level input folder):

    Resources().export(to: <path>)

This will create the Resources folder in `<path>` on the disk and export all children recursively into it. Single files can also be exported, but getting a reference to them is right now quite annoying (traversing through children).

Currently you cannot easily access files directly.

## More complicated use cases

    Resources().children.forEach { file in
        if file.isDirectory {
            // Special directory handling
        } else {
            if file.filename == "MyImage.png", 
                let data = ($0 as? File)?.contents,
                let image = UIImage(data: data) {
                    // You now have an image
            }
        }
    }

## Types

The generated code conforms to these protocols (which are included in the generated resources file):

    protocol FileType {
        var isDirectory: Bool { get }
        var filename: String { get }
        func export(to path: String) throws
    }
    protocol File: FileType {
        var contentsBase64: String { get }
    }
    extension File {
        var isDirectory: Bool {
            return false
        }
        var contents: Data? {
            return Data(base64Encoded: contentsBase64)
        }
    
        func export(to path: String) throws {
            guard let contents = contents else { return }
            let originalUrl = URL(fileURLWithPath: path)
            let myUrl = originalUrl.appendingPathComponent(filename)
            try contents.write(to: myUrl)
        }
    }
    protocol Directory: FileType {
        var children: [FileType] { get }
    }
    extension Directory {
        var isDirectory: Bool {
            return true
        }
        func export(to path: String) throws {
            let originalUrl = URL(fileURLWithPath: path)
            let myUrl = originalUrl.appendingPathComponent(filename)
            try FileManager.default.createDirectory(at: myUrl, withIntermediateDirectories: true, attributes: nil)
            try children.forEach { try $0.export(to: myUrl.path) }
        }
    }

## License

FakeBundle is licensed under MIT.