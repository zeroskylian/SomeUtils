//
//  ProcessPicturesView.m
//  ExampleProject
//
//  Created by 廉鑫博 on 2017/8/28.
//  Copyright © 2017年 廉鑫博. All rights reserved.
//

#import "ProcessPicturesView.h"

@interface ProcessPicturesView ()

@property (strong, nonatomic)UIImageView *imageView;
@end

@implementation ProcessPicturesView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_imageView];
        
        
        
        UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(100, 0, 80, 40)];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelTakePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIButton *sureButton = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 100, 0, 80, 40)];
        [sureButton setTitle:@"确认" forState:UIControlStateNormal];
        [sureButton addTarget:self action:@selector(sureTakePhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureButton];
        
    }
    return self;
}
-(void)setImage:(UIImage *)image
{
    _image = image;
    _imageView.image = image;
}

-(void)cancelTakePhoto
{
    if (self.takePhoto) {
        self.takePhoto(false);
    }
}
-(void)sureTakePhoto
{
    if (self.takePhoto) {
        self.takePhoto(true);
    }
}
@end
