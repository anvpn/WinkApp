//
//  ServerAPI.m
//  API_Framework
//
//  Created by LaNet on 6/10/16.
//  Copyright © 2016 Lanet. All rights reserved.
//

#import "ServerAPI.h"
#import <SystemConfiguration/SystemConfiguration.h>

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])


@implementation ServerAPI
@synthesize showIndicator;
UIActivityIndicatorView *indicator ;

+(ServerAPI *)shareInstance
{
    static ServerAPI * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ServerAPI alloc] init];
        indicator = [[UIActivityIndicatorView alloc]
                     initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center =   [[UIApplication sharedApplication]keyWindow].center;
        indicator.tag = 111;
        indicator.hidesWhenStopped = true;
        
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        if (!window) {
            window = [[UIApplication sharedApplication].windows objectAtIndex:0];
        }
        
        
        [window addSubview:indicator];
        [window bringSubviewToFront:indicator];

        [[[UIApplication sharedApplication]keyWindow] makeKeyAndVisible];
        
        
    });
    return instance;
}

-(void)stopIndicator
{
    if (showIndicator) {

        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator stopAnimating];
            
        });
    }
    
   
}

-(void)startIndicator
{
    if (showIndicator) {
        [indicator startAnimating];
    }
}



- (void) invokeHTTPRequestGET : (NSString *)fullApiName : (BOOL)TokenEmbedded  :(NSString *)token withSucessBlock:(void (^)(id result))SucessBlock  withFailureBlock:(void (^)(NSError * error))FailureBlock
{

    [self startIndicator];

    NSURL *_url = [NSURL URLWithString:fullApiName];
    NSMutableURLRequest *_request = [NSMutableURLRequest requestWithURL:_url];
    [_request setTimeoutInterval:30];
    [_request setHTTPMethod:@"GET"];
    [_request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    if(TokenEmbedded == true)
    {
        [_request setValue:token forHTTPHeaderField:@"Authorization"];
       
    }
    
    [self callWS:_request withSucessBlock:^(id result) {

        [self stopIndicator];
        SucessBlock(result);

    } withFailureBlock:^(id error) {
        [self stopIndicator];
        FailureBlock(error);
        
    }];
    
    
}


- (void) invokeHTTPRequestPOST : (NSString *)fullApiName : (NSMutableDictionary *)jsonDict : (BOOL)TokenEmbedded  :(NSString *)token withSucessBlock:(void (^)(id result))SucessBlock  withFailureBlock:(void (^)(NSError * error))FailureBlock
{
    [self startIndicator];

    NSError *error;
    NSURL *_url = [NSURL URLWithString:fullApiName];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
    
    NSMutableURLRequest *_request = [NSMutableURLRequest requestWithURL:_url];
    [_request setTimeoutInterval:30];
    [_request setHTTPMethod:@"POST"];
    
    [_request setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];

//    [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:jsonData];
    
//    if(TokenEmbedded == true)
//    {
//        [_request setValue:token forHTTPHeaderField:@"Authorization"];
//        
//    }
    
    [self callWS:_request withSucessBlock:^(id result) {
        [self stopIndicator];
        SucessBlock(result);
    } withFailureBlock:^(id error) {
        [self stopIndicator];
        FailureBlock(error);
    }];
    
    
}

- (void) invokeHTTPRequestPUT : (NSString *)fullApiName : (NSMutableDictionary *)jsonDict : (BOOL)TokenEmbedded  :(NSString *)token withSucessBlock:(void (^)(id result))SucessBlock  withFailureBlock:(void (^)(NSError * error))FailureBlock
{
    [self startIndicator];
    NSError *error;
    NSURL *_url = [NSURL URLWithString:fullApiName];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];
    
    NSMutableURLRequest *_request = [NSMutableURLRequest requestWithURL:_url];
    [_request setTimeoutInterval:30];
    [_request setHTTPMethod:@"PUT"];
    [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:jsonData];
    
    if(TokenEmbedded == true)
    {
        [_request setValue:token forHTTPHeaderField:@"Authorization"];
        
    }
    
    [self callWS:_request withSucessBlock:^(id result) {
        [self stopIndicator];
        SucessBlock(result);
    } withFailureBlock:^(id error) {
        [self stopIndicator];
        FailureBlock(error);
    }];
    
    
}


