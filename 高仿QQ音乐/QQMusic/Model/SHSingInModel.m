
#import "SHSingInModel.h"

@implementation SHSingInModel
+ (instancetype)dateWithJSON:(NSDictionary *)json{
    return [[self alloc] initWithWebJSON:json];
}
- (instancetype)initWithWebJSON:(NSDictionary *)json{
    if (self = [super init]) {
        self.account = json[@"account"];
        self.password = json[@"password"];
    }
    return self;
}
@end
