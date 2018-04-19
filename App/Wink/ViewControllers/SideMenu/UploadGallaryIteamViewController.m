//
//  UploadGallaryIteamViewController.m
//  Wink
//
//  Created by Apple on 15/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "UploadGallaryIteamViewController.h"

@interface UploadGallaryIteamViewController ()<AGEmojiKeyboardViewDelegate,AGEmojiKeyboardViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtvComment;
@property (weak, nonatomic) IBOutlet UIButton *btnCamera;
@property (weak, nonatomic) IBOutlet UIButton *btnEmoji;
@property (weak, nonatomic) IBOutlet UILabel *lblNewIteam;
@property (weak, nonatomic) IBOutlet UIView *vwTextInput;


@property UIImage *selectedImage;
@property UIImage *thumbImage;

@property BOOL isEmojiView;
@property BOOL isVideo;

@property (strong, nonatomic) NSString *imageNormalUrl;
@property (strong, nonatomic) NSString *imageOriginUrl;
@property (strong, nonatomic) NSString *imagePreviewUrl;
@property (strong, nonatomic) NSString *videoUrl;

@property (strong, nonatomic) NSURL *selectedVideoURL;
@property (strong, nonatomic) UILabel *placeHolderLabel;


@end

@implementation UploadGallaryIteamViewController
@synthesize txtvComment,btnCamera,btnEmoji,lblNewIteam,vwTextInput,isEmojiView,imageNormalUrl,imageOriginUrl,imagePreviewUrl,isVideo,videoUrl,selectedVideoURL,thumbImage,placeHolderLabel;
- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    
    [txtvComment becomeFirstResponder];
    isEmojiView = NO;
    isVideo = NO;
    imagePreviewUrl = @"";
    imageOriginUrl = @"";
    imageNormalUrl = @"";
    videoUrl = @"";
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0.0, txtvComment.frame.size.width - 20.0, 34.0)];
    [placeHolderLabel setText:@"Type Comment"];
    // placeholderLabel is instance variable retained by view controller
    [placeHolderLabel setBackgroundColor:[UIColor clearColor]];
    [placeHolderLabel setFont:[UIFont fontWithName:@"system" size:15.0]];
    [placeHolderLabel setTextColor:[UIColor lightGrayColor]];
    
    // textView is UITextView object you want add placeholder text to
    [txtvComment addSubview:placeHolderLabel];
    // Do any additional setup after loading the view.
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
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:(BOOL)animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)btnBAckTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnEmojiTap:(id)sender
{
    _btnDone.hidden = false;
   

    
    if(isEmojiView)
    {
        [txtvComment resignFirstResponder];
        txtvComment.inputView = nil;
        [btnEmoji setImage:[UIImage imageNamed:@"ic_keyboard.png"] forState:UIControlStateNormal];
    }
    else
    {
        [txtvComment resignFirstResponder];
        CGRect keyboardRect = CGRectMake(0, 0, self.view.frame.size.width, 216);
        AGEmojiKeyboardView *emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:keyboardRect
                                                                                 dataSource:self];
        emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        emojiKeyboardView.delegate = self;
        txtvComment.inputView = nil;
        txtvComment.inputView = emojiKeyboardView;
        [btnEmoji setImage:[UIImage imageNamed:@"ic_emoji.png"] forState:UIControlStateNormal];
        
    }
    isEmojiView = !isEmojiView;
    
    [txtvComment reloadInputViews];
    [txtvComment becomeFirstResponder];
}
- (IBAction)btnCameraTap:(id)sender
{
    _btnDone.hidden = true;

    if(_selectedImage)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete" message:@"Are you sure you want to delete iteam?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *Cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:nil];
        
        UIAlertAction *Block = [UIAlertAction actionWithTitle:@"DELETE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
        _selectedImage = nil;
        selectedVideoURL = nil;
        videoUrl =@"";
        isVideo = NO;
        [btnCamera setImage:[UIImage imageNamed:@"ic_action_camera.png"] forState:UIControlStateNormal];
        [btnCamera setBackgroundImage:nil forState:UIControlStateNormal];
        _imgTobeUpload.image = nil;
        
    }];
        
        [alert addAction:Cancel];
        [alert addAction:Block];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self askForImage];
    }
    
}
- (IBAction)btnSendTap:(id)sender
{
    if(_selectedImage || (selectedVideoURL != nil))
    {
        if([WinkUtil reachable])
        {
            if(isVideo)
            {
                [self uploadGallaryVideo];
            }
            else
            {
                [self uploadGallaryPhoto];
            }
            
        }
        else
        {
            [self showAlertWithMessage:WinkNoInternet];
        }
    }
    else
    {
        [self showAlertWithMessage:@"Please select Image first"];
    }
}
-(void)uploadGallaryPhoto
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken
                           };
    
    [WinkWebServiceAPI uploadGallaryPhoto:dict withImage:_selectedImage completionHAndler:^(WinkAPIResponse *response, NSDictionary *dict)
     {
         if(response.code == RCodeSuccess)
         {
             dispatch_async(dispatch_get_main_queue(), ^{
                 imageNormalUrl = dict[@"normalPhotoUrl"];
                 imageOriginUrl = dict[@"originPhotoUrl"];
                 imagePreviewUrl = dict[@"previewPhotoUrl"];
                 [self uploadGallaryIteam];
             });
           
         }
        
    }];
    
}
-(void)uploadGallaryVideo
{
    [SVProgressHUD show];
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken
                           };
    NSData *videoData = [NSData dataWithContentsOfURL:selectedVideoURL];
    
    [WinkWebServiceAPI uploadGallaryVideo:dict withData:videoData andImage:thumbImage completionHAndler:^(WinkAPIResponse *response, NSDictionary *dict)
     {
    
         if(response.code == RCodeSuccess)
         {
             videoUrl = dict[@"videoFileUrl"];
             imageNormalUrl = dict[@"imgFileUrl"];
             
             [self uploadGallaryIteam];
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
-(void)uploadGallaryIteam
{
    //accountId,accessToken,accessMode,itemType,comment,imgUrl,videoUrl,originImgUrl,previewImgUrl,postArea,postCountry,postCity,postLat,postLng
    NSString *strComment = txtvComment.text;
    if(![txtvComment.text isEqualToString:@""])
    {
        strComment = [self encodeEmojis:strComment];
    }
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           @"accessMode" : @"0",
                           @"itemType" :[NSNumber  numberWithBool:isVideo],
                           @"comment" : strComment,
                           @"imgUrl" : imageNormalUrl,
                           @"videoUrl" : videoUrl,
                           @"originImgUrl" : imageOriginUrl,
                           @"previewImgUrl" : imagePreviewUrl,
                           @"postArea" : @"",
                           @"postCity" : @"",
                           @"postLat" : @"",
                           @"postLng" : @""
                           };
    
    [WinkWebServiceAPI uploadGallaryIteam:dict completionHandler:^(WinkAPIResponse *response)
    {
        [SVProgressHUD dismiss];
        
        if(response.code == RCodeSuccess)
        {
           [self showAlertWithMessage:@"Iteam uploaded successfully" andHandler:^(UIAlertAction * _Nullable action)
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
#pragma mark - Keyboard appearance/disappearance handling

- (void)keyboardWillAppear:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect messageFrame = vwTextInput.frame;
    messageFrame.origin.y -= keyboardSize.height;
    
    CGRect rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -(keyboardSize.height + vwTextInput.frame.size.height), [UIScreen mainScreen].bounds.size.width, vwTextInput.frame.size.height);
    
    [vwTextInput setFrame:rect];
    
    
    

    
}
- (void)keyboardWillDisappear:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
   // CGRect messageFrame = vwTextInput.frame;
   // messageFrame.origin.y += keyboardSize.height;
   // [vwTextInput setFrame:messageFrame];

    CGRect rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -(vwTextInput.frame.size.height), [UIScreen mainScreen].bounds.size.width, vwTextInput.frame.size.height);
    
    [vwTextInput setFrame:rect];
    
    self.txtvComment.hidden = false;
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
    txtvComment.text = [txtvComment.text stringByAppendingString:emoji];
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView
{
    if(txtvComment.text.length > 0)
    {
        NSString *newString = [txtvComment.text substringToIndex:[txtvComment.text length]-1];
        txtvComment.text=newString;
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
                                    isVideo = NO;
                                    [self selectProfileImageFrom:UIImagePickerControllerSourceTypeCamera];
                                }];
    
    UIAlertAction *fromAlbum = [UIAlertAction actionWithTitle:WinkTextFromLibrary
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    isVideo = NO;
                                    [self selectProfileImageFrom:UIImagePickerControllerSourceTypePhotoLibrary];
                                }];
    UIAlertAction *videoFromAlbum = [UIAlertAction actionWithTitle:@"VideoFromAlbum"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    isVideo = YES;
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
    [actionSheet addAction:videoFromAlbum];
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
    if(isVideo)
    {
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeMovie,      nil];
    }
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - UIImagePickerControllerDelegate method
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:YES completion:^
     {
         
         if(isVideo)
         {
             selectedVideoURL = [info objectForKey:UIImagePickerControllerMediaURL];
             
             NSLog(@"VideoURL = %@", selectedVideoURL);
             [picker dismissViewControllerAnimated:YES completion:NULL];
             [self generateImage];
         }
         else
         {
             UIImage *selectedImg1 = info[UIImagePickerControllerEditedImage];
             _selectedImage = selectedImg1;
             _imgTobeUpload.image = _selectedImage;
             
             [btnCamera setBackgroundColor:[UIColor clearColor]];
             [btnCamera setImage:nil forState:UIControlStateNormal];
             [btnCamera setBackgroundImage:_selectedImage forState:UIControlStateNormal];
             
             [txtvComment becomeFirstResponder];
         }
         
     }];
}

-(void)generateImage
{
    AVURLAsset *asset=[[AVURLAsset alloc] initWithURL:selectedVideoURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform=TRUE;
   //[asset release];
    CMTime thumbTime = CMTimeMakeWithSeconds(0,1);
    
    AVAssetImageGeneratorCompletionHandler handler = ^(CMTime requestedTime, CGImageRef im, CMTime actualTime, AVAssetImageGeneratorResult result, NSError *error){
        if (result != AVAssetImageGeneratorSucceeded) {
            NSLog(@"couldn't generate thumbnail, error:%@", error);
        }
        [btnCamera setImage:[UIImage imageWithCGImage:im] forState:UIControlStateNormal];
        thumbImage = [UIImage imageWithCGImage:im] ;
        //[generator release];
    };
    
    CGSize maxSize = CGSizeMake(320, 180);
    generator.maximumSize = maxSize;
    [generator generateCGImagesAsynchronouslyForTimes:[NSArray arrayWithObject:[NSValue valueWithCMTime:thumbTime]] completionHandler:handler];
    
}
#pragma mark - UITextviewDelegate Method
- (void) textViewDidChange:(UITextView *)theTextView
{
    if(![txtvComment hasText])
    {
        [txtvComment addSubview:placeHolderLabel];
    } else if ([[txtvComment subviews] containsObject:placeHolderLabel]) {
        [placeHolderLabel removeFromSuperview];
    }
}

- (void)textViewDidEndEditing:(UITextView *)theTextView
{
    if (![txtvComment hasText])
    {
        [txtvComment addSubview:placeHolderLabel];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (IBAction)btnDone:(id)sender {
    [txtvComment resignFirstResponder];

}

@end
