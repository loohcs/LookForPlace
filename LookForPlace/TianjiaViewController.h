//
//  TianjiaViewController.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-2.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceMessageViewController.h"
#import "BianjiViewController.h"
#import "DaliChuanCankao.h"
#import "JiexiDitie.h"
@interface TianjiaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,dailiArray,dailiArraya,dailiDitie>
{
    UIActivityIndicatorView * activ;
    NSString * fangwei;
   // NSString * fangweijuli;
}
@property (nonatomic,retain)NSString *fangwei;
//@property (nonatomic,retain)NSString *fangweijuli;
@property (nonatomic,assign) id<DaliChuanCankao> delegate;

@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,retain)NSArray * messArray;//保存信息的数组
@property (nonatomic,retain)NSDictionary * ditieDic;//保存信息的数组
@property (nonatomic,retain)PlaceMessageViewController * placeController;
@property (nonatomic,retain)BianjiViewController * bianjiController;
@property (nonatomic,retain) NSString * cankaoname;
@property (nonatomic,retain) NSString * cankaomess;
@property (nonatomic,assign) float cankaolat,cankaolon;
@property (nonatomic,assign) float placelat,placelon;
-(NSString *) jisuanFangwei:(float) thelat andlon:(float) thelon andcankaolat:(float) thecankaolat andcnakaolon:(float) thecankaolon;
- (IBAction)goBack:(id)sender;//返回按钮的方法
@end
