//
//  WSPieItemsView.m
//  PieChart
//
//  Created by iMac on 17/2/7.
//  Copyright © 2017年 zws. All rights reserved.
//

#import "WSPieItemsView.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface WSPieItemsView ()

@property (nonatomic,assign) CGFloat beginAngle;
@property (nonatomic,assign) CGFloat endAngle;
@property (nonatomic,strong) UIColor * fillColor;
@property (nonatomic,strong) CAShapeLayer * shapeLayer;
@end
@implementation WSPieItemsView
-(WSPieItemsView *)initWithFrame:(CGRect)frame andBeginAngle:(CGFloat)beginAngle andEndAngle:(CGFloat)endAngle andFillColor:(UIColor *)fillColor{
    
    if (self = [super initWithFrame:frame]) {
        _beginAngle = beginAngle;
        _endAngle = endAngle;
        _fillColor = fillColor;
        
        [self configBaseLayer];
        
    }
    return self;
}

- (void)configBaseLayer{
    _shapeLayer = [CAShapeLayer layer];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint center = CGPointMake(self.frame.size.width/2.0, self.frame.size.height/2.0);
    CGFloat radius = MIN(self.frame.size.width, self.frame.size.height) / 2.0f;


    [path appendPath:[UIBezierPath bezierPathWithArcCenter:center               //外圆
                                                    radius:radius-15
                                                startAngle:_beginAngle
                                                  endAngle:_endAngle
                                                 clockwise:YES]];
    NSLog(@"%f  %f",_beginAngle*360,_endAngle/M_PI/2*360);

//    CGPoint point2;                     //结束圆
//    point2 =[self calcCircleCoordinateWithCenter:center andWithAngle:360-_endAngle/M_PI/2*360 andWithRadius:radius - 15];
//    [path addArcWithCenter:point2
//                    radius:15
//                startAngle:_endAngle
//                  endAngle:_endAngle-M_PI
//                 clockwise:YES];

 
    
//    [path addArcWithCenter:center
//                    radius:radius-30
//                startAngle:_endAngle
//                  endAngle:_beginAngle
//                 clockwise:NO];        //内圆
//
//    //开始端点
//    CGPoint point;
////
//    point =[self calcCircleCoordinateWithCenter:center andWithAngle:360-_beginAngle/M_PI/2*360 andWithRadius:radius - 15];
//    [path addArcWithCenter:point
//                    radius:15
//                startAngle:_beginAngle-M_PI
//                  endAngle:_beginAngle
//                 clockwise:NO];
    //结束端点
 

 
    _shapeLayer.path = path.CGPath;
    _shapeLayer.lineWidth = 30;
    _shapeLayer.strokeColor = _fillColor.CGColor;
    _shapeLayer.fillColor = [UIColor clearColor].CGColor;
//    _shapeLayer.lineCap = kCALineCapRound;
//    _shapeLayer.lineJoin = CAShapeLayerLineJoin;
//    [_shapeLayer setLineJoin:kCALineJoinRound];
 
    _shapeLayer.borderColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_shapeLayer];
 
//    CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    basic.duration = 1.1;
//    basic.fromValue = @(0.1f);
//    basic.toValue = @(1.0f);
//    [_shapeLayer addAnimation:basic forKey:@"basic"];
    
    
}

-(CGPoint)calcCircleCoordinateWithCenter:(CGPoint) center  andWithAngle : (CGFloat) angle andWithRadius: (CGFloat) radius{
    CGFloat x2 = radius*cosf(angle*M_PI/180);
    CGFloat y2 = radius*sinf(angle*M_PI/180);
    return CGPointMake(center.x+x2, center.y-y2);
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"touch%ld",self.tag);
    
}

@end
