//
//  NetApiManager.h
//  RedPacket
//
//  Created by peng on 2018/6/8.
//  Copyright © 2018年 peng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"

typedef void(^response)(BOOL isSuccess,id responseObject);
typedef void (^UploadImageTempBlock)(BOOL sussess,NSMutableArray *array);

@interface NetApiManager : NSObject
{
 }
#pragma mark - 获取网络状态
//获取网络状态
+ (BOOL) getNetStaus;

/***********************************************************
 *
 * 请求示例
 *
 //请求首页数据 GET
 + (void)requestHomePageDataWithParam:(NSDictionary *)dict
 withHandle:(response)responseHandle;
 
 //首页-获取健身房相关课程 POST
 + (void)requestGetgymsclWithParam:(NSDictionary *)paramer
 withHandle:(response)responseHandle;
 
 //修改头像  RequestTypeUploadSingleImage 单张图片上传
 + (void)avartarChangeWithParam:(NSDictionary *)paramer
 singleImage:(UIImage *)image
 singleImageName:(NSString *)imageName
 withHandle:(response)responseHandle;
 
 //发布帖子 RequestTypeUploadImagesArray 多张图片上传
 + (void)requestPublishArticle:(NSDictionary*)parameters
 imageArray:(NSArray*)imageArray
 imageNameArray:(NSArray*)imageNameArray
 response:(response)response;
 ***********************************************************/



+(void)uploadImages:(NSArray *)images atIndex:(NSInteger)index token:(NSString *)token uploadManager:(QNUploadManager *)uploadManager keys:(NSMutableArray *)keys andBlock:(UploadImageTempBlock)BlockInfo;

#pragma mark - 首页
/************************************************************/
//*  首页
/************************************************************/
//首页列表
+ (void)requestWorklistWithParam:(id)paramer
                      withHandle:(response)responseHandle;
//查询所有行业/工种
+ (void)requestMechanismlistWithParam:(id)paramer
                           withHandle:(response)responseHandle;
//招聘详情
+ (void)requestWorkDetailWithParam:(id)paramer
                        withHandle:(response)responseHandle;
//收藏接口
+ (void)requestSetCollectionWithParam:(id)paramer
                           withHandle:(response)responseHandle
                       IsShowActivity:(BOOL) IsShow;
//查询是否报名/收藏公司/实名认证
+ (void)requestIsApplyOrIsCollectionWithParam:(id)paramer
                                   withHandle:(response)responseHandle;
//入职报名
+ (void)requestEntryApplyWithUrl:(NSString *)urlString
                       withParam:(id)paramer
                      withHandle:(response)responseHandle;
//取消报名
+ (void)requestCancleApplyWithUrl:(NSString *)urlString
                        withParam:(id)paramer
                       withHandle:(response)responseHandle;
//查询面试预约列表
+ (void)requestWorkorderlistWithParam:(id)paramer
                           withHandle:(response)responseHandle;
//删除面试预约
+ (void)requestDelWorkorderWithParam:(id)paramer
                          withHandle:(response)responseHandle;
#pragma mark - 资讯
/************************************************************/
//*  资讯
/************************************************************/
//资讯分类
+ (void)requestLabellistWithParam:(id)paramer
                       withHandle:(response)responseHandle;
//资讯列表
+ (void)requestEssaylistWithParam:(id)paramer
                       withHandle:(response)responseHandle;
//资讯详情
+ (void)requestEssayWithParam:(id)paramer
                   withHandle:(response)responseHandle;
//新闻推荐列表
+ (void)requestEssay_LabelWithParam:(id)paramer
                         withHandle:(response)responseHandle;
//增加新闻浏览量
+ (void)requestSetEssayViewWithParam:(id)paramer
                          withHandle:(response)responseHandle;
//获取评论列表
+ (void)requestCommentListWithParam:(id)paramer
                         withHandle:(response)responseHandle;
//点赞（取消）
+ (void)requestSocialSetlikeWithParam:(id)paramer
                           withHandle:(response)responseHandle
                       IsShowActiviTy:(BOOL) IsShow;
//添加评论
+ (void)requestCommentAddcommentWithParam:(id)paramer
                               withHandle:(response)responseHandle;
#pragma mark - 圈子
/************************************************************/
//*  圈子
/************************************************************/
//查看圈子种类
+ (void)requestMoodTypeWithParam:(id)paramer
                      withHandle:(response)responseHandle;
