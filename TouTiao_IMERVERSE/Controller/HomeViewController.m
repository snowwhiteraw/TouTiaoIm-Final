//
//  ViewController.m
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/16.

#import "CommentModel.h"
#import "Comment_ViewController.h"


#import "HomeViewController.h"
#import <WebKit/WebKit.h>
#import "MessageContentModel.h"
#import <AFNetworking.h>
#import <YYModel.h>
#import "CollectionViewController.h"

#import "plViewController.h"
#import "TVUMJRefresh.h"
#import "LoginViewController.h"
#import <SAMKeychain/SAMKeychain.h>
#import "ZanLikeView.h"
#import "IFMShareView.h"

#import <MJRefresh/MJRefresh.h>

@interface HomeViewController () <LoginDelegate,LikeDelegate>
@property(nonatomic, strong) NSMutableArray *shareArray;
@property(nonatomic, strong) NSMutableArray *functionArray;
@end

@implementation HomeViewController

//代替原有的init方法
- (instancetype)init:(NSMutableArray<MessageContentModel *> *)dataArr : (NSString*) label{
    self = [super init];
    //数据源加载
    self.Contentarray = [dataArr mutableCopy];
    self.messagelabel = [label copy];
    
    //全在这里加载的话，会造成父view响应时间变长
    
    //可拖拽按钮
    self.nextMessageButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8 * 4,self.view.frame.size.height- self.view.frame.size.width/8 * 5, self.view.frame.size.width/8 * 2, self.view.frame.size.width/8 * 2)];
//    [self.nextMessageButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.nextMessageButton  setImage:[UIImage systemImageNamed:@"arrowtriangle.down.circle.fill"]  forState:UIControlStateNormal];
    [self.nextMessageButton  setImage:[UIImage systemImageNamed:@"arrowtriangle.down.circle.fill.fill"]   forState:UIControlStateSelected];
    self.nextMessageButton.tintColor = UIColor.grayColor;
    self.nextMessageButton.layer.shadowColor = [UIColor blackColor].CGColor;
    self.nextMessageButton.layer.shadowOffset = CGSizeZero;
    self.nextMessageButton.layer.shadowRadius = 5;
    self.nextMessageButton.layer.shadowOpacity = 0.5;
//    [self.nextMessageButton.layer setBorderWidth:5];
//    [self.nextMessageButton.imageView.layer setBorderWidth:3];
    
