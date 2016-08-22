//
//  DrawSomeGraphical.m
//  temp
//
//  Created by KXRT_01 on 16/8/3.
//  Copyright © 2016年 KXRT. All rights reserved.
//

#import "DrawSomeGraphical.h"
#import <QuartzCore/QuartzCore.h>


@implementation DrawSomeGraphical

+(void)drawDashLine:(UIView *)lineView lineLength:(float)lineLength lineSpacing:(float)lineSpacing lineColor:(UIColor *)lineColor positionStartPoint:(CGPoint)startpoint endPoint:(CGPoint)endPoint{
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    //    shapeLayer.frame = lineView.frame;
    //    [shapeLayer setBounds:dr.bounds];
    /**
     *  如果设置Position这个属性那么起点（x,y）就会加上position的值
     */
    //    [shapeLayer setPosition:CGPointMake(50, 50)];
    
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置虚线颜色为blackColor [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
    [shapeLayer setStrokeColor:[lineColor CGColor]];
    // 3.0f设置虚线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 3=线的宽度 1=每条线的间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithFloat:lineLength],[NSNumber numberWithFloat:lineSpacing],nil]];
    // Setup the path
    CGMutablePathRef pathLine = CGPathCreateMutable();
    //起点
    CGPathMoveToPoint(pathLine, NULL, startpoint.x, startpoint.y);
    //终点 后面可继续加点
    CGPathAddLineToPoint(pathLine, NULL, endPoint.x,endPoint.y);
    
    [shapeLayer setPath:pathLine];
    CGPathRelease(pathLine);
    
    [lineView.layer addSublayer:shapeLayer] ;
    
}

/**
 *  绘制矩形
 *
 *  注意 ：要放入view的drawRect方法中
 *  @param view       目标view
 *  @param lineWidth  矩形边宽度
 *  @param lineColor  矩形边的颜色
 *  @param startpoint 起点
 *  @param longLength 长
 *  @param wideLength 宽
 */
+(void)drawRectangle:(UIView *)view lineWidth:(float)lineWidth lineColor:(UIColor *)lineColor positionStartPoint:(CGPoint)startpoint  longLength:(float)longLength wideLength:(float)wideLength{
    //画矩形
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
    CGContextSetLineWidth(ctx, lineWidth);
    CGPoint poins[] = {startpoint,CGPointMake(startpoint.x + longLength, startpoint.y),CGPointMake(startpoint.x + longLength, startpoint.y + wideLength),CGPointMake(startpoint.x, startpoint.y + wideLength)};
    CGContextAddLines(ctx,poins,4);
    CGContextClosePath(ctx);
    CGContextStrokePath(ctx);

}

/**
 *  绘制弧形
 *
 *  注意 ：要放入view的drawRect方法中
 *  @param view       目标view
 *  @param lineWidth  弧形宽度
 *  @param lineColor  弧形颜色
 *  @param startpoint 弧形中心点
 *  @param radius     弧形半径
 *  @param startAngle 弧形起始弧度
 *  @param endAngle   弧形终止弧度 M_PI
 */

+(void)drawCircular:(UIView *)view lineWidth:(float)lineWidth lineColor:(UIColor *)lineColor positionCenterPoint:(CGPoint)startpoint  radius:(float)radius startAngle:(float)startAngle endAngle:(float)endAngle{
    
    [[UIColor blueColor] setStroke];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:startpoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [path stroke];
    
}



@end