//查看圈子列表
+ (void)requestMoodListWithParam:(id)paramer
                      withHandle:(response)responseHandle;
//获取圈子详情
+ (void)requestGetMoodWithParam:(id)paramer
                     withHandle:(response)responseHandle;
//增加圈子浏览量
+ (void)requestSetMoodViewWithParam:(id)paramer
                         withHandle:(response)responseHandle;
//添加圈子
+ (void)requestAddMoodWithParam:(id)paramer
                     withHandle:(response)responseHandle;
//删除圈子
+ (void)requestDeleteMoodWithParam:(id)paramer
                        withHandle:(response)responseHandle;
// 多张图片上传
+ (void)requestPublishArticle:(id)parameters
                   imageArray:(NSArray*)imageArray
               imageNameArray:(NSArray*)imageNameArray
                     response:(response)response;
// 单张图片上传
+ (void)avartarChangeWithParamDict:(id)paramer
                       singleImage:(UIImage *)image
                   singleImageName:(NSString *)imageName
                        withHandle:(response)responseHandle;

// 视频上传
+ (void)requestPublishVideo:(id)parameters
                   VideoUrl:(NSString *) VideoUrl
                   response:(response)response;

//人员关注
+ (void)requestSetUserConcernWithParam:(id)paramer
                            withHandle:(response)responseHandle;

#pragma mark - 登陆注册
/************************************************************/
//*  登陆注册
/************************************************************/
//登陆
+ (void)requestLoginWithParam:(id)paramer
                   withHandle:(response)responseHandle;
//退出登陆
+ (void)requestSignoutWithParam:(id)paramer
                     withHandle:(response)responseHandle;
//注册接口
+ (void)requestAddUserWithParam:(id)paramer
                     withHandle:(response)responseHandle;
//找回密码
+ (void)requestSetPswWithParam:(id)paramer
                    withHandle:(response)responseHandle;
//发送手机验证码
+ (void)requestSendCodeWithParam:(id)paramer
                      withHandle:(response)responseHandle;
//验证验证码及手机
+ (void)requestMateCodeWithParam:(id)paramer
                      withHandle:(response)responseHandle;
//修改密码
+ (void)requestModifyPswWithParam:(id)paramer
                       withHandle:(response)responseHandle;
//修改手机号
//修改手机号
+ (void)requestUpdateUsertelWithParam:(NSString *)appendURLString
                            WithParam:(id)paramer
                           withHandle:(response)responseHandle;
#pragma mark - 消息中心
/************************************************************/
//*  消息中心
/************************************************************/
+ (void)requestQueryUnreadNumWithParam:(id)paramer
                            withHandle:(response)responseHandle;
//查询消息列表
+ (void)requestQueryInfolistWithParam:(id)paramer
                           withHandle:(response)responseHandle;
//删除消息
+ (void)requestDelInfosWithParam:(id)paramer
                      withHandle:(response)responseHandle;
//消息详情
+ (void)requestQueryInfodetailWithParam:(id)paramer
                             withHandle:(response)responseHandle;

//接受或者拒绝店主邀请A
+ (void)requestQueryAccept_invite:(id)paramer
                       withHandle:(response)responseHandle;

#pragma mark - 我的
/************************************************************/
//*  我的
/************************************************************/
//查询用户个人资料
+ (void)requestUserMaterialWithParam:(id)paramer
                          withHandle:(response)responseHandle;
//查询用户个人资料
+ (void)requestUserMaterialSelectMechanism:(id)paramer
                                withHandle:(response)responseHandle;
//查询当天是否签到
+ (void)requestSelectCurIsSignWithParam:(id)paramer
                             withHandle:(response)responseHandle;
//查询是否允许借支
+ (void)requestQueryIsLendWithParam:(id)paramer
                         withHandle:(response)responseHandle;
//借支记录
+ (void)requestQueryCheckrecordWithParam:(id)paramer
                              withHandle:(response)responseHandle;
//借支
+ (void)requestAddLendmoneyWithParam:(id)paramer
                          withHandle:(response)responseHandle;
//离职通知
+ (void)requestGetNoticeWithParam:(id)paramer
                       withHandle:(response)responseHandle;
//申请离职,发送离职通知
+ (void)requestAddDimissionWithParam:(id)paramer
                          withHandle:(response)responseHandle;

//邀请奖励
+ (void)requestGetRegisterWithParam:(id)paramer
                         withHandle:(response)responseHandle;
