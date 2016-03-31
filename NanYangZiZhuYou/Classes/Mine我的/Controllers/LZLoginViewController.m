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
#import "LZOAuthViewController.h"
#import "LZPPooCodeView.h"
#import "HWAccountTool.h"
#import <BmobSDK/Bmob.h>

@interface LZLoginViewController ()
{
    LZPPooCodeView *_pooCodeView;
    
}
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;
@property (weak, nonatomic) IBOutlet UITextField *validate;
@property (weak, nonatomic) IBOutlet UIView *vailDateView;

/** 用户 */
@property (nonatomic, strong) BmobObject *userId;

@end

@implementation LZLoginViewController
- (void)loadView{
    [super loadView];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登录";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:0 target:self action:@selector(cancel)];
    _pooCodeView = [[LZPPooCodeView alloc] initWithFrame:CGRectMake(0, 0, 82, 34)];
    [self.vailDateView addSubview:_pooCodeView];
//    self.vailDateView = _pooCodeView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_pooCodeView addGestureRecognizer:tap];

}

- (void)tapClick:(UITapGestureRecognizer*)tap{
    [_pooCodeView changeCode];
}
- (void)viewWillAppear:(BOOL)animated{//nyzzy123
    [super viewWillAppear:animated];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *name = [userDefault valueForKey:@"name"];
    if (name) {
        BOOL isFirst =  [[userDefault objectForKey:@"isfirstlzc"] boolValue];
        if(!isFirst) {
            BmobUser *bUser = [[BmobUser alloc] init];
            bUser.username = name;
            bUser.password = @"nyzzy123";
            [bUser signUpInBackgroundWithBlock:^ (BOOL isSuccessful, NSError *error){
                //注册成功返回mineVC
                [self.navigationController popViewControllerAnimated:YES];
                if (isSuccessful){
                    [ProgressHUD showSuccess:@"注册成功"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ProgressHUD dismiss];
                    });
                } else {
                    [ProgressHUD showError:@"授权失败，请重新授权"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ProgressHUD dismiss];
                    });
                }
            }];
            [userDefault setObject:@"YES"forKey:@"isfirstlzc"];
            [userDefault synchronize];
            
        }else{
            [BmobUser loginInbackgroundWithAccount:name andPassword:@"nyzzy123" block:^(BmobUser *user, NSError *error) {
                if (user) {
                    [self.navigationController popViewControllerAnimated:YES];
                    
                } else {
                    [ProgressHUD show:@"授权失败，请重新授权"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [ProgressHUD dismiss];
                    });
                    
                }
            }];
            
        }
    }else{
        
        [self.userName becomeFirstResponder];
    }
    
}

- (BOOL)checkout {
    //用户名不能为空且不能为空格
    if (self.userName.text.length <= 0 || [self.userName.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0){
        
        [ProgressHUD show:@"密码不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
        });
        return NO;
    }
    
    //输入密码不为空
    if (self.passWord.text.length <= 0 || [self.passWord.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0){
        
        [ProgressHUD show:@"密码不能为空"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
        });
        return NO;
    }
    
    if (![self.validate.text isEqualToString:_pooCodeView.changeString]){
//        [ProgressHUD show:@"请注意大小写!"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [ProgressHUD dismiss];
//        });
//        
//        return NO;
    }
    return YES;
}
- (IBAction)loginBtn:(id)sender {
    if (![self checkout]) {
        
        return;
    }

    [BmobUser loginInbackgroundWithAccount:self.userName.text andPassword:self.passWord.text block:^(BmobUser *user, NSError *error) {
        if (user) {
            [ProgressHUD show:@"正在登陆..."];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
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
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)otherLogin:(id)sender {
    LZOAuthViewController *lz = [LZOAuthViewController new];
    [self.navigationController pushViewController:lz animated:YES];
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




























