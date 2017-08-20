//
// Created by Alan.li on 2017/8/13.
// Copyright (c) 2017 Alan. All rights reserved.
//

#import "DynamicCircleRender.h"

@interface DynamicCircleRender ()

@end


@implementation DynamicCircleRender


- (instancetype)initWithOverlay:(id<MKOverlay>)overlay {
    self = [super initWithOverlay: overlay];
    if (self) {
        _radius = 0;
    }
    return self;
}



- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    
    //Map
    MKMapPoint mapPoint = MKMapPointForCoordinate(self.overlay.coordinate);
    double radiusAtLatitude = (_radius)*MKMapPointsPerMeterAtLatitude(self.overlay.coordinate.latitude);
    //Screen
    CGPoint center = [self pointForMapPoint:mapPoint];
    //Prepare Draw
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextAddArc(context, center.x, center.y, radiusAtLatitude , 0,  2 * M_PI, 1);
    //Key Draw
    CGContextDrawPath(context, kCGPathFillStroke);
    UIGraphicsPopContext();

}


- (void)updateRadius:(CGFloat)radius {
    _radius = radius;
    [self setNeedsDisplay];
}


@end
