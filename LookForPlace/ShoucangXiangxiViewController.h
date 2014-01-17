//
//  ShoucangXiangxiViewController.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-11.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PlaceMessage;
@interface ShoucangXiangxiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (retain, nonatomic) IBOutlet UITableView *myTableView;
@property (nonatomic,retain) PlaceMessage * place;
- (IBAction)backButton:(id)sender;
@end
