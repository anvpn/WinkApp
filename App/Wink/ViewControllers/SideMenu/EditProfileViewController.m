//
//  EditProfileViewController.m
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "EditProfileViewController.h"
#import "CCTextFieldEffects.h"

@interface EditProfileViewController () <DatePickerViewControllerDelegate,SettingOptionViewControllerDelegate>
{
    NSInteger Age;
    NSString *AgeCount;
    float Height;
    BOOL ShowDOB;
}
//@property (weak, nonatomic) IBOutlet UITextField *txtFullName;
@property (weak, nonatomic) IBOutlet HoshiTextField *txtFullName;

//@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet HoshiTextField *txtLocation;

//@property (weak, nonatomic) IBOutlet UITextField *txtFBPage;
@property (weak, nonatomic) IBOutlet HoshiTextField *txtFBPage;

//@property (weak, nonatomic) IBOutlet UITextField *txtInstaPage;
@property (weak, nonatomic) IBOutlet HoshiTextField *txtInstaPage;

//@property (weak, nonatomic) IBOutlet UITextField *txtStatus;
@property (weak, nonatomic) IBOutlet HoshiTextField *txtStatus;
@property (weak, nonatomic) IBOutlet HoshiTextField *txtJobprofile;
@property (weak, nonatomic) IBOutlet HoshiTextField *txtReligion;
@property (weak, nonatomic) IBOutlet UIImageView *img_Dob;

@property (weak, nonatomic) IBOutlet UILabel *lbl_Height;

@property (weak, nonatomic) IBOutlet UIButton *btnGender;
@property (weak, nonatomic) IBOutlet UIButton *btnDOB;
@property (weak, nonatomic) IBOutlet UIButton *btnRstatus;
@property (weak, nonatomic) IBOutlet UIButton *btnEmployment;
@property (weak, nonatomic) IBOutlet UIButton *btnWorldView;
@property (weak, nonatomic) IBOutlet UIButton *btnPersonalPriority;
@property (weak, nonatomic) IBOutlet UIButton *btnImportantInOther;
@property (weak, nonatomic) IBOutlet UIButton *btnSmoking;
@property (weak, nonatomic) IBOutlet UIButton *btnAlcohol;
@property (weak, nonatomic) IBOutlet UIButton *btnLookingFor;

@property (weak, nonatomic) IBOutlet UIButton *btnGenderYouLike;
@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBG;
@property (strong, nonatomic) UIButton *selectedButton;
@property int byear;
@property int bMonth;
@property int bDay;

@property ZWTTextboxToolbarHandler *handler;

@end

@implementation EditProfileViewController
@synthesize txtFullName,txtLocation,txtFBPage,txtInstaPage,txtStatus,btnGender,btnDOB,btnRstatus,btnEmployment,btnWorldView,btnPersonalPriority,btnImportantInOther,btnSmoking,btnAlcohol,btnLookingFor,btnGenderYouLike,scrlvBG,user,handler;
@synthesize byear,bMonth,bDay;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    Height=3.0;
    _lbl_Height.text= [NSString stringWithFormat:@"%.1f",Height];
    [self prepareView];
}
-(void)prepareView

