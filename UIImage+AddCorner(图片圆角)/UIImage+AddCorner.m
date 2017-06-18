//
//  UIImage+AddCorner.m
//  可拖拽CollectionView
//
//  Created by KXRT_01 on 2017/4/24.
//  Copyright © 2017年 KXRT_01. All rights reserved.
//

#import "UIImage+AddCorner.h"

@implementation UIImage (AddCorner)
-(UIImage *)kt_drawRectWithRoundedCorner:(CGFloat)radius SizetoFit:(CGSize)sizetoFit
{
    CGRect rect = CGRectMake(0, 0, sizetoFit.width, sizetoFit.height);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen.scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
    UIImage * output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return output;
}
@end
