#import <Foundation/Foundation.h>
#import <AntBot-GA/Sim.h>
#import "Utilities.h"

@interface Controller : NSObject {
    NSString* logFilePath;
}

-(id) initWithLogFile:(NSString*)_logFilePath;
-(void) start;
-(void) writeTeamToFile:(NSString*)file :(Team*)team;

@property (nonatomic) Simulation* simulation;
@property (nonatomic) NSString* logBestParameters;
@property (nonatomic) NSString* logMeanParameters;

@end