#import "HaptikSdkPlugin.h"
#if __has_include(<haptik_sdk/haptik_sdk-Swift.h>)
#import <haptik_sdk/haptik_sdk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "haptik_sdk-Swift.h"
#endif

@implementation HaptikSdkPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftHaptikSdkPlugin registerWithRegistrar:registrar];
}
@end
