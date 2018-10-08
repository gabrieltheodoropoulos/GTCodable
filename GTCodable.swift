//
//  GTCodable.swift
//
//
//  Created by Gabriel Theodoropoulos.
//  Copyright © 2018 Gabriel Theodoropoulos. All rights reserved.
//

import UIKit

protocol GTCodable: Codable {
    /// It creates a dictionary that contains the properties of the current object along with their values. Practically, it converts the current object into a dictionary.
    ///
    /// This function is using reflection for accessing the properties of the current object and their values, and eventually keep everything into a dictionary. Note that it works recursively in case a property is a custom type (class or struct) that conforms to GTCodable protocol.
    ///
    /// Apart from calling this function when you want to "convert" the current object into a dictionary, it's also being called automatically when it's necessary:
    ///
    /// - To encode to JSON but there are properties that should be excluded (see `toJson()`)
    /// - Save the current object as a Plist file using the default naming method (see `savePlist()`).
    /// - Archive the current object (see `archive()`).
    /// - Save archived data of the current object using the default naming method (see `saveArchive()`).
    ///
    /// If the array named `excludedProperties` has been declared to the current class or struct, then the properties described in there are not included in the final dictionary. Also, properties that have a `nil` value are not included in the dictionary as well.
    ///
    /// - Returns: The generated dictionary as a `[String: Any]` object.
    func toDictionary() -> [String: Any]
    
    /// It converts JSON data into a dictionary and returns it.
    ///
    /// - Parameter json: The original JSON data that should be converted into a dictionary.
    /// - Returns: A dictionary (`[String: Any]`), or `nil` if converting JSON to dictionary fails.
    func toDictionary(fromJson json: Data) -> [String: Any]?
    
    /// It encodes the properties and values of the current object in to JSON data.
    ///
    /// The JSONEncoder class is used to perform the encoding if all properties of the current object should be encoded.
    /// If, however, there are properties that should be excluded and not get encoded, then:
    ///
    /// - A dictionary with the properties and values that should be encoded is created by calling the `toDictionary()` function.
    /// - The dictionary is encoded into JSON data using the JSONSerialization class.
    ///
    /// **Important**
    ///
    /// To exclude properties, a String array *named mandatorily* `excludedProperties` must be declared to the class or struct. In it, the *exact* names of the properties that should be excluded must be added one by one.
    ///
    /// Note that declaring and using the `excludedProperties` array is required to each custom type objects of which are used in the current class or struct. In other words, each custom type that has properties to exclude from encoding must declare and use the `excludedProperties` array. Declaring that array to the current class or struct is necessary when there are custom types with excluded values, even if it should remain empty or `nil`.
    ///
    /// - Returns: The JSON encoded data (`Data` object), or `nil` if encoding fails.
    func toJson() -> Data?
    
    /// It creates a JSON object based on the parameter dictionary.
    ///
    /// - Parameter dictionary: The original dictionary that should be converted into a JSON object.
    /// - Returns: A `Data` object, or `nil` if converting to JSON fails.
    func toJSON(fromDictionary dictionary: [String: Any]) -> Data?
    
    /// It archives the current object using the `NSKeyedArchiver` class.
    ///
    /// The `toDictionary()` function is called to convert the current object into a dictionary. This dictionary is then archived.
    ///
    /// - Returns: The archived Data object.
    func archive() -> Data

    
    
    /// It saves the given JSON data to the specified URL.
    ///
    /// - Parameters:
    ///   - json: The JSON encoded data.
    ///   - url: The target URL.
    /// - Returns: `true` if writing as file is succesful, `false` if it fails.
    func save(json: Data, toURL url: URL) -> Bool
    
    /// It encodes the current object in to JSON data and saves it to disk using default naming.
    ///
    /// It calls the `toJson()` function to perform the encoding and the `save(json:toURL:)` to perform the actual saving to file.
    ///
    /// The file is written to a default subdirectory called "appdata" inside the documents directory. The name of the file is the name of the current class or struct, or "Default" if it's impossible to define it. The extension "json" is appended to the file.
    ///
    /// To save to a file using a custom name and path, use the `save(json:toURL)` function directly.
    ///
    /// - Returns: `true` if encoding and saving is successful, `false` if not. `false` can also be returned if the "appdata" subdirectory doesn't exist and cannot be created for some reason.
    func saveJSON() -> Bool
    