//    [self.nextMessageButton setTitle:@"下一篇" forState:UIControlStateNormal];
    [self.nextMessageButton addTarget:self action: @selector(nextMessgaeButtonfunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside表示轻点按钮触发事件
    //添加手势,使得按钮可拖拽
    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [self.nextMessageButton addGestureRecognizer:panRcognize];
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    if(self.Contentarray != nil && self.messagelabel != nil){
        self.messageNum = 0;//起始文章序号定为0
        [self setViewfunc : self.messageNum : self.messagelabel];
    }
}

//不要随便把代码写在这里，有些代码需要写在更初始化的地方
- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark swipe轻扫手势事件
-(void)swipeViewup:(UISwipeGestureRecognizer *)sender{
    self.commentButton.hidden = YES;
    self.shareNumLabel.hidden = YES;
    self.colletionButton.hidden = YES;
    self.agreeButton.hidden = YES;
    self.likeView.hidden = YES;
    self.agreeNumlabel.hidden = YES;
    self.commentNumLabel.hidden = YES;
    self.collectionNumLabel.hidden = YES;
    self.shareNumLabel.hidden = YES;
    self.shareButton.hidden = YES;
    self.nextMessageButton.hidden = YES;
    self.visual.alpha=0;
//    self.navigationController.navigationBar.hidden = YES;
    //这里希望将子view变成全屏，但是貌似做不到233，先留个坑
}
-(void)swipeViewdown:(UISwipeGestureRecognizer *)sender{
    self.commentButton.hidden = NO;
    self.shareNumLabel.hidden = NO;
    self.colletionButton.hidden = NO;
    self.agreeButton.hidden = NO;
    self.likeView.hidden = NO;
    self.agreeNumlabel.hidden = NO;
    self.commentNumLabel.hidden = NO;
    self.collectionNumLabel.hidden = NO;
    self.shareNumLabel.hidden = NO;
    self.shareButton.hidden = NO;
    self.nextMessageButton.hidden = NO;
    self.visual.alpha=0.8;
//    self.navigationController.navigationBar.hidden = NO;
    
}



//将wkwebview内手势与新添加的手势并存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark -
//点赞按钮箭头事件
- (void)agreeButtonfunc:(id)sender{
    //本地数据库点赞加1，联网请求对应文章点赞数+1，点完赞按钮变色
    //点赞触发页面
    if(self.agreeButton.selected == NO){
        if(![self.agreeNumlabel.text  isEqual: @"999+"]){
            self.agreeNumlabel.text  = [NSString stringWithFormat: @"%d", (self.agreeNumlabel.text.intValue + 1)];
        }
        self.agreeButton.selected = YES;
    }else{
        if(![self.agreeNumlabel.text  isEqual: @"999+"]){
            self.agreeNumlabel.text  = [NSString stringWithFormat: @"%d", (self.agreeNumlabel.text.intValue - 1)];
        }
        self.agreeButton.selected = NO;
    }
}

//继承LikeDelegate后重写方法，被通知爱心有没有被按下，从而改变agreeNumeLabel————初始状态是不会调用这个方法的
- (void) TouchUpLikeView: (NSString*)isPressed{
    if([isPressed isEqual: @"YES"]){
        if(![self.agreeNumlabel.text  isEqual: @"999+"]){
            self.agreeNumlabel.text  = [NSString stringWithFormat: @"%d", (self.agreeNumlabel.text.intValue + 1)];
        }
    }else{
        if(![self.agreeNumlabel.text  isEqual: @"999+"]){
            self.agreeNumlabel.text  = [NSString stringWithFormat: @"%d", (self.agreeNumlabel.text.intValue - 1)];
        }
    }
}

- (void)commentButtonfunc:(id)sender {

    //主页面跳转评论页
        CommentModel *model = [[CommentModel alloc]init];
        model.name = @"安妮日记";
        model.touXiang = @"tou7.jpeg";

    if (self.messageNum >= self.Contentarray.count) {
        return;
    }

    [Comment_ViewController pop:self andid:self.Contentarray[self.messageNum].messageid.intValue andmodel:model];
    
    
    
}



- (void)collectionButtonfunc:(id)sender {
    NSLog(@"用户点击了收藏页面");
    //验证用户是否登录--是否存在这个用户信息
    if(nil == [SAMKeychain passwordForService:@"NowUser" account:@"toutiaoim"]){
        LoginViewController * lvc = [[LoginViewController alloc]init];
        lvc.delegate = self;
        [self.navigationController setNavigationBarHidden:YES animated:YES]; //隐藏要跳转过去的二级页面的导航栏
        [self.navigationController pushViewController:lvc  animated:YES];
    }
    else{
        if(self.colletionButton.selected == NO){
            if(![self.collectionNumLabel.text  isEqual: @"999+"]){
                self.collectionNumLabel.text  = [NSString stringWithFormat: @"%d", (self.collectionNumLabel.text.intValue + 1)];
            }
            self.colletionButton.selected = YES;
        }else{
            if(![self.collectionNumLabel.text  isEqual: @"999+"]){
                self.collectionNumLabel.text  = [NSString stringWithFormat: @"%d", (self.collectionNumLabel.text.intValue - 1)];
            }
            self.colletionButton.selected = NO;
        }
    }

}


- (void)shareButtonfunc:(id)sender {
    NSLog(@"点击了转发");
    //调用伊布的第三方分享组件
    [self showHeadFootStyle:sender];
}
//以下是伊布第三方组件用到的函数
- (void)showHeadFootStyle:(UIButton *)sender {
    IFMShareView *shareView = [[IFMShareView alloc] initWithShareItems:self.shareArray functionItems:self.functionArray itemSize:CGSizeMake(80,100)];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, headerView.frame.size.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:51/255.0 green:68/255.0 blue:79/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:15];
    label.text = @"头条沉浸版";
    [headerView addSubview:label];
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    footerView.backgroundColor = [UIColor clearColor];
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, headerView.frame.size.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:5/255.0 green:27/255.0 blue:40/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:18];
    label.text = @"-.-";
    [footerView addSubview:label];
    
    shareView.headerView = headerView;
    shareView.footerView = footerView;
    shareView = [self addShareContent:shareView];
    [shareView showFromControlle:self];
}

