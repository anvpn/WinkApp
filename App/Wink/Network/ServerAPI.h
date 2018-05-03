//
//  ServerAPI.h
//  API_Framework
//
//  Created by LaNet on 6/10/16.
//  Copyright © 2016 Lanet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef id (^successHandler)(id result);
typedef id (^testHandler) (NSURLRequest *request, NSHTTPURLResponse *response, id JSON);
typedef id (^errorHandler)(NSError* error);

@interface ServerAPI : NSObject

@property  BOOL showIndicator ;

- (void) invokeHTTPRequestGET : (NSString *)fullApiName : (BOOL)TokenEmbedded  :(NSString *)token  withSucessBlock:(void (^)(id result))SucessBlock  withFailureBlock:(void (^)(NSError * error))FailureBlock;

- (void) invokeHTTPRequestPOST : (NSString *)fullApiName : (NSMutableDictionary *)jsonDict : (BOOL)TokenEmbedded  :(NSString *)token withSucessBlock:(void (^)(id result))SucessBlock  withFailureBlock:(void (^)(NSError * error))FailureBlock;

- (void) invokeHTTPRequestPUT : (NSString *)fullApiName : (NSMutableDictionary *)jsonDict : (BOOL)TokenEmbedded  :(NSString *)token withSucessBlock:(void (^)(id result))SucessBlock  withFailureBlock:(void (^)(NSError * error))FailureBlock;

- (void) invokeHTTPRequestDELETE : (NSString *)fullApiName : (NSMutableDictionary *)jsonDict : (BOOL)TokenEmbedded  :(NSString *)token withSucessBlock:(void (^)(id result))SucessBlock  withFailureBlock:(void (^)(NSError * error))FailureBlock;

-(void) callWS : (NSMutableURLRequest *)request  withSucessBlock:(void (^)(id result))SucessBlock  withFailureBlock:(void (^)(NSError * error))FailureBlock;
-(void)showErrorAlert : (NSString *)strMesg :(NSString *)appName;

+(ServerAPI *)shareInstance;
-(BOOL) isInternetConnected;

@end
