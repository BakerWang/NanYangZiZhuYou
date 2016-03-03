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

@interface IndexViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 数据 */
@property (nonatomic, retain) NSMutableArray *bannerList;
/** 类别 */
@property (nonatomic, retain) NSMutableArray *categroyList;
/** scrollView图片上 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** scrollView_Puls图片下 */
@property (nonatomic, strong) UIScrollView *scrollView_Puls;
/** pageControl大文字上 */
@property(nonatomic, retain) UIPageControl *pageControl;
/** pageControl_Puls小文字下 */
@property (nonatomic, strong) UIPageControl *pageControl_Puls;
/** 吃美住娱 */
@property (nonatomic, retain) NSMutableArray *topicList;
/** cell */
@property (nonatomic, retain) NSMutableArray *hotList;
@property(nonatomic, retain) NSTimer *timer;

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
- (NSMutableArray *)hotList
{
    if (!_hotList) {
        self.hotList = [[NSMutableArray alloc] init];
    }
    return _hotList;
}
- (void)loadView{
    [super loadView];
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
        NSArray *topicList_Plus = [Index objectArrayWithKeyValuesArray:indexList[@"topicList"]];;
        for (int i = 0; i < topicList_Plus.count; i++) {
            Index *index = topicList_Plus[i];
            [self.topicList addObject:index];
            showpicM *showpicm = index.showpicArray[i];
            fSLog(@"%@",showpicm.showpic);
        }
        
        //cell
        NSArray *hotList_Plus = [Index objectArrayWithKeyValuesArray:indexList[@"hotList"]];
        for (int i = 0; i < hotList_Plus.count; i++) {
            Index *index = hotList_Plus[i];
            [self.hotList addObject:index];
        }
        
        [self loadingCustomView];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fSLog(@"%@",error);
    }];
}
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.2 - 2)];
        self.scrollView.backgroundColor = [UIColor darkGrayColor];
        self.scrollView.delegate = self;
        //整屏滑动
        self.scrollView.pagingEnabled = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.2 - 30, SCREEN_WIDTH, 30)];
        self.pageControl.pageIndicatorTintColor = [UIColor blueColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];

    }
    return _pageControl;
}
- (void)loadingCustomView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.6)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, SCREEN_HEIGHT * 0.2);
    [tableViewHeaderView addSubview:self.scrollView];
    self.pageControl.numberOfPages = 5;
    [tableViewHeaderView addSubview:self.pageControl];
#pragma mark 数组图片
    for (int i = 0; i < self.bannerList.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.2 - 2)];
        Index *index = self.bannerList[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:index.showpic] placeholderImage:nil];
        [self.scrollView addSubview:imageView];
    }
    //定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollViewAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    
    
    [self chidren:tableViewHeaderView];
    
    self.tableView.tableHeaderView = tableViewHeaderView;
}

- (void)scrollViewAction{
    NSInteger i = self.pageControl.currentPage;
    if (i == 4) {
        i = -1;
    }
    i++;
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = i * SCREEN_WIDTH;
    [self.scrollView setContentOffset:offset animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGPoint offSet = self.scrollView.contentOffset;
    CGFloat width = self.scrollView.frame.size.width;
    self.pageControl.currentPage = offSet.x / width;
}
//当用户拖拽scrollView的时候，移除定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate], self.timer = nil;
}
//当用户停止拖拽时，添加定时器
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(scrollViewAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

//切换视图时，移除定时器
- (void)viewWillDisappear:(BOOL)animated{
    [self.timer invalidate], self.timer = nil;
}
#pragma mark    //Plus
#pragma mark    //当前位置
- (void)pateSelectAction:(UIPageControl *)pageControl{
    _scrollView_Puls.contentOffset = CGPointMake(pageControl.currentPage * _scrollView_Puls.frame.size.width, 0);
}

#pragma mark    //停止时的位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _pageControl_Puls.currentPage = _scrollView_Puls.contentOffset.x / _scrollView_Puls.frame.size.width;
}
- (UIScrollView *)scrollView_Puls
{
    if (!_scrollView_Puls) {
        self.scrollView_Puls = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.2 + 2, SCREEN_WIDTH, SCREEN_HEIGHT * 0.2 - 2)];
        self.scrollView_Puls.delegate = self;
        //整屏滑动
        self.scrollView_Puls.pagingEnabled = YES;
        self.scrollView_Puls.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView_Puls;
}
- (UIPageControl *)pageControl_Puls
{
    if (!_pageControl_Puls) {
        self.pageControl_Puls = [[UIPageControl alloc] init];
        self.pageControl_Puls = [[UIPageControl alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT * 0.4 - 30, SCREEN_WIDTH, 30)];
        self.pageControl_Puls.pageIndicatorTintColor = [UIColor blueColor];
        self.pageControl_Puls.currentPageIndicatorTintColor = [UIColor redColor];
        
        [_pageControl_Puls addTarget:self action:@selector(pateSelectAction:) forControlEvents:UIControlEventValueChanged];
    }
    return _pageControl_Puls;
}
- (void)chidren:(UIView *)tableViewHeaderView{
    self.scrollView_Puls.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT * 0.2 - 2);
    [tableViewHeaderView addSubview:self.scrollView_Puls];
    self.pageControl_Puls.numberOfPages = 2;
    [tableViewHeaderView addSubview:self.pageControl_Puls];
