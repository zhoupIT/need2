//
//  MacroDefine.h
//  EasyTrade
//
//  Created by smy on 2017/12/1.
//  Copyright © 2017年 Rohon. All rights reserved.
//

#ifndef MacroDefine_h
#define MacroDefine_h
//系统相关宏定义

//系统版本号
#define iOS8           [[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0
#define iOS7           [[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0

//机型
#define IS_IPHONE4 (([[UIScreen mainScreen] bounds].size.height == 480) ? YES : NO)
#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height == 568) ? YES : NO)
#define IS_IPhone6 (([[UIScreen mainScreen] bounds].size.height == 667) ? YES : NO)
#define IS_IPhone6P (([[UIScreen mainScreen] bounds].size.height == 736) ? YES : NO)
#define IS_IPhoneX (([[UIScreen mainScreen] bounds].size.height == 812) ? YES : NO)

#pragma mark 系统相关
//获取屏幕 宽度、高度
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define kSafeAreaTopHeight (SCREEN_HEIGHT == 812.0 ? 88 : 64)
#define kSafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define ZPWidthScale (SCREEN_WIDTH / 375)
#define ZPHeightScale ((IS_IPhoneX ? 667 : SCREEN_HEIGHT) / 667)
#define ZPHeight(H) ((H) * ZPHeightScale)
#define ZPWidth(W) ((W) * ZPWidthScale)
//字体大小
#define ZPFont(x) [UIFont systemFontOfSize:(x) * ZPHeightScale]
#define ZPFontSize(x) (x) * ZPHeightScale

//应用程序Document目录
#define APP_DOC_PATH                    [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
//缓存目录
#define APP_CACHE_PATH                  [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"]
//应用里plist文件所在目录，可以自由定义
#define PLIST_DIR_PATH                  [APP_DOC_PATH stringByAppendingPathComponent:@"pList"]

//判断不是空字符串
#define ZPIsExist_String(_string) (_string != nil && _string.length != 0 && ![_string isEqualToString:@""])
//判断不是空数组
#define ZPIsExist_Array(_array) (_array.count > 0 && _array != nil)

#pragma mark -
#pragma mark 打印日志
//DEBUG  模式下打印日志,当前行
#ifdef DEBUG
#   define DLog(fmt, ...) XYZLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

#pragma mark -
#pragma mark 系统

//获取系统版本
#define IOS_VERSION_VALUE [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS_VERSION_STRING [[UIDevice currentDevice] systemVersion]

//计算当前文本的高度
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
#define MULTILINE_TEXTSIZE(text, font, maxSize) [text length] > 0 ? [text \
boundingRectWithSize:maxSize options:(NSStringDrawingUsesLineFragmentOrigin) \
attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
#else
#define MULTILINE_TEXTSIZE(text,font,maxSize) [text length] > 0 ? [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:NSLineBreakByCharWrapping] : CGSizeZero;
#endif

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//判断是否 Retina屏、设备是否%fhone 5、是否是iPad
#define isRetina ([[UIScreen mainScreen] scale] == 2.0 ? YES : NO)
#define iPhone5 (CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size))


//检查系统版本
#define IOS_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define IOS_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define IOS_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define IOS_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define IOS_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#pragma mark - 解析相关
#define ParseObject(obj, key)   ([obj valueForKey:key]==[NSNull null]?nil:[obj valueForKey:key])
#define ParseInteger(obj, key)  ([obj valueForKey:key]==[NSNull null]?0:[[obj valueForKey:key] integerValue])
#define ParseBool(obj, key)     ([obj valueForKey:key]==[NSNull null]?NO:[[obj valueForKey:key] boolValue])
#define ParseFloat(obj, key)    ([obj valueForKey:key]==[NSNull null]?0.0f:[[obj valueForKey:key] floatValue])
#define ParseLongLong(obj, key) ([obj valueForKey:key]==[NSNull null]?0.0f:[[obj valueForKey:key] longLongValue])
#define ParseObjectTo(obj, key) ([obj valueForKey:key]==[NSNull null]?@"":[obj valueForKey:key])

#pragma mark -
#pragma mark 图片

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

#pragma mark -
#pragma mark 颜色相关
// rgb颜色转换（16进制->10进制）
#define UIColorFromRBGString(rgbValue)  [Utils colorWithHexString:rgbValue]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

#pragma mark -
#pragma mark 基础数据类型等快速创建

