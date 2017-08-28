//
//  GetAuthorizationTool.m
//  MarryLoveDriver
//
//  Created by 廉鑫博 on 2017/7/10.
//  Copyright © 2017年 hzkting. All rights reserved.
//

#import "GetAuthorizationTool.h"
@import MapKit;
@import Photos;
@import UIKit;

static GetAuthorizationTool *_tool = nil;
@interface GetAuthorizationTool ()
+(instancetype)shareInstance;
@end

@implementation GetAuthorizationTool
+(instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _tool = [[self alloc]init];
    });
    return _tool;
}

+(BOOL)getAuthorization:(AuthorizationType)type
{
    return [[GetAuthorizationTool shareInstance] getAuthorization:type];
}

-(BOOL)getAuthorization:(AuthorizationType)type
{
    switch (type) {
        case AuthorizationTypeLocation:
            return  [self getLocationAuthorization];
            break;
        case AuthorizationTypeCamera:
            return [self getCameraAuthorization];
            break;
        case AuthorizationTypePhotoLibrary:
            return [self getPhotoLibraryAuthorization];
            break;
        default:
            break;
    }
}
-(BOOL)getLocationAuthorization
{
    if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways)) {
        //定位功能可用
        return true;
    }else  {
        //定位不能用
        [self initAlertTitleUseType:AuthorizationTypeLocation];
        return  false;
    }
}
-(BOOL)getPhotoLibraryAuthorization
{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied)
    {
        [self initAlertTitleUseType:AuthorizationTypePhotoLibrary];
        return false;
    }else if(status == PHAuthorizationStatusNotDetermined)
    {
        WEAKSELF;
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf getPhotoLibraryAuthorization];
            });
        }];
        return false;
    }else{
        return true;
    }
}
-(BOOL)getCameraAuthorization
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied ||authStatus == AVAuthorizationStatusRestricted) {
        [self initAlertTitleUseType:(AuthorizationTypeCamera)];
        return false;
    }else if (authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self getCameraAuthorization];
                });
            }
        }];
        return false;
    }
    else{
        return true;
    }
    return NO;
    
}

-(void)initAlertTitleUseType:(AuthorizationType)type
{
    UIAlertController * con;
    switch (type) {
        case AuthorizationTypeLocation:
        {
            con = [UIAlertController alertControllerWithTitle:@"定位功能不可用" message:@"请前往设置打开定位权限" preferredStyle:UIAlertControllerStyleAlert];
        }
            break;
        case AuthorizationTypePhotoLibrary:
        {
            con = [UIAlertController alertControllerWithTitle:@"相册不可用" message:@"请前往设置打开相册权限" preferredStyle:UIAlertControllerStyleAlert];
        }
            break;
        case AuthorizationTypeCamera:
        {
            con = [UIAlertController alertControllerWithTitle:@"相机不可用" message:@"请前往设置打开相机权限" preferredStyle:UIAlertControllerStyleAlert];
        }
            break;
        default:
            break;
    }
    UIAlertAction * open =[UIAlertAction actionWithTitle:@"打开设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (UIApplicationOpenSettingsURLString != NULL) {
            NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:appSettings];
        }
    }];
    [con addAction:open];
    [con addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [[AppDelegate shareInstance].window.rootViewController presentViewController:con animated:YES completion:nil];
}


@end
