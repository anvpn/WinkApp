//
//  RootSignupViewController.m
//  Wink
//
//  Created by Apple on 19/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "RootSignupViewController.h"

@interface RootSignupViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,DatePickerViewControllerDelegate,ZWTTextboxToolbarHandlerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBG;



@property (nonatomic,strong) NSArray *arrPageTitles;
@property (nonatomic,strong) NSArray *arrPageImages;
@property (weak, nonatomic) IBOutlet UILabel *lblHeight;
@property (weak, nonatomic) IBOutlet UIButton *btnpswdEye;
@property (weak, nonatomic) IBOutlet UIImageView *imgvMale;
@property (weak, nonatomic) IBOutlet UIImageView *imagvFemale;

@property (weak, nonatomic) IBOutlet UIView *vwBackGround;
@property (weak, nonatomic) IBOutlet UIView *vwCreateAccount;
@property (weak, nonatomic) IBOutlet UIView *vwGeneralInformation;
@property (weak, nonatomic) IBOutlet UIView *vwPersonalDetail;
@property (weak, nonatomic) IBOutlet UIPageControl *pagecontrol;
@property (weak, nonatomic) IBOutlet UIButton *btnProfilePic;

@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtfCity;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtFJobProfile;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtfReligion;

@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtfFullName;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtDOB;
@property (weak, nonatomic) IBOutlet UIButton *btnNext;

@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtUserName;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtEmail;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtPswd;
@property (weak, nonatomic) IBOutlet UIButton *btnMale;
@property (weak, nonatomic) IBOutlet UIButton *btnFemale;
@property (weak, nonatomic) IBOutlet RPFloatingPlaceholderTextField *txtAge;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;

@property (strong, nonatomic) ZWTTextboxToolbarHandler *handler;
@property int index;
@property  int gender;

@property (strong, nonatomic) UIImage *selectedImage;
@property (strong, nonatomic) NSDate *selectedDate;
@property (strong, nonatomic) NSString *photoStr;
@property BOOL isAcceptedTerms;

@end

@implementation RootSignupViewController


@synthesize vwBackGround,index,vwCreateAccount,vwGeneralInformation,vwPersonalDetail,pagecontrol,btnProfilePic,txtfCity,txtFJobProfile,txtfReligion,txtfFullName,txtDOB,txtUserName,txtEmail,txtPswd,txtAge,selectedImage,selectedDate,photoStr,btnNext,gender,scrlvBG,handler,btnCheckBox,isAcceptedTerms;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    photoStr = @"";
    isAcceptedTerms = false;
    //[self setupSwipeGestureRecognizer];
    
    btnProfilePic.layer.cornerRadius = btnProfilePic.width /2;
    btnProfilePic.clipsToBounds = YES;

    btnNext.layer.borderWidth= 1;
    btnNext.layer.borderColor = [UIColor whiteColor].CGColor;
    btnNext.layer.cornerRadius = 3;
    btnNext.clipsToBounds = YES;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    gradient.frame = self.view.bounds;
