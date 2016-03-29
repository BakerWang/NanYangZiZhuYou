//
//  Index.h
//  NanYangZiZhuYou
//
//  Created by scjy on 16/2/21.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "showpicM.h"

@interface Index : NSObject
//bannerList 5
/** 头图片 */
@property (nonatomic, copy) NSString *showpic;

//categroyList 16
/** 图片 */
@property (nonatomic, copy) NSString *icon;
/** 名称 */
@property (nonatomic, copy) NSString *categroyname;

//topicList 4
/** 吃美住娱_主 */
@property (nonatomic, copy) NSString *content;
/** 吃美住娱_副  cell主标题*/
@property (nonatomic, copy) NSString *title;

//hotList
/** <热门推荐> */
@property (nonatomic, copy) NSString *hotrecommend;
/** cell副标题 */
@property (nonatomic, copy) NSString *subtitle;
/** <县> */
@property (nonatomic, copy) NSString *cname;
/** <筛选> */
@property (nonatomic, copy) NSString *ordername;
/** <价格> */
@property (nonatomic, copy) NSString *originalprice;

//详情页面
/** <名字> */
@property (nonatomic, copy) NSString *shopname;
/** <平均价格> */
@property (nonatomic, copy) NSString *averageconsumer;
/** <类型> */
@property (nonatomic, copy) NSString *secondname;
/** <距离> */
@property (nonatomic, copy) NSString *distance;
/** <地址> */
@property (nonatomic, copy) NSString *address;

@end













