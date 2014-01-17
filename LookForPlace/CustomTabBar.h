//
//  CustomTabBarController.h
//  TestTabbar]
//
//  Created by zuo jianjun on 11-7-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomTabBar : UITabBarController {
	NSMutableArray * buttons;
	int currentSelectedIndex;
	UIImageView   * slideView;
    UILabel * lab;
    UIImageView * imagView;
    NSArray * nameArr;
}
@property (nonatomic ,retain)  NSMutableArray * buttons;
@property (nonatomic ,retain)  UIImageView    * slideView;
@property (nonatomic ,assign)  int   currentSelectedIndex;
-(void) hidesTabBar;
-(void) customTabBar;
-(void) selectedTabBarItem:(UIButton *) button;
-(void) changePick;
@end
