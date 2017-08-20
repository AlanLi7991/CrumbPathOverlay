//
// Created by Alan.li on 2017/8/13.
// Copyright (c) 2017 Alan. All rights reserved.
//

#import "DynamicCircleOverly.h"

@interface DynamicCircleOverly ()

@property (nonatomic, assign) CLLocationCoordinate2D center;
@property (nonatomic, assign) MKMapRect mapRect;

@end


@implementation DynamicCircleOverly


- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    if (self) {
        _center = coordinate;
        _mapRect = [self worldRectWithCenter:coordinate];
        
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    if(MKMapRectEqualToRect(_mapRect, MKMapRectNull)) {
        _mapRect = [self worldRectWithCenter:self.coordinate];
    }
    return _center;
}

- (MKMapRect)boundingMapRect {
    return _mapRect;
}

- (MKMapRect)worldRectWithCenter:(CLLocationCoordinate2D)coordinate {
    MKMapPoint center = MKMapPointForCoordinate(coordinate);
    double width = MKMapSizeWorld.width/2;
    double height = MKMapSizeWorld.height/2;
    MKMapPoint origin = MKMapPointMake(center.x - width/2, center.y - height/2);
    
    return MKMapRectMake(origin.x, origin.y, width , height);
    
}

@end
