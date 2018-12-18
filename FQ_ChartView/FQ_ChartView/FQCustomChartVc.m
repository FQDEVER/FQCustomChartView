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
    }else if (type == SpecialChartChartType_NoneDataBar){
        [self chartViewSpecialChartChartType_NoneDataBar];
    }else if (type == SpecialChartChartType_NoneDataPie){
        [self chartViewSpecialChartChartType_NoneDataPie];
    }else if(type == SpecialChartChartType_MeterCircle){
        [self  chartviewSpecialChartChartType_MeterCircle];
    }else if (type == SpecialChartChartType_HeartRate){
        [self  chartviewSpecialChartChartType_HeartRate];
    }else if (type == SpecialChartChartType_CustomCenter){
        [self  chartviewSpecialChartChartType_CustomCenter];
    }else if (type == SpecialChartChartType_CustomLeftRight){
         [self  chartviewSpecialChartChartType_CustomLeftRight];
    }else if (type == SpecialChartChartType_CustomCorresponding){
        [self  chartviewSpecialChartChartType_CustomCorresponding];
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
    element.barPlaceholderColor = [UIColor clearColor];
    element.barColors = @[UIColor.redColor,UIColor.blueColor,UIColor.cyanColor,UIColor.orangeColor].mutableCopy;
    element.fillLayerHidden = NO;
    element.barSpacing = 0;
    
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
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
//    curveView.chartDelegate = self;
    curveView.changePopViewPositionBlock = ^(FQChartView * _Nonnull chartView, FQPopTipView * _Nonnull popTipView, NSArray<FQXAxisItem *> * _Nonnull dataItemArr) {
        NSLog(@"-------------xxxxx->popView%@--%@",dataItemArr,popTipView);
        NSMutableString * muStr = [NSMutableString string];
        for (int i = 0; i < dataItemArr.count; ++i) {
            if (i != 0) {
                [muStr appendString:@"\n"];
            }
            FQXAxisItem * xaxisItem = dataItemArr[i];
            [muStr appendString:[NSString stringWithFormat:@"AAAA:%@",xaxisItem.dataValue]];
        }
        
        popTipView.contentTextStr = muStr.copy;
    };
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
    element.orginNumberDatas = @[@5,@10,@60,@30].mutableCopy;
    element.fillLayerBackgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.3];
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
//    chartConfiguration.showRightYAxisDatas = @[@0,@10,@20,@30,@40,@50,@60].mutableCopy;
    chartConfiguration.showXAxisStringDatas = @[@"22:99",@"10:20",@"30:10",@"19:20",@"18:00"];
    //设定最大值范围
