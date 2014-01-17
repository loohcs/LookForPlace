//
//  MoreViewController.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-10.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoreViewController : UIViewController
{
    IBOutlet UILabel *xinLable;
    IBOutlet UILabel *yiLable;
    IBOutlet UILabel *daoLable;
    IBOutlet UILabel *banLable;
    IBOutlet UILabel *diwenLable;
}

- (IBAction)pushXinshou:(id)sender;
- (IBAction)pushYijian:(id)sender;
- (IBAction)pushAppstore:(id)sender;
- (IBAction)pushBanben:(id)sender;

- (IBAction)backButton:(id)sender;
@end
