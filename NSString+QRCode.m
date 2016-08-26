//
//  NSString+QRCode.m
//  UIButtonMutablieClick
//
//  Created by KXRT_01 on 16/8/26.
//  Copyright © 2016年 andson. All rights reserved.
//

#import "NSString+QRCode.h"


@implementation NSString (QRCode)
-(UIImage *)qrcodeImageWithSize:(CGFloat)size

{
    
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建filter
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //设置内容和纠错级别
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    
    [qrFilter setValue:@"M"forKey:@"inputCorrectionLevel"];
    
    //等到一个矩形
    
    CGRect extent = CGRectIntegral(qrFilter.outputImage.extent);
    
    //得出缩放倍数
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //得出大小
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    //创建一个灰度图
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    //创建一个bitmap
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height,8,0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    //获取cicontext
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:qrFilter.outputImage fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return[UIImage imageWithCGImage:scaledImage];
    
}

@end
