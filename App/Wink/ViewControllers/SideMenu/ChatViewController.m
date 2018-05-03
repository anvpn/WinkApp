//
//  ChatViewController.m
//  Wink
//
//  Created by Apple on 07/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "ChatViewController.h"
#import "TPKeyboardAvoidingTableView.h"


@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource,TextCellDelegate,MediaCellDelegate,AGEmojiKeyboardViewDelegate,AGEmojiKeyboardViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UITapGestureRecognizer *img_Left,*img_Right;
    UIRefreshControl *refreshController;
}

@property (weak, nonatomic) IBOutlet UILabel *lblWithUserName;
//@property (weak, nonatomic) IBOutlet JSQMessagesCollectionView *clcvChat;
//@property (weak, nonatomic) IBOutlet UITableView *tblvChat;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingTableView *tblvChat;

@property (strong , nonatomic) NSMutableArray *arrMesaagesList;
@property (strong, nonatomic) NSString *messageID;
@property (weak, nonatomic) IBOutlet UIView *vwTextInput;
@property (weak, nonatomic) IBOutlet UITextField *txtchat;
@property (weak, nonatomic) IBOutlet UIButton *btnEmoji;
@property (weak, nonatomic) IBOutlet UIImageView *imgvImage;

@property (weak, nonatomic) IBOutlet UIView *vwImageView;
@property (weak, nonatomic) IBOutlet UIView *vwTextview;

@property BOOL isEmpojiView;

@property (strong, nonatomic) UIImage *selectedChatImage;
@property (strong, nonatomic) NSString *strChatImg;

@property CGRect OriginalFrame;



@end

@implementation ChatViewController
@synthesize chat,lblWithUserName,arrMesaagesList,messageID,tblvChat,vwTextInput,isEmpojiView,selectedChatImage,imgvImage,strChatImg,vwImageView,vwTextview,OriginalFrame;

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIApplication *app = [UIApplication sharedApplication];
    CGFloat statusBarHeight = app.statusBarFrame.size.height;
    
    UIView *statusBarView =  [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, statusBarHeight)];
    statusBarView.backgroundColor = [UIColor colorWithRed:(118/255.0) green:(36/255.0) blue:(242/255.0) alpha:1] ;
    [self.view addSubview:statusBarView];
    isEmpojiView = NO;
    OriginalFrame = vwTextInput.frame;
    [self prepareView];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:@"refreshChatTable"
                                               object:nil];
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:(BOOL)animated];
    
    self.tblvChat.delegate = self;
    self.tblvChat.dataSource = self;
    
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

- (void)receiveNotification:(NSNotification *)notification
{
    NSDictionary *dict = notification.object;
    // [self showAlertWithMessage:dict[@"msgMessage"]];
    if ([[notification name] isEqualToString:@"refreshChatTable"])
    {
        if(![dict[@"msgImgUrl"] isEqualToString:@""])
        {
            [self adddMediaBubbledata:kImagebyOther mediaPath:dict[@"msgMessage"] mtime:dict[@"msgTimeAgo"] thumb:dict[@"msgImgUrl"] downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"msgId"]avtarImage:dict[@"msgFromUserPhotoUrl"]];
        }
        else
        {
            [self adddMediaBubbledata:kTextByOther mediaPath:dict[@"msgMessage"] mtime:dict[@"msgTimeAgo"] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"msgId"]avtarImage:dict[@"msgFromUserPhotoUrl"]];
        }
        [tblvChat reloadData];
        [self scrollTableview];
    }
}

