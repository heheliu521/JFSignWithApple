//
//  ViewController.m
//  JFSignWithApple
//
//  Created by jinfeng.liu on 2019/8/21.
//  Copyright © 2019 jinfeng.liu. All rights reserved.
//

#import "ViewController.h"
#import "JFAppleIDUserModel.h"
#import "JFAppleSignManager.h"

#import <AuthenticationServices/AuthenticationServices.h>
#import <Masonry/Masonry.h>

#define leftSpace 50
#define rightSpace -50
#define btnHeight 45

@interface ViewController ()<ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

//----------------- 苹果登录 -------------------
//白色苹果登录按钮
@property (nonatomic, strong) ASAuthorizationAppleIDButton *appleLoginBtnWhite;
//黑色苹果登录按钮
@property (nonatomic, strong) ASAuthorizationAppleIDButton *appleLoginBtnBlack;
//自定义按钮
@property (nonatomic, strong) UIButton *customBtn;
//分割线
@property (nonatomic, strong) UILabel *orLabel;
//----------------- 其他登录 -------------------
@property (nonatomic, strong) UIButton *otherLoginBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.view.backgroundColor = [UIColor orangeColor];
    [self setuoView];
}

- (void)setuoView{
    
    [self.view addSubview:self.appleLoginBtnWhite];
    [self.view addSubview:self.appleLoginBtnBlack];
    [self.view addSubview:self.customBtn];
    [self.view addSubview:self.orLabel];
    [self.view addSubview:self.otherLoginBtn];
    
    [_appleLoginBtnWhite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(leftSpace);
        make.right.mas_equalTo(self.view).offset(rightSpace);
        make.top.mas_equalTo(self.view).offset(200);
        make.height.mas_equalTo(btnHeight);
    }];
    
    [_appleLoginBtnBlack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(leftSpace);
        make.right.mas_equalTo(self.view).offset(rightSpace);
        make.top.mas_equalTo(_appleLoginBtnWhite.mas_bottom).offset(30);
        make.height.mas_equalTo(btnHeight);
    }];
    
    [_customBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(leftSpace);
        make.right.mas_equalTo(self.view).offset(rightSpace);
        make.top.mas_equalTo(_appleLoginBtnBlack.mas_bottom).offset(30);
        make.height.mas_equalTo(btnHeight);
    }];
    
    [_orLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_customBtn.mas_bottom).offset(20);
    }];
    
    [_otherLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(_orLabel.mas_bottom).offset(20);
    }];
}

- (ASAuthorizationAppleIDButton *)appleLoginBtnWhite{
    if (!_appleLoginBtnWhite) {
        /*
         ASAuthorizationAppleIDButtonStyleWhite:白色苹果登录按钮
         ASAuthorizationAppleIDButtonStyleWhiteOutline:白色带边框苹果登录按钮
         */
        _appleLoginBtnWhite = [[ASAuthorizationAppleIDButton alloc] initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeDefault authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleWhite];
        [_appleLoginBtnWhite addTarget:self action:@selector(handleAppleIDBtnClicked1) forControlEvents:UIControlEventTouchUpInside];
        [_appleLoginBtnWhite setCornerRadius:btnHeight/2.0];
    }
    return _appleLoginBtnWhite;
}

- (ASAuthorizationAppleIDButton *)appleLoginBtnBlack{
    if (!_appleLoginBtnBlack) {
        _appleLoginBtnBlack = [[ASAuthorizationAppleIDButton alloc] initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeDefault authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleBlack];
        [_appleLoginBtnBlack addTarget:self action:@selector(handleAppleIDBtnClicked2) forControlEvents:UIControlEventTouchUpInside];
        [_appleLoginBtnBlack setCornerRadius:btnHeight/2.0];
    }
    return _appleLoginBtnBlack;
}
- (UIButton *)customBtn{
    if (!_customBtn) {
        _customBtn = [UIButton new];
        [_customBtn setBackgroundColor:[UIColor redColor]];
        [_customBtn setTitle:@"Custom Apple Login" forState:UIControlStateNormal];
        [_customBtn.layer setCornerRadius:btnHeight/2.0];
        [_customBtn addTarget:self action:@selector(handleAppleIDBtnClicked1) forControlEvents:UIControlEventTouchUpInside];
    }
    return _customBtn;
}
- (UILabel *)orLabel{
    if (!_orLabel) {
        _orLabel = [UILabel new];
        _orLabel.numberOfLines = 1;
        _orLabel.textColor = [UIColor blackColor];
        [_orLabel setText:@"--- OR ---"];
    }
    return _orLabel;
}
- (UIButton *)otherLoginBtn{
    if (!_otherLoginBtn) {
        _otherLoginBtn = [UIButton new];
        //解决多个控件同时响应s事件
        _otherLoginBtn.exclusiveTouch = YES;
        [_otherLoginBtn addTarget:self action:@selector(changeStyleToAnotherWays) forControlEvents:UIControlEventTouchUpInside];
        _otherLoginBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:14];
        [_otherLoginBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_otherLoginBtn setTitle:@"使用其他方式登录" forState:UIControlStateNormal];
    }
    return _otherLoginBtn;
}


