//滑动图

#import <UIKit/UIKit.h>

@interface MiddleScrollView : UIScrollView
@property (nonatomic, strong) UIScrollView *scrollView_Puls;
@property (nonatomic, strong) UIPageControl *pageControl_Puls;
@property (nonatomic, strong) NSMutableArray *categroyList;
- (instancetype)initWithFrame:(CGRect)frame andcategroyList:(NSMutableArray *)categroyList;
@end
