#import <Foundation/Foundation.h>
#import <AntBot-GA/Sim.h>

@interface Controller : NSObject {
    NSString* logFilePath;
    NSDictionary* reporterActions;
}

-(id) initWithLogFile:(NSString*)_logFilePath;
-(void) start;

@property (nonatomic) Simulation* simulation;
@property (nonatomic) NSString* logBestParameters;
@property (nonatomic) NSString* logMeanParameters;
@property (nonatomic) NSArray* reporters;

@end