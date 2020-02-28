//
//  PackagMet.h
//  XiaoBuOutWork
//
//  Created by 陈彬 on 15-5-20.
//  Copyright (c) 2015年 com.eteamsun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface PackagMet : UIView
{
    MBProgressHUD * ProgressHud;
}

/**
 *  单利
 *
 *  @return 对象
 */
+ (instancetype)shareInstance;

/**
 *  改变单个uilable 的字体格式
 *
 *  @param label UILabel
 *  @param numF   字号
 *  @param color  字体颜色
 */
+ (void)initZTFont:(UILabel *)label numF:(NSInteger)numF color:(UIColor *)color;
/**
 *  改变多个uilable 的字体格式
 *
 *  @param labAry UILabel数组
 *  @param numF   字号
 *  @param color  字体颜色
 */
+ (void)initZTFonts:(NSArray *)labAry
               numF:(NSInteger)numF
              color:(UIColor *)color;

+(void)currentTimeLabel:(UILabel *)label date:(UIDatePicker *)dates Num:(NSInteger)num;

/**
 *  提示信息
 */
+ (void)initAlertViewShowStr:(NSString *)str;

/**
 *  提示信息 带自定义标题
 */
+ (void)initAlertViewTitle:(NSString *)title showStr:(NSString *)str btnName:(NSString *)name;

// 只有一个确认按钮
+ (void)PackagAlertOnlySureViewMsg:(NSString *)msg SureBlock:(void(^)(void))click;

/**
 两个按钮
 
 @param title 弹出框标题
 @param msg 内容
 @param sureTitle 确认按钮文字
 @param sureStyle cancelStyle description
 @param cancelTitle 关闭按钮文字
 @param cancelStyle cancelStyle description
 @param sure 确认回调
 @param cancel 关闭回调
 */
+ (void)PackagAlertTwoBtnViewTitle:(NSString *)title
                               msg:(NSString *)msg
                         sureTitle:(NSString *)sureTitle
                         sureStyle:(UIAlertActionStyle)sureStyle
                       cancelTitle:(NSString *)cancelTitle
                       cancelStyle:(UIAlertActionStyle)cancelStyle
                         SureBlock:(void(^)(void))sure
                       cancelBlock:(void(^ __nullable)(void))cancel;

/**
 *  时间计算
 */
+ (NSString *)checkOrderDate:(id)date string:(nullable NSString *)Str;

/**
 *  缓冲图标
 */
- (instancetype)initHUDProgresSelfView:(UIViewController *)views title:(NSString *)strTitle;
- (void)initHideProgressHud;
- (void)initShowProgressHud:(UIViewController *)views;


/**
 显示在KeyWindow上

 @param strTitle 显示内容
 @return self
 */
- (instancetype)initHUDProgresWindowWithTitle:(NSString *)strTitle ;
// 隐藏KeyWindow显示
- (void)showProgress;

/**
 *  提示成功
 */
+ (void)showAllTextView:(UIViewController *)view string:(NSString *)labelT;
+ (void)showHUDWithKeyWindowWithString:(NSString *)labelT;

/**
 *  文本自适应
 */
+ (void)initWithUILabelText:(UILabel *)label sizeWith:(CGSize)size;

/**
 *  文本框自适应高度
 */
+ (void)initWithUITextView:(UITextView *)label sizeWith:(CGSize)size;

/**
 *  获取当前时间
 */
+ (NSString *)checkNowTimeStr:(nullable NSString *)str date:(NSDate *)date;

/**
 *  获取当前时间
 *
 *  @param str   @"yyyy-MM-dd HH:mm:ss"
 *  @param date NSDate
 *
 *  @return NSDate
 */
+ (NSDate *)checkDateNowTimeStr:(nullable NSString *)str
                         date:(NSDate *)date;

/**
 格式化时间 ，将字符串时间转换为 NSDate 格式

 @param str 时间格式
 @param dateStr 要转换的时间
 @return 转换后的时间
 */
+ (NSDate *)checkDateTimeStr:(nullable NSString *)str
                   dateStr:(NSString *)dateStr ;

+ (NSString *)metCheckWithTimeString:(NSString *)timeStr;

/**
 *  圆环百分比
 */
