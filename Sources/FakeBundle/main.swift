import Foundation
import Commander
import PathKit

let generateCommand = command(
Option<String>("input", default: "./Resources", description: "Folder containing all the resources that should be exported. Folder name will be used as top level class name."),
Option<String>("output", default: "./Resources.swift", description: "Path where the generated swift file should be stored.")) { input, output in
    
    let inputFolder = Path(input).absolute().url
    let outputFile = Path(output).absolute().url
    
    try generateCode(inputUrl: inputFolder, outputUrl: outputFile)
}

generateCommand.run()
