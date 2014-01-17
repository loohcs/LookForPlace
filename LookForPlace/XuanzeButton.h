//
//  XuanzeButton.h
//  FindPlace
//
//  Created by zuo jianjun on 11-11-30.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DingweiViewController,ShoucangViewController,ViewController;
@interface XuanzeButton : UIView
{
    DingweiViewController * dingwei;
    ShoucangViewController * shoucang;
    ViewController * viewControll;
}
@property (nonatomic,retain) DingweiViewController * dingwei;
@property (nonatomic,retain) ShoucangViewController * shoucang;
@property (nonatomic,retain)  ViewController * viewControll;

+(XuanzeButton *) danliXuanze;
@end
