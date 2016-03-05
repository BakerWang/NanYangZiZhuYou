//滑动图

#import <UIKit/UIKit.h>

@interface middleScrollView : UIScrollView
@property (nonatomic, strong) UIScrollView *scrollView_Puls;
@property (nonatomic, strong) UIPageControl *pageControl_Puls;
- (instancetype)initWithFrame:(CGRect)frame andcategroyname:(NSMutableArray *)categroyname;
@end
