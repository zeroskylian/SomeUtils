//
//  UIImage+AddCorner.h
//  可拖拽CollectionView
//
//  Created by KXRT_01 on 2017/4/24.
//  Copyright © 2017年 KXRT_01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AddCorner)
-(UIImage *)kt_drawRectWithRoundedCorner:(CGFloat)radius SizetoFit:(CGSize)sizetoFit;
@end
