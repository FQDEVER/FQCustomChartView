//
//  FQCustomChartVc.m
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQCustomChartVc.h"
#import "FQChartView.h"
@interface FQCustomChartVc ()<FQChartViewDelegate>

@property (nonatomic, strong) FQChartView *chartView;

@property (nonatomic, weak) UILabel *customLabel;

@property (nonatomic, strong) FQPopTipView *popTipView;

@end

@implementation FQCustomChartVc

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置Large Title偏好设置为True
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:NO];
    } else {
        // Fallback on earlier versions
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //设置Large Title偏好设置为false
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:YES];
    } else {
        // Fallback on earlier versions
    }
}

//SpecialChartChartType_Histogram = 0, //柱状图
//SpecialChartChartType_BrokenLine ,   //折线图
//SpecialChartChartType_Histogram_BrokenLine ,   //柱状-折线图
//SpecialChartChartType_Histogram_BrokenLine_Point,         //柱状-折线-平均点图
//SpecialChartChartType_Histogram_Reverse, //柱状翻转
//SpecialChartChartType_BrokenLine_Reverse, //折线翻转
//SpecialChartChartType_RoundCakes,     //圆饼图

-(void)setType:(SpecialChartChartType)type
{
    _type = type;
    if (type == SpecialChartChartType_Histogram)
    {
        [self chartviewSpecialChartChartType_Histogram];
    }else if (type == SpecialChartChartType_BrokenLine) {
        [self chartViewSpecialChartChartType_BrokenLine];
    }else if (type == SpecialChartChartType_Histogram_BrokenLine) {
        [self chartViewSpecialChartChartType_Histogram_BrokenLine];
    }else if (type == SpecialChartChartType_BrokenLine_BrokenLineFill) {
        [self chartViewSpecialChartChartType_BrokenLine_BrokenLineFill];
    }else if (type == SpecialChartChartType_Histogram_Reverse) {
        [self chartViewSpecialChartChartType_Histogram_Reverse];
    }else if (type == SpecialChartChartType_BrokenLine_XReverse) {
        [self chartViewSpecialChartChartType_BrokenLine_XReverse];
    }else if (type == SpecialChartChartType_BrokenLine_YReverse) {
        [self chartViewSpecialChartChartType_BrokenLine_YReverse];
    }else if (type == SpecialChartChartType_RoundCakes) {
        [self chartViewSpecialChartChartType_RoundCakes];
    }
    
    //添加一个按钮.用来更新数据.
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 60, 150, 60)];
    [btn setBackgroundColor:[UIColor orangeColor]];
    [btn setTitle:@"更新数据" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refreshChartView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    //添加一个按钮.用来更新数据.
    UIButton * btn1 = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 150, self.view.frame.size.height - 60, 150, 60)];
    [btn1 setBackgroundColor:[UIColor orangeColor]];
    [btn1 setTitle:@"更新整个配置文件" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(refreshChartViewConfiguration) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
}

/**
 柱状图
 */
-(void)chartviewSpecialChartChartType_Histogram{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@8,@30,@60,@17].mutableCopy;
//    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.barPlaceholderColor = [UIColor clearColor];
    element.barColors = @[UIColor.redColor,UIColor.blueColor,UIColor.cyanColor,UIColor.orangeColor].mutableCopy;
    element.fillLayerHidden = NO;
    element.barSpacing = 0;
//    element.barWidth = 20.0;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.showXAxisStringDatas = @[@"极限",@"无氧",@"有氧",@"其他"].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @7;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.hiddenLeftYAxis = YES;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 100, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.delegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 折线图
 */