#define IDARRAY(...) (id []){ __VA_ARGS__ }
#define IDCOUNT(...) (sizeof(IDARRAY(__VA_ARGS__)) / sizeof(id))

#define ARRAY(...) [NSArray arrayWithObjects: IDARRAY(__VA_ARGS__) count: IDCOUNT(__VA_ARGS__)]

#define DICT(...) DictionaryWithIDArray(IDARRAY(__VA_ARGS__), IDCOUNT(__VA_ARGS__) / 2)

#define NUM_INT(int) [NSNumber numberWithInt:int]
#define NUM_FLOAT(float) [NSNumber numberWithFloat:float]
#define NUM_BOOL(bool) [NSNumber numberWithBool:bool]

#pragma mark -
#pragma mark UIView的常见操作

#define CENTER_VERTICALLY(parent,child) floor((parent.frame.size.height - child.frame.size.height) / 2)
#define CENTER_HORIZONTALLY(parent,child) floor((parent.frame.size.width - child.frame.size.width) / 2)

// example: [[UIView alloc] initWithFrame:(CGRect){CENTER_IN_PARENT(parentView,500,500),CGSizeMake(500,500)}];
#define CENTER_IN_PARENT(parent,childWidth,childHeight) CGPointMake(floor((parent.frame.size.width - childWidth) / 2),floor((parent.frame.size.height - childHeight) / 2))
#define CENTER_IN_PARENT_X(parent,childWidth) floor((parent.frame.size.width - childWidth) / 2)
#define CENTER_IN_PARENT_Y(parent,childHeight) floor((parent.frame.size.height - childHeight) / 2)

#define WIDTH(view) view.frame.size.width
#define HEIGHT(view) view.frame.size.height
#define X(view) view.frame.origin.x
#define Y(view) view.frame.origin.y
#define LEFT(view) view.frame.origin.x
#define TOP(view) view.frame.origin.y
#define BOTTOM(view) (view.frame.origin.y + view.frame.size.height)
#define RIGHT(view) (view.frame.origin.x + view.frame.size.width)

#pragma mark -
#pragma mark IndexPath创建

#define INDEX_PATH(a,b) [NSIndexPath indexPathWithIndexes:(NSUInteger[]){a,b} length:2]

#pragma mark -
#pragma mark 单例创建
#ifndef SHARED_INSTANCE_GCD
#define SHARED_INSTANCE_GCD \
\
+ (instancetype)sharedInstance { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(^{ \
return [[self alloc] init]; \
}) \
}
#endif

#ifndef SHARED_INSTANCE_GCD_USING_BLOCK
#define SHARED_INSTANCE_GCD_USING_BLOCK(block) \
\
+ (instancetype)sharedInstance { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(block) \
}
#endif

#ifndef SHARED_INSTANCE_GCD_WITH_NAME
#define SHARED_INSTANCE_GCD_WITH_NAME(classname)                        \
\
+ (instancetype)shared##classname { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(^{ \
return [[self alloc] init]; \
}) \
}
#endif

#ifndef SHARED_INSTANCE_GCD_WITH_NAME_USING_BLOCK
#define SHARED_INSTANCE_GCD_WITH_NAME_USING_BLOCK(classname, block) \
\
+ (instancetype)shared##classname { \
DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(block) \
}
#endif

#ifndef DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK
#define DEFINE_SHARED_INSTANCE_GCD_USING_BLOCK(block) \
static dispatch_once_t pred = 0; \
__strong static id _sharedObject = nil; \
dispatch_once(&pred, ^{ \
_sharedObject = block(); \
}); \
return _sharedObject;
#endif

//----------------------其他----------------------------

//G－C－D
#define BACKGCD(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

//NSUserDefaults 实例化
#define kUSER_DEFAULT [NSUserDefaults standardUserDefaults]


//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)


//static inline BOOL IsEmpty(id thing) {
//    return thing == nil || [thing isEqual:[NSNull null]]
//    || ([thing respondsToSelector:@selector(length)]
//        && [(NSData *)thing length] == 0)
//    || ([thing respondsToSelector:@selector(count)]
//        && [(NSArray *)thing count] == 0);
//}
//
//static inline NSString *StringFromObject(id object) {
//    if (object == nil || [object isEqual:[NSNull null]]) {
//        return @"";
//    } else if ([object isKindOfClass:[NSString class]]) {
//        return object;
//    } else if ([object respondsToSelector:@selector(stringValue)]){
//        return [object stringValue];
//    } else {
//        return [object description];
//    }
//}

#endif /* MacroDefine_h */
