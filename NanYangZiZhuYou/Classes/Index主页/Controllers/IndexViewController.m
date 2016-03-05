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

@interface IndexViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
/** 轮播数据 */
@property (nonatomic, retain) NSMutableArray *bannerList;
/** 滑动类别 */
@property (nonatomic, retain) NSMutableArray *categroyList;
/** 吃美住娱 */
@property (nonatomic, retain) NSMutableArray *topicList;
/** cell */
@property (nonatomic, retain) NSMutableArray *hotList;
@property(nonatomic, retain) NSTimer *timer;
/** <#draw#> */
@property (nonatomic, strong) NSMutableArray *bannerListStr;
/** <#draw#> */
@property (nonatomic, strong) NSMutableArray *topicListStr;

@end

@implementation IndexViewController
- (NSMutableArray *)topicListStr
{
    if (!_topicListStr) {
        self.topicListStr = [[NSMutableArray alloc] init];
    }
    return _topicListStr;
}
- (NSMutableArray *)bannerListStr
{
    if (!_bannerListStr) {
        self.bannerListStr = [[NSMutableArray alloc] init];
    }
    return _bannerListStr;
}
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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
#pragma mark    //数据请求
    [self requestModel];
    
//    BmobObject *user = [BmobObject objectWithClassName:@"content"];
//    [user sub_saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//        fSLog(@"success");
//    }];
    
    BmobACL *acl = [BmobACL ACL];
    //设置所有人读权限为true
    [acl setPublicReadAccess];
    //设置所有人写权限为true
    [acl setPublicWriteAccess];
    
    //轮播图数据
    NSArray *idArray = @[@"wVmOXXX2",@"0Bmo111T",@"qtXhCCCd",@"LflO222J",@"gOZXbbbO"];
    NSString *key = @"showPic";
    [self getqueryWithClassName:@"content" idArray:idArray key:key returnMArray:self.bannerListStr];
    //四个按钮
    NSArray *siArray = @[@"MTlmIIIC",@"2XWj1117",@"Z7JlDDDK",@"PQVq2223"];
    NSString *siKey = @"content";
    [self getqueryWithClassName:@"topiclist" idArray:siArray key:siKey returnMArray:self.topicListStr];
    
    
}
- (void)getqueryWithClassName:(NSString *)name idArray:(NSArray *)idarray key:(NSString *)key returnMArray:(NSMutableArray *)returnMArray{
    BmobQuery *bquery = [BmobQuery queryWithClassName:name];
    for (NSString *Id in idarray) {
        [bquery getObjectInBackgroundWithId:Id block:^(BmobObject *object, NSError *error) {
            if (object) {
                    NSString *str = [object objectForKey:key];
                    [returnMArray addObject:str];
//                fSLog(@"%@",str);
//                fSLog(@"%lu",returnMArray.count);
            }else{
                if (error) {
                    fSLog(@"%@",error);
                    
                }
            }
        }];
    }
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

- (void)loadingCustomView{
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.6)];
    self.tableView.tableHeaderView = tableViewHeaderView;
    
    HeadScrollView *headScrollView = [[HeadScrollView alloc] initWithFrame:tableViewHeaderView.frame andbannerList:self.bannerList];
    headScrollView.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 5, SCREEN_HEIGHT * 0.2);
    [tableViewHeaderView addSubview:headScrollView.scrollView];
    headScrollView.pageControl.numberOfPages = 5;
    [tableViewHeaderView addSubview:headScrollView.pageControl];
  
    MiddleScrollView *middleScrollView = [[MiddleScrollView alloc] initWithFrame:tableViewHeaderView.frame andcategroyList:self.categroyList];
    middleScrollView.scrollView_Puls.contentSize = CGSizeMake(SCREEN_WIDTH * 2, SCREEN_HEIGHT * 0.2 - 2);
    [tableViewHeaderView addSubview:middleScrollView.scrollView_Puls];
    middleScrollView.pageControl_Puls.numberOfPages = 2;
    [tableViewHeaderView addSubview:middleScrollView.pageControl_Puls];
#pragma mark    //4
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor colorWithRed:arc4random() %256/255.0f green:arc4random() %256/255.0f blue:arc4random() %256/255.0f alpha:arc4random() %256/255.0f];
            if (j == 0) {
                btn.frame = CGRectMake(i * SCREEN_WIDTH / 2,SCREEN_HEIGHT * 0.4 + 2, SCREEN_WIDTH / 4, SCREEN_HEIGHT * 0.1 - 1);
//                showpicM *showpicm = self.topicList[i];
                Index *index = self.topicList[i];
                [btn setTitle:index.title forState:UIControlStateNormal];
//                fSLog(@"%@",showpicm.image);
//                [btn setTitle:self.topicListStr[i] forState:UIControlStateNormal];
//                NSURL *URL = [NSURL URLWithString:showpicm.image];
//                [btn sd_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:nil];
            } else {
                btn.frame = CGRectMake(i * SCREEN_WIDTH / 2,SCREEN_HEIGHT * 0.5, SCREEN_WIDTH / 4, SCREEN_HEIGHT * 0.1 - 2);
//                showpicM *showpicm = self.topicList[i + 2];
                Index *index = self.topicList[i + 2];
                [btn setTitle:index.title forState:UIControlStateNormal];
//                fSLog(@"%@",showpicm.image);
//                [btn setTitle:self.topicListStr[i + 2] forState:UIControlStateNormal];
//                NSURL *URL = [NSURL URLWithString:showpicm.image];
//                [btn sd_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:nil];
            }
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
//    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:index.showpic] placeholderImage:nil];
    cell.textLabel.text = index.title;
    cell.detailTextLabel.text = index.subtitle;
    return cell;
    
}



@end
