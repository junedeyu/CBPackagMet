//
//  PackagMet.m
//  XiaoBuOutWork
//
//  Created by 陈彬 on 15-5-20.
//  Copyright (c) 2015年 com.eteamsun. All rights reserved.
//

#define kScreenSizes [UIScreen mainScreen].bounds.size
#define MBHUD_Size CGSizeMake(90., 90.)
#define rootNavVC (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController]
#define CB_KeyWindow [[[UIApplication sharedApplication] delegate] window]
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define HWColorAlp(r, g, b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kDocument_Folder [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kUserDef [NSUserDefaults standardUserDefaults]

#ifdef DEBUG
#define CBLog(...) NSLog(__VA_ARGS__)
#define CBMsg object[@"RetMessage"]
#else
#define CBLog(...)
#endif

#import "PackagMet.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import <AFNetworking/AFNetworking.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "SSKeychain.h"
#import <AVFoundation/AVFoundation.h>
#import <sys/utsname.h> // 获取手机型号

static PackagMet *_instance ;
@implementation PackagMet

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance ;
}

/**
 *  字体格式
 */
+ (void)initZTFont:(UILabel *)label
              numF:(NSInteger)numF
             color:(UIColor *)color
{
    label.font = [UIFont systemFontOfSize:numF];
    label.textColor = color;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
}

/**
 *  改变多个uilable 的字体格式
 *
 *  @param labAry UILabel数组
 *  @param numF   字号
 *  @param color  字体颜色
 */
+ (void)initZTFonts:(NSArray *)labAry
              numF:(NSInteger)numF
             color:(UIColor *)color
{
    for (UILabel * label in labAry)
    {
        label.font = [UIFont systemFontOfSize:numF];
        label.textColor = color;
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
    }
}

//获取现在的时间
+(void)currentTimeLabel:(UILabel *)label
                   date:(UIDatePicker *)dates
                    Num:(NSInteger)num
{
    NSString * str;
    
    //获取现在的时间
    NSDate *currentTime;
    if (num == 0) {
        currentTime = [NSDate date];
    }else{
        currentTime = [dates date];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];;
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *NowTime = [formatter stringFromDate:currentTime];
    
    //获取现在是星期几
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday
                                          fromDate:currentTime];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    switch (weekday) {
        case 1:
            str = @"日";
            break;
        case 2:
            str = @"一";
            break;
        case 3:
            str = @"二";
            break;
        case 4:
            str = @"三";
            break;
        case 5:
            str = @"四";
            break;
        case 6:
            str = @"五";
            break;
        case 7:
            str = @"六";
            break;
        default:
            break;
    }
    
    label.text = [NSString stringWithFormat:@"%@  周%@", NowTime, str];
}

/**
 *  根据当前时间获取星期
 *
 *  @return 星期几
 */
+ (NSString *)initGetNowTimeWeek
{
    NSString * str = @"";
    //获取现在的时间
    NSDate *currentTime = [NSDate date];
    //获取现在是星期几
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday
                                          fromDate:currentTime];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    switch (weekday) {
        case 1:
            str = @"7";
            break;
        case 2:
            str = @"1";
            break;
        case 3:
            str = @"2";
            break;
        case 4:
            str = @"3";
            break;
        case 5:
            str = @"4";
            break;
        case 6:
            str = @"5";
            break;
        case 7:
            str = @"6";
            break;
        default:
            break;
    }
    return str;
}

/**
 *  提示信息
 */
+ (void)initAlertViewShowStr:(NSString *)str {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:str preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [rootNavVC presentViewController:alert animated:YES completion:nil];
}

/**
 *  提示信息 带自定义标题
 */
+ (void)initAlertViewTitle:(NSString *)title
                   showStr:(NSString *)str
                   btnName:(NSString *)name {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:str preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:name ? name : @"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [rootNavVC presentViewController:alert animated:YES completion:nil];
}

// 只有一个确认按钮
+ (void)PackagAlertOnlySureViewMsg:(NSString *)msg SureBlock:(void(^)(void))click {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        click();
    }]];
    [rootNavVC presentViewController:alert animated:YES completion:nil];
}

// 取消和确认按钮
+ (void)PackagAlertTwoBtnViewTitle:(NSString *)title
                               msg:(NSString *)msg
                         sureTitle:(NSString *)sureTitle
                         sureStyle:(UIAlertActionStyle)sureStyle
                       cancelTitle:(NSString *)cancelTitle
                       cancelStyle:(UIAlertActionStyle)cancelStyle
                         SureBlock:(void(^)(void))sure
                       cancelBlock:(void(^ __nullable)(void))cancel {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * sureAction = [UIAlertAction actionWithTitle:sureTitle style:sureStyle handler:^(UIAlertAction * _Nonnull action) {
        sure();
    }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:cancelTitle style:cancelStyle handler:^(UIAlertAction * _Nonnull action) {
        if (cancel) {
            cancel();
        }
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:sureAction];
    [rootNavVC presentViewController:alert animated:YES completion:nil];
}

//时间计算/S
+ (NSString *)checkOrderDate:(id)date
                      string:(nullable NSString *)Str {
    NSString *string = [NSString stringWithFormat:@"%@",date] ;
    string = [string substringWithRange:NSMakeRange(0, string.length - 3)];
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970: [string doubleValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    if (Str == nil) {
        [dateFormat setDateFormat:@"yyy-MM-dd"];
    }else{
        [dateFormat setDateFormat:Str];
    }
    NSString *dateString = [dateFormat stringFromDate:nd];
    return dateString ;
}

+ (NSString *)checkNowTimeStr:(nullable NSString *)str
                       date:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    if (str == nil) {
        [formatter setDateFormat:@"yyy-MM-dd"];
    }else{
        [formatter setDateFormat:str];
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSString *NowTime = [formatter stringFromDate:localeDate];
    return NowTime;
}

+ (NSDate *)checkDateNowTimeStr:(nullable NSString *)str
                           date:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    if (str == nil) {
        [formatter setDateFormat:@"yyy-MM-dd HH:mm:ss"];
    }else{
        [formatter setDateFormat:str];
    }
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}

+ (NSDate *)checkDateTimeStr:(nullable NSString *)str dateStr:(NSString *)dateStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    if (str == nil) {
        [formatter setDateFormat:@"yyy-MM-dd"];
    }else{
        [formatter setDateFormat:str];
    }
    NSDate * date = [formatter dateFromString:dateStr];
    return date;
}