//    chartConfiguration.yLeftAxisMaxNumber = @60;
//    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
//    
//    chartConfiguration.yRightAxisMaxNumber = @60;
//    chartConfiguration.yRightAxisMinNumber = @0;
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.yAxisRightTitle = @"m/s";
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.xAxisGridHidden = YES;
    chartConfiguration.yAxisGridHidden = YES;
    
    chartConfiguration.mainContainerBackColor = rgba(250, 250, 250, 1.0f);
    chartConfiguration.kYAxisLabelMargin = 10;
    chartConfiguration.kYAxisChartViewMargin = 0;
    chartConfiguration.startPointType = ChartViewStartPointType_Left;
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_LeftRight;
    chartConfiguration.leftDecimalCount = 4;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(20, 164, self.view.bounds.size.width - 40, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
//    curveView.chartDelegate = self;
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
    element.orginNumberDatas = @[@20,@7,@10,@30,@60,@17].mutableCopy;
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
    element1.orginNumberDatas = @[@8,@0,@0,@60,@10].mutableCopy;
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
//    chartConfiguration.yLeftAxisMaxNumber = @70;
//    chartConfiguration.yLeftAxisMinNumber = @7;
    
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
    
    chartConfiguration.yLeftAxisIsReverse = NO;//YES;
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
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
    element.modeType = FQModeType_RoundedCorners;
    element.isGradientFillLayer = YES;
    element.fillLayerBackgroundColor = [[UIColor orangeColor]colorWithAlphaComponent:1.0];
    element.averageNum = @30;
    element.averageLineColor = [UIColor redColor];
    element.averageLineType = ChartSelectLineType_DottedLine;
    element.selectPointColor = UIColor.redColor;
    
    FQSeriesElement * element1 = [[FQSeriesElement alloc]init];
    element1.chartType = FQChartType_Line;
    element1.yAxisAligmentType = FQChartYAxisAligmentType_Right;
    element1.orginNumberDatas = @[@8,@7,@10,@30,@60,@17].mutableCopy;
    element1.chartType = FQChartType_Line;
    element1.gradientColors = @[(id)[UIColor redColor].CGColor,(id)[UIColor blueColor].CGColor];
    element1.fillLayerHidden = YES;
    element1.modeType = FQModeType_RoundedCorners;
    element1.averageNum = @20;
    element1.averageLineColor = [UIColor blueColor];
    element1.averageLineType = ChartSelectLineType_SolidLine;
    element1.selectPointColor = UIColor.blueColor;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element,element1];
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @80;
    chartConfiguration.yLeftAxisMinNumber = @0;
    chartConfiguration.yRightAxisMaxNumber = @80;
    chartConfiguration.yRightAxisMinNumber = @0;
    
    chartConfiguration.yAxisLeftTitle = @"min";//@"步频(次/分钟)";
    chartConfiguration.yAxisRightTitle = @"m/s";//@"海拔高度(米)";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisRightTitleColor = [UIColor blueColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    chartConfiguration.yAxisRightTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.yAxisGridHidden = NO;
    chartConfiguration.xAxisGridHidden = NO;
    chartConfiguration.gridRowCount = 5;
    chartConfiguration.gridColumnCount = 2;
    
    chartConfiguration.hiddenLeftYAxis = NO;
    chartConfiguration.hiddenRightYAxis = NO;
    chartConfiguration.isShowPopView = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.mainContainerBackColor = rgba(250.0, 250.0, 250.0, 1.0f);
    chartConfiguration.isSelectPointBorder = NO;
    chartConfiguration.unitDescrType = ChartViewUnitDescrType_LeftRight;
    chartConfiguration.yLeftAxisIsReverse = YES;
    chartConfiguration.yRightAxisIsReverse = NO;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
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
    chartConfiguration.showXAxisStringDatas = @[kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithBigDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,@"06",kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithBigDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,@"12",kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithBigDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,@"18",kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithBigDot,kXAxisShowNameWithSmoDot,kXAxisShowNameWithSmoDot,@"24"].mutableCopy;
    chartConfiguration.xAxisIsBottom = NO;
    chartConfiguration.isShowPopView = YES;
    chartConfiguration.selectLineType = ChartSelectLineType_DottedLine;
    chartConfiguration.popArrowDirection = FQArrowDirectionUP;
    chartConfiguration.popContentBackColor = [UIColor orangeColor];
    chartConfiguration.xAxisLabelsTitleColor = rgba(102, 102, 102, 1);
    chartConfiguration.xAxisLabelsTitleFont = [UIFont systemFontOfSize:9];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 200)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
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
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

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
    chartConfiguration.yRightAxisIsReverse = YES;
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 64, self.view.bounds.size.width, 300)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
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
    chartConfiguration1.yLeftAxisIsReverse = NO;

    //自定义提示框
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
    curveView1.chartDelegate = self;
    [self.view addSubview:curveView1];
    [curveView1 fq_drawCurveView];
}

/**
 圆饼图
 */
-(void)chartViewSpecialChartChartType_RoundCakes{
    
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Pie;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7,@9].mutableCopy;
    element.pieColors = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor greenColor],[UIColor lightGrayColor],[UIColor cyanColor]];
    element.showPieNameDatas = @[@"跑步",@"游泳",@"骑行",@"铁人三项",@"夜跑",@"室内跑",@"室内游泳"];
    element.pieRadius = 50.0f;
    element.pieCenterMaskRadius = 60.0f;
    element.pieCenterDesc = @"8623";
    element.pieCenterUnit = @"小时";
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];//element
    chartConfiguration.chartBackLayerColor = rgba(240, 240, 240, 1.0);

    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];

}

