//
//  GallaryIteamViewController.m
//  Wink
//
//  Created by Apple on 04/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "GallaryIteamViewController.h"

@interface GallaryIteamViewController ()<UITableViewDelegate,UITableViewDataSource,AGEmojiKeyboardViewDelegate,AGEmojiKeyboardViewDataSource,UITextFieldDelegate,SettingOptionViewControllerDelegate>
{
    int UID;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrlvBG;
@property (weak, nonatomic) IBOutlet UIView *vwProfile;
@property (weak, nonatomic) IBOutlet UIView *vwGImage;
@property (weak, nonatomic) IBOutlet UIView *vwComment;
@property (weak, nonatomic) IBOutlet UIView *vwLike;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;

@property (weak, nonatomic) IBOutlet UIView *vwTextInput;
@property (weak, nonatomic) IBOutlet UIImageView *imgvProfilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeAgo;
@property (weak, nonatomic) IBOutlet UILabel *lblPhotoComment;
@property (weak, nonatomic) IBOutlet UIImageView *imgvGallaryPhoto;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet UITableView *tblvComment;
@property (weak, nonatomic) IBOutlet UIButton *btnGallaryImage;
@property (weak, nonatomic) IBOutlet UITextField *txtComment;
@property (weak, nonatomic) IBOutlet UIButton *btnEmoji;

@property BOOL isEmojiView;
@property BOOL isvideo;



@property (strong, nonatomic) NSMutableArray *arrComments;

@end

@implementation GallaryIteamViewController
@synthesize scrlvBG,vwProfile,vwGImage,vwComment,vwTextInput,imgvProfilePhoto,lblName,lblUserName,lblTimeAgo,lblPhotoComment,imgvGallaryPhoto,tblvComment,selectedPhoto,btnGallaryImage,isEmojiView,btnEmoji,likeCount,btnLike;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _isvideo=false;
    
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    //[self prepareView];
    [self getCommentList];
    _arrComments = [[NSMutableArray alloc]init];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //ana
    if(selectedPhoto != nil)
    [self setupUserData:nil];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - Keyboard appearance/disappearance handling

- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
    [scrlvBG setContentInset:contentInsets];
    [scrlvBG setScrollIndicatorInsets:contentInsets];
    
    CGRect messageFrame = vwTextInput.frame;
    messageFrame.origin.y -= keyboardSize.height;
    [vwTextInput setFrame:messageFrame];
}
- (void)keyboardWillDisappear:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [scrlvBG setContentInset:UIEdgeInsetsZero];
    [UIView commitAnimations];
    [scrlvBG setScrollIndicatorInsets:UIEdgeInsetsZero];
    
    CGRect messageFrame = vwTextInput.frame;
    messageFrame.origin.y += keyboardSize.height;
    [vwTextInput setFrame:messageFrame];
}