-(void)prepareView
{
    lblWithUserName.text = chat.WithUserFullname;
    arrMesaagesList = [[NSMutableArray alloc]init];
    
    refreshController = [[UIRefreshControl alloc] init];
    [refreshController addTarget:self action:@selector(handleRefresh:) forControlEvents:UIControlEventValueChanged];
    [tblvChat addSubview:refreshController];
    
    /* UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
     initWithTarget:self
     action:@selector(dismissKeyboard)];
     [tblvChat addGestureRecognizer:tap];*/
    //tblvChat.backgroundColor =[UIColor clearColor];
    vwImageView.hidden = YES;
    vwTextInput.frame = CGRectMake(vwTextInput.x,(vwTextInput.y + vwImageView.height), vwTextInput.width, vwTextview.height);
    
    tblvChat.height = tblvChat.height + vwImageView.height - 10;
    
    [tblvChat setSeparatorColor:[UIColor clearColor]];
    
    if([WinkUtil reachable])
    {
        [self getChatMessages];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
#pragma mark - Keyboard appearance/disappearance handling

- (void)keyboardWillAppear:(NSNotification *)notification
{
//    NSDictionary *userInfo = [notification userInfo];
//    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0);
//    [tblvChat setContentInset:contentInsets];
//    [self scrollTableview];
//
//    CGRect messageFrame = vwTextInput.frame;
//    messageFrame.origin.y -= keyboardSize.height;
//    [vwTextInput setFrame:messageFrame];
    
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect messageFrame = vwTextInput.frame;
    messageFrame.origin.y -= keyboardSize.height;
    
    CGRect rect = CGRectMake(0, [UIScreen mainScreen].bounds.size.height -(keyboardSize.height + vwTextInput.frame.size.height ), [UIScreen mainScreen].bounds.size.width, vwTextInput.frame.size.height);
    
    [vwTextInput setFrame:rect];

    
}
- (void)keyboardWillDisappear:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [tblvChat setContentInset:UIEdgeInsetsZero];
    [UIView commitAnimations];
    [tblvChat setScrollIndicatorInsets:UIEdgeInsetsZero];
    
    CGRect messageFrame = vwTextInput.frame;
    messageFrame.origin.y += keyboardSize.height;
    [vwTextInput setFrame:messageFrame];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
-(void)getChatMessages
{
    [SVProgressHUD show];
    
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken: WinkGlobalObject.accessToken,
                           UKeyProfileId : chat.WithUserId,
                           @"chatId"     : chat.chatId,
                           @"chatFromUserId" :WinkGlobalObject.user.ID,
                           @"chatToUserId" : chat.WithUserId
                           };
    [WinkWebServiceAPI getChatMessages:dict completionHAndler:^(WinkAPIResponse *response, NSArray *arrMessages, NSString *msgID)
     {
         [SVProgressHUD dismiss];
         
         messageID = msgID;
         if(arrMessages.count > 0)
         {
             for(int  i = (int)(arrMessages.count-1) ; i>= 0; i--)
             {
                 NSDictionary *dict = arrMessages[i];
                 
                 if([WinkGlobalObject.user.ID isEqualToString:dict[@"fromUserId"]])
                 {
                     if(![dict[@"imgUrl"] isEqualToString:@""])
                     {
                         [self adddMediaBubbledata:kImagebyme mediaPath:dict[@"message"] mtime:dict[@"timeAgo"] thumb:dict[@"imgUrl"] downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"id"]avtarImage:dict[@"fromUserPhotoUrl"]];
                     }
                     else
                     {
                         [self adddMediaBubbledata:kTextByme mediaPath:dict[@"message"] mtime:dict[@"timeAgo"] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"id"]avtarImage:dict[@"fromUserPhotoUrl"]];
                     }
                     
                 }
                 else
                 {
                     if(![dict[@"imgUrl"] isEqualToString:@""])
                     {
                         [self adddMediaBubbledata:kImagebyOther mediaPath:dict[@"message"] mtime:dict[@"timeAgo"] thumb:dict[@"imgUrl"] downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"id"]avtarImage:dict[@"fromUserPhotoUrl"]];
                     }
                     else
                     {
                         [self adddMediaBubbledata:kTextByOther mediaPath:dict[@"message"] mtime:dict[@"timeAgo"] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"id"]avtarImage:dict[@"fromUserPhotoUrl"]];
                     }
                     
                 }
             }
         }
         else if(response.message)
         {
             [self showAlertWithMessage:response.message];
         }
         else
         {
             [self showAlertWithMessage:response.error.localizedDescription];
         }
         [tblvChat reloadData];
         [self scrollTableview];
     }];
    
}
- (IBAction)btnBackTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnDeleteTap:(id)sender
{
    if([WinkUtil reachable])
    {
        [self deleteChat];
    }
    else
    {
        [self showAlertWithMessage:WinkNoInternet];
    }
}
- (IBAction)btnSendTap:(id)sender
{
    if(selectedChatImage != nil)
    {
        [SVProgressHUD show];
        [WinkWebServiceAPI uploadChatPhoto:selectedChatImage completionHandler:^(WinkAPIResponse *response, NSDictionary *photoDict)
         {
             if(response.code == RCodeSuccess)
             {
                 strChatImg = photoDict[@"imgUrl"];
                 [self sendNewMessage];
             }
         }];
    }
    else
    {
        strChatImg = @"";
        [self sendNewMessage];
    }
    
}
-(void)sendNewMessage
{
    [self.txtchat resignFirstResponder];
    
    NSString *str = [_txtchat.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *msg = [self encodeEmojis:str];
    
    if([WinkUtil reachable] &&(selectedChatImage != nil || ![str isEqualToString:@""]))
    {
        
        [self.txtchat setText:@""];
        

        // accountId,accessToken,profileId,chatId,messageText,messageImg,listId,chatFromUserId,chatToUserId
        NSDictionary * dict = @{
                                UKeyAccountId : WinkGlobalObject.user.ID,
                                UKeyAccessToken : WinkGlobalObject.accessToken,
                                UKeyProfileId : chat.WithUserId,
                                @"messageText" : msg,
                                @"listId" : chat.chatId,
                                @"chatFromUserId" : WinkGlobalObject.user.ID,
                                @"chatToUserId" : chat.WithUserId,
                                @"messageImg" : strChatImg
                                };
        [WinkWebServiceAPI newChatMessage:dict completionHAndler:^(WinkAPIResponse *response, NSDictionary *dict)
         {
             if(response.code == RCodeSuccess)
             {
                 _txtchat.text = @"";
                 if(selectedChatImage)
                 {
                     selectedChatImage = nil;
                     imgvImage.image = nil;
                     vwImageView.hidden = YES;
                     vwTextInput.frame = CGRectMake(vwTextInput.x,(vwTextInput.y + vwImageView.height), vwTextInput.width, vwTextview.height);
                     
                     tblvChat.height = tblvChat.height + vwImageView.height - 10;
                 }
                 
                 [SVProgressHUD dismiss];
                 if(![dict[@"imgUrl"] isEqualToString:@""])
                 {
                     [self adddMediaBubbledata:kImagebyme mediaPath:dict[@"message"] mtime:dict[@"timeAgo"] thumb:dict[@"imgUrl"] downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"id"]avtarImage:dict[@"fromUserPhotoUrl"]];
                 }
                 else
                 {
                     [self adddMediaBubbledata:kTextByme mediaPath:dict[@"message"] mtime:dict[@"timeAgo"] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"id"]avtarImage:dict[@"fromUserPhotoUrl"]];
                 }
                 [tblvChat reloadData];
                 [self scrollTableview];
             }
             else if(response.message)
             {
                 [self showAlertWithMessage:response.message];
             }
             else
             {
                 //ana
                 
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if(selectedChatImage != nil)
            {
                 vwTextInput.frame = CGRectMake(vwTextInput.frame.origin.x, [UIScreen mainScreen].bounds.size.height - vwTextview.frame.size.height, vwTextInput.frame.size.width, vwTextInput.frame.size.height - vwImageView.frame.size.height);
            }
            
           
                     vwImageView.hidden = true;
                     selectedChatImage = nil;
                     imgvImage.image = nil;
                     [self getChatMessages];
        });
                 
                
//                 [self showAlertWithMessage:response.error.localizedDescription];
             }
         }];
    }
    else
    {
        [self showAlertWithMessage:@"Please connect with internet"];
    }
}