- (NSMutableArray *)shareArray{
    if (!_shareArray) {
        _shareArray = [NSMutableArray array];
        
        [_shareArray addObject:IFMPlatformNameSms];
        [_shareArray addObject:IFMPlatformNameEmail];
        [_shareArray addObject:IFMPlatformNameSina];
        [_shareArray addObject:IFMPlatformNameWechat];
        [_shareArray addObject:IFMPlatformNameQQ];
        [_shareArray addObject:IFMPlatformNameAlipay];
    }
    return _shareArray;
}
- (NSMutableArray *)functionArray{
    if (!_functionArray) {
        _functionArray = [NSMutableArray array];
        [_functionArray addObject:[[IFMShareItem alloc] initWithImage:[UIImage imageNamed:@"function_collection"] title:@"收藏" action:^(IFMShareItem *item) {
            ALERT_MSG(@"提示",@"点击了收藏",self);
        }]];
        [_functionArray addObject:[[IFMShareItem alloc] initWithImage:[UIImage imageNamed:@"function_copy"] title:@"复制" action:^(IFMShareItem *item) {
            ALERT_MSG(@"提示",@"点击了复制",self);
        }]];
        [_functionArray addObject:[[IFMShareItem alloc] initWithImage:[UIImage imageNamed:@"function_expose"] title:@"举报" action:^(IFMShareItem *item) {
            ALERT_MSG(@"提示",@"点击了举报",self);
        }]];
        [_functionArray addObject:[[IFMShareItem alloc] initWithImage:[UIImage imageNamed:@"function_font"] title:@"调整字体" action:^(IFMShareItem *item) {
            ALERT_MSG(@"提示",@"点击了调整字体",self);
        }]];
        [_functionArray addObject:[[IFMShareItem alloc] initWithImage:[UIImage imageNamed:@"function_link"] title:@"复制链接" action:^(IFMShareItem *item) {
            ALERT_MSG(@"提示",@"点击了复制链接",self);
        }]];
        [_functionArray addObject:[[IFMShareItem alloc] initWithImage:[UIImage imageNamed:@"function_refresh"] title:@"刷新" action:^(IFMShareItem *item) {
            ALERT_MSG(@"提示",@"点击了刷新",self);
        }]];
    }
    return _functionArray;
}
- (IFMShareView *)addShareContent:(IFMShareView *)shareView{
    [shareView addText:@"分享测试"];
    [shareView addURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    [shareView addImage:[UIImage imageNamed:@"share_alipay"]];
    
    return shareView;
}



//加载下一篇文章
- (void)nextMessgaeButtonfunc:(id)sender {
    if(self.nextMessageButton.selected == NO){
        self.nextMessageButton.selected = YES;
    }else{
        self.nextMessageButton.selected = NO;
    }
    
    if(self.messageNum >= self.Contentarray.count){ //目前数据源就写了5篇
        //过大就直接不做了，避免数据过大
        self.messageNum = self.num404;
        //直接加载404
        [self setViewfuncjustfor404]; //直接找到self.conArr中404页面并展示
    }
    else{
        self.messageNum ++;
        [self setViewfunc : self.messageNum: self.messagelabel];
    }
    
    
}

#pragma mark - 自定义展示页面方法
- (void) setViewfunc:(int) num : (NSString*)messagelabel {
    NSMutableString * url = nil;
    NSString * url404 = nil;
    //找到对应标签的num起始的最新文章
    for(int number = num;number < [self.Contentarray count];number++){
        if([self.Contentarray[number].label isEqual:messagelabel]){
            url = [self.Contentarray[number].contentstring mutableCopy];
            self.messageNum = number+1; //这篇文章加载过了，就不需要再加载了
            break;
        }
    }
    //获得没有找到标签文章时显示的404页面url
    for(int number = 0;number < [self.Contentarray count];number++){
        if([self.Contentarray[number].label isEqual:@"404"]){
            url404 = self.Contentarray[number].contentstring;
            self.num404 = number;
            break;
        }
    }
    
    WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc]init];
        // 视频页面播放支持，注意前端也要加上webkit-playsinline="true" playsinline="true"
    webViewConfig.allowsInlineMediaPlayback = YES;
    //记得初始化，不然就是无用功给一个nil loadrequest.
    if(self.wkwebview == nil){
        NSLog(@"wkwebview == nil");
        self.wkwebview = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:webViewConfig];
    }
    if(url == nil){ //没有找到对应标签文章，不同的api的标签可能没有对应文章
        [self.wkwebview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url404]]]; //有可能异步加载，注意
        [self.view addSubview: self.wkwebview];
    }
    else{
        [self.wkwebview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]]; //有可能异步加载，注意
        [self.view addSubview: self.wkwebview];
        [self loadButtons:num:messagelabel];
    }
    [self.view addSubview:self.nextMessageButton];
    
