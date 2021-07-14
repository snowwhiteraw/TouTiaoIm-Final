//
//  abcViewController.m
//  yibolaxi
//
//  Created by Admin on 2021/6/29.
//

#import "abcViewController.h"
#import <Masonry.h>

@interface abcViewController ()

@end

@implementation abcViewController

+ (void)popsousuo:(UIViewController *)vc{
    abcViewController *a = [[abcViewController alloc]init];
//    biaoqianViewController *b = [[biaoqianViewController alloc]init];
    [vc presentViewController:a animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.tintColor = [UIColor blueColor];
    
    
    UIButton *sou1 =[[UIButton alloc]init];
//    sou1.backgroundColor =[UIColor redColor];
    [sou1 setTitle:@"🔍" forState:UIControlStateNormal];
    [sou1 setBackgroundImage:[UIImage imageNamed:@"magnifyingglass"] forState:UIControlStateNormal];
    sou1.tintColor = [UIColor blackColor];
    [self.view addSubview:sou1];
    [sou1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(5);
        make.right.equalTo(self.view).with.offset(-5);
        make.width.mas_equalTo(@45);
        make.height.mas_equalTo(@40);
    }];
    
    UITextField *bt1 = [[UITextField alloc]init];
//    bt1.layer.borderColor = [[UIColor blackColor]CGColor];
    //写成用户界面颜色
//    bt1.backgroundColor = [UIColor grayColor];
//    bt1.backgroundColor = [UIColor blueColor];
    bt1.tintColor = [UIColor blackColor];
    
    [bt1 setBorderStyle:UITextBorderStyleRoundedRect];

    [self.view addSubview:bt1];
    [bt1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).with.offset(5);
            make.left.equalTo(self.view).with.offset(5);
        make.right.equalTo(sou1.mas_left);
            make.height.mas_equalTo(@40);
        
        
        
        
        
        //自己开始写的
      
       
            
            
        
        
    }];
    
    //第二个
   //创建一个搜索
    UIButton *button =[[UIButton alloc] init];
    
    //设置Ferm
    //🔍view.frame =CGRectMake(0, 0, 200, 50);
    //把搜索view加到self.view中
//    [self.view addSubview:buttonview];
    //禁用autoresizing
//    buttonview.translatesAutoresizingMaskIntoConstraints =NO;
//    //创建并添加约束
//    //创建🔍view的高度的约束
//    NSLayoutConstraint *buttonhc =[NSLayoutConstraint constraintWithItem:buttonview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:50];
//    //把约束添加到控件上
//    [buttonview addConstraint:buttonhc];
//
//
//    //创建🔍view的左边
//    NSLayoutConstraint *buttonleft =[NSLayoutConstraint constraintWithItem:buttonview attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:buttonview.superview attribute:NSLayoutAttributeLeft multiplier:1.0 constant:200];
//
//    [self.view addConstraint:buttonleft];
//    //创建🔍view的上边
//    NSLayoutConstraint *buttontop =[NSLayoutConstraint constraintWithItem:buttonview attribute:NSLayoutAttributeTop  relatedBy:NSLayoutRelationEqual toItem:buttonview.superview attribute:NSLayoutAttributeTop multiplier:1.0 constant:40];
//    [self.view addConstraint:buttontop];
//    //创建🔍view的右边
//    NSLayoutConstraint *buttonRight =[NSLayoutConstraint constraintWithItem:buttonview attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:buttonview.superview attribute:NSLayoutAttributeRight multiplier:1.0 constant:-40];
//    [self.view addConstraint:buttonRight];
    

    
    
    

}
@end