//邀请奖励详情
+ (void)requestGetOnWorkWithParam:(id)paramer
                       withHandle:(response)responseHandle;
//邀请注册奖励列表添加备注
+ (void)requestUpdateRelationReg:(id)paramer
                       URLString:(NSString *)URLString
                      withHandle:(response)responseHandle;
//查询绑定银行卡
+ (void)requestSelectBindbankcardWithParam:(id)paramer
                                withHandle:(response)responseHandle;
//绑定/变更银行卡
+ (void)requestBindunbindBankcardWithParam:(id)paramer
                                withHandle:(response)responseHandle;
//提现密码验证
+ (void)requestUpdateDrawpwdWithParam:(id)paramer
                           withHandle:(response)responseHandle;
// 查询身份证号是否被占用
+ (void)requestCardNOoccupy:(id)paramer
                 withHandle:(response)responseHandle;
//我的客服
+ (void)requestQueryProblemWithParam:(id)paramer
                          withHandle:(response)responseHandle;
//查询问题
+ (void)requestQueryProblemDetailWithParam:(id)paramer
                                withHandle:(response)responseHandle;
//问题关键字搜索
+ (void)requestQueryProblemDetailWithParamKey:(id)paramer
                                   withHandle:(response)responseHandle;
//招聘收藏
+ (void)requestGetWorkCollectionWithParam:(id)paramer
                               withHandle:(response)responseHandle;
//资讯收藏
+ (void)requestGetEssayCollectionWithParam:(id)paramer
                                withHandle:(response)responseHandle;
//批量删除收藏信息
+ (void)requestDeleteCollectionWithParam:(id)paramer
                              withHandle:(response)responseHandle;
//意见反馈
+ (void)requestProblemAddWithParam:(id)paramer
                        withHandle:(response)responseHandle;
//查询签到
+ (void)requestSelectSignInfoWithParam:(id)paramer
                            withHandle:(response)responseHandle;
//签到
+ (void)requestUserSignAddWithParam:(id)paramer
                         withHandle:(response)responseHandle;
//修改用户个人资料
+ (void)requestSaveOrUpdateWithParam:(NSString *)urlString
                           withParam:(id)paramer
                          withHandle:(response)responseHandle;
//账单
+ (void)requestQueryBillrecordWithParam:(id)paramer
                             withHandle:(response)responseHandle;
//提现
+ (void)requestQueryBankcardwithDrawWithParam:(id)paramer
                                   withHandle:(response)responseHandle;

//提现余额
+ (void)requestQueryBankcardwithDrawDepositWithParam:(NSString *)appendURLString
                                           WithParam:(id)paramer
                                          withHandle:(response)responseHandle;
#pragma mark - 企业点评
/************************************************************/
//*  企业点评
/************************************************************/
//查询所有企业
+ (void)requestMechanismcommentMechanismlistWithParam:(id)paramer
                                           withHandle:(response)responseHandle;
//企业点评详情
+ (void)requestMechanismcommentDeatilWithParam:(id)paramer
                                    withHandle:(response)responseHandle;
//查询用户就过职、曾经就职的企业
+ (void)requestCheckIsmechanismWithParam:(id)paramer
                              withHandle:(response)responseHandle;
#pragma mark - 工时记录
/************************************************************/
//*  工时记录
/************************************************************/
//记录/修改工时
+ (void)requestSaveorupdateWorkhourWithParam:(id)paramer
                                  withHandle:(response)responseHandle;
//查询工时记录详情
+ (void)requestSelectWorkhourWithParam:(id)paramer
                            withHandle:(response)responseHandle;
//查询当天工时记录
+ (void)requestQueryCurrecordWithParam:(id)paramer
                            withHandle:(response)responseHandle;
//查询已记录工时
+ (void)requestQueryNormalrecordWithParam:(id)paramer
                               withHandle:(response)responseHandle;
//删除加班记录
+ (void)requestDeleteAddtimeWithParam:(id)paramer
                           withHandle:(response)responseHandle;
//记录补贴扣款
+ (void)requestAddWorkrecordWithParam:(id)paramer
                           withHandle:(response)responseHandle;
#pragma mark - 工资明细
/************************************************************/
//*  工资明细
/************************************************************/
//查询工资明细
+ (void)requestQuerySalarylistWithParam:(id)paramer
                             withHandle:(response)responseHandle;