#pragma mark 加载下拉刷新wkwebview组件
    TVUMJRefreshNormalHeader *header = [TVUMJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    [header setTitle:@"下拉来刷新" forState:TVUMJRefreshStateIdle];
    [header setTitle:@"松开来刷新" forState:TVUMJRefreshStatePulling];
    [header setTitle:@"加载中..." forState:TVUMJRefreshStateRefreshing];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.wkwebview.scrollView.mj_header = header;
    
    
#pragma mark 上拉加载下一篇wkwebview文章
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
//    [TVUMJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [footer setTitle:@"上拉进入下一篇" forState:MJRefreshStateIdle];
    [footer setTitle:@"松开加载下一篇" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    self.wkwebview.scrollView.mj_footer = footer;
    
    self.wkwebview.navigationDelegate = self;
    
    [self initProgressView];
  
    // Listen the web load condition
    [self.wkwebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

//直接显示404，而且下一篇按钮消失
- (void) setViewfuncjustfor404 {
    NSString * url404 = nil;
    //获得没有找到标签文章时显示的404页面url
    for(int number = 0;number < [self.Contentarray count];number++){
        if([self.Contentarray[number].label isEqual:@"404"]){
            url404 = self.Contentarray[number].contentstring;
            self.num404 = number;
            break;
        }
    }
    WKWebViewConfiguration *webViewConfig = [[WKWebViewConfiguration alloc]init];
        // 视频页面播放支持，注意前端也要加上webkit-playsinline="true" playsinline="true"
    webViewConfig.allowsInlineMediaPlayback = YES;
    //记得初始化，不然就是无用功给一个nil loadrequest.
    if(self.wkwebview == nil){
        NSLog(@"wkwebview == nil");
        self.wkwebview = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:webViewConfig];
    }
    [self.wkwebview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url404]]]; //有可能异步加载，注意
    [self.view addSubview: self.wkwebview];
//    [self.view addSubview:self.nextMessageButton];
    
#pragma mark 404加载下拉刷新wkwebview组件
    TVUMJRefreshNormalHeader *header = [TVUMJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
           [header setTitle:@"下拉来刷新" forState:TVUMJRefreshStateIdle];
           [header setTitle:@"松开来刷新" forState:TVUMJRefreshStatePulling];
           [header setTitle:@"加载中..." forState:TVUMJRefreshStateRefreshing];
           
           header.lastUpdatedTimeLabel.hidden = YES;
           self.wkwebview.scrollView.mj_header = header;
    
    
#pragma mark 404上拉加载下一篇wkwebview文章
    //TVUMJRefreshAutoNormalFooter无法生效，只会显示第一种状态，虽然功能正常，但是用户体验不好
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    [footer setTitle:@"已经是最后一篇啦~" forState:MJRefreshStateIdle];
    [footer setTitle:@"别拽我啦~" forState:MJRefreshStatePulling];
    [footer setTitle:@"加载中 ..." forState:MJRefreshStateRefreshing];
    [footer endRefreshingWithNoMoreData];
    self.wkwebview.scrollView.mj_footer = footer;
    
    

    
    self.wkwebview.navigationDelegate = self;
    
    [self initProgressView];

    // Listen the web load condition
    [self.wkwebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)footerRefresh{
    // If user enter our app (not network), the URL is NULL even if we have already setted.
    NSLog(@"上拉刷新啦");
//    NSLog(@"self.num404== %d;self.messageNum== %d,self.messagelabel== %@,self.Contentarray[self.messageNum].label==%@ ",self.num404,self.messageNum,self.messagelabel,self.Contentarray[self.messageNum].label);
    if(self.messageNum > self.Contentarray.count || self.messageNum >= self.num404){
        TVUMJRefreshAutoNormalFooter *footer = [TVUMJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
        [footer setTitle:@"这是最后一篇新闻了，下拉刷新下吧~" forState:TVUMJRefreshStateIdle];
        [footer setTitle:@"别拽我啦~" forState:TVUMJRefreshStatePulling];
        [footer setTitle:@"尝试加载..." forState:TVUMJRefreshStateRefreshing];
        self.wkwebview.scrollView.mj_footer = footer;
        
    }
    else{
        self.messageNum ++;
        //上拉也会重新加载整个页面
        [self setViewfunc : self.messageNum: self.messagelabel];
    }
    
//    [self endRefresh]; //此方法在网页加载完毕和页面销毁等地方都会被调用，用于将刷新组件的Loading状态变成endRefresh状态
}

//由于按钮复用了两次，所以单独提出来
- (void) loadButtons: (int) num : (NSString*)messagelabel{
    //给下方评论毛玻璃特效
    UIBlurEffect*blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];//可以选择三种样式
    self.visual=[[UIVisualEffectView alloc]initWithEffect:blur];
    self.visual.frame=CGRectMake(0, self.view.frame.size.height-80, self.view.frame.size.width,80);
    self.visual.alpha=0.8;
    [self.view addSubview: self.visual];
    
    //添加各个按钮
//    self.agreeButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height-80,self.view.frame.size.width/8,self.view.frame.size.width/8)];
    self.likeView = [[ZanLikeView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-70,self.view.frame.size.width/14,self.view.frame.size.width/14)]; //设置背景图图方位 //设置爱心(爱心是asset文件夹下的两张前后图片)大小
//    [self.agreeButton.imageView addSubview: likeView];
    [self.view addSubview:self.likeView];
    self.likeView.likeDuration = 0.5;
    self.likeView.zanFillColor = [UIColor redColor];
    self.likeView.delegate = self;
//    self.likeView.backgroundColor = UIColor.lightGrayColor;
//    [self.agreeButton addTarget:self action: @selector(agreeButtonfunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside表示轻点按钮触发事件
//    [self.agreeButton  setImage:[UIImage systemImageNamed:@"hand.thumbsup"]  forState:UIControlStateNormal];
//    [self.agreeButton  setImage:[UIImage systemImageNamed:@"hand.thumbsup.fill"]   forState:UIControlStateSelected];
//    self.agreeButton.tintColor = UIColor.redColor;
    
    self.agreeNumlabel= [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8 * 1,self.view.frame.size.height-80,self.view.frame.size.width/8,self.view.frame.size.width/8)];
    [self.shareNumLabel setFont: [UIFont systemFontOfSize:15]];
    [self.agreeNumlabel setTextColor:UIColor.blackColor];
    
    self.commentButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8 * 2, self.view.frame.size.height-80, self.view.frame.size.width/8,self.view.frame.size.width/8)];
    [self.commentButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.commentButton  setImage:[UIImage systemImageNamed:@"text.bubble"]  forState:UIControlStateNormal];
    [self.commentButton  setImage:[UIImage systemImageNamed:@"text.bubble.fill"]   forState:UIControlStateSelected];
    self.commentButton.tintColor = UIColor.redColor;
    [self.commentButton addTarget:self action: @selector(commentButtonfunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside表示轻点按钮触发事件
   
    self.shareNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8 * 7, self.view.frame.size.height-80, self.view.frame.size.width/8,self.view.frame.size.width/8)];
    [self.shareNumLabel setFont: [UIFont systemFontOfSize:15]];
    [self.shareNumLabel setTextColor:UIColor.blackColor];
    
    self.colletionButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8 * 4, self.view.frame.size.height-80,self.view.frame.size.width/8,self.view.frame.size.width/8)];
    [self.colletionButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.colletionButton  setImage:[UIImage systemImageNamed:@"star"]  forState:UIControlStateNormal];
    [self.colletionButton  setImage:[UIImage systemImageNamed:@"star.fill"]   forState:UIControlStateSelected];
    self.colletionButton.tintColor = UIColor.redColor;
    [self.colletionButton addTarget:self action: @selector(collectionButtonfunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside表示轻点按钮触发事件
    
    self.commentNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8 * 3,self.view.frame.size.height-80,self.view.frame.size.width/8,self.view.frame.size.width/8)];
    [self.shareNumLabel setFont: [UIFont systemFontOfSize:15]];
    [self.commentNumLabel setTextColor:UIColor.blackColor];

    self.collectionNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8 * 5, self.view.frame.size.height-80,self.view.frame.size.width/8,self.view.frame.size.width/8)];
    [self.shareNumLabel setFont: [UIFont systemFontOfSize:15]];
    [self.collectionNumLabel setTextColor:UIColor.blackColor];
    
    self.shareButton = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8 * 6, self.view.frame.size.height-80,self.view.frame.size.width/8,self.view.frame.size.width/8)];
    [self.shareButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [self.shareButton  setImage:[UIImage systemImageNamed:@"arrowshape.turn.up.forward"]  forState:UIControlStateNormal];
    [self.shareButton  setImage:[UIImage systemImageNamed:@"arrowshape.turn.up.forward.fill"]   forState:UIControlStateSelected];
    self.shareButton.tintColor = UIColor.redColor;
    [self.shareButton addTarget:self action: @selector(shareButtonfunc:) forControlEvents:UIControlEventTouchUpInside]; //UIControlEventTouchUpInside表示轻点按钮触发事件
    
    //对当前页面加载按钮和导航栏数据
    
    NSString * agreenum = self.Contentarray[num].agree;
    if([agreenum isEqual:@"999+"] || agreenum.intValue < 1000){
        [self.agreeNumlabel setText:self.Contentarray[num].agree];
    }
    else{
        [self.agreeNumlabel setText:@"999+"];
    }
    NSString * commentnum = self.Contentarray[num].comment;
    if([commentnum isEqual:@"999+"] || commentnum.intValue < 1000){
        [self.commentNumLabel setText:self.Contentarray[num].comment];
    }
    else{
        [self.commentNumLabel setText:@"999+"];
    }
    NSString * collectionnum = self.Contentarray[num].collection;
    if([collectionnum isEqual:@"999+"] || collectionnum.intValue < 1000){
        [self.collectionNumLabel setText:self.Contentarray[num].collection];
    }
    else{
        [self.collectionNumLabel setText:@"999+"];
    }
    NSString * sharenum = self.Contentarray[num].share;
    if([sharenum isEqual:@"999+"] || sharenum.intValue < 1000){
        [self.shareNumLabel setText:self.Contentarray[num].share];
    }
    else{
        [self.shareNumLabel setText:@"999+"];
    }
    
    
    [self.view addSubview:self.commentButton];
    [self.view addSubview:self.shareNumLabel];
    [self.view addSubview:self.colletionButton];
//    [self.view addSubview:self.agreeButton];
//    [self.view addSubview:self.likeView];
    [self.view addSubview:self.agreeNumlabel];
    [self.view addSubview:self.commentNumLabel];
    [self.view addSubview:self.collectionNumLabel];
    [self.view addSubview:self.shareButton];
    
    UISwipeGestureRecognizer *swipedown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeViewdown:)]; //从下往上划，隐藏按钮
    UISwipeGestureRecognizer *swipeup = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeViewup:)];//从上往下划，显示按钮
    swipedown.delegate = self; //设置手势代理，代理gestureRecognizer方法
    swipeup.delegate = self;
    swipedown.numberOfTouchesRequired = 1;//一个手指
    swipeup.numberOfTouchesRequired = 1;//一个手指
    swipedown.direction = UISwipeGestureRecognizerDirectionDown;//手势设置为从下往上
    swipeup.direction = UISwipeGestureRecognizerDirectionUp;
    [self.wkwebview addGestureRecognizer:swipedown];
    [self.wkwebview addGestureRecognizer:swipeup];
}

