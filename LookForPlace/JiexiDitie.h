//
//  JiexiDitie.h
//  LookForPlace
//
//  Created by zuo jianjun on 11-12-18.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol dailiDitie 

-(void) chuanDitie:(NSDictionary *) dic;

@end

@interface JiexiDitie : NSObject
{
    NSURLConnection * conn;//地铁接口链接
    NSMutableData * webData;//地铁信息
}
@property (nonatomic,assign) id<dailiDitie> delegate;
-(void) getDitieUrl:(NSURL *) url post:(NSString *) str;
@end
