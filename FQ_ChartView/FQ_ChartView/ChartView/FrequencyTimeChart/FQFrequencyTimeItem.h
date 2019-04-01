//
//  FQFrequencyTimeItem.h
//  FQ_ChartView
//
//  Created by 范奇 on 2019/4/1.
//  Copyright © 2019 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FQFrequencyTimeItem : NSObject


/**
 @[[开始值,结束值],[开始值,结束值]]数组
 */
@property (nonatomic, strong) NSArray * dataItemArr ;

/**
 当前横条的渐变色
 */
@property (nonatomic, strong) NSArray * itemColors ;



@end

