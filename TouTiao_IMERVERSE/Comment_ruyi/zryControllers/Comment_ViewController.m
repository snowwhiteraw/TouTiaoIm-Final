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
#import <AFNetworking.h>

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
    [self.manager openDBWithPath:self.path];
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
    //实现点击关闭评论页
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
    //设置回复框的代理
    self.replyTextView.delegate = self;
    self.replyTextView.layer.backgroundColor = [[UIColor clearColor]CGColor];
    self.replyTextView.layer.borderWidth = 1.0;
    self.replyTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.replyTextView.layer.cornerRadius = 15.0;
    //注册通知，处理键盘弹起事件
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
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    //键盘收起方式
    self.tableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.top.equalTo(toplabel.mas_bottom);
            make.bottom.equalTo(self.bottomView.mas_top);
    }];
    //设置代理为self
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    //注册
    [self.tableview registerClass:[Comment_TableViewCell class] forCellReuseIdentifier:@"123"];
    [self.view addSubview:self.tableview];
    
    //增加单击页面其余地方关闭键盘的手势
    UITapGestureRecognizer *singletTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(single:)];
    [self.tableview addGestureRecognizer:singletTap];

}


#pragma mark tableview的代理方法
    //tableviw的数据源方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentModel *model = self.commentArray[indexPath.row];
    //cell的重用
    Comment_TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123"];
    if(!cell){
        cell = [[Comment_TableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"123"];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
#pragma mark 这里给cell页面传了本vc的底部输入框textview的地址与用户名
    [cell sentMSG:self.replyTextView andName:model.name];
    //通过模型赋值给cell
    cell.touXiang.image = [UIImage imageNamed:model.touXiang];
    cell.name.text = model.name;
    cell.comment.text = model.comment;
    cell.time.text = model.time;
    cell.dz_count.text = model.dz_count;
    //调用computeHight方法计算行高
    self.hight = [self computeHightWithString:cell.comment.text];
    return cell;
}
//tableview行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}
//tableview行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.hight;
}

#pragma mark 页面的api
//弹出评论页的类方法实现
+ (instancetype)pop :(UIViewController *)vc andid:(int)articleid andmodel:(CommentModel *)user{
    if(vc!=nil && articleid>=0 && user.name !=nil){
    Comment_ViewController *pl1 = [[Comment_ViewController alloc]init];
    //通过沙盒创建数据库
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSString *sqlitePath = [NSString stringWithFormat:@"%@/toutiaoComment.db",pathDocuments];
    NSFileManager *copyDatabaseFM = [NSFileManager defaultManager];
    if ([copyDatabaseFM fileExistsAtPath:sqlitePath] == NO) {
        [copyDatabaseFM copyItemAtPath:[[NSBundle mainBundle]pathForResource:@"toutiaoComment" ofType:@"db"] toPath:sqlitePath error:nil];
    }
    NSLog(@"当前评论数据库路径：%@",sqlitePath);
    pl1.path = sqlitePath;
    //联网查找id
    NSString *idString = [NSString stringWithFormat:@"%d",articleid];
    NSDictionary *dic = [NSDictionary dictionaryWithObject:idString forKey:@"article"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:@"https://qcth23.fn.thelarkcloud.com/comment" parameters:dic headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"联网成功");
                int commentID = [[responseObject valueForKey:@"id"]intValue]+2;
                NSLog(@"返回文章对应评论id：%d",commentID);
                pl1.articleid = commentID;
                pl1.user = user;
                [vc presentViewController:pl1 animated:YES completion:nil];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    NSLog(@"网络请求失败：%@",error);
     }];
    return pl1;
    }else{
        NSLog(@"调用评论页api失败，请检查参数");
        return nil;
    }
}

#pragma mark 其他相关方法的实现
//关闭回复框键盘的实现
- (void)single :(UITapGestureRecognizer *)gesture{
    [self.replyTextView resignFirstResponder];
    NSLog(@"已收起键盘");
}

//顶部的点击关闭评论页面方法
- (void)back{
    self.tableview = nil;
    [self.view removeFromSuperview];
    self.view = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

//实现键盘监听方法使输入框不被遮挡
- (void)keyboardWillShow:(NSNotification *)notification{
    CGFloat keybloardHight = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
    [self.bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-keybloardHight);
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:MM"];
    model.time = [dateFormatter stringFromDate:[NSDate date]];
    model.dz_count = @"0";
    [self.manager insert:model :self.articleid];
    //添加model到commentArray
    [self.commentArray addObject:model];
    //清空输入框
    [self.replyTextView setText:@""];
    //关闭键盘
    [self.replyTextView resignFirstResponder];
    //弹出对话框
    UIAlertController *alerk = [UIAlertController alertControllerWithTitle:@"" message:@"发布成功" preferredStyle:UIAlertControllerStyleAlert];
    [alerk addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //这里重新加载了一遍数据库的数据到commentarray
//        [self.manager openDBWithPath:self.path];
//        self->_commentArray = [self.manager select:self.articleid];
        //这里做了优化，不需要重新加载数据库，直接添加到暂存的评论数组后reload即可
        [self.tableview reloadData];
        NSLog(@"发布成功，现在的评论数是%lu",(unsigned long)self.commentArray.count);
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
        if([self computeHightWithString:textView.text]>=73+30){
            if ([self computeHightWithString:textView.text]<=180) {
                [textView.superview mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.height.mas_equalTo([self computeHightWithString:textView.text]-55);
                }];
            }
        }else{
            [textView.superview mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.height.mas_equalTo(60);
            }];
        }
    }
}
//计算行高方法
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

@end