-(void)prepareView
{
//    if (selectedPhoto.isUserVerify)
//    {
//        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
//        attachment.image = [UIImage imageNamed:@"profile_verify_icon.png"];
//        
//        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
//        //NSString *Name = selectedPhoto.fullName;
//        NSString *Name = [NSString stringWithFormat:@"%@ ",selectedPhoto.fullName];
//        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
//        [myString appendAttributedString:attachmentString];
//        lblName.attributedText  = myString;
//    }
//    else
//    {
//        lblName.text = selectedPhoto.fullName;
//    }
    //lblName.text = selectedPhoto.fullName;
    lblUserName.text = [NSString stringWithFormat:@"@%@",selectedPhoto.userName];
    //lblUserName.text = selectedPhoto.userName;
    lblTimeAgo.text = selectedPhoto.timeAgo;
    
    imgvProfilePhoto.layer.cornerRadius = imgvProfilePhoto.width / 2;
    imgvProfilePhoto.layer.masksToBounds = YES;
    
    [imgvProfilePhoto setImageWithURL:selectedPhoto.userPhotoURL placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
    
    
   // lblPhotoComment.text = selectedPhoto.comment;
    lblPhotoComment.text = [self decodeEmojis:selectedPhoto.comment];
    lblPhotoComment.numberOfLines = 0;
    [lblPhotoComment sizeToFit];
    isEmojiView = NO;
    
    if([selectedPhoto.userId isEqualToString:WinkGlobalObject.user.ID])
    {
        [_btnReport setTitle:@"Delete" forState:UIControlStateNormal];
        [_btnReport setImage:[UIImage imageNamed:@"img_del.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_btnReport setTitle:@"Report" forState:UIControlStateNormal];
        [_btnReport setImage:[UIImage imageNamed:@"img_reports.png"] forState:UIControlStateNormal];
    }
    [imgvGallaryPhoto setImageWithURL:selectedPhoto.gallaryNormalPhotoURL];
    
    if(selectedPhoto.isVideo)
    {
        [btnGallaryImage setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnGallaryImage setImage:nil forState:UIControlStateNormal];
    }
    
    int likecount = [selectedPhoto.likesCount intValue];
    
    [self setLikesView:likecount andIsMyLike:selectedPhoto.isMyLike];
    
    int commentCount = [selectedPhoto.commentCount intValue];
    
    if(commentCount > 0)
    {
        
    }
    [self getCommentList];
  //  [btnGallaryImage setImageForState:UIControlStateNormal withURL:selectedPhoto.gallaryOriginPhotoURL];
    
    if(selectedPhoto.isAllowComment)
    {
        vwTextInput.hidden = NO;
    }
    else
    {
        vwTextInput.hidden = YES;
    }
}
-(void)setLikesView:(int)ilikeCount andIsMyLike:(BOOL)isMyLike
{
    if(ilikeCount > 0)
    {
        likeCount.text = [NSString stringWithFormat:@"%d",ilikeCount];
        likeCount.hidden = NO;
    }
    else
    {
        likeCount.hidden = YES;
    }
    if(isMyLike)
    {
        [btnLike setImage:[UIImage imageNamed:@"perk_active.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnLike setImage:[UIImage imageNamed:@"perk.png"] forState:UIControlStateNormal];
    }
}
-(void)setFrames
{
    btnGallaryImage.y = lblPhotoComment.y + lblPhotoComment.height + 5;
    vwGImage.frame = CGRectMake(vwGImage.x, vwGImage.y, vwGImage.width, btnGallaryImage.y + btnGallaryImage.height);
    
    tblvComment.height = tblvComment.contentSize.height;
    
    vwComment.frame = CGRectMake(vwComment.x, _vwLike.y + _vwLike.height, vwComment.width, tblvComment.contentSize.height + 10);
    
    [scrlvBG setContentSize:CGSizeMake(scrlvBG.width, vwComment.y+ vwComment.height)];
}
-(void)getCommentList
{
    [SVProgressHUD show];
    if([WinkUtil reachable])
    {
        if(_ItemId == nil)
        {
            if(selectedPhoto != nil)
            {
                _ItemId = selectedPhoto.photoId;
            }
        }
        
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"itemId" : _ItemId
                               };
        [SVProgressHUD show];
        [WinkWebServiceAPI getPhotoDetail:dict completionHandler:^(WinkAPIResponse *response, NSMutableArray *comment,NSMutableArray *Data)
        {
            [SVProgressHUD dismiss];
            if (Data.count > 0)
            {
            dispatch_async(dispatch_get_main_queue(), ^{
                    [self setupUserData:Data];
            });
                
            }
            //NSString *Url = [dict1 valueForKey:@"gallaryNormalPhotoURL"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{

            
            if(comment.count > 0)
            {
                _arrComments = comment.mutableCopy;
                [tblvComment reloadData];
                [self setFrames];
            }
            else if(response.message)
            {
                [self showAlertWithMessage:response.message];
                [self setFrames];
            }
            else
            {
                [self showAlertWithMessage:response.error.localizedDescription];
                [self setFrames];
            }
            });
        }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}

//ana: refactor code
-(void)setupUserData : (NSMutableArray *) Data
{
    BOOL IsUserverify = false,isMyLike,isCommentAllow;
    NSURL *videoURL,*imgURL,*gallaryNormalPhotoURL;
    NSString * fullname,*userName,*timeAgo,*imgUrl;
    int commentCount = 0;
    if(selectedPhoto != nil)
    {
        IsUserverify = selectedPhoto.isUserVerify;
        PhotoId = selectedPhoto.photoId;
        fullname = selectedPhoto.fullName;
        _isvideo = selectedPhoto.isVideo;
        videoURL = selectedPhoto.gallaryVideoURL;
        Videourl = videoURL.absoluteString;
        UID = [selectedPhoto.userId intValue];
        userName = selectedPhoto.userName;
        gallaryNormalPhotoURL = selectedPhoto.gallaryNormalPhotoURL;
        isMyLike = selectedPhoto.isMyLike;
        isCommentAllow = selectedPhoto.isAllowComment;
        commentCount = [selectedPhoto.commentCount intValue];
        NSString *s;
        if (selectedPhoto.isAccessMode)
        {
            s=@"Friends";
        }
        else
        {
            s=@"Public";
        }
        
        timeAgo = [NSString stringWithFormat:@"%@ - %@",selectedPhoto.timeAgo,s];
        imgURL = selectedPhoto.userPhotoURL;
        
    }
    else
    {
        NSMutableDictionary *dict1 = [Data objectAtIndex:0];
        IsUserverify = [[dict1 valueForKey:@"isUserVerify"]boolValue];
        PhotoId = [dict1 valueForKey:@"photoId"];
        fullname = [dict1 valueForKey:@"fullName"];
        _isvideo = [[dict1 valueForKey:@"isVideo"]boolValue];
        Videourl = [dict1 valueForKey:@"gallaryVideoURL"];
        UID = [[dict1 valueForKey:@"userId"]integerValue];
        
        
        
        lblPhotoComment.text = [self decodeEmojis:[dict1 valueForKey:@"comment"]];
        lblPhotoComment.numberOfLines = 5;
        //[lblPhotoComment sizeToFit];
        isEmojiView = NO;
        
        if([[dict1 valueForKey:@"userId"] isEqualToString:WinkGlobalObject.user.ID])
        {
            [_btnReport setTitle:@"Delete" forState:UIControlStateNormal];
            [_btnReport setImage:[UIImage imageNamed:@"img_del.png"] forState:UIControlStateNormal];
        }
        else
        {
            [_btnReport setTitle:@"Report" forState:UIControlStateNormal];
            //[_btnReport setImage:[UIImage imageNamed:@"img_reports.png"] forState:UIControlStateNormal];
            [_btnReport setImage:[UIImage imageNamed:@"img_reportnew.png"] forState:UIControlStateNormal];
        }
        
        userName = [dict1 valueForKey:@"userName"];
        timeAgo = [dict1 valueForKey:@"timeAgo"];
        imgURL = [dict1 valueForKey:@"userPhotoURL"];
        gallaryNormalPhotoURL = [dict1 valueForKey:@"gallaryNormalPhotoURL"];
        _isvideo = [[dict1 valueForKey:@"isVideo"]boolValue];
        
        commentCount =  [[dict1 valueForKey:@"likesCount"] intValue];
        isMyLike = [[dict1 valueForKey:@"isMyLike"]boolValue];
        
        
        isCommentAllow = [[dict1 valueForKey:@"isAllowComment"]boolValue];    }
    
    if (IsUserverify)
    {
        NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
        attachment.image = [UIImage imageNamed:@"profile_verify_icon.png"];
        
        NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
        NSString *Name = [NSString stringWithFormat:@"%@ ",fullname];
        NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:Name];
        [myString appendAttributedString:attachmentString];
        lblName.attributedText  = myString;
    }
    else
    {
        lblName.text = fullname;
    }
    
    
    lblUserName.text = userName;
    lblTimeAgo.text = timeAgo;
    imgvProfilePhoto.layer.cornerRadius = imgvProfilePhoto.width / 2;
    imgvProfilePhoto.layer.masksToBounds = YES;
    [imgvProfilePhoto setImageWithURL:imgURL placeholderImage:[UIImage imageNamed:@"profile_default_photo.png"]];
    
    
    [imgvGallaryPhoto setImageWithURL:gallaryNormalPhotoURL];
    
    BOOL IsVideo = _isvideo ;
    
    if(IsVideo)
    {
        [btnGallaryImage setImage:[UIImage imageNamed:@"play-button.png"] forState:UIControlStateNormal];
    }
    else
    {
        [btnGallaryImage setImage:nil forState:UIControlStateNormal];
    }
    
    
    [self setLikesView:commentCount andIsMyLike:isMyLike];
    
    BOOL isAllowComment = isCommentAllow;
    if(isAllowComment)
    {
        vwTextInput.hidden = NO;
    }
    else
    {
        vwTextInput.hidden = YES;
    }
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (IBAction)btnGallaryImageTap:(id)sender
{
    if (_isvideo)
    {
        NSString *URL = Videourl;
        NSURL *videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",URL]];
        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [player play];
        [self addChildViewController:playerViewController];
        [self.view addSubview:playerViewController.view];
        playerViewController.view.frame = self.view.frame;
    }
//    if(selectedPhoto.isVideo)
//    {
//        NSURL *videoURL = selectedPhoto.gallaryVideoURL;
//        AVPlayer *player = [AVPlayer playerWithURL:videoURL];
//        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
//        playerViewController.player = player;
//        [player play];
//        [self addChildViewController:playerViewController];
//        [self.view addSubview:playerViewController.view];
//        playerViewController.view.frame = self.view.frame;
//    }

}

- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnLikeTap:(id)sender
{
    [self likeImage];
}

- (IBAction)btnEmojiTap:(id)sender
{
    if(isEmojiView)
    {
        [_txtComment resignFirstResponder];
        _txtComment.inputView = nil;
        [btnEmoji setImage:[UIImage imageNamed:@"ic_keyboard.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_txtComment resignFirstResponder];
        CGRect keyboardRect = CGRectMake(0, 0, self.view.frame.size.width, 216);
        AGEmojiKeyboardView *emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:keyboardRect
                                                                                 dataSource:self];
        emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        emojiKeyboardView.delegate = self;
        _txtComment.inputView = nil;
        _txtComment.inputView = emojiKeyboardView;
        [btnEmoji setImage:[UIImage imageNamed:@"ic_emoji.png"] forState:UIControlStateNormal];
    }
    isEmojiView = !isEmojiView;
    
    [_txtComment reloadInputViews];
    [_txtComment becomeFirstResponder];
}

- (IBAction)btnSendCommentTap:(id)sender
{
    if(_txtComment.text.length > 0)
    {
        if([WinkUtil reachable])
        {
            [self sendComment];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }
}
- (IBAction)btnReportTap:(id)sender
{
    if([_btnReport.titleLabel.text isEqualToString:@"Delete"])
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Do you want to delete this iteam?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *Block = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [self deleteImage];
                                }];
        
        [alert addAction:Cancel];
        [alert addAction:Block];
        [self presentViewController:alert animated:YES completion:nil];

    }
    else
    {
        SettingOptionViewController *svc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"SettingOptionViewController"];
        
        svc.titleLable = @"Abuse Report";
        svc.arrOptions = @[@"Spam",@"Hate speech or violence",@"Nudity or Pornography",@"Piracy"];
        svc.selectedIndex = 0;
        //svc.buttonLabel = lblButton;
        svc.delegate = self;
        self.providesPresentationContextTransitionStyle = YES;
        self.definesPresentationContext = YES;
        
        [svc setModalPresentationStyle:UIModalPresentationOverFullScreen];
        
        [self setModalPresentationStyle:UIModalPresentationCurrentContext];
        [self presentViewController:svc animated:NO completion:nil];

    }
}
- (IBAction)btnDeleteTap:(UIButton *)btn
{
    CGPoint buttonPosition = [btn convertPoint:CGPointZero toView:tblvComment];
    NSIndexPath *indexPath = [tblvComment indexPathForRowAtPoint:buttonPosition];
    WinkComment *comment = _arrComments[indexPath.row];
    
    if(btn.tag == 1) // delete comment
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete comment?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *Block = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                {
                                    [self deleteComment:comment];
                                }];
        
        [alert addAction:Cancel];
        [alert addAction:Block];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (btn.tag == 2) //reply comment
    {
        _txtComment.text = [NSString stringWithFormat:@"@%@",comment.fromUserUsername];
        [_txtComment becomeFirstResponder];
        _txtComment.tag = [comment.fromUserId intValue];
    }
    
    
}
-(void)deleteComment:(WinkComment *)comment
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"commentId" : comment.CommentId
                               };
        
        [WinkWebServiceAPI deletePhotoComment:dict completionHandler:^(WinkAPIResponse *response)
        {
            [SVProgressHUD dismiss];
            
            
        }];
        
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
    
}
-(void)deleteImage
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"photoId" : PhotoId
                               };
        //selectedPhoto.photoId
        [WinkWebServiceAPI deletePhoto:dict completionHandler:^(WinkAPIResponse *response)
        {
            [SVProgressHUD dismiss];
            if(response.code == RCodeSuccess)
            {
                AppDeleObj.isDeleteFeed = true;

                [self showAlertWithMessage:@"Iteam deleted successfully" andHandler:^(UIAlertAction * _Nullable action) {
                    [self dismissViewControllerAnimated:YES completion:^{
                    }];
                }];
               
            }
            
        }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
-(void)sendComment
{
    [SVProgressHUD show];
    
    NSString *str = [_txtComment.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *goodMsg = [self encodeEmojis:str] ;
    NSString *replyId = @"";
    
    if(_txtComment.tag != 0)
    {
        replyId = [NSString stringWithFormat:@"%ld",(long)_txtComment.tag];
    }
    
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"commentText" : goodMsg,
                           @"replyToUserId" : replyId,
                           @"itemId" : PhotoId
                           };
    //selectedPhoto.photoId
    [WinkWebServiceAPI SendPhotoComment:dict completionHandler:^(WinkAPIResponse *response,WinkComment *comment)
    {
        [SVProgressHUD dismiss];
        if(response.code == RCodeSuccess)
        {
            [_arrComments addObject:comment];
            [tblvComment reloadData];
            _txtComment.text = @"";
            [self setFrames];
        }
        
    }];

}
//selectedPhoto.photoId
-(void)likeImage
{
    if([WinkUtil reachable])
    {
        [SVProgressHUD show];
        NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"itemId" : PhotoId
                               };
        [WinkWebServiceAPI likeGallaryIteam:dict completionHandler:^(WinkAPIResponse *response, int Likes , BOOL isMyLike)
        {
            [SVProgressHUD dismiss];
            if(response.code == RCodeSuccess)
            {
                [self setLikesView:Likes andIsMyLike:isMyLike];
            }
            else
            {
                [self showAlertWithMessage:@"Something went wrong,Please try again later"];
            }
        }];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
#pragma mark - UITableView delegate & Datasource Method
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _arrComments.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfileLikeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCell"];
    WinkComment *comment = _arrComments[indexPath.row];
    [cell setCommentData:comment];
    return cell;
}


#pragma mark - Keyboard Delegate & datasource Method
- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [self randomImage];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

- (UIImage *)emojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView imageForNonSelectedCategory:(AGEmojiKeyboardViewCategoryImage)category {
    UIImage *img = [self randomImage];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}

- (UIImage *)backSpaceButtonImageForEmojiKeyboardView:(AGEmojiKeyboardView *)emojiKeyboardView
{
    UIImage *img = [self randomImage];
    [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return img;
}
- (void)emojiKeyBoardView:(AGEmojiKeyboardView *)emojiKeyBoardView didUseEmoji:(NSString *)emoji {
    _txtComment.text = [_txtComment.text stringByAppendingString:emoji];
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView
{
    if(_txtComment.text.length > 0)
    {
        NSString *newString = [_txtComment.text substringToIndex:[_txtComment.text length]-1];
        _txtComment.text=newString;
    }
   
}
- (UIImage *)randomImage {
    CGSize size = CGSizeMake(30, 10);
    UIGraphicsBeginImageContextWithOptions(size , NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIColor *fillColor = [self randomColor];
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextFillRect(context, rect);
    
    fillColor = [self randomColor];
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGFloat xxx = 3;
    rect = CGRectMake(xxx, xxx, size.width - 2 * xxx, size.height - 2 * xxx);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
- (UIColor *)randomColor {
    return [UIColor colorWithRed:drand48()
                           green:drand48()
                            blue:drand48()
                           alpha:drand48()];
}

#pragma mark - UITextfield Delegate Method
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
-(void)selectedOption:(int)selectedId ofArray:(NSArray *)arrOptions andLabel:(NSString *)Label
{
   
    NSDictionary *dict = @{
                               UKeyAccountId : WinkGlobalObject.user.ID,
                               UKeyAccessToken : WinkGlobalObject.accessToken,
                               @"photoId" : PhotoId,
                               @"abuseId" : [NSNumber numberWithInt:selectedId]
                               };
        //selectedPhoto.photoId
        if([WinkUtil reachable])
        {
            [WinkWebServiceAPI reportUserPhoto:dict completionHandler:^(WinkAPIResponse *response)
             {
               
                 if(response.code == RCodeSuccess)
                 {
                     [self showAlertWithMessage:@"Iteam Reported Successfully" andHandler:^(UIAlertAction * _Nullable action)
                      {
                          [self dismissViewControllerAnimated:YES completion:nil];
                      }];
                 }
                 else
                 {
                     [self showAlertWithMessage:response.message];
                 }
             }];
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    
}
- (IBAction)btn_goProfile:(id)sender
{
    FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
    fvc.profileId = UID;
    //fvc.profileId = [frnd.userId intValue];
    
    [self presentViewController:fvc animated:YES completion:nil];
}



@end
