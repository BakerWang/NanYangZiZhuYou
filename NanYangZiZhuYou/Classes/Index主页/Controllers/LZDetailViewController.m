//
//  LZDetailViewController.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/11.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZDetailViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "Index.h"
#import "MJExtension.h"
#import "LZViewTableViewCell.h"


@interface LZDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
/** <县级> */
@property (nonatomic, retain) NSMutableArray *areaList;
/** <筛选> */
@property (nonatomic, retain) NSMutableArray *sortList;
/** <左边> */
@property (nonatomic, strong) UITableView *leftTableView;
/** <右边> */
@property (nonatomic, strong) UITableView *rightTableView;
/** <筛选> */
@property (nonatomic, strong) UITableView *tableView;
/** <视图数据cell> */
@property (nonatomic, strong) UITableView *dataTableView;
@property(nonatomic)         BOOL show;
/** <按钮> */
@property (nonatomic, strong) UIButton *btn;
/** <标题> */
@property (nonatomic, retain) NSArray *array;
/** <生活> */
@property (nonatomic, retain) NSArray *lifeArray;
/** <生活详情> */
@property (nonatomic, retain) NSArray *lifeDetailArray;
/** <通用> */
@property (nonatomic, retain) NSMutableArray *generalArray;
/** <视图数据> */
@property (nonatomic, strong) NSMutableArray *viewArray;
/** <全局button> */
@property (nonatomic, retain) UIButton *generalButton;
@end

@implementation LZDetailViewController
- (UITableView *)dataTableView
{
    if (!_dataTableView) {
        self.dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT - 110) style:UITableViewStylePlain];
        self.dataTableView.delegate = self;
        self.dataTableView.dataSource = self;
//        self.dataTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _dataTableView;
}
- (NSMutableArray *)generalArray
{
    if (!_generalArray) {
        self.generalArray = [[NSMutableArray alloc] init];
    }
    return _generalArray;
}
- (NSMutableArray *)areaList
{
    if (!_areaList) {
        self.areaList = [[NSMutableArray alloc] init];
    }
    return _areaList;
}
- (NSMutableArray *)sortList
{
    if (!_sortList) {
        self.sortList = [[NSMutableArray alloc] init];
    }
    return _sortList;
}
- (UITableView *)leftTableView
{
    if (!_leftTableView) {
        self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.6) style:UITableViewStylePlain];
        self.leftTableView.delegate = self;
        self.leftTableView.dataSource = self;
        self.leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _leftTableView;
}
- (UITableView *)rightTableView
{
    if (!_rightTableView) {
        self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2, 44, SCREEN_WIDTH / 2, SCREEN_HEIGHT * 0.6) style:UITableViewStylePlain];
        self.rightTableView.delegate = self;
        self.rightTableView.dataSource = self;
        self.rightTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _rightTableView;
}
- (UITableView *)tableView
{
    if (!_tableView) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, SCREEN_HEIGHT * 0.3) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (NSMutableArray *)viewArray
{
    if (!_viewArray) {
        self.viewArray = [[NSMutableArray alloc] init];
    }
    return _viewArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor darkGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.dataTableView];
    [self.dataTableView registerNib:[UINib nibWithNibName:@"LZViewTableViewCell" bundle:nil] forCellReuseIdentifier:@"cells"];

#pragma mark    //数据请求
    [self requestModelList];
#pragma mark    //数据请求
    [self requestModelSortList];
