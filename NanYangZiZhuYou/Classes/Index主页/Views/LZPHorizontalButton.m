//
//  LZPHorizontalButton.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZPHorizontalButton.h"

@implementation LZPHorizontalButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self p_setupView];
    }
    return self;
}
// 内部只实现一次的样式统一写在一个方法里面,方便用纯代码和,xib和sb创建的时候调用
- (void)p_setupView
{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)awakeFromNib
{
    [self p_setupView];
}

// 更改frame在这个方法里写,当视图尺寸发生改变的时候调用
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 原理很简单,右边的图片尺寸是定死的,但是左边label有多宽不定,所以根据图片大小来更改label尺寸,适配的话自己微调
    // 设置label
    self.titleLabel.x = 0;
    self.titleLabel.y = 0;
    // width = buttonwith - buttonHeigh;
    self.titleLabel.width = self.width - self.height;
    self.titleLabel.height = self.height;
    // 调整图片
    self.imageView.x = self.width - self.height;
    self.imageView.y = 12;
    self.imageView.width = self.height * 2 / 3;
    self.imageView.height = self.height * 2 / 3;
}

@end
