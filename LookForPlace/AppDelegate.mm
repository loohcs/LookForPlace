//
//  AppDelegate.m
//  LookForPlace
//
//  Created by sangbei on 11-12-1.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "PlaceMessage.h"
#import "JSON.h"
#import "PlaceMark.h"
#import "PlaceNow.h"
#import "NowPlaceViewController.h"
#import "Fuwuzhinan.h"
#import "GANTracker.h"
#import "MyDanLi.h"
static const NSInteger kGANDispatchPeriodSec = 10;
static NSString* const kAnalyticsAccountId = @"UA-28254094-1";
//志涛 UA-28792127-1
@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize theRegion,location,afuwuzhinan;
- (void)dealloc
{
    //谷歌分析暂停，释放内存
    [[GANTracker sharedTracker] stopTracker];
    [afuwuzhinan release];
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //启动谷歌分析的追踪器
    [[GANTracker sharedTracker] startTrackerWithAccountID:kAnalyticsAccountId
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
//    监控事件或网页的各种方法，可以直接放到需要监控的控件里
//    NSError *error;
    
//    if (![[GANTracker sharedTracker] setCustomVariableAtIndex:1
//                                                         name:@"iOS1"
//                                                        value:@"iv1"
//                                                    withError:&error]) {
//        NSLog(@"error in setCustomVariableAtIndex");
//    }
//    
//    if (![[GANTracker sharedTracker] trackEvent:@"Application iOS"
//                                         action:@"Launch iOS"
//                                          label:@"Example iOS"
//                                          value:99
//                                      withError:&error]) {
//        NSLog(@"error in trackEvent");
//    }
//    
//    if (![[GANTracker sharedTracker] trackPageview:@"/app_entry_point"
//                                         withError:&error]) {
//        NSLog(@"error in trackPageview");
//    }

    //[self location:nil]; 
    locationManager = [[CLLocationManager alloc]init];//初始化位置管理器
	
    
    [locationManager setDelegate:self];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//设置精度
    locationManager.distanceFilter = 1000.0f;//设置距离筛选器
    [locationManager startUpdatingLocation];//启动位置管理器
    
    
//    lat = location.latitude;
//    lon = location.longitude;
//    location.latitude = location.latitude+0.0016;
//    location.longitude = location.longitude+0.0062;
//    MKCoordinateSpan theSpan; 
//    theSpan.latitudeDelta= 0.01f; 
//    theSpan.longitudeDelta=0.01f; 
//    theRegion.center = location; 
//    theRegion.span = theSpan; 
//    NSLog(@"lat=%f",lat);
//    NSLog(@"lon=%f",lon);
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    
    NSString *path = [docPath stringByAppendingPathComponent:@"TestFirst"];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:path] == NO)
    {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        //[[MyDanLi dingWeiVC] searchBarString:@"海淀"];
        Fuwuzhinan *fuwu=[[Fuwuzhinan alloc] init];
        self.afuwuzhinan=fuwu;
        self.window.rootViewController=self.afuwuzhinan;
        [fuwu release];

    }
    
    if (lat==0.0&&lon==0.0) {
        NSLog(@"ahahah");
        
        
        view1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
        [view1 setImage:[UIImage imageNamed:@"开机画面"]];
        [self.window addSubview:view1];
        [view1 release];

    }


    
      
    [self.window makeKeyAndVisible];
    return YES;
}
//-(void)location:(id)sender
//{
//    
//    locationManager = [[CLLocationManager alloc]init];//初始化位置管理器
//    [locationManager setDelegate:self];
//	[locationManager setDesiredAccuracy:kCLLocationAccuracyBest];//设置精度
//    locationManager.distanceFilter = 1000.0f;//设置距离筛选器
//    [locationManager startUpdatingLocation];//启动位置管理器
//
//}
- (void)locationManager:(CLLocationManager *)managern
	didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;
{
    NSLog(@"最初定位");
    //当前经纬    
    location = [newLocation coordinate];
    //插针的经纬  有偏移量     
    lat = location.latitude;
    lon = location.longitude;
    location.latitude = location.latitude+0.0016;
    location.longitude = location.longitude+0.0062;
    MKCoordinateSpan theSpan; 
    theSpan.latitudeDelta= 0.01f; 
    theSpan.longitudeDelta=0.01f; 
    theRegion.center = location; 
    theRegion.span = theSpan; 
    NSLog(@"lat=%f",lat);
    NSLog(@"lon=%f",lon);
    
    [view1 setFrame:CGRectMake(0, -480, 320, 480)];
    if (self.window.rootViewController==nil) {
        ViewController *aViewC=[[ViewController alloc] init];
        self.window.rootViewController=aViewC;
        [aViewC release];
    }

   
  
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
