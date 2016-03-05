//滚动图

#import <UIKit/UIKit.h>

@interface HeadScrollView : UIScrollView
@property (nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *bannerList;
- (instancetype)initWithFrame:(CGRect)frame andbannerList:(NSMutableArray *)bannerList;

@end
