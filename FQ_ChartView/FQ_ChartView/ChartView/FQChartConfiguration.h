//
//  FQChartConfiguration.h
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQSeriesElement.h"
#import "FQMeshElement.h"
#import "FQPopTipView.h"
#import "FQHorizontalBarElement.h"
#import "FQBothwayBarElement.h"

#define kXAxisShowNameWithBigDot @"kXAxisShowNameWithBigDot"
#define kXAxisShowNameWithSmoDot @"kXAxisShowNameWithSmoDot"

typedef NS_ENUM(NSInteger,ChartViewUnitDescrType) {
    ChartViewUnitDescrType_Top = 0, //上边
    ChartViewUnitDescrType_LeftRight ,//左侧Y轴在左侧.右边Y轴在右侧.
};

typedef NS_ENUM(NSInteger,ChartViewTitleDescType) {
    ChartViewTitleDescType_Right = 0 ,//标题描述居右对齐  标题- |
    ChartViewTitleDescType_Left, //标题描述居左对齐  | -标题
};

typedef NS_ENUM(NSInteger,ChartViewStartPointType) {
    ChartViewStartPointType_Center = 0, //中心点
    ChartViewStartPointType_Left ,//起点.结束点.
};

typedef NS_ENUM(NSInteger,ChartViewXYAxisCustomStrType) {//自定义串的布局样式
    ChartViewXYAxisCustomStrType_LeftRight = 0 ,//从左到右撑满.上下撑满
    ChartViewXYAxisCustomStrType_Center, //居中布局
    ChartViewXYAxisCustomStrType_Corresponding ,//能与实际数据对应上.如果是Y轴.就和LeftRight效果一致
    ChartViewXYAxisCustomStrType_Corresponding_Data ,//与实际X轴的位置对应
};


@interface FQChartConfiguration : NSObject

/**
 如果指定显示的数组为showXAxisStringDatas或者showLeftYAxisNames.showRightYAxisNames时.参考该参数布局
 */
@property (nonatomic, assign) ChartViewXYAxisCustomStrType xyAxisCustomStrType;

#pragma mark - X轴

/*---------------------------------------------优先级最高----------------------------------------*/
#pragma mark - 优先级最高
/**
 显示出来的X轴的值.只想显示其中的是文字.这种只适用等分 @[20180103,20180203,20180303].
 */
@property (nonatomic, strong) NSArray<NSString *> *showXAxisStringDatas;

/**
 显示出来的X轴值.这种会根据X轴的数据选择性展示. 例如:[1,2,3,4,5,6,7,8,9]选中对面[@1,@3,@7,@8]
 */
@property (nonatomic, strong) NSArray<NSNumber *> *showXAxisStringNumberDatas;

/*---------------------------------------------优先级第二----------------------------------------*/
#pragma mark - 优先级第二
/**
 显示出来的X轴的值.间隔.默认为0.例如.间隔为2.那么针对1,2,3.....24.取出来为.1.4.7...
 */
@property (nonatomic, assign) NSInteger showXAxisInterval;

/*---------------------------------------------优先级最低----------------------------------------*/
#pragma mark - 优先级最低
//默认为最小到最大全部排列.所以需要自己定义.

/**
 x轴是否在底部.默认为YES.设定为NO就在顶部 - 这个是底部.
 */
@property (nonatomic, assign) BOOL xAxisIsBottom;

/**
 是否隐藏X轴
 */
@property (nonatomic, assign) BOOL hiddenXAxis;

/**
 是否显示X轴标识.默认为No.
 */
@property (nonatomic, assign) BOOL isShowXAxisFlag;

/*---------------------------------------------y轴----------------------------------------*/
#pragma mark - y轴

/**
 左侧y轴数据显示是否倒序.默认为NO.
 */
@property (nonatomic, assign) BOOL yLeftAxisIsReverse;

/**
 右侧y轴数据显示是否倒序.默认为NO.
 */
@property (nonatomic, assign) BOOL yRightAxisIsReverse;

/**
 描述位置.
 */
@property (nonatomic, assign) ChartViewUnitDescrType unitDescrType;
/**
 左Y轴单位
 */
@property (nonatomic, copy) NSString *yAxisLeftTitle;

/**
 左Y轴单位布局 - 默认为ChartViewTitleDescType_Right
 */
@property (nonatomic, assign) ChartViewTitleDescType yAxisLeftTitleType;

