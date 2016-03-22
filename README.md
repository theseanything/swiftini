# swiftini
A ini file parser framework for swift.

Here it is finally, the file parser you've all obviously been waiting for. The days of struggling with those mongrel ini files are over. Sit back, relax and pour yourself a swiftini.

## How to use:
Clone, build and import the framework bundle into swift projects.

Create a inifile object:
```swift
let iniFile = Inifile(ilepathAsString: "path/to/some/ini/file")
```

Then access properties:
```swift
let properties = iniFile.sections
let propertyValue = properties["exampleSection"]["exampleProperty"]
```