//    gradient.colors = @[(id)[UIColor colorWithRed:157/255.0 green:98/255.0 blue:249/255.0 alpha:1.0].CGColor, (id)[UIColor whiteColor].CGColor, (id)[UIColor colorWithRed:157/255.0 green:98/255.0 blue:249/255.0 alpha:1.0].CGColor];
    gradient.colors = @[(id)[UIColor colorWithRed:118/255.0 green:36/255.0 blue:245/255.0 alpha:1.0].CGColor,(id)[UIColor colorWithRed:228/255.0 green:181/255.0 blue:252/255.0 alpha:1.0].CGColor, (id)[UIColor colorWithRed:143/255.0 green:75/255.0 blue:248/255.0 alpha:1.0].CGColor];
    [vwBackGround.layer insertSublayer:gradient atIndex:0];
    index = 0;
    [self prepareTextFields];
    gender = 0;
    vwBackGround.frame = self.view.bounds;
   // vwCreateAccount.layer.cornerRadius = 5;
    //vwCreateAccount.layer.masksToBounds = true;
    
    vwPersonalDetail.layer.cornerRadius = 5;
    vwPersonalDetail.layer.masksToBounds = true;

    vwGeneralInformation.layer.cornerRadius = 5;
    vwGeneralInformation.layer.masksToBounds = true;

    // Do any additional setup after loading the view.
}
-(void)prepareTextFields
{
    txtUserName.floatingLabelActiveTextColor = [UIColor colorWithRed:157/255.0 green:98/255.0 blue:249/255.0 alpha:1.0];
    txtUserName.floatingLabelInactiveTextColor = [UIColor darkGrayColor];
    txtUserName.textColor = [UIColor blackColor];
    txtUserName.placeholder = @"Username";
    txtUserName.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    txtEmail.floatingLabelActiveTextColor = [UIColor colorWithRed:157/255.0 green:98/255.0 blue:249/255.0 alpha:1.0];
    txtEmail.floatingLabelInactiveTextColor = [UIColor darkGrayColor];
    txtEmail.textColor = [UIColor blackColor];
    txtEmail.placeholder = @"Email";
    txtEmail.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    txtPswd.floatingLabelActiveTextColor = [UIColor colorWithRed:157/255.0 green:98/255.0 blue:249/255.0 alpha:1.0];
    txtPswd.floatingLabelInactiveTextColor = [UIColor darkGrayColor];
    txtPswd.textColor = [UIColor blackColor];
    txtPswd.placeholder = @"Password";
    txtPswd.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    txtfFullName.floatingLabelActiveTextColor = [UIColor colorWithRed:157/255.0 green:98/255.0 blue:249/255.0 alpha:1.0];
    txtfFullName.floatingLabelInactiveTextColor = [UIColor darkGrayColor];
    txtfFullName.textColor = [UIColor blackColor];
    txtfFullName.placeholder = @"Fullname";
    txtfFullName.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    txtDOB.floatingLabelActiveTextColor = [UIColor colorWithRed:157/255.0 green:98/255.0 blue:249/255.0 alpha:1.0];
    txtDOB.floatingLabelInactiveTextColor = [UIColor darkGrayColor];
    txtDOB.textColor = [UIColor blackColor];
    txtDOB.placeholder = @"dd/mm/yyyy";
    txtDOB.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    txtfCity.floatingLabelActiveTextColor = [UIColor colorWithRed:157/255.0 green:98/255.0 blue:249/255.0 alpha:1.0];
    txtfCity.floatingLabelInactiveTextColor = [UIColor darkGrayColor];
    txtfCity.textColor = [UIColor blackColor];
    txtfCity.placeholder = @"City";
    txtfCity.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    txtFJobProfile.floatingLabelActiveTextColor = [UIColor colorWithRed:157/255.0 green:98/255.0 blue:249/255.0 alpha:1.0];
    txtFJobProfile.floatingLabelInactiveTextColor = [UIColor darkGrayColor];
    txtFJobProfile.textColor = [UIColor blackColor];
    txtFJobProfile.placeholder = @"Job Profile";
    txtFJobProfile.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    
    txtfReligion.floatingLabelActiveTextColor = [UIColor colorWithRed:157/255.0 green:98/255.0 blue:249/255.0 alpha:1.0];
    txtfReligion.floatingLabelInactiveTextColor = [UIColor darkGrayColor];
    txtfReligion.textColor = [UIColor blackColor];
    txtfReligion.placeholder = @"Religion";
    txtfReligion.font = [UIFont fontWithName:@"Helvetica" size:18.f];
    if(_fbId != nil)
    {
        txtEmail.text = _email;
        txtfFullName.text = _firstname;
    }
    [scrlvBG setContentSize:CGSizeMake(vwCreateAccount.width, vwCreateAccount.height + 20)];
    
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:@[txtUserName,txtEmail,txtPswd] andScroll:scrlvBG];
    handler.delegate = self;
}
- (void) setupSwipeGestureRecognizer
{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    
    //swipeGesture.direction = (UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight);
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [vwBackGround addGestureRecognizer:swipeGesture];
    
    swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipedScreen:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [vwBackGround addGestureRecognizer:swipeGesture];

}
-(void)displayViewOfIndex
{
    if(index == 0)
    {
        vwCreateAccount.hidden = NO;
        
        [UIView transitionWithView:vwCreateAccount
                          duration:0.4
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            
                        } completion:^(BOOL finished)
                            {
                            vwPersonalDetail.hidden = YES;
                            vwGeneralInformation.hidden = YES;
                        }];
        [btnNext setTitle:@"NEXT" forState:UIControlStateNormal];
    }
    else if (index == 1)
    {
        //vwCreateAccount.hidden = YES;
        //vwPersonalDetail.hidden = NO;
        //vwGeneralInformation.hidden = YES;
        vwPersonalDetail.hidden = NO;
        vwGeneralInformation.hidden = YES;
        vwCreateAccount.hidden = YES;

        [UIView transitionWithView:vwPersonalDetail
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            
                        } completion:^(BOOL finished)
         {
             
             
         }];
        
        [btnNext setTitle:@"NEXT" forState:UIControlStateNormal];
        [scrlvBG setContentSize:CGSizeMake(vwPersonalDetail.width, vwPersonalDetail.height + 20)];
        
        handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:@[txtfFullName] andScroll:scrlvBG];
        handler.delegate = self;
        
    }
    else if (index == 2)
    {
        //vwCreateAccount.hidden = YES;
        //vwPersonalDetail.hidden = YES;
        //vwGeneralInformation.hidden = NO;
        vwPersonalDetail.hidden = YES;
        vwCreateAccount.hidden = YES;
         vwGeneralInformation.hidden = NO;
        [UIView transitionWithView:vwGeneralInformation
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromRight
                        animations:^{
                            
                        } completion:^(BOOL finished)
         {
             
         }];
        [scrlvBG setContentSize:CGSizeMake(vwGeneralInformation.width, vwGeneralInformation.height + 20)];
        
        handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:@[txtfCity,txtFJobProfile,txtfReligion] andScroll:scrlvBG];
        handler.delegate = self;

        [btnNext setTitle:@"SIGN UP" forState:UIControlStateNormal];
    }
    [pagecontrol setCurrentPage:index];
}
- (IBAction)valueChange:(id)sender
{
    NSLog(@"Value Changed");
}
- (IBAction)btnBackTap:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnChekBoxTap:(id)sender
{
    if(isAcceptedTerms)
    {
        [btnCheckBox setImage:[UIImage imageNamed:@"checkbox.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnCheckBox setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    isAcceptedTerms = !isAcceptedTerms;
}

- (void)swipedScreen:(UISwipeGestureRecognizer*)gesture
{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft)
    {
       if(index < 2)
       {
           index ++;
           [self displayViewOfIndex];
       }
        
    }
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight)
    {
        if(index > 0)
        {
            index --;
            [self displayViewOfIndex];
        }
        
    }
    
}
-(void)signup
{
    
    [SVProgressHUD show];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selectedDate];
    
    int year = (int)[components year] ;
    int month = (int)[components month];
    int day = (int)[components day];
    //gcm , fb id remaining
    if(_fbId == nil)
        _fbId = @"";
    
    NSDictionary *userInfo = @{
                               UKeyUserName : txtUserName.text,
                               UKeyPassword : txtPswd.text,
                               UKeyName     :txtfFullName.text,
                               UKeyClientId: @1,
                               UKeyEmail : txtEmail.text,
                               UKeySex : [NSNumber numberWithBool:gender],
                               UKeyYear : [NSNumber numberWithInt:year],
                               UKeyMonth : [NSNumber numberWithInt:month],
                               UKeyDay : [NSNumber numberWithInt:day],
                               @"photo" :photoStr,
                               @"location": txtfCity.text,
                               @"height": _lblHeight.text,
                               @"religion": txtfReligion.text,
                               @"adding_job" :txtFJobProfile.text,
                               @"facebookId" : _fbId? _fbId : @""
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
-(void)uploadPhoto
{
    [SVProgressHUD show];
    [WinkWebServiceAPI uploadPhoto:nil withImage:selectedImage completionHandler:^(WinkAPIResponse *response, NSDictionary *photo)
     {
         if(response.code == RCodeSuccess)
         {
             photoStr = photo[@"normalPhotoUrl"];
             [self signup];
         }
     }];
}
- (IBAction)btnProfilePicTap:(id)sender
{
    [self askForImage];
}
- (IBAction)btnTermsNConTap:(id)sender
{
    TermsNConditionViewController *tvc = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"TermsNConditionViewController"];
    
    [self presentViewController:tvc animated:YES completion:nil];
}
- (IBAction)btnSignUpTap:(id)sender
{
    if(index == 0)
    {
        if([self isValidAccountDetail])
        {
            index++;
            [self displayViewOfIndex];
        }
    }
    else if (index == 1)
    {
        if([self isvalidPersonalDetail])
        {
            index++;
            [self displayViewOfIndex];
        }
    }
    else if (index == 2)
    {
        if([self isValidGeneralDetail])
        {
            if(selectedImage != nil)
            {
                [self uploadPhoto];
            }
            else
            {
                [self signup];
            }
        }
    }
}
- (IBAction)btnHeightMinusTap:(id)sender
{
    float height = [_lblHeight.text floatValue];
    if(height > 3.0)
    {
        height= height - 0.1;
    }
    _lblHeight.text = [NSString stringWithFormat:@"%.01f",height];
}
- (IBAction)btnPlusMinusTap:(id)sender
{
    float height = [_lblHeight.text floatValue];
    if(height < 10.0)
    {
        height= height + 0.1;
    }
    _lblHeight.text = [NSString stringWithFormat:@"%.01f",height];
}
- (IBAction)btnPswdShowTap:(UIButton *)btn
{
    _btnpswdEye.selected = !_btnpswdEye.selected;
    if(_btnpswdEye.selected)
    {
        [_btnpswdEye setImage:[UIImage imageNamed:@"show.png"] forState:UIControlStateNormal];
        txtPswd.secureTextEntry = NO;
    }
    else
    {
        [_btnpswdEye setImage:[UIImage imageNamed:@"hide.png"] forState:UIControlStateNormal];
        txtPswd.secureTextEntry = YES;
    }
    
}
- (IBAction)btnGenderTap:(UIButton *)btn
{
    if(btn.tag != gender)
    {
        if(btn.tag == 0)
        {
            [_imgvMale setImage:[UIImage imageNamed:@"radiobutton-selected.png"]];
            [_imagvFemale setImage:[UIImage imageNamed:@"radiobutton.png"]];
            gender = 0;
        }
        else if (btn.tag == 1)
        {
            [_imagvFemale setImage:[UIImage imageNamed:@"radiobutton-selected.png"]];
            [_imgvMale setImage:[UIImage imageNamed:@"radiobutton.png"]];
            gender = 1;
        }
    }
}

-(BOOL)isValidAccountDetail
{
    ZWTValidationResult result;
    
    result = [txtUserName validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankUserName belowView:txtUserName];
        
        return NO;
    }
    else if (txtUserName.text.length  < 5)
    {
        [self showErrorMessage:WinkEnterMinChar belowView:txtUserName];
        
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

    
    result = [txtPswd validate:ZWTValidationTypePassword showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankPassword belowView:txtPswd];
        
        return NO;
    }
    else if([txtPswd.text rangeOfString:@" "].location != NSNotFound)
    {
        [self showErrorMessage:WinkPswdSpace belowView:txtPswd];
        
        return NO;
    }
    else if (![self isValidPassword:txtPswd.text])
    {
        [self showAlertWithMessage:WinkInvalidPswd];
        return NO;
    }
    return YES;
}
-(BOOL)isvalidPersonalDetail
{
    ZWTValidationResult result;
    
    result = [txtfFullName validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankFullName belowView:txtfFullName];
        
        return NO;
    }
    else if (selectedDate == nil)
    {
        [self showErrorMessage:WinkBlankDate belowView:txtDOB];
        return NO;
    }
    return YES;
}
-(BOOL)isValidGeneralDetail
{
    ZWTValidationResult result;
    
    result = [txtfCity validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:winkBlankCity belowView:txtfCity];
        
        return NO;
    }
    
    result = [txtFJobProfile validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankJobProfile belowView:txtFJobProfile];
        
        return NO;
    }
    
    result = [txtfReligion validate:ZWTValidationTypeBlank showRedRect:YES getFocus:YES];
    
    if (result == ZWTValidationResultBlank)
    {
        [self showErrorMessage:WinkBlankReligion belowView:txtfReligion];
        return NO;
    }
    
    if(!isAcceptedTerms)
    {
        [self showAlertWithMessage:@"Please read and agree to Terms & Policies"];
        return NO;
    }

    return YES;
}
-(BOOL)isValidPassword:(NSString *)checkString
{
    // NSString *stricterFilterString = @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}";
    //"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{8,}
    //NSString *stricterFilterString =  @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{6,}$$";
    
    NSString *stricterFilterString =  @"^(?=.*\\d)[a-zA-Z\\d]{6,}$$";
    
    NSPredicate *passwordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    BOOL ans =  [passwordTest evaluateWithObject:checkString];
    NSLog(@"%d",ans);
    return ans;
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
         [btnProfilePic setImage:selectedImage forState:UIControlStateNormal];
         //[self uploadPhoto];
         
     }];
}
#pragma mark - UITextfieldDelegate Method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField == txtDOB)
    {
        
        [handler endEditing];
        [textField resignFirstResponder];
        
        DatePickerViewController *picker = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"DatePickerViewController"];
        
        picker.delegate = self;
        
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        
        [picker setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self presentViewController:picker animated:NO completion:nil];
    }
    else
    {
        
    }
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self removeErrorMessageBelowView:textField];
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - DatePickerViewController delegate Method
-(void)selectedDate:(NSDate *)selectedDate1
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    selectedDate = selectedDate1;
    
    txtDOB.text = [formatter stringFromDate:selectedDate1];
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:selectedDate
                                       toDate:now
                                       options:0];
    NSInteger age = [ageComponents year];
    
    txtAge.text = [NSString stringWithFormat:@"%ld",(long)age];
}

@end
