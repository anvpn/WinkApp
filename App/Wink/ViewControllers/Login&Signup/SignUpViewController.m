//
//  SignUpViewController.m
//  Wink
//
//  Created by Apple on 15/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,DatePickerViewControllerDelegate,SettingOptionViewControllerDelegate,FBSDKLoginButtonDelegate,FBSDKGraphRequestConnectionDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *btnProfile;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBg;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtUsername;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtFullName;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtPassword;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtEmail;
@property (weak, nonatomic) IBOutlet UIButton *btnGender;
@property (weak, nonatomic) IBOutlet UIButton *btnDOB;
@property (strong, nonatomic) ZWTTextboxToolbarHandler *handler;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSString *photoStr;
@property  BOOL gender;

@end

@implementation SignUpViewController
@synthesize btnProfile,scrlvBg,txtUsername,txtFullName,txtPassword,txtEmail,btnGender,btnDOB,handler,selectedImage,datePicker,selectedDate,gender,photoStr;

- (void)viewDidLoad
{
    photoStr = @"";
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    [self prepareView];
    
}
-(void)prepareView
{
    if(WinkGlobalObject.screenSizeType == WinkScreenSizeType3_5)
    {
        [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, scrlvBg.y+ scrlvBg.height + 220)];
    }
    else if (WinkGlobalObject.screenSizeType == WinkScreenSizeType4)
    {
       [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, scrlvBg.y+ scrlvBg.height + 150)];
    }
    else if (WinkGlobalObject.screenSizeType == WinkScreenSizeType4_7)
    {
        [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, scrlvBg.y+ scrlvBg.height + 50)];
    }
    else if (WinkGlobalObject.screenSizeType == WinkScreenSizeType5_5)
    {
        [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, scrlvBg.y+ scrlvBg.height + 10)];
    }
    else
    {
        [scrlvBg setContentSize:CGSizeMake(scrlvBg.width, scrlvBg.y+ scrlvBg.height + 220)];
    }
    
    
    txtUsername.floatingLabelActiveTextColor = [UIColor whiteColor];
    txtUsername.floatingLabelInactiveTextColor = [UIColor blackColor];
    txtUsername.textColor = [UIColor whiteColor];
    txtUsername.placeholder = @"Username";
    txtUsername.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    txtFullName.floatingLabelActiveTextColor = [UIColor whiteColor];
    txtFullName.floatingLabelInactiveTextColor = [UIColor blackColor];
    txtFullName.textColor = [UIColor whiteColor];
    txtFullName.placeholder = @"Fullname";
    txtFullName.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    txtPassword.floatingLabelActiveTextColor = [UIColor whiteColor];
    txtPassword.floatingLabelInactiveTextColor = [UIColor blackColor];
    txtPassword.textColor = [UIColor whiteColor];
    txtPassword.placeholder = @"Password";
    txtPassword.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    txtEmail.floatingLabelActiveTextColor = [UIColor whiteColor];
    txtEmail.floatingLabelInactiveTextColor = [UIColor blackColor];
    txtEmail.textColor = [UIColor whiteColor];
    txtEmail.placeholder = @"Email";
    txtEmail.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    btnProfile.layer.cornerRadius = btnProfile.width /2;
    
    btnProfile.layer.borderColor = [UIColor whiteColor].CGColor;
    btnProfile.layer.borderWidth = 2.0;
    btnProfile.clipsToBounds = YES;
    
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:@[txtUsername,txtFullName,txtPassword,txtEmail] andScroll:scrlvBg];
    gender = 0;
    [btnGender setTitle:[NSString stringWithFormat:@"GENDER:%@",WinkGlobalObject.arrGender[gender]] forState:UIControlStateNormal];

}
-(BOOL)isValidData
{
    ZWTValidationResult result;
    
    result = [txtUsername validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankUserName belowView:txtUsername];
        
        return NO;
    }
    else if (txtUsername.text.length  < 5)
    {
        [self showErrorMessage:WinkEnterMinChar belowView:txtUsername];
        
        return NO;
    }
    
    result = [txtFullName validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankFullName belowView:txtFullName];
        
        return NO;
    }
    
    result = [txtPassword validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankPassword belowView:txtPassword];
        
        return NO;
    }
    else if([txtPassword.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:WinkPswdSpace belowView:txtPassword];
        
        return NO;
    }
    else if (![self isValidPassword:txtPassword.text])
    {
         [self showAlertWithMessage:WinkInvalidPswd];
        return NO;
    }
    result = [txtEmail validate:ZWTValidationTypeEmail showRedRect:YES getFocus:YES];
    
    if(result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankEmail belowView:txtEmail];
        return NO;
    }
    else if (result == ZWTValidationResultInvalid)
    {
        [self showErrorMessage:WinkInvalidMail belowView:txtEmail];
        return NO;
    }
    
    if(selectedDate == nil)
    {
        [self showAlertWithMessage:@"Please select birth date"];
        return NO;
    }
    
    return YES;
    
}
-(BOOL)isValidPassword:(NSString *)checkString
{
   // NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}";
    //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}
    NSString *stricterFilterString =  @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[A-Za-z\\d$@$!%*?&]";
   
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    BOOL ans =  [passwordTest evaluateWithObject:checkString];
    NSLog(@"%d",ans);
    return ans;
}
-(void)signup
{
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selectedDate];
    
    int year = (int)[components year] ;
    int month = (int)[components month];
    int day = (int)[components day];
    //gcm , fb id remaining
    
    NSDictionary *userInfo = @{
                               UKeyUserName : txtUsername.text,
                               UKeyPassword : txtPassword.text,
                               UKeyName     :txtFullName.text,
                               UKeyClientId: @1,
                               UKeyEmail : txtEmail.text,
                               UKeySex : [NSNumber numberWithBool:gender],
                               UKeyYear : [NSNumber numberWithInt:year],
                               UKeyMonth : [NSNumber numberWithInt:month],
                               UKeyDay : [NSNumber numberWithInt:day],
                               @"photo" :photoStr
                               //UKeyDeviceToken : WinkGlobalObject.deviceToken
                               };
    
    [WinkWebServiceAPI signUpWithImage:userInfo withImage:selectedImage completionHandler:^(WinkAPIResponse *response, WinkUser *user)
     {
         [SVProgressHUD dismiss];
         if(response.code == RCodeSuccess)
         {
             WinkGlobalObject.user = user;
             [WinkGlobalObject.user login];
             UINavigationController *sbvc = [WinkGlobalObject.storyboardMenubar instantiateInitialViewController];
             
             AppDelegate *delegate = (AppDelegate *) [UIApplication sharedApplication].delegate;
             
             delegate.window.rootViewController = sbvc;
             WinkGlobalObject.rootNavigationController = sbvc;
         }
         else if(response.message)
         {
             [self showAlertWithMessage:response.message];
         }
         else
         {
             [self showAlertWithMessage:response.error.localizedDescription];
         }

    }];
}
-(void)openSettingViewWithArray:(NSArray *)arrSettings andSelected:(int)selected WithTitle:(NSString *)labelTitle andButtonLAbel:(NSString *)lblButton
{
    SettingOptionViewController *svc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SettingOptionViewController"];
    svc.titleLable = labelTitle;
    svc.arrOptions = arrSettings;
    svc.selectedIndex = selected;
    svc.buttonLabel = lblButton;
    svc.delegate = self;
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [svc setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:svc animated:NO completion:nil];
    
}
#pragma mark - UIEvent Method
- (IBAction)btnDOBTap:(id)sender
{
    [self.view resignFirstResponder];
    
    DatePickerViewController *picker = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"DatePickerViewController"];
    
    picker.delegate = self;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [picker setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:picker animated:NO completion:nil];
}
- (IBAction)btnProfileTap:(id)sender
{
    [self askForImage];
}
- (IBAction)btnFbTap:(id)sender
{
    /*if ([FBSDKAccessToken currentAccessToken])
    {
        
        
    }*/
}
- (IBAction)btnGenderTap:(UIButton *)sender
{
     [self.view resignFirstResponder];
    [self openSettingViewWithArray:WinkGlobalObject.arrGender andSelected:gender WithTitle:@"Gender"andButtonLAbel:@"GENDER"];
}
- (IBAction)btnTermsTap:(id)sender
{
    TermsNConditionViewController *tvc = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"TermsNConditionViewController"];
    
    [self presentViewController:tvc animated:YES completion:nil];
    
}
- (IBAction)btnSignUpTap:(id)sender
{
    if([WinkUtil reachable])
    {
        if([self isValidData])
        {
            [SVProgressHUD show];
            [self uploadPhoto];
            //[self signup];
        }
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Uiimage selection method
-(void)askForImage
{
    [self.view endEditing:YES];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:AppName
                                                                         message:WinkAskImageSource
                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *takePhoto = [UIAlertAction actionWithTitle:WinkTextFromCamera
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectProfileImageFrom:UIImagePickerControllerSourceTypeCamera];
                                }];
    
    UIAlertAction *fromAlbum = [UIAlertAction actionWithTitle:WinkTextFromLibrary
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    [self selectProfileImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
                                }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:WinkTextCancel
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action)
                             {
                                 [actionSheet dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [actionSheet addAction:takePhoto];
    [actionSheet addAction:fromAlbum];
    [actionSheet addAction:cancel];
    [self presentViewController:actionSheet animated:YES completion:nil];
}
- (void)selectProfileImageFrom:(UIImagePickerControllerSourceType)sourceType
{
    if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary || sourceType == UIImagePickerControllerSourceTypeSavedPhotosAlbum)
    {
        PHAuthorizationStatus photoStatus = [PHPhotoLibrary authorizationStatus];
        
        BOOL isAuthorizedLibrary = NO;
        
        if (photoStatus == PHAuthorizationStatusAuthorized)
        {
            // Access has been granted.
            isAuthorizedLibrary = YES;
            [self openImagePicker:sourceType];
        }
        else if (photoStatus == PHAuthorizationStatusDenied)
        {
            // Access has been denied.
        }
        else if (photoStatus == PHAuthorizationStatusNotDetermined)
        {
            // Access has not been determined.
        }
        else if (photoStatus == PHAuthorizationStatusRestricted)
        {
            // Restricted access - normally won't happen.
        }
        
        if (isAuthorizedLibrary == NO)
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus Authstatus)
             {
                 if (Authstatus == PHAuthorizationStatusAuthorized)
                 {
                     [self openImagePicker:sourceType];
                 }
                 else
                 {
                     [self showAlertWithMessage:WinkAllowAccessPhotoLibrary];
                 }
             }];
        }
        
    }
    else if (sourceType == UIImagePickerControllerSourceTypeCamera)
    {
        
        BOOL isAuthorizedCamera = NO;
        
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        if(authStatus == AVAuthorizationStatusAuthorized)
        {
            isAuthorizedCamera = YES;
            [self openImagePicker:sourceType];
        }
        else if(authStatus == AVAuthorizationStatusDenied)
        {
            // denied
        }
        else if(authStatus == AVAuthorizationStatusRestricted)
        {
            // restricted, normally won't happen
        }
        else if(authStatus == AVAuthorizationStatusNotDetermined)
        {
            // not determined?!
        }
        else
        {
            // impossible, unknown authorization status
        }
        
        if (isAuthorizedCamera == NO)
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted)
             {
                 if(granted)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        [self openImagePicker:sourceType];
                                    });
                 }
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^
                                    {
                                        [self showAlertWithMessage:WinkAllowAccessCamera];
                                    });
                 }
             }];
        }
    }
    else
    {
        NSAssert(NO, @"Permission type not found");
    }
}
-(void)openImagePicker:(UIImagePickerControllerSourceType)sourceType
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setAllowsEditing:YES];
    imagePicker.delegate      = self;
    imagePicker.allowsEditing = YES;
    imagePicker.sourceType    = sourceType;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         UIImage *selectedImg = info[UIImagePickerControllerEditedImage];
         selectedImage = selectedImg;
         [btnProfile setImage:selectedImage forState:UIControlStateNormal];
         //[self uploadPhoto];
         
     }];
}
-(void)uploadPhoto
{
    
    [WinkWebServiceAPI uploadPhoto:nil withImage:selectedImage completionHandler:^(WinkAPIResponse *response, NSDictionary *photo)
    {
        if(response.code == RCodeSuccess)
        {
            photoStr = photo[@"normalPhotoUrl"];
            [self signup];
        }
    }];
}
#pragma mark - DatePickerViewController delegate Method
-(void)selectedDate:(NSDate *)selectedDate1
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    selectedDate = selectedDate1;
    [btnDOB setTitle:[NSString stringWithFormat:@"DATE OF BIRTH: %@",[formatter stringFromDate:selectedDate1]] forState:UIControlStateNormal];
}
-(void)selectedOption:(int)selectedId ofArray:(NSArray *)arrOptions andLabel:(NSString *)Label
{
    gender = (BOOL)selectedId;
    [btnGender setTitle:[NSString stringWithFormat:@"GENDER:%@",arrOptions[selectedId]] forState:UIControlStateNormal];
}

#pragma mark - FBSDKLogin Button delegate
-(void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error
{
    //["fields": "id, name, first_name, last_name, picture.type(large), email"]
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name,first_name,id,last_name"}]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
     {
         if (!error)
         {
             NSLog(@"fetched user:%@", result);
             NSLog(@"%@",result[@"email"]);
             
         }
     }];

}
-(void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton
{
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self removeErrorMessageBelowView:textField];
}
@end
