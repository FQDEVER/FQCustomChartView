//
//  FQTableViewC.m
//  FQ_ChartView
//
//  Created by fanqi on 2018/12/4.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQTableViewC.h"
#import "FQSportDetailCell.h"

@interface FQTableViewC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *sportChartArr;

@end

@implementation FQTableViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - tableviewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sportChartArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FQSportDetailCell * sportDetailCell = [tableView dequeueReusableCellWithIdentifier:@"FQSportDetailCellID" forIndexPath:indexPath];
//    sportDetailCell.sportModel = self.sportChartArr[indexPath.row];
    return sportDetailCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 控件-懒加载
-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[FQSportDetailCell class] forCellReuseIdentifier:@"FQSportDetailCellID"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = UIColor.clearColor;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.showsVerticalScrollIndicator = NO;
        //解决删除tableviewCell时.跳动的问题
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.rowHeight = 92;
    }
    return _tableView;
}

@end
