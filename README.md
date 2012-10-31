Purpose
--------------

HRCoder is a replacement for the NSKeyedArchiver and NSKeyedUnarchiver classes. Although the NSKeyedArchiver writes data in binary Plist format, the structure of the Plist makes it hard to read, and nearly impossible to generate by hand.

The *HR* stands for *Human Readable*. HRCoder saves files in a simpler format than NSKeyedArchiver; Standard objects such as strings, dictionaries, arrays, numbers, booleans and binary data are all saved and loaded using the standard plist primitives, and any other type of object is saved as a simple dictionary, with the addition of a $class key to indicate the object type.

This makes it possible to easily generate HRCoder-compatible Plist files by hand, and then load them using the standard NSCoding protocol. You can also read and manually edit files saved by the HRCoder class without fear of corrupting the file.

The simple dictionary/array-based format used by HRCoding can also be easily stored as JSON, opening up more options for serialisation (NSKeyedArchiver is tied to Plists and cannot easily be used to save as JSON without creating a Plist as an intermediate step).

HRCoder is designed to work with the AutoCoding library (https://github.com/nicklockwood/AutoCoding), which can automatically write the `initWithCoder:` and `encodeWithCoder:` methods for your classes. Check out the *AutoTodoList* example to see how this works.

HRCoder is also designed to work hand-in-hand with the BaseModel library (https://github.com/nicklockwood/BaseModel) which forms the basis for building a powerful model hierarchy for your project with minimal effort. Check the *HRTodoList* example included in the BaseModel repository for an example of how these libraries can work together.


Supported OS & SDK Versions
-----------------------------

* Supported build target - iOS 6.0 / Mac OS 10.8 (Xcode 4.5, Apple LLVM compiler 5.1)
* Earliest supported deployment target - iOS 5.0 / Mac OS 10.7
* Earliest compatible deployment target - iOS 4.0 / Mac OS 10.6

NOTE: 'Supported' means that the library has been tested with this version. 'Compatible' means that the library should work on this OS version (i.e. it doesn't rely on any unavailable SDK features) but is no longer being tested for compatibility and may require tweaking or bug fixes to run correctly.


ARC Compatibility
------------------

HRCoder is compatible with both ARC and non-ARC compile targets.


Thread Safety
--------------

It is not safe to access a single HRCoder instance from multiple threads concurrently, hower using the HRCoder class methods to encode and decode objects is completely thread safe.


Installation
--------------

To use HRCoder, just drag the HRCoder.h and .m files into your project.


HRCoder properties
-------------------------

    @property (nonatomic, assign) NSPropertyListFormat outputFormat;

This property can be used to set the output format when serialising HRCoded plists. The default value is `NSPropertyListXMLFormat_v1_0`.


HRCoder methods
-----------------------------

HRCoder implements the following methods, which mirror those of the NSKeyedArchiver and NSKeyedUnarchiver classes.

    + (id)unarchiveObjectWithPlist:(id)plist;
    
Constructs an object tree from an encoded plist and returns it. The plist parameter can be any object that is natively supported by the Plist format. This would typically be a container object such as an NSDictionary or NSArray. If any other kind of object is supplied it will be returned without modification.

Note that this object need not actually be loaded from a Plist - you can create such an object quite easily using JSON or another compatible serialisation format.

    + (id)unarchiveObjectWithData:(NSData *)data;
    
Loads a serialised plist from an NSData object and returns an unarchived object tree by calling `unarchiveObjectWithPlist:` on the root object in the file. Supports text, xml or binary-formatted data. Data is deserialised using the `NSPropertyListMutableContainersAndLeaves` option to ensure that mutability of objects is preserved when serialising. There is a small performance overhead to this, so if you'd prefer immutable objects, load the plist yourself directly using the `NSPropertyListSerialization` class.

    + (id)unarchiveObjectWithFile:(NSString *)path;
    
Loads a data file in Plist format and returns an unarchived object tree by calling `unarchiveObjectWithData:`.

    + (id)archivedPlistWithRootObject:(id)object;
    
Encodes the passed object as a hierarchy of Plist-compatible objects, and returns it. The resultant object will typically be one of NSDictionary, NSArray, NSString, NSData, NSDate or NSNumber. This object is then safe to pass to NSPropertyListSerialisation for conversion to raw data or saving to a file (either a Plist or JSON, etc).

    + (NSData *)archivedDataWithRootObject:(id)rootObject;
    
Encodes the passed object by calling `archivedPlistWithRootObject:` and then serialises it to data using the XML property list format.
    
    + (BOOL)archiveRootObject:(id)rootObject toFile:(NSString *)path;
    
Encodes the passed object by calling `archivedDataWithRootObject:` and then saves it to the file path specified. The file is saved atomically to prevent data corruption.

    - (id)initForReadingWithData:(NSData *)data;
    
This method is used for creating an HRCoder instance from an encoded NSData object that can be passed directly to the initWithCoder: method of a class. It is included mostly for compatibility with the `NSKeyedUnarchiver` class, which has the same method. The data must contain a plist-encoded NSDictionary object. Other root objects types such as NSArray are not supported with this method (you can use the `unarchiveObjectWithData:` method to load data containing other root object types).

    - (id)initForWritingWithMutableData:(NSMutableData *)data;
    
This method is used to create an HTCoder object for the purpose of writing to a data object. Once you have created the HRCoder instance, you can pass it to the `encodeWithCoder:` method of an object to encode it. Once you have written an object, calling `finishEncoding` will write the serialised plist data into the NSMutableData object.

    - (void)finishDecoding;
    
Finishes decoding data that was opened using the `initForReadingWithData: method.`

    - (void)finishEncoding;
    
When a file has been opened using the `initForWritingWithMutableData:` method, this will close it off and write the serialised data to the originally specified NSMutableData object.


Plist structure
---------------------------

Any ordinary Plist can be loaded using HECoder and it will behave the same way as if you loaded it using `NSPropertyListSerialization`. To add custom classes to the Plist, define the object as if it was a dictionary, but add an additional `$class` key with the class name of the object. For example, this code will result in an ordinary NSDictionary:

    <dict>
        <key>coming</key>
        <string>Hello</string>
        <key>going</key>
        <string>Goodbye</string>
    </dict>
    
But this will load an object of class `Greetings` (assuming that class exists in your project).

    <dict>
        <key>$class</key>
        <string>Greetings</string>
        <key>coming</key>
        <string>Hello</string>
        <key>going</key>
        <string>Goodbye</string>
    </dict>
    
Another feature of NSCoding that isn't supported by ordinary Plists is circular references. HRCoding supports this using the an aliasing mechanism. If you want to re-use an object in another place within your object hierarchy, you can do this using the following syntax:

    <dict>
        <key>$alias</key>
        <string>path.to.the.object</string>
    </dict>
    
The alias value is a key path to the original object within the hierarchy. To see this in context, here is a simple example of how this would work:

    <dict>
        <key>object1</key>
        <string>Hello World</string>
        <key>object2</key>
        <dict>
            <key>$alias</key>
            <string>object1</string>
        </dict>
    </dict>
    
Once loaded, the object1 and object2 properties will both point at the same "Hello World" string instance (not just the same value, but the same actual object). This also works with arrays - just use the array index as the alias key:

    <array>
        <string>Hello World</string>
        <dict>
            <key>$alias</key>
            <string>0</string>
        </dict>
    </array>
    
Forward references are permitted in aliases (i.e. aliasing an object which is declared later in the hierarchy), however this should be avoided as possible as it involves inserting `HRCoderAliasPlaceholder` objects as the object tree is deserialised, and then replacing these later, which incurs a slight performance penalty.

Note that if you are using aliases you should be careful not to call methods on deserialised objects insider your `initWithCoder:` method, as they may not always be of the expected type until loading is complete.