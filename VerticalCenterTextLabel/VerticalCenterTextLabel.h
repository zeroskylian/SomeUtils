//
//  VerticalCenterTextLabel.h
//  TestLogin
//
//  Created by KXRT_01 on 2016/11/30.
//  Copyright © 2016年 KXRT_01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    VerticalAlignmentTop  = 0,
    VerticalAlignmentCenter,
    VerticalAlignmentBottom
} VerticalAlignment;

@interface VerticalCenterTextLabel : UILabel
@property (nonatomic) UIEdgeInsets edgeInsets;

/**
 *  对齐方式
 */
@property (nonatomic) VerticalAlignment verticalAlignment;

@end