/**
 无数据柱状图
 */
-(void)chartViewSpecialChartChartType_NoneDataBar{
    
    
    NSArray * xAxisStrArr = @[@"20",@"21",@"22",@"23",@"24",@"25",@"26"];
    FQChartView *curveView = [FQChartView getDefaultHistogramChartViewWithArr:xAxisStrArr withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
    
}

/**
 无数据的饼状图
 */
-(void)chartViewSpecialChartChartType_NoneDataPie{

    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Pie;
    element.pieRadius = 50.0f;
    element.pieCenterMaskRadius = 60.0f;
    element.pieCenterDesc = @"0000";
    element.pieCenterUnit = @"0000";
    element.pieCenterDescColor = UIColor.redColor;
    element.pieCenterDescFont = [UIFont systemFontOfSize:40];
    element.pieCenterUnitColor = UIColor.redColor;
    element.pieCenterUnitFont = [UIFont systemFontOfSize:40];
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.elements = @[element];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}



/**
 计圈样式
 */
-(void)chartviewSpecialChartChartType_MeterCircle{
    
    FQHorizontalBarItem * barItem = [[FQHorizontalBarItem alloc]init];
    barItem.xLeftAxisStr = @"1";
    barItem.contentStr = @"5’56”";
    barItem.barTopStr = @"+293";
    barItem.xRightAxisStr = @"6:30";
    barItem.valueData = @100;
    barItem.isSelect = YES;
    
    FQHorizontalBarItem * barItem1 = [[FQHorizontalBarItem alloc]init];
    barItem1.xLeftAxisStr = @"1";
    barItem1.contentStr = @"5’56”";
    barItem1.barTopStr = @"+293";
    barItem1.xRightAxisStr = @"6:30";
    barItem1.valueData = @50;
    
    FQHorizontalBarItem * barItem2 = [[FQHorizontalBarItem alloc]init];
    barItem2.xLeftAxisStr = @"1";
    barItem2.contentStr = @"5/’56/”";
    barItem2.barTopStr = @"+293";
    barItem2.xRightAxisStr = @"6:30";
    barItem2.valueData = @0;
    
    FQHorizontalBarElement * element = [[FQHorizontalBarElement alloc]init];
    element.horizontalBarItemArr = @[barItem,barItem1,barItem2];
    element.horizontalBarContentType = ChartHorizontalBarContentType_Inside;
    element.isShowXLeftAxisStr = YES;
    element.isShowXRightAxisStr = YES;
    //设定他展示的最小值
    element.narrowestW = 66;
    
    element.contentTitle = @"配速";
    element.xRightTitle = @"累计耗时";
    element.horBarBotDesc = @"最后一圈0.89公里,用时8:30";
    element.horBarBotRightDesc = @"22:40:28";
    element.horBarBotLeftDesc = @"其他";
    
    element.titleColor = rgba(102, 102, 102, 1.0f);
    element.titleFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:12];
    element.xLeftAxisLabColor = rgba(102, 102, 102, 1.0f);
    element.xLeftAxisLabFont = [UIFont fontWithName:@"PingFangSC-Regular"size:12];
    element.contentLabColor = rgba(255, 255, 255, 1);
    element.contentLabFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:14];
    element.chartTopLabColor = rgba(153, 153, 153, 1.0f);
    element.chartTopLabFont = [UIFont fontWithName:@"PingFangSC-Regular"size:10];
    element.xRightAxisLabColor = rgba(102, 102, 102, 1.0f);
    element.xRightAxisLabFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:12];
    element.gradientColors = @[(id)rgba(0, 227, 255, 1).CGColor,(id)rgba(0, 122, 255, 1).CGColor];
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.horBarElement = element;
    chartConfiguration.kHorizontalBarBotMargin = 20;
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

