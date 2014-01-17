//
//  MoreViewController.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-10.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "MoreViewController.h"
#import "XinshouViewController.h"
#import "YijianViewController.h"
#import "BanbenViewController.h"
#import "MoreFuwuzhinan.h"
@implementation MoreViewController


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
//    UIColor * aColor  = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"木纹背景.png"]];
//    self.view.backgroundColor = aColor;
//    [aColor release];
    UIImageView *aImageView=[[UIImageView alloc] initWithFrame:self.view.bounds];
    [aImageView setImage:[UIImage imageNamed:@"木纹背景.png"]];
    [self.view insertSubview:aImageView atIndex:0];
    [aImageView release];
    [xinLable setTextColor:[UIColor colorWithRed:0.388 green:0.192 blue:0.105 alpha:1]];
    [yiLable setTextColor:[UIColor colorWithRed:0.388 green:0.192 blue:0.105 alpha:1]];
    [daoLable setTextColor:[UIColor colorWithRed:0.388 green:0.192 blue:0.105 alpha:1]];
    [banLable setTextColor:[UIColor colorWithRed:0.388 green:0.192 blue:0.105 alpha:1]];
    [diwenLable setTextColor:[UIColor colorWithRed:0.250 green:0.082 blue:0.003 alpha:1]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (IBAction)pushXinshou:(id)sender {
//    XinshouViewController * xinshou = [[XinshouViewController alloc] init];
//    [self.navigationController pushViewController:xinshou animated:YES];
//    [xinshou release];
    UIView *View1=[[UIView alloc] initWithFrame:CGRectMake(0, -480, 320, 480)];
    [View1 setBackgroundColor:[UIColor clearColor]];
    [View1 setTag:10];
   
    
    
    [self performSelector:@selector(fuwuzhinan:) withObject:View1 afterDelay:0.0];
    [self.view addSubview:View1];
    //[aView release];
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"更多页面"
                                         action:@"点击按钮"
                                          label:@"新手使用指导"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
}
-(void)fuwuzhinan:(id)sender
{
    MoreFuwuzhinan *aMoreFu=[[MoreFuwuzhinan alloc] init];
    [self presentModalViewController:aMoreFu animated:YES];
    [aMoreFu release];
}


- (IBAction)pushYijian:(id)sender {
    YijianViewController * yijian = [[YijianViewController alloc] init];
    [self.navigationController pushViewController:yijian animated:YES];
    [yijian release];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"更多页面"
                                         action:@"点击按钮"
                                          label:@"意见反馈"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
}

- (IBAction)pushAppstore:(id)sender {
//    NSString *str = [NSString stringWithFormat:
//                     @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa     /wa/viewContentsUserReviews?type=Purple+Software&id=2"];  //, m_appleID。。。itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa     /wa/viewContentsUserReviews?type=Purple+Software&id=2
    //NSString *str1=[NSString stringWithFormat:@"http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id=284417350&mt=8"];
    NSString *str = [NSString stringWithFormat:
                     @"http://itunes.apple.com/cn/app//id496407433?mt=8"]; 
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]]; 
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"更多页面"
                                         action:@"点击按钮"
                                          label:@"到AppStore评分"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
}

- (IBAction)pushBanben:(id)sender {
    BanbenViewController * banben = [[BanbenViewController alloc] init];
    [self.navigationController pushViewController:banben animated:YES];
    [banben release];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"更多页面"
                                         action:@"点击按钮"
                                          label:@"版本信息"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
}

- (IBAction)backButton:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
- (void)dealloc {

    [super dealloc];
}
@end