-(void)chartViewSpecialChartChartType_BrokenLine{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element.fillLayerBackgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    //    FQSeriesElement * element1 = [[FQSeriesElement alloc]init];
    //    element1.chartType = FQChartType_Line;
    //    element1.yAxisAligmentType = FQChartYAxisAligmentType_Right;
    //    element1.orginNumberDatas = @[@20,@10,@30,@60,@7].mutableCopy;
    //    element1.chartType = FQChartType_Line;
    //    element1.gradientColors = @[(id)[UIColor redColor].CGColor,(id)[UIColor blueColor].CGColor];
    //    element1.fillLayerHidden = YES;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];//element
    //    chartConfiguration.gridColumnCount = element.orginNumberDatas.count * 2.0 - 1;
    //    chartConfiguration.gridRowCount = 5 * 2 - 1;
    chartConfiguration.hiddenLeftYAxis = NO;
    //    chartConfiguration.showXAxisInterval = 1; //即012345.变为024
    //从小到大
    //    chartConfiguration.showXAxisStringDatas = @[@"OC",@"C++",@"C",@"JAVA"].mutableCopy;
    //    chartConfiguration.showXAxisStringNumberDatas = @[@"1",@"2",@"5"].mutableCopy;
    //从小到大
    //    chartConfiguration.showLeftYAxisNames = @[@"低",@"中",@"高"].mutableCopy;
    //    chartConfiguration.showLeftYAxisDatas = @[@10,@30].mutableCopy;
    
    //从小到大
    //        chartConfiguration.showRightYAxisNames = @[@"低",@"中",@"高"].mutableCopy;
    chartConfiguration.showRightYAxisDatas = @[@0,@10,@20,@30,@40,@50,@60].mutableCopy;
    //    chartConfiguration.showLeftYAxisDatas = @[@0,@20,@30,@40,@50,@60].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @60;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yRightAxisMaxNumber = @60;
    chartConfiguration.yRightAxisMinNumber = @0;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.yAxisRightTitle = @"m/s";
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    
    chartConfiguration.mainContainerBackColor = rgba(250, 250, 250, 1.0f);
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 100, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.delegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 柱状图-折线图
 */
-(void)chartViewSpecialChartChartType_Histogram_BrokenLine{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@8,@7,@10,@30,@60,@17].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.barSpacing = 5.0f;
    element.barWidth = 20.0;
    element.modeType = FQModeType_RoundedCorners;
    element.barPlaceholderColor = [UIColor grayColor];
    element.averageNum = @30;
    element.averageLineColor = [UIColor redColor];
    element.averageLineType = ChartSelectLineType_DottedLine;
    
    FQSeriesElement * element1 = [[FQSeriesElement alloc]init];
    element1.chartType = FQChartType_Line;
    element1.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element1.orginNumberDatas = @[@20,@10,@30,@60,@6].mutableCopy;
    element1.chartType = FQChartType_Line;
    element1.gradientColors = @[(id)[UIColor redColor].CGColor,(id)[UIColor blueColor].CGColor];
    element1.fillLayerHidden = YES;
    element1.modeType = FQModeType_RoundedCorners;
    element1.averageNum = @20;
    element1.averageLineColor = [UIColor blueColor];
    element1.averageLineType = ChartSelectLineType_SolidLine;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element,element1];
    //    chartConfiguration.gridColumnCount = element.orginNumberDatas.count * 2.0 - 1;
    //    chartConfiguration.gridRowCount = 5 * 2 - 1;
    
//        chartConfiguration.showXAxisInterval = 1; //即012345.变为024
    //从小到大
//        chartConfiguration.showXAxisStringDatas = @[@"OC",@"C++",@"C",@"JAVA",@"C",@"AS"].mutableCopy;
//        chartConfiguration.showXAxisStringNumberDatas = @[@"1",@"2",@"5"].mutableCopy;
    //从小到大
    //    chartConfiguration.showLeftYAxisNames = @[@"低",@"中",@"高"].mutableCopy;
//        chartConfiguration.showLeftYAxisDatas = @[@10,@20,@30,@40,@50,@60].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @7;
    
    chartConfiguration.yAxisLeftTitle = @"步频(次/分钟)";
    chartConfiguration.yAxisRightTitle = @"海拔高度(米)";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.isShowPopView = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.isSelectPointBorder = NO;
    chartConfiguration.unitDescrType = ChartViewUnitDescrType_Top;
    
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    
    chartConfiguration.chartBackLayerColor = rgba(240, 240, 240, 1.0f);
    chartConfiguration.chartViewEdgeInsets = UIEdgeInsetsMake(30, 0, 5, 0);
    //------设定刚好把Y轴隔离出背景Layer.
    chartConfiguration.chartBackLayerEdgeInsets = UIEdgeInsetsMake(0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin, 0, chartConfiguration.kYAxisChartViewMargin + chartConfiguration.kChartViewWidthMargin);
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 100, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.delegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 折线-折线渲染
 */