/**
 心率样式
 */
-(void)chartviewSpecialChartChartType_HeartRate{
    FQHorizontalBarItem * barItem = [[FQHorizontalBarItem alloc]init];
    barItem.xLeftAxisStr = @"38%";
    barItem.contentStr = @"热身(95-114)";
    barItem.barTopStr = @"3:58:36";
    barItem.valueData = @0;//时间长度
    FQHorizontalBarItem * barItem1 = [[FQHorizontalBarItem alloc]init];
    barItem1.xLeftAxisStr = @"18%";
    barItem1.contentStr = @"燃脂(115-133)";
    barItem1.barTopStr = @"58:36";
    barItem1.valueData = @2;
    
    FQHorizontalBarItem * barItem2 = [[FQHorizontalBarItem alloc]init];
    barItem2.xLeftAxisStr = @"28%";
    barItem2.contentStr = @"有氧耐力(134-152)";
    barItem2.barTopStr = @"2:28:36";
    barItem2.valueData = @4;
    
    FQHorizontalBarItem * barItem3 = [[FQHorizontalBarItem alloc]init];
    barItem3.xLeftAxisStr = @"68%";
    barItem3.contentStr = @"无氧耐力(153-171)";
    barItem3.barTopStr = @"6:58:36";
    barItem3.valueData = @68;
    
    FQHorizontalBarItem * barItem4 = [[FQHorizontalBarItem alloc]init];
    barItem4.xLeftAxisStr = @"8%";
    barItem4.contentStr = @"极限(172)";
    barItem4.barTopStr = @"28:36";
    barItem4.valueData = @8;
    
    
    FQHorizontalBarElement * element = [[FQHorizontalBarElement alloc]init];
    element.horizontalBarItemArr = @[barItem,barItem1,barItem2,barItem3,barItem4];
    element.horizontalBarContentType = ChartHorizontalBarContentType_Top;
    element.isShowXLeftAxisStr = YES;
    element.xLeftAxisLabColor = rgba(51, 51, 51, 1.0f);
    element.xLeftAxisLabFont = [UIFont fontWithName:@"PingFangSC-Regular"size:12];
    element.contentLabColor = rgba(102, 102, 102, 1.0f);
    element.contentLabFont = [UIFont fontWithName:@"PingFangSC-Semibold"size:12];
    element.chartTopLabColor = rgba(153, 153, 153, 1.0f);
    element.chartTopLabFont = [UIFont fontWithName:@"PingFangSC-Regular"size:12];
    element.colors = @[rgba(71, 204, 255, 1),rgba(65, 212, 0, 1),rgba(183, 238, 2, 1),rgba(251,222, 6, 1),rgba(238, 58, 28, 1)];
    element.horBarHeight = 12;
    element.horBarMargin = 2;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.horBarElement = element;
    chartConfiguration.kHorizontalBarTopMargin = 0;
    chartConfiguration.kHorizontalBarXAxisRightLabW = 0;

    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 300)];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

