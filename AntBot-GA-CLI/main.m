#import <Foundation/Foundation.h>
#import "Controller.h"
#import "Utilities.h"

int main(int argc, const char * argv[]) {
    //Input file path
    NSString *inputFilePath = [@"~/Desktop" stringByExpandingTildeInPath];
    
    //Output file path
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_E/HH_mm_ss"];
    NSString *outputFilePath = [NSString stringWithFormat:@"%@/iAntSimulation/%@", inputFilePath, [dateFormatter stringFromDate:[NSDate date]]];
    
    //Number of simulation iterations
    int iterations = 10;
    
    //Instantiate controller
    Controller *controller = [[Controller alloc] initWithLogFile:outputFilePath];
    Simulation *simulation = [controller simulation];
    
    [simulation setRobotCount:6];
    [simulation setTeamCount:100];
    [simulation setGenerationCount:100];
    [simulation setTagCount:256];
    [simulation setEvaluationCount:8];
    [simulation setExploreTime:0];
    
    [simulation setDistributionClustered:0.];
    [simulation setDistributionPowerlaw:1.];
    [simulation setDistributionRandom:0.];
    
    [simulation setRealWorldError:FALSE];
    
    [simulation setVariableStepSize:FALSE];
    [simulation setUniformDirection:FALSE];
    [simulation setAdaptiveWalk:TRUE];
    
    [simulation setDecentralizedPheromones:FALSE];
    
    NSString *parameterFilePath = [NSString stringWithFormat:@"%@/evolvedParameters.plist",inputFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:parameterFilePath]) {
        [simulation setParameterFile:parameterFilePath];
    }

    [controller start];
    
    //Write initialization parameters to file
    [[simulation getParameters] writeToFile:[outputFilePath stringByAppendingString:@"/simulationParameters.plist"] atomically:YES];
    
    //Run for NUM_ITERATIONS and find best overall team
    NSNumber* mostTags = [[NSNumber alloc] initWithFloat:0.];
    Team* bestTeam = [[Team alloc] init];
    NSMutableArray* bestTagsCollected;
    
    for (int i=0; i<iterations; i++) {
        
        printf("Starting iteration %d\n",i);
        
        //Run sim
        NSMutableArray* tagsCollected = [simulation run];
        
        //Record parameters of best performing team
        NSNumber* totalTagsCollected = [tagsCollected valueForKeyPath:@"@sum.floatValue"]; //sum over tags collected array
        if (totalTagsCollected > mostTags) {
            mostTags = totalTagsCollected;
            bestTeam = [simulation averageTeam];
            bestTagsCollected = tagsCollected;
        }
    }
    
    //Write best parameters to file for later use
    NSMutableDictionary* bestParameters = [bestTeam getParameters];
    [bestParameters writeToFile:[outputFilePath stringByAppendingString:@"/evaluation/evolvedParameters.plist"] atomically:YES];
    
    //Write best tags collected array to file for analysis
    NSString* allTags = [bestTagsCollected componentsJoinedByString:@"\n"];
    [allTags writeToFile:[outputFilePath stringByAppendingString:@"/evaluation/tagsCollected.txt"] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    
    return 0;
}