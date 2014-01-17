//
//  JiexiGuanjianzi.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-23.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol dailiGuanjianzi 

-(void) chuanDGuanjianxinxi:(NSDictionary *) guanjian;

@end

@interface JiexiGuanjianzi : NSObject
{
    NSURLConnection * conn;//附近接口链接
    NSMutableData * aData;//附近信息
}
@property (nonatomic ,assign) id<dailiGuanjianzi> delegate;
-(void) getUrl:(NSURL *) url;

@end