//查询工资明细详情
+ (void)requestQuerySalarydetailWithParam:(id)paramer
                               withHandle:(response)responseHandle;
//晒工资
+ (void)requestQueryBusinessWageParam:(id)paramer
                           withHandle:(response)responseHandle;
//查询账单详情及提现进度
+ (void)requestQueryBankcardwithWithdrawreCordWithParam:(NSString *)appendURLString
                                              WithParam:(id)paramer
                                             withHandle:(response)responseHandle;
//查询招聘列表及详情
+ (void)requestQueryWorkList:(id)paramer
                  withHandle:(response)responseHandle;

//更新招聘信息
+ (void)requestQueryUpdateWorkList:(id)paramer
                        withHandle:(response)responseHandle;

//查询借支列表
+ (void)requestQueryLandMoneyList:(id)paramer
                       withHandle:(response)responseHandle;

//审核借支状态
+ (void)requestQueryUpdateLandMoneyList:(id)paramer
                             withHandle:(response)responseHandle;

//借支详情
+ (void)requestQueryUpdateLandMoneyDetail:(id)paramer
                               withHandle:(response)responseHandle;
//入职员工信息列表
+ (void)requestQueryWorkOrderList:(id)paramer
                       withHandle:(response)responseHandle;

//修改面试预约状态
+ (void)requestQueryUodateWorkOrderList:(id)paramer
                             withHandle:(response)responseHandle;

//面试通过
+ (void)requestQueryupdate_interview:(id)paramer
                          withHandle:(response)responseHandle;

//设置入职时间
+ (void)requestQueryUodateWorkDate:(id)paramer
                        withHandle:(response)responseHandle;

//查询企业员工管理列表
+ (void)requestQueryCompanyStaff:(id)paramer
                      withHandle:(response)responseHandle;
//查询企业员工管理详细列表
+ (void)requestQueryUserRegistration:(id)paramer
                          withHandle:(response)responseHandle;
//更新查询企业员工管理详细列表
+ (void)requestQueryUpdateUserRegistration:(id)paramer
                                withHandle:(response)responseHandle;

//查询店主下劳务工信息
+ (void)requestQuerylabourlist:(id)paramer
                    withHandle:(response)responseHandle;
//查询店员下劳务工信息
+ (void)requestQueryassistantlabourlist:(id)paramer
                             withHandle:(response)responseHandle;
//查询门店信息
+ (void)requestQueryshopkeeperinfo:(id)paramer
                        withHandle:(response)responseHandle;
//查询门店信息  店员
+ (void)requestQueryassistantshopkeeperinfo:(id)paramer
                                 withHandle:(response)responseHandle;

//查询门店收支明细
+ (void)requestQueryshopincome:(id)paramer
                    withHandle:(response)responseHandle;

//查询门店下员工信息
+ (void)requestQueryshopuserlist:(id)paramer
                    withHandle:(response)responseHandle;

//辞退店员
+ (void)requestQueryshopdismiss:(id)paramer
                     withHandle:(response)responseHandle;
//邀请店员
+ (void)requestQueryinviteshopUser:(id)paramer
                        withHandle:(response)responseHandle;

//查询门店业绩详情
+ (void)requestQueryBonusDetail:(id)paramer
                     withHandle:(response)responseHandle;

//设置返费
+ (void)requestQueryadd_overseer:(id)paramer
                      withHandle:(response)responseHandle;

//设置上架/下架
+ (void)requestQueryset_workwatchstatus:(id)paramer
                             withHandle:(response)responseHandle;

//提醒店主设置返费
+ (void)requestQueryremind_shopkeeper:(id)paramer
                           withHandle:(response)responseHandle;

//查询用户个人资料
+ (void)requestQueryUserMaterialSelect:(id)paramer
                            withHandle:(response)responseHandle;

//信息举报接口
+ (void)requestQueryReportAdd:(id)paramer
                   withHandle:(response)responseHandle;

//屏蔽用户  传参identity,type(1屏蔽2取消屏蔽)
+ (void)requestQueryDefriendPullBlack:(id)paramer
                           withHandle:(response)responseHandle;

//获取屏蔽用户列表
+ (void)requestQueryDefriendPullBlackUserList:(id)paramer
                                   withHandle:(response)responseHandle;
//获取系统版本号
+ (void)requestQueryDownload:(id)paramer
                  withHandle:(response)responseHandle;
