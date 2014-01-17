//
//  PlaceMessageViewController.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-2.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import "DaliChuanCankao.h"
//传解析的附近信息的协议
@protocol dailiArray 

-(void) chuanshuzu:(NSArray *) array;//传附近信息的代理的方法

@end

@class TianjiaViewController;
@interface PlaceMessageViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,MFMessageComposeViewControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,
    UITextViewDelegate,
    UIActionSheetDelegate,DaliChuanCankao>
{
    
    MFMessageComposeViewController *picker;
    
    NSURLConnection * fujinconn;//附近建筑链接
    NSMutableData * aData;//附近建筑信息
    
    TianjiaViewController * tianjia;
    UITextField * fujiaField;
    UILabel * aLable;
    
    NSURLConnection * conn;//地铁接口链接
    NSMutableData * webData;//地铁信息
    
    UITextView * xinxiField;
    
    UIAlertView * blertView ;
    
   // float height;//cell1中的适应文字大小
    
    BOOL baocun;
    UIToolbar * toolBar;
    MKMapView * mapView;
    
    //接受传过来的selectindex
    NSUInteger selectindex;
    
    //推送到参考物页面
    //UIViewController *aViewC;
}
@property (retain, nonatomic) UIToolbar * toolBar;;
@property (nonatomic,assign) id<dailiArray> delegate;
//@property (nonatomic,assign) UIViewController *aViewC;
@property (retain, nonatomic) IBOutlet UIButton *bacunButton;

//存数据库的字段
@property (nonatomic,assign) float lat,lon;//placelat,placelon
@property (nonatomic,assign) float cankaolat,cankaolon;//cankaolat,cankaolon
@property (nonatomic,retain) NSString * nameMess;
@property (nonatomic,retain) NSString * placename;  //placename
@property (nonatomic,retain) NSString * cankaoname; //cankaoname
@property (nonatomic,retain) NSString * placemess;  //placemess
@property (nonatomic,retain) NSString * cankaomess; //cankaomess
@property (nonatomic,retain) NSString * baocunname; //baocunname
@property (nonatomic,retain) NSString * imageData;  //imagedata
@property (nonatomic,retain) NSString * fujiaxinxi; //fujiaXinxi
//tableview上的控件
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,retain) UITextField * nameField;//输入保存名字的文本框
@property (nonatomic,retain) UITextField * nameView;//cell上的保存名字
@property (nonatomic,retain) UITextView * xinxiField;//当前的地址
@property (nonatomic,retain) UILabel * messageLable;//添加的参照物信息
//@property (nonatomic,retain)UITextField * fujiaField;//添加附加信息的文本框

//存数据
@property (nonatomic,retain) NSDictionary * dicMessage;    
@property (retain, nonatomic) NSDictionary * messageDic;  //解析的附近地理信息

- (IBAction)goBack:(id)sender;
- (IBAction)showSMSPicker:(id)sender;
- (IBAction)pushMingziView:(id)sender;
-(void)displaySMSComposerSheet;
-(UIImage*)captureView:(UIView *)theView;//截取图片的方法
-(void)selectIndex:(NSUInteger)sender;//接受selectindex
@end
