//
//  WinkWebservice.m
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkWebservice.h"

//#define BasePath @"http://www.winkandroid.com/"
#define BasePath @"http://winkfreedating.com/"
#define BaseFilePath BasePath @"api/"

NSString *const BaseAPIPath = BaseFilePath @"v3/method";

NSString *const BaseUserFolderPath   = BasePath @"photo/";
NSString *const BaseProfileImagePath = BasePath @"cover/";
NSString *const BaseGallaryImagePath = BasePath @"gallery/";
NSString *const BaseGallaryVideoPath = BasePath @"video/";
NSString *const BaseGiftImagePath   = BasePath @"gifts/";
NSString *const BaseChatImagePath   = BasePath @"chat_images/";

NSString *const RKeyCode     = @"error";
NSString *const RKeyData     = @"data";
NSString *const RKeyObjectID = @"id";
NSString *const RKeyMessage  = @"error_description";
NSString *const RKeyPageNo   = @"i_page";

NSString *const RKeyOperationType = @"e_operation_type";

NSInteger const RCodeSuccess   = 0;
NSInteger const RCodeUnSuccess = 101;

NSInteger const RCodeUnauthorized = 102;

NSInteger const RCodeAccountBlokedByAdmin   = 120;
NSInteger const RCodeAccountRemovedByAdmin  = 130;

NSInteger const RCodeAccountInactiveByAdmin   = 140;
NSInteger const RCodeCMSInactiveByAdmin       = 142;
NSInteger const RCodeVerificationCodeInactive = 143;

NSInteger const RCodeInvalidEmailID      = 150;
NSInteger const RCodeInvalidPassword     = 151;
NSInteger const RCodeInvalidMobileNumber = 152;
NSInteger const RCodeInvalidVerifyCode   = 153;
NSInteger const RCodeInvalidAPIResponse  = 154;
NSInteger const RCodeInvalidImageName    = 155;
NSInteger const RCodeInvalidOperation    = 156;

NSInteger const RCodeEmailAlreadyRegistered   = 160;
NSInteger const RCodeEmailAlreadyVerified     = 161;
NSInteger const RCodeMobileAlreadyRegistered  = 163;
NSInteger const RCodeMobileAlreadyVerified    = 164;
NSInteger const RCodeLicenseAlreadyRegistered = 166;
NSInteger const RCodeShipingAlreadyAccepted   = 167;
NSInteger const RCodeCounterOfferStarted      = 168;

NSInteger const RCodeEmptyParameteres        = 170;
NSInteger const RCodeEmptyImageParameteres   = 171;
NSInteger const RCodeEmptyOperationParameter = 172;
NSInteger const RCodeNoLicenceVehicleDetail  = 173;
NSInteger const RCodeNoBankDetail            = 176;
NSInteger const RCodeBTAccountStatusPending  = 178;
NSInteger const RCodeBTAccountStatusSuspended= 179;

NSInteger const RCodeNoData = 180;

NSInteger const RCodeMobileNotverified = 191;

//Custom Code
NSInteger const RCodeRequestFail = 12321;
NSString *const FileExtension   =@".inc.php";

@implementation WinkWebservice
    
#pragma mark - Initialization Method
+ (WinkWebservice *)APIClient
    {
        static WinkWebservice *_sharedClient = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^
                      {
                          NSURL *baseURL = [NSURL URLWithString:BaseAPIPath];
                          
                          NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
                          
//#if !BUILT_FOR_RELEASE
  //                        config.protocolClasses = @[[NFXProtocol class]];
                          
    //                      [[NFX sharedInstance] start];
//#endif
                          
                          _sharedClient = [[WinkWebservice alloc] initWithBaseURL:baseURL sessionConfiguration:config];
                          
                          //_sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
                          
                          _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
                          
                          [_sharedClient.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
                          
                         // _sharedClient.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
                          
                          _sharedClient.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingMutableLeaves];
                      });
        
        return _sharedClient;
    }
    
#pragma mark - Error Handler Method
- (void)requestFail:(NSURLSessionDataTask *)task withError:(NSError *)error
    {
        NSString *htmlError = [[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey]
                                                    encoding:NSUTF8StringEncoding];
        
        // NSLog(@"Error in Text format : %@", htmlError);
        
        [SVProgressHUD dismiss];
        
        if(error.code == kCFURLErrorTimedOut)
        {
            [WinkUtil showAlertFromController:nil withMessage:WinkNoInternet];
        }
    }
    
#pragma mark - Path Generation Method
+ (NSURL *)URLForProfileImage:(NSString *)pathComponent
    {
        NSURL *profileImageURL = [NSURL URLWithString:BaseUserFolderPath];
        
        profileImageURL = [profileImageURL URLByAppendingPathComponent:pathComponent];
        
        return profileImageURL;
    }
    
+ (NSURL *)URLForCoverImage:(NSString *)pathComponent
    {
        
        NSURL *profileImageURL = [NSURL URLWithString:BaseProfileImagePath];
        
        profileImageURL = [profileImageURL URLByAppendingPathComponent:pathComponent];
        
        return profileImageURL;
    }
    
+ (NSURL *)URLForGallaryImage:(NSString *)pathComponent
{
    
    NSURL *profileImageURL = [NSURL URLWithString:BaseGallaryImagePath];
    
    profileImageURL = [profileImageURL URLByAppendingPathComponent:pathComponent];
    
    return profileImageURL;
}
+(NSURL *)URLForGallaryVideo:(NSString *)pathComponent
{
    NSURL *profileImageURL = [NSURL URLWithString:BaseGallaryVideoPath];
    
    profileImageURL = [profileImageURL URLByAppendingPathComponent:pathComponent];
    
    return profileImageURL;

}
+ (NSURL *)URLForGiftImage:(NSString *)pathComponent
{
    NSURL *profileImageURL = [NSURL URLWithString:BaseGiftImagePath];
    
    profileImageURL = [profileImageURL URLByAppendingPathComponent:pathComponent];
    
    return profileImageURL;
}
+(NSURL *)URLForChatImages:(NSString *)pathComponent
{
    NSURL *profileImageURL = [NSURL URLWithString:BaseChatImagePath];
    
    profileImageURL = [profileImageURL URLByAppendingPathComponent:pathComponent];
    
    return profileImageURL;
}
+ (void)downloadImageWithURL:(NSURL *)URLImage complication:(void (^)(UIImage *image, NSError *error))completion
    {
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:URLImage.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject)
         {
             UIImage *image = [UIImage imageWithData:responseObject];
             
             if(image)
             {
                 completion(image, nil);
             }
             else
             {
                 completion(nil, nil);
             }
         }
             failure:^(NSURLSessionTask *operation, NSError *error)
         {
             completion(nil, error);
         }];
    }
    
    @end

@implementation WinkAPIResponse
    
    @synthesize code, message, error,cashoutBalance;
    
- (instancetype)initWithCode:(NSInteger)statusCode andMessage:(NSString *)responseMessage
    {
        self = [super init];
        
        if(self)
        {
            code    = statusCode;
            message = responseMessage;
        }
        
        return self;
    }

- (instancetype)initWithCode:(NSInteger)statusCode andMessage:(NSString *)responseMessage andcashoutBalance:(NSString *)Balance
{
    self = [super init];
    
    if(self)
    {
        code    = statusCode;
        message = responseMessage;
        cashoutBalance = Balance;
    }
    
    return self;
}
- (instancetype)initWithCode:(NSInteger)statusCode andError:(NSError *)errorDetail
    {
        self = [super init];
        
        if(self)
        {
            code  = statusCode;
            error = errorDetail;
        }
        
        return self;
    }

@end
