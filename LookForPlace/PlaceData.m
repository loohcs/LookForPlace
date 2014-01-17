//
//  PlaceData.m
//  LookForPlace
//
//  Created by yy c on 12-1-12.
//  Copyright 2012年 ibokanwisdom. All rights reserved.
//

#import "PlaceData.h"

@implementation PlaceData
@synthesize x,y,cname,caddress,distance;

+(id) GPSPointWithX:(NSNumber *) cx Y:(NSNumber *) cy basePoint:(NSArray *) point  cname:(NSString *)name caddress:(NSString *)address
{
    return [[[self alloc] initWithX:cx Y:cy basePoint:point cname:name caddress:address] autorelease];
}
-(id) initWithX:(NSNumber *) cx Y:(NSNumber *) cy basePoint:(NSArray *) point  cname:(NSString *)name caddress:(NSString *)address
{
    if ((self = [super init])) {
        self.x = cx;
        self.y = cy;
        self.cname = name;
        self.caddress = address;
        NSString *strX = [point objectAtIndex:0];
        NSString *strY = [point objectAtIndex:1];
        
        
        self.distance = sqrtf(([self.x floatValue]-[strX floatValue])*([self.x floatValue]-[strX floatValue])+([self.y floatValue]-[strY floatValue])*([self.y floatValue]-[strY floatValue]));
      
    }
    return self;
}

- (NSComparisonResult)compare:(PlaceData *)otherPoint
{
    if (self.distance>otherPoint.distance) {
        return NSOrderedDescending;
        
    }else
    {
        return NSOrderedAscending;
    }
}

-(NSString *) description
{
    return [NSString stringWithFormat:@"x:%@ y:%@ distance:%.2f  name = %@  address = %@",self.x,self.y,self.distance,self.cname,self.caddress];
}

- (void) dealloc
{
    self.x = nil;
    self.y = nil;
    self.caddress = nil;
    self.cname = nil;
    [super dealloc];
}

@end