- (IBAction)btnCameraTap:(id)sender
{
    [self askForImage];
}
- (IBAction)btnEmojiTap:(id)sender
{
    if(isEmpojiView)
    {
        [_txtchat resignFirstResponder];
        _txtchat.inputView = nil;
        [_btnEmoji setImage:[UIImage imageNamed:@"ic_keyboard.png"] forState:UIControlStateNormal];
    }
    else
    {
        [_txtchat resignFirstResponder];
        CGRect keyboardRect = CGRectMake(0, 0, self.view.frame.size.width, 216);
        AGEmojiKeyboardView *emojiKeyboardView = [[AGEmojiKeyboardView alloc] initWithFrame:keyboardRect
                                                                                 dataSource:self];
        emojiKeyboardView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        emojiKeyboardView.delegate = self;
        _txtchat.inputView = nil;
        _txtchat.inputView = emojiKeyboardView;
        [_btnEmoji setImage:[UIImage imageNamed:@"ic_emoji.png"] forState:UIControlStateNormal];
        
    }
    isEmpojiView = !isEmpojiView;
    
    [_txtchat reloadInputViews];
    [_txtchat becomeFirstResponder];
}

-(void)deleteChat
{
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken : WinkGlobalObject.accessToken,
                           UKeyProfileId : chat.WithUserId,
                           @"chatId" : chat.chatId,
                           };
    
    [WinkWebServiceAPI deleteChat:dict completionHandler:^(WinkAPIResponse *response)
     {
         if(response.code == RCodeSuccess)
         {
             [self showAlertWithMessage:@"Chat deleted successfully" andHandler:^(UIAlertAction * _Nullable action)
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

-(void)scrollTableview
{
    
    NSInteger item = [tblvChat numberOfRowsInSection:0] - 1;
    if(item > 0)
    {
        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
        [tblvChat scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}

#pragma mark - UItableview delegate & Datasource Method


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrMesaagesList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[arrMesaagesList objectAtIndex:indexPath.row];
    
    if ([feed_data.chat_media_type isEqualToString:kImagebyme]||[feed_data.chat_media_type isEqualToString:kImagebyOther])  return 180;
    
    CGSize labelSize =[feed_data.chat_message boundingRectWithSize:CGSizeMake(226.0f, MAXFLOAT)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:17.0f] }
                                                           context:nil].size;
    return labelSize.height + 30 + TOP_MARGIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *L_CellIdentifier = @"SPHTextBubbleCell";
    static NSString *R_CellIdentifier = @"SPHMediaBubbleCell";
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[arrMesaagesList objectAtIndex:indexPath.row];
    
    if ([feed_data.chat_media_type isEqualToString:kTextByme]||[feed_data.chat_media_type isEqualToString:kTextByOther])
    {
        SPHTextBubbleCell *cell = (SPHTextBubbleCell *) [tableView dequeueReusableCellWithIdentifier:L_CellIdentifier];
        if (cell == nil)
        {
            cell = [[SPHTextBubbleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:L_CellIdentifier];
        }
        
        cell.bubbletype=([feed_data.chat_media_type isEqualToString:kTextByme])?@"RIGHT":@"LEFT";
        
        NSString *goodMsg = [self decodeEmojis:feed_data.chat_message];
        
        cell.textLabel.text = goodMsg;
        cell.textLabel.tag=indexPath.row;
        cell.timestampLabel.text =feed_data.chat_date_time;
       // cell.timestampLabel.textColor = (__bridge UIColor * _Nullable)([UIColor whiteColor].CGColor);
        cell.CustomDelegate=self;
        
        
        NSURL *url = [NSURL URLWithString:feed_data.chat_avtarImageURLString];
        NSString *lastComponent;
        NSURL *fromProfURL;
        
        if(url != nil && url != NULL && (url.absoluteString.length != 0))
        {
            lastComponent = [url lastPathComponent];
            fromProfURL = [WinkWebservice URLForProfileImage:lastComponent];
            
        }
        
        [cell.AvatarImageView setImageWithURL:fromProfURL placeholderImage:[UIImage imageNamed:@"profile_default_photo"]];
        img_Right = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedRight:)];
        
        img_Right.numberOfTapsRequired = 1;
        [cell.AvatarImageView setUserInteractionEnabled:YES];
        [cell.AvatarImageView addGestureRecognizer:img_Right];
        return cell;
        
    }
    
    SPHMediaBubbleCell *cell = (SPHMediaBubbleCell *) [tableView dequeueReusableCellWithIdentifier:R_CellIdentifier];
    if (cell == nil)
    {
        cell = [[SPHMediaBubbleCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:R_CellIdentifier];
    }
    cell.messageImageView.backgroundColor= [UIColor clearColor];
    cell.bubbletype=([feed_data.chat_media_type isEqualToString:kImagebyme])?@"RIGHT":@"LEFT";
    cell.textLabel.text = feed_data.chat_message;
    cell.messageImageView.tag=indexPath.row;
    cell.CustomDelegate=self;
    cell.timestampLabel.text = feed_data.chat_date_time;
   // cell.timestampLabel.textColor = (__bridge UIColor * _Nullable)([UIColor whiteColor].CGColor);
    //[cell.messageImageView setImageWithURL:[NSURL URLWithString:feed_data.chat_Thumburl]];
    NSLog(@"%@",feed_data.chat_Thumburl);
    
    
    
    
    
    NSURL *url = [NSURL URLWithString:feed_data.chat_avtarImageURLString];
    NSString *lastComponent;
    NSURL *fromProfURL;
    
    if(url != nil && url != NULL && (url.absoluteString.length != 0))
    {
        lastComponent = [url lastPathComponent];
        fromProfURL = [WinkWebservice URLForProfileImage:lastComponent];
        
    }
    [cell.AvatarImageView setImageWithURL:fromProfURL placeholderImage:[UIImage imageNamed:@"profile_default_photo"]];
    
    url = [NSURL URLWithString:feed_data.chat_Thumburl];
    if(url != nil && url != NULL && (url.absoluteString.length != 0))
    {
        lastComponent = [url lastPathComponent];
        fromProfURL = [WinkWebservice URLForChatImages:lastComponent];
    }
    
    cell.messageImageView.image = [UIImage imageNamed:@"img_defaultthumbnail"];
    NSLog(@"Purl:-%@",fromProfURL);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSData *imgData = [NSData dataWithContentsOfURL:fromProfURL];
        dispatch_async(dispatch_get_main_queue(), ^{ // 2
            
            if(imgData)
            {
                UIImage *img = [UIImage imageWithData:imgData];
                if(img)
                {
                    [cell.messageImageView setImage:img];
                }
                else
                {
                    cell.messageImageView.image = [UIImage imageNamed:@"img_defaultthumbnail"];
                    
                    //NSLog(@" image url was %@ ",feed_data.chat_Thumburl);
                }
                
            }
            else
            {
                cell.messageImageView.image = [UIImage imageNamed:@"img_defaultthumbnail"];
                //NSLog(@" image url was %@ ",feed_data.chat_Thumburl);
            }
            
        });
    });
    //[cell.messageImageView setImageWithURL:fromProfURL];
    //NSData * imageData = [NSData dataWithContentsOfURL:fromProfURL];
    //UIImage * image = [UIImage imageWithData:imageData];
    //cell.messageImageView.image = image;
    //cell.messageImageView.backgroundColor = [UIColor clearColor];
    /*img_Left = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetectedLeft:)];
     
     img_Left.numberOfTapsRequired = 1;
     [cell.AvatarImageView setUserInteractionEnabled:YES];
     [cell.AvatarImageView addGestureRecognizer:img_Left];*/
    return cell;
}
- (void)tapDetectedLeft:(UITapGestureRecognizer *)gesture
{
    FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
    
    int pid = [chat.WithUserId intValue];
    fvc.profileId = pid;
    
    [self presentViewController:fvc animated:YES completion:nil];
    //    FriendsViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendsViewController"];
    //    fvc.isMenu = NO;
    //    fvc.profileId = chat.WithUserId;
    //    [self presentViewController:fvc animated:YES completion:nil];
    //chat.WithUserId
    //UITableViewCell *cell = [[[gesture view] superview] superview];
    //NSIndexPath *tappedIndexPath = [self.tblvChat indexPathForCell:cell];
    //NSLog(@"Image Tap %@", tappedIndexPath);
    //SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    //feed_data=[arrMesaagesList objectAtIndex:tappedIndexPath.row];
    //NSLog(@"%@",feed_data);
}

-(void)tapDetectedRight:(UITapGestureRecognizer *)gesture
{
    UITableViewCell *cell = (UITableViewCell *) [[[gesture view] superview] superview];
    NSIndexPath *tappedIndexPath = [self.tblvChat indexPathForCell:cell];
    NSLog(@"Image Tap %@", tappedIndexPath);
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data=[arrMesaagesList objectAtIndex:tappedIndexPath.row];
    
    if([feed_data.chat_media_type isEqualToString:kImagebyme] || [feed_data.chat_media_type isEqualToString:kTextByme])
    {
        ProfileViewController *vc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"ProfileViewController"];
        
        vc.isMenu = NO;
        [self presentViewController:vc animated:YES completion:nil];
    }
    else
    {
        FriendProfileViewController *fvc = [WinkGlobalObject.storyboardMenubar instantiateViewControllerWithIdentifier:@"FriendProfileViewController"];
        
        int pid = [chat.WithUserId intValue];
        fvc.profileId = pid;
        
        [self presentViewController:fvc animated:YES completion:nil];
    }
    
    
    
    NSLog(@"%@",feed_data);
}

