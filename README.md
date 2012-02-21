Serializer composition of NSKeyedArchvier/NSKeyedUnarchiver that primarily deals with creating portable seralized plists of objects for use on both the Mac and iOS.

The current version only deals with portability of NSAttributedString and its components that are perhaps not present on iOS. This includes the following but may ahve more,

- NSFont to UIFont
- NSColor to UIColor
- NSAttributedString to close to 1-to-1 mapping of NSAttributedString on relevant platforms

#### How
MNCoder works by having intermediate objects that are actually serializable that when unarchived on various platforms will have platform specific representations generated. This currently only works for the fonts and colors. NSParagraphStyles may require regeneration of the entire Attributed string and is currently under investigation as it seems to require explicit setting of Alignments via CoreText.

#### So now what?
It is fairly easy to implement the intermediate objects that will handle the translation between the different platforms. All that is needed is for any object to implement the `MNCIntermediateObjectProtocol` which consists of the following.

`+(NSArray *)subsituteClasses;` Basically returns an NSArray of NSString class names that the Intermediate object negotiates for. In the case of `NSFont`/`UIFont`, the NSArray basically will contain NSString values of `NSFont` and `UIFont` respectively.

`-(id)initWithSubsituteObject:(id)object;` is the initializer that is used when initializing the intermediate object for serialization.

`-(id)platformRepresentation;` returns the object that is to be represented for the current platform that the serialzied version is decoded for.

In addition to these methods, the intermediate object protocol also requires that the NSCoding protocol be implemented such that these intermediate objects can be serialized by the Archiver.

Attributed strings have their own internal intermediate objects to handle the various features that iOS/Mac supports and will reduce the current working set to the lowest common denominator by rejecting attributes it doesn't understand (sadly NSLinkAttributeName for links on Mac OS X). Further work can be made to enhnace this system that will provide a way to revive attachments and links.

Specifically for Attributed strings, you can set whether it will be a lossless translation (by preserving attributes that can't be translated) or one that is not by setting the lossless BOOL via a static method `[MNAttributedString setLossless:(BOOL)]`.

#### Cavets
- Doesn't do TextLists and TextBlocks
- Doesn't do certain portions of the Mac's Attributed String (ie. hypenation factor, etc.)
- Doesn't do certain portions of the iOS's Attributed String (ie. background color, etc.)
- Links
- Text attachments

#### Sample Project
The same project provided opens as a workspace, MNcoder.xcworkspace and contain 2 projects, one for iOS and one for Mac OS X for testing. All archivng and unarchiving does so in the NSTemporaryDirectory() under the file name MNCoderTest.plist or whatever is set in the #define in the MNCoder.h file.

This project makes use of git submodules for EGOTextView.

Remember to do `git submodule init` and `git submodule update` after cloning the project.