    /// It saves the given dictionary to the specified URL.
    ///
    /// - Parameters:
    ///   - dict: The dictionary to save to file.
    ///   - url: The URL where the dictionary file should be written to.
    /// - Returns: `true` if saving is successful, `false` if it fails.
    func savePlist(fromDictionary dict: [String: Any], toURL url: URL) -> Bool
    
    /// It saves the properties and their values of the current object to a Plist file using default naming.
    ///
    /// It calls the `toDirectory()` function to convert to dictionary, and the `savePlist(fromDictionary:toURL:)` to perform the actual saving.
    ///
    /// The file is written to a default subdirectory called "appdata" inside the documents directory. The name of the file is the name of the current class or struct, or "Default" if it's impossible to define it. The extension "plist" is appended to the file.
    ///
    /// To save a Plist using a different name and location, use the `savePlist(fromDictionary:toURL:)` function instead.
    ///
    /// - Returns: `true` if saving is successful, `false` if it fails. `false` can also be returned if the "appdata" subdirectory doesn't exist and cannot be created for some reason.
    func savePlist() -> Bool
    
    /// It saves the given serialized data to the specified URL.
    ///
    /// - Parameters:
    ///   - archive: The data created by archiving the current object.
    ///   - url: The target URL where the file should be written to.
    /// - Returns: `true` if saving is successful, `false` if it fails.
    func save(archive: Data, toURL url: URL) -> Bool
    
    /// It serializes the current object and saves the archived data to a file using default naming.
    ///
    /// It calls the `archive()` function to create the archived data, and the `save(archive:toURL:)` to perform the actual saving to file.
    ///
    /// The file is written to a default subdirectory called "appdata" inside the documents directory. The name of the file is the name of the current class or struct, or "Default" if it's impossible to define it. No extension is appended to the file.
    ///
    /// The `NSKeyedArchiver` class is used to archive the data. To save an archive using a custom name and path, use the `save(archive:toURL:` function.
    /// - Returns: `true` if saving is successful, `false` if it fails. `false` can also be returned if the "appdata" subdirectory doesn't exist and cannot be created for some reason.
    func saveArchive() -> Bool
    
    
    
    /// It loads JSON data from the given URL.
    ///
    /// - Parameter url: The URL describing the path to the JSON file.
    /// - Returns: The JSON data as `Data`, or `nil` if loading fails.
    func loadJSON(fromURL url: URL) -> Data?
    
    /// It loads a dictionary from the specified URL.
    ///
    /// - Parameter url: The URL describing the path to the property list file.
    /// - Returns: A dictionary (`[String: Any]`), or `nil` if the file contents cannot be loaded.
    func loadPlist(fromURL url: URL) -> [String: Any]?
    
    /// It loads serialized data from the specified URL.
    ///
    /// - Parameter url: The URL describing the path to the serialized data file.
    func loadArchive(fromURL url: URL) -> Data?
    
    /// It decodes the given JSON data and initializes the current object.
    ///
    /// - Parameter json: The source JSON data that should be decoded.
    mutating func initialize(usingJSON json: Data) -> Bool
    
    /// It initializes self using the given property list (dictionary) data.
    ///
    /// Behind the scenes, the parameter dictionary is converted into JSON data, and then the `initialize(usingJSON:)` function is used to initialize self.
    ///
    /// - Parameter plist: The source property list.
    mutating func initialize(usingPlist plist: [String: Any]) -> Bool
    
    /// It initializes self using the given archived data.
    ///
    /// Behind the scenes, the archived data is unarchived into a dictionary using the NSKeyedUnarchiver class, which in turn is converted into a JSON object and finally the `initialize(usingJSON:)` function is used to initialize self.
    ///
    /// - Parameter archive: The source serialized data.
    mutating func initialize(usingArchive archive: Data) -> Bool
    
    /// It initializes self by loading and decoding JSON data stored in the default file.
    ///
    /// The default JSON file resides in a subdirectory called "appdata" inside the documents directory. The name of the file is the name of the current class or struct, or "Default" if it's impossible to define it. The extension "json" is appended to the file.
    mutating func initFromJSON() -> Bool
    
    /// It initializes self by loading and populating data from the default property list (plist) file to the matching properties.
    ///
    /// The default Plist file resides in a subdirectory called "appdata" inside the documents directory. The name of the file is the name of the current class or struct, or "Default" if it's impossible to define it. The extension "plist" is appended to the file.
    mutating func initFromPlist() -> Bool
    
