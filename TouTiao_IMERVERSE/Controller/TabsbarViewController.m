//
//  TabsbarViewController.m
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/20.
//

#import "TabsbarViewController.h"
#import "HomeViewController.h"
#import "FSScrollContentView.h"
#import <WebKit/WebKit.h>
#import "MessageContentModel.h"
#import <AFNetworking.h>
#import <YYModel.h>
#import "SceneDelegate.h"
#import <SAMKeychain/SAMKeychain.h>
#import "TagViewController.h"


@interface TabsbarViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate,HomeDelegate,TagDelegate>
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic,strong) NSMutableArray * dataArr; //选择展示的标签页数组
@property (nonatomic,strong) NSMutableArray * unSelectedDataArr; //未选择的标签页数组

@end

//创建FSPageContentView
@implementation TabsbarViewController
 
-(void)viewWillAppear:(BOOL)animated{
  [super viewWillAppear:animated];
  
//  [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
#pragma mark 联网请求数据
    self.api = [@"https://qcdybn.fn.thelarkcloud.com/home" mutableCopy];
    [[AFHTTPSessionManager manager]GET:self.api
                            parameters:nil
                               headers:nil
                              progress:^(NSProgress * _Nonnull downloadProgress) {
            
    }
    success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.Contentarray = [[NSMutableArray yy_modelArrayWithClass: [MessageContentModel class] json: [((NSDictionary * )responseObject) objectForKey:@"json"] ] mutableCopy];
        NSLog(@"请求成功,self.Contentarray====%@",self.Contentarray.yy_modelDescription);
        //这里如果self.comnarr为nil要怎么提示用户没有数据？（未联网）
        
#pragma mark 加载首页固定顶部标签页
        self.selectedItemsIndex = 0;
        
        self.dataArr = [self.Contentarray[0].labels mutableCopy];
        self.unSelectedDataArr = [self.Contentarray[0].unSelectedLabels mutableCopy];
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.view.backgroundColor = [UIColor whiteColor];
        self.title = @"pageContentView"; //当前navigationccontroller的标题，在下面代码中被标签组件覆盖了
        self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8,90, CGRectGetWidth(self.view.bounds) - self.view.frame.size.width/8 * 2, 50) titles:self.dataArr delegate:self indicatorType:FSIndicatorTypeEqualTitle];
        self.titleView.titleSelectFont = [UIFont systemFontOfSize:20];
        self.titleView.titleSelectColor = [UIColor redColor];
        self.titleView.selectIndex = self.selectedItemsIndex; //这个决定展示的是第几个标签
        [self.view addSubview:_titleView];
        
        NSMutableArray *childVCs = [[NSMutableArray alloc]init];
        for (NSString *title in self.dataArr) {
            HomeViewController *vc = [[HomeViewController alloc]init:self.Contentarray :title]; //加载对应标签的文章
            vc.title = title;
            vc.delegate = self; //利用代理方法实现监听，一旦收藏按钮进入登陆页面登陆成功，就会触发代理方法刷新头像
            [childVCs addObject:vc];
        }
        self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 90, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
        self.pageContentView.contentViewCurrentIndex = self.selectedItemsIndex;
        self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
        
        [self.view addSubview:_pageContentView];
        [self.navigationItem setTitleView: self.titleView];
        
        //右上角，本来是搜索按钮，现在改为标签编辑页弹出按钮
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"line.horizontal.3"] style:UIBarButtonItemStylePlain target:self action:@selector(rightNavBtnAction)];
        self.navigationItem.rightBarButtonItem.tintColor = UIColor.redColor;
    //    self.navigationItem.title = @"今日头条沉浸版"; //当前navigationccontroller的标题
        //回调是异步的，所以需要注意没有回调前的其他函数里组件加载显示
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败");
      
    }];
    //注意执行到这里的时候，self.contentarray很可能还是nil。
#pragma mark 下面是无需联网就写死的框架

    //左上角侧滑按钮，点击进入个人中心
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"person"] style:UIBarButtonItemStylePlain target:self action:@selector(leftNavBtnAction)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColor.redColor;
    
   
    
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


- (void)leftNavBtnAction
{
    //获取代理对象然后调用它那个属性方法
    SceneDelegate *delegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    [delegate.sideMenuContainer toggleLeftSideMenuWithCompleteBolck:nil];
}
- (void)rightNavBtnAction
{
    //点击标签编辑页
    NSLog(@"跳转到标签编辑页面咯");
    
    
    TagViewController * tags = [[TagViewController alloc]init];
    [tags initwithTags:self.dataArr :self.unSelectedDataArr];
    tags.delegate = self;
    [self.navigationController presentViewController:tags animated:YES completion:nil];
    
//    //暂时先执行销户方法
//    [SAMKeychain deletePasswordForService:@"NowUser" account:@"toutiaoim"];
//    //销户完后要刷新tabs页面的头像和收藏、点赞状态
//    [self.navigationItem.leftBarButtonItem setImage:[UIImage systemImageNamed:@"person"]];
//    //没法取消收藏和点赞按钮状态2333
}


