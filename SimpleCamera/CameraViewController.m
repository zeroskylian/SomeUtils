//
//  CameraViewController.m
//  ExampleProject
//
//  Created by 廉鑫博 on 2017/8/28.
//  Copyright © 2017年 廉鑫博. All rights reserved.
//

#import "CameraViewController.h"
#import "ProcessPicturesView.h"
@import AVFoundation;


@interface CameraViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate>
//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;

//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;

//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;

@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;

//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;

//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;


/// 拍照button
@property (nonatomic)UIButton *photoButton;

/// 闪光灯button
@property (strong, nonatomic)UIButton *flashButton;

/// 更改分辨率
@property (strong, nonatomic)UIButton *changeResolutionButton;

@property (strong, nonatomic)UIImage *image;


@property (strong, nonatomic)UIView *focusView;


@property (strong, nonatomic)ProcessPicturesView *picView;
@end

@implementation CameraViewController

#pragma mark - lazy load
-(UIView *)focusView
{
    if (!_focusView) {
        _focusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 80)];
        _focusView.layer.borderWidth = 1.0;
        _focusView.layer.borderColor =[UIColor greenColor].CGColor;
        _focusView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_focusView];
        _focusView.hidden = YES;
    }
    return _focusView;
}

-(ProcessPicturesView *)picView
{
    if (!_picView) {
        _picView =  [[ProcessPicturesView alloc]initWithFrame:self.previewLayer.frame];
        _picView.layer.masksToBounds = true;
        WEAKSELF;
        _picView.takePhoto = ^(BOOL sure) {
            [weakSelf canSaveImage:sure];
        };
        _picView.hidden = true;
        [self.view addSubview:_picView];
    }
    return _picView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initCamera];
    [self initUI];
    
}
/// 初始化UI
-(void)initUI
{
    self.view.backgroundColor = [UIColor clearColor];
    _photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _photoButton.frame = CGRectMake(0, 0, 80, 80);
    _photoButton.center = CGPointMake(kScreenWidth / 2 , self.view.frame.size.height - 60);
    [_photoButton setImage:[UIImage imageNamed:@"chooseImg"] forState: UIControlStateNormal];
    [_photoButton setImage:[UIImage imageNamed:@"chooseImg_down"] forState:UIControlStateHighlighted];
    [_photoButton addTarget:self action:@selector(takePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_photoButton];
    
    ///切换按钮
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake( 0, 0, 80, 80);
    rightButton.center = CGPointMake(kScreenWidth * 3 / 4 , self.view.frame.size.height - 60);
    [rightButton setImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"change_down"] forState:UIControlStateHighlighted];
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightButton addTarget:self action:@selector(changeCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightButton];
    
    /// 闪光灯
    _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _flashButton.frame = CGRectMake(0, 0, 80, 80);
    _flashButton.center = CGPointMake(kScreenWidth * 1 / 4, self.view.frame.size.height - 60);
    if (!_device.flashActive) {
        [_flashButton setImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"light_on_down"] forState:UIControlStateHighlighted];
    }else
    {
        [_flashButton setImage:[UIImage imageNamed:@"light_off"] forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"light_off_down"] forState:UIControlStateHighlighted];
    }
    [_flashButton addTarget:self action:@selector(flashOn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_flashButton];
    
    /// 焦点手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(focusGesture:)];
    [self.view addGestureRecognizer:tapGesture];
    
    ///放大手势
    UIPinchGestureRecognizer *pinGes = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(zoomLayer:)];
    [self.view addGestureRecognizer: pinGes];
    
    ///取消按钮
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(10, 30, 30, 30);
    [leftButton setImage:[UIImage imageNamed:@"exitCamera"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"exitCamera_down"] forState:UIControlStateHighlighted];
    leftButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    
}
/// 初始化相机
-(void)initCamera
{
    //使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //使用设备初始化输入
    self.input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    
    //生成输出对象
    self.output = [[AVCaptureMetadataOutput alloc]init];
    self.ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]) {
        // 6以前不支持AVCaptureSessionPreset3840x2160
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    //使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    self.previewLayer.frame = CGRectMake(0, 0, kScreenWidth, self.view.frame.size.height);
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.previewLayer];
    
    //开始启动
    [self.session startRunning];
    if ([_device lockForConfiguration:nil]) {
        if ([_device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [_device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([_device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [_device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        [_device unlockForConfiguration];
    }
}
#pragma mark - button func

-(void)cancel
{
    [self.session stopRunning];
    [self dismissViewControllerAnimated:true completion:false];
}
-(void)takePhoto
{
    
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        ZLog(@"take photo failed!");
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        weakSelf.image = [UIImage imageWithData:imageData];
        [weakSelf.session stopRunning];
        weakSelf.picView.image = _image;
        weakSelf.picView.hidden = false;
    }];
}

- (void)flashOn{
    if ([_device lockForConfiguration:nil]) {
        if (!_device.isFlashActive) {
            if ([_device isFlashModeSupported:AVCaptureFlashModeOff]) {
                [_device setFlashMode:AVCaptureFlashModeOff];
                [_device setTorchMode:AVCaptureTorchModeOff];
                
                [_flashButton setImage:[UIImage imageNamed:@"light_off"] forState:UIControlStateNormal];
                [_flashButton setImage:[UIImage imageNamed:@"light_off_down"] forState:UIControlStateHighlighted];
            }
        }else{
            if ([_device isFlashModeSupported:AVCaptureFlashModeOn]) {
                [_device setFlashMode:AVCaptureFlashModeOn];
                [_device setTorchMode:AVCaptureTorchModeOn];
                [_flashButton setImage:[UIImage imageNamed:@"light_on"] forState:UIControlStateNormal];
                [_flashButton setImage:[UIImage imageNamed:@"light_on_down"] forState:UIControlStateHighlighted];
            }
        }
        [_device unlockForConfiguration];
    }
}
- (void)changeCamera{
    NSUInteger cameraCount = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
    if (cameraCount > 1) {
        NSError *error;
        CATransition *animation = [CATransition animation];
        animation.duration = .5f;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.type = @"oglFlip";
        AVCaptureDevice *newCamera = nil;
        AVCaptureDeviceInput *newInput = nil;
        AVCaptureDevicePosition position = [[_input device] position];
        if (position == AVCaptureDevicePositionFront){
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionBack];
            animation.subtype = kCATransitionFromLeft;
        }else {
            newCamera = [self cameraWithPosition:AVCaptureDevicePositionFront];
            animation.subtype = kCATransitionFromRight;
        }
        newInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
        [self.previewLayer addAnimation:animation forKey:nil];
        if (newInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:_input];
            if ([self.session canAddInput:newInput]) {
                [self.session addInput:newInput];
                self.input = newInput;
            } else {
                [self.session addInput:self.input];
            }
            [self.session commitConfiguration];
        } else if (error) {
            NSLog(@"toggle carema failed, error = %@", error);
        }
        
    }
}
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for ( AVCaptureDevice *device in devices )
        if ( device.position == position ) return device;
    return nil;
}
#pragma mark - gesture
- (void)focusGesture:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:gesture.view];
    [self focusAtPoint:point];
}
- (void)focusAtPoint:(CGPoint)point{
    CGSize size = self.view.bounds.size;
    CGPoint focusPoint = CGPointMake( point.y /size.height ,1 - point.x/size.width );
    NSError *error;
    if ([self.device lockForConfiguration:&error]) {
        
        if ([self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:focusPoint];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        
        if ([self.device isExposureModeSupported:AVCaptureExposureModeAutoExpose ]) {
            [self.device setExposurePointOfInterest:focusPoint];
            [self.device setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        
        [self.device unlockForConfiguration];
        self.focusView.center = point;
        self.focusView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
        }completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                self.focusView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                self.focusView.hidden = YES;
            }];
        }];
    }
}
-(void)zoomLayer:(UIPinchGestureRecognizer *)pinch
{
    NSError *error = nil;
    
    [self.device lockForConfiguration:&error];
    if (!error) {
        self.device.videoZoomFactor = pinch.scale <= 1?1:pinch.scale;
        //        [self.device rampToVideoZoomFactor:pinch.scale <= 1 ?1:pinch.scale withRate:pinch.velocity];
    }else
    {
        NSLog(@"error = %@", error);
    }
    [self.device unlockForConfiguration];
}


-(void)canSaveImage:(BOOL)save
{
    if (save) {
        [self dismissViewControllerAnimated:true completion:NULL];
    }else
    {
        self.picView. hidden = true;
        [self.session startRunning];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
