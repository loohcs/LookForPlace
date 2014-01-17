//
//  BianjiViewController.h
//  FindPlace
//
//  Created by zuo jianjun on 11-11-29.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MapKit/MapKit.h>
#import "DaliChuanCankao.h"
@protocol dailiArraya 

-(void) chuanshuzua:(NSArray *) array;

@end
@class TianjiaViewController;
@interface BianjiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MFMessageComposeViewControllerDelegate,UITextViewDelegate,UIAlertViewDelegate,UITextFieldDelegate,DaliChuanCankao>
{
    TianjiaViewController * tianjia;
    BOOL bianji;
    BOOL tuisong;
    BOOL backJianpan;
    UITextField * fujiaField;//附加信息
    NSMutableData * aData;
    UILabel * aLable;
    UILabel * messageLable;//参照物的信息
    UITextView * xinxiField;
    
    UIToolbar * toolBar;
}
@property (nonatomic,assign) int placeID;
@property (nonatomic,assign) id<dailiArraya> delegate;
@property (nonatomic,retain) NSDictionary * dicMessage;
@property (retain, nonatomic) IBOutlet UIButton *bianjiButton;
//数据库中的信息
@property (assign, nonatomic) float lat,lon;//jingwei
@property (assign, nonatomic) float cankaolat,cankaolon;//cankaojingwei
@property (retain, nonatomic) NSString * messageString;//dizhi
@property (retain, nonatomic) NSString * canzhaoString;//canzhaodizhi
@property (retain, nonatomic) NSString * placenName;//mingzi
@property (retain, nonatomic) NSString * canzhaoName;//canzhaomingzi
@property (retain, nonatomic) NSString * nameString;//收藏的名字
@property (retain, nonatomic) NSString * imagedata;
@property (retain, nonatomic) NSString * fujiaxinxi;
//表中的控件
@property (retain, nonatomic) UITextField * aLabel;
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (retain, nonatomic) NSString * fujiaString;
@property (retain, nonatomic) NSString * xinxiStr;
@property (retain, nonatomic) UITextView * xinxiField;//位置的信息

- (IBAction)fasongButton:(id)sender;//发送按钮
- (IBAction)bianjiButton:(id)sender;//编辑按钮
- (IBAction)backButton:(id)sender;//返回按钮
- (IBAction)tianjiaButton:(id)sender;//添加按钮
- (IBAction)liebiaoButton:(id)sender;//列表按钮
-(void)displaySMSComposerSheet;
- (IBAction)showSMSPicker:(id)sender;
@end
