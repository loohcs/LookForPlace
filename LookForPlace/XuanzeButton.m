//
//  XuanzeButton.m
//  FindPlace
//
//  Created by zuo jianjun on 11-11-30.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "XuanzeButton.h"
#import "DingweiViewController.h"
#import "ShoucangViewController.h"
#import "XuanzeButton.h"
@implementation XuanzeButton
@synthesize dingwei,shoucang,viewControll;

+(XuanzeButton *) danliXuanze
{
   static  XuanzeButton * xuanzeButton = nil;
    if (xuanzeButton == nil) {
        xuanzeButton = [[XuanzeButton alloc] initWithFrame:CGRectMake(0, 423, 320, 49)];
    }
    return xuanzeButton;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"标题栏背景.png"]];
//  定位按钮
         UIButton * dingweiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        dingweiButton.frame = CGRectMake(0, 0, 80, 49);
        [dingweiButton setImage:[UIImage imageNamed:@"小图标_2.png"] forState:UIControlStateNormal];
        [dingweiButton addTarget:self action:@selector(chushihuaDingweiView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:dingweiButton];
//    收藏按钮
        UIButton * shoucangButton = [UIButton buttonWithType:UIButtonTypeCustom];
        shoucangButton.frame = CGRectMake(80,0,80,49);
        [shoucangButton setImage:[UIImage imageNamed:@"小图标_3.png"] forState:UIControlStateNormal];
        [shoucangButton addTarget:self action:@selector(chushihuaShoucangView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shoucangButton];
//   发送当前信息的按钮
        UIButton * xinxiButton = [UIButton buttonWithType:UIButtonTypeCustom];
        xinxiButton.frame = CGRectMake(160,0,80,49);
        [xinxiButton setImage:[UIImage imageNamed:@"小图标_1.png"] forState:UIControlStateNormal];
        [xinxiButton addTarget:self action:@selector(chushihuafasongView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:xinxiButton];
//    更多按钮
        UIButton * gengduoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        gengduoButton.frame = CGRectMake(240,0,80,49);
        [gengduoButton setImage:[UIImage imageNamed:@"ooo.png"] forState:UIControlStateNormal];
        [gengduoButton addTarget:self action:@selector(chushihuagengduoView )forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:gengduoButton];
    }
    return self;
}
-(void) chushihuaDingweiView
{
//    NSLog(@"dingweiView ");
  
}
-(void) chushihuaShoucangView
{
    NSLog(@"shoucangView");
}
-(void) chushihuafasongView
{
    NSLog(@"fasongView");
}
-(void) chushihuagengduoView
{
    NSLog(@"gengduoView");
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
