//
//  PlaceData.h
//  LookForPlace
//
//  Created by yy c on 12-1-12.
//  Copyright 2012年 ibokanwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceData : NSObject

@property(nonatomic,retain) NSString *cname,*caddress;
@property(nonatomic,retain) NSNumber *x,*y;
@property(nonatomic,assign) double distance;

+(id) GPSPointWithX:(NSNumber *) cx Y:(NSNumber *) cy basePoint:(NSArray *) point  cname:(NSString *)name caddress:(NSString *)address;
-(id) initWithX:(NSNumber *) cx Y:(NSNumber *) cy basePoint:(NSArray *) point  cname:(NSString *)name caddress:(NSString *)address;
- (NSComparisonResult)compare:(PlaceData *)otherPoint;


@end