#pragma mark - 第三方库可拖拽按钮手势
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [recognizer translationInView:self.navigationController.view];
            recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x, recognizer.view.center.y + translation.y);
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGPoint stopPoint = CGPointMake(0, self.view.frame.size.height / 2.0);
            
            if (recognizer.view.center.x < self.view.frame.size.width / 2.0) {
                if (recognizer.view.center.y <= self.view.frame.size.height/2.0) {
                    //左上
                    if (recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.nextMessageButton.frame.size.width/2.0);
                    }else{
                        stopPoint = CGPointMake(self.nextMessageButton.frame.size.width/2.0, recognizer.view.center.y);
                    }
                }else{
                    //左下
                    if (recognizer.view.center.x  >= self.view.frame.size.height - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.view.frame.size.height - self.nextMessageButton.frame.size.width/2.0);
                    }else{
                        stopPoint = CGPointMake(self.nextMessageButton.frame.size.width/2.0, recognizer.view.center.y);
                    }
                }
            }else{
                if (recognizer.view.center.y <= self.view.frame.size.height/2.0) {
                    //右上
                    if (self.view.frame.size.width - recognizer.view.center.x  >= recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.nextMessageButton.frame.size.width/2.0);
                    }else{
                        stopPoint = CGPointMake(self.view.frame.size.width - self.nextMessageButton.frame.size.width/2.0, recognizer.view.center.y);
                    }
                }else{
                    //右下
                    if (self.view.frame.size.width - recognizer.view.center.x  >= self.view.frame.size.height - recognizer.view.center.y) {
                        stopPoint = CGPointMake(recognizer.view.center.x, self.view.frame.size.height - self.nextMessageButton.frame.size.width/2.0);
                    }else{
                        stopPoint = CGPointMake(self.view.frame.size.width - self.nextMessageButton.frame.size.width/2.0,recognizer.view.center.y);
                    }
                }
            }
            
            //如果按钮超出屏幕边缘
            if (stopPoint.y + self.nextMessageButton.frame.size.width+40>= self.view.frame.size.height) {
                stopPoint = CGPointMake(stopPoint.x, self.view.frame.size.height - self.nextMessageButton.frame.size.width/2.0-49);
                NSLog(@"超出屏幕下方了！！"); //这里注意iphoneX的适配。。X的SCREEN高度算法有变化。
            }
            if (stopPoint.x - self.nextMessageButton.frame.size.width/2.0 <= 0) {
                stopPoint = CGPointMake(self.nextMessageButton.frame.size.width/2.0, stopPoint.y);
            }
            if (stopPoint.x + self.nextMessageButton.frame.size.width/2.0 >= self.view.frame.size.width) {
                stopPoint = CGPointMake(self.view.frame.size.width - self.nextMessageButton.frame.size.width/2.0, stopPoint.y);
            }
            if (stopPoint.y - self.nextMessageButton.frame.size.width/2.0 <= 0) {
                stopPoint = CGPointMake(stopPoint.x, self.nextMessageButton.frame.size.width/2.0);
            }
  
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.center = stopPoint;
            }];
        }
            break;
            
        default:
            break;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
}