-(void)adddMediaBubbledata:(NSString*)mediaType  mediaPath:(NSString*)mediaPath mtime:(NSString*)messageTime thumb:(NSString*)thumbUrl  downloadstatus:(NSString*)downloadstatus sendingStatus:(NSString*)sendingStatus msg_ID:(NSString*)msgID avtarImage:(NSString *)urlString
{
    
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data.chat_message=mediaPath;
    feed_data.chat_date_time=messageTime;
    feed_data.chat_media_type=mediaType;
    feed_data.chat_send_status=sendingStatus;
    feed_data.chat_Thumburl=thumbUrl;
    feed_data.chat_downloadStatus=downloadstatus;
    feed_data.chat_messageID=msgID;
    feed_data.chat_avtarImageURLString = urlString;
    [arrMesaagesList addObject:feed_data];
}
//=========***************************************************=============
#pragma mark - CELL CLICKED  PROCEDURE
//=========***************************************************=============


-(void)textCellDidTapped:(SPHTextBubbleCell *)tesxtCell AndGesture:(UIGestureRecognizer*)tapGR;
{
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tesxtCell.textLabel.tag inSection:0];
    // NSLog(@"Forward Pressed =%@ and IndexPath=%@",tesxtCell.textLabel.text,indexPath);
    //[tesxtCell showMenu];
}
// 7684097905