-(void)chartviewSpecialChartChartType_CustomCenter{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_Center;
    
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.showLeftYAxisNames = @[@"aaa",@"bbb",@"ccc",@"dddd"];
    chartConfiguration.showXAxisStringDatas = @[@"aaa",@"bbb"];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

-(void)chartviewSpecialChartChartType_CustomLeftRight{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_LeftRight;
    
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.showLeftYAxisNames = @[@"aaa",@"bbb",@"ccc",@"dddd"];
    chartConfiguration.showXAxisStringDatas = @[@"aaa",@"bbb"];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

-(void)chartviewSpecialChartChartType_CustomCorresponding{
    FQSeriesElement * element = [[FQSeriesElement alloc]init];
    element.chartType = FQChartType_Line;
    element.yAxisAligmentType = FQChartYAxisAligmentType_Left;
    element.orginNumberDatas = @[@10,@20,@10,@30,@60,@7].mutableCopy;
    element.gradientColors = @[(id)[UIColor orangeColor].CGColor,(id)[UIColor cyanColor].CGColor];
    element.fillLayerHidden = NO;
    element.modeType = FQModeType_RoundedCorners;
    
    FQChartConfiguration * chartConfiguration = [[FQChartConfiguration alloc]init];
    chartConfiguration.xyAxisCustomStrType = ChartViewXYAxisCustomStrType_Corresponding;
    
    chartConfiguration.elements = @[element];
    chartConfiguration.hiddenLeftYAxis = NO;
    //设定最大值范围
    chartConfiguration.yLeftAxisMaxNumber = @70;
    chartConfiguration.yLeftAxisMinNumber = @10; //如果不是最小.则使用数据中的最小.
    
    chartConfiguration.yAxisLeftTitle = @"min";
    chartConfiguration.yAxisLeftTitleColor = [UIColor redColor];
    chartConfiguration.yAxisLeftTitleFont = [UIFont systemFontOfSize:15];
    
    chartConfiguration.showLeftYAxisNames = @[@"aaa",@"bbb",@"ccc",@"dddd"];
    chartConfiguration.showXAxisStringDatas = @[@"aaa",@"bbb"];
    
    FQChartView *curveView = [FQChartView getChartViewWithConfiguration:chartConfiguration withFrame:CGRectMake(0, 164, self.view.bounds.size.width, 400)];
    curveView.backgroundColor = [UIColor whiteColor];
    _chartView = curveView;
    curveView.chartDelegate = self;
    [self.view addSubview:curveView];
    [curveView fq_drawCurveView];
}

#pragma mark - 更新数据

-(void)refreshChartView{
    
    if (_type == SpecialChartChartType_Histogram)
    {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@10,@20,@40,@10]]];
    }else if (_type == SpecialChartChartType_BrokenLine) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@13,@2,@19,@60,@20,@17]]];
    }else if (_type == SpecialChartChartType_Histogram_BrokenLine) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@20,@10,@30,@60,@6],@[@8,@7,@10,@30,@60,@17]]];
    }else if (_type == SpecialChartChartType_BrokenLine_BrokenLineFill) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@20,@10,@30,@60,@6,@8,@7,@10,@30,@60,@17],@[@8,@7,@10,@30,@60,@17,@20,@10,@30,@60,@6]]];
    }else if (_type == SpecialChartChartType_Histogram_Reverse) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@30,@60,@17,@30,@60,@17,@8,@7,@10,@8,@7,@10,@8,@7,@10,@30,@60,@17,@8,@7,@10,@30,@60,@17]]];
    }else if (_type == SpecialChartChartType_BrokenLine_XReverse) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@13,@2,@19,@60,@20,@17]]];
    }else if (_type == SpecialChartChartType_BrokenLine_YReverse) {
        [self.chartView fq_refreshChartViewWithDataArr:@[@[@13,@2,@19,@60,@20,@17]]];
    }else if (_type == SpecialChartChartType_RoundCakes) {
        
        FQSeriesElement * element = [[FQSeriesElement alloc]init];
        element.chartType = FQChartType_Pie;
        element.orginNumberDatas = @[@10,@20,@10,@30].mutableCopy;
        element.pieColors = @[[UIColor redColor],[UIColor blueColor],[UIColor orangeColor],[UIColor cyanColor],[UIColor greenColor],[UIColor lightGrayColor],[UIColor cyanColor]];
        element.showPieNameDatas = @[@"跑步",@"游泳",@"骑行",@"铁人三项"];
        element.pieRadius = 50.0f;
        element.pieCenterMaskRadius = 60.0f;
        element.pieCenterDesc = @"8";
        element.pieCenterUnit = @"小时";
        [self.chartView fq_refreshPieChartViewWithElement:element];
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
    
    [self.chartView fq_refreshChartViewWithConfiguration:chartConfiguration];
}



#pragma mark - chartViewchartDelegate
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
        [muStr appendString:[NSString stringWithFormat:@"x:%@,y:%@",xaxisItem.dataNumber,xaxisItem.dataValue]];
    }

    popView.contentTextStr = muStr.copy;
}

@end
