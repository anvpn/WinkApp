//
//  WinkWebservice.h
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//
extern NSString *const RKeyCode;
extern NSString *const RKeyData;
extern NSString *const RKeyObjectID;
extern NSString *const RKeyMessage;
extern NSString *const RKeyPageNo;

extern NSString *const RKeyOperationType;

extern NSInteger const RCodeSuccess;
extern NSInteger const RCodeUnSuccess;

extern NSInteger const RCodeUnauthorized;

extern NSInteger const RCodeAccountBlokedByAdmin;
extern NSInteger const RCodeAccountRemovedByAdmin;

extern NSInteger const RCodeAccountInactiveByAdmin;
extern NSInteger const RCodeCMSInactiveByAdmin;
extern NSInteger const RCodeVerificationCodeInactive;

extern NSInteger const RCodeInvalidEmailID;
extern NSInteger const RCodeInvalidPassword;
extern NSInteger const RCodeInvalidMobileNumber;
extern NSInteger const RCodeInvalidVerifyCode;
extern NSInteger const RCodeInvalidAPIResponse;
extern NSInteger const RCodeInvalidImageName;
extern NSInteger const RCodeInvalidOperation;

extern NSInteger const RCodeEmailAlreadyRegistered;
extern NSInteger const RCodeEmailAlreadyVerified;
extern NSInteger const RCodeMobileAlreadyRegistered;
extern NSInteger const RCodeMobileAlreadyVerified;
extern NSInteger const RCodeLicenseAlreadyRegistered;
extern NSInteger const RCodeShipingAlreadyAccepted;
extern NSInteger const RCodeCounterOfferStarted;

extern NSInteger const RCodeEmptyParameteres;
extern NSInteger const RCodeEmptyImageParameteres;
extern NSInteger const RCodeEmptyOperationParameter;
extern NSInteger const RCodeNoLicenceVehicleDetail;
extern NSInteger const RCodeNoBankDetail;
extern NSInteger const RCodeBTAccountStatusPending;
extern NSInteger const RCodeBTAccountStatusSuspended;

extern NSInteger const RCodeNoData;

extern NSInteger const RCodeMobileNotverified;

//Custom Code
extern NSInteger const RCodeRequestFail;
extern NSString *const FileExtension;


#define WinkWebServiceAPI [WinkWebservice APIClient]
#define AppDeleObj ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#import <AFNetworking/AFNetworking.h>

@interface WinkWebservice : AFHTTPSessionManager
    
    
+ (WinkWebservice *)APIClient;
    
- (void)requestFail:(NSURLSessionDataTask *)task withError:(NSError *)error;
    
+ (NSURL *)URLForProfileImage:(NSString *)pathComponent;
+ (NSURL *)URLForCoverImage:(NSString *)pathComponent;
+ (NSURL *)URLForGallaryImage:(NSString *)pathComponent;
+ (NSURL *)URLForGallaryVideo:(NSString *)pathComponent;

+ (NSURL *)URLForGiftImage:(NSString *)pathComponent;
+ (NSURL *)URLForChatImages:(NSString *)pathComponent;

+ (void)downloadImageWithURL:(NSURL *)URLImage complication:(void (^)(UIImage *image, NSError *error))completion;
    
@end

@interface WinkAPIResponse : NSObject
    
@property (nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *cashoutBalance;
@property (strong, nonatomic) NSError  *error;
    
- (instancetype)initWithCode:(NSInteger)statusCode andMessage:(NSString *)responseMessage;

- (instancetype)initWithCode:(NSInteger)statusCode andMessage:(NSString *)responseMessage andcashoutBalance:(NSString *)Balance;

- (instancetype)initWithCode:(NSInteger)statusCode andError:(NSError *)errorDetail;
    
@end
