//
//  MyDanLi.h
//  LookForPlace
//
//  Created by ibokan on 12-1-9.
//  Copyright 2012年 ibokanwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Head_import.h"
@class DingweiViewController;

@interface NSString(Uincode)
//参数char * str 返回NSString
+(NSString *) stringWithUniCode:(char *) str Length:(int) length;
@end

@interface MyDanLi : NSObject<MSearchDelegate>
{
    DingweiViewController *dingwei;
    NSMutableArray *array2;
}

@property (retain,nonatomic)DingweiViewController *dingwei;
@property (retain,nonatomic)NSMutableArray *array2;
@property (assign,nonatomic) CLLocationDegrees lon,lat;

-(void)searchBarString:(NSString *)sender;

+(MyDanLi *)dingWeiVC;

@end
