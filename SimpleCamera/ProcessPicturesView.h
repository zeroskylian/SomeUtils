//
//  ProcessPicturesView.h
//  ExampleProject
//
//  Created by 廉鑫博 on 2017/8/28.
//  Copyright © 2017年 廉鑫博. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TakePhoto)(BOOL sure);

@interface ProcessPicturesView : UIView

@property (strong, nonatomic)UIImage *image;

@property (copy, nonatomic)TakePhoto takePhoto;
@end
