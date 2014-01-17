//
//  KeyBoardTopBar.h
//  Huishoujianpan
//
//  Created by zuo jianjun on 11-12-22.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyBoardTopBar : NSObject
{
UIToolbar       *view;                       //工具条        
NSArray         *textFields;                 //输入框数组
BOOL            allowShowPreAndNext;         //是否显示上一项、下一项
BOOL            isInNavigationController;    //是否在导航视图中
UIBarButtonItem *prevButtonItem;             //上一项按钮
UIBarButtonItem *nextButtonItem;             //下一项按钮
UIBarButtonItem *hiddenButtonItem;           //隐藏按钮
UIBarButtonItem *spaceButtonItem;            //空白按钮
UITextField     *currentTextField;           //当前输入框
}
@property(nonatomic,retain) UIToolbar *view;
-(id)init; 


-(void)setIsInNavigationController:(BOOL)isbool;


-(void)showBar:(UITextField *)textField;

-(void)HiddenKeyBoard;
@end