+ (NSString *)metCheckWithTimeString:(NSString *)timeStr
{
    NSDateFormatter * format = [[NSDateFormatter alloc] init];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSDate * date = [format dateFromString:timeStr];
    NSString * str = [format stringFromDate:date];
    return str;
}


/**
 *  计算前后一个月
 *
 *  @param date  要计算的时间
 *  @param Flag 正数为后一个月 负数为前一个月
 *
 *  @return 计算后的时间
 */
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date flag:(int)flag
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:flag];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

- (instancetype)initHUDProgresSelfView:(UIViewController *)views title:(NSString *)strTitle
{
    if (self = [super init])
    {
        ProgressHud = [[MBProgressHUD alloc] initWithView:views.view];
        ProgressHud.minSize = MBHUD_Size;
        ProgressHud.label.font = [UIFont systemFontOfSize:13];
        [views.view addSubview:ProgressHud];
        ProgressHud.backgroundColor = HWColorAlp(0, 0, 0, 0.3);
        ProgressHud.label.text = strTitle;
    }
    return self;
}

// 显示在KeyWindow上
- (instancetype)initHUDProgresWindowWithTitle:(NSString *)strTitle
{
    if (self = [super init])
    {
        ProgressHud = [MBProgressHUD showHUDAddedTo:CB_KeyWindow animated:YES];;
        ProgressHud.minSize = MBHUD_Size;
        ProgressHud.label.font = [UIFont systemFontOfSize:13];
        ProgressHud.label.text = strTitle;
    }
    return self;
}

- (void)showProgress {
    [ProgressHud showAnimated:YES];
}

- (void)initHideProgressHud {
    [ProgressHud hideAnimated:YES];
}

- (void)initShowProgressHud:(UIViewController *)views
{
    ProgressHud.frame = CGRectMake(-60, 0, kScreenSizes.width, kScreenSizes.height + 60);
    [views.view bringSubviewToFront:ProgressHud];
    [ProgressHud showAnimated:YES];
}

+ (void)showAllTextView:(UIViewController *)view
               string:(NSString *)labelT
{
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:view.view];
    
    [view.view addSubview:HUD];
    HUD.label.text = labelT;
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        HUD.minSize = CGSizeMake(130, 35);
        HUD.label.font = [UIFont systemFontOfSize:15];
    }else{
        HUD.minSize = CGSizeMake(100, 25);
        HUD.label.font = [UIFont systemFontOfSize:14];
    }
    HUD.offset = CGPointMake(view.view.bounds.origin.x, kScreenSizes.height/3.0);
    HUD.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAnimated:YES];
        });
        
        sleep(1);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD removeFromSuperview];
        });
    });
    
}

+ (void)showHUDWithKeyWindowWithString:(NSString *)labelT
{
    MBProgressHUD * HUD = [[MBProgressHUD alloc] initWithView:CB_KeyWindow];
    
    [CB_KeyWindow addSubview:HUD];
    
    HUD.label.text = labelT;
    HUD.mode = MBProgressHUDModeText;
    
    //指定距离中心点的X轴和Y轴的偏移量，如果不指定则在屏幕中间显示
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        HUD.minSize = CGSizeMake(130, 35);
        HUD.label.font = [UIFont systemFontOfSize:15];
    }else{
        HUD.minSize = CGSizeMake(100, 25);
        HUD.label.font = [UIFont systemFontOfSize:14];
    }
    HUD.offset = CGPointMake([UIScreen mainScreen].bounds.origin.x, kScreenSizes.height/2.5);
    HUD.userInteractionEnabled = NO;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD showAnimated:YES];
        });
        
        sleep(1);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD removeFromSuperview];
        });
    });
}

+ (void)initWithUILabelText:(UILabel *)label
                   sizeWith:(CGSize)size
{
    CGSize containSize = size;//创建一个最大的Size
    UIFont * font = label.font;
    CGRect autorect = [label.text boundingRectWithSize:containSize options:
                       NSStringDrawingTruncatesLastVisibleLine|
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    CGPoint oldCenter = label.frame.origin;
    label.frame = CGRectMake(oldCenter.x + 5,  oldCenter.y, size.width, CGRectGetHeight(autorect)+25);
}

+ (void)initWithUITextView:(UITextView *)label
                  sizeWith:(CGSize)size
{
    CGSize containSize = size;//创建一个最大的Size
    UIFont * font = label.font;
    CGRect autorect = [label.text boundingRectWithSize:containSize options:
                       NSStringDrawingTruncatesLastVisibleLine|
                       NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font} context:nil];
    CGPoint oldCenter = label.frame.origin;
    label.frame = CGRectMake(oldCenter.x,  oldCenter.y, label.frame.size.width, CGRectGetHeight(autorect)+15);
}

