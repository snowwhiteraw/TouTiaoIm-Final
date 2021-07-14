//
//  NotificationViewController.m
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/20.
//

#import "NotificationViewController.h"
#import "FSScrollContentView.h"

@interface NotificationViewController () <FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic,strong) NSMutableArray * dataArr;//标签页数组
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    self.dataArr = @[@"全部",@"系统通知",@"私信",@"评论",@"粉丝",@"点赞",@"@我"];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"pageContentView";
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 90, CGRectGetWidth(self.view.bounds), 50) titles:self.dataArr delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:10];
    self.titleView.selectIndex = 2;
    [self.view addSubview:_titleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in self.dataArr) { //这里可能要根据具体去看具体做，但是只是做样式而已，不用太操心数据源，不要本末倒置
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = UIColor
        .whiteColor;
        vc.title = title;
        [childVCs addObject:vc];
    }
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 124, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = 2;
    self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
    
    [self.view addSubview:_pageContentView];
    
    
    
    
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
    self.title = self.dataArr[endIndex];
}

- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    self.title = self.dataArr[endIndex];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