/**
 右Y轴单位
 */
@property (nonatomic, copy) NSString *yAxisRightTitle;

/**
 右Y轴单位布局 - 默认为ChartViewTitleDescType_Left
 */
@property (nonatomic, assign) ChartViewTitleDescType yAxisRightTitleType;

/**
 左Y轴单位字体
 */
@property (nonatomic, strong) UIFont *yAxisLeftTitleFont;

/**
 右Y轴单位字体
 */
@property (nonatomic, strong) UIFont *yAxisRightTitleFont;

/**
 左Y轴单位颜色
 */
@property (nonatomic, strong) UIColor *yAxisLeftTitleColor;

/**
 右Y轴单位颜色
 */
@property (nonatomic, strong) UIColor *yAxisRightTitleColor;

/**
 实际显示那几条.Y轴坐标以showLeftYAxisDatas为标准.若不存在showLeftYAxisDatas.那就默认均等分.
 */
@property (nonatomic, strong) NSArray<NSString *> *showLeftYAxisNames;

/**
 实际显示那几条.Y轴坐标以showRightYAxisDatas为标准.若不存在showRightYAxisDatas.那就默认均等分.
 */
@property (nonatomic, strong) NSArray<NSString *> *showRightYAxisNames;

/*---------------------------------------------优先级最高----------------------------------------*/
#pragma mark - 优先级最高

/**
 左Y轴点数据源.可以直接从指定的点开始@[@5,@10,@20].是否存在.
 */
@property (nonatomic, strong) NSArray<NSNumber *> *showLeftYAxisDatas;

/**
 右Y轴点数据源.可以直接从指定的点开始@[@5,@10,@20].是否存在
 */
@property (nonatomic, strong) NSArray<NSNumber *> *showRightYAxisDatas;

/*---------------------------------------------优先级第二----------------------------------------*/
#pragma mark - 优先级第二

//设定最大值
@property (nonatomic, strong) NSNumber * yLeftAxisMaxNumber;

//设定最小值
@property (nonatomic, strong) NSNumber * yLeftAxisMinNumber;

//设定最大值
@property (nonatomic, strong) NSNumber * yRightAxisMaxNumber;

//设定最小值
@property (nonatomic, strong) NSNumber * yRightAxisMinNumber;

/*---------------------------------------------优先级最小 - 默认.----------------------------------------*/
#pragma mark - 优先级最小 - 默认.
//如果没有就从0到最大.等分5次排列.

/**
 是否隐藏左边Y轴.默认为YES
 */
@property (nonatomic, assign) BOOL hiddenLeftYAxis;

/**
 是否隐藏右边Y轴.默认为YES.
 */
@property (nonatomic, assign) BOOL hiddenRightYAxis;

/**
 是否隐藏左边Y轴上的文本.默认为NO
 */
@property (nonatomic, assign) BOOL hiddenLeftYAxisText;

/**
 是否隐藏右边Y轴的文本.默认为NO
 */
@property (nonatomic, assign) BOOL hiddenRightYAxisText;


/*---------------------------------------------图表数据----------------------------------------*/
#pragma mark - 图表数据

//叠加图.一般叠加图使用均是同一组x轴数据.即个数一致
@property (nonatomic, strong) NSArray <FQSeriesElement *>*elements;

/*---------------------------------------------图表设定----------------------------------------*/
#pragma mark - 图表设定
/**
 是否显示图例 - #warning 还待完善
 */
@property (nonatomic, assign) BOOL isShowLegend;

/*---------------------------------------------布局相关.----------------------------------------*/
#pragma mark - 布局相关.
/**
 整个ChartView的内边距
 */
@property (nonatomic, assign) UIEdgeInsets chartViewEdgeInsets;

/**
 图表视图(包含X.Y轴)背景色的内边距
 */
@property (nonatomic, assign) UIEdgeInsets chartBackLayerEdgeInsets;

/**
 图表背景色(包含X.Y轴)
 */
@property (nonatomic, strong) UIColor * chartBackLayerColor;

/**
 图表视图(不包含X.Y)背景色
 */
@property (nonatomic, strong) UIColor *mainContainerBackColor;

/**
 默认Y轴显示个数.默认为5
 */
@property (nonatomic, assign) NSInteger kDefaultYAxisNames;

/**
 x轴描述距离X轴的间距.默认为5.0
 */
