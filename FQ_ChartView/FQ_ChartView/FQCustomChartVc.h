//
//  FQCustomChartVc.h
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger,SpecialChartChartType) {
    SpecialChartChartType_Histogram = 0, //柱状图
    SpecialChartChartType_BrokenLine ,   //折线图
    SpecialChartChartType_Histogram_BrokenLine ,   //柱状-折线图
    SpecialChartChartType_BrokenLine_BrokenLineFill,//折线-折线渲染
    SpecialChartChartType_Histogram_Reverse, //柱状翻转
    SpecialChartChartType_BrokenLine_XReverse, //折线图-X翻转
    SpecialChartChartType_BrokenLine_YReverse, //折线图-Y轴翻转
    SpecialChartChartType_RoundCakes,     //圆饼图
    SpecialChartChartType_NoneDataBar,     //无数据的柱状图展示
    SpecialChartChartType_NoneDataPie,     //无数据的饼状图展示
    SpecialChartChartType_MeterCircle,     //计圈样式
    SpecialChartChartType_HeartRate,       //心率样式
    SpecialChartChartType_HorizontalBarChart,//水平柱状
    SpecialChartChartType_CustomCenter,       //自定义居中
    SpecialChartChartType_CustomLeftRight,       //自定义左右对齐
    SpecialChartChartType_CustomCorresponding,       //自定义对应每条数据
    SpecialChartChartType_CustomXAxisItem,       //自定义对应X轴数据不均等的情况
    SpecialChartChartType_AdvancedBarTopLine,       //进阶9 - 柱状.顶部折线展示(一组数据)
    SpecialChartChartType_AdvancedLineAndDot,       //进阶10 - 折线-点图展示(一组数据)
    SpecialChartChartType_AdvancedRadarChart,       //进阶11 - 雷达网状图展示
    SpecialChartChartType_AdvancedRoundCakesChart,          //进阶12 - 炫酷圆饼展示
    SpecialChartChartType_AdvancedBothwayBarChart,       //进阶13 - 左右横向柱状图展示
    SpecialChartChartType_AdvancedTransverseBarChart,    //进阶14 - 运动频率图展示
    SpecialChartChartType_AdvancedSportScheduleChart,    //进阶15 - 多段赛事展示
    SpecialChartChartType_Histogram_Gradient, //柱状渐变
    SpecialChartChartType_BrokenLine_Double_Highlight, //双折线可高亮
};


@interface FQCustomChartVc : UIViewController

@property (nonatomic, assign) SpecialChartChartType type;

@end

NS_ASSUME_NONNULL_END
