//
//  AppDelegate.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-1.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class  PlaceMark;
@class  PlaceNow;
@class  NowPlaceViewController;
@class ViewController;
@class Fuwuzhinan;

@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    CLLocationManager * locationManager;//定义位置管理器
    CLLocationDegrees lat;//定义经度
    CLLocationDegrees lon;//定义纬度
    PlaceMark * mark;
    PlaceNow * now;
    NSMutableArray * arrayMessage;//定位点附近建筑物的信息
    UIView * viewTable;
    CLLocationCoordinate2D location;
    MKCoordinateRegion theRegion;
    Fuwuzhinan *aFuwuzhinan;
    
    UIImageView *view1;

}
@property (retain,nonatomic) Fuwuzhinan *afuwuzhinan;
@property (assign,nonatomic) MKCoordinateRegion theRegion;

@property (assign,nonatomic) CLLocationCoordinate2D location;

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) ViewController *viewController;
-(void)location:(id)sender;

@end
