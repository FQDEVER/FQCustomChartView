//
//  FQChartView.h
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQChartConfiguration.h"
#import "FQSeriesElement.h"

NS_ASSUME_NONNULL_BEGIN

@class FQChartView;

@protocol FQChartViewDelegate <NSObject>

@optional


/**
 tap手势点击时.
 
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
- (void)chartView:(FQChartView *)chartView tapSelectItem:(NSArray <FQXAxisItem *> *)dataItemArr location:(NSArray<NSValue *> *)pointArr index:(NSInteger)index;

/**
 pan手势开始时.
 
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
- (void)chartView:(FQChartView *)chartView panBeginItem:(NSArray <FQXAxisItem *> *)dataItemArr location:(NSArray<NSValue *> *)pointArr index:(NSInteger)index;

/**
 pan手势滑动时.
 
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
- (void)chartView:(FQChartView *)chartView panChangeItem:(NSArray <FQXAxisItem *> *)dataItemArr location:(NSArray<NSValue *> *)pointArr index:(NSInteger)index;


/**
 pan手势结束时
 
 @param chartView chartView
 */
- (void)chartViewPanGestureEnd:(FQChartView *)chartView;

/**
 当popView位置发生变化时回调
 
 @param chartView chartView-图标视图
 @param popView 冒泡视图-可以直接设定其.如果未自定义.可配置dataItemArr的数据转换为字符串.给其contentTextStr赋值.如自定义.则给自定义的视图赋值相关dataItemArr数据
 @param dataItemArr 图表展示数据.包含x.y显示数据.
 */
-(void)chartView:(FQChartView *)chartView changePopViewPositionWithView:(FQPopTipView *)popView itemData:(NSArray <FQXAxisItem *> *)dataItemArr;

@end


@interface FQChartView : UIView

/**
 点击或者滑动chartView时的代理回调.该代码仅仅针对柱状图.折线图时.饼状图无回调
 */
@property (nonatomic, weak) id<FQChartViewDelegate> chartDelegate;

/**
 tap手势点击时block方式回调.
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
@property (nonatomic, copy) void(^tapSelectItemBlock)(FQChartView *chartView,NSArray <FQXAxisItem *> *dataItemArr,NSArray<NSValue *> *pointArr,NSInteger index);

/**
 pan手势开始时block方式回调.
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
@property (nonatomic, copy) void(^panBeginItemBlock)(FQChartView *chartView,NSArray <FQXAxisItem *> *dataItemArr,NSArray<NSValue *> *pointArr,NSInteger index);

/**
 pan手势滑动时block方式回调.
 @param chartView 图表视图
 @param dataItemArr 数据数组
 @param pointArr 位置点数组
 @param index 索引
 */
@property (nonatomic, copy) void(^panChangeItemBlock)(FQChartView *chartView,NSArray <FQXAxisItem *> *dataItemArr,NSArray<NSValue *> *pointArr,NSInteger index);

/**
 pan手势结束时block方式回调
 @param chartView chartView
 */
@property (nonatomic, copy) void(^panGestureEndBlock)(FQChartView *chartView);

/**
 当popView位置发生变化时block方式回调
 
 @param chartView chartView-图标视图
 @param popView 冒泡视图-可以直接设定其.如果未自定义.可配置dataItemArr的数据转换为字符串.给其contentTextStr赋值.如自定义.则给自定义的视图赋值相关dataItemArr数据
 @param dataItemArr 图表展示数据.包含x.y显示数据.
 */
@property (nonatomic, copy) void(^changePopViewPositionBlock)(FQChartView *chartView,FQPopTipView *popTipView,NSArray <FQXAxisItem *> *dataItemArr);

/**
 根据新配置文件.重新刷新图表
 
 @param configuration 配置文件
 */
-(void)fq_refreshChartViewWithConfiguration:(FQChartConfiguration *)configuration;

/**
 根据最新的itemdata数据.刷新图表 - 针对柱状图以及折线图
 
 @param axisItemDataArrs 图表数据数组.
 */
-(void)fq_refreshChartViewWithDataArr:(NSArray *)axisItemDataArrs;

/**
 根据最新的element数据.刷新图表 - 针对圆饼图
 
 @param element 图表数据数组.
 */
-(void)fq_refreshPieChartViewWithElement:(FQSeriesElement *)element;

/**
 开始绘制视图
 */
- (void)fq_drawCurveView;

/**
 获取当前水平柱状图的高度
 
 @return  获取当前水平柱状的高度
 */
-(CGFloat)getCurrentHorizontalBarHeight;

/**
 隐藏popView
 */
-(void)fq_hiddenCurveView;

/**
获取当前索引下的textLayer
*/
-(NSString *)getCurrentXAxisTextLayer:(NSInteger)index;

/**
 快捷创建对应的图表
 
 @param configuration 默认设置
 @param frame 布局
 @return 图表视图
 */
+ (instancetype)getChartViewWithConfiguration:(FQChartConfiguration *)configuration withFrame:(CGRect)frame;

/**
 获取默认柱状图样式
 
 @param xAxisStrArr x展示视图
 @param frame 布局尺寸
 @return chartView
 */
+(instancetype)getDefaultHistogramChartViewWithArr:(NSArray *)xAxisStrArr withFrame:(CGRect)frame;

@end

NS_ASSUME_NONNULL_END