    /// It initializes self by deserializing and populating data from the default archived data file.
    ///
    /// The default file with serialized data resides in a subdirectory called "appdata" inside the documents directory. The name of the file is the name of the current class or struct, or "Default" if it's impossible to define it. There's no extension to that file.
    mutating func initFromArchive() -> Bool
    
    
    
    /// It returns the path to documents directory as a String value.
    ///
    /// - Returns: The path to the documents directory.
    func getDocDirPath() -> String

    /// It returns the raw value of an Enum value which conforms to the GTCodable protocol.
    ///
    /// - Returns: The raw value.
    func getRaw() -> Any?
    
    /// It returns a textual representation of a JSON object.
    ///
    /// - Parameter json: The original JSON data.
    /// - Returns: The textual representation as a `String` value, or `nil` if converting to `String` fails.
    func getTextualRepresentation(fromJson json: Data) -> String?
    
    /// It creates a String that represents the properties of the current object with their values.
    ///
    /// - Returns: The String that "describes" the current object.
    func describeSelf() -> String
    
    
    init()
}



// MARK: Public Functions
extension GTCodable {
    // MARK: Conversion & Encoding
    
    func toDictionary() -> [String: Any] {
        var dict = [String: Any]()
        let selfMirror = Mirror(reflecting: self)
        
        // Go through all children of selfMirror.
        for (label, value) in selfMirror.children {
            if !(value as AnyObject).isKind(of: NSNull.self) {
                // Does the label have a valid value?
                if let label = label {
                    if label != "excludedProperties" && !isInExcludedProperties(property: label) {
                        // Get the mirror of the current child of the selfMirror.
                        let currentMirror = Mirror(reflecting: value)
                        if let ds = currentMirror.displayStyle {
                            // Keep the display style of the current value to a new variable.
                            // If the current value is Not an Optional, the displayStyle and ds will be the same.
                            // If the current value IS an Optional, then the displayStyle might take a different value, depending on the actual type behind the optional.
                            // The above distinction between the two display style variables is extremely useful later.
                            var displayStyle = ds
                            
                            // Handle the case where the current value is an Optional.
                            // The real type behind the optional must be determined.
                            if let specifiedDisplayType = specifyDisplayType(fromOptionalValue: value) {
                                displayStyle = specifiedDisplayType
                            }
                            
                            if displayStyle == .collection {    // DisplayStyle = COLLECTION
                                if let newCollection = process(collection: value, defaultDisplayStyle: ds, specifiedDisplayStyle: displayStyle) {
                                    dict[label] = newCollection
                                }
                            }
                            else if displayStyle == .dictionary {   // DisplayStyle = DICTIONARY
                                if let newDictionary = process(dictionaryValue: value, defaultDisplayStyle: ds, specifiedDisplayStyle: displayStyle) {
                                    dict[label] = newDictionary
                                }
                            }
                            else if displayStyle == .enum {     // DisplayStyle = ENUM
                                // Check if the normal display style for the current value is Enum.
                                // If it is, the value is Not an optional enum. If it's not, then the value is an Optional and the displayStyle variable was set manually.
                                if ds == .enum {
                                    if let val = value as? GTCodable {
                                        // If so keep the value.
                                        dict[label] = val.getRaw()
                                        
                                    }
                                    else {
                                        let typeOfValue: AnyObject.Type = type(of: (value as AnyObject))
                                        
                                        if typeOfValue == __DispatchData.self {
                                            if let stringRepr = String(data: value as! Data, encoding: String.Encoding.utf8) {
                                                dict[label] = stringRepr
                                            }
                                            else {
                                                dict[label] = (value as! Data).base64EncodedString()
                                            }
                                        }
                                        else if typeOfValue == type(of: NSDate()) {
                                            dict[label] = (value as! Date).timeIntervalSinceReferenceDate
                                        }
                                        else {
                                            if let valueAsCGPoint = value as? CGPoint {
                                                dict[label] = [valueAsCGPoint.x, valueAsCGPoint.y]
                                            }
                                            else if let valueAsCGSize = value as? CGSize {
                                                dict[label] = [valueAsCGSize.width, valueAsCGSize.height]
                                            }
                                            else if let valueAsCGRect = value as? CGRect {
                                                dict[label] = [valueAsCGRect.origin.x, valueAsCGRect.origin.y, valueAsCGRect.size.width, valueAsCGRect.size.height]
                                            }
                                            else if let valueAsData = value as? Data {
                                                dict[label] = valueAsData.base64EncodedString()
                                            }
                                            else {
                                                dict[label] = value
                                            }
                                        }
                                    }
                                }
                                else if ds == .optional {
                                    if let val = currentMirror.children.first?.value as? GTCodable {
                                        dict[label] = val.getRaw()
                                    }
                                }
                            }
                            else if displayStyle == .struct || displayStyle == .class {     // DisplayStyle = STRUCT || DisplayStyle == CLASS
                                if ds == .struct || ds == .class {
                                    if let value = value as? GTCodable {
                                        dict[label] = value.toDictionary()
                                    }
                                }
                                else if ds == .optional || ds == .enum {
                                    if let value = currentMirror.children.first?.value as? GTCodable {
                                        dict[label] = value.toDictionary()
                                    }
                                }
                                else if ds == .collection {    // DisplayStyle = COLLECTION
                                    if let newCollection = process(collection: value, defaultDisplayStyle: ds, specifiedDisplayStyle: displayStyle) {
                                        dict[label] = newCollection
                                    }
                                }
                            }
                            else {
                                dict[label] = value
                            }
                        }
                        else {
                            // The displayStyle value is nil for the current child.
                            // Keep the child value to the dictionary.
                            dict[label] = value
                        }
                    }
                }
            }
            
        }
        
        return dict
    }
    
    
    
