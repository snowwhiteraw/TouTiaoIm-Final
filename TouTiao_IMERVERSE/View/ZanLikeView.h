//
//  ZanLikeView.h
//  LikeDemo
//
//  Created by sunyazhou on 2018/11/26.
//  Copyright © 2018 sunyazhou.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LikeDelegate <NSObject>

//代理方法，实现点击爱心响应给HomeVC,让HomeVC知道爱心被点击了，需要在右边的agreeNumLabel + 1或者变成999+
- (void) TouchUpLikeView: (NSString*)isPressed; //isPressed为YES就表示当前爱心被点下了需要爱心数+1，NO就需要-1

@end

@interface ZanLikeView : UIView

@property (weak,nonatomic) id<LikeDelegate> delegate;

@property (strong,nonatomic) UIImageView *likeBefore;
@property (strong,nonatomic) UIImageView *likeAfter;
@property (assign,nonatomic) CGFloat     likeDuration;
@property (strong,nonatomic) UIColor     *zanFillColor;

@property  CGFloat heartWidth;
@property  CGFloat heartHeight;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)resetView;
@end

NS_ASSUME_NONNULL_END
