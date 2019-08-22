//
//  JFAppleSignManager.m
//  JFSignWithApple
//
//  Created by jinfeng.liu on 2019/8/21.
//  Copyright © 2019 jinfeng.liu. All rights reserved.
//

#import "JFAppleSignManager.h"
#import <AuthenticationServices/AuthenticationServices.h>

@implementation JFAppleSignManager

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    __strong static id _shareObject = nil;
    dispatch_once(&onceToken, ^{
        _shareObject = [[self alloc] init];
    });
    return _shareObject;
}
- (void)dealloc{
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}
- (instancetype)init{
    if (self = [super init]) {
        //添加 Sign with Apple 登录状态通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAppleIdHasChanged) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
    return self;
}

- (void)checkAppleSignLoginState{
    if (@available(iOS 13.0, *)) {
        if ([_appleUserModel isLegalAppleUser]) {
            ASAuthorizationAppleIDProvider *provider = [ASAuthorizationAppleIDProvider new];
            //在回调中返回用户的授权状态
            [provider getCredentialStateForUserID:_appleUserModel.userIdentifier completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
                
                NSString* __block errorMsg = nil;
                
                switch (credentialState) {
                    case ASAuthorizationAppleIDProviderCredentialRevoked:
                        errorMsg = @"用户重新登录了其他的apple id";
                        break;
                    case ASAuthorizationAppleIDProviderCredentialAuthorized:
                        errorMsg = @"该userid apple id 登录状态良好";
                        break;
                    case ASAuthorizationAppleIDProviderCredentialNotFound:
                        errorMsg = @"该userid apple id 登录找不到: 用户在设置-appleid header-密码与安全性-使用您 Apple ID的App 中将网易新闻的禁止掉了";
                        break;
                    default:
                        break;
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%@", errorMsg);
                });
            }];
        }
    }
}
- (void)configAppleUserModel:(JFAppleIDUserModel *)appleUserModel{
    _appleUserModel = appleUserModel;
}
- (void)saveAppleUserModel{
    if (_appleUserModel) {
        //保存获取到的本地Apple ID User
    }
}

#pragma mark - Sign with Apple 登录状态通知
- (void)handleAppleIdHasChanged {
    //退出登录
    //弹窗提示 “因为你的apple id 发生了切换，需要重新登录”
    NSLog(@"因为你的apple id 发生了切换，需要重新登录");
}


@end