#pragma mark - 下拉刷新相关

//下拉刷新进度条,怕影响观感,去掉了
- (void)initProgressView {
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.8)];
    self.progressView.progressTintColor = [UIColor redColor];
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
//    [self.wkwebview addSubview:self.progressView];
}

/*
 ManyUsers这个表记录了曾经注册过的所有账号，里面信息不可被删除（除非日后做出注销账号功能，偏后台。其实这个表正常情况下是存到服务端的）；
 NowUser是表示当前登陆账号表，直接取来用户数据。
 不管哪张表，表名都是固定的。
 **/

#pragma mark 手动下拉刷新wkwebview，开始下拉加载时要做的回调
- (void)headerRefresh{
    NSLog(@"用户下拉刷新");
    //利用代理方法，反向传值。实现子页面下拉动作可以刷新父页面的头像，注意这里传的是对象而非字典
    if (self.delegate && [self.delegate respondsToSelector:@selector(notificatioonModel:)]) {
        //从本地数据库中查找用户信息，有就传给父页面，没有就不执行这个方法
        NSLog(@"本地NowUser数据库的数据：%@",[SAMKeychain passwordForService:@"NowUser" account:@"toutiaoim"]);
        NSString * usermodel = [SAMKeychain passwordForService:@"NowUser" account:@"toutiaoim"];
        
        if(usermodel != nil){
            NSLog(@"调用了刷新头像代理方法并成功传值%@",usermodel);
            [self.delegate notificatioonModel:usermodel]; //调用代理此类的那个类的重写代理方法，将model数据传过去
        }else{
            NSLog(@"调用了刷新头像代理方法但是没有值可以传（用户未登陆）");
            [self.delegate notificatioonModel:nil]; //这个是为了告诉Tabs父页面刷新了，没有值也要刷新
        }
       
    }
    
    //重新联网加载新的数据源
    if(self.urlNum == YES){
        self.urlNow = [@"https://qcdybn.fn.thelarkcloud.com/hello" mutableCopy];
        self.urlNum = NO;
    }
    else{
        self.urlNow = [@"https://qcdybn.fn.thelarkcloud.com/home" mutableCopy];
        self.urlNum = YES;
    }
    
    //注意这个函数更改了self.conArr
    [self netWorking: self.urlNow];
    self.messageNum = 0; //避免一些文章没轮到
//    [self.wkwebview reload];
    
    //加载wkwebview数据和按钮，与setviewwfunc不同的是这里删除了webview的判空（不删直接调用setviewfunc会出现下拉刷新显示异常）
    NSMutableString * url = nil;
    NSString * url404 = nil;
    //找到对应标签的num起始的最新文章
    for(int number = self.messageNum;number < [self.Contentarray count];number++){
        if([self.Contentarray[number].label isEqual:self.messagelabel]){
            url = [self.Contentarray[number].contentstring mutableCopy];
            self.messageNum = number; //这篇文章加载过了，就不需要再加载了
            break;
        }
    }
    //获得没有找到标签文章时显示的404页面url
    for(int number = 0;number < [self.Contentarray count];number++){
        if([self.Contentarray[number].label isEqual:@"404"]){
            url404 = self.Contentarray[number].contentstring;
            self.num404 = number;
            break;
        }
    }
    if(url == nil){ //没有找到对应标签文章
        [self.wkwebview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url404]]]; //有可能异步加载，注意
        [self.view addSubview: self.wkwebview];
        
    }
    else{
        [self.wkwebview loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]]; //有可能异步加载，注意
        [self.view addSubview: self.wkwebview];
        [self loadButtons:self.messageNum:self.messagelabel];
    }
    [self.view addSubview:self.nextMessageButton];
    
    
}

