//
//  Comment_TableViewCell.m
//  toutiao_Comment
//
//  Created by Admin on 2021/6/27.
//
//  评论页的cell
//  cell的高度应当是45+20+textview的高度
#import "Comment_TableViewCell.h"
#import <Masonry.h>
#import "KxMenu.h"

@implementation Comment_TableViewCell

#pragma mark 使调用者传进一个textview，并存储其地址
- (void)sentMSG:(UITextView *)tv andName:(NSString *)name{
    self.textview = tv;
    self.pername = name;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:(UITableViewCellStyle)style reuseIdentifier:reuseIdentifier];
    //头像
    self.touXiang = [[UIImageView alloc]init];
    [self.contentView addSubview:self.touXiang];
    //评论详情
    self.comment = [[UITextView alloc]init];
    self.comment.font = [UIFont systemFontOfSize:12];
    self.comment.editable = NO;
    [self.contentView addSubview:self.comment];
    //用户名or回复
    self.name = [[UILabel alloc]init];
    self.name.font = [UIFont boldSystemFontOfSize:10];
    [self.contentView addSubview:self.name];
    //评论发布时间
    self.time = [[UILabel alloc]init];
    self.time.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.time];
    //点赞数
    self.dz_count = [[UILabel alloc]init];
    self.dz_count.font = [UIFont boldSystemFontOfSize:12];
    self.dz_count.textColor = [UIColor grayColor];
    [self.dz_count setTextAlignment:NSTextAlignmentRight];
    [self.contentView addSubview:self.dz_count];
    //点赞按钮
    self.dianzan = [[UIButton alloc]init];
    [self.dianzan setBackgroundImage:[UIImage systemImageNamed:@"hand.thumbsup"] forState:UIControlStateNormal];
    [self.dianzan addTarget:self action:@selector(dianzanaction:) forControlEvents:UIControlEventAllEvents];
    self.dianzan.tintColor = [UIColor lightGrayColor];
    [self.contentView addSubview:self.dianzan];
    //回复按钮
    self.reply = [[UIButton alloc]init];
    [self.reply setTitle:@"回复" forState:UIControlStateNormal];
    self.reply.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.reply.titleLabel setTextAlignment:NSTextAlignmentRight];
    [self.reply setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    //
    [self.reply addTarget:self action:@selector(replyaction:) forControlEvents:UIControlEventAllEvents];
    [self.contentView addSubview:self.reply];
    //菜单按钮
    self.menu = [[UIButton alloc]init];
    [self.menu addTarget:self action:@selector(menuaction:) forControlEvents:UIControlEventAllEvents];
    [self.menu setTitle:@"..." forState:UIControlStateNormal];
    self.menu.titleLabel.font = [UIFont boldSystemFontOfSize:24];
    [self.menu setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:self.menu];
    
    return self;
}


# pragma mark cell控件的Masonry布局
- (void)layoutSubviews{
    //头像
    [self.touXiang mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    //菜单按钮
    [self.menu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.right.equalTo(self.contentView.mas_right);
            make.size.mas_equalTo(CGSizeMake(50, 40));
    }];
    //用户名
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.height.mas_equalTo(@40);
            make.left.equalTo(self.touXiang.mas_right).with.offset(12);
            make.right.equalTo(self.menu.mas_right);
    }];
    //时间
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.touXiang.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(160, 20));
    }];
    //点赞按钮
    [self.dianzan mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).with.offset(-8);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    //点赞数
    [self.dz_count mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.right.equalTo(self.dianzan.mas_left);
            make.size.mas_equalTo(CGSizeMake(40, 20));
    }];
    //回复按钮
    [self.reply mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.dz_count.mas_left);
            make.bottom.equalTo(self.contentView.mas_bottom);
            make.size.mas_equalTo(CGSizeMake(50, 20));
    }];
    //评论详情
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.touXiang.mas_bottom);
            make.left.equalTo(self.touXiang.mas_right);
            make.bottom.equalTo(self.dianzan.mas_top);
            make.right.equalTo(self.contentView.mas_right).with.offset(-8);
    }];
}

//cell中回复按钮的事件响应
- (void) replyaction:(UIButton *)bt{
    self.textview.text = [NSString stringWithFormat:@"回复 %@ ：\n",self.pername];
    [self.textview becomeFirstResponder];
    
}

//点赞按钮响应
- (void)dianzanaction:(UIButton *)bt{
    
    if(!self.clicking){
        
        self.dianzan.tintColor = [UIColor systemBlueColor];
        NSInteger tem = [self.dz_count.text intValue];
        tem++;
        self.dz_count.text = [NSString stringWithFormat:@"%d",tem];
    }else{
        
        self.dianzan.tintColor = [UIColor lightGrayColor];
        NSInteger tem = [self.dz_count.text intValue];
        tem--;
        self.dz_count.text = [NSString stringWithFormat:@"%d",tem];
    }
    self.clicking = !self.clicking;
}



//菜单按钮的监听
- (void)menuaction:(UIButton *)bt{
    
    //这里用到了KxMenu框架
    NSArray *menuItems =
    @[[KxMenuItem menuItem:@"分享"
                     image:nil
                    target:self
                    action:@selector(shard)],
      [KxMenuItem menuItem:@"举报该评论"
                       image:nil
                      target:self
                      action:@selector(jubao)]
    ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor whiteColor];
    first.alignment = NSTextAlignmentCenter;
    [KxMenu showMenuInView:self.contentView
                  fromRect:bt.frame
                 menuItems:menuItems];
}


- (void)jubao{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notify_jubao" object:nil userInfo:@{@"jubaoname":self.name.text}];
}

- (void)shard{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"Notify_shard" object:nil userInfo:@{@"sharededname":self.name.text,@"sharededdate":self.comment.text}];
}

@end
