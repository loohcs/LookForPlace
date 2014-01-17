//
//  ShoucangXiangxiViewController.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-11.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "ShoucangXiangxiViewController.h"
#import "PlaceMessage.h"
@implementation ShoucangXiangxiViewController
@synthesize myTableView;
@synthesize place;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.myTableView.backgroundColor = [UIColor clearColor];

}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * acell = @"acell";
    UITableViewCell * cell;
    cell = [tableView dequeueReusableCellWithIdentifier:acell];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:acell] autorelease];
    }
    for (UIView * aView in [cell.contentView subviews]) {
        [aView removeFromSuperview];
    }    
    UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 3, 250, 25)];
    nameLable.font = [UIFont systemFontOfSize:15];
    nameLable.backgroundColor = [UIColor clearColor];
    nameLable.text  = @"qqqqq";
    UILabel * addressLable = [[UILabel alloc] initWithFrame:CGRectMake(18, 30, 250, 30)];
    addressLable.font = [UIFont systemFontOfSize:10];
    addressLable.backgroundColor = [UIColor clearColor];
    addressLable.text  = @"wwww";
    if (indexPath.row%2 != 0) {
        cell.contentView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
    }
    [cell.contentView addSubview:nameLable];
    [cell.contentView addSubview:addressLable];
    [nameLable release];
    [addressLable release];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
//表 表头的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
//表  返回表头
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIControl * aView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];

//    UIImageView * aImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"绿条.png"]];
//    [aView addSubview:aImage];
//    [aImage release];
    UILabel * aLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
    aLable.backgroundColor = [UIColor grayColor];
    aLable.text = @"详细信息列表";
    [aView addSubview:aLable];
    [aLable release];
    return aView;
}
//表  行的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 62;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void) dealloc
{
    [place release];
    [myTableView release];
    [super dealloc];
}
@end
