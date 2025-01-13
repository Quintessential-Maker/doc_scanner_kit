#import "DocumentScannerPlugin.h"
#if __has_include(<doc_scanner_kit/doc_scanner_kit-Swift.h>)
#import <doc_scanner_kit/doc_scanner_kit-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "doc_scanner_kit-Swift.h"
#endif

@implementation DocumentScannerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDocumentScannerPlugin registerWithRegistrar:registrar];
}
@end