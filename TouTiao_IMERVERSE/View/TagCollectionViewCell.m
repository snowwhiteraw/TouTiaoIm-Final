//
//  TagCollectionViewCell.m
//  TouTiao_IMERVERSE
///Users/a123/Documents/TouTiao_IMERVERSE/TouTiao_IMERVERSE/View/TagHeaderView.m
//  Created by 123 on 2021/7/1.
//

#import "TagCollectionViewCell.h"
#import <Masonry/Masonry.h>

@interface TagCollectionViewCell ()

@end

@implementation TagCollectionViewCell


/*
 在初始化使用init方法初始化时，会将以init开头的初始化方法，按顺序调用一遍。比如以下几个方法：

 1 initWithFrame:
 2 initWithNibName:
 3 initWithStyle:
 PS：注意，在自定义Cell时，使用register注册一个Cell时，仅调用initWithStyle:方法。（存疑）
 
 https://www.cnblogs.com/naray/p/5020798.html
 **/
- (instancetype)initWithFrame:(CGRect)frame { //这个frame是由collectionView负责的
    if (self = [super initWithFrame:frame]) {
        //这里处理cell的样式
        [self.titleLabel.layer setBorderWidth: 1.0]; //给文本加边框
        self.titleLabel.layer.cornerRadius = 5;//圆角边框（该值到一定的程度，就为圆形了。）
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

//重写UIView的方法
- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.bounds;//文本充满整个视图（毕竟这就一个cell）
    
}

//懒加载，调用此类实例.inEditState将会调用此方法，不能修改参数和返回类型
- (void)setInEditState:(BOOL)inEditState {
    NSLog(@"Coll的cell的状态被赋值");
    _inEditState = inEditState;
    if (inEditState) {
        NSLog(@"Coll的cell的状态是YES");
        self.titleLabel.backgroundColor = [UIColor lightGrayColor];
        
        if([self.contentView viewWithTag:1] == nil){
            UIImageView * uiimage = [[UIImageView alloc]init];
            [uiimage setImage: [UIImage systemImageNamed:@"minus"]]; //可编辑时的减号
            [uiimage setTintColor:UIColor.blackColor];
            uiimage.tag = 1; //给此子视图打上标记，日后可以根据这个标记找到它
            [self.contentView addSubview:uiimage];
            
            //masonry自动布局
            [uiimage mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.right.equalTo(self.contentView).offset(1); //减号的上、右距离本视图1px(像素)距离
                make.size.mas_equalTo(CGSizeMake(10, 10)); //直接指定减号大小
            }];
        }
        else{
            [self.contentView viewWithTag:1].hidden = NO;
        }
    }
    else {
        self.titleLabel.backgroundColor = [UIColor whiteColor];
        [self.contentView viewWithTag:1].hidden = YES; //不处于编辑状态下隐藏右上角那个减号
    }
}

//懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel *titleLabel = [UILabel new]; //new == alloc + init
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter; //文本居中
        titleLabel.adjustsFontSizeToFitWidth = YES; //宽度自动适应文本
        _titleLabel = titleLabel;
    }
    
    return _titleLabel;
}

@end