- (void) invokeHTTPRequestDELETE : (NSString *)fullApiName : (NSMutableDictionary *)jsonDict : (BOOL)TokenEmbedded  :(NSString *)token withSucessBlock:(void (^)(id result))SucessBlock  withFailureBlock:(void (^)(NSError * error))FailureBlock
{
    [self startIndicator];
    NSError *error;
    NSURL *_url = [NSURL URLWithString:fullApiName];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDict
                                                       options:NSJSONWritingPrettyPrinted error:&error];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[jsonData length]];

    NSMutableURLRequest *_request = [NSMutableURLRequest requestWithURL:_url];
    [_request setTimeoutInterval:30];
    [_request setHTTPMethod:@"DELETE"];
    [_request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [_request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [_request setHTTPBody:jsonData];
    
    if(TokenEmbedded == true)
    {
        [_request setValue:token forHTTPHeaderField:@"Authorization"];
        
    }
    
    
    
    [self callWS:_request withSucessBlock:^(id result) {
        [self stopIndicator];
        SucessBlock(result);
    } withFailureBlock:^(id error) {
        [self stopIndicator];
        FailureBlock(error);
    }];
    
    
}




-(void) callWS : (NSMutableURLRequest *)request  withSucessBlock:(void (^)(id result))SucessBlock  withFailureBlock:(void (^)(NSError * error))FailureBlock
{

    if([self isInternetConnected])
    {
        
        //[SVProgressHUD showWithStatus:LoaderText];

        [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
          {
              // Block Body
              
              if(error == nil)
              {
                  if(data != nil)
                  {
                      
                      
                      
                      NSHTTPURLResponse *httpResponse =  (NSHTTPURLResponse *)response;
                      
                      if([httpResponse statusCode] == 200)
                      {
                          
                          id innerJson;
                          
                          @try {
                              innerJson = [NSJSONSerialization
                                           JSONObjectWithData:data options:kNilOptions error:&error];
                          } @catch (NSException *exception) {
                              NSLog(@"Result is kind like %@",exception.description);
                          } @finally {
                              
                          }
                          
                          
                          if(response != NULL)
                          {
                              SucessBlock(innerJson);
                          }
                          else if (error)
                          {
                              FailureBlock(error);
                          }
                      }
                      else
                      {
                          FailureBlock(error);
                      }
                  }
                  else
                  {
                      FailureBlock(error);
                      
                  }
              }
              else
              {
                  FailureBlock(error);
              }
          }] resume];
    }
    else
    {
        [self showErrorAlert:@"App Name" :@"No Internet Connection"];

    }
    
   }


-(BOOL) isInternetConnected {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    BOOL connected;
    BOOL isConnected;
    const char *host = "https://www.google.co.in/";
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host);
    SCNetworkReachabilityFlags flags;
    connected = SCNetworkReachabilityGetFlags(reachability, &flags);
    isConnected = NO;
    isConnected = connected && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
    CFRelease(reachability);
    return isConnected;
}

-(void)showErrorAlert : (NSString *)strMesg :(NSString *)appName
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AppName"
        message:strMesg
        preferredStyle:UIAlertControllerStyleAlert];

    
    UIAlertAction *actionOk = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:actionOk];

    [[[[UIApplication sharedApplication]keyWindow ]rootViewController] presentViewController:alertController animated:YES completion:nil];
    [[[UIApplication sharedApplication] keyWindow] makeKeyAndVisible];
    
}
    @end
