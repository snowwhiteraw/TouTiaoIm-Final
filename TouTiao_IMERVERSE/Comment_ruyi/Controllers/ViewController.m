//
//  ViewController.m
//  toutiao_Comment
//
//  Created by Admin on 2021/6/27.
//

#import "ViewController.h"
#import <Masonry.h>
#import "Comment_ViewController.h"

#import "CommentModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *lb1 = [[UIButton alloc]init];
    [lb1 setTitle:@"给我转" forState:UIControlStateNormal];
    lb1.backgroundColor = [UIColor systemBlueColor];
    [self.view addSubview:lb1];
    [lb1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(100, 30));
            make.center.equalTo(self.view);
    }];
    [lb1 addTarget:self action:@selector(ba1:) forControlEvents:UIControlEventTouchUpInside];

}

- (void) ba1 :(UIButton *) b1{
    //主页面跳转评论页

    CommentModel *model = [[CommentModel alloc]init];
    model.name = @"我";
    model.touXiang = @"tou.png";
    [Comment_ViewController pop:self andid:1  andmodel:model];
//    NSLog(@"-------%ld",(long)in1);
}

@end