-(void)chartViewSpecialChartChartType_BrokenLine_BrokenLineFill{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@8,@7,@10,@30,@60,@17].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    
    element.isGradientFillLayer = YES;
    element.fillLayerBackgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:1.0];
    
    element.barSpacing = 5.0f;
    element.barWidth = 20.0;
    element.modeType = FQModeType_RoundedCorners;
    element.averageNum = @30;
    element.averageLineColor = [UIColor redColor];
    element.averageLineType = ChartSelectLineType_DottedLine;
    
    FQSeriesElement * element1 = [[FQSeriesElement alloc]init];
    element1.chartType = FQChartType_Line;
    element1.yAxisAligmentType = FQChartYAxisAligmentType_Right;
    element1.orginNumberDatas = @[@20,@10,@30,@60,@6].mutableCopy;
    element1.chartType = FQChartType_Line;
    element1.gradientColors = @[(id)[UIColor redColor].CGColor,(id)[UIColor blueColor].CGColor];
    element1.fillLayerHidden = YES;
    element1.modeType = FQModeType_RoundedCorners;
    element1.averageNum = @20;
    element1.averageLineColor = [UIColor blueColor];
    element1.averageLineType = ChartSelectLineType_SolidLine;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element,element1];
    //    chartConfiguration.gridColumnCount = element.orginNumberDatas.count * 2.0 - 1;
    //    chartConfiguration.gridRowCount = 5 * 2 - 1;
    
    //        chartConfiguration.showXAxisInterval = 1; //即012345.变为024
    //从小到大
    //        chartConfiguration.showXAxisStringDatas = @[@"OC",@"C++",@"C",@"JAVA",@"C",@"AS"].mutableCopy;
    //        chartConfiguration.showXAxisStringNumberDatas = @[@"1",@"2",@"5"].mutableCopy;
    //从小到大
    //    chartConfiguration.showLeftYAxisNames = @[@"低",@"中",@"高"].mutableCopy;
    //        chartConfiguration.showLeftYAxisDatas = @[@10,@20,@30,@40,@50,@60].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @7;
    
    chartConfiguration.yAxisLeftTitle = @"步频(次/分钟)";
    chartConfiguration.yAxisRightTitle = @"海拔高度(米)";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.isShowPopView = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.mainContainerBackColor = rgba(250.0, 250.0, 250.0, 1.0f);
    chartConfiguration.isSelectPointBorder = NO;
    chartConfiguration.unitDescrType = ChartViewUnitDescrType_Top;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 100, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.delegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 柱状翻转
 */
-(void)chartViewSpecialChartChartType_Histogram_Reverse{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@8,@7,@10,@8,@7,@10,@30,@60,@17,@30,@60,@17,@8,@7,@10,@30,@60,@17,@8,@7,@10,@30,@60,@17].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.barSpacing = 4.0f;
    element.barPlaceholderColor = rgba(230, 230, 230, 1.0);
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    chartConfiguration.showXAxisStringDatas = @[@"·",@"·",@"·",@"·",@"·",@"06",@"·",@"·",@"·",@"·",@"·",@"12",@"·",@"·",@"·",@"·",@"·",@"18",@"·",@"·",@"·",@"·",@"·",@"24"].mutableCopy;
    chartConfiguration.xAxisIsBottom = NO;
    chartConfiguration.isShowPopView = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.popArrowDirection = FQArrowDirectionUP;
    chartConfiguration.popContentBackColor = [UIColor orangeColor];
    chartConfiguration.xAxisLabelsTitleColor = [UIColor lightGrayColor];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 100, self.view.bounds.size.width, 200)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.delegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}


/**
 折线翻转 -x轴翻转
 */
-(void)chartViewSpecialChartChartType_BrokenLine_XReverse{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Right;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];//element
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.showRightYAxisDatas = @[@0,@10,@20,@30,@40,@50,@60].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yRightAxisMaxNumber = @70;
    chartConfiguration.yRightAxisMinNumber = @10;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.yAxisRightTitle = @"m/s";
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.xAxisIsBottom = NO;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 100, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.delegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

#warning  -- 这两个需要操作

/**
 折线翻转 -Y轴翻转 - 针对配速图标.也就是数据越大.
 */
