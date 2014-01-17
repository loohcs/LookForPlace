//
//  DingweiViewController.h
//  FindPlace
//
//  Created by zuo jianjun on 11-11-29.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@class  PlaceMark;
@class  PlaceNow;
@class  XuanzeButton;
@class AppDelegate;
@class MSearch;
#import "JiexiGuanjianzi.h"  
#import "JiexiFujin.h"  
#import "JiexiNowjiwe.h"  
#define dizhi @"data.plist"
@interface DingweiViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UISearchBarDelegate,
UITableViewDelegate,UITableViewDataSource,dailiFujin,dailiNow>
{
    CLLocationManager * locationManager;//定义位置管理器
    CLLocationDegrees lat;//定义经度
    CLLocationDegrees lon;//定义纬度
    PlaceMark * mark;
    PlaceNow * now;
    
    NSString *nowmark1;
    NSString *nowmark2;
    
    NSMutableArray * arrayMessage;//定位点附近建筑物的信息
    //弹出附近tableview下面得view
    UIView * viewTable;
    CLLocationCoordinate2D location;
    //CLLocationCoordinate2D touchMapCoordinate;
    BOOL shousuo;//tableview上收缩按钮的标识
    NSMutableData * aData;
    UIActivityIndicatorView * activ;
    NSURLConnection * fujinconnect;//街旁附近建筑 链接
    NSURLConnection * sousuoconnect;//谷歌搜索链接
    
    BOOL backJianpan;
    AppDelegate *appDelegete;
    NSMutableArray * muArray;//联想字的数组
    
    UIToolbar * toolBar;
    
    NSMutableData *data;
    NSNumber * aNum;
    NSNumber * bNum;
    //搜索后返回的全国数据，弹出的tableview
   IBOutlet UITableView *dictableV;
    //dictablev 上传输的数组
    NSMutableArray *tablearray;
    //根据搜索弹出的tableview的row进行数值取值
    NSUInteger arrayrow;
    
    //把selectindex传值给发送信息页面，以便返回是tabaritem处于高亮状态
    NSUInteger selectindex;
    
    //当前位置和重新定位时得网络请求地址
    NSURLRequest *request1;
    
    //如果未获取到经纬度时，重新设置定义位置管理器
    //MKCoordinateRegion theRegion1;
    
}
@property (nonatomic,retain)NSURLRequest *request1;
//添加到搜索弹出tableview中的风货轮
@property (nonatomic,retain)UIActivityIndicatorView *actiIndicator;
@property (nonatomic,retain)NSMutableArray *tablearray;
@property (nonatomic,retain) UITableView *dictableV;
@property (nonatomic,retain)    NSMutableData *data;
@property (retain, nonatomic) UIToolbar * toolBar;
@property (retain, nonatomic) NSMutableData * aData;
@property (retain, nonatomic) NSMutableData * bData;
@property (retain, nonatomic)  NSMutableArray * arrayMessage;   
@property (retain, nonatomic) IBOutlet UIView *xinxiView;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) IBOutlet UITableView *mingziTableView;
@property (retain, nonatomic)  XuanzeButton * xuanButton;
@property (retain, nonatomic) IBOutlet UISearchBar *seachBar;
@property (retain, nonatomic) IBOutlet MKMapView *mapView;//定义地图属性
@property (retain, nonatomic) NSString *nowmark1;
@property (retain, nonatomic) NSString *nowmark2;
@property(nonatomic) CLLocationDegrees lat; 
@property(nonatomic) CLLocationDegrees lon; 
@property(nonatomic) CLLocationCoordinate2D coord;
@property (nonatomic,retain)PlaceMark * mark;
@property (nonatomic,retain) PlaceNow * now;
-(void) sousuo;
-(void) removeTable:(id)sender;//收缩按钮的方法
- (IBAction)goBack:(id)sender;//返回按钮的方法
//- (IBAction)xinDingwei:(id)sender;
- (IBAction)huishouJianpan:(id)sender;
-(void)Delegatedingwei;
-(void) chuanDGuanjianxinxidic:(NSMutableArray *)guanndic;


//没有搜到数据的时候调用
- (void) errorWithNoPlace;
@end
