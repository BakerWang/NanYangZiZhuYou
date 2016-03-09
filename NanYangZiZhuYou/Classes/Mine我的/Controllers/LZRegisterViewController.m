//
//  LZRegisterViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZRegisterViewController.h"
#import <BmobSDK/Bmob.h>
#import "ProgressHUD.h"

@interface LZRegisterViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *userEmail;
@property (weak, nonatomic) IBOutlet UITextField *userPassWord;
@property (weak, nonatomic) IBOutlet UITextField *userAgainPassWord;

@end

@implementation LZRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.title = @"返回";
    self.navigationItem.title = @"注册";
    
    //密码密文显示
    //    self.userPassWord.secureTextEntry = YES;
    //    self.userAgainPassWord.secureTextEntry = YES;
    //    //默认switch关闭,密码不显示
    //    self.SwitchOn.on = NO;
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.userName becomeFirstResponder];
    
}
- (IBAction)SwitchOn:(UISwitch *)sender {
    if (sender.isOn == YES) {
        self.userPassWord.secureTextEntry = NO;
        self.userAgainPassWord.secureTextEntry = NO;
    } else {
        self.userPassWord.secureTextEntry = YES;
        self.userAgainPassWord.secureTextEntry = YES;
    }

}

//注册之前需要判断
- (BOOL)checkout {
    //用户名不能为空且不能为空格
    if (self.userName.text.length <= 0 || [self.userName.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        
        return NO;
    }
    
    //两次输入密码一直
    if (![self.userPassWord.text isEqualToString:self.userAgainPassWord.text]) {
        //alert提示框
        
        return NO;
    }
    
    //输入的密码不能为空
    if (self.userPassWord.text.length <= 0 || [self.userAgainPassWord.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert输入密码不能为空
        return NO;
    }
    if (![self validateEmail:self.userEmail.text]) {
        return NO;
    }
    
    
    //判断手机号
    //    NSString *MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9]|70|77)\\d{8}$";
//    372809375@qq.com
//    1713396133@qq.com
    
    return YES;
}
- (BOOL)validateEmail:(NSString *)email{
    //判断是否是邮箱
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
//    NSString *emailRegex = @"/\w+@\w+\.(com|net|org|edu)/i";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
- (IBAction)login:(id)sender {
    if (![self checkout]) {
        return;
    }
    BmobUser *bUser = [[BmobUser alloc] init];
    bUser.username = self.userName.text;
    bUser.password = self.userPassWord.text;
    bUser.email = self.userEmail.text;
    [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
        if (isSuccessful){
            [ProgressHUD showSuccess:@"注册成功"];
            BmobUser *user = [BmobUser getCurrentUser];
            //应用开启了邮箱验证功能
            if ([user objectForKey:@"emailVerified"]) {
                //用户没验证过邮箱
                if (![[user objectForKey:@"emailVerified"] boolValue]) {
                    [user verifyEmailInBackgroundWithEmailAddress:self.userEmail.text];
                }
            }
            [self.navigationController popToRootViewControllerAnimated:YES];
        } else {
            [ProgressHUD showError:@"注册失败"];
        }
    }];

}


//点击右下角回收键盘
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
//点击页面空白处回收键盘
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
    
}
@end



























