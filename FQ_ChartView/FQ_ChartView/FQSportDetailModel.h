//
//  FQSportDetailModel.h
//  FQ_ChartView
//
//  Created by fanqi on 2018/12/5.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SportDetailItemType) {
    SportDetailItemType_LapTime = 0, //计圈时间
    SportDetailItemType_Pace ,   //配速
    SportDetailItemType_Speed ,   //速度
    SportDetailItemType_Heartrate ,   //心率
    SportDetailItemType_StepFreq,//步频
    SportDetailItemType_SteppedFreq, //踏频
    SportDetailItemType_Altitude, //海拔高度
    SportDetailItemType_Swolf,     //swolf
    SportDetailItemType_StrokeFreq,     //划次
    SportDetailItemType_HeartrateRange, //心率区间
    SportDetailItemType_ExerciseEvaluation,       //运动评价
};

@interface FQSportDetailModel : NSObject //举例:跑步




@end
