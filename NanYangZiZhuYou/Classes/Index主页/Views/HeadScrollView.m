//滚动图

#import "HeadScrollView.h"
#import "Index.h"


#import <SDWebImage/UIImageView+WebCache.h>
@interface HeadScrollView()<UIScrollViewDelegate>
@property(nonatomic, retain) NSTimer *timer;

@end
@implementation HeadScrollView

- (instancetype)initWithFrame:(CGRect)frame andbannerList:(NSMutableArray *)bannerList{
    self = [super initWithFrame:frame];
    if (self) {
        self.bannerList = bannerList;
        [self loadingCustomView];
    }
    return self;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.2 - 2)];
        self.scrollView.backgroundColor = [UIColor darkGrayColor];
        self.scrollView.delegate = self;
        //整屏滑动
        self.scrollView.pagingEnabled = YES;
        ////是否显示水平方向的滚动条
        self.scrollView.showsHorizontalScrollIndicator = NO;
        //是否反弹左右
        self.scrollView.alwaysBounceHorizontal = NO;
        //上下是否可以反弹
        self.scrollView.alwaysBounceVertical = NO;
        //边界不滑动
//        self.scrollView.bounces = NO;
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
    for (int i = 0; i < self.bannerList.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT * 0.2 - 2)];
        imageView.userInteractionEnabled = YES;
        Index *index = self.bannerList[i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:index.showpic] placeholderImage:nil];
        [self.scrollView addSubview:imageView];
        UIButton *touchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        touchBtn.frame = imageView.frame;
        touchBtn.tag = 90 + i;
        [self.scrollView addSubview:touchBtn];
    }
    //定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(scrollViewAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    [_pageControl addTarget:self action:@selector(pateSelectAction:) forControlEvents:UIControlEventValueChanged];
    
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
    self.pageControl.currentPage = self.scrollView.contentOffset.x / SCREEN_WIDTH;
}
#pragma mark    //当前位置
- (void)pateSelectAction:(UIPageControl *)pageControl{
    //滚动的当前页面
    self.scrollView.contentOffset = CGPointMake(pageControl.currentPage * self.scrollView.frame.size.width, 0);
}
#pragma mark    //停止时的位置
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    //当前页面的位置宽度 除以 单个宽度
    self.pageControl.currentPage = self.scrollView.contentOffset.x / self.scrollView.frame.size.width;
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

@end





















