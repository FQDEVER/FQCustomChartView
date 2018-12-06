//
//  ViewController.m
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/23.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "ViewController.h"
#import "FQCustomChartVc.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController


#pragma mark ============ 测试屏幕旋转 ==============
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
}

-(NSArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = @[
                     @{@"柱状图":@"icon_acceleration"},
                     @{@"折线图":@"icon_pip"},
                     @{@"柱状-折线图":@"icon_spring"},
                     @{@"折线-折线渲染":@"icon_rotation"},
                     @{@"柱状翻转图":@"icon_rubber"},
                     @{@"折线翻转图 - X翻转":@"icon_flash"},
                     @{@"折线翻转图 - Y翻转":@"icon_calc"},
                     @{@"圆图":@"icon_momentum"},
                     @{@"自定义1":@"icon_calc"},
                     @{@"自定义2":@"icon_calc"},
                     @{@"自定义3":@"icon_calc"},
                     @{@"自定义4":@"icon_calc"},
                     @{@"自定义5":@"icon_calc"},
                     @{@"自定义6":@"icon_calc"},
                     @{@"自定义7":@"icon_calc"},
                     ];
    }
    return _dataArr;
}

#pragma -mark UITableView数据源方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //添加三种样式
    UITableViewCell * tableviewCell = [tableView dequeueReusableCellWithIdentifier:@"AlertController" forIndexPath:indexPath];
    tableviewCell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary * dict = self.dataArr[indexPath.row];
    tableviewCell.textLabel.text = dict.allKeys.firstObject;
    tableviewCell.imageView.image = [UIImage imageNamed:dict.allValues.firstObject];
    tableviewCell.textLabel.textColor = [UIColor whiteColor];
    tableviewCell.accessoryType   =  UITableViewCellAccessoryDisclosureIndicator;
    tableviewCell.backgroundColor = [UIColor blackColor];
    return tableviewCell;
}


#pragma -mark UITableView代理
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FQCustomChartVc * chartVc = [[FQCustomChartVc alloc]init];
    chartVc.type = indexPath.row;
    [self.navigationController pushViewController:chartVc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
        _tableView.backgroundColor = [UIColor blackColor];
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.sectionFooterHeight = CGFLOAT_MIN;
        _tableView.estimatedSectionFooterHeight = CGFLOAT_MIN;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AlertController"];
    }
    return _tableView;
}


@end
