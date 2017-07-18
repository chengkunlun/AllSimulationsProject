
#import "SHCurrentMusic.h"

@implementation SHCurrentMusic
+ (instancetype)currentWithJSON:(NSDictionary *)json{
    return [[self alloc] initWithJSON:json];
}

- (instancetype)initWithJSON:(NSDictionary *)json{
    if (self = [super init]) {
        self.name = json[@"title"];
        self.singer = json[@"artist"];
        self.singericon = json[@"picture"];
        self.musicNameURL = [NSURL URLWithString:json[@"url"]];
    }
    return self;
}
@end
