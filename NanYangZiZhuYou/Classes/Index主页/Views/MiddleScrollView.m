//滑动图

#import "middleScrollView.h"
#import "Index.h"


#import <SDWebImage/UIButton+WebCache.h>
@interface MiddleScrollView()<UIScrollViewDelegate>

@end
@implementation MiddleScrollView
- (instancetype)initWithFrame:(CGRect)frame andcategroyList:(NSMutableArray *)categroyList{
    if ([super initWithFrame:frame]) {
        self.categroyList = categroyList;
        [self loadingCustomView];
    }
    return self;
}
- (void)loadingCustomView{
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
                [btn sd_setImageWithURL:[NSURL URLWithString:index.icon] forState:UIControlStateNormal placeholderImage:nil];
            } else {
                Index *index = self.categroyList[i + 8];
                [btn setTitle:index.categroyname forState:UIControlStateNormal];
                NSURL *URL = [NSURL URLWithString:index.icon];
                [btn sd_setImageWithURL:URL forState:UIControlStateNormal placeholderImage:nil];
            }
            
            //            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, SCREEN_WIDTH * 0.1 * 0.2, 0);
            //            btn.titleEdgeInsets = UIEdgeInsetsMake(0, SCREEN_WIDTH * 0.1 * 0.8, 0, 0);
            [btn setClipsToBounds:YES];
            btn.imageView.x = CGRectGetMaxX(btn.titleLabel.frame) + 10;
            [self.scrollView_Puls addSubview:btn];
        }
    }
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
        ////是否显示水平方向的滚动条
        self.scrollView_Puls.showsHorizontalScrollIndicator = NO;
        //是否反弹左右
        self.scrollView_Puls.alwaysBounceHorizontal = NO;
        //上下是否可以反弹
        self.scrollView_Puls.alwaysBounceVertical = NO;
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

@end










