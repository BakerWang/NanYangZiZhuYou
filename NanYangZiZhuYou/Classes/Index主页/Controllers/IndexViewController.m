//
//  IndexViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/2/21.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "IndexViewController.h"
#import "Index.h"
#import "UIButton+WebCache.h"
#import "HeadScrollView.h"
#import "MiddleScrollView.h"
#import <BmobSDK/Bmob.h>

#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/UIButton+WebCache.h>
#import "MJExtension.h"

#import "TitleImageButton.h"
#import "LZDetailViewController.h"
#import "LZAdViewController.h"
#import "LZLifeViewController.h"
#import "LZIndexTableViewCell.h"
#import "LZMapViewController.h"
#import "LZPHorizontalButton.h"

@interface IndexViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 轮播数据 */
@property (nonatomic, retain) NSMutableArray *bannerList;
/** 滑动类别 */
@property (nonatomic, retain) NSMutableArray *categroyList;
/** 吃美住娱 */
@property (nonatomic, retain) NSMutableArray *topicList;
/** 吃美住娱 */
@property (nonatomic, retain) NSMutableArray *topicListImage;
/** cell */
@property (nonatomic, retain) NSMutableArray *hotList;
/** cell */
@property (nonatomic, retain) NSMutableArray *hotListImage;
/** <tag> */
@property (nonatomic, assign) NSInteger gat;
/** <<#draw#>> */
@property (nonatomic, strong) MiddleScrollView *middleScrollView;
/** <热门推荐> */
@property (nonatomic, copy) NSString *hotrecommend;

@end

@implementation IndexViewController
- (NSMutableArray *)bannerList
{
    if (!_bannerList) {
        self.bannerList = [NSMutableArray array];
    }
    return _bannerList;
}
- (NSMutableArray *)categroyList
{
    if (!_categroyList) {
        self.categroyList = [NSMutableArray array];
    }
    return _categroyList;
}
- (NSMutableArray *)topicList
{
    if (!_topicList) {
        self.topicList = [[NSMutableArray alloc] init];
    }
    return _topicList;
}
- (NSMutableArray *)topicListImage
{
    if (!_topicListImage) {
        self.topicListImage = [[NSMutableArray alloc] init];
    }
    return _topicListImage;
}
- (NSMutableArray *)hotList
{
    if (!_hotList) {
        self.hotList = [[NSMutableArray alloc] init];
    }
    return _hotList;
}
- (NSMutableArray *)hotListImage
{
    if (!_hotListImage) {
        self.hotListImage = [[NSMutableArray alloc] init];
    }
    return _hotListImage;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"地图" style:0 target:self action:@selector(toMap)];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"LZIndexTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
#pragma mark    //数据请求
    [self requestModel];
}
- (void)toMap{
    LZMapViewController *lz = [LZMapViewController new];
    [self.navigationController pushViewController:lz animated:YES];
    
    
}
#pragma mark    //数据请求
- (void)requestModel{
    NSString *URLString = kIndex;
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    
    [sessionManager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *responseObject) {
//        fSLog(@"%@",responseObject);
        NSDictionary *indexList = responseObject[@"indexList"];
        NSDictionary *customtitle = indexList[@"customtitle"];
        self.hotrecommend = customtitle[@"hotrecommend"];
        //5
        NSArray *bannerList_Plus = [Index objectArrayWithKeyValuesArray:indexList[@"bannerList"]];
        for (int i = 0; i < bannerList_Plus.count; i++) {
            Index *index = bannerList_Plus[i];
            [self.bannerList addObject:index];
        }
        
        //16
        NSArray *categroyList_Plus = [Index objectArrayWithKeyValuesArray:indexList[@"categroyList"]];
        for (int i = 0; i < categroyList_Plus.count; i++) {
            Index *index = categroyList_Plus[i];
            [self.categroyList addObject:index];
        }
        //4
        NSArray *topicList_Plus = [Index objectArrayWithKeyValuesArray:indexList[@"topicList"]];
        for (int i = 0; i < topicList_Plus.count; i++) {
            Index *index = topicList_Plus[i];
            [self.topicList addObject:index];
            showpicM *showpicm = topicList_Plus[i];
            [self.topicListImage addObject:showpicm];
                }
        
        
        //cell
        NSArray *hotList_Plus = [Index objectArrayWithKeyValuesArray:indexList[@"hotList"]];
        for (int i = 0; i < hotList_Plus.count; i++) {
            Index *index = hotList_Plus[i];
            [self.hotList addObject:index];
            showpicM *showpicm = hotList_Plus[i];
            [self.hotListImage addObject:showpicm];
            
        }
        
        
        [self loadingCustomView];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fSLog(@"%@",error);
    }];
}

