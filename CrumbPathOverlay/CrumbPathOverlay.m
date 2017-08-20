//
//  CrumbPathOverlay.m
//  DJI-AppGround
//
//  Created by Alan.li on 8/18/17.
//  Copyright © 2017 DJI. All rights reserved.
//

#import <pthread.h>
#import "CrumbPathOverlay.h"

#define INITIAL_POINT_SPACE 1000
#define MINIMUM_DELTA_METERS 10.0

@interface CrumbPathOverlay()

@property (nonatomic, assign) MKMapRect boundingRect;
@property (nonatomic, assign) pthread_rwlock_t rwLock;
@property (nonatomic, assign) NSUInteger pointSpace;

@end

@implementation CrumbPathOverlay




- (instancetype)initWithOrigin:(CrumbPoint)point {
    self = [super init];
    if (self) {
        _pointSpace = INITIAL_POINT_SPACE;
        _pointsCount = 1;
        _points = malloc(sizeof(CrumbPoint)*_pointSpace);
        _points[0] = point;
        _boundingRect = [self worldRectWithCenter:_points[0].coordinate];
        pthread_rwlock_init(&_rwLock,NULL);

    }
    return self;}


- (CLLocationCoordinate2D)coordinate {
    return _points[0].coordinate;
}

- (MKMapRect)boundingMapRect {
    return _boundingRect;
}


- (MKMapRect)worldRectWithCenter:(CLLocationCoordinate2D)coordinate {
    MKMapPoint center = MKMapPointForCoordinate(coordinate);
    double width = MKMapSizeWorld.width/4;
    double height = MKMapSizeWorld.height/4;
    MKMapPoint origin = MKMapPointMake(center.x - width/2, center.y - height/2);

    return MKMapRectMake(origin.x, origin.y, width , height);

}


-(void)dealloc{
    free(_points);
    pthread_rwlock_destroy(&_rwLock);
}



#pragma mark - Point add

- (void)addCoordinate:(CrumbPoint)point {
    //LOCK Thread because we are going to changing the list of points
    pthread_rwlock_wrlock(&_rwLock);

    //receive new point and previous point
    MKMapPoint newPoint = MKMapPointForCoordinate(point.coordinate);
    MKMapPoint prevPoint = MKMapPointForCoordinate(_points[_pointsCount-1].coordinate);


    //Get the distance between this new point and previous point
    CLLocationDistance metersApart = MKMetersBetweenMapPoints(newPoint, prevPoint);
    MKMapRect updateRect = MKMapRectNull;

    if (metersApart > MINIMUM_DELTA_METERS){
        //Grow (multiply 2) the points array if full
        if (_pointSpace == _pointsCount){
            _pointSpace *= 2;
            _points = realloc(_points, sizeof(CrumbPoint) * _pointSpace);
        }

        //Add the new point to points array
        _points[_pointsCount] = point;
        _pointsCount++;

        //Compute MKMapRect bounding prevPoint and newPoint
        double minX = MIN(newPoint.x,prevPoint.x);
        double minY = MIN(newPoint.y,prevPoint.y);
        double maxX = MAX(newPoint.x, prevPoint.x);
        double maxY = MAX(newPoint.y, prevPoint.y);
        
        updateRect = MKMapRectMake(minX, minY, maxX - minX, maxY - minY);
    }
    //UNLOCK Thread
    pthread_rwlock_unlock(&_rwLock);

    //Make Update Display
    if (_render) {
        [_render setNeedsDisplayInMapRect:updateRect];
    }
}




#pragma mark - Thread Lock

- (void)lockPointArray {
    pthread_rwlock_rdlock(&_rwLock);
}

- (void)unlockPointArray {
    pthread_rwlock_unlock(&_rwLock);
}

@end