#pragma mark    //数据请求
    [self requestModelAreaList];
    
    self.array = @[@"全城",@"全部分类",@"智能排序"];
    self.lifeArray = @[@"全部分类",@"餐饮",@"酒店",@"购物",@"丽人",@"体闲娱乐",@"生活服务",@"政府机构",@"便民服务",@"收藏/宠物",@"旅游服务",@"教育培训"];
    self.lifeDetailArray = @[@"全部",@"工商注册",@"家政/搬家/快递",@"机票/火车票",@"艺术摄影",@"足疗按摩",@"洗衣店",@"教育培训",@"鲜花婚庆",@"儿童摄影",@"婚纱摄影",@"家具建材",@"汽车服务",@"托儿所",@"其他"];
    self.show = YES;
    for (int i = 0; i < 3; i++) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = CGRectMake(i * SCREEN_WIDTH / 3, 0, SCREEN_WIDTH / 3, 44);
        [self.btn setTitle:self.array[i] forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(touchesSelet:) forControlEvents:UIControlEventTouchUpInside];
        [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.btn setClipsToBounds:YES];
        [self.btn setBackgroundColor:[UIColor orangeColor]];
        self.btn.tag = 20 + i;

        [self.view addSubview:self.btn];
    }
}
- (void)touchesSelet:(UIButton *)btn{
    self.generalButton = btn;
    if (!_show) {
        [self.leftTableView removeFromSuperview];
        [self.rightTableView removeFromSuperview];
        [self.tableView removeFromSuperview];
    }
    switch (btn.tag) {
        case 20:
            if (_show) {
                [self.generalArray removeAllObjects];
//                for (int i = 0; i < self.areaList.count; i++) {
//                    Index *index = self.areaList[i];
//                    [self.generalArray addObject:index.cname];
                //                }
                for (Index *index in self.areaList) {
                [self.generalArray addObject:index.cname];
            }
            
                [self.view addSubview:self.leftTableView];
                [self.leftTableView reloadData];
                self.show = NO;
            }else{
                
                self.show = YES;
            }
            break;
        case 21:
            if (_show) {
                [self.generalArray removeAllObjects];
                for (NSString *str in self.lifeArray) {
                    [self.generalArray addObject:str];
                }
                [self.view addSubview:self.leftTableView];
                [self.view addSubview:self.rightTableView];
                [self.leftTableView reloadData];
                [self.rightTableView reloadData];
                self.show = NO;
            }else{
                self.show = YES;
            }
            break;
        case 22:
            if (_show) {
                [self.view addSubview:self.tableView];
                [self.tableView reloadData];
                self.show = NO;
            }else{
                self.show = YES;
            }
            break;
            
        default:
            break;
    }
    
    
}
- (void)requestModelList{
    NSString *URLString = kDetail;
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [sessionManager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        fSLog(@"%@",responseObject);
        //5
        NSArray *indexList_Plus = [Index objectArrayWithKeyValuesArray:responseObject[@"shops"]];
        for (int i = 0; i < indexList_Plus.count; i++) {
            Index *index = indexList_Plus[i];
            [self.viewArray addObject:index];
        }
        [self.dataTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (void)requestModelAreaList{
    NSString *URLString = kArea;
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [sessionManager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        fSLog(@"%@",responseObject);
        //5
        NSArray *indexList_Plus = [Index objectArrayWithKeyValuesArray:responseObject[@"areaList"]];
        for (int i = 0; i < indexList_Plus.count; i++) {
            Index *index = indexList_Plus[i];
            [self.areaList addObject:index];
        }
        [self.leftTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}
- (void)requestModelSortList{
    NSString *URLString = kSort;
    AFHTTPSessionManager *sessionManager = [[AFHTTPSessionManager alloc] init];
    sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [sessionManager GET:URLString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        fSLog(@"%@",responseObject);
        NSArray *ordertype_Plus = [Index objectArrayWithKeyValuesArray:responseObject[@"ordertype"]];
        for (int i = 0; i < ordertype_Plus.count; i++) {
            Index *index = ordertype_Plus[i];
            [self.sortList addObject:index];
        }
        [self.rightTableView reloadData];
        [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.leftTableView) {
        return self.generalArray.count;
    }
    else if (tableView == self.rightTableView) {
        return self.lifeDetailArray.count;
    }
    else if (tableView == self.tableView) {
        return self.sortList.count;
    }
    return self.viewArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellidentifier = @"cell";
    UITableViewCell *cell = [self.leftTableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    if (tableView == self.leftTableView) {
        cell.textLabel.text = self.generalArray[indexPath.row];
        return cell;
    }
    else if (tableView == self.rightTableView) {
        cell.backgroundColor = [UIColor colorWithWhite:0.638 alpha:0.600];
        cell.textLabel.text = self.lifeDetailArray[indexPath.row];
        return cell;
        }
    else if (tableView == self.tableView) {
        Index *index = self.sortList[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",index.ordername];
        return cell;
    }
     LZViewTableViewCell *cells = [self.dataTableView dequeueReusableCellWithIdentifier:@"cells" forIndexPath:indexPath];
    Index *index = self.viewArray[indexPath.row];
    cells.index = index;
    return cells;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.leftTableView) {
        Index *index = self.areaList[indexPath.row];
        if (self.generalButton == [self.view viewWithTag:20]) {
            [self.generalButton setTitle:index.cname forState:UIControlStateNormal];
            [self.leftTableView removeFromSuperview];
        }else if (self.generalButton == [self.view viewWithTag:21]){
        [self.generalButton setTitle:self.lifeArray[indexPath.row] forState:UIControlStateNormal];
        }
    }
    else if (tableView == self.rightTableView) {
        [self.leftTableView removeFromSuperview];
        [self.rightTableView removeFromSuperview];

    }else if (tableView == self.tableView){
        UIButton *button = (UIButton *)[self.view viewWithTag:22];
        Index *index = self.sortList[indexPath.row];
        [button setTitle:index.ordername forState:UIControlStateNormal];
        [self.tableView removeFromSuperview];
        
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.dataTableView) {
        return SCREEN_HEIGHT / 5;
    }
    return 44;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.leftTableView removeFromSuperview];
    [self.rightTableView removeFromSuperview];
    [self.tableView removeFromSuperview];
}
@end



























