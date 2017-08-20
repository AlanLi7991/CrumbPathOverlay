//
// Created by Alan.li on 8/18/17.
// Copyright (c) 2017 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "CrumbPathOverlay.h"


@interface CrumbPathRender : MKOverlayPathRenderer

- (instancetype)initWithOverlay:(CrumbPathOverlay *)overlay;

@property (nonatomic, assign) CGFloat beginHue;
@property (nonatomic, assign) CGFloat endHue;
@property (nonatomic, assign) CGFloat minScreenPointDelta;

@end