-(void)chartViewSpecialChartChartType_BrokenLine_YReverse{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Right;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];//element
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.showRightYAxisDatas = @[@10,@20,@30,@40,@50,@60].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yRightAxisMaxNumber = @70;
    chartConfiguration.yRightAxisMinNumber = @10;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.yAxisRightTitle = @"m/s";
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.unitDescrType = ChartViewUnitDescrType_LeftRight;
    chartConfiguration.xAxisIsBottom = YES;
    chartConfiguration.yAxisIsReverse = YES;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 64, self.view.bounds.size.width, 300)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.delegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
    

    FQSeriesElement * element1 = [[FQSeriesElement alloc]init];
    element1.chartType = FQChartType_Line;
    element1.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element1.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element1.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element1.fillLayerHidden = NO;
    element1.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration1 = [[FQChartConfiguration alloc]init];
    chartConfiguration1.elements = @[element1];//element
    chartConfiguration1.hiddenRightYAxis = NO;
    chartConfiguration1.hiddenLeftYAxis = NO;
    chartConfiguration1.showRightYAxisDatas = @[@0,@10,@20,@30,@40,@50,@60].mutableCopy;
    chartConfiguration1.showLeftYAxisDatas = @[@0,@10,@20,@30,@40,@50,@60].mutableCopy;
    //设定最大值范围
    chartConfiguration1.yLeftAxisMaxNumber = @70;
    chartConfiguration1.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration1.yRightAxisMaxNumber = @70;
    chartConfiguration1.yRightAxisMinNumber = @10;
    
    chartConfiguration1.yAxisLeftTitle = @"min";
    chartConfiguration1.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration1.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration1.yAxisRightTitle = @"m/s";
    chartConfiguration1.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration1.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration1.unitDescrType = ChartViewUnitDescrType_LeftRight;
    chartConfiguration1.xAxisIsBottom = NO;
    chartConfiguration1.yAxisIsReverse = NO;

    //自定义
//    _popTipView = [FQPopTipView initWithPopViewWithDirection:FQArrowDirectionDOWN maxX:self.view.bounds.size.width minX:0 edge:UIEdgeInsetsMake(5, 5, 5, 5) contentText:@"x:y:" textColor:UIColor.whiteColor textFont:[UIFont systemFontOfSize:15]];
//    _popTipView.marginSpcingW = 20;
//    _popTipView.marginSpcingH = 10;
//    _popTipView.cornerRadius = 5.0f;
//    _popTipView.contentBackColor = [UIColor blueColor];
//    chartConfiguration1.customPopTip = _popTipView;
    //自定义
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor whiteColor];
    _popTipView = [FQPopTipView initWithPopViewWithDirection:FQArrowDirectionUP maxX:self.view.bounds.size.width minX:0 edge:UIEdgeInsetsMake(5, 5, 5, 5) customView:view andCustomSize:CGSizeMake(100, 30)];
    _popTipView.marginSpcingW = 20;
    _popTipView.marginSpcingH = 10;
    _popTipView.cornerRadius = 5.0f;
    _popTipView.contentBackColor = [UIColor blueColor];
    chartConfiguration1.customPopTip = _popTipView;
    
    FQChartView *curveView1 = [FQChartView getChartViewWithConfiguration:chartConfiguration1 withFrame:CGRectMake(0, 364, self.view.bounds.size.width, 300)];
    curveView1.backgroundColor = [UIColor whiteColor];
    curveView1.delegate = self;
    [self.view addSubview:curveView1];
    [curveView1 fq_drawCurveView];
}

/**
 圆饼图
 */
-(void)chartViewSpecialChartChartType_RoundCakes{
    
    
}


#pragma mark - 更新数据

