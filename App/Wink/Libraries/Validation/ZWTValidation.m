

#import "ZWTValidation.h"


@implementation ZWTValidation

+ (ZWTValidationResult) isBlank:(NSString *)string;
{
    @try
    {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        if(string == Nil || [string isEqualToString:@""])
        {
            return ZWTValidationResultBlank;
        }
        
        return ZWTValidationResultValid;
    }
    @catch (NSException *exception)
    {
        //DDLogError(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validateEmail:(NSString *)email isRequire:(BOOL)require
{
    @try
    {
        if(require && (email == Nil || [email isEqualToString:@""]))
        {
            return ZWTValidationResultBlank;
        }
        else
        {
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
			
            return [self validateString:email againstRegExp:emailRegex];
        }
    }
    @catch (NSException *exception)
    {
        //DDLogError(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validatePassword:(NSString *)password isRequire:(BOOL)require
{
    @try
    {
        NSString *trimmedPassword = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        ZWTValidationResult result = [self validateLength:trimmedPassword min:6 max:128 isRequire:require];
        
        if(result == ZWTValidationResultValid)
        {
            if(![password isEqualToString:trimmedPassword])
            {
                return ZWTValidationResultContainSpace;
            }
            else
            {
                return ZWTValidationResultValid;
            }
        }
        else
        {
            return result;
        }
    }
    @catch (NSException *exception)
    {
        //DDLogError(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validateName:(NSString *)name isRequire:(BOOL)require
{
    NSString *trimmedName = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    ZWTValidationResult result = [self validateLength:trimmedName min:2 max:50 isRequire:require];
    
    if(result == ZWTValidationResultValid)
    {
        result = [self validateString:trimmedName againstRegExp:@"(^[A-Za-z .'-]{2,50})"];
        
        return result;
    }
    else
    {
        return result;
    }
}
+ (ZWTValidationResult) validateNumber:(NSString *)number isRequire:(BOOL)require
{
    @try
    {
        number = [number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if(require && (number == Nil || [number isEqualToString:@""]))
        {
            return ZWTValidationResultBlank;
        }
        
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        NSNumber *isNumber = [formatter numberFromString:number];
    
        if(isNumber)
        {
            return ZWTValidationResultValid;
        }
        else
        {
            return ZWTValidationResultInvalid;
        }
    }
    @catch (NSException *exception)
    {
       // DDLogError(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validateInteger:(NSString *)number isRequire:(BOOL)require
{
    @try
    {
        number = [number stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if(require && (number == Nil || [number isEqualToString:@""]))
        {
            return ZWTValidationResultBlank;
        }
        else if(!require && (number == Nil || [number isEqualToString:@""]))
        {
            return ZWTValidationResultValid;
        }
        
        NSScanner *scan = [NSScanner scannerWithString:number];
        
        int val;
        
        if([scan scanInt:&val] && scan.atEnd)
        {
            return ZWTValidationResultValid;
        }
        else
        {
            return ZWTValidationResultInvalid;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validateAlphaNospace:(NSString *)string isRequire:(BOOL)require;
{
    @try
    {
        NSString *trimedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if(require && (trimedString == Nil || [trimedString isEqualToString:@""]))
        {
            return ZWTValidationResultBlank;
        }
        
        NSString *alphaRegex = @"[A-Za-z]+";
        
        return [self validateString:string againstRegExp:alphaRegex];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validateAlphaWithspace:(NSString *)string isRequire:(BOOL)require
{
    @try
    {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if(require && (string == Nil || [string isEqualToString:@""]))
        {
            return ZWTValidationResultBlank;
        }
        
        NSString *alphaRegex = @"[A-Za-z ]+";
        
        return [self validateString:string againstRegExp:alphaRegex];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validateAlphaNumericNospace:(NSString *)string isRequire:(BOOL)require
{
    @try
    {
        NSString *trimedString = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if(require && (trimedString == Nil || [trimedString isEqualToString:@""]))
        {
            return ZWTValidationResultBlank;
        }
        
        NSString *alphaRegex = @"[A-Za-z0-9]+";
        
        return [self validateString:string againstRegExp:alphaRegex];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validateAlphaNumericWithspace:(NSString *)string isRequire:(BOOL)require
{
    @try
    {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        if(require && (string == Nil || [string isEqualToString:@""]))
        {
            return ZWTValidationResultBlank;
        }
        
        NSString *alphaRegex = @"[A-Za-z0-9 ]+";
        
        return [self validateString:string againstRegExp:alphaRegex];
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validateLength:(NSString *)string min:(NSUInteger)min max:(NSUInteger)max isRequire:(BOOL)require
{
    @try
    {
        if(require && (string == Nil || [string isEqualToString:@""]))
        {
            return ZWTValidationResultBlank;
        }
        
        if (string.length < min)
        {
            return ZWTValidationResultLessLength;
        }
        else if ( string.length > max)
        {
            return ZWTValidationResultMoreLength;
        }
        
        return ZWTValidationResultValid;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception : %@", exception);
    }
}

+ (ZWTValidationResult) validateString:(NSString *)string againstRegExp:(NSString *)regExp
{
    @try
    {
        NSPredicate *regExpTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExp];
        
        if([regExpTest evaluateWithObject:string])
        {
            return ZWTValidationResultValid;
        }
        else
        {
            return ZWTValidationResultInvalid;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception : %@", exception);
    }
}

+ (ZWTValidationResult) validateDate:(NSDate *)date isAfterDate:(NSDate *)pastDate
{
    @try
    {
        if([date compare:pastDate] == NSOrderedDescending)
        {
            return ZWTValidationResultValid;
        }
        else
        {
            return ZWTValidationResultInvalid;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validateDate:(NSDate *)date isBeforeDate:(NSDate *)futureDate
{
    @try
    {
        if([date compare:futureDate] == NSOrderedAscending)
        {
            return ZWTValidationResultValid;
        }
        else
        {
            return ZWTValidationResultInvalid;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception : %@", exception);
    }
}
+ (ZWTValidationResult) validateDate:(NSDate *)date isBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate
{
    @try
    {
        if ([date compare:firstDate] == NSOrderedAscending)
        {
            return ZWTValidationResultInvalid;
        }
        
        if ([date compare:secondDate] == NSOrderedDescending)
        {
            return ZWTValidationResultInvalid;
        }
        
        return ZWTValidationResultValid;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception : %@", exception);
    }
}
@end
