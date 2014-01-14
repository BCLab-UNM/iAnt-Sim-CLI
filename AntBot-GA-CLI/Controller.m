#import "Controller.h"

@implementation Controller

@synthesize simulation,logBestParameters,logMeanParameters;

- (id) initWithLogFile:(NSString*)_logFilePath {
    if (self = [super init]) {
        logFilePath = [_logFilePath stringByExpandingTildeInPath];
        simulation = [[Simulation alloc] init];
        [simulation setDelegate:self];
    }
    return self;
}

-(void) start {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //Create main directory
    if(![fileManager createDirectoryAtPath:logFilePath withIntermediateDirectories:YES attributes:nil error:NULL]){
        NSLog(@"Error: Create folder failed %@", logFilePath);
    }
    //Create evolution subdirectory
    if(![fileManager createDirectoryAtPath:[logFilePath stringByAppendingString:@"/evolution"] withIntermediateDirectories:YES attributes:nil error:NULL]){
        NSLog(@"Error: Create folder failed %@", [logFilePath stringByAppendingString:@"/evolution"]);
    }
    //Create evaluation subdirectory
    if(![fileManager createDirectoryAtPath:[logFilePath stringByAppendingString:@"/evaluation"] withIntermediateDirectories:YES attributes:nil error:NULL]){
        NSLog(@"Error: Create folder failed %@", [logFilePath stringByAppendingString:@"/evaluation"]);
    }
    
    //Create the file names for the best parameters and mean parameters files.
    logBestParameters = [NSString stringWithFormat:@"%@/evolution/bestParameters.csv", logFilePath];
    logMeanParameters = [NSString stringWithFormat:@"%@/evolution/meanParameters.csv", logFilePath];
    
    //Initialize log file with appropriate column headings
    [Team writeParameterNamesToFile:logBestParameters];
    [Team writeParameterNamesToFile:logMeanParameters];
}

-(void) finishedGeneration:(int)generation atEvaluation:(int)evaluation {
    Team *team;
    //Write best parameters to file using comma-delimited format
    team = [simulation bestTeam];
    if (team) {
        [team writeParameters:[team getParameters] toFile:logBestParameters];
    }
    
    //Write averaged parameters to file using comma-delimited format
    team = [simulation averageTeam];
    if (team) {
        [team writeParameters:[team getParameters] toFile:logBestParameters];
    }
    
    //If run has completed, add new line to each log file
    if ((generation == [simulation generationCount] - 1) || (evaluation >= [simulation evaluationLimit]))
    {
        [Utilities appendText:@"\n" toFile:logBestParameters];
        [Utilities appendText:@"\n" toFile:logMeanParameters];
    }
}

@end