#import "DocumentScannerPlugin.h"
#if __has_include(<doc_scanner_kit/DocScannerKitPlugin.h>)
#import <doc_scanner_kit/DocScannerKitPlugin.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
//#import "doc_scanner_kit-Swift.h"
#import "DocScannerKitPlugin.h"
#endif

@implementation DocumentScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDocumentScannerPlugin registerWithRegistrar:registrar];
}
@end