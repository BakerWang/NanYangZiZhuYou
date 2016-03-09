//
//  MineViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/2/6.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "MineViewController.h"
#import <MessageUI/MessageUI.h>
#import <SDWebImage/SDImageCache.h>
#import "ProgressHUD.h"
#import "HWNavigationController.h"
#import <BmobSDK/Bmob.h>

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) UIButton *headImageButton;
@property (nonatomic, strong) UILabel *nikeNameLabel;
/** <登录昵称> */
@property (nonatomic, copy) NSString *loginStr;

@end

@implementation MineViewController
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (UIButton *)headImageButton {
    if (_headImageButton == nil) {
        self.headImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.headImageButton.frame = CGRectMake(20, 20, SCREEN_WIDTH / 3, SCREEN_WIDTH / 3);
        [self.headImageButton setBackgroundColor:[UIColor whiteColor]];
        [self.headImageButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.headImageButton.layer.cornerRadius = 65;
        self.headImageButton.clipsToBounds = YES;
    }
    return _headImageButton;
}
- (UILabel *)nikeNameLabel {
    if (_nikeNameLabel == nil) {
        self.nikeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 55, SCREEN_WIDTH / 2, 60)];
        self.nikeNameLabel.numberOfLines = 0;
        self.nikeNameLabel.textColor = [UIColor whiteColor];
    }
    return _nikeNameLabel;
}
- (void)setting{
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    }else{
        NSURL *url2 = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url2];
    }
}
- (void)userlogout{
    [BmobUser logout];
    [self viewWillAppear:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 4)];
    headView.backgroundColor = HWColor(96, 185, 191, 1.0);
    [headView addSubview:self.headImageButton];
    [headView addSubview:self.nikeNameLabel];
    self.tableView.tableHeaderView = headView;
    
    self.imageArray = @[@"mine_clear",@"mine_message",@"mine_share",@"mine_appStore",@"mine_appVersion",@"iconfont-qq-3"];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除图片缓存",@"用户反馈",@"分享给好友",@"给我评分",@"当前版本1.0", @"QQ:1713396133",nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    BmobUser *bUser = [BmobUser getCurrentUser];
    if (!bUser) {
        //对象为空时，可打开用户注册界面
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:0 target:self action:@selector(setting)];
        [self.headImageButton setTitle:@"登陆/注册" forState:UIControlStateNormal];
        [self.headImageButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
        self.nikeNameLabel.text = @"欢迎来到南阳自助游";
    
    }else{
       
    //进行操作
    //-(id)objectForKey:(id)key;
    self.loginStr = bUser.username;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出" style:0 target:self action:@selector(userlogout)];
    [self.headImageButton setImage:[UIImage imageNamed:@"tabbar_profile"] forState:UIControlStateNormal];
    self.nikeNameLabel.text = self.loginStr;
    fSLog(@"%@",bUser);
        }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    //去掉cell选中颜色
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    return cell;
}
#pragma mark -----------  UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            [ProgressHUD show:@"正在为您清理中..."];
            [self performSelector:@selector(clearImage) withObject:nil afterDelay:2.0];
        }
            break;
        case 1:
        {
            //发送邮件
            [self sendEmail];
        }
            break;
        case 2:
        {
            //分享
            [self share];
        }
            break;
        case 3:
        {
            //appStore评分
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 4:
        {
            //检测当前版本
            [ProgressHUD show:@"正在为您检测中..."];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
        }
            break;
        default:
            break;
    }
}

- (void)login:(UIButton *)btn{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZLogin" bundle:nil];
    UINavigationController *nav = sb.instantiateInitialViewController;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
    
}

- (void)sendEmail {
    //初始化
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    //设置代理
    picker.mailComposeDelegate = self;
    //设置主题
    [picker setSubject:@"用户反馈"];
    //设置收件人
    NSArray *recive = [NSArray arrayWithObjects:@"1713396133@qq.com", nil];
    [picker setToRecipients:recive];
    //设置发送内容
    NSString *text = @"请留下您宝贵的意见";
    [picker setMessageBody:text isHTML:NO];
    //推出视图
    [self presentViewController:picker animated:YES completion:nil];
}
/*
 Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
 if (mailClass != nil) {
 // We must always check whether the current device is configured for sending emails
 if ([MFMailComposeViewController canSendMail]) {
 //初始化发送邮件类对象
 MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
 //设置代理
 mailVC.mailComposeDelegate = self;
 
 //设置主题：
 [mailVC setSubject:@"用户反馈"];
 
 //设置收件人
 NSArray *receive = [NSArray arrayWithObjects:@"1713396133@qq.com", nil];
 
 [mailVC setToRecipients:receive];
 
 //设置发送内容
 NSString *text = @"请留下您宝贵意见";
 [mailVC setMessageBody:text isHTML:NO];
 
 //推出视图
 [self presentViewController:mailVC animated:YES completion:nil];
 } else {
 fSLog(@"未配置邮箱账号");
 }
 } else {
 fSLog(@"当前设备不能发送");
 }
 */
//邮件发送完成调用的方法
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    //关闭邮件发送窗口
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            fSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            fSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            fSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            fSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)checkAppVersion {
    [ProgressHUD showSuccess:@"恭喜您！当前已是最新版本！"];
}

- (void)share {
//    UIWindow *window = [[UIApplication sharedApplication].delegate window];
//    self.shareView = [[ShareView alloc] init];
//    [window addSubview:self.shareView];
    return;
}

- (void)clearImage {
    [ProgressHUD showSuccess:@"占您的地儿已经挪开."];
    //清除缓存
    fSLog(@"%@",NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES));
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearDisk];
    [self.titleArray replaceObjectAtIndex:0 withObject:@"清除图片缓存"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

//- (void)pushShareWeiboVC {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//    [self.shareView removeAllChildrenViews];
//    
//    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
//    UINavigationController *shareNav = [mineStoryBoard instantiateViewControllerWithIdentifier:@"ShareNav"];
//    [self.navigationController presentViewController:shareNav animated:YES completion:nil];
//}










@end
