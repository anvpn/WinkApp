


#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, ZWTValidationType)
{
    ZWTValidationTypeBlank,
    ZWTValidationTypeEmail,
    ZWTValidationTypeName,
    ZWTValidationTypePassword,
    ZWTValidationTypeNumber,
    ZWTValidationTypeInteger,
    ZWTValidationTypeAlphaNoSpace,
    ZWTValidationTypeAlphaWithSpace,
    ZWTValidationTypeAlphaNumericNospace,
    ZWTValidationTypeAlphaNumericWithspace,
    ZWTValidationTypeRegExp,
};

typedef NS_ENUM(NSInteger, ZWTValidationResult)
{
    ZWTValidationResultValid,
    ZWTValidationResultInvalid,
    ZWTValidationResultBlank,
    ZWTValidationResultNotAlpha,
    ZWTValidationResultNotNumber,
    ZWTValidationResultNotInteger,
    ZWTValidationResultLessLength,
    ZWTValidationResultMoreLength,
    ZWTValidationResultContainSpace
};

@interface ZWTValidation : NSObject

+ (ZWTValidationResult) isBlank:(NSString *)string;

+ (ZWTValidationResult) validateEmail:(NSString *)email isRequire:(BOOL)require;
+ (ZWTValidationResult) validatePassword:(NSString *)email isRequire:(BOOL)require;
+ (ZWTValidationResult) validateName:(NSString *)name isRequire:(BOOL)require;

+ (ZWTValidationResult) validateNumber:(NSString *)number isRequire:(BOOL)require;
+ (ZWTValidationResult) validateInteger:(NSString *)number isRequire:(BOOL)require;

+ (ZWTValidationResult) validateAlphaNospace:(NSString *)string isRequire:(BOOL)require;
+ (ZWTValidationResult) validateAlphaWithspace:(NSString *)string isRequire:(BOOL)require;
+ (ZWTValidationResult) validateAlphaNumericNospace:(NSString *)string isRequire:(BOOL)require;
+ (ZWTValidationResult) validateAlphaNumericWithspace:(NSString *)string isRequire:(BOOL)require;

+ (ZWTValidationResult) validateLength:(NSString *)string min:(NSUInteger)min max:(NSUInteger)max isRequire:(BOOL)require;

+ (ZWTValidationResult) validateString:(NSString *)string againstRegExp:(NSString *)regExp;

+ (ZWTValidationResult) validateDate:(NSDate *)date isAfterDate:(NSDate *)pastDate;
+ (ZWTValidationResult) validateDate:(NSDate *)date isBeforeDate:(NSDate *)futureDate;
+ (ZWTValidationResult) validateDate:(NSDate *)date isBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate;

@end