///**
// *  圆环百分比
// */
//+ (void)initKDGoalBar:(id)view
//               netNum:(NSInteger)num
//               menNum:(NSInteger)menNum
//               colors:(UIColor *)colors
//{
//    KDGoalBar*firstGoalBar = [[KDGoalBar alloc] initWithFrame:CGRectMake(0, 0, 25, 25) UIcolor:colors];
//    firstGoalBar.menNum = (float)menNum;
//    [firstGoalBar setPercent:(int)num animated:NO];
//    [view addSubview:firstGoalBar];
//}

+ (NSString *)initNeedAry:(id)ary
{
    NSString * str = [ary componentsJoinedByString:@","];
    NSString * str1 = [str stringByReplacingOccurrencesOfString:@"," withString:@"@"];
    return str1;
}

+ (NSString *)initTimeWeekDate:(id)date
                           str:(NSString *)str
{
    NSString *string = [NSString stringWithFormat:@"%@",date] ;
    string = [string substringWithRange:NSMakeRange(0, string.length - 3)];
    NSDate *nd = [NSDate dateWithTimeIntervalSince1970: [string doubleValue]];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:str];
//    NSString *dateString = [dateFormat stringFromDate:nd];
    //获取现在是星期几
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitWeekday fromDate:nd];
    NSInteger weekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
    NSString * day = @"";
    switch (weekday) {
        case 1:
            day = @"日";
            break;
        case 2:
            day = @"一";
            break;
        case 3:
            day = @"二";
            break;
        case 4:
            day = @"三";
            break;
        case 5:
            day = @"四";
            break;
        case 6:
            day = @"五";
            break;
        case 7:
            day = @"六";
            break;
        default:
            break;
    }
    return day;
}

+ (NSDateComponents *)initDateComponentsView
{
    NSCalendar *greCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //  通过已定义的日历对象，获取某个时间点的NSDateComponents表示，并设置需要表示哪些信息（NSYearCalendarUnit, NSMonthCalendarUnit, NSDayCalendarUnit等）
    NSDateComponents *dateComponents = [greCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekday | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
    return dateComponents;
}

//+ (void)initGetCusVivsitEmpNetWorkingSuccessHandle:(void (^)(id object))successHandle
//                                         dataError:(void (^)(id object))dataError
//{
//    NSMutableDictionary * parmas = [NSMutableDictionary dictionary];
//    [parmas setObject:@"getEmpPowerState" forKey:@"op"];
//    [parmas setObject:userId forKey:@"employeeid"];
//    [[NetWorkManager shareInstance] postMethodWithUrl:KPUrl
//                                           Parameters:parmas
//                                        successHandle:^(id object) {
//        if ([object[@"datas"][0][@"power_state"] intValue] == 2) {
//            successHandle(object) ;
//        }else{
//            dataError(object) ;
//        }
//    } dataError:^(id object) {
//        [PackagMet initAlertViewShowStr:object[@"errormsg"]];
//    } errorHandle:^(NSError *error) {
//    }];
//}
//
+ (void)initButtonLayerBtn:(UIView *)btn
                    corner:(NSInteger)num
                  borwidth:(NSInteger)borWNum
                   bocolor:(nullable CGColorRef)color
{
    btn.layer.borderWidth = borWNum;
    btn.layer.borderColor = color;
    btn.layer.cornerRadius = num;
    btn.layer.masksToBounds = YES;
    
    //绘制曲线路径
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:btn.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(num, num)]; // btn.bounds.size
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    //设置大小
//    maskLayer.frame = btn.bounds;
//    //设置图形样子
//    maskLayer.path = maskPath.CGPath;
//    btn.layer.mask = maskLayer;
}

