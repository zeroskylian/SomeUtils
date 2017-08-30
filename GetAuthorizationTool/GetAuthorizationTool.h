//
//  GetAuthorizationTool.h
//  MarryLoveDriver
//
//  Created by 廉鑫博 on 2017/7/10.
//  Copyright © 2017年 hzkting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AuthorizationType) {
    /// 位置
    AuthorizationTypeLocation = 0,
    /// 相机
    AuthorizationTypeCamera = 1,
    /// 相册
    AuthorizationTypePhotoLibrary = 2,
    /// 麦克风
    AuthorizationTypeRecord = 3,
    /// 通讯录
    AuthorizationTypeAddressBook = 4,
    ///
};

@interface GetAuthorizationTool : NSObject

+(BOOL)getAuthorization:(AuthorizationType)type;
@end
