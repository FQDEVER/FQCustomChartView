//
//  FQSportDetailDataModel.h
//  FQ_ChartView
//
//  Created by fanqi on 2018/12/5.
//  Copyright © 2018年 fanqi. All rights reserved.
//

#import <Foundation/Foundation.h>

//运动类型
typedef enum : NSInteger{
    SocialSportType_Hiking = 0,         //徒步
    SocialSportType_Run,                //跑步
    SocialSportType_Ride,               //骑行
    SocialSportType_Mountain,           //爬山
    SocialSportType_InDoorSwim,         //泳池游泳
    SocialSportType_OutDoorSwim,        //室外游泳
    SocialSportType_Walking,            //健走
    SocialSportType_InDoorRun,          //室内跑
    SocialSportType_CrossCountry,       //越野跑
    SocialSportType_Marathon,           //马拉松
    SocialSportType_Triathlon,          //铁人三项
    SocialSportType_ArticleTitle = 1000,       //资讯标题-推荐
    SocialSportType_AllRecordTitle = 1001,       //全部纪录
}SocialSportType;



@interface FQSportDetailDataModel : NSObject

//根据传入的运动类型.
@property (nonatomic, assign) SocialSportType sportType;

//计圈数据
@property (nonatomic, copy) NSString *meterFlagStr; //多少m/圈.多少km/圈等

@property (nonatomic, copy) NSString *meterFlagTimeStr; //计圈的时间展示

//配速数据

//速度数据

//心率数据

//步频数据

//踏频数据

//海拔高度数据

//swolf数据

//划次数据

//心率区间

//运动评价

@end


//SportDetailItemType_LapTime = 0, //计圈时间
//SportDetailItemType_Pace ,   //配速
//SportDetailItemType_Speed ,   //速度
//SportDetailItemType_Heartrate ,   //心率
//SportDetailItemType_StepFreq,//步频
//SportDetailItemType_SteppedFreq, //踏频
//SportDetailItemType_Altitude, //海拔高度
//SportDetailItemType_Swolf,     //swolf
//SportDetailItemType_StrokeFreq,     //划次
//SportDetailItemType_HeartrateRange, //心率区间
//SportDetailItemType_ExerciseEvaluation,       //运动评价
