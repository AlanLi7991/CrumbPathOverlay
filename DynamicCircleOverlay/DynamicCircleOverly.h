//
// Created by Alan.li on 2017/8/13.
// Copyright (c) 2017 Alan. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface DynamicCircleOverly : MKShape <MKOverlay>

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