//获取视频列表,
+ (void)requestQueryGetVideoList:(id)paramer
                      withHandle:(response)responseHandle;
//获取视频浏览量
+ (void)requestQuerySetVideoView:(id)paramer
                      withHandle:(response)responseHandle;
//获取视频
+ (void)requestQueryGetVideo:(id)paramer
                  withHandle:(response)responseHandle;
//获取视频分类
+ (void)requestQueryGetVideoType:(id)paramer
                      withHandle:(response)responseHandle;
//视频收藏列表
+ (void)requestQueryGetVideoCollection:(id)paramer
                            withHandle:(response)responseHandle;
//获取红包
+ (void)requestQueryGetRedPacket:(id)paramer
                      withHandle:(response)responseHandle;
//获取时间
+ (void)requestQueryGetRedPacketStatus:(id)paramer
                            withHandle:(response)responseHandle;
//查询是否第一次微信登入
+ (void)requestQueryWXUserStatus:(id)paramer
                      withHandle:(response)responseHandle;
//微信手机绑定
+ (void)requestQueryWXSetPhone:(id)paramer
                    withHandle:(response)responseHandle了;
//查询公司列表（h5）
+ (void)requestQueryLendMoneyMechanism:(id)paramer
                            withHandle:(response)responseHandle;
//查询是否允许借支（h5）
+ (void)requestQueryLendApi:(id)paramer
                 withHandle:(response)responseHandle;

//添加借支（h5）
+ (void)requestQueryAddLendApi:(NSString *)urlString
                     withParam:(id)paramer
                    withHandle:(response)responseHandle;

//是否需要驻厂电话审核。  1 为 需要   2为不需要驻厂电话号码
+ (void)requestQueryLendMoneyType:(id)paramer
                       withHandle:(response)responseHandle;

//获取点赞列表
+ (void)requestQueryPraiseList:(id)paramer
                    withHandle:(response)responseHandle;
//查询驻厂管理的厂列表
+ (void)requestQueryTeacherMechanism:(id)paramer
                          withHandle:(response)responseHandle;
//获取活动列表
+ (void)requestQueryActivityList:(id)paramer
                      withHandle:(response)responseHandle;
//获取广告弹框
+ (void)requestQueryActivityadvert:(id)paramer
                        withHandle:(response)responseHandle;
//更新，修改企业底薪加班倍数
+ (void)requestQueryUpdateBaseSalary:(id)paramer
                          withHandle:(response)responseHandle;

//获取加班倍数及金额，以及小时工单价列表
+ (void)requestQueryGetYsetMulList:(id)paramer
                        withHandle:(response)responseHandle;
//添加、更新记加班记录
+ (void)requestQueryGetOvertime:(id)paramer
                     withHandle:(response)responseHandle;
//添加修改删除记账本
+ (void)requestQueryUpdateAccount:(id)paramer
                       withHandle:(response)responseHandle;
//查询具体某一天记加班详情
+ (void)requestQueryGetOvertimeRecordBy:(id)paramer
                             withHandle:(response)responseHandle;
//添加更新考勤周期内月工资详情
+ (void)requestQueryGetOvertimeAddMonthWage:(id)paramer
                                 withHandle:(response)responseHandle;
//首页展示
+ (void)requestQueryGetOvertimeGetMonthWage:(id)paramer
                                 withHandle:(response)responseHandle;
//首页获取记账本与工作记录
+ (void)requestQueryGetOvertimeAccount:(id)paramer
                            withHandle:(response)responseHandle;
//查询记加班时长，请假时长详情列表
+ (void)requestQueryGetOvertimeGetDetails:(id)paramer
                               withHandle:(response)responseHandle;
//查询考勤周期内消费金额分类统计
+ (void)requestQueryGetAccountPrice:(id)paramer
                         withHandle:(response)responseHandle;
//查询消费详情列表
+ (void)requestQueryGetAccountList:(id)paramer
                        withHandle:(response)responseHandle;
//查询月工资详情
+ (void)requestQueryGetMonthWageDetail:(id)paramer
                            withHandle:(response)responseHandle;
//月综合工资详情-工时列表
+ (void)requestQueryGetHoursWorkList:(id)paramer
                          withHandle:(response)responseHandle;

//查询用户设置的企业底薪
+ (void)requestQueryGetHoursWorkBaseSalary:(id)paramer
                                withHandle:(response)responseHandle;
