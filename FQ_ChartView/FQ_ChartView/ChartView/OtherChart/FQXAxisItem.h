//
//  FQBarItem.h
//  JTFQ_TestCharts
//
//  Created by fanqi on 2018/11/12.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FQXAxisItem : NSObject

@property(nonatomic, strong) NSNumber* dataNumber; //x轴对应的值
@property(nonatomic, strong) NSNumber* dataValue;  //y轴对应的值

/**
 设置数据item
 
 @param dataNumber (NSNumber *)dataNumber
 @param dataValue (NSNumber *)dataValue
 @return instancetype
 */
- (instancetype)initWithDataNumber:(NSNumber*)dataNumber
                         dataValue:(NSNumber*)dataValue;

@end

