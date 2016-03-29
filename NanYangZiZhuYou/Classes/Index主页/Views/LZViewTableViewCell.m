//
//  LZViewTableViewCell.m
//  NanYangZiZhuYou
//
//  Created by scjy on 16/3/13.
//  Copyright © 2016年 李志鹏. All rights reserved.
//

#import "LZViewTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface LZViewTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *nameImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *other;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *address;



@end
@implementation LZViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setIndex:(Index *)index{
    [self.nameImage sd_setImageWithURL:[NSURL URLWithString:index.showpic] placeholderImage:[UIImage imageNamed:@"iconfont-qq"]];
    self.name.text = index.shopname;
    self.price.text = index.averageconsumer;
    self.other.text = index.secondname;
    self.distance.text = index.distance;
    self.address.text = index.address;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end



























