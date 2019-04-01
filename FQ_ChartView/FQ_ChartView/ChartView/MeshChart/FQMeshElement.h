//
//  FQMeshElement.h
//  FQ_ChartView
//
//  Created by 范奇 on 2019/3/27.
//  Copyright © 2019 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQMeshItem.h"

@interface FQMeshElement : NSObject

/**
 源数据. - 主要是使用这个
 */
@property (nonatomic, strong) NSArray<FQMeshItem *> *orginDatas;

/**
 昵称字体
 */
@property (nonatomic, strong) UIFont * nameFont ;

/**
 昵称字体颜色
 */
@property (nonatomic, strong) UIColor * nameColor ;

/**
 描述字体
 */
@property (nonatomic, strong) UIFont * descFont ;

/**
 描述字体颜色
 */
@property (nonatomic, strong) UIColor * descColor ;

/**
 数据字体
 */
@property (nonatomic, strong) UIFont * valueFont ;

/**
 数据字体颜色
 */
@property (nonatomic, strong) UIColor * valueColor ;

/**
 是否隐藏填充layer，默认NO
 */
@property (nonatomic, assign) BOOL fillLayerHidden;

/**
 填充layer的颜色，默认黑色，透明度0.2
 */
@property (nonatomic, strong) UIColor *fillLayerBackgroundColor;

/**
 填充边框的颜色.
 */
@property (nonatomic, strong) UIColor * fillLineColor ;

/**
 展示最大值.默认是从orginData中最大值.可自设定.自己设定登记更高
 */
@property (nonatomic, assign) CGFloat  maxValue ;

/**
 展示最小值.默认是从orginData中最小值.可自设定.自己设定登记更高
 */
@property (nonatomic, assign) CGFloat  minValue ;

/**
 边框线条总数.默认为5
 */
@property (nonatomic, assign) NSInteger borderLineCount;

/**
 最大半径是多少.默认为屏幕的0.25
 */
@property (nonatomic, assign) CGFloat maxRadius;

@end


