//
//  ShoucangViewController.h
//  FindPlace
//
//  Created by zuo jianjun on 11-11-29.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XuanzeButton.h"
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
@interface ShoucangViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,MFMessageComposeViewControllerDelegate>
{
    BOOL shanchu;
     UIView *gestureView;
}
@property (retain, nonatomic) IBOutlet UIButton *shanchuButton;
@property (retain, nonatomic) MKMapView * mapView;
@property (retain, nonatomic) NSMutableArray * messageArray;//存放信息的数组
@property (retain, nonatomic) NSMutableArray * tupianArray;//存放tupian信息的数组
@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,retain) NSString * nameString;//收藏的名字
@property (nonatomic,retain) XuanzeButton * xuanButton;
- (IBAction)goBack:(id)sender;//返回按钮
- (IBAction)shanchuButton:(id)sender;//删除按钮
- (IBAction)tianjiaButton:(id)sender;//添加按钮
//-(UIImage*)captureView:(UIView *)theView;//截图片
-(void)displaySMSComposerSheet;
@end