-(void)cellCopyPressed:(SPHTextBubbleCell *)tesxtCell
{
    NSLog(@"copy Pressed =%@",tesxtCell.textLabel.text);
    
}

-(void)cellForwardPressed:(SPHTextBubbleCell *)tesxtCell
{
    NSLog(@"Forward Pressed =%@",tesxtCell.textLabel.text);
    
}
-(void)cellDeletePressed:(SPHTextBubbleCell *)tesxtCell
{
    NSLog(@"Delete Pressed =%@",tesxtCell.textLabel.text);
    
}

//=========*******************  BELOW FUNCTIONS FOR IMAGE  **************************=============

-(void)mediaCellDidTapped:(SPHMediaBubbleCell *)mediaCell AndGesture:(UIGestureRecognizer*)tapGR;
{
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:mediaCell.messageImageView.tag inSection:0];
    // NSLog(@"Media cell Pressed  and IndexPath=%@",indexPath);
    
    //[mediaCell showMenu];
}

-(void)mediaCellCopyPressed:(SPHMediaBubbleCell *)mediaCell
{
    NSLog(@"copy Pressed =%@",mediaCell.messageImageView.image);
}

-(void)mediaCellForwardPressed:(SPHMediaBubbleCell *)mediaCell
{
    NSLog(@"Forward Pressed =%@",mediaCell.messageImageView.image);
    
}
-(void)mediaCellDeletePressed:(SPHMediaBubbleCell *)mediaCell
{
    NSLog(@"Delete Pressed =%@",mediaCell.messageImageView.image);
    
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
    _txtchat.text = [_txtchat.text stringByAppendingString:emoji];
}