{
    ShowDOB = user.isAllowBirthday;
    
    if (ShowDOB == 1)
    {
        _img_Dob.image= [UIImage imageNamed:@"checked.png"];
    }
    else
    {
        _img_Dob.image= [UIImage imageNamed:@"checkbox.png"];
    }
    
    txtFullName.text = user.name;
    txtLocation.text = user.location;
    txtFBPage.text = user.fb_page;
    txtInstaPage.text = user.insta_page;
    txtStatus.text = user.fStatus;
    _txtJobprofile.text = user.adding_job;
    _txtReligion.text = user.religion;
    
    Height = [user.height floatValue];
    _lbl_Height.text = [NSString stringWithFormat:@"%.1f",Height];
    [btnGender setTitle:[NSString stringWithFormat:@"%@:%@",btnGender.titleLabel.text,WinkGlobalObject.arrGender[user.gender]] forState:UIControlStateNormal];
    btnGender.tag = user.gender;
    
    
    [btnDOB setTitle:[NSString stringWithFormat:@"%@:%d/%d/%d",btnDOB.titleLabel.text,user.bDay,user.bMonth,user.bYear] forState:UIControlStateNormal];
    byear = user.bYear;
    bMonth = user.bMonth;
    bDay = user.bDay;
    
    
    [btnRstatus setTitle:[NSString stringWithFormat:@"%@:%@",btnRstatus.titleLabel.text,WinkGlobalObject.arrRstatus[user.rStatus]] forState:UIControlStateNormal];
    btnRstatus.tag = user.rStatus;
    
    
    [btnEmployment setTitle:[NSString stringWithFormat:@"%@:%@",btnEmployment.titleLabel.text,WinkGlobalObject.arrTypeOfEmployment[user.politicalView]] forState:UIControlStateNormal];
    btnEmployment.tag = user.politicalView;
    
    
    [btnWorldView setTitle:[NSString stringWithFormat:@"%@:%@",btnWorldView.titleLabel.text,WinkGlobalObject.arrWorldView[user.worldView]] forState:UIControlStateNormal];
    btnWorldView.tag = user.worldView;
    
    
    [btnPersonalPriority setTitle:[NSString stringWithFormat:@"%@:%@",btnPersonalPriority.titleLabel.text,WinkGlobalObject.arrPersonalPrio[user.personalView]] forState:UIControlStateNormal];
    btnPersonalPriority.tag = user.personalView;
    
    
    [btnImportantInOther setTitle:[NSString stringWithFormat:@"%@:%@",btnImportantInOther.titleLabel.text,WinkGlobalObject.arrImportantInOther[user.importantInOthers]] forState:UIControlStateNormal];
    btnImportantInOther.tag = user.importantInOthers;
    
    [btnSmoking setTitle:[NSString stringWithFormat:@"%@:%@",btnSmoking.titleLabel.text,WinkGlobalObject.arrViewOnSmoking[user.smokingViews]] forState:UIControlStateNormal];
    btnSmoking.tag = user.smokingViews;
    
    [btnAlcohol setTitle:[NSString stringWithFormat:@"%@:%@",btnAlcohol.titleLabel.text,WinkGlobalObject.arrViewOnAlcohol[user.alcoholView]] forState:UIControlStateNormal];
    btnAlcohol.tag = user.alcoholView;
    
    
    [btnLookingFor setTitle:[NSString stringWithFormat:@"%@:%@",btnLookingFor.titleLabel.text,WinkGlobalObject.arrLookingFor[user.lookingFor]] forState:UIControlStateNormal];
    btnLookingFor.tag = user.lookingFor;
    
    
    [btnGenderYouLike setTitle:[NSString stringWithFormat:@"%@:%@",btnGenderYouLike.titleLabel.text,WinkGlobalObject.arrInterestedIn[user.interested]] forState:UIControlStateNormal];
    btnGenderYouLike.tag = user.interested;
    
    
    [scrlvBG setContentSize:CGSizeMake(scrlvBG.width, 1000)];
    
    AgeCount = [NSString stringWithFormat:@"%@",user.age];
    
    handler = [[ZWTTextboxToolbarHandler alloc]initWithTextboxs:@[txtFullName,txtLocation,txtFBPage,txtInstaPage,txtStatus,_txtJobprofile,_txtReligion,] andScroll:scrlvBG];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnSaveTap:(id)sender
{
    //accountId,accessToken,fullname,location,facebookPage,instagramPage,bio,sex,year,month,day,iStatus,politicalViews,worldViews,personalPriority,importantInOthers,smokingViews,alcoholViews,lookingViews,interestedViews,allowShowMyBirthday.
    //accountId,accessToken,fullname,location,facebookPage,instagramPage,bio,sex,year,month,day,iStatus,politicalViews,worldViews,personalPriority,importantInOthers,smokingViews,alcoholViews,lookingViews,interestedViews,allowShowMyBirthday.
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               UKeyName : txtFullName.text,
                               UKeyLocation : txtLocation.text,
                               @"facebookPage" : txtFBPage.text,
                               @"instagramPage" : txtInstaPage.text,
                               @"bio" : txtStatus.text,
                               @"adding_job" : _txtJobprofile.text,
                               @"height" : _lbl_Height.text,
                               @"age" : AgeCount,
                               UKeySex : [NSNumber numberWithInteger:btnGender.tag],
                               UKeyYear : [NSNumber numberWithInt:byear],
                               UKeyMonth : [NSNumber numberWithInt:bMonth],
                               UKeyDay : [NSNumber numberWithInt:bDay],
                               @"iStatus" : [NSNumber numberWithInteger:btnRstatus.tag],
                               @"worldViews" : [NSNumber numberWithInteger:btnWorldView.tag],
                               @"personalPriority" : [NSNumber numberWithInteger:btnPersonalPriority.tag],
                               @"politicalViews" : [NSNumber numberWithInteger:btnEmployment.tag],
                               @"importantInOthers" : [NSNumber numberWithInteger:btnImportantInOther.tag],
                               @"smokingViews" : [NSNumber numberWithInteger:btnSmoking.tag],
                               @"alcoholViews" : [NSNumber numberWithInteger:btnAlcohol.tag],
                               @"lookingViews" : [NSNumber numberWithInteger:btnLookingFor.tag],
                               @"interestedViews" : [NSNumber numberWithInteger:btnGenderYouLike.tag],
                               @"allowShowMyBirthday" :[NSNumber numberWithBool:ShowDOB]
                               };
        NSLog(@"dict:-%@",dict);
        [WinkWebServiceAPI updateProfile:dict completionHandler:^(WinkAPIResponse *response)
         {
             [SVProgressHUD dismiss];
             if(response.code == RCodeSuccess)
             {
                 [self showAlertWithMessage:@"Profile updated successfully" andHandler:^(UIAlertAction * _Nullable action)
                 {
                     [self dismissViewControllerAnimated:YES completion:nil];
                 }];
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
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
    
    
    
}

- (IBAction)btnGenderTap:(id)sender
{
    _selectedButton = btnGender;
    
    [self openSettingViewWithArray:WinkGlobalObject.arrGender andSelected:(int)_selectedButton.tag WithTitle:@"Gender"andButtonLAbel:@"GENDER"];
}
- (IBAction)btnDOBTap:(id)sender
{
    DatePickerViewController *picker = [WinkGlobalObject.storyboardLoginSignup instantiateViewControllerWithIdentifier:@"DatePickerViewController"];
    picker.delegate = self;
    
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    
    [picker setModalPresentationStyle:UIModalPresentationOverFullScreen];
    
    [self setModalPresentationStyle:UIModalPresentationCurrentContext];
    [self presentViewController:picker animated:NO completion:nil];
}
- (IBAction)btnRStatusTap:(id)sender
{
    _selectedButton = btnRstatus;
    [self openSettingViewWithArray:WinkGlobalObject.arrRstatus andSelected:(int)_selectedButton.tag WithTitle:@"Relationship Status"andButtonLAbel:@"RELATIONSHIP STATUS"];
}
- (IBAction)btnTypeOfEmploymentTap:(id)sender
{
    _selectedButton = btnEmployment;
    [self openSettingViewWithArray:WinkGlobalObject.arrTypeOfEmployment andSelected:(int)_selectedButton.tag WithTitle:@"Type of Employment"andButtonLAbel:@"TYPE OF EMPLOYMENT"];
}
- (IBAction)btnWorldViewTap:(id)sender
{
    _selectedButton = btnWorldView;
    [self openSettingViewWithArray:WinkGlobalObject.arrWorldView andSelected:(int)_selectedButton.tag WithTitle:@"World View"andButtonLAbel:@"WORLD VIEW"];
}
- (IBAction)btnPersonalPriorityTap:(id)sender
{
    _selectedButton = btnPersonalPriority;
    [self openSettingViewWithArray:WinkGlobalObject.arrPersonalPrio andSelected:(int)_selectedButton.tag WithTitle:@"Personal Priority"andButtonLAbel:@"PERSONAL PRIORITY"];
}
- (IBAction)btnImportantInOther:(id)sender
{
    _selectedButton = btnImportantInOther;
    [self openSettingViewWithArray:WinkGlobalObject.arrImportantInOther andSelected:(int)_selectedButton.tag WithTitle:@"Important in Others"andButtonLAbel:@"IMPORTANT IN OTHERS"];
}
- (IBAction)btnSmokingViewTap:(id)sender
{
    _selectedButton = btnSmoking;
    [self openSettingViewWithArray:WinkGlobalObject.arrViewOnSmoking andSelected:(int)_selectedButton.tag WithTitle:@"Views on smoking"andButtonLAbel:@"VIEWS ON SMOKING"];
}
- (IBAction)btnAlcoholViewTap:(id)sender
{
    _selectedButton = btnAlcohol;
    [self openSettingViewWithArray:WinkGlobalObject.arrViewOnAlcohol andSelected:(int)_selectedButton.tag WithTitle:@"Views on alcohol"andButtonLAbel:@"VIEWS ON ALCOHOL"];
}
- (IBAction)btnLookingForTap:(id)sender
{
    _selectedButton = btnLookingFor;
    [self openSettingViewWithArray:WinkGlobalObject.arrLookingFor andSelected:(int)_selectedButton.tag WithTitle:@"What are you looking for?"andButtonLAbel:@"YOU LOOKING FOR"];
}
- (IBAction)btnGenderLikeTap:(id)sender
{
    _selectedButton = btnGenderYouLike;
    [self openSettingViewWithArray:WinkGlobalObject.arrInterestedIn andSelected:(int)_selectedButton.tag WithTitle:@"Which gender do you like?"andButtonLAbel:@"GENDER DO YOU LIKE"];
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
#pragma mark - Delegate Method
-(void)selectedDate:(NSDate *)selectedDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:selectedDate];
    
    byear = (int)[components year] ;
    bMonth = (int)[components month];
    bDay = (int)[components day];
    
    [btnDOB setTitle:[NSString stringWithFormat:@"DATE OF BIRTH: %@",[formatter stringFromDate:selectedDate]] forState:UIControlStateNormal];
    
    
    NSDate* now = [NSDate date];
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                       components:NSCalendarUnitYear
                                       fromDate:selectedDate
                                       toDate:now
                                       options:0];
    Age = [ageComponents year];
    AgeCount = [NSString stringWithFormat:@"%ld",(long)Age];
    NSLog(@"%ld",(long)Age);
}
-(void)selectedOption:(int)selectedId ofArray:(NSArray *)arrOptions andLabel:(NSString *)Label
{
    
    _selectedButton.tag = selectedId;
    [_selectedButton setTitle:[NSString stringWithFormat:@"%@:%@",Label,arrOptions[selectedId]]forState:UIControlStateNormal];
}

- (IBAction)btn_plus:(id)sender
{
    if (!(Height > 10))
    {
        Height=Height+0.1;
        _lbl_Height.text= [NSString stringWithFormat:@"%.1f",Height];
    }
}
- (IBAction)btn_minus:(id)sender
{
    if (!(Height <= 3))
    {
        Height=Height-0.1;
        _lbl_Height.text= [NSString stringWithFormat:@"%.1f",Height];
    }
}
- (IBAction)btn_showDOB:(id)sender
{
    if (ShowDOB == 1)
    {
        //checkbox.png
        _img_Dob.image= [UIImage imageNamed:@"checkbox.png"];
        ShowDOB=0;
    }
    else
    {
        ShowDOB=1;
        _img_Dob.image= [UIImage imageNamed:@"checked.png"];
    }
}

@end