//查询用户考勤周期和正常工作日
+ (void)requestQueryGetHoursWorkYset:(id)paramer
                          withHandle:(response)responseHandle;

//添加修改用户考勤周期和正常工作日
+ (void)requestQuerySetHoursWorkYset:(id)paramer
                          withHandle:(response)responseHandle;
//记加班日历列表查看
+ (void)requestQueryGetCalenderList:(id)paramer
                         withHandle:(response)responseHandle;
//月综合详情中-查询班次补贴金额和班次天数
+ (void)requestQueryGetSubsidy:(id)paramer
                    withHandle:(response)responseHandle;
//记加班初始化用户设置
+ (void)requestQueryYsetInit:(id)paramer
                  withHandle:(response)responseHandle;
//综合记加班-查询月工作小时数
+ (void)requestQueryGetMonthHours:(id)paramer
                       withHandle:(response)responseHandle;

//综合记加班-添加更新月工作小时数
+ (void)requestQueryUpdateMonthHours:(id)paramer
                          withHandle:(response)responseHandle;
//查询小时工单价列表
+ (void)requestQueryGetPriceName:(id)paramer
                      withHandle:(response)responseHandle;

//添加更新小时工单价列表
+ (void)requestQueryUpdatePriceName:(id)paramer
                         withHandle:(response)responseHandle;
//查询计件中用户设置的产品列表
+ (void)requestQueryGetProList:(id)paramer
                    withHandle:(response)responseHandle;

//计件中添加更新删除产品信息
+ (void)requestQueryUpdateProList:(id)paramer
                       withHandle:(response)responseHandle;

//计件模式-添加修改删除计件记录
+ (void)requestQueryUpdateProRecord:(id)paramer
                         withHandle:(response)responseHandle;
//计件模式计件详情
+ (void)requestQueryGetProRecordList:(id)paramer
                          withHandle:(response)responseHandle;

//获取百度图像识别token
+ (void)requestQueryGetBiaduBankAccessToken:(id)paramer
                                 withHandle:(response)responseHandle;

//获取百度图像识别
+ (void)requestQueryGetBiaduUserBankScan:(id)paramer
                               URLString:(NSString *)URLString
                              withHandle:(response)responseHandle;

//删除评论信息
+ (void)requestQueryDeleteComment:(id)paramer
                        URLString:(NSString *)URLString
                       withHandle:(response)responseHandle;
//粉丝、关注列表
+ (void)requestQueryUserConcernList:(id)paramer
                         withHandle:(response)responseHandle;
//招聘详情中推荐招聘信息接口
+ (void)requestQueryWorkRecommend:(id)paramer
                       withHandle:(response)responseHandle;

//查询拒绝申请借支天数  get请求
+ (void)requestQueryGetRefuseLendDay:(id)paramer
                          withHandle:(response)responseHandle;
//查询幸运球开奖记录列表
+ (void)requestQueryGetPrizeRecordList:(id)paramer
                            withHandle:(response)responseHandle;
//一键清空圈子消息
+ (void)requestQueryDeleteInfoMood:(id)paramer
                        withHandle:(response)responseHandle;
//查询密保问题列表  post 请求  无参数
+ (void)requestQueryGetUserProdlemList:(id)paramer
                            withHandle:(response)responseHandle;
//添加更新密保问题
+ (void)requestQueryUpdateUserProdlemList:(id)paramer
                               withHandle:(response)responseHandle;
//校验密保正确性   post请求  参数
+ (void)requestQueryVerifyUserProdlemList:(id)paramer
                               withHandle:(response)responseHandle;
//查询客服电话 get请求
+ (void)requestQueryGetCustomerTel:(id)paramer
                        withHandle:(response)responseHandle;

//工资领取消息
+ (void)requestQueryGetBillRecordList:(id)paramer
                           withHandle:(response)responseHandle;

//获取企业岗位
+ (void)requestQueryGetMechanismTypeList:(id)paramer
                              withHandle:(response)responseHandle;


//获取电话号码
+ (void)requestQueryGetUserConcernTel:(id)paramer
                           withHandle:(response)responseHandle;
//获取入职评价列表
+ (void)requestQueryGetWorkOrderRemarkList:(id)paramer
                                withHandle:(response)responseHandle;
//首页获取弹框入职评价
+ (void)requestQueryGetWorkOrderRemarkMain:(id)paramer
                                withHandle:(response)responseHandle;

@end




