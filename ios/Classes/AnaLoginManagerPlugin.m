#import "AnaLoginManagerPlugin.h"
#if __has_include(<ana_login_manager/ana_login_manager-Swift.h>)
#import <ana_login_manager/ana_login_manager-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "ana_login_manager-Swift.h"
#endif

@implementation AnaLoginManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAnaLoginManagerPlugin registerWithRegistrar:registrar];
}
@end
