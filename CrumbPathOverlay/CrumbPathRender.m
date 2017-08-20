//
// Created by Alan.li on 8/18/17.
// Copyright (c) 2017 DJI. All rights reserved.
//

#import "CrumbPathRender.h"


@interface CrumbPathRender ()

@property (nonatomic, weak) CrumbPathOverlay *crumb;
@property (nonatomic, assign) CGFloat hueRange;

@end


@implementation CrumbPathRender


- (instancetype)initWithOverlay:(CrumbPathOverlay *)overlay {
    self = [super initWithOverlay:overlay];
    if (self){
        _crumb = overlay;
        _beginHue = 0.3;
        _endHue = 0.03;
        _minScreenPointDelta = 5.0;
        _hueRange = _beginHue - _endHue;
        _crumb.render = self;
        self.fillColor = [UIColor blueColor];
        self.lineWidth = 5;
    }
    return self;
}


- (id<MKOverlay>)overlay {
    return _crumb;
}

- (BOOL)canDrawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale {
    return _crumb?YES:NO;
}

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)context {
    
    //Lock Add 
    [_crumb lockPointArray];

    //Prepare ClipRect
    CGFloat lineWidth = self.lineWidth;
    lineWidth = lineWidth / zoomScale;
    MKMapRect clipRect = MKMapRectInset(mapRect, -lineWidth, -lineWidth);
    

    //Make Limit Distance
    double minMapPointDelta = pow(_minScreenPointDelta / zoomScale,2);
    
    //For to Add
    CrumbPoint point,prevPoint = _crumb.points[0];
    for (int i = 1;i < _crumb.pointsCount;i++){
        point = _crumb.points[i];
        CGMutablePathRef path = CGPathCreateMutable();
        
        
        //Convert Map Point
        MKMapPoint mapPoint = MKMapPointForCoordinate(point.coordinate);
        MKMapPoint prevMapPoint = MKMapPointForCoordinate(prevPoint.coordinate);
        
        //Check Delta
        double pointDelta = pow(mapPoint.x - prevMapPoint.x,2) + pow(mapPoint.y - prevMapPoint.y,2);
        if (pointDelta < minMapPointDelta && i < _crumb.pointsCount - 1) {
            prevPoint = point;
            continue;
        }
        
        //Check Area
        if ([CrumbPathRender linePoint:mapPoint and:prevMapPoint intersectsRect:clipRect]) {
            //Add Line
            CGPoint startPoint = [self pointForMapPoint:mapPoint];
            CGPoint endPoint = [self pointForMapPoint:prevMapPoint];
            CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
            CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
            //Save State
            CGContextSaveGState(context);
            //Line Prepare
            CGPathRef pathToFill = CGPathCreateCopyByStrokingPath(path, NULL, lineWidth, self.lineCap, self.lineJoin, self.miterLimit);
            CGContextAddPath(context, pathToFill);
            CGContextClip(context);
            //Color Prepare
            UIColor *startColor, *endColor;
            if(point.scale == CGFLOAT_MAX) {
                startColor = self.fillColor;
                endColor = self.fillColor;
            } else {
                CGFloat scale =  [CrumbPathRender distributeScale:prevPoint.scale];
                startColor = [CrumbPathRender hueColor:_beginHue - scale *_hueRange];
                scale =  [CrumbPathRender distributeScale:point.scale];
                endColor = [CrumbPathRender hueColor:_beginHue - scale*_hueRange];
            }

            CGGradientRef gradient = [CrumbPathRender lineColorGradient:startColor and:endColor];
            //Add Color
            CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsAfterEndLocation);
            //Release Color
            CGGradientRelease(gradient);
            //Return State for Next
            CGContextRestoreGState(context);
        }
        prevPoint = point;
        CGPathRelease(path);
    }
    [_crumb unlockPointArray];
}


+ (CGFloat)distributeScale:(CGFloat)scale {
    CGFloat temp = scale;
    temp = temp > 1? 1: (temp < 0 ? 0 : temp);
    return temp;
}

+ (UIColor *)hueColor:(CGFloat)hue {
    return [UIColor colorWithHue:hue saturation:1.0f brightness:1.0f alpha:1.0f];
}


+ (BOOL)linePoint:(MKMapPoint)p0 and:(MKMapPoint)p1 intersectsRect:(MKMapRect) r {
    double minX = MIN(p0.x, p1.x);
    double minY = MIN(p0.y, p1.y);
    double maxX = MAX(p0.x, p1.x);
    double maxY = MAX(p0.y, p1.y);
    
    MKMapRect r2 = MKMapRectMake(minX, minY, maxX - minX, maxY - minY);
    return MKMapRectIntersectsRect(r, r2);
}

+ (CGGradientRef)lineColorGradient:(UIColor *)startColor and:(UIColor *)endColor {
    //Color Prepare
    CGFloat pc_r,pc_g,pc_b,pc_a, cc_r,cc_g,cc_b,cc_a;
    [startColor getRed:&pc_r green:&pc_g blue:&pc_b alpha:&pc_a];
    [endColor getRed:&cc_r green:&cc_g blue:&cc_b alpha:&cc_a];
    CGFloat gradientColors[8] = {pc_r,pc_g,pc_b,pc_a, cc_r,cc_g,cc_b,cc_a};
    CGFloat gradientLocation[2] = {0,1};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, gradientColors, gradientLocation, 2);
    CGColorSpaceRelease(colorSpace);
    return gradient;
}

@end