- (void)emojiKeyBoardViewDidPressBackSpace:(AGEmojiKeyboardView *)emojiKeyBoardView
{
    if(_txtchat.text.length > 0)
    {
        NSString *newString = [_txtchat.text substringToIndex:[_txtchat.text length]-1];
        _txtchat.text=newString;
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
         UIImage *selectedImg1 = info[UIImagePickerControllerEditedImage];
         selectedChatImage = selectedImg1;
         
         //[btnProfile setImage:selectedImage forState:UIControlStateNormal];
         imgvImage.image = selectedChatImage;
         vwImageView.hidden = NO;
         vwTextInput.frame = OriginalFrame;
         tblvChat.height = vwTextInput.y;
         [self scrollTableview];
         //[self uploadPhoto];
         
     }];
}
#pragma mark - Handle Refresh Method
-(void)handleRefresh : (id)sender
{
    NSLog (@"Pull To Refresh Method Called");
    [refreshController endRefreshing];
    //http://www.winkandroid.com/api/v3/method/chat.getPrevious.inc.php
    //accountId,accessToken,profileId,chatId,msgId,chatFromUserId,chatToUserId
    if (messageID.length==0)
    {
        
    }
    else
    {
        [self getPreviusChatMessages];
    }
}

-(void)getPreviusChatMessages
{
    [SVProgressHUD show];
    NSLog(@"user.ID:-%@",WinkGlobalObject.user.ID);
    NSLog(@"accessToken:-%@",WinkGlobalObject.accessToken);
    NSLog(@"user.ID:-%@",WinkGlobalObject.user.ID);
    NSLog(@"user.ID:-%@",WinkGlobalObject.user.ID);
    NSLog(@"chat.WithUserId:-%@",chat.WithUserId);
    NSLog(@"chat.chatId:-%@",chat.chatId);
    NSLog(@"user.ID:-%@",WinkGlobalObject.user.ID);
    NSLog(@"chat.WithUserId:-%@",chat.WithUserId);
    NSLog(@"messageID:-%@",messageID);
    NSDictionary *dict = @{
                           UKeyAccountId : WinkGlobalObject.user.ID,
                           UKeyAccessToken: WinkGlobalObject.accessToken,
                           UKeyProfileId : chat.WithUserId,
                           @"chatId"     : chat.chatId,
                           @"chatFromUserId" :WinkGlobalObject.user.ID,
                           @"chatToUserId" : chat.WithUserId,
                           @"msgId" : messageID
                           };
    NSLog(@"dict:-%@",dict);
    [WinkWebServiceAPI getPreviusChatMessages:dict completionHAndler:^(WinkAPIResponse *response, NSArray *arrMessages, NSString *msgID)
     {
         [SVProgressHUD dismiss];
         if(arrMessages.count > 0)
         {
             messageID = msgID;
             for(int  i = (int)(arrMessages.count-1) ; i>= 0; i--)
             {
                 NSDictionary *dict = arrMessages[i];
                 
                 if([WinkGlobalObject.user.ID isEqualToString:dict[@"fromUserId"]])
                 {
                     if(![dict[@"imgUrl"] isEqualToString:@""])
                     {
                         [self adpreviueMediaBubbledata:kImagebyme mediaPath:dict[@"message"] mtime:dict[@"timeAgo"] thumb:dict[@"imgUrl"] downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"id"]avtarImage:dict[@"fromUserPhotoUrl"]];
                     }
                     else
                     {
                         [self adpreviueMediaBubbledata:kTextByme mediaPath:dict[@"message"] mtime:dict[@"timeAgo"] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"id"]avtarImage:dict[@"fromUserPhotoUrl"]];
                     }
                 }
                 else
                 {
                     if(![dict[@"imgUrl"] isEqualToString:@""])
                     {
                         [self adpreviueMediaBubbledata:kImagebyOther mediaPath:dict[@"message"] mtime:dict[@"timeAgo"] thumb:dict[@"imgUrl"] downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"id"]avtarImage:dict[@"fromUserPhotoUrl"]];
                     }
                     else
                     {
                         [self adpreviueMediaBubbledata:kTextByOther mediaPath:dict[@"message"] mtime:dict[@"timeAgo"] thumb:@"" downloadstatus:@"" sendingStatus:kSent msg_ID:dict[@"id"]avtarImage:dict[@"fromUserPhotoUrl"]];
                     }
                     
                 }
             }
         }
         [tblvChat reloadData];
         //[self scrollTableview];
     }];
    
}

-(void)adpreviueMediaBubbledata:(NSString*)mediaType  mediaPath:(NSString*)mediaPath mtime:(NSString*)messageTime thumb:(NSString*)thumbUrl  downloadstatus:(NSString*)downloadstatus sendingStatus:(NSString*)sendingStatus msg_ID:(NSString*)msgID avtarImage:(NSString *)urlString
{
    SPH_PARAM_List *feed_data=[[SPH_PARAM_List alloc]init];
    feed_data.chat_message=mediaPath;
    feed_data.chat_date_time=messageTime;
    feed_data.chat_media_type=mediaType;
    feed_data.chat_send_status=sendingStatus;
    feed_data.chat_Thumburl=thumbUrl;
    feed_data.chat_downloadStatus=downloadstatus;
    feed_data.chat_messageID=msgID;
    feed_data.chat_avtarImageURLString = urlString;
    [arrMesaagesList insertObject:feed_data atIndex:0];
    //[arrMesaagesList addObject:feed_data];
}


@end
