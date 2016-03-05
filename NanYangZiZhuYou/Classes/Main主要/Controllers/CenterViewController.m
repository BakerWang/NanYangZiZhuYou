//
//  CenterViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/1.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "CenterViewController.h"
//#import "LBXScanViewController.h"
#import "LBXScanView.h"

@interface CenterViewController ()

@end

@implementation CenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫描二维码";
    self.view.backgroundColor = [UIColor yellowColor];
    
    
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    style.photoframeLineW = 6;
    style.photoframeAngleW = 24;
    style.photoframeAngleH = 24;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_light_green"];
    style.animationImage = imgLine;
    
//    LBXScanViewController *vc = [LBXScanViewController new];
//    vc.style = style;
//    vc.isQQSimulator = YES;
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
