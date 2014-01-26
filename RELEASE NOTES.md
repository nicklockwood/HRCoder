Version 1.3.1

- Fixed bug with encoding conditional objects
- HRCoder can now encode NSData objects as JSON using base 64 encoding

Version 1.3

- outputFormat enum is now of type HRCoderFormat, and includes JSON as an option
- When using the JSON output format, NSData and NSDate objects are now encoded in a JSON-compatible format
- HRCoder can now load data encoded in JSON format
- Now complies with -Weverything warning level
- Improved performance when using ARC
- HRCoder now requires ARC

Version 1.2.3

- Fixed a bug where objects that override isEqual would be incorrectly aliased
- Objects of type NSNumber, NSDate and short NSStrings will no longer be aliased
- Now complies with -Wall and -Wextra warning levels

Version 1.2.2

- Fixed a bug where objects could be skipped when decoding, depending on the order of items in the plist
- Added CocoaPods podspec

Version 1.2.1

- Fixed bug where nested NSDictionaries were not decoded correctly

Version 1.2

- Added `initForReadingWithData:` and `initForWritingWithMutableData:` methods, which improve compatibility with the NSKeyedArchiver/Unarchiver class interfaces.
- Added outputFormat property for setting the Plist format when saving

Version 1.1.3

- Fixed analyzer warning due to over-autorelease of decoded object

Version 1.1.2

- Fixed crash when attempting to archive a nil object property

Version 1.1.1

- HRCoder now calls the `awakeAfterUsingCoder:` method on objects after they are unarchived.
- HRCoder now calls the `classForCoder` and `replacementObjectForCoder:` methods on an object prior to archiving.

Version 1.1

- Added `unarchiveObjectWithData:` and `archivedDataWithRootObject:` methods
- HRCoder now saves in XML format instead of binary by default
- Now supports 32-bit CPUs on Mac OS 10.6

Version 1.0

- Initial release