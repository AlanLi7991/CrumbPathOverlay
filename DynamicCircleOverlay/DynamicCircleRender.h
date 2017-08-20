//
// Created by Alan.li on 2017/8/13.
// Copyright (c) 2017 Alan. All rights reserved.
//

#import <MapKit/MapKit.h>


@interface DynamicCircleRender : MKOverlayRenderer

@property (nonatomic, readonly) CGFloat radius;


- (void)updateRadius:(CGFloat)radius;

@end
