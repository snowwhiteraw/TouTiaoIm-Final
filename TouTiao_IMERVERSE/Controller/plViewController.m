//
//  plViewController.m
//  toutiao_cj_zry
//
//  Created by Admin on 2021/6/23.
//

#import "plViewController.h"
#import "plCell.h"
#import "HomeViewController.h"
@interface plViewController ()<UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *plTableView;

@end

@implementation plViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _plTableView.rowHeight = 120;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ID = @"plcell";
    plCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(!cell){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"plCell" owner:nil options:nil]firstObject];
    }
    return  cell;
}




@end
