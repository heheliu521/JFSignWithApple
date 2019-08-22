//
//  JFAppleIDUserModel.m
//  JFSignWithApple
//
//  Created by jinfeng.liu on 2019/8/21.
//  Copyright © 2019 jinfeng.liu. All rights reserved.
//

#import "JFAppleIDUserModel.h"

@implementation JFAppleIDUserModel

- (BOOL)isLegalAppleUser {
    if (_realUserStatus != ASUserDetectionStatusLikelyReal) {
        return NO;
    }
    
    if (!_token || !_authorizationCode || !_userIdentifier) {
        return NO;
    }
    
    return YES;
}

@end