//加载wkwebview完毕，加载完毕后要做的回调
- (void)endRefresh{
    [self.wkwebview.scrollView.mj_header endRefreshing];
}

#pragma mark - Button Action
- (void)didClickBackBtn {
    if ([self.wkwebview canGoBack]) {
        [self.wkwebview goBack];
    }
}

#pragma mark - Notificaiton
#pragma webView progress view
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([self.progressView isDescendantOfView:self.wkwebview]) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            self.progressView.progress = self.wkwebview.estimatedProgress;
            if (self.progressView.progress == 1) {
                /*
                 *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
                 *动画时长0.25s，延时0.3s后开始动画
                 *动画结束后将progressView隐藏
                 */
                
                __weak HomeViewController *weakSelf = self;
                [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
                } completion:^(BOOL finished) {
                    weakSelf.progressView.hidden = YES;
                    
                }];
            }
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
}

#pragma mark - Delegate
#pragma mark WKScriptMessageHandler Delegate
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    
}

#pragma mark - WKNavigation Delegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self endRefresh];
    
    if ([self.progressView isDescendantOfView:self.wkwebview]) {
        self.progressView.hidden = NO;
        self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSString *absoluteString = self.wkwebview.URL.absoluteString;
    
    [self endRefresh];
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    [self endRefresh];
}


