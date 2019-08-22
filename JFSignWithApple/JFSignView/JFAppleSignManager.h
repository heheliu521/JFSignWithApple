//
//  JFAppleSignManager.h
//  JFSignWithApple
//
//  统一管理Sign with Apple 相关功能
//
//  Created by jinfeng.liu on 2019/8/21.
//  Copyright © 2019 jinfeng.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JFAppleIDUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JFAppleSignManager : NSObject

@property (nonatomic, strong) JFAppleIDUserModel *appleUserModel;

+ (instancetype)sharedInstance;

/*
 用于检查用户手机 Apple ID 登录状态
 
 如果是使用Apple Sign方式登录的，则每次客户端启动的时候需要检查
 */
- (void)checkAppleSignLoginState;

/*
 用于配置本地userModel
 
 用于接收苹果返回的user模型
*/
- (void)configAppleUserModel:(JFAppleIDUserModel *)appleUserModel;

/*
 保存信息到本地
 
 ign with Apple 成功之后保存把信息保存到本地
*/
- (void)saveAppleUserModel;

@end

NS_ASSUME_NONNULL_END
