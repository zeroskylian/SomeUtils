//
//  DrawSomeGraphical.h
//  temp
//
//  Created by KXRT_01 on 16/8/3.
//  Copyright © 2016年 KXRT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DrawSomeGraphical : NSObject
/**
 *  绘制虚线
 *
 *  @param lineView    目标view
 *  @param lineLength  虚线长度
 *  @param lineSpacing 虚线之间的距离
 *  @param lineColor   虚线颜色
 *  @param point       起点
 */
+(void)drawDashLine:(UIView *)lineView lineLength:(float)lineLength lineSpacing:(float)lineSpacing lineColor:(UIColor *)lineColor positionStartPoint:(CGPoint)startpoint endPoint:(CGPoint)endPoint;



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
+(void)drawRectangle:(UIView *)view lineWidth:(float)lineWidth lineColor:(UIColor *)lineColor positionStartPoint:(CGPoint)startpoint  longLength:(float)longLength wideLength:(float)wideLength;


/**
 *  绘制弧形
 *
 *  注意 ：要放入view的drawRect方法中
 *  @param view       目标view
 *  @param lineWidth  弧形宽度
 *  @param lineColor  弧形颜色
 *  @param startpoint 弧形中心点
 *  @param radius     弧形半径
 *  @param startAngle 弧形起始角度
 *  @param endAngle   弧形终止角度
 */

+(void)drawCircular:(UIView *)view lineWidth:(float)lineWidth lineColor:(UIColor *)lineColor positionCenterPoint:(CGPoint)startpoint  radius:(float)radius startAngle:(float)startAngle endAngle:(float)endAngle;
@end
