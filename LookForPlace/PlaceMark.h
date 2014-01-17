//
//  PlaceMark.h
//  FindPlace
//
//  Created by zuo jianjun on 11-11-29.
//  Copyright (c) 2011年 ibokanwisdom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PlaceMark : NSObject<MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *subtitle1;
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property(nonatomic,readonly)CLLocationCoordinate2D coordinate;
- (id)initWithCoords:(CLLocationCoordinate2D)coords;

@end
