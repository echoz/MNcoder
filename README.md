Serializer subclass of NSKeyedArchvier/NSKeyedUnarchiver that primarily deals with creating portable seralized plists of objects for use on both the Mac and iOS.

The current version only deals with portability of NSAttributedString and its components that are perhaps not present on iOS. This includes the following but may ahve more,

- NSFont to UIFont
- NSColor to UIColor
- NSParagraphStyle to < Some CoreText Alignment Value >

#### How
MNCoder works by having intermediate objects that are actually serializable that when unarchived on various platforms will have platform specific representations generated. This currently only works for the fonts and colors. NSParagraphStyles may require regeneration of the entire Attributed string and is currently under investigation as it seems to require explicit setting of Alignments via CoreText.