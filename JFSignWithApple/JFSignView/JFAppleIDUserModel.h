//
//  JFAppleIDUserModel.h
//  JFSignWithApple
//
//  Apple ID登录下，系统返回的模型
//
//  Created by jinfeng.liu on 2019/8/21.
//  Copyright © 2019 jinfeng.liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AuthenticationServices/AuthenticationServices.h>

NS_ASSUME_NONNULL_BEGIN

@interface JFAppleIDUserModel : NSObject

/**
 苹果用户唯一标识符，该值在同一个开发者账号下的所有 App 下是一样的，开发者可以用该唯一标识符与自己后台系统的账号体系绑定起来
 */
@property (nonatomic, copy) NSString *userIdentifier;

/**
 苹果返回的该用户的状态
 */
@property (nonatomic, assign) ASUserDetectionStatus realUserStatus;

/**
 用户邮箱，注意这里用户可以选择隐藏自己的邮箱地址的，因此这个值不一定是真正的邮箱地址
 */
@property (nonatomic, copy) NSString *email;

/**
 token 给后台向苹果服务器验证使用
 */
@property (nonatomic, copy) NSString *token;

/**
 authorizationCodeString 给后台向苹果服务器验证使用 这个有时效性 五分钟之内有效
 */
@property (nonatomic, copy) NSString *authorizationCode;

/**
 givenName
 */
@property (nonatomic, copy) NSString *givenName;

/**
 familyName
 */
@property (nonatomic, copy) NSString *familyName;

/**
 是否是合法的苹果用户
 */
- (BOOL)isLegalAppleUser;


@end

NS_ASSUME_NONNULL_END
