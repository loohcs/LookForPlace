//
//  ShoucangViewController.m
//  FindPlace
//
//  Created by zuo jianjun on 11-11-29.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "ShoucangViewController.h"
#import "PlaceMessage.h"
#import "DingweiViewController.h"
#import "ShoucangXiangxiViewController.h"
#import "BianjiViewController.h"

#define LongPressDuration 1

@implementation ShoucangViewController
@synthesize shanchuButton;
@synthesize myTableView;
@synthesize xuanButton,nameString,messageArray,mapView,tupianArray;
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//发短信按钮
- (void)showSMSPicker:(PlaceMessage *)sender {
   
    NSString *postString =[NSString stringWithFormat:@"act=position&dev=ios&ver=1.1&p_long=%@&p_lat=%@&p_add=%@&net=wifi&op=00&r_long=%@&r_lat=%@&r_add=%@",[[NSNumber alloc] initWithFloat:sender.placeLon],[[NSNumber alloc] initWithFloat:sender.placeLat],sender.placeMess,[[NSNumber alloc] initWithFloat:sender.cankaoLon],[[NSNumber alloc] initWithFloat:sender.cankaoLat],sender.cankaoMess];  
   
    NSURL *url = [NSURL URLWithString:@"http://www.hylinkad.com/mirror/map/map.php"];    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];       
    [req setHTTPMethod:@"POST"]; 
    [req setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));   
    if (messageClass != nil) {   
        // Check whether the current device is configured for sending SMS messages   
        if ([messageClass canSendText]) {   
           
            [self displaySMSComposerSheet];   
        }   
        else {   
            
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本设备没有短信功能，您不能发送信息！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"关闭", nil];
            [alertView show];
            [alertView release];
        }   
    }   
    else {   
       
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"iOS版本过低,iOS4.0以上才支持程序内发送短信！" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"关闭", nil];
        [alertView show];
        [alertView release];
    }  
}

//发送的内容
-(void)displaySMSComposerSheet   
{   
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];   
    picker.messageComposeDelegate = self;   
    
    NSIndexPath *indexPath = [myTableView indexPathForCell:(UITableViewCell *)gestureView];
    PlaceMessage * place = (PlaceMessage *)[self.messageArray objectAtIndex:indexPath.row];
    
    
    picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",place.placeMess,[[NSNumber alloc] initWithFloat:place.placeLat],[[NSNumber alloc] initWithFloat:place.placeLon]];
    /*
     if ([self.messageLable.text isEqualToString:@"添加参照物"]) {
     if ([fujiaField.text isEqualToString:@"添加附加信息"]) {
     picker.body=[NSString stringWithFormat:@"我在%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
     }
     else{
     picker.body=[NSString stringWithFormat:@"我在%@,%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,fujiaField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
     }
     }
     else
     {
     if ([fujiaField.text isEqualToString:@"添加附加信息"]) {
     picker.body=[NSString stringWithFormat:@"我在%@【％@】。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,self.messageLable.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
     }
     else{
     picker.body=[NSString stringWithFormat:@"我在%@【%@】,%@。\n参考地图: http://maps.google.com/maps?q=loc:%@,%@",self.xinxiField.text,self.messageLable.text,fujiaField.text,[[NSNumber alloc] initWithFloat:self.lat],[[NSNumber alloc] initWithFloat:self.lon]];
     }
     
     }  */
    [self presentModalViewController:picker animated:YES];   
    [picker release];   
}   
//短信的代理 MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller   
                 didFinishWithResult:(MessageComposeResult)result {   
    
    switch (result)   
    {   
        case MessageComposeResultCancelled:   
            NSLog(@"Result: SMS sending canceled");   
            break;   
        case MessageComposeResultSent:   
            
            
            break;   
        case MessageComposeResultFailed:   
            
            NSLog(@"Result: SMS sent");
            UIActionSheet * act = [[UIActionSheet alloc] initWithTitle:
                                   @"短信发送失败!" delegate:self cancelButtonTitle:@"关闭" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
            [act showFromTabBar:self.tabBarController.tabBar];
            break;   
        default:   
            NSLog(@"Result: SMS not sent");   
            break;   
    } 
    [self dismissModalViewControllerAnimated:YES];
    
    //self.nameField.inputAccessoryView=NO;
    
    //    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否保存本信息！" delegate:self cancelButtonTitle:@"保存" otherButtonTitles:@"不保存", nil];
    //    [alertView setTag:101];
    //    [alertView show];
    //    [alertView release];
} 



#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackPageview:@"我的收藏页面"
                                         withError:&error]) {
        NSLog(@"error in trackPageview");
    }
    
    // Do any additional setup after loading the view from its nib.
    self.messageArray = [[NSMutableArray alloc] init];
    tupianArray = [[NSMutableArray alloc] init];
    NSMutableArray * array = [PlaceMessage findAll];
    for (int i = 0; i < [array count]; i++) {
//        PlaceMessage * plac = (PlaceMessage *)[array objectAtIndex:i];
//        [self.messageArray insertObject:plac atIndex:0];
    }
     self.messageArray = array;
    shanchu = YES;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0;
}
//返回行
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.messageArray count = %d",[self.messageArray count]);
    return [self.messageArray count];
}
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        gestureView = [longPress view];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送地址给好友？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        [alert show];
        [alert release];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSIndexPath *indexPath = [myTableView indexPathForCell:(UITableViewCell *)gestureView];
        PlaceMessage * place = (PlaceMessage *)[self.messageArray objectAtIndex:indexPath.row];
        [self showSMSPicker:place];
    }
}
//行的重用
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier0 = @"Cell0";
    static NSString *CellIdentifier1 = @"Cell1";
    UITableViewCell *cell;
    if (indexPath.row%2 == 0) {
        NSLog(@"11111qqqqq");
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier0];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0] autorelease];
            UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            lpress.minimumPressDuration = LongPressDuration;
            [cell addGestureRecognizer:lpress];
            [lpress release];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        for (UIView * aView in [cell.contentView subviews]) {
            [aView removeFromSuperview];
        }
    }
    else if (indexPath.row%2 == 1)
    {
        NSLog(@"222222qqqqq");
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
            
            UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
            lpress.minimumPressDuration = LongPressDuration;
            [cell addGestureRecognizer:lpress];
            [lpress release];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.contentView.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1.0];
        }
        for (UIView * aView in [cell.contentView subviews]) {
            [aView removeFromSuperview];
        }
    }
    else{}
    
    PlaceMessage * place = (PlaceMessage *)[self.messageArray objectAtIndex:indexPath.row];
    UIImage * aimage = [[UIImage alloc] initWithContentsOfFile:place.imageData];
   
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 56, 56)];
    UIView * map = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    map.backgroundColor = [UIColor colorWithRed:89/255.0 green:141/255.0 blue:93/255.0 alpha:1.0];    
    imageView.image = aimage;
    [map addSubview:imageView];
    
    UILabel * nameLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 170, 25)];
    nameLable.backgroundColor = [UIColor clearColor];
    nameLable.text = place.baocunName;
    nameLable.font = [UIFont systemFontOfSize:23];
    nameLable.numberOfLines = 2;
    UILabel * messLable = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 200, 30)];
    messLable.numberOfLines = 2;
    messLable.backgroundColor = [UIColor clearColor];
    NSLog(@"self.placemess=%@",place.placeMess);
    messLable.text = place.placeMess;
    messLable.font = [UIFont systemFontOfSize:12];
    messLable.numberOfLines = 3;
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(295, 30, 15, 21)];
    image.image = [UIImage imageNamed:@"arrow-copy-3.png"];
    [cell.contentView addSubview:map];
    [cell.contentView addSubview:nameLable];
    [cell.contentView addSubview:messLable];
    [cell.contentView addSubview:image];
    [image release];
    [map release];
    [nameLable release];
    [messLable release];
    [imageView release];
    return cell;
}

