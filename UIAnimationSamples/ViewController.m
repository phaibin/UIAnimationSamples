//
//  ViewController.m
//  UIAnimationSamples
//
//  Created by Leon on 12-12-25.
//  Copyright (c) 2012年 Leon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
{
    BOOL _isRotating;
    float _startAngle;
    NSTimer *_rotateTimer;
    BOOL _clockWise;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch begin");
    UITouch *touch = [touches anyObject];
    if ([touch view] == self.imageView) {
        _isRotating = YES;
        CGPoint point = [touch locationInView:self.view];
        _startAngle = [self angleBetweenCenterAndPoint:point];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isRotating) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self.view];
        float angle = [self angleBetweenCenterAndPoint:point];
        
        if (angle > _startAngle)
            _clockWise = YES;
        else
            _clockWise = NO;
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, (angle-_startAngle)*M_PI/180);
        _startAngle = angle;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    _isRotating = NO;
    float stopAngle = 160*M_PI/180;
    if (!_clockWise)
        stopAngle = -stopAngle;
    [UIView animateWithDuration:1 delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut) animations:^{
        self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, stopAngle);
    } completion:nil];
}

- (float)angleFromPoint:(CGPoint)startPoint toPoint:(CGPoint)endPoint
{
    return atan2(endPoint.y-startPoint.y, endPoint.x-startPoint.x) * M_PI / 180 * (endPoint.x/ABS(endPoint.x)) * (endPoint.y/ABS(endPoint.y));
}

- (float)angleBetweenCenterAndPoint:(CGPoint)point
{
    CGPoint center = self.imageView.center;
    
	// Yes, the arguments to atan2() are in the wrong order. That's because our
	// coordinate system is turned upside down and rotated 90 degrees. :-)
    return atan2(point.x - center.x, center.y - point.y) * 180.0f/M_PI;
}

@end
