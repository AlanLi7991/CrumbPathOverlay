//
//  CrumbPathExample.m
//  MapBox
//
//  Created by Alan.li on 2017/8/19.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import "DynamicCircleExample.h"
#import "DynamicCircleRender.h"
#import "DynamicCircleOverly.h"

@implementation DynamicCircleExample


- (void)setupMap {
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mapView = mapView;
    [_mapView setDelegate:self];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[DynamicCircleOverly class]]) {
        MKOverlayRenderer *render = [mapView rendererForOverlay:overlay];
        if(!render) {
            render = [[DynamicCircleRender alloc] initWithOverlay:overlay];
            _render = (DynamicCircleRender *)render;
        }
        return render;
    }
    return nil;
}


/**
 Genreate Coordinate
 */
- (CLLocationCoordinate2D)randomCoordinate {
    return CLLocationCoordinate2DMake(31, 121);
}

/**
 Dynamic Circle Overlay Example
 */
- (void)dynamicOverlay {
    DynamicCircleOverly *overlay = [[DynamicCircleOverly alloc] initWithCoordinate:[self randomCoordinate]];
    [_mapView addOverlay:overlay];
}

- (void)updateCircleRadius {
    [_render updateRadius:_render.radius + 50];
}

- (void)testDynamicCircle {
    if(_render) {
        [self updateCircleRadius];
    }else {
        [self dynamicOverlay];
    }
}



@end
