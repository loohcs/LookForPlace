//
//  ViewController.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-1.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CustomTabBar.h"
@class DingweiViewController,ShoucangViewController,XuanzeButton,NowPlaceViewController,MoreViewController;
@interface ViewController : UIViewController<CLLocationManagerDelegate>
{
    DingweiViewController  *dingWei;
    ShoucangViewController * shoucang;
    NowPlaceViewController * nowplace;
    MoreViewController * more;
    XuanzeButton * xuanzeButton;
    UITabBarController * aTab;
    CLLocationDegrees lat;//定义经度
    CLLocationDegrees lon;//定义纬度
    CLLocationCoordinate2D location;
    CLLocationManager * locationManager;//定义位置管理器
    UIView *aView;
}
@property (retain,nonatomic)UIView *aView;
@property (retain, nonatomic) IBOutlet MKMapView *myMapView;
@property (retain, nonatomic) IBOutlet UILabel *numberLable;//显示收藏的个数
@property (retain, nonatomic) IBOutlet UILabel *nowmessageLable;//当前位置信息
//UITabBarController的属性
@property (nonatomic,retain)UITabBarController * aTab;
@property (retain, nonatomic) CustomTabBar *custom;//
//ViewController的属性
@property (nonatomic,retain) DingweiViewController  *dingWei;//自选位置
@property (nonatomic,retain)     ShoucangViewController * shoucang;//收藏 
@property (nonatomic,retain) NowPlaceViewController * nowplace;//当前位置
@property (nonatomic,retain) MoreViewController * more;//更多
@property (nonatomic,retain)    XuanzeButton * xuanzeButton; 

- (IBAction)pushDingwei:(id)sender;//发送自选位置的按钮方法
- (IBAction)pushShoucang:(id)sender;//我的收藏按钮的方法
- (IBAction)pushNowplace:(id)sender;//发送当前位置按钮的方法
- (IBAction)pushMore:(id)sender;//更多按钮的方法


@end
