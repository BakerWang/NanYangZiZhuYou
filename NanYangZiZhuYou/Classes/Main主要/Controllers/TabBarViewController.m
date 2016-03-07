//
//  TabBarViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/2/10.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "TabBarViewController.h"
#import "IndexViewController.h"
#import "OrderViewController.h"
#import "FavoriteViewController.h"
#import "MineViewController.h"


#import "HWNavigationController.h"
#import "HWTabBar.h"
#import "CenterViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.初始化子控制器
    IndexViewController *home = [[IndexViewController alloc] init];
    [self addChildVc:home title:@"主页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    OrderViewController *messageCenter = [[OrderViewController alloc] init];
    [self addChildVc:messageCenter title:@"订单" image:@"botm_nav_order" selectedImage:@"botm_nav_order"];
    
    FavoriteViewController *discover = [[FavoriteViewController alloc] init];
    [self addChildVc:discover title:@"收藏" image:@"btmbar_home_favor_normal" selectedImage:@"btmbar_home_favor_press"];
    
    MineViewController *profile = [[MineViewController alloc] init];
    [self addChildVc:profile title:@"我的" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
    // 2.更换系统自带的tabbar
//        self.tabBar = [[HWTabBar alloc] init];
    HWTabBar *tabBar = [[HWTabBar alloc] init];
//    tabBar.delegate = self;
    [self setValue:tabBar forKeyPath:@"tabBar"];
    //    self.tabBar = tabBar;
    
    //    Person *p = [[Person allooc] init];
    //    p.name = @"jack";
    //    [p setValue:@"jack" forKeyPath:@"name"];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//
//    int count = self.tabBar.subviews.count;
//    for (int i = 0; i<count; i++) {
//        UIView *child = self.tabBar.subviews[i];
//        Class class = NSClassFromString(@"UITabBarButton");
//        if ([child isKindOfClass:class]) {
//            child.width = self.tabBar.width / count;
//        }
//    }
//}
/**
 *  添加一个子控制器
 *
 *  @param childVc        子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    // 设置子控制器的文字
    childVc.title = title; // 同时设置tabbar和navigationBar的文字
    //    childVc.tabBarItem.title = title; // 设置tabbar的文字
    //    childVc.navigationItem.title = title; // 设置navigationBar的文字
    
    // 设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = HWColor(123, 123, 123 ,1.0);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    // 先给外面传进来的小控制器 包装 一个导航控制器
    HWNavigationController *nav = [[HWNavigationController alloc] initWithRootViewController:childVc];
    // 添加为子控制器
    [self addChildViewController:nav];
}

#pragma mark - TabBarDelegate代理方法
- (void)tabBarDidClickPlusButton:(HWTabBar *)tabBar
{
    CenterViewController *vc = [[CenterViewController alloc] init];
    HWNavigationController *nav = [[HWNavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}




@end
