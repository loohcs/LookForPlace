//
//  JiexiNowjiwe.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-23.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol dailiNow 

-(void) chuanNowjinwei:(NSDictionary *) nowDic;

@end

@interface JiexiNowjiwe : NSObject
{
    NSURLConnection * conn;//附近接口链接
    NSMutableData * aData;//附近信息
    
    //当前位置和重新定位时得网络请求地址
    NSURLRequest *request1;
    
}
@property (nonatomic,retain)NSURLRequest *request1;
@property (nonatomic ,assign) id<dailiNow> delegate;
-(void) getUrl:(NSURL *) url;
@end
