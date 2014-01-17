//
//  NowPlaceViewController.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-9.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceNow.h"
@class PlaceMark;
@class AppDelegate;
#import "JiexiGuanjianzi.h"  
#import "JiexiFujin.h"  
#import "JiexiNowjiwe.h"  

@interface NowPlaceViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    CLLocationDegrees lat;                               //定义经度
    CLLocationDegrees lon;                               //定义纬度
    CLLocationCoordinate2D location;
    CLLocationManager * locationManager;                 //定义位置管理器
    NSMutableArray * arrayMessage;                             //存储当前点附近的信息
    UIView * viewTable;
    PlaceMark * mark;
    
    NSString *nowmark1;
    NSString *nowmark2;
    
    BOOL shousuo;   //tableview上收缩按钮的标识
    NSMutableData * aData;
    UIActivityIndicatorView * activ;
    NSString * str;
    
    //气泡上得名字和地址
    NSString *nameanotion;
    NSString *addranotion;
    
    //气泡为搜索时转动
    UIActivityIndicatorView *indicatorV;
    
     AppDelegate *appDelegete;
    NSMutableData * mutabledata;
    NSNumber * aNum;
    NSNumber * bNum;
    PlaceNow * now;
    MKPinAnnotationView *newAnnotation;//气泡view
    
    NSURLConnection *connection1;
    NSURLConnection *connection2;
    NSURLConnection *connection3;
    
    //把selectindex传值给发送信息页面，以便返回是tabaritem处于高亮状态
    NSUInteger selectindex;
    
    CLLocationCoordinate2D touchMapCoordinate;
    //当前位置和重新定位时得网络请求地址
    NSURLRequest *request1;
    //长按时得网络请求地址
    NSURLRequest *request3;
    //附近信息得网络请求地址
    NSURLRequest *request2;
    
}
@property (nonatomic,retain)NSURLRequest *request1;
@property (nonatomic,retain)NSURLRequest *request2;
@property (nonatomic,retain)NSURLRequest *request3;

@property (nonatomic,retain)NSMutableData *amutabledata;
@property (nonatomic,retain) NSMutableArray * arrayMessage;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain,nonatomic)PlaceMark *mark;
@property (nonatomic,retain)  NSURLConnection *connection1,*connection2,*connection3;


@property(nonatomic) CLLocationDegrees lat; 
@property(nonatomic)  CLLocationDegrees lon; 
- (IBAction)backButton:(id)sender;
- (IBAction)xinDingwei:(id)sender;
-(void) jiexiDingdianxinxi;
-(void) jiexiFujinxinxi;
-(void) removeTable:(id)sender;

@end