//-(UIImage*)captureView:(UIView *)theView
//{
//    CGRect rect = theView.frame;
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    [theView.layer renderInContext:context];
//    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return img;
//}
//点中行
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    PlaceMessage * place = (PlaceMessage *)[self.messageArray objectAtIndex:indexPath.row];
    BianjiViewController * bianjiView = [[BianjiViewController alloc] init];
    bianjiView.nameString = place.baocunName;//baocunname
    bianjiView.canzhaoString = place.cankaoMess;
    bianjiView.messageString = place.placeMess;
    bianjiView.placenName = place.placeName;
    bianjiView.canzhaoName = place.cankaoName;
    bianjiView.placeID = place.ID;
    bianjiView.imagedata = place.imageData;
    bianjiView.fujiaxinxi = place.fujiaXinxi;
    bianjiView.lat = [[[NSNumber alloc] initWithDouble:place.placeLat] floatValue];
    bianjiView.lon = [[[NSNumber alloc] initWithDouble:place.placeLon] floatValue];
   
    bianjiView.cankaolon = [[[NSNumber alloc] initWithDouble:place.cankaoLon] floatValue];
    bianjiView.cankaolat = [[[NSNumber alloc] initWithDouble:place.cankaoLat] floatValue];
    [self.navigationController pushViewController:bianjiView animated:YES];
    [bianjiView release];
}

//编辑
-(BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath//编辑
{
	return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView 
		  editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row == [self.messageArray count]) {
		return UITableViewCellEditingStyleInsert;
	}
	return UITableViewCellEditingStyleDelete;
}

- (UITableViewCellAccessoryType)tableView:(UITableView *)aTableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath {
    return (self.editing) ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        PlaceMessage * place = [self.messageArray objectAtIndex:indexPath.row];
       
        [PlaceMessage deletePlaceID:place.ID];
        NSFileManager * fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:place.imageData error:nil];
        [self.messageArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
						 withRowAnimation:UITableViewRowAnimationLeft];
        [myTableView reloadData];
    }  
}

- (void)viewDidUnload
{
    [self setMyTableView:nil];
    [self setShanchuButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
//返回按钮
- (IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)dealloc {
    [myTableView release];
    [nameString release];
    [messageArray release];
    [shanchuButton release];
    [super dealloc];
}
//删除按钮的方法
- (IBAction)shanchuButton:(id)sender {
    if (shanchu == YES) {
        [myTableView beginUpdates];
        [myTableView setEditing:YES animated:YES];
        [myTableView endUpdates];
        [self.shanchuButton setBackgroundImage:[UIImage imageNamed:@"完成-xz.png"] forState:UIControlStateNormal];
        shanchu = NO;
    }
    else{
        [self.shanchuButton setBackgroundImage:[UIImage imageNamed:@"删除.png"] forState:UIControlStateNormal];
        [myTableView setEditing:NO animated:YES];
        shanchu = YES;
    }
}

//添加按钮的方法
- (IBAction)tianjiaButton:(id)sender {
    DingweiViewController * dingwei = [[DingweiViewController alloc] init];
    [self.navigationController pushViewController:dingwei animated:YES];
    [dingwei release];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"我的收藏页面"
                                         action:@"点击按钮"
                                          label:@"添加"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSMutableArray * array = [PlaceMessage findAll];
    for (int i = 0; i < [array count]; i++) {
//        PlaceMessage * plac = (PlaceMessage *)[array objectAtIndex:i];
        //        [self.messageArray insertObject:plac atIndex:0];
    }
    self.messageArray = array;
    [myTableView reloadData];
}
@end