    func toDictionary(fromJson json: Data) -> [String: Any]? {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: json, options: JSONSerialization.ReadingOptions.mutableLeaves) as? [String: Any] {
                return dictionary
            }
        }
        catch {
            print(error)
        }
        
        return nil
    }
    
    
    
    func toJson() -> Data? {
        // Check if the excludedProperties array has been declared in the current object.
        if let _ = getExcludedProperties() {
            // In that case create a dictionary that will contain only the properties that should be encoded.
            let dict = toDictionary()
            do {
                // Convert the dictionary into a Data object.
                let jsonData = try JSONSerialization.data(withJSONObject: dict, options: [JSONSerialization.WritingOptions.prettyPrinted, JSONSerialization.WritingOptions.sortedKeys])
                
                // Return the data.
                return jsonData
            }
            catch {
                print(error)
            }
        }
        else {
            // All properties of the object should be encoded in this case. Use the JSONEncoder class to do that.
            do {
                // Initialize a JSONEncoder object.
                let encoder = JSONEncoder()
                
                // Set the output formatting.
                encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
                
                // Encode.
                let jsonData = try encoder.encode(self)
                
                // Return the encoded data.
                return jsonData
            }
            catch {
                print(error)
            }
        }
        
        // If the execution reaches to this point then encoding the properties failed, so return nil.
        return nil
    }
    
    
    
    func toJSON(fromDictionary dictionary: [String: Any]) -> Data? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [JSONSerialization.WritingOptions.prettyPrinted, JSONSerialization.WritingOptions.sortedKeys])
            return jsonData
        }
        catch {
            print(error)
            return nil
        }
    }
    
    
    
    func archive() -> Data {
        return NSKeyedArchiver.archivedData(withRootObject: toDictionary())
    }
    
    
    
    // MARK: Save
    
    func save(json: Data, toURL url: URL) -> Bool {
        do {
            try json.write(to: url)
            return true
        }
        catch {
            print(error)
            return false
        }
    }
    
    
    
    func saveJSON() -> Bool {
        // Convert self to JSON.
        if let json = toJson() {
            // Build the URL to the documents directory appending the self name.
            if let appDataURL = getAppDataDirectoryURL() {
                let url = appDataURL.appendingPathComponent(getSelfName()).appendingPathExtension("json")
                
                // Save the JSON data.
                return save(json: json, toURL: url)
            }
        }
        
        return false
    }
    
    
    
    func savePlist(fromDictionary dict: [String: Any], toURL url: URL) -> Bool {
        do {
            try (dict as NSDictionary).write(to: url)
            return true
        }
        catch {
            print(error)
        }
        
        return false
    }
    
    
    
    func savePlist() -> Bool {
        // Get a dictionary with self properties and values.
        let dict = toDictionary()
        
        // Determine the URL to the save file.
        if let appDataURL = getAppDataDirectoryURL() {
            let url = appDataURL.appendingPathComponent(getSelfName()).appendingPathExtension("plist")
            
            // Save the plist file.
            return savePlist(fromDictionary: dict, toURL: url)
        }
        
        // Return false if the URL to the "appdata" file cannot be found.
        return false
    }
    
    
    
    func save(archive: Data, toURL url: URL) -> Bool {
        do {
            try archive.write(to: url)
            return true
        }
        catch {
            print(error)
            return false
        }
    }
    
    
    
    func saveArchive() -> Bool {
        if let appDataURL = getAppDataDirectoryURL() {
            let url = appDataURL.appendingPathComponent(getSelfName())
            
            return save(archive: archive(), toURL: url)
        }
        
        return false
    }
    
    
    
    // MARK: Load & Init
    
    func loadJSON(fromURL url: URL) -> Data? {
        do {
            let jsonData = try Data(contentsOf: url)
            return jsonData
        }
        catch {
            print(error)
            return nil
        }
    }
    
    
    
    func loadPlist(fromURL url: URL) -> [String: Any]? {
        if let dict = NSDictionary(contentsOf: url) {
            return dict as? [String: Any]
        }
        
        return nil
    }
    
    
    
    func loadArchive(fromURL url: URL) -> Data? {
        do {
            let archive = try Data(contentsOf: url)
            return archive
        }
        catch {
            print(error)
            return nil
        }
    }
    
    
    
    mutating func initialize(usingJSON json: Data) -> Bool {
        do {
            self = try JSONDecoder().decode(type(of: self), from: json)
            return true
        }
        catch {
            print(error)
        }
        
        return false
    }
    
    
    
    mutating func initialize(usingPlist plist: [String: Any]) -> Bool {
        if let json = toJSON(fromDictionary: plist) {
            return initialize(usingJSON: json)
        }
        
        return false
    }
    
    
    
    mutating func initialize(usingArchive archive: Data) -> Bool {
        if let dictionary = NSKeyedUnarchiver.unarchiveObject(with: archive) as? [String: Any] {
            if let json = toJSON(fromDictionary: dictionary) {
                return initialize(usingJSON: json)
            }
        }
        
        return false
    }
    
    
    
    mutating func initFromJSON() -> Bool {
        if let appDataURL = getAppDataDirectoryURL() {
            let url = appDataURL.appendingPathComponent(getSelfName()).appendingPathExtension("json")
            if let json = loadJSON(fromURL: url) {
                return initialize(usingJSON: json)
            }
        }
        
        return false
    }
    
    
    
    mutating func initFromPlist() -> Bool {
        if let appDataURL = getAppDataDirectoryURL() {
            let url = appDataURL.appendingPathComponent(getSelfName()).appendingPathExtension("plist")
            if let plist = loadPlist(fromURL: url) {
                return initialize(usingPlist: plist)
            }
        }
        
        return false
    }
    
    
    
    mutating func initFromArchive() -> Bool {
        if let appDataURL = getAppDataDirectoryURL() {
            let url = appDataURL.appendingPathComponent(getSelfName())
            if let archive = loadArchive(fromURL: url) {
                return initialize(usingArchive: archive)
            }
        }
        
        return false
    }
    
    
    init() {
        self.init()
    }
}