+(NSDictionary *)ParseDictJsonWithStr:(NSString *)JsonStr {
    NSData *JSONData = [JsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

+ (NSArray *)ParseAryJsonWithStr:(NSString *)JsonStr {
    NSData *JSONData = [JsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

/**
 *  删除换行符
 *
 */
+(NSString *)ReplacingNewLineAndWhitespaceCharactersFromJson:(NSString *)dataStr
{
    NSScanner *scanner = [[NSScanner alloc] initWithString:dataStr];
    [scanner setCharactersToBeSkipped:nil];
    NSMutableString *result = [[NSMutableString alloc] init];
    
    NSString *temp;
    NSCharacterSet*newLineAndWhitespaceCharacters = [ NSCharacterSet newlineCharacterSet];
    // 扫描
    while (![scanner isAtEnd])
    {
        temp = nil;
        [scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
        if (temp) [result appendString:temp];
        
        // 替换换行符
        if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
            if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
                [result appendString:@"|"];
        }
    }
    return result;
}

//自定义Btn

+ (UIButton *)getButtonLayer:(UIButton *)button Width:(CGFloat )Width BorderColor:(UIColor *)color CornerRadius:(CGFloat)radius {
    [button.layer setCornerRadius:radius];
    [button.layer setBorderWidth:Width];
    [button.layer setBorderColor:color.CGColor];
    return button;
}

+ (UIButton *)getButtonTitle:(UIButton *)button Title:(NSString *)title Font:(CGFloat)size Color:(UIColor *)color {
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:size];
    [button setTitleColor:color forState:UIControlStateNormal];
    return button;
}

// 获取分割线

+ (UIView *)getSeparatView:(CGFloat )yy {
    UIView *separatView = [[UIView alloc] initWithFrame:CGRectMake(0, yy, kScreenSizes.width, 1)];
    [separatView setBackgroundColor:HWColor(220, 220, 220)];
    return separatView;
}

+ (UIView *)customView:(UIView *)view CornerRadius:(CGFloat)radius BorderWidth:(CGFloat)width borderColor:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor {
    if (!view) {
        view = [[UIView alloc]init];
    }
    [view.layer setCornerRadius:radius];
    [view.layer setBorderWidth:1];
    [view.layer setBorderColor:borderColor.CGColor];
    [view setBackgroundColor:backgroundColor];
    return view;
}

+ (UILabel *)getLabelLayer:(UILabel *)label width:(CGFloat )width borderColor:(UIColor *)color cornerRadius:(CGFloat)radius {
    [label.layer setBorderColor:color.CGColor];
    [label.layer setBorderWidth:width];
    [label.layer setCornerRadius:radius];
    return label;
}

+ (UILabel *)getLabelTitle:(UILabel *)label text:(NSString *)text font:(CGFloat)font textColor:(UIColor *)color textAlignment:(NSTextAlignment)Alignment {
    if (!label) {
        label = [[UILabel alloc]init];
    }
    label.text = text;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    label.textAlignment = Alignment;
    return label;
}

+ (NSString *)GetTimeChange:(NSString *)timeStr {
    
    NSDate *currentTimeDate = [NSDate date];    //  现在时间
    //获取时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *getTimeDate = [formatter dateFromString:timeStr];
    
    // 现在时间 与 获取时间 之差
    long dd = (long)[currentTimeDate timeIntervalSince1970] - [getTimeDate timeIntervalSince1970];
    
    NSString *timeString=@"";
    
    // 1小时内。。
    if (dd/3600<1)
    {
        if (dd/60 <= 5) {
            timeString = @"刚刚";
        }else{
            timeString = [NSString stringWithFormat:@"%ld", dd/60];
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }
    //   1小时 < 时间差 < 1天
    if (dd/3600 > 1 && dd/86400<1)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/3600];
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
    }
    //   1天 < 时间差 < 2天
    if (dd/86400 >=1 && dd/86400 < 2){
        timeString = @"昨天";
    }
    //   2天 < 时间差 < 4天
    if (dd/86400 >= 2 && dd/86400<5)
    {
        timeString = [NSString stringWithFormat:@"%ld", dd/86400];
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    // 4天 < 时间差
    if (dd/86400 > 4) {
        timeString = [timeStr substringWithRange:NSMakeRange(0, 10)];
    }
    return timeString;
}

+ (NSString *)getWifiName
{
    NSString *wifiName = @"";
    
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    
    if (!wifiInterfaces) {
        return @"";
    }
    
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            
            CFRelease(dictRef);
        }
    }
    
    CFRelease(wifiInterfaces);
    return wifiName;
}

+ (NSString *)localWiFiIPAddress
{   
    /*
     #include <arpa/inet.h>
     #include <netdb.h>
     #include <net/if.h>
     #include <ifaddrs.h>
     #import <dlfcn.h>
     #import <SystemConfiguration/SystemConfiguration.h>
     
     */
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return @"";
}

+ (NSString *)getFileNameByFilePath:(NSString *)filePath {
    return [filePath stringByDeletingPathExtension];
}

/**
 *  获得文件的扩展类型（不带'.'）
 */
+ (NSString *)getFileSuffixByFilePath:(NSString *)filePath {
    return [filePath pathExtension];
}

+ (NSString *)getCompleteFileNameByFilePath:(NSString *)filePath {
    return [filePath lastPathComponent];
}

+ (NSString *)getFilePathOnLocation:(NSString *)filename {
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *path =[documentPaths objectAtIndex:0];
    //    文件保存路径
    NSString *filePath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@", filename]];
    return filePath;
}

/**
 *  获取返回数据的Key
 */
+ (NSString *)getDataWithData:(NSArray *)dataAry Key:(NSString *)key
{
    NSString *keyValue = @"";
    if (dataAry.count > 0) {
        for (NSInteger index = 0; index < dataAry.count; index ++) {
            NSDictionary *dataDict = [PackagMet changeWithlowercaseString:[dataAry objectAtIndex:index]];
            NSString *capTion = [dataDict objectForKey:@"caption"];
            if ([capTion isEqualToString:[key lowercaseString]]) {
                NSArray *keyAry = [dataDict allKeys];
                for (NSString *subkey in keyAry) {
                    if ([[dataDict objectForKey:subkey] isEqualToString:[key lowercaseString]] && ![subkey isEqualToString:@"caption"]) {
                        keyValue = subkey;
                        return [keyValue uppercaseString];
                    }
                }
            }
        }
    }
    return @"";
}


/**
 返回字典形式的数据 key值全为小写
 
 @param rowsAry 传入请求下来的大字典
 @param fieldsAry 描述key
 @return 出后后的数组 直接KVC 搞定
 */
+ (NSArray *)getDataLowercaseWithData:(NSArray *)rowsAry fields:(NSArray *)fieldsAry {
    // 直接处理为字典数组 赋给model 一句话搞定避免空的双重循环
    NSMutableArray * ary = [NSMutableArray array];
    for (NSDictionary * dict in rowsAry) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        int index = 0;
        for (NSDictionary * Fields in fieldsAry) {
            [dic setObject:dict[[NSString stringWithFormat:@"F%d",index]] forKey:[Fields[@"Caption"] lowercaseString]];
            index ++;
        }
        [ary addObject:dic];
    }
    return ary ;
}

