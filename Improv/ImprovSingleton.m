#import "ImprovSingleton.h"

@implementation ImprovSingleton

static ImprovSingleton *sharedImprov = nil;
@synthesize startingMax;
@synthesize startingMin;
@synthesize tagsArray;
// Get the shared instance and create it if necessary.
+ (ImprovSingleton *)sharedImprov {
    if (sharedImprov == nil) {
        sharedImprov = [[super allocWithZone:NULL] init];
    }
    
    return sharedImprov;
}

// We can still have a regular init method, that will get called the first time the Singleton is used.
- (id)init
{
    self = [super init];
    
    if (self) {
        // Work your initialising magic here as you normally would
        tagsArray = [[NSMutableArray alloc] init];
    }
    
    return self;
}

// Your dealloc method will never be called, as the singleton survives for the duration of your app.
// However, I like to include it so I know what memory I'm using (and incase, one day, I convert away from Singleton).
// We don't want to allocate a new instance, so return the current one.
+ (id)allocWithZone:(NSZone*)zone {
    return [self sharedImprov];
}

// Equally, we don't want to generate multiple copies of the singleton.
- (id)copyWithZone:(NSZone *)zone {
    return self;
}


@end