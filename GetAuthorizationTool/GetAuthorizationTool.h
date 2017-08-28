//
//  GetAuthorizationTool.h
//  MarryLoveDriver
//
//  Created by 廉鑫博 on 2017/7/10.
//  Copyright © 2017年 hzkting. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, AuthorizationType) {
    AuthorizationTypeLocation = 0,
    AuthorizationTypeCamera = 1,
    AuthorizationTypePhotoLibrary = 2
};

@interface GetAuthorizationTool : NSObject

+(BOOL)getAuthorization:(AuthorizationType)type;
@end
