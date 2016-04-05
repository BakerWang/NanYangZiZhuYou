//
//  LZPVerticalButton.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZPVerticalButton.h"

@implementation LZPVerticalButton
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_setup];
    }
    return self;
}
- (void)p_setup
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}
- (void)awakeFromNib
{
    [self p_setup];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 调整图片
    self.imageView.x = self.width / 4;
    self.imageView.y = 0;
    self.imageView.width = self.width / 2;
    self.imageView.height = self.width / 2;
    
    // 调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
//    NSLog(@"%zd",self.imageView.height);
//    NSLog(@"---%zd",self.titleLabel.y);
}

@end



