// MARK: Public Auxiliary Functions
extension GTCodable {
    func getDocDirPath() -> String {
        return (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))[0] as String
    }
    
    
    func getRaw() -> Any? {
        return nil
    }
    
    
    func getTextualRepresentation(fromJson json: Data) -> String? {
        return String(data: json, encoding: String.Encoding.utf8)
    }
    
    
    func describeSelf() -> String {
        var desc = ""
        
        let selfMirror = Mirror(reflecting: self)
        for (label, value) in selfMirror.children {
            desc += (label ?? "-No label-") + ": " + "\(value)" + "\n"
        }
        
        return desc
    }
}



// MARK: Enum-Specific
extension GTCodable where Self: RawRepresentable {
    func getRaw() -> Any? {
        let mirror = Mirror(reflecting: self)
        if mirror.displayStyle == .enum {
            return rawValue
        }
        
        return nil
    }
}


// MARK: Private Functions
extension GTCodable {
    /// It returns the name of the current class or struct.
    ///
    /// If the name cannot be specified, the word "Default" is returned as the name of self.
    ///
    /// - Returns: A `String` object containing the name of the current class or struct, or "Default" if it cannot be specified.
    private func getSelfName() -> String {
        let selfMirror = Mirror(reflecting: self)
        let descParts = selfMirror.description.components(separatedBy: "Mirror for ")
        if descParts.count > 1 {
            return descParts[1]
        }
        
        return "Default"
    }
    
    
    /// It returns the URL to the "appdata" dictionary inside the documents dictionary.
    ///
    /// - Returns: The URL to the "appdata" directory. If it doesn't exist, it's being created. If creating it fails, `nil` is then returned.
    private func getAppDataDirectoryURL() -> URL? {
        // Check if the "appdata" directory exists.
        // If not create it now.
        let appdataURL = URL(fileURLWithPath: getDocDirPath()).appendingPathComponent("appdata")
        let appdataPath = getDocDirPath() + "/appdata"
        var isDir : ObjCBool = true
        if !FileManager.default.fileExists(atPath: appdataPath, isDirectory: &isDir) {
            do {
                try FileManager.default.createDirectory(at: appdataURL, withIntermediateDirectories: false, attributes: nil)
            }
            catch {
                print(error)
                
                // The "appdata" directory couldn't be created.
                // Return nil.
                return nil
            }
        }
        
        // Return the URL to the "appdata" directory.
        return appdataURL
    }
    
    
    /// It gets the excluded properties of the current class or struct.
    ///
    /// When it's necessary to exclude properties from being JSON encoded or from the conversion to dictionary, then an array of String objects named "excludedProperties" must be declared in the class or struct, and filled with the names of the properties that should be left aside.
    ///
    /// - Returns: An array of String objects (`[String]`) with the names of the properties that should be excluded from any encoding or conversion, or `nil` if the "excludedProperties" array has not been defined.
    private func getExcludedProperties() -> [String]? {
        var excludedProperties: [String]!
        
        let selfMirror = Mirror(reflecting: self)
        for (label, value) in selfMirror.children {
            if let label = label {
                if label == "excludedProperties" {
                    excludedProperties = value as? [String]
                    break
                }
            }
        }
        
        return excludedProperties
    }
    
    
    /// It checks if the given property name is included in the collection of the properties that should be excluded from JSON encoding and any other kind of conversion (the `excludedProperties` array).
    ///
    /// - Parameter property: The name of the property that to look up.
    /// - Returns: `true` if the property is found in the `excludedProperties` array, `false` if it's not found or the `excludedProperties` array doesn't exist.
    private func isInExcludedProperties(property: String) -> Bool {
        var isExcluded = false
        
        if let excludedProperties = getExcludedProperties() {
            for prop in excludedProperties {
                if prop == property {
                    isExcluded = true
                    break
                }
            }
        }
        
        return isExcluded
    }
}


