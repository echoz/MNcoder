Serializer subclass of NSKeyedArchvier/NSKeyedUnarchiver that primarily deals with creating portable seralized plists of objects for use on both the Mac and iOS.

The current version only deals with portability of NSAttributedString and its components that are perhaps not present on iOS. This includes the following but may ahve more,

- NSFont to UIFont
- NSColor to UIColor
- NSParagraphStyle to < Some CoreText Alignment Value >

#### How
MNCoder works by having intermediate objects that are actually serializable that when unarchived on various platforms will have platform specific representations generated. This currently only works for the fonts and colors. NSParagraphStyles may require regeneration of the entire Attributed string and is currently under investigation as it seems to require explicit setting of Alignments via CoreText.

#### So now what?
It is fairly easy to implement the intermediate objects that will handle the translation between the different platforms. All that is needed is for any object to implement the `MNCIntermediateObjectProtocol` which consists of the following.

`+(NSArray *)subsituteClasses;` Basically returns an NSArray of NSString class names that the Intermediate object negotiates for. In the case of `NSFont`/`UIFont`, the NSArray basically will contain NSString values of `NSFont` and `UIFont` respectively.

`-(id)initWithSubsituteObject:(id)object;` is the initializer that is used when initializing the intermediate object for serialization.

`-(id)platformRepresentation;` returns the object that is to be represented for the current platform that the serialzied version is decoded for.

In addition to these methods, the intermediate object protocol also requires that the NSCoding protocol be implemented such that these intermediate objects can be serialized by the Archiver.

#### Proposed Solution for NSParagraphStyle in NSAttributedString

It will have an intermediate class that will inspect its attributes and serialize them accordingly. So in this case, it will selectively hunt for NSParagraphStyle and perform some sort of translation function such that it can render as CoreText and vice versa.