-(void)refreshChartView{
    
    if (_type == SpecialChartChartType_Histogram)
    {
        [self.chartView refreshChartViewWithDataArr:@[@[@10,@20,@40,@10]]];
    }else if (_type == SpecialChartChartType_BrokenLine) {
        [self.chartView refreshChartViewWithDataArr:@[@[@13,@2,@19,@60,@20,@17]]];
    }else if (_type == SpecialChartChartType_Histogram_BrokenLine) {
        [self.chartView refreshChartViewWithDataArr:@[@[@20,@10,@30,@60,@6],@[@8,@7,@10,@30,@60,@17]]];
    }else if (_type == SpecialChartChartType_BrokenLine_BrokenLineFill) {
        [self.chartView refreshChartViewWithDataArr:@[@[@20,@10,@30,@60,@6,@8,@7,@10,@30,@60,@17],@[@8,@7,@10,@30,@60,@17,@20,@10,@30,@60,@6]]];
    }else if (_type == SpecialChartChartType_Histogram_Reverse) {
        [self.chartView refreshChartViewWithDataArr:@[@[@30,@60,@17,@30,@60,@17,@8,@7,@10,@8,@7,@10,@8,@7,@10,@30,@60,@17,@8,@7,@10,@30,@60,@17]]];
    }else if (_type == SpecialChartChartType_BrokenLine_XReverse) {
        [self.chartView refreshChartViewWithDataArr:@[@[@13,@2,@19,@60,@20,@17]]];
    }else if (_type == SpecialChartChartType_BrokenLine_YReverse) {
        [self.chartView refreshChartViewWithDataArr:@[@[@13,@2,@19,@60,@20,@17]]];
    }else if (_type == SpecialChartChartType_RoundCakes) {
        [self chartViewSpecialChartChartType_RoundCakes];
    }
}

-(void)refreshChartViewConfiguration{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Bar;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@30,@20,@10,@60,@30].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.barPlaceholderColor = [UIColor clearColor];
    element.barColors = @[UIColor.redColor,UIColor.blueColor,UIColor.cyanColor,UIColor.orangeColor].mutableCopy;
    element.fillLayerHidden = NO;
    element.barSpacing = 0;
    //    element.barWidth = 20.0;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.showXAxisStringDatas = @[@"极限",@"无氧",@"有氧",@"燃脂",@"PP"].mutableCopy;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @7;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.hiddenLeftYAxis = YES;
    
    [self.chartView refreshChartViewWithConfiguration:chartConfiguration];
}



#pragma mark - chartViewDelegate
/**
 tap手势点击时.
 
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
- (void)chartView:(FQChartView *)chartView tapSelectItem:(NSArray <FQXAxisItem *> *)dataItemArr location:(NSArray<NSValue *> *)pointArr index:(NSInteger)index{
    NSLog(@"-------------点击%@--%@---%zd",dataItemArr,pointArr,index);
}

/**
 pan手势开始时.
 
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
- (void)chartView:(FQChartView *)chartView panBeginItem:(NSArray <FQXAxisItem *> *)dataItemArr location:(NSArray<NSValue *> *)pointArr index:(NSInteger)index
{
    NSLog(@"-------------开始%@--%@---%zd",dataItemArr,pointArr,index);
}

/**
 pan手势滑动时.
 
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
- (void)chartView:(FQChartView *)chartView panChangeItem:(NSArray <FQXAxisItem *> *)dataItemArr location:(NSArray<NSValue *> *)pointArr index:(NSInteger)index
{
 NSLog(@"-------------滑动%@--%@---%zd",dataItemArr,pointArr,index);
}


/**
 pan手势结束时
 
 @param chartView chartView
 */
- (void)chartViewPanGestureEnd:(FQChartView *)chartView
{
    NSLog(@"-------------结束%@=",chartView);
}

/**
 当popView位置发生变化时回调
 
 @param chartView chartView-图标视图
 @param popView 冒泡视图-可以直接设定其.如果未自定义.可配置dataItemArr的数据转换为字符串.给其contentTextStr赋值.如自定义.则给自定义的视图赋值相关dataItemArr数据
 @param dataItemArr 图表展示数据.包含x.y显示数据.
 */
-(void)chartView:(FQChartView *)chartView changePopViewPositionWithView:(FQPopTipView *)popView itemData:(NSArray <FQXAxisItem *> *)dataItemArr
{
    NSLog(@"-------------xxxxx->popView%@--%@",dataItemArr,popView);
    NSMutableString * muStr = [NSMutableString string];
    for (int i = 0; i < dataItemArr.count; ++i) {
        if (i != 0) {
            [muStr appendString:@"\n"];
        }
        FQXAxisItem * xaxisItem = dataItemArr[i];
        [muStr appendString:[NSString stringWithFormat:@"AAAA:%@",xaxisItem.dataValue]];
    }
    
    popView.contentTextStr = muStr.copy;
}

@end