/**
 返回字典形式的数据 key值为原生大小
 
 @param rowsAry 传入请求下来的大字典
 @param fieldsAry 描述key
 @return 出后后的数组 直接KVC 搞定
 */
+ (NSArray *)getPrimDataWithData:(NSArray *)rowsAry fields:(NSArray *)fieldsAry {
    // 直接处理为字典数组 赋给model 一句话搞定避免空的双重循环
    NSMutableArray * ary = [NSMutableArray array];
    for (NSDictionary * dict in rowsAry) {
        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
        int index = 0;
        for (NSDictionary * Fields in fieldsAry) {
            [dic setObject:dict[[NSString stringWithFormat:@"F%d",index]] forKey:Fields[@"Caption"]];
            index ++;
        }
        [ary addObject:dic];
    }
    return ary ;
}

/**
 *  将字典内容转换为小写
 *
 *  @param dic 要转换的字典
 *
 *  @return 转换结果
 */
+ (NSDictionary *)changeWithlowercaseString:(NSDictionary *)dic
{
    NSData * data =  [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString * str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    str = [str lowercaseString];
    return [self ParseDictJsonWithStr:str];
}

+ (NSString *)getDoubleFromString:(NSString *)string numberOfxiaoshu:(NSInteger )num {
    NSString *aaa;
    switch (num) {
        case 2:
            aaa = [NSString stringWithFormat:@"%.2f", [string floatValue]];
            break;
            
        case 4:
            aaa = [NSString stringWithFormat:@"%.4f", [string floatValue]];
            break;
            
        case 8:
            aaa = [NSString stringWithFormat:@"%.8f", [string floatValue]];
            break;
            
        default:
            break;
    }
    return aaa;
}

// 文件写入
+ (BOOL)createDataBaseWithDic:(NSDictionary *)dict pathComment:(NSString *)pathComment
{
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    NSString *filepath = [docPath stringByAppendingPathComponent:pathComment]; // GoStorePlist.plist
    BOOL flag = [dict writeToFile:filepath atomically:YES];
    return flag;
}

// 文件读取
+ (NSMutableDictionary *)getLoadDataBaseWithPathComment:(NSString *)pathComment
{
    NSMutableDictionary * dict ;
    // 1.获得沙盒根路径
    NSString *home = NSHomeDirectory();
    // 2.document路径
    NSString *docPath = [home stringByAppendingPathComponent:@"Documents"];
    // 3.文件路径
    NSString *filepath = [docPath stringByAppendingPathComponent:pathComment];
    // 4.读取数据
    dict = [[NSMutableDictionary alloc] initWithContentsOfFile:filepath];
    
    return dict;
}

// 自定义View四个角的圆角
+ (void)PackViewLayerWithView:(UIView *)view byRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view.bounds
                                                   byRoundingCorners:corners
                                                         cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view.bounds;
    maskLayer.path = maskPath.CGPath;
    view.layer.mask = maskLayer;
}

/**
 *  单纯改变一句话中的某些字的颜色（一种颜色）
 *
 *  @param color    需要改变成的颜色
 *  @param totalStr 总的字符串
 *  @param subArray 需要改变颜色的文字数组(要是有相同的 只取第一个)
 *
 *  @return 生成的富文本
 */
+ (NSMutableAttributedString *)att_changeCorlorWithColor:(UIColor *)color
                                            TotalString:(NSString *)totalStr
                                         SubStringAry:(NSArray *)subAry {
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:totalStr];
    for (NSString *rangeStr in subAry) {
        NSRange range = [totalStr rangeOfString:rangeStr
                                        options:NSBackwardsSearch];
        [attributedStr addAttribute:NSForegroundColorAttributeName
                              value:color
                              range:range];
    }
    return attributedStr;
}

/**
 *  局部刷新tableView cell
 *
 *  @param tableView tableView
 *  @param row       要刷新的cell
 *  @param section   要刷新那个section的cell
 */
+ (void)reloadTableView:(UITableView *)tableView rowsAtIndexPathForRow:(NSInteger)row inSection:(NSInteger)section withRowAnimation:(UITableViewRowAnimation)animation
{
    NSIndexPath * indexP = [NSIndexPath indexPathForRow:row inSection:section];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexP, nil] withRowAnimation:animation];
}

// 更改状态栏的背景颜色
+ (void)setStatusBarBackgroundColor:(UIColor *)color
{
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)])
    {
        statusBar.backgroundColor = color;
    }
}

// 用kCFStringTransformMandarinLatin方法转化出来的是带音标的拼音，如果需要去掉音标，则继续使用kCFStringTransformStripCombiningMarks方法即可。
+ (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    return [pinyin lowercaseString];
}