//+ (void)initKDGoalBar:(id)view netNum:(NSInteger)num menNum:(NSInteger)menNum colors:(UIColor *)colors;
/**
 *  以@符号分割  数组转换为字符串
 */
+ (NSString *)initNeedAry:(id)ary;

/**
 *  计算星期
 */
+ (NSString *)initTimeWeekDate:(id)date str:(NSString *)str;

/**
 *  根据当前时间获取星期
 *
 *  @return 星期几
 */
+ (NSString *)initGetNowTimeWeek;

/**
 *  获取本周是今年的第几周
 */
//+ (NSInteger)initWeekOfYear;

/**
 *  获取一年中得数据
 *
 @property NSInteger era;
 @property NSInteger year;
 @property NSInteger month;
 @property NSInteger day;
 @property NSInteger hour;
 @property NSInteger minute;
 @property NSInteger second;
 @property NSInteger nanosecond NS_AVAILABLE(10_7, 5_0);
 @property NSInteger weekday;
 @property NSInteger weekdayOrdinal;
 @property NSInteger quarter NS_AVAILABLE(10_6, 4_0);
 @property NSInteger weekOfMonth NS_AVAILABLE(10_7, 5_0);
 @property NSInteger weekOfYear NS_AVAILABLE(10_7, 5_0);
 @property NSInteger yearForWeekOfYear NS_AVAILABLE(10_7, 5_0);

 */
+ (NSDateComponents *)initDateComponentsView;

/**
 *  计算前后一个月
 *
 *  @param date  要计算的时间
 *  @param flag 正数为后一个月 负数为前一个月
 *
 *  @return 计算后的时间
 */
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date flag:(int)flag;

/**
 *  判断权限
 */
//+ (void)initGetCusVivsitEmpNetWorkingSuccessHandle:(void (^)(id object))successHandle dataError:(void (^)(id object))dataError;
/**
 *  UIButton 画边框先圆角
 */
+ (void)initButtonLayerBtn:(UIView *)btn
                    corner:(NSInteger)num
                  borwidth:(NSInteger)borWNum
                   bocolor:(nullable CGColorRef)color;
/**
 *  字符串字典 转 字典
 */
+(NSDictionary *)ParseDictJsonWithStr:(NSString *)JsonStr;

/**
 *  字符串字典 转 字典
 */
+ (NSArray *)ParseAryJsonWithStr:(NSString *)JsonStr;

/**
 *  删除换行符
 */
+(NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)dataStr;
/*
 *  自定义Btn
 */
+ (UIButton *)getButtonLayer:(UIButton *)button Width:(CGFloat )Width BorderColor:(UIColor *)color CornerRadius:(CGFloat)radius;

+ (UIButton *)getButtonTitle:(UIButton *)button Title:(NSString *)title Font:(CGFloat)size Color:(UIColor *)color;
/*
 *  自定义View
 */

+(UIView *)customView:(UIView *)view CornerRadius:(CGFloat)radius BorderWidth:(CGFloat)width borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor;
/*
 *  自定义Label
 */
+ (UILabel *)getLabelLayer:(UILabel *)label width:(CGFloat )width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius;

+ (UILabel *)getLabelTitle:(UILabel *)label text:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)Alignment;
/*
 *  自定义分割线
 */
+ (UIView *)getSeparatView:(CGFloat )yy;

/**
 *  传入需要转换的时间
 *  获取的时间与现有时间的差值
 */
+ (NSString *)GetTimeChange:(NSString *)timeStr;

/**
 *  获取当前手机连接的wifi名字
 */
+ (NSString *)getWifiName;

/**
 *  获取当前手机连接的wifi的IP地址
 */
+ (NSString *)localWiFiIPAddress;
/**
 *  获得文件名（不带后缀）
 */
+ (NSString *)getFileNameByFilePath:(NSString *)filePath;
/**
 *  获得文件的扩展类型（不带'.'）
 */
+ (NSString *)getFileSuffixByFilePath:(NSString *)filePath;
/**
 *  从路径中获得完整的文件名（带后缀）
 */
+ (NSString *)getCompleteFileNameByFilePath:(NSString *)filePath;
/**
 *  将文件存储到沙盒内 返回路径
 *  @param filename 存储的文件名
 */