#pragma mark - Action

//处理授权 (只发送appleid request)
- (void)handleAppleIDBtnClicked1 {
    //生成ID授权请求
    ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
    ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
    // 在用户授权期间请求的联系信息
    [request setRequestedScopes:@[ASAuthorizationScopeFullName, ASAuthorizationScopeEmail]];
    
    //授权控制器
    ASAuthorizationController *appleSignVC = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
    //授权成功与失败的代理
    appleSignVC.delegate = self;
    //展示上下文的代理 (系统可以展示授权界面给用户)
    appleSignVC.presentationContextProvider = self;
    //启动授权流
    [appleSignVC performRequests];
}

//处理授权 (appleID request + password request)
- (void)handleAppleIDBtnClicked2 {
    //生成ID授权请求
    ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
    ASAuthorizationAppleIDRequest *request = appleIDProvider.createRequest;
    [request setRequestedScopes:@[ASAuthorizationScopeFullName,ASAuthorizationScopeEmail]];
    
    //生成密码授权请求 （需要考虑已经登录过的用户，可以直接使用keychain密码来进行登录-这个很牛皮。。。）
    ASAuthorizationPasswordProvider *appleIDPasswordProvider = [ASAuthorizationPasswordProvider new];
    ASAuthorizationPasswordRequest *passwordRequest = appleIDPasswordProvider.createRequest;
    
    ASAuthorizationController *appleSignController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request,passwordRequest]];
    appleSignController.delegate = self;
    appleSignController.presentationContextProvider = self;
    [appleSignController performRequests];
}
//其他登录方式
- (void)changeStyleToAnotherWays {
    NSLog(@"使用其他登录方式");
}


#pragma mark - ASAuthorizationControllerDelegate
//授权失败的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error {
    NSString *errorMsg = nil;
    switch (error.code) {
        case ASAuthorizationErrorCanceled:
            errorMsg = @"用户取消了授权请求";
            break;
        case ASAuthorizationErrorFailed:
            errorMsg = @"授权请求失败";
            break;
        case ASAuthorizationErrorInvalidResponse:
            errorMsg = @"授权请求响应无效";
            break;
        case ASAuthorizationErrorNotHandled:
            errorMsg = @"未能处理授权请求";
            break;
        case ASAuthorizationErrorUnknown:
            errorMsg = @"授权请求失败未知原因";
            break;
    }
    NSLog(@"%@",errorMsg);
    NSLog(@"controller requests：%@", controller.authorizationRequests);
}

//授权成功地回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization {
    if ([authorization.provider isKindOfClass:[ASAuthorizationAppleIDProvider class]])
    {
        //Sign With Apple 方式登录
        ASAuthorizationAppleIDCredential *credential = authorization.credential;
        if ([credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
            
            NSString *tokenString = [[NSString alloc] initWithData:credential.identityToken encoding:NSUTF8StringEncoding];
            NSString *authorizationCodeString = [[NSString alloc] initWithData:credential.authorizationCode encoding:NSUTF8StringEncoding];
            //登录成功返回的信息
            NSString *userIdentifier = credential.user;
            NSString *email = credential.email;
            NSString *givenName = credential.fullName.givenName;
            NSString *familyName = credential.fullName.familyName;
            ASUserDetectionStatus realUserStatus = credential.realUserStatus;
            
            //将相信存到userModel中
            JFAppleIDUserModel *userModel = [JFAppleIDUserModel new];
            userModel.userIdentifier = userIdentifier;
            userModel.token = tokenString;
            userModel.authorizationCode = authorizationCodeString;
            userModel.email = email;
            userModel.realUserStatus = realUserStatus;
            userModel.givenName = givenName;
            userModel.familyName = familyName;
            
            if ([userModel isLegalAppleUser]) {
                //如果苹果返回正确信息
                //需要给后台传userIdentifier、token、authorizationCode
                if (1) {
                    //保存用户信息
                    [[JFAppleSignManager sharedInstance] configAppleUserModel:userModel];
                    [[JFAppleSignManager sharedInstance] saveAppleUserModel];
                }
            }
        }
    }
    else if ([authorization.provider isKindOfClass:[ASAuthorizationPasswordProvider class]])
    {
        //password 方式登录
        ASPasswordCredential *passwordCredential = authorization.credential;
        if ([passwordCredential isKindOfClass:[ASPasswordCredential class]]) {
            NSString *userName = passwordCredential.user;
            NSString *password = passwordCredential.password;
            NSLog(@"使用密码登录,userName == %@, password == %@",userName,password);
        }
    }
    else
    {
        NSLog(@"授权信息均不符");
    }
}

#pragma mark - ASAuthorizationControllerPresentationContextProviding
//告诉代理应该在哪个window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return self.view.window;
}



@end
