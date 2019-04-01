//
//  FQBothwayBarElement.h
//  FQ_ChartView
//
//  Created by 范奇 on 2019/3/28.
//  Copyright © 2019 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FQBothwayBarItem.h"

@interface FQBothwayBarElement : NSObject

/**
 源数据. - 主要是使用这个
 */
@property (nonatomic, strong) NSArray<FQBothwayBarItem *> *orginDatas;

@property (nonatomic, strong) UIFont * dateTextFont ;

@property (nonatomic, strong) UIColor * dateTextColor ;

@property (nonatomic, strong) UIFont * leftDataTextFont ;

@property (nonatomic, strong) UIColor * leftDataTextColor ;

@property (nonatomic, strong) UIFont * rightDataTextFont ;

@property (nonatomic, strong) UIColor * rightDataTextColor ;

@property (nonatomic, strong) NSArray * leftBarColors ;

@property (nonatomic, strong) NSArray * rightBarColors ;

@property (nonatomic, strong) UIColor * descTextColor ;

@property (nonatomic, strong) UIFont * descTextFont;

/**
 左侧描述
 */
@property (nonatomic, copy) NSString * leftDescStr ;

/**
 右侧描述
 */
@property (nonatomic, copy) NSString * rightDescStr ;

/**
 双向图表顶部间距.默认为20
 */
@property (nonatomic, assign) CGFloat bothwayTopMargin;

/**
 双向中间视图的宽度.默认为28
 */
@property (nonatomic, assign) CGFloat bothwayMidContentW;

/**
 双向柱状的高度.默认为6
 */
@property (nonatomic, assign) CGFloat bothwayBarH;

/**
 双向柱状间距.默认为 14
 */
@property (nonatomic, assign) CGFloat bothwayBarMargin;

/**
 双向文本与柱状间距.默认为5
 */
@property (nonatomic, assign) CGFloat bothwayTextBarMargin;

/**
 双向柱状的左侧最大范围值与视图最左侧之间的间距.默认为52  |   -------,中间间隔
 */
@property (nonatomic, assign) CGFloat barLeftMargin;

/**
 双向柱状的右侧最大范围与视图最右侧之间的间距.默认为52    -------  |.
 */
@property (nonatomic, assign) CGFloat barRightMargin;

@end

