//
//  LZLoginViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/8.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZLoginViewController.h"
#import <BmobSDK/Bmob.h>
#import "MineViewController.h"
#import "ProgressHUD.h"
#import "TabBarViewController.h"
@interface LZLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

/** 用户 */
@property (nonatomic, strong) BmobObject *userId;

@end

@implementation LZLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(cancel)];
    
    
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.userName becomeFirstResponder];
    
}
- (BOOL)checkout {
    //用户名不能为空且不能为空格
    if (self.userName.text.length <= 0 || [self.userName.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        
        return NO;
    }
    
    //两次输入密码一直
    if (self.passWord.text.length <= 0 || [self.passWord.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        //alert提示框
        
        return NO;
    }
    
    return YES;
}
- (IBAction)loginBtn:(id)sender {
    if (![self checkout]) {
        return;
    }
    [ProgressHUD show:@"正在登陆..."];
    [BmobUser loginInbackgroundWithAccount:self.userName.text andPassword:self.passWord.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [self cancel];
            fSLog(@"%@",user);
            
        } else {
            [ProgressHUD show:@"账号密码错误"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
            fSLog(@"%@",error);
        }
    }];
    
}
- (void)cancel{
    [ProgressHUD dismiss];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    window.rootViewController = [[TabBarViewController alloc] init];
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




























