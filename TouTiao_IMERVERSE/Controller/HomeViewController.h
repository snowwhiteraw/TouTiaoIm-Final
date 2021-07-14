//
//  ViewController.h
//  TouTiao_IMERVERSE
//
//  Created by 123 on 2021/6/16.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MessageContentModel.h"
#import "UserMessageModel.h"
#import "ZanLikeView.h"

@protocol HomeDelegate <NSObject>

//代理方法，实现wkwebview刷新立即通知父页面（调用父页面重写的方法），这个参数是字典
- (void)notification:(NSString *)userMessageModelJSONString;

//代理方法，参数是模型
- (void)notificatioonModel:(NSString*)userMessageModelJSONString;


@end

//本类只加载对应标签的wkwebbview文章和对应按钮及其数据
@interface HomeViewController : UIViewController

// 代理属性
@property (weak,nonatomic) id<HomeDelegate> delegate;

@property (strong, nonatomic)  UIButton *agreeButton; //旧版本的点赞按钮，现在改为likeview，因为要加动画
@property (nonatomic, strong) ZanLikeView *likeView;
@property (strong, nonatomic)  UIButton *commentButton;
@property (strong, nonatomic)  UIButton *colletionButton;
@property (strong, nonatomic)  UIButton *shareButton;
@property (strong, nonatomic)  UILabel *agreeNumlabel;
@property (strong, nonatomic)  WKWebView * wkwebview; //文章视图，全屏
@property (strong, nonatomic)  UILabel *commentNumLabel;
@property (strong, nonatomic)  UILabel *collectionNumLabel;
@property (strong, nonatomic)  UILabel *shareNumLabel;
@property (strong, nonatomic)  UIButton *nextMessageButton;

@property (strong,nonatomic) NSString* messagelabel; //本类只显示此标签的文章
//一次联网加载到APP的几十条h5文章相关标签
@property (strong, nonatomic) NSMutableArray<MessageContentModel *> * Contentarray;

//@property int returnNum;  //此属性是一次返回的文章数，也是json里面的数组数————直接用conArr.count代替
@property (strong, nonatomic) NSString* isFollowed;

@property int messageNum;//文章序号

@property  BOOL urlNum; //加载的url标志，YES加载一个url，NO加载另一个url

@property (strong,nonatomic) NSMutableString * urlNow;//当前url

@property (strong, nonatomic) UITabBar * tabsbar; //顶部标签页

@property (strong, nonatomic) UIVisualEffectView *visual; //毛玻璃特效数值,0为完全透明，1为完全不透明

@property int num404; //404文章的self.conArr的序号

@property (nonatomic, strong) UIProgressView    *progressView;

- (void) setViewfunc:(int) num : (NSString*)messagelabel;

- (void) setViewfuncjustfor404;

- (instancetype)init:(NSMutableArray<MessageContentModel *> *)dataArr : (NSString*) label;

- (void) netWorking : (NSString*) url;

- (void) loadButtons: (int) num : (NSString*)messagelabel;

@end

