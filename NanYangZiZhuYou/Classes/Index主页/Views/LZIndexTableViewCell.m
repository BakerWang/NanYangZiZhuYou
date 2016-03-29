//
//  LZIndexTableViewCell.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/13.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZIndexTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LZIndexTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;


@end
@implementation LZIndexTableViewCell

- (void)drawRect:(CGRect)rect{
//    self.ImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH * 0.4, SCREEN_HEIGHT / 5);
//    self.nameLabel.frame = CGRectMake(SCREEN_WIDTH * 0.4, 0, SCREEN_WIDTH * 0.4 * 2, SCREEN_HEIGHT / 5 * 0.4);
//    self.contentLabel.frame = CGRectMake(SCREEN_WIDTH * 0.4, SCREEN_HEIGHT / 5 * 0.4, SCREEN_WIDTH * 0.4 * 2, SCREEN_HEIGHT / 5 * 0.4);
//    self.priceLabel.frame = CGRectMake(SCREEN_WIDTH * 0.4, SCREEN_HEIGHT / 5 * 0.4 * 2, SCREEN_WIDTH * 0.4 * 2, SCREEN_HEIGHT / 5 * 0.4);
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
}
- (void)awakeFromNib {
    //    [super awakeFromNib];
}
- (void)setIndex:(Index *)index{
    self.nameLabel.text = index.title;
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    self.contentLabel.text = index.subtitle;
    self.contentLabel.font = [UIFont systemFontOfSize:15];
    self.priceLabel.text = [NSString stringWithFormat:@"%@元",index.originalprice];
    [self setNeedsDisplay];
//    [self setNeedsLayout];

}
- (void)setShowpicm:(showpicM *)showpicm{
    [self.ImageView sd_setImageWithURL:[NSURL URLWithString:showpicm.showpic[0][@"image"]] placeholderImage:[UIImage imageNamed:@"iconfont-qq"]];
    [self setNeedsDisplay];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
