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