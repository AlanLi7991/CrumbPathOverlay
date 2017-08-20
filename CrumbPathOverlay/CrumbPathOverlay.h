//
//  CrumbPathOverlay.h
//  DJI-AppGround
//
//  Created by Alan.li on 8/18/17.
//  Copyright © 2017 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef struct {
    CLLocationCoordinate2D coordinate;
    CGFloat scale;
}CrumbPoint;


CG_INLINE CrumbPoint CrumbPointMake(CLLocationCoordinate2D coordinate, CGFloat scale) {
    CrumbPoint point;
    point.coordinate = coordinate;
    point.scale = scale;
    return point;
}

@interface CrumbPathOverlay : NSObject <MKOverlay>

@property (nonatomic, weak) MKOverlayRenderer *render;
@property (nonatomic, readonly) CrumbPoint *points;
@property (nonatomic, readonly) NSUInteger pointsCount;

- (instancetype)initWithOrigin:(CrumbPoint)point;

- (void)addCoordinate:(CrumbPoint)point;
- (void)lockPointArray;
- (void)unlockPointArray;

@end
