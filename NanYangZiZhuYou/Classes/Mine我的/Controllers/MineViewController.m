//
//  MineViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/2/6.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "MineViewController.h"
#import <MessageUI/MessageUI.h>
#import <BmobSDK/Bmob.h>

#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/SDImageCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import <UIImageView+WebCache.h>

#import "HWNavigationController.h"
#import "HWAccountTool.h"
#import "LZ_HeadView.h"
#import "LZ_Mine_Head_DetailViewController.h"
#import "LZ_DetailTableViewController.h"


@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *imageArray;

/** <登录昵称> */
@property (nonatomic, copy) NSString *loginStr;
/** <微博字典> */
@property (nonatomic, strong) NSMutableDictionary *dic;
/** <Bmob> */
@property (nonatomic, strong) BmobUser *bUser;
/** <微博用户> */
@property (nonatomic, strong) HWAccount *account;
/** <<#draw#>> */
@property (nonatomic, strong) LZ_HeadView *mineHead;
/** <bool> */
@property (nonatomic, assign) BOOL *isSina;
@end

@implementation MineViewController
- (NSMutableDictionary *)dic
{
    if (!_dic) {
        self.dic = [[NSMutableDictionary alloc] init];
    }
    return _dic;
}
- (UITableView *)tableView {
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 44) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.scrollEnabled = NO;
    [self.view addSubview:self.tableView];
    self.imageArray = [NSMutableArray arrayWithObjects:@"mine_clear",@"mine_message",@"mine_share",@"mine_appStore",@"mine_appVersion",@"iconfont-qq-3",nil];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除图片缓存",@"用户反馈",@"分享给好友",@"给我评分",@"当前版本1.1", @"退出登录",nil];
    
       self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self makeImageWithName];
//    self.bUser = [BmobUser getCurrentUser];
//    if (self.bUser && self.titleArray.count == 4) {
//        [self.imageArray addObject:@"iconfont-qq-3"];
//        [self.titleArray addObject:@"退出登录"];
//    }
//    self.bUser = [BmobUser getCurrentUser];
//    fSLog(@"%@",self.bUser.username);
//    fSLog(@"%lu",self.titleArray.count);
//    if (!self.bUser && self.titleArray.count == 5) {
//        [self.imageArray removeObjectAtIndex:5];
//        [self.titleArray removeObjectAtIndex:5];
//    }

}

//______________________________________________________________________________
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = 100;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y > 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else
        if(scrollView.contentOffset.y >= sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
}
#pragma mark    //[业务逻辑]
- (void)makeImageWithName{
    self.bUser = [BmobUser getCurrentUser];
    self.account = [HWAccountTool account];
    
    self.mineHead.imageView.layer.cornerRadius     = 50;
    self.mineHead.imageView.clipsToBounds          = YES;
    if (!self.bUser) {
        self.mineHead.imageView.image = [UIImage imageNamed:@"phloder"];
        [self.mineHead.userName setTitle:@"欢迎来到南阳自助游" forState:UIControlStateNormal];
        
    } else {
        UIImage *image = [UIImage imageWithContentsOfFile:kPath];
        NSString *avatar_hd = [[NSUserDefaults standardUserDefaults] valueForKey:@"avatar_hd"];
        if (image) {
            self.mineHead.imageView.image = image;
        }else{
            if (avatar_hd) {
                [self.mineHead.imageView sd_setImageWithURL:[NSURL URLWithString:avatar_hd] placeholderImage:[UIImage imageNamed:@"phloder"]];
            }else{
                self.mineHead.imageView.image = [UIImage imageNamed:@"phloder"];
                
            }
        }
        [self.mineHead.userName setTitle:self.bUser.username forState:UIControlStateNormal];
    }
    
    
    
    
}
- (void)login:(UIButton *)btn{
    if (!self.bUser) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LZLogin" bundle:nil];
        UINavigationController *nav = sb.instantiateInitialViewController;
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }else{
//        LZ_Mine_Head_DetailViewController *lz = [LZ_Mine_Head_DetailViewController new];
//        [self.navigationController pushViewController:lz animated:YES];
        
        LZ_DetailTableViewController *lz = [LZ_DetailTableViewController new];
        [self.navigationController pushViewController:lz animated:YES];
    }
    
}
//==============================================================================
#pragma mark    //[cell处理]
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    self.mineHead = [[[NSBundle mainBundle] loadNibNamed:@"LZ_HeadView" owner:nil options:nil] lastObject];
    
    UIButton *headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headBtn.frame = self.mineHead.frame;
    [headBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.mineHead addSubview:headBtn];
    
    [self makeImageWithName];

    return self.mineHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 100;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    
    
    return cell;
}
#pragma mark    //[选中方法]
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        self.bUser = [BmobUser getCurrentUser];
        [BmobUser logout];
        NSUserDefaults *userDefatluts = [NSUserDefaults standardUserDefaults];
        [userDefatluts removeObjectForKey:@"name"];
        [userDefatluts removeObjectForKey:@"avatar_hd"];
        [userDefatluts synchronize];
        self.account = [HWAccountTool account];
        if (self.account) {
            fSLog(@"%@",self.account);
            [self userlogout];
        }
        [self makeImageWithName];
    
      
        
}

}
//==========================================================================================================================================================================================================================================

//______________________________________________________________________________

#pragma mark    //[新浪退出]
- (void)userlogout{
        // 1.请求管理者
        AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
        sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
        // 2.拼接请求参数
        NSString *URLString = @"https://api.weibo.com/oauth2/revokeoauth2?";
        // 3.发送请求
        [sessionManager GET:[NSString stringWithFormat:@"%@access_token=%@",URLString,self.account.access_token] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            fSLog(@"%@",responseObject);
            if ([responseObject[@"result"] isEqualToString:@"true"]) {
                
                fSLog(@"移除授权成功");
            }
            [ProgressHUD showSuccess:@"退出成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [ProgressHUD dismiss];
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            fSLog(@"%@",error);
        }];
}
//==============================================================================
//______________________________________________________________________________
#pragma mark    //[新浪登录]
- (void)setupUserInfo
{
    self.account = [HWAccountTool account];
    // 1.请求管理者
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    // 2.拼接请求参数
    NSString *URLString = @"https://api.weibo.com/2/users/show.json?";
    // 3.发送请求
    [sessionManager GET:[NSString stringWithFormat:@"%@access_token=%@&uid=%@",URLString,self.account.access_token,self.account.uid] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.dic = responseObject;
        fSLog(@"%@",self.dic[@"name"]);
        
        
        //        fSLog(@"%@",responseObject);
        [self makeImageWithName];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fSLog(@"%@",error);
    }];
    
}

//==============================================================================










@end
