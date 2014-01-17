//
//  PlaceMark.m
//  FindPlace
//
//  Created by zuo jianjun on 11-11-29.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import "PlaceMark.h"

@implementation PlaceMark
@synthesize coordinate;
@synthesize name,latitude,longitude,subtitle1;
-(void) dealloc
{
    
    [name release];
    [latitude release];
    [longitude release];
    [subtitle1 release];
    [super dealloc];
}
- (id)initWithCoords:(CLLocationCoordinate2D)coords
{
	if (self == [super init]) {
		coordinate = coords;
	}
	return self;
}
- (NSString *)title
{
    return name;
}

// optional
- (NSString *)subtitle
{
    return subtitle1;
}
@end