// MARK: Private Functions Assistive to the toDictionary() Function
extension GTCodable {
    /// It determines the underlying type of an Optional value and returns its DisplayType (if found).
    ///
    /// - Parameter value: The original optional value.
    /// - Returns: The display style of the actual type of the given value, or `nil` if the mirror of the given value has no child elements describing the reflected subject.
    private func specifyDisplayType(fromOptionalValue value: Any) -> Mirror.DisplayStyle? {
        var displayStyle: Mirror.DisplayStyle!
        
        // Get the mirror of the value.
        let mirror = Mirror(reflecting: value)
        
        // Check if the mirror of the value has children.
        if mirror.children.count > 0 {
            // Get the first child and check if it's a GTCodable type.
            if (mirror.children.first?.value as AnyObject) is GTCodable {
                // To determine if the type behind the optional value is an Enum or not, try to get the raw value.
                // If it's other than nil then it's an Enum, otherwise it's a Struct or Class.
                if let _ = (mirror.children.first?.value as! GTCodable).getRaw() {
                    displayStyle = Mirror.DisplayStyle.enum
                }
                else {
                    displayStyle = Mirror.DisplayStyle.struct
                }
            }
            else {
                // Not a GTCodable type.
                // Determine if the Optional is a collection (array).
                if let _ = value as? [Any] {
                    displayStyle = .collection
                }
                
                // Determine if the Optional is a dictionary.
                if let _ = value as? [AnyHashable: Any] {
                    displayStyle = .dictionary
                }
            }
            
            // Return the specified display type.
            return displayStyle
        }
        
        // Return nil if the mirror of the value doesn't have any children.
        return nil
    }
    
    
    
