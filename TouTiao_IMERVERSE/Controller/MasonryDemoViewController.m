//
//  MasonryDemoViewController.m
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/30.
//

#import "MasonryDemoViewController.h"
#import <Masonry/Masonry.h>

@implementation MasonryDemoViewController

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"调用了");
    UILabel * justforfun = [[UILabel alloc]init];
    justforfun.backgroundColor = UIColor.redColor;
    [justforfun setText:@"我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字我是许多字"];
    justforfun.numberOfLines = 0;
    [self.view addSubview:justforfun];
    [justforfun mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.greaterThanOrEqualTo(self.view).insets(UIEdgeInsetsMake(100, 100, 150, 200)); //表示子页面在父页面的距离边缘上100、左100、下150、右200
        make.center.equalTo(self.view);
    }];
}

@end
