//
//  YijianViewController.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-11.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YijianViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
{
    NSURLConnection * conn;
    NSMutableData * webData;
    BOOL backJianpan;
    
    UIToolbar * toolBar;
    IBOutlet UILabel *dingweilable;
}
@property (retain, nonatomic) IBOutlet UILabel *zishuLable;
@property (retain, nonatomic) IBOutlet UITextView *textView1;
@property (retain, nonatomic) IBOutlet UITextField *youxianText;

- (IBAction)backButton:(id)sender;
- (IBAction)tijiaoButton:(id)sender;
- (IBAction)getBack:(id)sender;
- (IBAction)ress:(id)sender;
@end