    /// Part of the process to create a dictionary out of the properties of the current object (see `toDictionary()`), it accepts a reflected value with display type of "collection" or "optional" with an underlying type of collection, and it goes through its contents trying to convert them to the proper representation acceptable for JSON encoding.
    ///
    /// If the incoming collection contains types conforming to GTCodable protocol, then it's necessary to proceed to special handling and fetch for each such type the raw value if it's an enum, or get a dictionary from a class or struct. Any fetched or converted values, or any other kind of values contained in the original collection, are stored to a new collection which eventually is returned from the function.
    ///
    /// - Parameters:
    ///   - collection: The input value is an `Any` object, as it can be an Optional or a collection type. It's the source for the processing that will take place.
    ///   - defaultDisplayStyle: The display style of the `collection` as it comes from the reflection.
    ///   - specifiedDisplayStyle: The display style of the `collection`, which is same to the `defaultDisplayStyle` if the `collection` is NOT an Optional, or "collection" if the `defaultDisplayStyle` is an Optional.
    /// - Returns: A new collection with JSON encodable contents, `nil` if the `collection` cannot be unwrapped.
    private func process(collection: Any, defaultDisplayStyle: Mirror.DisplayStyle, specifiedDisplayStyle: Mirror.DisplayStyle) -> [Any]? {
        // Check if the defaultDisplayStyle is the same to specifiedDisplayStyle, meaning they both have the "collection" value.
        // If that's true, then get the mirror of the collection parameter and store it to the collectionMirror variable.
        // If it's false and the defaultDisplayStyle has the "optional" value, then the collection parameter is Optional. If unwrapping is succesful, then get the mirror of the unwrapped dictionary and store it to the collectionMirror property.
        // If the defaultDisplayStyle is not an "optional", or unwrapping it fails, the collectionMirror remains nil.
        var collectionMirror: Mirror!
        if defaultDisplayStyle == specifiedDisplayStyle {
            collectionMirror = Mirror(reflecting: collection)
        }
        else {
            if let val = collection as? [Any] {
                collectionMirror = Mirror(reflecting: val)
            }
        }
        
        // Make sure that there is a mirror of the collection.
        if let collectionMirror = collectionMirror {
            // Initialize a new collection for storing.
            var newCollection = [Any]()
            
            // Traverse all child elements of the mirrored collection.
            for (_, collValue) in collectionMirror.children {
                // Check if the current value conforms to the GTCodable protocol.
                // In that case it's an enum, struct, or class.
                if let val = collValue as? GTCodable {
                    if let raw = val.getRaw() {
                        // If it's an enum, get the raw value.
                        newCollection.append(raw)
                    }
                    else {
                        // If it's a struct or class, then get all of the properies as a dictionary.
                        newCollection.append(val.toDictionary())
                    }
                }
                else {
                    // In this case the current value in the collection does not conform to GTCodable protocol.
                    // It's necessary to get its display type and:
                    // - If it's an optional to find the actual type behind the "optional" display type.
                    // - If it's an array (optional or not), process it in case it contains objects that conform to GTCodable protocol.
                    // - If it's a dictionary (optional or not), process it in case it contains objects that conform to GTCodable protocol.
                    // - Get a value that can be stored to the new collection and be JSON encodable.
                    
                    // Call the following function to do all the above.
                    if let toStore = getValueToStore(fromValue: collValue) {
                        newCollection.append(toStore)
                    }
                }
            }
            
            // Return the newCollection array.
            return newCollection
        }
        
        // Return nil because the collection parameter could not be unwrapped.
        return nil
    }
    
    
    