@property (nonatomic, assign) CGFloat kXAxisLabelTop;

/**
 图表视图与y轴描述的间距.默认为20.0
 */
@property (nonatomic, assign) CGFloat kChartViewAndYAxisLabelMargin;

/**
 y轴描述距离y轴的间距.默认为5.0
 */
@property (nonatomic, assign) CGFloat kYAxisLabelMargin;

/**
 y轴描述距离chartView的间距.默认为10.0
 */
@property (nonatomic, assign) CGFloat kYAxisChartViewMargin;

/**
 单位距离.y轴的间距.默认为10.0
 */
@property (nonatomic, assign) CGFloat kYTitleLabelBot;

/**
 y轴描述的宽度.默认为30.0
 */
@property (nonatomic, assign) CGFloat kChartViewWidthMargin;

/**
 x轴描述的高度.默认为25.0
 */
@property (nonatomic, assign) CGFloat kChartViewHeightMargin;


// ---- popView相关
/**
 是否显示popView.默认为Yes
 */
@property (nonatomic, assign) BOOL isShowPopView;

/**
 popView的箭头所在位置
 */
@property (nonatomic, assign) FQArrowDirection popArrowDirection;

/**
 contentView的背景色
 */
@property (nonatomic, strong) UIColor *popContentBackColor;

/**
 popView默认样式文字的字体
 */
@property (nonatomic, strong) UIFont *popTextFont;

/**
 popview默认样式文字颜色
 */
@property (nonatomic, strong) UIColor *popTextColor;

/**
 是否添加阴影
 */
@property (nonatomic, assign) BOOL isPopViewAddShadow;

/**
 想自定义popTipView.直接传入该对象.不传则默认是用String样式.
 */
@property (nonatomic, strong) FQPopTipView *customPopTip;

// ---- 选中线相关

/**
 选中线条的颜色 - 如果不需要.可以设定为透明色.
 */
@property (nonatomic, strong) UIColor *currentLineColor;

/**
 选中线条的类型
 */
@property (nonatomic, assign) ChartSelectLineType selectLineType;

/**
 是否隐藏当前选中标识线
 */
@property (nonatomic, assign) BOOL isHiddenCurrentLine;

// ----- 选中点相关

/**
 是否显示所有数据标点选中点.默认为NO
 */
@property (nonatomic, assign) BOOL isShowAllPoint;

/**
 是否显示选中点.默认为YES
 */
@property (nonatomic, assign) BOOL isShowSelectPoint;

/**
 选中点是否需要白色边框.默认为YES
 */
@property (nonatomic, assign) BOOL isSelectPointBorder;

/**
 选中点的边框颜色.默认为白色
 */
@property (nonatomic, strong) UIColor *pointBorderColor;


/*---------------------------------------------动画相关-待完善----------------------------------------*/
#pragma mark - 动画相关-待完善

/**
 绘制的时候是否需要动画，默认YES - 待完善
 */
@property (nonatomic, assign) BOOL drawWithAnimation;

/**
 绘制动画时间，默认0.0s - 待完善
 */
@property (nonatomic, assign) CGFloat drawAnimationDuration;


/*---------------------------------------------网格线相关----------------------------------------*/
#pragma mark - 网格线相关

/**
 是否隐藏x轴方向(水平)网格线，默认NO
 */
@property (nonatomic, assign) BOOL xAxisGridHidden;

/**
 是否隐藏y轴方向(竖直)网格线，默认NO
 */
@property (nonatomic, assign) BOOL yAxisGridHidden;

/**
 网格线宽度，默认1
 */
@property (nonatomic, assign) CGFloat gridLineWidth;

/**
 网格线颜色，默认黑色,
 */
@property (nonatomic, strong) UIColor *gridLineColor;

/**
 网格线的长度. -- -- -- -- -- --.单小段 -- 的长度
 */
@property (nonatomic, assign) CGFloat gridlineLength;

/**
 网格线间距的的长度. -- -- -- -- -- --.单小段的间距-- --的长度
 */
@property (nonatomic, assign) CGFloat gridlineSpcing;

/**
 行网格线数量，默认10
 */
@property (nonatomic, assign) NSUInteger gridRowCount;

/**
 列网格线数量，默认10
 */
@property (nonatomic, assign) NSUInteger gridColumnCount;

