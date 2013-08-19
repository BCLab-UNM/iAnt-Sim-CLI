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
    [self writeHeadersToFile:logBestParameters];
    [self writeHeadersToFile:logMeanParameters];
}

-(void) writeTeamToFile:(NSString*)file :(Team*)team {
    NSMutableDictionary *evolvedParameters;
    //Write parameters to file using comma-delimited format
    evolvedParameters = [team getParameters];
    [Utilities appendText:[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%f\n",
                           [evolvedParameters objectForKey:@"pheromoneDecayRate"],
                           [evolvedParameters objectForKey:@"travelGiveUpProbability"],
                           [evolvedParameters objectForKey:@"searchGiveUpProbability"],
                           [evolvedParameters objectForKey:@"uninformedSearchCorrelation"],
                           [evolvedParameters objectForKey:@"informedSearchCorrelation"],
                           [evolvedParameters objectForKey:@"informedGiveUpProbability"],
                           [evolvedParameters objectForKey:@"neighborSearchGiveUpProbability"],
                           [evolvedParameters objectForKey:@"stepSizeVariation"],
                           [evolvedParameters objectForKey:@"pheromoneLayingRate"],
                           [evolvedParameters objectForKey:@"siteFidelityRate"],
                           [team tagsCollected]]
                   toFile:file];
}


-(void) writeHeadersToFile:(NSString*)file {
    NSString* headers = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,\n",
                         @"pheromoneDecayRate",
                         @"travelGiveUpProbability",
                         @"searchGiveUpProbability",
                         @"uninformedSearchCorrelation",
                         @"informedSearchCorrelation",
                         @"informedGiveUpProbability",
                         @"neighborSearchGiveUpProbability",
                         @"stepSizeVariation",
                         @"pheromoneLayingRate",
                         @"siteFidelityRate",
                         @"tagsCollected"];
    [Utilities appendText:headers toFile:file];
}


-(void) finishedGeneration:(int)generation {
    Team *team;
    //Write best parameters to file using comma-delimited format
    team = [simulation bestTeam];
    if (team) {
        [self writeTeamToFile:logBestParameters :team];
    }
    
    //Write averaged parameters to file using comma-delimited format
    team = [simulation averageTeam];
    if (team) {
        [self writeTeamToFile:logMeanParameters :team];
    }
    
    //If run has completed, add new line to each log file
    if ((generation == [simulation generationCount] - 1) || ([simulation evalCount] >= [simulation evaluationLimit]))
    {
        [Utilities appendText:@"\n" toFile:logBestParameters];
        [Utilities appendText:@"\n" toFile:logMeanParameters];
    }
}

@end