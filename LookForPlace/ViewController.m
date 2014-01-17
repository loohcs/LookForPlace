//
//  ViewController.m
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-1.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "ViewController.h"
#import "DingweiViewController.h"
#import "ShoucangViewController.h"
#import "NowPlaceViewController.h"
#import "MoreViewController.h"
#import "XuanzeButton.h"
#import "PlaceMessage.h"
//#import "GANTracker.h"
@implementation ViewController
@synthesize nowmessageLable;
@synthesize myMapView,aView;
@synthesize numberLable,custom;
@synthesize dingWei,shoucang,nowplace,xuanzeButton,more,aTab;
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - 位置管理器的代理方法
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation
{
    //获得当前坐标
    location = [newLocation coordinate];
	lat = location.latitude;//纬度
	lon = location.longitude;//经度
    NSNumber * a = [[NSNumber alloc] initWithFloat:lat];
    NSNumber * b = [[NSNumber alloc] initWithFloat:lon];
    [a release];
    [b release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.


    UIImageView *bgImgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    bgImgV.image = [UIImage imageNamed:@"木纹背景.png"];
    [self.view insertSubview:bgImgV atIndex:0];
    [bgImgV release];
    locationManager = [[CLLocationManager alloc]init];//初始化位置管理器
	[locationManager setDelegate:self];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//设置精度
    locationManager.distanceFilter = 1000.0f;//设置距离筛选器
    [locationManager startUpdatingLocation];
    [self performSelectorInBackground:@selector(chushi) withObject:nil];       
}
- (void)viewDidUnload
{
    [self setNumberLable:nil];
    [self setNowmessageLable:nil];
    [self setMyMapView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    // 收藏个数的显示   
    int a = [PlaceMessage count];
    NSNumber * aNumber = [[NSNumber alloc] initWithInt:a];
    self.numberLable.text = [NSString stringWithFormat:@"%@",aNumber];
    [aNumber release];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark - 初始化方法
-(void)chushi
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
   self.shoucang = [[ShoucangViewController alloc] init];
    self.shoucang.mapView = self.myMapView;
    UINavigationController * nav1 = [[UINavigationController alloc] initWithRootViewController:self.shoucang];
    [self.shoucang release];
    nav1.navigationBarHidden = YES;
//    nav1.tabBarItem.image = [UIImage imageNamed:@"小图标_2.png"];
//    nav1.tabBarItem.title = @"我的收藏";
    
     self.dingWei = [[DingweiViewController alloc] init];
    dingWei.coord = location;
    UINavigationController * nav2 = [[UINavigationController alloc] initWithRootViewController:self.dingWei];
    [self.dingWei release];
    nav2.navigationBarHidden = YES;
//    nav2.tabBarItem.image = [UIImage imageNamed:@"小图标_3.png"];
//    nav2.tabBarItem.title = @"自选位置";
    NSLog(@"nav2.tabBarItem.image = %@",nav2.tabBarItem.image);
    
     self.nowplace = [[NowPlaceViewController alloc] init];
    UINavigationController * nav3 = [[UINavigationController alloc] initWithRootViewController:self.nowplace];
    [self.nowplace release];
    nav3.navigationBarHidden = YES;
//    nav3.tabBarItem.image = [UIImage imageNamed:@"小图标_1.png"];
//    nav3.tabBarItem.title = @"当前位置";
    
    self.more = [[MoreViewController alloc] init];
    UINavigationController * nav4 = [[UINavigationController alloc] initWithRootViewController:self.more];
    [self.more release];
    nav4.navigationBarHidden = YES;
    
//    nav4.tabBarItem.image = [UIImage imageNamed:@"ooo.png"];
//    nav4.tabBarItem.title = @"更多";
    
      
//判断版本号 判断4或5的方法
    UIDevice *device = [UIDevice currentDevice];
    int version = [device.systemVersion intValue];
    NSLog(@"version = %d",version);
        self.custom = [[CustomTabBar alloc] init];
    
        self.custom.viewControllers = [[NSArray alloc] initWithObjects:nav1,nav2,nav3,nav4, nil];
        self.aTab = (CustomTabBar *)self.custom;
//    self.aTab = [[UITabBarController alloc] init];
//    self.aTab.viewControllers = [[NSArray alloc] initWithObjects:nav1,nav2,nav3,nav4, nil];
    [nav1 release];
    [nav2 release];
    [nav3 release];
    [nav4 release];
    [pool release];
}
#pragma mark - 发送自选位置
- (IBAction)pushDingwei:(id)sender {
//    NSError *error;
//    if (![[GANTracker sharedTracker] trackEvent:@"Application iOS"
//                                         action:@"Launch iOS"
//                                          label:@"发送自选位置"
//                                          value:99
//                                      withError:&error]) {
//        NSLog(@"error in trackEvent");
//    }

    [self chushi];
    self.aTab.selectedIndex = 1;
    [self.custom changePick];
    [self presentModalViewController:self.aTab animated:YES];
    [self.aTab release];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"首页页面"
                                         action:@"点击按钮"
                                          label:@"发送自选位置"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
}
#pragma mark - 我的收藏
- (IBAction)pushShoucang:(id)sender {
    [self chushi];
    self.aTab.selectedIndex = 0;
    [self.custom changePick];
    [self presentModalViewController:self.aTab animated:YES];  
    [self.aTab release];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"首页页面"
                                         action:@"点击按钮"
                                          label:@"我的收藏"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
}
#pragma mark - 发送当前位置
- (IBAction)pushNowplace:(id)sender {
    [self chushi];
    self.aTab.selectedIndex = 2;
    [self.custom changePick];
    [self presentModalViewController:self.aTab animated:YES];
    [self.aTab release];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"首页页面"
                                         action:@"点击按钮"
                                          label:@"发送当前位置"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
}
#pragma mark - 更多
- (IBAction)pushMore:(id)sender {
    [self chushi];
    self.aTab.selectedIndex = 3;
    [self.custom changePick];
    [self presentModalViewController:self.aTab animated:YES];
    [self.aTab release];
    
    NSError *error;
    if (![[GANTracker sharedTracker] trackEvent:@"首页页面"
                                         action:@"点击按钮"
                                          label:@"更多"
                                          value:1
                                      withError:&error]) {
        NSLog(@"error in trackEvent");
    }
}

- (void)dealloc {
    [aView release];
    [numberLable release];
    [nowmessageLable release];
    [myMapView release];
    [self.dingWei release];
    [self.shoucang release];
    [self.nowplace release];
    [self.more release];
    [self.nowmessageLable release];
    [super dealloc];
}
@end