+ (void)getReachability {
    // 开始网络监视器
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: [self showHUDWithKeyWindowWithString:@"请检查网络"];
                break;
            case AFNetworkReachabilityStatusNotReachable: [self showHUDWithKeyWindowWithString:@"请检查网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: [self showHUDWithKeyWindowWithString:@"正在使用流量"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: [self showHUDWithKeyWindowWithString:@"网络已连接"];
                break;
            default:
                break;
        }
    }];
}

/**
 创建随机码 UUID 唯一标示符

 @return UUID
 */
+ (NSString*)stringWithUUID {
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

/**
 获取软件和设备的唯一标识符，不管软件卸载几次都不会变

 @return 唯一标识符 类似于UDID
 */
+ (NSString *)stringWithUDID {
//    NSUUID * uuid = [[UIDevice currentDevice] identifierForVendor];
//    return uuid.UUIDString;
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *identifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    
    NSString * currentDeviceUUIDStr = [SSKeychain passwordForService:identifier account:@"uuid"];
    if (currentDeviceUUIDStr == nil || [currentDeviceUUIDStr isEqualToString:@""]) {
        NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
        currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
//        currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
//        currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
        [SSKeychain setPassword:currentDeviceUUIDStr forService:identifier account:@"uuid"];
    }
    return currentDeviceUUIDStr;
}

//+ (void)breakNetWorking {
//    [[NetWorkManager sharedPostHTTPSession].operationQueue cancelAllOperations];
//    [[NetWorkManager sharedGetHTTPSession].operationQueue cancelAllOperations];
//    for (NSURLSessionTask * task in [NetWorkManager sharedPostHTTPSession].tasks) {
//        [task cancel];
//    }
//}

// 删除沙盒里面所有的zip文件
+ (void)deleteFileManagerWithZip {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *fileListArray = [fileManager contentsOfDirectoryAtPath:kDocument_Folder error:nil];
    for (NSString *file in fileListArray)
    {
        NSString *path = [kDocument_Folder stringByAppendingPathComponent:file];
        NSString *extension = [path pathExtension];
        if ([extension isEqualToString:@"zip"])
        {
            BOOL delete = [fileManager removeItemAtPath:path error:nil];
            if (delete) {
                CBLog(@"删除成功 %@",path);
            }else{
                CBLog(@"删除失败 %@",path);
            }
        }
    }
}

/**
 * 截取背景
 */
+ (UIImage *)packagMetWithSnapshot:(UIView *)view cliSize:(CGSize)size {
    NSDictionary * imageDict = [PackagMet getLoadDataBaseWithPathComment:@"FuncBackEffectImage"];
    if (imageDict) {
        return [UIImage imageNamed:@""];
    }
    UIGraphicsBeginImageContextWithOptions(size,YES,0); // - 50 工具栏
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 邮箱正则表达式

 @param email 邮箱地址
 @return 是否符合邮箱标准
 */
-(BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    if( [emailTest evaluateWithObject:email]){
        return YES;
    }else{
        [PackagMet showHUDWithKeyWindowWithString:@"请输入正确的邮箱"];
        return NO;
    }
    return NO;
}

+ (BOOL)allowAccessCamera {
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusDenied || status == AVAuthorizationStatusRestricted) {
        [PackagMet initAlertViewShowStr:@"尚未开启相机权限,请在\"设置->隐私->相机\"中允许访问相机。"] ;
        return NO;
    }
    return YES ;
}

// 商品数量保留三位小数
+ (NSString *)goodsQuantity:(double)quantity {
    NSString * quantitys = [NSString stringWithFormat:@"%g",quantity];
    return quantitys;
}

+ (NSString *)version {
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appCurVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return appCurVersion;
}

+ (void)checkForUpdates {
    NSString *content = [[NSString alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.teenysoft.com/App/Client/Ver.txt"]] encoding:NSUTF8StringEncoding];
    NSDictionary * info = [PackagMet ParseDictJsonWithStr:content][@"iOS"];
    // 比较
    NSString * newVer = [info[@"ver"] stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString * nowVer = [[PackagMet version] stringByReplacingOccurrencesOfString:@"." withString:@""];
//    NSDate * netDate = [PackagMet checkDateTimeStr:nil nsdateStr:info[@"date"]];
//    BOOL flag = [PackagMet compareOneDay:[PackagMet checkDateNowTimeStr:nil nsdate:[NSDate date]] withAnotherDay:netDate];
    if ([nowVer integerValue] < [newVer integerValue]) {
        NSString * date = [PackagMet checkNowTimeStr:@"yyyy-MM-dd" date:[NSDate date]];
        if ([[kUserDef valueForKey:@"TSUpdates"] isEqualToString:date]) {
            return;
        }
        [kUserDef setValue:date forKey:@"TSUpdates"];
        [PackagMet PackagAlertTwoBtnViewTitle:@"App更新提示" msg:[NSString stringWithFormat:@"App有新的版本更新\n支撑AppServer版本为:%@",info[@"server"]] sureTitle:@"更新" sureStyle:0 cancelTitle:@"忽略" cancelStyle:2 SureBlock:^{
            NSString * urlStr = @"https://itunes.apple.com/cn/app/id1093339326?l=zh&ls=1&mt=8";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        } cancelBlock:^{
        }];
    }
}

// 当前时间要超过h上架时间，才弹窗 时间 1 >= 时间2 返回YES
+ (BOOL)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay {
    NSComparisonResult result = [oneDay compare:anotherDay];
    if (result == NSOrderedDescending) {
        //在指定时间前面 过了指定时间 过期
        return YES;
    }
    //刚好时间一样.
    return NO;
}

// 生成的二维码太模糊的处理方法
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image size:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    //设置比例
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap（位图）;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
}

// 金钱大写转换
+ (NSString *)digitUppercase:(NSString *)numstr {
    double numberals=[numstr doubleValue];
    NSArray *numberchar = @[@"零",@"壹",@"贰",@"叁",@"肆",@"伍",@"陆",@"柒",@"捌",@"玖"];
    NSArray *inunitchar = @[@"",@"拾",@"佰",@"仟"];
    NSArray *unitname = @[@"",@"万",@"亿",@"万亿"];
    //金额乘以100转换成字符串（去除圆角分数值）
    NSString *valstr=[NSString stringWithFormat:@"%.2f",numberals];
    NSString *prefix;
    NSString *suffix;
    prefix=@"";
    suffix=@"";
    NSInteger flag = valstr.length - 2;
    NSString *head=[valstr substringToIndex:flag - 1];
    NSString *foot=[valstr substringFromIndex:flag];
    if (head.length>13) {
        return@"数值太大（最大支持13位整数），无法处理";
    }
    //处理整数部分
    NSMutableArray *ch=[[NSMutableArray alloc]init];
    for (int i = 0; i < head.length; i++) {
        NSString * str=[NSString stringWithFormat:@"%x",[head characterAtIndex:i]-'0'];
        [ch addObject:str];
    }
    int zeronum=0;
    
    for (int i=0; i<ch.count; i++) {
        int index=(ch.count -i-1)%4;//取段内位置
        NSInteger indexloc=(ch.count -i-1)/4;//取段位置
        if ([[ch objectAtIndex:i]isEqualToString:@"0"]) {
            zeronum++;
        }
        else
        {
            if (zeronum!=0) {
                if (index!=3) {
                    prefix=[prefix stringByAppendingString:@"零"];
                }
                zeronum=0;
            }
            prefix=[prefix stringByAppendingString:[numberchar objectAtIndex:[[ch objectAtIndex:i]intValue]]];
            prefix=[prefix stringByAppendingString:[inunitchar objectAtIndex:index]];
        }
        if (index ==0 && zeronum<4) {
            prefix=[prefix stringByAppendingString:[unitname objectAtIndex:indexloc]];
        }
    }
    prefix =[prefix stringByAppendingString:@"元"];
    //处理小数位
    if ([foot isEqualToString:@"00"]) {
        suffix =[suffix stringByAppendingString:@"整"];
    }
    else if ([foot hasPrefix:@"0"])
    {
        NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
        suffix=[NSString stringWithFormat:@"%@分",[numberchar objectAtIndex:[footch intValue] ]];
    }
    else
    {
        NSString *headch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:0]-'0'];
        NSString *footch=[NSString stringWithFormat:@"%x",[foot characterAtIndex:1]-'0'];
        suffix=[NSString stringWithFormat:@"%@角%@分",[numberchar objectAtIndex:[headch intValue]],[numberchar  objectAtIndex:[footch intValue]]];
    }
    return [prefix stringByAppendingString:suffix];
}

// 获取手机型号
+ (NSString *)getCurrentDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5"; //  (GSM+CDMA)
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5c"; //  (GSM)
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5c"; //  (GSM+CDMA)
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5s"; //  (GSM)
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5s"; //  (GSM+CDMA)
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    // 日行两款手机型号均为日本独占，可能使用索尼FeliCa支付方案而不是苹果支付
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus";
    if ([deviceModel isEqualToString:@"iPhone10,1"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,4"])   return @"iPhone_8";
    if ([deviceModel isEqualToString:@"iPhone10,2"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,5"])   return @"iPhone_8_Plus";
    if ([deviceModel isEqualToString:@"iPhone10,3"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone10,6"])   return @"iPhone X";
    if ([deviceModel isEqualToString:@"iPhone11,8"])   return @"iPhone XR";
    if ([deviceModel isEqualToString:@"iPhone11,2"])   return @"iPhone XS";
    if ([deviceModel isEqualToString:@"iPhone11,6"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPhone11,4"])   return @"iPhone XS Max";
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch"; //  (5 Gen)
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2"; //  (WiFi)
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2"; //  (CDMA)
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini"; //  (WiFi)
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini"; //  (GSM+CDMA)
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3"; //  (WiFi)
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3"; //  (GSM+CDMA)
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4"; //  (WiFi)
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4"; //  (GSM+CDMA)
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air"; //  (WiFi)
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air"; //  (Cellular)
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2"; //  (WiFi)
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2"; //  (Cellular)
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4"; //  (WiFi)
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4"; //  (LTE)
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad Pro 9.7";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad Pro 12.9";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad Pro 12.9";
    
    if ([deviceModel isEqualToString:@"AppleTV2,1"])      return @"Apple TV 2";
    if ([deviceModel isEqualToString:@"AppleTV3,1"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV3,2"])      return @"Apple TV 3";
    if ([deviceModel isEqualToString:@"AppleTV5,3"])      return @"Apple TV 4";
    
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    return deviceModel;
}

// 生成二维码并显示
+ (UIImage *)QRCodeWithString:(NSString *)QRStr {
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    //过滤器恢复默认
    [filter setDefaults];
    //将NSString格式转化成NSData格式
    NSData *data = [QRStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    //获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];
    return [PackagMet createNonInterpolatedUIImageFormCIImage:image size:65.0];
}

// 指定View生成图片
+ (UIImage *)PackagSnapshotSingleView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(view.bounds.size.width+1.5, view.bounds.size.height), NO, 3.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

// 网络请求错误码解释
+ (NSString *)PackagShowErrorWithCode:(NSError * _Nonnull)error {
    NSString * errorMsg = error.localizedDescription;
    switch (error.code) {
        case -1://NSURLErrorUnknown
            errorMsg = @"无效的URL地址";
            break;
        case -1000://NSURLErrorBadURL
            errorMsg = @"无效的URL地址";
            break;
        case -1001://NSURLErrorTimedOut
            errorMsg = @"网络不给力，请稍后再试";
            break;
        case -1002://NSURLErrorUnsupportedURL
            errorMsg = @"不支持的URL地址";
            break;
        case -1003://NSURLErrorCannotFindHost
            errorMsg = @"找不到服务器";
            break;
        case -1004://NSURLErrorCannotConnectToHost
            errorMsg = @"连接不上服务器";
            break;
        case -1103://NSURLErrorDataLengthExceedsMaximum
            errorMsg = @"请求数据长度超出最大限度";
            break;
        case -1005://NSURLErrorNetworkConnectionLost
            errorMsg = @"网络连接异常";
            break;
        case -1006://NSURLErrorDNSLookupFailed
            errorMsg = @"DNS查询失败";
            break;
        case -1007://NSURLErrorHTTPTooManyRedirects
            errorMsg = @"HTTP请求重定向";
            break;
        case -1008://NSURLErrorResourceUnavailable
            errorMsg = @"资源不可用";
            break;
        case -1009://NSURLErrorNotConnectedToInternet
            errorMsg = @"无网络连接";
            break;
        case -1010://NSURLErrorRedirectToNonExistentLocation
            errorMsg = @"重定向到不存在的位置";
            break;
        case -1011://NSURLErrorBadServerResponse
            errorMsg = @"服务器响应异常";
            break;
        case -1012://NSURLErrorUserCancelledAuthentication
            errorMsg = @"用户取消授权";
            break;
        case -1013://NSURLErrorUserAuthenticationRequired
            errorMsg = @"需要用户授权";
            break;
        case -1014://NSURLErrorZeroByteResource
            errorMsg = @"零字节资源";
            break;
        case -1015://NSURLErrorCannotDecodeRawData
            errorMsg = @"无法解码原始数据";
            break;
        case -1016://NSURLErrorCannotDecodeContentData
            errorMsg = @"无法解码内容数据";
            break;
        case -1017://NSURLErrorCannotParseResponse
            errorMsg = @"无法解析响应";
            break;
        case -1018://NSURLErrorInternationalRoamingOff
            errorMsg = @"国际漫游关闭";
            break;
        case -1019://NSURLErrorCallIsActive
            errorMsg = @"被叫激活";
            break;
        case -1020://NSURLErrorDataNotAllowed
            errorMsg = @"数据不被允许";
            break;
        case -1021://NSURLErrorRequestBodyStreamExhausted
            errorMsg = @"请求体";
            break;
        case -1100://NSURLErrorFileDoesNotExist
            errorMsg = @"文件不存在";
            break;
        case -1101://NSURLErrorFileIsDirectory
            errorMsg = @"文件是个目录";
            break;
        case -1102://NSURLErrorNoPermissionsToReadFile
            errorMsg = @"无读取文件权限";
            break;
        case -1200://NSURLErrorSecureConnectionFailed
            errorMsg = @"安全连接失败";
            break;
        case -1201://NSURLErrorServerCertificateHasBadDate
            errorMsg = @"服务器证书失效";
            break;
        case -1202://NSURLErrorServerCertificateUntrusted
            errorMsg = @"不被信任的服务器证书";
            break;
        case -1203://NSURLErrorServerCertificateHasUnknownRoot
            errorMsg = @"未知Root的服务器证书";
            break;
        case -1204://NSURLErrorServerCertificateNotYetValid
            errorMsg = @"服务器证书未生效";
            break;
        case -1205://NSURLErrorClientCertificateRejected
            errorMsg = @"客户端证书被拒";
            break;
        case -1206://NSURLErrorClientCertificateRequired
            errorMsg = @"需要客户端证书";
            break;
        case -2000://NSURLErrorCannotLoadFromNetwork
            errorMsg = @"无法从网络获取";
            break;
        case -3000://NSURLErrorCannotCreateFile
            errorMsg = @"无法创建文件";
            break;
        case -3001:// NSURLErrorCannotOpenFile
            errorMsg = @"无法打开文件";
            break;
        case -3002://NSURLErrorCannotCloseFile
            errorMsg = @"无法关闭文件";
            break;
        case -3003://NSURLErrorCannotWriteToFile
            errorMsg = @"无法写入文件";
            break;
        case -3004://NSURLErrorCannotRemoveFile
            errorMsg = @"无法删除文件";
            break;
        case -3005://NSURLErrorCannotMoveFile
            errorMsg = @"无法移动文件";
            break;
        case -3006://NSURLErrorDownloadDecodingFailedMidStream
            errorMsg = @"下载解码数据失败";
            break;
        case -3007://NSURLErrorDownloadDecodingFailedToComplete
            errorMsg = @"下载解码数据失败";
            break;
        default:
            break;
    }
    return errorMsg;
}

@end
