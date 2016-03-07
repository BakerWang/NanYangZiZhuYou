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
/** 头图片 */
@property (nonatomic, copy) NSString *showpic;
/** 图片 */
@property (nonatomic, copy) NSString *icon;
/** 名称 */
@property (nonatomic, copy) NSString *categroyname;
/** 吃美住娱_主 */
@property (nonatomic, copy) NSString *content;
/** 吃美住娱_副  cell主标题*/
@property (nonatomic, copy) NSString *title;
/** cell副标题 */
@property (nonatomic, copy) NSString *subtitle;
/** cell详细图片 */
//@property (nonatomic, copy) NSArray *showpicArray;
/** <<#draw#>> */
//@property (nonatomic, strong) showpicM *showpicm;

@end
