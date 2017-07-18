
#import <Foundation/Foundation.h>

@interface SHSingInModel : NSObject
@property(nonatomic,copy) NSString *account;
@property(nonatomic,copy) NSString *password;
+ (instancetype)dateWithJSON:(NSDictionary *)json;
@end
