//
//  GallaryIteamViewController.h
//  Wink
//
//  Created by Apple on 04/07/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "WinkViewController.h"

@interface GallaryIteamViewController : WinkViewController
{
    NSString *Videourl,*PhotoId;
}
@property (strong, nonatomic) WinkPhotos *selectedPhoto;
@property (nonatomic) BOOL Isnotification;
@property (strong,nonatomic)NSString *ItemId;

@end