    /// Part of the process to create a dictionary out of the properties of the current object (see `toDictionary()`), it accepts a reflected value with display type of "dictionary" or "optional" with an underlying type of dictionary, and it goes through its contents trying to convert them to the proper representation acceptable for JSON encoding.
    ///
    /// If the incoming dictionary contains types conforming to GTCodable protocol, then it's necessary to proceed to special handling and fetch for each such type the raw value if it's an enum, or get a dictionary from a class or struct. Any fetched or converted values, as well as any other kind of values contained in the original dictionary, are stored to a new dictionary which eventually is returned from the function.
    ///
    /// - Parameters:
    ///   - dictionaryValue: The input value is an `Any` object, as it can be an Optional or a dictionary type. It's the source for the processing that will take place.
    ///   - defaultDisplayStyle: The display style of the `dictionaryValue` as it comes from the reflection.
    ///   - specifiedDisplayStyle: The display style of the `dictionaryValue`, which is same to the `defaultDisplayStyle` if the `dictionaryValue` is NOT an Optional, or "dictionary" if the `defaultDisplayStyle` is an Optional.
    /// - Returns: A new dictionary with all of the original contents having been transformed to the proper format, so it's possible to JSON encode. It returns `nil` if the `dictionaryValue` cannot be unwrapped.
    private func process(dictionaryValue: Any, defaultDisplayStyle: Mirror.DisplayStyle, specifiedDisplayStyle: Mirror.DisplayStyle) -> [AnyHashable: Any]? {
        // Check if the default display style of the given dictionary value is the same to the specified one.
        // If that's true, then both the defaultDisplayStyle and the specifiedDisplayStyle have the value "dictionary", and the dictionaryValue is not optional.
        // If they don't have the same value, then check if the default display style of the dictionaryValue is "optional", and if so, unwrap it.
        // In any case, the dictionary declared right next will contain (if possible) the unwrapped dictionary value.
        var dictionary: [AnyHashable: Any]!
        if defaultDisplayStyle == specifiedDisplayStyle {
            dictionary = dictionaryValue as! [AnyHashable: Any]
        }
        else if defaultDisplayStyle == .optional {
            if let val = dictionaryValue as? [AnyHashable: Any] {
                dictionary = val
            }
        }
        
        // Proceed if only the dictionary variable is not nil.
        if let dictionary = dictionary {
            // Initialize a new dictionary object. This one will contain all the values after processing.
            var newDict = [AnyHashable: Any]()
            
            // Go through all dictionary values accessing each key and value.
            for (dKey, dValue) in dictionary {
                // Check if the value conforms to the GTCodable protocol.
                // In that case it's a class, struct, or enum.
                // If it's an enum, get its raw value.
                // If it's a class or struct, get the dictionary representation.
                if let val = dValue as? GTCodable {
                    if let raw = val.getRaw() {
                        // If it's an enum, get the raw value.
                        newDict[dKey] = raw
                    }
                    else {
                        // If it's a struct or class, then get all of the properies as a dictionary.
                        newDict[dKey] = val.toDictionary()
                    }
                }
                else {
                    // In this case the current value in the dictionary does not conform to GTCodable protocol.
                    // It's necessary to get its display type and:
                    // - If it's an optional to find the actual type behind the "optional" display type.
                    // - If it's an array (optional or not), process it in case it contains objects that conform to GTCodable protocol.
                    // - If it's a dictionary (optional or not), process it in case it contains objects that conform to GTCodable protocol.
                    // - Get a value that can be stored to the new dictionary and be JSON encodable.
                    
                    // Call the following function to do all the above.
                    if let toStore = getValueToStore(fromValue: dValue) {
                        newDict[dKey] = toStore
                    }
                }
            }
            
            // Return the newDict dictionary.
            return newDict
        }
        
        // Return nil, the parameter value couldn't be unwrapped.
        return nil
    }
    
    
    
    /// An auxiliary function that performs common actions to the `process(collection:defaultDisplayStyle:specifiedDisplayStyle:)` and `process(dictionaryValue:defaultDisplayStyle:specifiedDisplayStyle:)` functions.
    ///
    /// - Parameter value: The value that should be examined.
    /// - Returns: A JSON encodable value (as `Any`).
    private func getValueToStore(fromValue value: Any) -> Any? {
        var toStore: Any!
        
        // Get the mirror of the parameter value in the dictionary.
        let mirror = Mirror(reflecting: value)
        
        // Keep the display style as the default display type. This won't change, it's a constant.
        let defaultDS = mirror.displayStyle
        
        // Keep the display type to a variable this time. It will probably change right next if the display style is an "optional".
        var specifiedDS = mirror.displayStyle
        
        // Check if the display type is an optional.
        if defaultDS == .optional {
            // In this case try to determine the actual display type of the value.
            if let displayType = specifyDisplayType(fromOptionalValue: value) {
                // On success, keep it in the specifiedDS variable.
                specifiedDS = displayType
            }
        }
        
        // Values with certain display type need further processing, so check what the value of the specifiedDS is.
        if specifiedDS == .collection {
            // In this case the value is an array (collection), so process it in case it contains objects that conform to GTCodable and require special treatment.
            if let newCollection = process(collection: value, defaultDisplayStyle: defaultDS!, specifiedDisplayStyle: specifiedDS!) {
                toStore = newCollection
            }
        }
        else if specifiedDS == .dictionary {
            // In this case the value is a dictionary, so process it in case it contains objects that conform to GTCodable and require special treatment.
            if let newDictionary = process(dictionaryValue: value, defaultDisplayStyle: defaultDS!, specifiedDisplayStyle: specifiedDS!) {
                toStore = newDictionary
            }
        }
        else {
            // There's nothing special to the current value in this case, so just keep it as it is.
            toStore = value
        }
        
        // Return the toStore value.
        return toStore
    }
}
