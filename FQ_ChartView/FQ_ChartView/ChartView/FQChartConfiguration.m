//
//  FQChartConfiguration.m
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import "FQChartConfiguration.h"

@implementation FQChartConfiguration

-(instancetype)init
{
    if (self = [super init]) {
        [self creatDefaultConofiguration];
    }
    return self;
}

-(void)creatDefaultConofiguration{
    
    _drawWithAnimation = YES;
    _xAxisLabelsTitleColor = _yAxisLabelsTitleColor = _yAxisRightTitleColor = _yAxisLeftTitleColor = [UIColor blackColor];
    _xAxisLabelsTitleFont = _yAxisLabelsTitleFont = _yAxisRightTitleFont = _yAxisLeftTitleFont = [UIFont systemFontOfSize:12];
    _gridLineWidth = 0.5;
    _gridLineColor = rgba(0, 0, 0, 0.2);
    _gridRowCount = 10;
    _gridColumnCount = 10;
    _gridlineLength = 5;
    _gridlineSpcing = 5;
    
    _gestureEnabel = YES;
    _drawAnimationDuration = 0.0f;
    _hiddenLeftYAxis = YES;
    _hiddenRightYAxis = YES;
    _xAxisIsBottom = YES;
    _currentLineColor = [UIColor blackColor];
    _popContentBackColor = [UIColor blackColor];
    _mainContainerBackColor = [UIColor clearColor];
    _isShowPopView = YES;
    _isShowSelectPoint = YES;
    _isSelectPointBorder = YES;
    _popTextFont = [UIFont systemFontOfSize:11];
    _popTextColor = [UIColor whiteColor];
    _chartBackLayerEdgeInsets = UIEdgeInsetsZero;
    _chartBackLayerColor = [UIColor clearColor];
    _kDefaultYAxisNames = 4;
    _kXAxisLabelTop = 5.0;
    _kYAxisLabelMargin = 5.0;
    _kYAxisChartViewMargin = 10.0;
    _kYTitleLabelBot = 10.0;
    _kChartViewWidthMargin = 30.0;
    _kChartViewHeightMargin = 25.0;
    _isPopViewAddShadow = YES;
    
    _kHorizontalBarTitleMargin = 4;
    _kHorizontalBarXAxisLeftLabW = 20;
    _kHorizontalBarXAxisRightLabW = 55;
    _kHorizontalBarLeftMargin = 16;
    _kHorizontalBarRightMargin = 16;
    _kHorizontalBarTopMargin = 22;
    _kHorizontalBarBotMargin = 10;
    _kHorizontalBarItemMargin = 4;
    
    _leftDecimalCount = 0;
    _rightDecimalCount = 0;
    
    _yAxisLeftTitleType = ChartViewTitleDescType_Right;
    _yAxisRightTitleType = ChartViewTitleDescType_Left;
}

@end
