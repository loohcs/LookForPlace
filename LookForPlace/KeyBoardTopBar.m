//
//  KeyBoardTopBar.m
//  Huishoujianpan
//
//  Created by zuo jianjun on 11-12-22.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "KeyBoardTopBar.h"

@implementation KeyBoardTopBar
@synthesize view;

//初始化控件和变量

-(id)init{
    
    if((self = [super init])) {
        
        hiddenButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"隐藏键盘" style:UIBarButtonItemStyleBordered target:self action:@selector(HiddenKeyBoard)];
        
        spaceButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        view = [[UIToolbar alloc] initWithFrame:CGRectMake(0,480,320,44)];
        
        view.barStyle = UIBarStyleBlackTranslucent;
        
        view.items = [NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil];
        textFields = nil;
        isInNavigationController = YES;
        currentTextField = nil;
    }
    
    return self;
    
}
//设置是否在导航视图中
-(void)setIsInNavigationController:(BOOL)isbool{
    isInNavigationController = isbool;
}

//显示工具条
-(void)showBar:(UITextField *)textField{
    currentTextField = textField;
    [view setItems:[NSArray arrayWithObjects:spaceButtonItem,hiddenButtonItem,nil]];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:)name:UIKeyboardWillShowNotification object:nil];
}

-(void)keyboardWillShow:(NSNotification*)notification{
    
    NSDictionary*info=[notification userInfo];
    CGSize kbSize=[[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;    

    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    if (isInNavigationController) {
        view.frame = CGRectMake(0, 460-kbSize.height-44-40, 320, 44);
    }
    else {
        view.frame = CGRectMake(0, 460-kbSize.height-44, 320, 44);
    }
    [UIView commitAnimations];
}

//隐藏键盘和工具条

-(void)HiddenKeyBoard{
    
    if (currentTextField!=nil) {
        
        [currentTextField  resignFirstResponder];
        
    }
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.3];
    
    view.frame = CGRectMake(0, 480, 320, 44);
    
    [UIView commitAnimations];
    
}

- (void)dealloc {
    
    [view release];
    
    [textFields release];
    
    [prevButtonItem release];
    
    [nextButtonItem release];
    
    [hiddenButtonItem release];
    
    [currentTextField release];
    
    [spaceButtonItem release];
    
    [super dealloc];
    
}
@end
