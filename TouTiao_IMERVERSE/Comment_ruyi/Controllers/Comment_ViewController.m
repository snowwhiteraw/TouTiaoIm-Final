//
//  Comment_ViewController.m
//  toutiao_Comment
//
//  Created by Admin on 2021/6/27.
//

#import "Comment_ViewController.h"
#import <Masonry.h>
#import "Comment_TableViewCell.h"
#import "CommentModel.h"
#import "SQLiteManager.h"

@interface Comment_ViewController ()<UITextViewDelegate>

@property UITableView *tableview;
@property NSInteger hight;
//这个数组用来存储评论的plist数据
@property (strong)SQLiteManager *manager;
@property (nonatomic,strong)NSMutableArray *commentArray;
@property (nonatomic,strong)NSString *path;

@property(nonatomic,strong)UIView *bottomView;
@property(nonatomic,strong)UITextView *replyTextView;
@property(nonatomic,strong)UIButton *replyBotton;

@property(nonatomic)int articleid;
@property(nonatomic,strong)CommentModel *user;


@end
@implementation Comment_ViewController

#pragma mark 这里通过通知实现了cell中菜单按钮的功能，获得某cell的用户名或评论
- (void)shard:(NSNotification *)noti{//分享按钮的通知响应
    UIAlertController *alerk = [UIAlertController alertControllerWithTitle:@"" message:@"已复制该评论，快去粘贴分享吧！" preferredStyle:UIAlertControllerStyleAlert];
        [alerk addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alerk animated:YES completion:nil];
    NSLog(@"\n%@:\n%@",[noti.userInfo objectForKey:@"sharededname"],[noti.userInfo objectForKey:@"sharededdate"]);
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:[NSString stringWithFormat:@"用户”%@“的评论:\n%@",[noti.userInfo objectForKey:@"sharededname"],[noti.userInfo objectForKey:@"sharededdate"]]];
}

- (void)jubao:(NSNotification *)noti{//举报按钮的通知响应
    UIAlertController *alerk = [UIAlertController alertControllerWithTitle:@"" message:@"举报成功，审核中..." preferredStyle:UIAlertControllerStyleAlert];
        [alerk addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alerk animated:YES completion:nil];
    NSLog(@"%@ 被举报啦！！",[noti.userInfo objectForKey:@"jubaoname"]);
}


#pragma mark 懒加载模型数据到NSArray类型的commentArray数据里
- (NSArray *)commentArray{
    self.manager = [[SQLiteManager alloc]init];
    if(!_commentArray){
    [self.manager openDBWithPath:@"/Users/a123/toutiaoComment.db"];
    _commentArray = [self.manager select:self.articleid];
    }
    return _commentArray;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
#pragma mark 一些通知接收
    //举报按钮
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(jubao:) name:@"Notify_jubao" object:nil];
    //分享按钮
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(shard:) name:@"Notify_shard" object:nil];

    
#pragma mark 评论页的纯代码搭建
    
    //-----------------顶部------------------
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *toplabel = [[UILabel alloc]init];
    [toplabel setText:@"下拉关闭↓"];
    toplabel.textAlignment = NSTextAlignmentCenter;
    toplabel.userInteractionEnabled = YES;
    //点击关闭评论页方法
    UITapGestureRecognizer *res = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [toplabel addGestureRecognizer:res];
    [self.view addSubview:toplabel];
    [toplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.mas_equalTo(40);
    }];
        
        
        //-----------------底部view-----------------
    self.bottomView = [[UIView alloc]init];
    [self.bottomView inputAccessoryView];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
            make.height.mas_equalTo(60);
    }];
    //发布评论按钮
    self.replyBotton = [[UIButton alloc]init];
    [self.replyBotton setEnabled:NO];
    [self.replyBotton setTitle:@"发布" forState:UIControlStateNormal];
    self.replyBotton.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.replyBotton.titleLabel setTextAlignment:NSTextAlignmentRight];
    [self.replyBotton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.replyBotton addTarget:self action:@selector(replybtaction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomView addSubview:self.replyBotton];
    [self.replyBotton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomView.mas_right).with.offset(-5);
            make.top.equalTo(self.bottomView.mas_top).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    //发布评论输入框
    self.replyTextView = [[UITextView alloc]init];
    //
    self.replyTextView.delegate = self;
    //
    self.replyTextView.layer.backgroundColor = [[UIColor clearColor]CGColor];
    self.replyTextView.layer.borderWidth = 1.0;
    self.replyTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.replyTextView.layer.cornerRadius = 15.0;
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self.bottomView addSubview:self.replyTextView];
    [self.replyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).with.offset(3);
        make.bottom.equalTo(self.bottomView).with.offset(-5);
        make.left.equalTo(self.bottomView).with.offset(5);
        make.right.equalTo(self.replyBotton.mas_left);
    }];
    
    
    //-----------------中间tabelview部分----------------------
    self.tableview = [[UITableView alloc]init];
    //键盘收起方式
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(toplabel.mas_bottom);
            make.bottom.equalTo(self.bottomView.mas_top);
    }];
    //
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[Comment_TableViewCell class] forCellReuseIdentifier:@"123"];
    [self.view addSubview:self.tableview];
    
    

}


