//
//  HDCallEnum.h
//  helpdesk_sdk
//
//  Created by afanda on 3/15/17.
//  Copyright © 2017 hyphenate. All rights reserved.
//

#ifndef HDCallEnum_h
#define HDCallEnum_h


#ifndef H_SCALEASPECT_DEFINE
#define H_SCALEASPECT_DEFINE
/*!
 *  \~chinese
 *  视频通话页面缩放方式
 *
 *  \~english
 *  Video view scale mode
 */
typedef enum{
    HDCallViewScaleModeAspectFit = 0,   /*! \~chinese 按比例缩放 \~english Aspect fit */
    HDCallViewScaleModeAspectFill = 1,  /*! \~chinese 全屏 \~english Aspect fill */
}HDCallViewScaleMode;
#endif



typedef enum{
    HDMediaNoticeNone = 0,
    HDMediaNoticeStats = 100,
    HDMediaNoticeDisconn = 120,
    HDMediaNoticeReconn = 121,
    HDMediaNoticePoorQuality = 122,
    HDMediaNoticePublishSetup = 123,
    HDMediaNoticeSubscriptionSetup = 124,
    HDMediaNoticeTakePicture = 125,
    HDMediaNoticeCustomMsg = 126,
    HDMediaNoticeOpenCameraFail = 201,
    HDMediaNoticeOpenMicFail = 202,
    HDMediaNoticeTakePictureFail = 203,
}HDMediaNoticeCode;



#endif /* HDCallEnum_h */
