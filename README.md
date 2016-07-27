# swiftini
Here it is finally, the file parser you've all obviously been waiting for. A ini file parser for swift. 

## How to use:
Clone, build and import the framework bundle into swift projects.

Create a inifile object:
```swift
let iniFile = Inifile(filepathAsString: "path/to/some/ini/file")
```

Then access properties:
```swift
let configuration = iniFile.sections
let propertyValue = configuration["exampleSection"]["exampleProperty"]
```
