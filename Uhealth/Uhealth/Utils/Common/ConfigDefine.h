//
//  ConfigDefine.h
//  EasyTrade
//
//  Created by smy on 2017/12/1.
//  Copyright © 2017年 Rohon. All rights reserved.
//

#ifndef ConfigDefine_h
#define ConfigDefine_h
//项目相关宏定义

#pragma mark - ——————— 服务器地址 ————————
#define SERVER_ENVIRONMENT kProduction

//#define ZPBaseUrl @"http://121.43.168.51" //外
#define ZPBaseUrl @"https://app.uhealth-online.com.cn" //正式
//#define ZPBaseUrl @"http://192.168.8.12:8000" //许
//#define ZPBaseUrl @"http://192.168.8.10:8100" //韩
//#define ZPBaseUrl @"http://192.168.8.18:8000" //孙
//#define ZPBaseUrl @"http://192.168.8.20" //测试服务器

#define kProduction @"ws://139.224.229.253:19939"
#define kTest @"ws://192.168.1.49:19839"
#define kDevelopment @"ws://210.22.96.58:19939"
#define ktmp @"ws://192.168.1.70:19839"


#define kAppStoreUrl @""
#define kAppStoreIdentifier @""
#define kQQAppId @"1105367077"
#define kWXAppId @"wx49e16ef4de34d773"
#define kWXSecret @"16faf1cde163fccba0c370e381d7a652"
#define PRODUCT_VERSION     [[[NSBundle mainBundle] infoDictionary] valueForKey:@"CFBundleShortVersionString"]
#define AppStoreUrl @"https://itunes.apple.com/cn/app/id1269420620?mt=8"

#pragma mark - ——————— 三方服务的appKey ————————
//云信
#define NIMSDKAppKey @"6cf9eca3eba3c0382442f8369c61bc7f"
//极光推送 58365b001ae9677266a63d38
#define JpushAppKey @"fa5bbaedaffe91b3d87da64f"
#define WXPayKey @"wx634dda8b0c52bfd2"

#define UMKey @"5acc5464f29d9865be000246"
#define UMAppSecret @"55816a116999881f02c4a94fea7cccb6"

#define BuglyAppId @"8d97d4a1e2"

//温馨家园 的banner url
#define bannerUrl @"http://u4078151.viewer.maka.im/k/L37PQP7N?from=singlemessage&isappinstalled=0"
//39健康的url
#define healthUrl @"https://wapyyk.39.net/page/html5/quest/questlist_uhealth.jsp"

#pragma mark - ——————— 颜色相关 ————————
//命名时以color结尾，使用时可以输入kcolor直接找到
//主背景色
#define KBackgroundColor UIColorFromRGB(0x212532)
//nav背景色
#define KNavBackgroundColor UIColorFromRGB(0xffffff)
//tabbar字体颜色
#define KTbarColor UIColorFromRGB(0x666666)
//非主力合约色
#define KCommonSymbolColor UIColorFromRGB(0x323749)
//控制器背景色
#define KControlColor UIColorFromRGB(0xf2f2f2)
//常规蓝色
#define KCommonBlue UIColorFromRGB(0x4EB2FF)
//常规灰色170 170 170
#define KCommonGray UIColorFromRGB(0xaaaaaa)
//常规黑色74 74 74
#define KCommonBlack UIColorFromRGB(0x4A4A4A)
//常规绿色 跌
#define KCommonGreen UIColorFromRGB(0x7ed321)
//常规红色 涨
#define KCommonRed UIColorFromRGB(0xff4343)
//常规黄色
#define KCommonYellow UIColorFromRGB(0xf5a623)
//常规白色
#define KCommonWhite UIColorFromRGB(0xffffff)
//交易界面的黑色分割线
#define KCommonBlackLine UIColorFromRGB(0x1f222d)

//登录页面--------输入框边框颜色
#define ZPLoginTextFieldBorderColor RGBA(0,144,255,0.32)
#define ZPLoginBlueColor RGB(90,174,255)
#define ZPLoginOrangeColor RGB(255,131,77)

//注册页面
#define ZPRegisterLayerColor RGB(78,178,255)

//订单页面--------确认 框边框颜色
#define ZPMyOrderBorderColor RGB(255,158,33)
//删除边框的颜色
#define ZPMyOrderDeleteBorderColor RGB(170,170,170)
//详情 左label 字体颜色
#define ZPMyOrderDetailFontColor RGB(74,74,74)
//详情 右label 字体颜色
#define ZPMyOrderDetailValueFontColor RGB(78,178,255)

#define ZPPFSCRegular @"PingFangSC-Regular"
#define ZPPFSCMedium @"PingFangSC-Medium"
#define ZPPFSCLight @"PingFangSC-Light"

#pragma mark - ——————— 字号相关 ————————
#define SYS_FONT(x) [UIFont systemFontOfSize:x]
//integer转换为string
#define String_Integer(value) [NSString stringWithFormat:@"%ld",value]

#pragma mark - 公共描述文字
#define kErrorSocketDisconnect @"当前网络状况不佳，请稍后重试"

#pragma mark - NotificationName
#define kNotificationSmokeSel @"kNotificationSmokeSel"
#define kNotificationDrinkSel @"kNotificationDrinkSel"
#define kNotificationSmokeResult @"kNotificationSmokeResult"
#define kNotificationDrinkResult @"kNotificationDrinkResult"

#define kNotificationSendResult @"kNotificationSendResult"
#define KNotificationTimeOut @"KNotificationTimeOut"
#define KNotificationTimeEnd @"KNotificationTimeEnd"

#define kNotificationNeedSignIn @"kNotificationNeedSignIn"
#define kNotificationWXResp @"kNotificationWXResp"
#define kNotificationAliPayResp @"kNotificationAliPayResp"
#define kNotificationLoginSuccess @"kNotificationLoginSuccess"
#define kNotificationLogoutSuccess @"kNotificationLogoutSuccess"
#define kNotificationExchangesPrepared @"kNotificationExchangesPrepared"
#define kNotificationSymbolPrepared @"kNotificationSymbolPrepared"
#define kNotificationSymbolFail @"kNotificationSymbolFail"

// 1物理像素的pt值，常用于画水平或垂直分割线，iOS7下一律为0.5
#define ONE_PIXEL 1.0f/([[UIScreen mainScreen] respondsToSelector:@selector(nativeScale)] ? [UIScreen mainScreen].nativeScale : 2);

//UserDefaults存储的key值
//验证码绑定的字符串
#define keyOfSmsRes @"keyOfSmsRes"

//登录用户信息
#define keyOfToken @"keyOfToken"
#define keyOfLoginType @"keyOfLoginType"
#define keyOfUserId @"keyOfUserId"
#define keyOfUserName @"keyOfUserName"
#define keyOfOpenId @"keyOfOpenId"
#define keyOfUserPhone @"keyOfUserPhone"
#define keyOfUserPassword @"keyOfUserPassword"
#define keyOfRSAPrivateKey @"keyOfRSAPrivateKey"//rsa私钥
#define keyOfSymbolUrl @"keyOfSymbolUrl"//合约表下载地址
#define keyOfSymolUpdateTime @"keyOfSymolUpdateTime"//合约表更新时间
#define keyOfSymbolTable @"keyOfSymbolTable"//下载到的原始合约表
#define keyOfOptionSymbols @"keyOfOptionSymbols"//自选合约
/** 用户的信息的保存地址 */
#define ZPUserInfoPATH [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/user.data"]]
#endif /* ConfigDefine_h */
