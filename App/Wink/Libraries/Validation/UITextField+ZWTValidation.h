
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "ZWTValidation.h"

@interface UITextField (ZWTValidation)

- (ZWTValidationResult) validate:(ZWTValidationType)type;
- (ZWTValidationResult) validate:(ZWTValidationType)type showRedRect:(BOOL)errorRect;
- (ZWTValidationResult) validate:(ZWTValidationType)type showRedRect:(BOOL)errorRect getFocus:(BOOL)focusOnError;
- (ZWTValidationResult) validate:(ZWTValidationType)type showRedRect:(BOOL)errorRect getFocus:(BOOL)focusOnError alertMessage:(NSString *)message;

- (ZWTValidationResult) validateWithRegExp:(NSString *)regExp;
- (ZWTValidationResult) validateWithRegExp:(NSString *)regExp showRedRect:(BOOL)errorRect;
- (ZWTValidationResult) validateWithRegExp:(NSString *)regExp showRedRect:(BOOL)errorRect getFocus:(BOOL)focusOnError;
- (ZWTValidationResult) validateWithRegExp:(NSString *)regExp showRedRect:(BOOL)errorRect getFocus:(BOOL)focusOnError alertMessage:(NSString *)message;

@end
