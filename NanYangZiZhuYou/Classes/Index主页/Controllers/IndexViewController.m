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
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
#pragma mark    //数据请求
    [self requestModel];
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
//            if (showpicm) {
//                fSLog(@"%@",showpicm.showpic[0][@"image"]);
//            }
            
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
#pragma mark    //侧滑图
    MiddleScrollView *middleScrollView = [[MiddleScrollView alloc] initWithFrame:tableViewHeaderView.frame andcategroyList:self.categroyList];
    middleScrollView.scrollView_Puls.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT * 0.2 - 2);
    [tableViewHeaderView addSubview:middleScrollView.scrollView_Puls];
    middleScrollView.pageControl_Puls.numberOfPages = 2;
    [tableViewHeaderView addSubview:middleScrollView.pageControl_Puls];
#pragma mark    //4
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            UIButton *btn = [[UIButton alloc] init];
            btn.backgroundColor = [UIColor colorWithRed:0.177 green:0.803 blue:0.020 alpha:1.000];
            if (j == 0) {
                btn.frame = CGRectMake(i * SCREEN_WIDTH / 2,SCREEN_HEIGHT * 0.4 + 2, SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.1 - 1);
                Index *index = self.topicList[i];
                showpicM *showpicm = self.topicListImage[i];
                [btn setTitle:index.title forState:UIControlStateNormal];
                NSURL *URL = [NSURL URLWithString:showpicm.showpic[0][@"image"]];
                [btn sd_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:nil];
            } else {
                btn.frame = CGRectMake(i * SCREEN_WIDTH / 2,SCREEN_HEIGHT * 0.5, SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.1 - 2);
                Index *index = self.topicList[i + 2];
                showpicM *showpicm = self.topicListImage[i + 2];
                [btn setTitle:index.title forState:UIControlStateNormal];
                NSURL *URL = [NSURL URLWithString:showpicm.showpic[0][@"image"]];
                [btn sd_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:nil];
            }
//            [btn setClipsToBounds:YES];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tableViewHeaderView addSubview:btn];
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.topicList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellidentifier = @"index";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    Index *index = self.hotList[indexPath.row];
//    showpicM *showpicm = self.hotListImage[indexPath.row];
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:showpicm.showpic[0][@"image"]] placeholderImage:nil];
    cell.textLabel.text = index.title;
    cell.detailTextLabel.text = index.subtitle;
    return cell;
    
}



@end