/*---------------------------------------------columnLabels,列标相关----------------------------------------*/
#pragma mark - columnLabels,列标相关

/**
 x轴label的颜色, 默认黑色
 */
@property (nonatomic, strong) UIColor *xAxisLabelsTitleColor;

/**
 x轴label的字体，默认12
 */
@property (nonatomic, strong) UIFont *xAxisLabelsTitleFont;

/**
 x轴label选中的颜色，默认白色
 */
@property (nonatomic, strong) UIColor *xAxisSelectTitleColor;

/**
x轴label是否展示选中的颜色，默认NO
*/
@property (nonatomic, assign) BOOL showXAxisSelectColor;

/*---------------------------------------------rowLabels,行标相关----------------------------------------*/
#pragma mark - rowLabels,行标相关

/**
 y轴label的颜色, 默认黑色
 */
@property (nonatomic, strong) UIColor *yAxisLabelsTitleColor;

/**
 y轴label的字体，默认12
 */
@property (nonatomic, strong) UIFont *yAxisLabelsTitleFont;
/**
 y轴的宽度固定. - 待完善
 */
//@property (nonatomic, assign) CGFloat yAxisLabelsWidth;

#pragma 手势相关

/**
 是否开启长按手势，开启手势后长按会通过代理将手指所在位置的最近的坐标和对应的值返回，默认开启
 */
@property (nonatomic, assign) BOOL gestureEnabel;

/*---------------------------------------------添加水平柱状图数据----------------------------------------*/
#pragma mark - 添加水平柱状图数据

/**
 水平柱状图样式
 */
@property (nonatomic, strong) FQHorizontalBarElement *horBarElement;

/**
 标题与图表的间距.默认为4
 */
@property (nonatomic, assign) CGFloat kHorizontalBarTitleMargin;

/**
 水平柱状X轴左侧文本的宽.默认为20
 */
@property (nonatomic, assign) CGFloat kHorizontalBarXAxisLeftLabW;

/**
 水平柱状X轴右侧文本的宽.默认为55
 */
@property (nonatomic, assign) CGFloat kHorizontalBarXAxisRightLabW;

/**
 水平柱状图与左侧的间距.默认16
 */
@property (nonatomic, assign) CGFloat kHorizontalBarLeftMargin;

/**
 水平柱状图与右侧的间距.默认为16
 */
@property (nonatomic, assign) CGFloat kHorizontalBarRightMargin;

/**
 水平柱状图与顶部的间距.默认为26
 */
@property (nonatomic, assign) CGFloat kHorizontalBarTopMargin;

/**
 水平柱状图与底部的间距默认为10
 */
@property (nonatomic, assign) CGFloat kHorizontalBarBotMargin;

/**
 水平柱状图每个item的间距.默认为4.
 */
@property (nonatomic, assign) CGFloat kHorizontalBarItemMargin;

/*---------------------------------------------赛程样式分段标识数组----------------------------------------*/
#pragma mark - 赛程样式图表.

/**
 全数据中的索引数组@[@1,@3,@9]
 */
@property (nonatomic, strong) NSArray <NSNumber *>* sportSchedulesIndex ;

/**
 全数据中x轴占比数组@[@0.3,@0.6,@0.9]
 */
@property (nonatomic, strong) NSArray <NSNumber *>* sportSchedulesprogress ;


/*---------------------------------------------其他图表----------------------------------------*/
#pragma mark - 其他图表

/**
 图表开始绘制的起点. --- 一般有柱状的时候是取中心.如果只有折线时取左右.两者叠加时.使用中心样式.
 */
@property (nonatomic, assign) ChartViewStartPointType startPointType;

/**
 左侧YAxis文本保留几位小数.默认为0.最大为3位
 */
@property (nonatomic, assign) NSInteger leftDecimalCount;

/**
 右侧YAxis文本保留几位小数.默认为0.最大为3位
 */
@property (nonatomic, assign) NSInteger rightDecimalCount;

/*---------------------------------------------绘制网状图表----------------------------------------*/
#pragma mark - 网状图表

/**
 绘制网状图表样式
 */
@property (nonatomic, strong) FQMeshElement *meshElement;

/*---------------------------------------------绘制横向图表----------------------------------------*/
#pragma mark - 绘制横向图表

/**
 水平横向图表样式
 */
@property (nonatomic, strong) FQBothwayBarElement * bothwayBarElement ;

@end

