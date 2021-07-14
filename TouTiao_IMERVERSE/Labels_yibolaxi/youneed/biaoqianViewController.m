//
//  biaoqianViewController.m
//  yibolaxi
//
//  Created by Admin on 2021/6/29.
//

#import "biaoqianViewController.h"
#import <Masonry.h>
@interface biaoqianViewController ()

@end

@implementation biaoqianViewController

+(void)popbiaoqian:(UIViewController *)vc{
        biaoqianViewController *b = [[biaoqianViewController alloc]init];
        [vc presentViewController:b animated:YES completion:nil];
}

-(void)back:(UIButton *)bt{
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"执行了！！！！！！");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *back = [[UIButton alloc]init];
    [back setTitle:@"<" forState:UIControlStateNormal];
    [back setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [back.titleLabel setFont:[UIFont systemFontOfSize:24]];
//    [back setEnabled:YES];
    [back addTarget:self action:@selector(back:) forControlEvents:UIControlEventAllEvents];
    
    
    [self.view addSubview:back];
    [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
    }];
   //自己开始做
    UIButton *bian =[[UIButton alloc]init];
    [bian setTitle:@"编辑" forState:UIControlStateNormal];
    [bian setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bian .titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.view addSubview:bian];
    [bian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.right.equalTo(self.view);
            make.width.mas_equalTo(50);
             make.height.mas_equalTo(50);
    }];
    UIButton *rebang =[[UIButton alloc]init];
    //[rebang settile :@"热榜" forstate:UIControlStateNormal];
    [rebang setTitle:@"热榜" forState:UIControlStateNormal];
    [rebang setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    rebang.backgroundColor = [UIColor systemGray2Color];
    [rebang.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:rebang];
    [rebang mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(back.mas_bottom).with.offset(20);
            make.left.equalTo(self.view).with.offset(15);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(35);
    }];
    
    UIButton *xiao =[[UIButton alloc]init];
    [xiao setTitle:@"小说" forState:UIControlStateNormal];
    [xiao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    xiao.backgroundColor = [UIColor systemGray2Color];
    [xiao.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:xiao];
    [xiao mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rebang.mas_bottom).with.offset(40);
            make.left.equalTo(rebang.mas_left);
       // make.size.equalTo(rebang);等于他所（选的）值
        make.size.equalTo(rebang);
    

    }];

    UIButton *yu =[[UIButton alloc]init];
    [yu setTitle:@"娱乐" forState:UIControlStateNormal];
    [yu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    yu.backgroundColor = [UIColor systemGray2Color];
    [yu.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:yu];
    [yu mas_makeConstraints:^(MASConstraintMaker *make) {
        //with.offset偏移差
        make.top.equalTo(xiao.mas_bottom).with.offset(40);
        make.left.equalTo(xiao.mas_left);
        make.size.equalTo(xiao);
    }];
    UIButton *tui =[[UIButton alloc]init];
    [tui setTitle:@"推荐" forState:UIControlStateNormal];
    [tui setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    tui.backgroundColor = [UIColor systemGray2Color];
    [tui.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:tui];
    [tui mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rebang.mas_top);
            make.left.equalTo(rebang.mas_right).with.offset(20);
            make.size.equalTo(rebang);
    }];
    UIButton *shi =[[UIButton alloc]init];
    [shi setTitle:@"视频" forState:UIControlStateNormal];
    [shi setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shi.backgroundColor = [UIColor systemGray2Color];
    [shi.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:shi];
    [shi mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xiao.mas_top);
        make.left.equalTo(xiao.mas_right).with.offset(20);
        make.size.equalTo(xiao);
    }];
    UIButton *yao =[[UIButton alloc]init];
    [yao setTitle:@"要闻" forState:UIControlStateNormal];
    [yao setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    yao.backgroundColor = [UIColor systemGray2Color];
    [yao.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:yao];
    [yao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yu.mas_top);
        make.left.equalTo(yu.mas_right).with.offset(20);
        make.size.equalTo(xiao);
        
    }];
    UIButton *tong =[[UIButton alloc]init];
    [tong setTitle:@"同城" forState:UIControlStateNormal];
    [tong setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    tong.backgroundColor = [UIColor systemGray2Color];
    [tong.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:tong];
    [tong mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(rebang.mas_top);
        make.left.equalTo(rebang.mas_right).with.offset(110);
        make.size.equalTo(rebang);
    }];
    UIButton *kang =[[UIButton alloc]init];
    [kang setTitle:@"抗议" forState:UIControlStateNormal];
    [kang setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    kang.backgroundColor = [UIColor systemGray2Color];
    [kang.titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:kang];
    [kang mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(xiao.mas_top);
        make.left.equalTo(xiao.mas_right).with.offset(110);
        make.size.equalTo(xiao);
        
    }];
    UIButton *ke =[[UIButton alloc]init];
    [ke setTitle:@"科技" forState:UIControlStateNormal];
    [ke setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ke.backgroundColor = [UIColor systemGray2Color];
    [ke .titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:ke ];
    [ke  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(yu.mas_top);
        make.left.equalTo(yu.mas_right).with.offset(110);
        make.size.equalTo(yu);
        
    }];
    UIButton *ti =[[UIButton alloc]init];
    [ti setTitle:@"体育" forState:UIControlStateNormal];
    [ti setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    ti.backgroundColor = [UIColor systemGray2Color];
    [ti .titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:ti];
    [ti mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tong.mas_top);
        make.right.equalTo(self.view).with.offset(-15);
        make.size.equalTo(tong);
    }];
    UIButton *wen =[[UIButton alloc]init];
    [wen setTitle:@"问答" forState:UIControlStateNormal];
    [wen setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    wen.backgroundColor = [UIColor systemGray2Color];
    [wen  .titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:wen];
    [wen mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(kang.mas_top);
        make.right.equalTo(self.view).with.offset(-15);
        make.size.equalTo(kang);
    }];
    UIButton *cai =[[UIButton alloc]init];
    [cai setTitle:@"财经" forState:UIControlStateNormal];
    [cai setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cai.backgroundColor = [UIColor systemGray2Color];
    [cai .titleLabel setFont:[UIFont systemFontOfSize:17]];
    [self.view addSubview:cai];
    [cai mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(ke.mas_top);
        make.right.equalTo(self.view).with.offset(-15);
        make.size.equalTo(ke);
    }];


}
@end
