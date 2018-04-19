//
//  cell_winkStream.h
//  Wink
//
//  Created by Apple on 13/04/18.
//  Copyright © 2018 VPN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface cell_winkStream : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img_bg;
@property (weak, nonatomic) IBOutlet UIImageView *user_profile_img;
@property (weak, nonatomic) IBOutlet UILabel *lbl_user_fullname;
@property (weak, nonatomic) IBOutlet UILabel *lbl_user_userName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_user_activation_time;

@property (weak, nonatomic) IBOutlet UIImageView *img_user_postItem;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UILabel *lbl_commentCount;
@property (weak, nonatomic) IBOutlet UILabel *lbl_likeCount;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideo;





@end