#pragma mark tableview的代理方法
//     tableviw的数据源方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CommentModel *model = self.commentArray[indexPath.row];
    //cell的重用
    Comment_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if(!cell){
        cell = [[Comment_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
#pragma mark 这里给cell页面传了本vc的底部输入框textview的地址与用户名，慎用
    [cell sentMSG:self.replyTextView andName:model.name];
#pragma mark    通过模型赋值到cell的控件里
    cell.touXiang.image = [UIImage imageNamed:model.touXiang];
    cell.name.text = model.name;
    cell.comment.text = model.comment;
    cell.time.text = model.time;
    cell.dz_count.text = model.dz_count;

//    cell.name.text = @"啊啊啊啊";
//    cell.touXiang.image = [UIImage imageNamed:@"tou1.jpeg"];
//    cell.comment.text = @"dsfaioohoiudsafhgoivhasdripgfhap9srdjfgpg9pasj    法法师打发顺丰";
//    cell.dz_count.text = @"9";
//    cell.time.text = @"2021";
    self.hight = [self computeHightWithString:cell.comment.text];
    return cell;
}
//tableview行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
//    return 10;
}
//tableview行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.hight;
//    return 100;
}

#pragma mark 页面的api
//弹出评论页的类方法实现
+ (void)pop :(UIViewController *)vc andid:(int)articleid andmodel:(CommentModel *)user{
    Comment_ViewController *pl1 = [[Comment_ViewController alloc]init];
    pl1.articleid = articleid;
    pl1.user = user;
    [vc presentViewController:pl1 animated:YES completion:nil];
    
}

#pragma mark 其他相关方法的实现
//顶部的点击关闭评论页面方法
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}


//实现键盘监听方法使输入框不被遮挡
- (void)keyboardWillShow:(NSNotification *)notification{
    CGFloat kbhight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-kbhight);
    }];
    
    [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
    }];
}
//实现键盘监听方法使输入框回到底部
- (void)keyboardWillHide:(NSNotification *)notification{
    
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
    }];
}

//发布按钮的响应事件
- (void)replybtaction:(UIButton *)bt{
    
    
    //使发布按钮不可用
    [self.replyBotton setEnabled:NO];
    //把评论写入数据库
    CommentModel *model = [[CommentModel alloc]init];
    model.name = self.user.name;
    model.touXiang = self.user.touXiang;
    model.comment = self.replyTextView.text;
    //回复时间
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd HH:MM"];
    NSString *nss = [df stringFromDate:date];
    model.time = nss;
    model.dz_count = @"0";
    [self.manager insert:model :self.articleid];
    //清空输入框
    [self.replyTextView setText:@""];
    //关闭键盘
    [self.replyTextView resignFirstResponder];
    //弹出对话框
    UIAlertController *alerk = [UIAlertController alertControllerWithTitle:@"" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
    [alerk addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //这里重新加载了一遍数据库的数据到commentarray
        [self.manager openDBWithPath:@"/Users/a123/toutiaoComment.db"];
        self->_commentArray = [self.manager select:self.articleid];
        //
        [self.tableview reloadData];
        
        NSLog(@"%lu",(unsigned long)self.commentArray.count);
            }]] ;
    [self presentViewController:alerk animated:YES completion:nil];
}

//输入框的代理方法规定发布按钮的可用性
- (void)textViewDidChange:(UITextView *)textView{
    if(![textView hasText]){
        self.replyBotton.titleLabel.textColor = [UIColor grayColor];
        [self.replyBotton setEnabled:NO];
        
    }else{
        self.replyBotton.titleLabel.textColor = [UIColor blueColor];
        [self.replyBotton setEnabled:YES];
        
    }
}

- (float)computeHightWithString:(NSString *)text{
    if(text){
    CGSize com = CGSizeMake(self.replyTextView.contentSize.width, CGFLOAT_MAX);
    CGRect size = [text boundingRectWithSize:com options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil];
    float hight = size.size.height+18+55;
    return  hight;
    }else{
        NSLog(@"找不到评论啊");
        return 100;
    }
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