#pragma mark    //16
    /** //    for (int i = 0; i < 8; i++) {
     //        for (int j = 1; j < 3; j++) {
     //            UIImageView *imageView = [[UIImageView alloc] init];
     //            if (j == 1) {
     //                imageView.frame = CGRectMake(i * SCREEN_WIDTH / 4,0, SCREEN_WIDTH / 4, SCREEN_HEIGHT * 0.1 - 1);
     //                Index *index = self.categroyList[i];
     //                [imageView sd_setImageWithURL:[NSURL URLWithString:index.icon] placeholderImage:nil];
     //            }else{
     //                imageView.frame = CGRectMake(i * SCREEN_WIDTH / 4,SCREEN_HEIGHT * 0.1, SCREEN_WIDTH / 4, SCREEN_HEIGHT * 0.1 - 2);
     //                Index *index = self.categroyList[i + 8];
     //                [imageView sd_setImageWithURL:[NSURL URLWithString:index.icon] placeholderImage:nil];
     //            }
     //            [self.scrollView_Puls addSubview:imageView];
     //        }
     //    } */
    //按钮16
    for (int i = 0; i < 8; i++) {
        for (int j = 0; j < 2; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setBackgroundColor:[UIColor yellowColor]];
            btn.frame = CGRectMake(i * SCREEN_WIDTH / 4,j * SCREEN_HEIGHT * 0.1, SCREEN_WIDTH / 4, SCREEN_HEIGHT * 0.1 - 2);
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            if (j == 0) {
                Index *index = self.categroyList[i];
                [btn setTitle:index.categroyname forState:UIControlStateNormal];
                [btn sd_setImageWithURL:[NSURL URLWithString:index.icon] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"btmbar_home_favor_normal"]];
            } else {
                Index *index = self.categroyList[i + 8];
                [btn setTitle:index.categroyname forState:UIControlStateNormal];
                NSURL *URL = [NSURL URLWithString:index.icon];
                [btn sd_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"btmbar_home_favor_normal"]];
            }
//            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, SCREEN_WIDTH * 0.1 * 0.2, 0);
//            btn.titleEdgeInsets = UIEdgeInsetsMake(0, SCREEN_WIDTH * 0.1 * 0.8, 0, 0);
            [btn setClipsToBounds:YES];
            [self.scrollView_Puls addSubview:btn];
        }
    }

    
#pragma mark    //4
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor colorWithRed:arc4random() %256/255.0f green:arc4random() %256/255.0f blue:arc4random() %256/255.0f alpha:arc4random() %256/255.0f];
            if (j == 0) {
                btn.frame = CGRectMake(i * SCREEN_WIDTH / 2,SCREEN_HEIGHT * 0.4 + 2, SCREEN_WIDTH / 4, SCREEN_HEIGHT * 0.1 - 1);
                Index *index = self.topicList[i];
                [btn setTitle:index.content forState:UIControlStateNormal];
            } else {
                btn.frame = CGRectMake(i * SCREEN_WIDTH / 2,SCREEN_HEIGHT * 0.5, SCREEN_WIDTH / 4, SCREEN_HEIGHT * 0.1 - 2);
                Index *index = self.topicList[i+2];
                [btn setTitle:index.content forState:UIControlStateNormal];
            }
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [tableViewHeaderView addSubview:btn];
        }
    }
}
- (void)test{
    
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
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:index.showpic] placeholderImage:nil];
    cell.textLabel.text = index.title;
    cell.detailTextLabel.text = index.subtitle;
    return cell;
    
}



@end
