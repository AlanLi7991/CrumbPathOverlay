//
//  CrumbPathExample.h
//  MapBox
//
//  Created by Alan.li on 2017/8/19.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class CrumbPathOverlay;
@class CrumbPathOverlay;
@class CrumbPathRender;

@interface CrumbPathExample : NSObject <MKMapViewDelegate>

@property (nonatomic, weak) MKMapView *mapView;
@property (nonatomic, strong) CrumbPathRender *path;
@property (nonatomic, strong) CrumbPathOverlay *pathOverlay;
@property (nonatomic, assign) CLLocationCoordinate2D pathCoordinate;

@end
