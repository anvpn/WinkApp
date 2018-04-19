//
//  SettingOptionViewController.m
//  Wink
//
//  Created by Apple on 22/06/17.
//  Copyright © 2017 VPN. All rights reserved.
//

#import "SettingOptionViewController.h"

@interface SettingOptionViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UITableView *tblvOptions;
@property (weak, nonatomic) IBOutlet UIView *vwOption;
@property (weak, nonatomic) IBOutlet UIView *vwBottom;
@property (weak, nonatomic) IBOutlet UIView *vwTableview;

@end

@implementation SettingOptionViewController
@synthesize titleLable,arrOptions,lblTitle,tblvOptions,buttonLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    lblTitle.text = titleLable;
    [tblvOptions reloadData];
    [self setFramesOfViews];
}
-(void)setFramesOfViews
{
    tblvOptions.height = tblvOptions.contentSize.height;
    if(tblvOptions.contentSize.height > _vwTableview.height)
    {
        tblvOptions.height = _vwTableview.height;
    }
    else
    {
        tblvOptions.height = tblvOptions.contentSize.height;
    }
    _vwTableview.height = tblvOptions.y + tblvOptions.height;
    
    _vwBottom.y = _vwTableview.y + _vwTableview.height;
    _vwOption.height = _vwBottom.y +_vwBottom.height;
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}
- (IBAction)btnCancelTap:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)btnOKTap:(id)sender
{
    [self.delegate selectedOption:_selectedIndex ofArray:arrOptions andLabel:buttonLabel];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOptions.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionTableViewCell"];
    cell.lblOption.text = arrOptions[indexPath.row];
    if(indexPath.row == _selectedIndex)
    {
        cell.imgvRadio.image = [UIImage imageNamed:@"radiobutton-selected.png"];
    }
    else
    {
        cell.imgvRadio.image = [UIImage imageNamed:@"radiobutton.png"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OptionTableViewCell *cell;
    NSIndexPath *indexPathForFirstRow;
    
    if (_selectedIndex != indexPath.row)
     {
       indexPathForFirstRow = [NSIndexPath indexPathForRow:_selectedIndex inSection:0];
      cell = (OptionTableViewCell*)[tableView cellForRowAtIndexPath:indexPathForFirstRow];
      cell.imgvRadio.image = [UIImage imageNamed:@"radiobutton"];
     }
    
    cell  = (OptionTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell.imgvRadio.image  = [UIImage imageNamed:@"radiobutton-selected"];
    _selectedIndex = (int)indexPath.row;
}
@end