#pragma mark - Dealloc
- (void)dealloc {
    [[self.wkwebview configuration].userContentController removeScriptMessageHandlerForName:@"getMessage"];
}

//加载特定Url的数据源到self.conArr,数据格式参照Model那个类
- (void) netWorking : (NSString*) url{
    [[AFHTTPSessionManager manager]GET:url
                            parameters:nil
                               headers:nil
                              progress:^(NSProgress * _Nonnull downloadProgress) {
            
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.Contentarray = [[NSMutableArray yy_modelArrayWithClass: [MessageContentModel class] json: [((NSDictionary * )responseObject) objectForKey:@"json"]] mutableCopy];
        NSLog(@"请求成功,下拉刷新：%@ --- %@",self.urlNow,self.Contentarray.yy_modelDescription);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
      
    }];
}

//重写LoginViewController的代理方法
- (void)getUserMessageByDelegate:(NSString*)userMessageModelJSONString{
    NSLog(@"从登陆页面获得了数据————其实只要参数不为nil我就可以从本地数据库取了%@",userMessageModelJSONString);
    if (self.delegate && [self.delegate respondsToSelector:@selector(notification:)]) {
        [self.delegate notification:userMessageModelJSONString]; //调用代理此类的那个类的重写代理方法，将model数据传过去
        NSLog(@"调用了刷新头像代理方法");
    }
    else{
        NSLog(@"Home首页的获得刷新数据通知的代理方法没有被登录页面调用！");
    }
}



@end
