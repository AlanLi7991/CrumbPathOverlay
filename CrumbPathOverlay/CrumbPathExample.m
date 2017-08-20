//
//  CrumbPathExample.m
//  MapBox
//
//  Created by Alan.li on 2017/8/19.
//  Copyright © 2017年 Alan. All rights reserved.
//

#import "CrumbPathExample.h"
#import "CrumbPathRender.h"

@interface CrumbPathExample()

@end

@implementation CrumbPathExample

- (void)setupMap {
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _mapView = mapView;
    [_mapView setDelegate:self];
}


- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    if ([overlay isKindOfClass:[CrumbPathOverlay class]]) {
        MKOverlayRenderer *render = [mapView rendererForOverlay:overlay];
        if(!render) {
            render = [[CrumbPathRender alloc] initWithOverlay:overlay];
            _path = (CrumbPathRender *)render;
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
 Crumb Path Overlay Example
 */
- (void)addCrumbOverlay {
    _pathCoordinate = [self randomCoordinate];
    CrumbPathOverlay *overlay = [[CrumbPathOverlay alloc] initWithOrigin:CrumbPointMake(_pathCoordinate,0)];
    _pathOverlay = overlay;
    [_mapView addOverlay:overlay];
}


- (void)addCrumbPoint {
    _pathCoordinate.latitude += 0.01;
    _pathCoordinate.longitude += 0.01;
    CGFloat scale = _pathOverlay.points[_pathOverlay.pointsCount-1].scale;
    scale = scale < 1 ? scale+0.1:scale-0.1;
    [_pathOverlay addCoordinate:CrumbPointMake(_pathCoordinate,scale)];
}

- (void)testCrumbPath {
    if(_path) {
        [self addCrumbPoint];
    }else {
        [self addCrumbOverlay];
    }
}





@end
