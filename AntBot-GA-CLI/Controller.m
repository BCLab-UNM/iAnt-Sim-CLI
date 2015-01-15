#import "Controller.h"

@implementation Controller

@synthesize reporters;

- (id) initWithLogFile:(NSString*)_logFilePath {
    if (self = [super init]) {
        logFilePath = [_logFilePath stringByExpandingTildeInPath];
        
        reporters = [[NSArray alloc] init];
        reporterActions = @{
            @"average": @{
                @"start": ^(Simulation* simulation) {
                    NSString* filename = [logFilePath stringByAppendingString:@"/evolution/meanParameters.csv"];
                    [Team writeParameterNamesToFile:filename];
                },
                    
                @"finish": ^(Simulation* simulation) {
                    NSString* filename = [logFilePath stringByAppendingString:@"/evolution/meanParameters.csv"];
                    [Utilities appendText:@"\n" toFile:filename];
                },
                
                @"generation": ^(Simulation* simulation, int generation, int evaluation) {
                    NSString* filename = [logFilePath stringByAppendingString:@"/evolution/meanParameters.csv"];
                    
                    Team* team = [simulation averageTeam];
                    if(team) {
                        [team writeParametersToFile:filename];
                    }
                }
            },
        
            @"best": @{
                @"start": ^(Simulation* simulation) {
                    NSString* filename = [logFilePath stringByAppendingString:@"/evolution/bestParameters.csv"];
                    [Team writeParameterNamesToFile:filename];
                },
                
                @"finish": ^(Simulation* simulation) {
                    NSString* filename = [logFilePath stringByAppendingString:@"/evolution/bestParameters.csv"];
                    [Utilities appendText:@"\n" toFile:filename];
                },
                
                @"generation": ^(Simulation* simulation, int generation, int evaluation) {
                    NSString* filename = [logFilePath stringByAppendingString:@"/evolution/bestParameters.csv"];
                    
                    Team* team = [simulation bestTeam];
                    if(team) {
                        [team writeParametersToFile:filename];
                    }
                }
            },
            
            @"tags": @{
                @"tag": ^(Simulation* simulation, Tag* tag, int tick) {
                    NSString* filename = [logFilePath stringByAppendingString:@"/tags.csv"];
                    NSString* text = [NSString stringWithFormat:@"%d,%d,%d\n", tick, (int)tag.position.x, (int)tag.position.y];
                    [Utilities appendText:text toFile:filename];
                }
            },
            
            @"pheromones": @{
                @"pheromone": ^(Simulation* simulation, Pheromone* pheromone, int tick) {
                    NSString* filename = [logFilePath stringByAppendingString:@"/pheromones.csv"];
                    NSString* text = [NSString stringWithFormat:@"%d,%d,%d\n", tick, (int)pheromone.position.x, (int)pheromone.position.y];
                    [Utilities appendText:text toFile:filename];
                }
            }
        };
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
}

-(void) simulationDidStart:(Simulation*)_simulation {
    NSString* action = @"start";
    for(NSString* reporter in reporters) {
        if(reporterActions[reporter][action]) {
            void (^ block)(Simulation*) = reporterActions[reporter][action];
            block(_simulation);
        }
    }
}

-(void) simulationDidFinish:(Simulation*)_simulation {
    NSString* action = @"end";
    for(NSString* reporter in reporters) {
        if(reporterActions[reporter][action]) {
            void (^ block)(Simulation*) = reporterActions[reporter][action];
            block(_simulation);
        }
    }
}

-(void) simulation:(Simulation*)_simulation didFinishGeneration:(int)generation atEvaluation:(int)evaluation {
    NSString* action = @"generation";
    for(NSString* reporter in reporters) {
        if(reporterActions[reporter][action]) {
            void (^ block)(Simulation*, int) = reporterActions[reporter][action];
            block(_simulation, generation);
        }
    }
}

-(void) simulation:(Simulation*)_simulation didFinishTick:(int)tick {
    NSString* action = @"tick";
    for(NSString* reporter in reporters) {
        if(reporterActions[reporter][action]) {
            void (^ block)(Simulation*, int) = reporterActions[reporter][action];
            block(_simulation, tick);
        }
    }
}

-(void) simulation:(Simulation*)_simulation didPickupTag:(Tag*)tag atTick:(int)tick {
    NSString* action = @"tag";
    for(NSString* reporter in reporters) {
        if(reporterActions[reporter][action]) {
            void (^ block)(Simulation*, Tag*, int) = reporterActions[reporter][action];
            block(_simulation, tag, tick);
        }
    }
}

-(void) simulation:(Simulation*)_simulation didPlacePheromone:(Pheromone*)pheromone atTick:(int)tick {
    NSString* action = @"pheromone";
    for(NSString* reporter in reporters) {
        if(reporterActions[reporter][action]) {
            void (^ block)(Simulation*, Pheromone*, int) = reporterActions[reporter][action];
            block(_simulation, pheromone, tick);
        }
    }
}

@end