- (void)loadingCustomView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.6)];
    self.tableView.tableHeaderView = tableViewHeaderView;
#pragma mark    //轮播图
    HeadScrollView *headScrollView = [[HeadScrollView alloc] initWithFrame:tableViewHeaderView.frame andbannerList:self.bannerList];
    headScrollView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, SCREEN_HEIGHT * 0.2 - 2);
    [tableViewHeaderView addSubview:headScrollView.scrollView];
    headScrollView.pageControl.numberOfPages = 5;
    [tableViewHeaderView addSubview:headScrollView.pageControl];
    for (int i = 90; i < 95; i++) {
        UIButton *btnbn = [self.view viewWithTag:i];
        btnbn.tag = i;
        [btnbn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
#pragma mark    //侧滑图
    self.middleScrollView = [[MiddleScrollView alloc] initWithFrame:tableViewHeaderView.frame andcategroyList:self.categroyList];
    self.middleScrollView.scrollView_Puls.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT * 0.2 - 2);
    [tableViewHeaderView addSubview:self.middleScrollView.scrollView_Puls];
    self.middleScrollView.pageControl_Puls.numberOfPages = 2;
    [tableViewHeaderView addSubview:self.middleScrollView.pageControl_Puls];
    for (int i = 100; i < 116; i++) {
        UIButton *btnbn = [self.view viewWithTag:i];
        btnbn.tag = i;
        [btnbn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
    }
#pragma mark    //4
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            LZPHorizontalButton *btn = [LZPHorizontalButton new];
            btn.backgroundColor = [UIColor colorWithRed:0.177 green:0.803 blue:0.020 alpha:1.000];
            if (j == 0) {
                btn.frame = CGRectMake(i * SCREEN_WIDTH / 2,SCREEN_HEIGHT * 0.4 + 2, SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.1 - 1);
                btn.tag = i;
                Index *index = self.topicList[i];
                showpicM *showpicm = self.topicListImage[i];
                [btn setTitle:index.title forState:UIControlStateNormal];
                NSURL *URL = [NSURL URLWithString:showpicm.showpic[0][@"image"]];
                [btn sd_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:nil];
            } else {
                btn.frame = CGRectMake(i * SCREEN_WIDTH / 2,SCREEN_HEIGHT * 0.5, SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.1 - 2);
                btn.tag = i + 2;
                Index *index = self.topicList[i + 2];
                showpicM *showpicm = self.topicListImage[i + 2];
                [btn setTitle:index.title forState:UIControlStateNormal];
                NSURL *URL = [NSURL URLWithString:showpicm.showpic[0][@"image"]];
                [btn sd_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:nil];
            }
//            btn.imageView.x = CGRectGetMaxX(btn.titleLabel.frame) + 10;
            [btn addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
            [btn setClipsToBounds:YES];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tableViewHeaderView addSubview:btn];
        }
    }
}


- (void)selectAction:(UIButton *)btn{
//    fSLog(@"%lu",btn.tag);
    if (btn.tag < 5) {
        LZLifeViewController *lz = [LZLifeViewController new];
        [self.navigationController pushViewController:lz animated:YES];
    }else if (btn.tag < 100 && btn.tag > 89) {
        LZAdViewController *lz = [LZAdViewController new];
        lz.tag = btn.tag;
        [self.navigationController pushViewController:lz animated:YES];
    }else{
        LZDetailViewController *lz = [LZDetailViewController new];
        [self.navigationController pushViewController:lz animated:YES];
    }
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicList.count;
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.hotrecommend;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     static NSString *cellidentifier = @"index";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
     if (cell == nil) {
     cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
     }
     Index *index = self.hotList[indexPath.row];
     showpicM *showpicm = self.hotListImage[indexPath.row];
     if (showpicm.showpic.count) {
     [cell.imageView sd_setImageWithURL:[NSURL URLWithString:showpicm.showpic[0][@"image"]] placeholderImage:[UIImage imageNamed:@"iconfont-qq"]];
     }
     cell.textLabel.text = index.title;
     cell.detailTextLabel.text = index.subtitle;

     */
    LZIndexTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Index *index = self.hotList[indexPath.row];
    showpicM *showpicm = self.hotListImage[indexPath.row];
    cell.index = index;
    if (showpicm.showpic.count) {
    cell.showpicm = showpicm;
    }
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_HEIGHT / 5 ;
}
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // ------点击单元格之后，让其自动弹起
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//}



@end



























