//
//  CrumbPathExample.h
//  MapBox
//
//  Created by Alan.li on 2017/8/19.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class DynamicCircleRender;

@interface DynamicCircleExample : NSObject <MKMapViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) DynamicCircleRender *render;


@end