#pragma mark 代理方法，实现wkwebview刷新立即通知父页面（调用父页面重写的方法），注意代理方法参数不能是引用，会取不到值还报错
- (void)notification:(NSString *)userMessageModelJSONString{
    NSLog(@"登录页面成功返回啦？那刷新下头像呗%@",userMessageModelJSONString); //出问题：登录页面成功返回啦？那刷新下头像呗<UserMessageModel: 0x60000086ee80>
    //注意，YYModel貌似没有直接将字符串转成字典的方法
    NSData *jsonData = [userMessageModelJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *usermodeldict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                                error:&err];
    
    NSString * imageurl = [usermodeldict objectForKey:@"userimageurl"]; //示例：@"https://pic.imgdb.cn/item/607834e78322e6675c32d96c.png"
    NSLog(@"imageurl======%@",imageurl); //注意检查nil
    NSLog(@"usermodeldict====%@",usermodeldict.yy_modelDescription);
    UIImage * image = [TabsbarViewController getImageFromURL:imageurl];
    //图片调整大小后显示BarButtonItem
//    [self.navigationItem.leftBarButtonItem setImage:[UIImage systemImageNamed:@"person.fill"]];
    [self.navigationItem.leftBarButtonItem setImage:[TabsbarViewController reSizeImage:image toSize:CGSizeMake(28, 28)]];
}

//下拉刷新
- (void)notificatioonModel:(NSString*)userMessageModelJSONString{
    NSLog(@"下拉刷新啦？那刷新下头像呗%@",userMessageModelJSONString); //出问题：登录页面成功返回啦？那刷新下头像呗<UserMessageModel: 0x60000086ee80>
    //发现登陆返回的是nil说明用户没有登陆（验证是登陆那边做的，层层回调到这里）
    if(userMessageModelJSONString == nil || [userMessageModelJSONString isEqual:@""]){
        [self.navigationItem.leftBarButtonItem setImage:[UIImage systemImageNamed:@"person"]];
        NSLog(@"userMessageModelJSONString==nil");
    }
    else{
        //注意，YYModel貌似没有直接将字符串转成字典的方法
        NSData *jsonData = [userMessageModelJSONString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *usermodeldict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                options:NSJSONReadingMutableContainers
                                                                  error:&err];
        //这里也可以转成Model进而显示：[UserMessageModel yy_modelwithJSON:jsonstr]获得UserMesageModel对象。
        NSString * imageurl = [usermodeldict objectForKey:@"userimageurl"]; //示例：@"https://pic.imgdb.cn/item/607834e78322e6675c32d96c.png"
        NSLog(@"usermodeldict===model=====%@",usermodeldict);
        NSLog(@"imageurl===model===%@",imageurl); //null
        UIImage * image = [TabsbarViewController getImageFromURL:imageurl];
        //图片调整大小后显示BarButtonItem
    //    [self.navigationItem.leftBarButtonItem setImage:[UIImage systemImageNamed:@"person.fill"]];
        [self.navigationItem.leftBarButtonItem setImage:[TabsbarViewController reSizeImage:image toSize:CGSizeMake(28, 28)]];
    }
}


//传入图片大小修正BarButtonItem图片
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize
{
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [reSizeImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

//根据网络URL获取UIIamge图片
+ (UIImage *) getImageFromURL:(NSString *)fileURL {
    //NSLog(@"执行图片下载函数");
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

//继承TagDelegate的方法。刷新标签数据
- (void) sentSelectedItems:(NSMutableArray*)selectedItems :(NSMutableArray*)unSelectItems{
    NSLog(@"用户从标签页刷新了选择标签，这里刷新整个TabsView");
    self.dataArr = [selectedItems mutableCopy];
    self.unSelectedDataArr = [unSelectItems mutableCopy];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"pageContentView"; //当前navigationccontroller的标题，在下面代码中被标签组件覆盖了
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/8,90, CGRectGetWidth(self.view.bounds) - self.view.frame.size.width/8 * 2, 50) titles:self.dataArr delegate:self indicatorType:FSIndicatorTypeEqualTitle];
    self.titleView.titleSelectFont = [UIFont systemFontOfSize:20];
    self.titleView.titleSelectColor = [UIColor redColor];
    self.titleView.selectIndex = self.selectedItemsIndex;
    [self.view addSubview:_titleView];
    
    NSMutableArray *childVCs = [[NSMutableArray alloc]init];
    for (NSString *title in self.dataArr) {
        HomeViewController *vc = [[HomeViewController alloc]init:self.Contentarray :title]; //加载对应标签的文章
        vc.title = title;
        vc.delegate = self; //利用代理方法实现监听，一旦收藏按钮进入登陆页面登陆成功，就会触发代理方法刷新头像
        [childVCs addObject:vc];
    }
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 90, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - 90) childVCs:childVCs parentVC:self delegate:self];
    self.pageContentView.contentViewCurrentIndex = self.selectedItemsIndex;
    self.pageContentView.contentViewCanScroll = YES;//设置滑动属性
    
    [self.view addSubview:_pageContentView];
    [self.navigationItem setTitleView: self.titleView];
}

- (void) sentSelectedLabelIndex:(NSInteger) index{
    self.selectedItemsIndex = index;
}

@end
