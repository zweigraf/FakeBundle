# FakeBundle

As Swift Package Manager does not support Resources or `Bundle` for Swift executables, I needed a way to integrate some kind of file resources (including folders) in my binary.

`FakeBundle` takes an input folder and generates a single file of code, which can be used to export the complete folder, or single files, onto the file system during runtime.

## Usage with [Mint](https://github.com/yonaskolb/mint) 🌱

    $ mint run zweigraf/FakeBundle "fakebundle --input ./Resources --output ./Resources.swift"

## Exported Code

My main use case was directly exporting the whole input folder back onto the file system. This can be done like this (`Resources` here is the name of the top level input folder):

    Resources().export(to: <path>)

This will create the Resources folder on the disk and export all children recursively into it. Single files can also be exported, but getting a reference to them is right now quite annoying (traversing through children). Currently you cannot easily access files directly.

## License

MIT.