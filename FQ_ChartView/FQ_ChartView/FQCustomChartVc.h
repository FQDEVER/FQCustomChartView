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
    
};


@interface FQCustomChartVc : UIViewController

@property (nonatomic, assign) SpecialChartChartType type;

@end

NS_ASSUME_NONNULL_END