+ (NSString *)getFilePathOnLocation:(NSString *)filename;
/**
 *  获取返回数据的Key
 */
+ (NSString *)getDataWithData:(NSArray *)dataAry Key :(NSString *)key;

/**
 返回字典形式的数据 key值全为小写
 
 @param rowsAry 传入请求下来的大字典
 @param fieldsAry 描述key
 @return 出后后的数组 直接KVC 搞定
 */
+ (NSArray *)getDataLowercaseWithData:(NSArray *)rowsAry fields:(NSArray *)fieldsAry ;

/**
 返回字典形式的数据 key值为原生大小
 
 @param rowsAry 传入请求下来的大字典
 @param fieldsAry 描述key
 @return 出后后的数组 直接KVC 搞定
 */
+ (NSArray *)getPrimDataWithData:(NSArray *)rowsAry fields:(NSArray *)fieldsAry;

+ (NSString *)getDoubleFromString:(NSString *)string numberOfxiaoshu:(NSInteger )num;
/**
 *  文件读取
 */
+ (NSMutableDictionary *)getLoadDataBaseWithPathComment:(NSString *)pathComment;
/**
 *  文件写入
 */
+ (BOOL)createDataBaseWithDic:(NSDictionary *)dict pathComment:(NSString *)pathComment;

/**
 *  自定义View四个角的圆角
 */
+ (void)PackViewLayerWithView:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii;
/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subAry 需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)att_changeCorlorWithColor:(UIColor *)color TotalString:(NSString *)totalStr SubStringAry:(NSArray *)subAry;

/**
 *  局部刷新tableView cell
 *
 *  @param tableView tableView
 *  @param row       要刷新的cell
 *  @param section   要刷新那个section的cell
 */
+ (void)reloadTableView:(UITableView *)tableView rowsAtIndexPathForRow:(NSInteger)row inSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  更改状态栏的背景颜色
 *
 *  @param color 颜色
 */
+ (void)setStatusBarBackgroundColor:(UIColor *)color;
/**
 *  汉字转拼音
 *
 *  @param chinese 要转换的汉字
 *
 *  @return pyin
 */
+ (NSString *)transform:(NSString *)chinese;

/**
 检测是否有网络 采用AFNetWorking
 */
+ (void)getReachability;

/**
 创建随机码 UUID 唯一标示符
 
 @return UUID
 */
+ (NSString*)stringWithUUID;

/**
 获取软件和设备的唯一标识符，不管软件卸载几次都不会变 (类似于UDID,但他是软件和设备的结合体)
 
 @return 唯一标识符 类似于UDID
 */
+ (NSString *)stringWithUDID;

/**
 删除沙盒里面所有的zip文件
 */
+ (void)deleteFileManagerWithZip;
/**
 *  结束当前所有网络请求
 */
//+ (void)breakNetWorking;

/**
 * 截取背景
 */
+ (UIImage *)packagMetWithSnapshot:(UIView *)view cliSize:(CGSize)size ;

/**
 邮箱正则表达式
 
 @param email 邮箱地址
 @return 是否符合邮箱标准
 */
-(BOOL)validateEmail:(NSString *)email;

/**
 是否允许访问相机

 @return YES 允许 NO 不允许
 */
+ (BOOL)allowAccessCamera ;

// 商品数量保留三位小数
+ (NSString *)goodsQuantity:(double)quantity;

// 当前App版本号
+ (NSString *)version;

/**
 检测更新
 */
+ (void)checkForUpdates;

// 时间比较 时间 1 >= 时间2 返回YES
+ (BOOL)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;

// 生成的二维码太模糊的处理方法
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image size:(CGFloat)size;


/**
 金钱大写转换

 @param numstr 要大写的金额
 @return 大写金额
 */
+ (NSString *)digitUppercase:(NSString *)numstr;


/**
 获取手机型号

 @return 手机具体型号
 */
+ (NSString *)getCurrentDeviceModel;


/**
 生成二维码并显示

 @param QRStr 文字内容
 @return 生成的w二维码
 */
+ (UIImage *)QRCodeWithString:(NSString *)QRStr;

/**
 指定View生成图片

 @param view 要生成图片的View
 @return 图片
 */
+ (UIImage *)PackagSnapshotSingleView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
