#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#import <Foundation/Foundation.h>
#import "Controller.h"

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
    
    //Read arguments from the command line as an array
    NSArray *args = [[NSProcessInfo processInfo] arguments];
    if (args && ([args count] > 1)){
        //Check if the user is requesting help.
        if((int)[args indexOfObject:[NSString stringWithFormat:@"-h"]] != -1 || (int)[args indexOfObject:[NSString stringWithFormat:@"-help"]] != -1){
            NSLog(@"%@",
                  [NSString stringWithFormat:@"Optional command line flags with their default values are as follows:\n%@%d%@\n%@%d%@\n%@%d%@\n%@%d%@\n%@%d%@\n%@%d%@\n%@%d%@\n%@%d%@\n%@%d%@\n%@%@%@\n%@%d%@\n%@%f%@\n%@%f%@\n%@%f%@\n%@%f%@\n%@%f%@\n%@%d%@\n%@%d%@\n%@\n%@\n\n",
                   @"-iters ",
                   iterations,
                   @"   //Sets the number of iterations to run.",
                   @"-genLimit ",
                   [simulation generationCount],
                   @"   //Sets the generationCount, the limit on the number of generations. Set to -1 to ignore and use evaluationLimit instead.",
                   @"-evalLimit ",
                   [simulation evaluationLimit],
                   @"   //Sets the evaluationLimit, the limit on the number of generations. Set to -1 to ignore and use generationCount instead.",
                   @"-evalCount ",
                   [simulation evaluationCount],
                   @"   //Sets evaluationCount, the number of evaluations per individual.",
                   @"-popSize ",
                   [simulation teamCount],
                   @"   //Sets the teamCount, aka population size.",
                   @"-teamSize ",
                   [simulation robotCount],
                   @"   //Sets the robotCount, aka team size.",
                   @"-tagCount ",
                   [simulation tagCount],
                   @"   //Sets tagCount, the number of tags distributed on the grid.",
                   @"-tickCount ",
                   [simulation tickCount],
                   @"   //Set the tickCount, the total amount of time that teams are allowed to search.",
                   @"-tagCutoff ",
                   [simulation clusteringTagCutoff],
                   @"   //Set the clusteringTagCutoff, the number of tags that must be discovered before EM is applied to reduce the random exploration region size.",
                   @"-gridSize ",
                   NSStringFromSize([simulation gridSize]),
                   @"   //Sets dimensions of grid {width, length}",
                   @"-pileNumber ",
                   [simulation numberOfClusteredPiles],
                   @"   //Sets the number of piles for clustered distribution",
                   @"-distribCluster ",
                   [simulation distributionClustered],
                   @"   //Sets the distributionClustered.",
                   @"-distribPowerLaw ",
                   [simulation distributionPowerlaw],
                   @"   //Sets the distributionPowerLaw.",
                   @"-distribRandom ",
                   [simulation distributionRandom],
                   @"   //Sets the distributionRandom.",
                   @"-crossRate ",
                   [simulation crossoverRate],
                   @"   //Sets the crossover rate.",
                   @"-mutRate ",
                   [simulation mutationRate],
                   @"   //Sets the mutation rate.",
                   @"-mutOp ",
                   [simulation mutationOperator],
                   @"   //Sets the mutation operator.\n      //Mutation operator options include:\n      //0 for value-dependent variance mutation\n      //1 for decreasing variance mutation\n      //2 for fixed variance mutation",
                   @"-crossOp ",
                   [simulation crossoverOperator],
                   @"   //Sets the crossover operator.\n      //Crossover operator options include:\n      //0 for independent assortment\n      //1 for uniform crossover\n      //2 for one point crossover\n      //3 for two point crossover",
                   @"-noElitism   //Turns off elitism. Elitism is enabled by default.",
                   @"-noError   //Turns off real world error. Real world error is enabled by default."]);
            exit(0);
        }
        //Set iterations
        NSString *flag = @"-iters";
        int index = (int)[args indexOfObject:flag];
        if(index != -1){
            iterations = [[args objectAtIndex:(index+1)] intValue];
        }
        //Set generationCount aka generationLimit
        flag = @"-genLimit";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setGenerationCount:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set evaluationLimit
        flag = @"-evalLimit";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setEvaluationLimit:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set evaluationCount. This is the number of evaluations per individual.
        flag = @"-evalCount";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setEvaluationCount:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set teamCount aka population size.
        flag = @"-popSize";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setTeamCount:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set robotCount aka team size
        flag = @"-teamSize";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setRobotCount:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set tagCount
        flag = @"-tagCount";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setTagCount:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set tickCount
        flag = @"-tickCount";
        index = (int)[args indexOfObject:flag];
        if (index != -1){
            [simulation setTickCount:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set exploredCutoff
        flag = @"-tagCutoff";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setClusteringTagCutoff:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set gridSize and nest location
        flag = @"-gridSize";
        index = (int)[args indexOfObject:flag];
        if (index != -1){
            [simulation setGridSize:NSMakeSize([[args objectAtIndex:(index+1)] intValue],[[args objectAtIndex:(index+2)] intValue])];
            [simulation setNest:NSMakePoint(floor([simulation gridSize].width/2.),floor([simulation gridSize].height/2.))];
        }
        //Set numberOfClusteredPiles
        flag = @"-pileNumber";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setNumberOfClusteredPiles:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set distributionClustered
        flag = @"-distribCluster";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setDistributionClustered:[[args objectAtIndex:(index+1)] floatValue]];
        }
        //Set distributionPowerlaw
        flag = @"-distribPowerLaw";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setDistributionPowerlaw:[[args objectAtIndex:(index+1)] floatValue]];
        }
        //Set distributionRandom
        flag = @"-distribRandom";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setDistributionRandom:[[args objectAtIndex:(index+1)] floatValue]];
        }
        //Set crossoverRate
        flag = @"-crossRate";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setCrossoverRate:[[args objectAtIndex:(index+1)] floatValue]];
        }
        //Set mutationRate
        flag = @"-mutRate";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setMutationRate:[[args objectAtIndex:(index+1)] floatValue]];
        }
        //Set mutation operator
        flag = @"-mutOp";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            //This case statement is not strictly needed, but I want to use it for error checking and giving feedback to the user. See the default case.
            switch ([[args objectAtIndex:(index+1)] intValue]){
                case ValueDependentVarMutId:
                    [simulation setMutationOperator:ValueDependentVarMutId];
                    break;
                case DecreasingVarMutId:
                    [simulation setMutationOperator:DecreasingVarMutId];
                    break;
                case FixedVarMutId:
                    [simulation setMutationOperator:FixedVarMutId];
                    break;
                default:
                    NSLog(@"%@ is not a valid mutation operator. See help using -h for more information.", [[args objectAtIndex:(index+1)] stringValue]);
                    exit(1);
            }
        }
        //Set crossover operator
        flag = @"-crossOp";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            //This case statement is not strictly needed, but I want to use it for error checking and giving feedback to the user. See the default case.
            switch ([[args objectAtIndex:(index+1)] intValue]){
                case IndependentAssortmentCrossId:
                    [simulation setCrossoverOperator:IndependentAssortmentCrossId];
                    break;
                case UniformPointCrossId:
                    [simulation setCrossoverOperator:UniformPointCrossId];
                    break;
                case OnePointCrossId:
                    [simulation setCrossoverOperator:OnePointCrossId];
                    break;
                case TwoPointCross:
                    [simulation setCrossoverOperator:TwoPointCross];
                    break;
                default:
                    NSLog(@"%@ is not a valid crossover operator. See help using -h for more information.", [[args objectAtIndex:(index+1)] stringValue]);
                    exit(1);
            }
        }
        //Turn off elitism. Elitism is enabled by default.
        flag = @"-noElitism";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setElitism:NO];
        }
        //Turn off error. Error is enabled by default.
        flag = @"-noError";
        index = (int)[args indexOfObject:flag];
        if(index != -1){
            [simulation setObservedError:NO];
        }
        
    }
    //print out the parameters to the console.
    NSLog(@"%@",
          [NSString stringWithFormat:@"%@%d\n%@%d\n%@%d\n%@%d\n%@%d\n%@%d\n%@%d\n%@%d\n%@%d\n%@%@\n%@%@\n%@%d\n%@%f\n%@%f\n%@%f\n%@%f\n%@%f\n%@%d\n%@%d\n%@%d\n%@%d\n",
           @"iterations = ",
           iterations,
           @"generationCount aka generation limit = ",
           [simulation generationCount],
           @"evaluationLimit = ",
           [simulation evaluationLimit],
           @"evaluationCount = ",
           [simulation evaluationCount],
           @"teamCount aka population size = ",
           [simulation teamCount],
           @"robotCount aka team size = ",
           [simulation robotCount],
           @"tagCount = ",
           [simulation tagCount],
           @"tickCount = ",
           [simulation tickCount],
           @"tagCutoff = ",
           [simulation clusteringTagCutoff],
           @"gridSize = ",
           NSStringFromSize([simulation gridSize]),
           @"nest = ",
           NSStringFromPoint([simulation nest]),
           @"numberOfClusteredPiles = ",
           [simulation numberOfClusteredPiles],
           @"distributionClustered = ",
           [simulation distributionClustered],
           @"distributionPowerlaw = ",
           [simulation distributionPowerlaw],
           @"distributionRandom = ",
           [simulation distributionRandom],
           @"crossoverRate = ",
           [simulation crossoverRate],
           @"mutationRate = ",
           [simulation mutationRate],
           @"mutationOperator = ",
           [simulation mutationOperator],
           @"crossoverOperator = ",
           [simulation crossoverOperator],
           @"elitism = ",
           [simulation elitism],
           @"error = ",
           [simulation observedError]]);
    
    NSString *parameterFilePath = [NSString stringWithFormat:@"%@/evolvedParameters.plist",inputFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:parameterFilePath]) {
        [simulation setParameterFile:parameterFilePath];
    }

    [controller start];
    
    //Write initialization parameters to file
    [[simulation getParameters] writeToFile:[outputFilePath stringByAppendingString:@"/simulationParameters.plist"] atomically:YES];
    
    //Run for NUM_ITERATIONS and find best overall team
    NSNumber* mostTags = @(0.);
    Team* bestTeam = [[Team alloc] init];
    NSMutableArray* bestTagsCollected;
    NSMutableArray* bestTimeToCompleteCollection;
    
    for (int i=0; i<iterations; i++) {
        
        printf("Starting iteration %d\n",i);
        
        //Run sim
        NSMutableDictionary* data = [simulation run];
        NSMutableArray* tagsCollected = data[@"fitness"];
        NSMutableArray* timeToCompleteCollection = data[@"time"];
        
        //Record parameters of best performing team
        NSNumber* totalTagsCollected = [tagsCollected valueForKeyPath:@"@sum.floatValue"]; //sum over tags collected array
        if ([totalTagsCollected compare:mostTags] == NSOrderedDescending) {
            mostTags = totalTagsCollected;
            bestTeam = [simulation averageTeam];
            bestTagsCollected = tagsCollected;
            bestTimeToCompleteCollection = timeToCompleteCollection;
        }
        
        //Write (averaged) parameters to file for later use
        NSMutableDictionary* meanParamters = [[simulation averageTeam] getParameters];
        [meanParamters writeToFile:[outputFilePath stringByAppendingString:[NSString stringWithFormat:@"/evaluation/evolvedParameters%d.plist", i]] atomically:YES];
        
        //Write tags collected array to file for analysis
        NSString* allTags = [tagsCollected componentsJoinedByString:@"\n"];
        [allTags writeToFile:[outputFilePath stringByAppendingString:[NSString stringWithFormat:@"/evaluation/tagsCollected%d.txt", i]] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
        
        //Write time to complete collection array to file for analysis
        NSString* allTime = [timeToCompleteCollection componentsJoinedByString:@"\n"];
        [allTime writeToFile:[outputFilePath stringByAppendingString:[NSString stringWithFormat:@"/evaluation/timeToCompleteCollection%d.txt", i]] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    }
    
    //Write best parameters to file for later use
    NSMutableDictionary* bestParameters = [bestTeam getParameters];
    [bestParameters writeToFile:[outputFilePath stringByAppendingString:@"/evaluation/bestEvolvedParameters.plist"] atomically:YES];
    
    //Write best tags collected array to file for analysis
    NSString* allTags = [bestTagsCollected componentsJoinedByString:@"\n"];
    [allTags writeToFile:[outputFilePath stringByAppendingString:@"/evaluation/bestTagsCollected.txt"] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    
    //Write best time to complete collection array to file for analysis
    NSString* allTime = [bestTimeToCompleteCollection componentsJoinedByString:@"\n"];
    [allTime writeToFile:[outputFilePath stringByAppendingString:@"/evaluation/bestTimeToCompleteCollection.txt"] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    
    return 0;
}