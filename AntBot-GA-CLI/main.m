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
    [simulation setGenerationCount:100]; //Negative 1 makes simulation ignore this.
    [simulation setEvaluationLimit:-1]; //Negative 1 makes simulation ignore this.
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

    [simulation setCrossoverRate:1.0];
    [simulation setMutationRate:0.1];
    [simulation setCrossoverOperator:UniformPointCrossId];
    [simulation setMutationOperator:FixedVarMutId];
    [simulation setElitism:TRUE];
    
    //Read values from the command line
    NSArray *args = [[NSProcessInfo processInfo] arguments];
    if (args && ([args count] > 1)){
        //Check if the user is requesting help.
        if([args indexOfObject:[NSString stringWithFormat:@"-h"]] != -1 || [args indexOfObject:[NSString stringWithFormat:@"-help"]] != -1){
            NSLog(@"%@",
                  [NSString stringWithFormat:@"Optional command line flags with their default values are as follows:\n%@%d%@\n%@%d%@\n%@%d%@\n%@%d%@\n%@%f%@\n%@%f%@\n%@%f%@\n%@%f%@\n%@%f%@\n%@%d%@\n%@%d%@\n%@\n\n",
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
                   @"-noElitism   //Turns off elitism. Elitism is enabled by default."]);
            exit(0);
        }
        //Set iterations
        NSString *flag = [NSString stringWithFormat:@"-iters"];
        int index = [args indexOfObject:flag];
        if(index != -1){
            iterations = [[args objectAtIndex:(index+1)] intValue];
        }
        //Set generationCount aka generationLimit
        flag = [NSString stringWithFormat:@"-genLimit"];
        index = [args indexOfObject:flag];
        if(index != -1){
            [simulation setGenerationCount:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set evaluationLimit
        flag = [NSString stringWithFormat:@"-evalLimit"];
        index = [args indexOfObject:flag];
        if(index != -1){
            [simulation setEvaluationLimit:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set evaluationCount. This is the number of evaluations per individual.
        flag = [NSString stringWithFormat:@"-evalCount"];
        index = [args indexOfObject:flag];
        if(index != -1){
            [simulation setEvaluationCount:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set teamCount aka population size.
        flag = [NSString stringWithFormat:@"-popSize"];
        index = [args indexOfObject:flag];
        if(index != -1){
            [simulation setTeamCount:[[args objectAtIndex:(index+1)] intValue]];
        }
        //Set distributionClustered
        flag = [NSString stringWithFormat:@"-distribCluster"];
        index = [args indexOfObject:flag];
        if(index != -1){
            [simulation setDistributionClustered:[[args objectAtIndex:(index+1)] floatValue]];
        }
        //Set distributionPowerlaw
        flag = [NSString stringWithFormat:@"-distribPowerLaw"];
        index = [args indexOfObject:flag];
        if(index != -1){
            [simulation setDistributionPowerlaw:[[args objectAtIndex:(index+1)] floatValue]];
        }
        //Set distributionRandom
        flag = [NSString stringWithFormat:@"-distribRandom"];
        index = [args indexOfObject:flag];
        if(index != -1){
            [simulation setDistributionRandom:[[args objectAtIndex:(index+1)] floatValue]];
        }
        //Set crossoverRate
        flag = [NSString stringWithFormat:@"-crossRate"];
        index = [args indexOfObject:flag];
        if(index != -1){
            [simulation setCrossoverRate:[[args objectAtIndex:(index+1)] floatValue]];
        }
        //Set mutationRate
        flag = [NSString stringWithFormat:@"-mutRate"];
        index = [args indexOfObject:flag];
        if(index != -1){
            [simulation setMutationRate:[[args objectAtIndex:(index+1)] floatValue]];
        }
        //Set mutation operator
        flag = [NSString stringWithFormat:@"-mutOp"];
        index = [args indexOfObject:flag];
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
        flag = [NSString stringWithFormat:@"-crossOp"];
        index = [args indexOfObject:flag];
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
        flag = [NSString stringWithFormat:@"-noElitism"];
        index = [args indexOfObject:flag];
        if(index != -1){
            [simulation setElitism:FALSE];
        }
    }
    //print out the parameters to the console.
    NSLog(@"%@",
          [NSString stringWithFormat:@"%@%d\n%@%d\n%@%d\n%@%d\n%@%d\n%@%f\n%@%f\n%@%f\n%@%f\n%@%f\n%@%d\n%@%d\n%@%d\n",
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
           [simulation elitism]]);
    
    //Error check
    if([simulation generationCount] < 1 && [simulation evaluationLimit] < 1){
        NSLog(@"ERROR: generationCount and evaluationLimit cannot both be less than 1.");
        exit(0);
    }
    
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
        
        //Write best parameters to file for later use
        NSMutableDictionary* bestParameters = [bestTeam getParameters];
        [bestParameters writeToFile:[outputFilePath stringByAppendingString:[NSString stringWithFormat:@"/evaluation/evolvedParameters%d.plist", i]] atomically:YES];
        
        //Write best tags collected array to file for analysis
        NSString* allTags = [bestTagsCollected componentsJoinedByString:@"\n"];
        [allTags writeToFile:[outputFilePath stringByAppendingString:[NSString stringWithFormat:@"/evaluation/tagsCollected%d.txt", i]] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    }
    
    //Write best parameters to file for later use
    NSMutableDictionary* bestParameters = [bestTeam getParameters];
    [bestParameters writeToFile:[outputFilePath stringByAppendingString:@"/evaluation/bestEvolvedParameters.plist"] atomically:YES];
    
    //Write best tags collected array to file for analysis
    NSString* allTags = [bestTagsCollected componentsJoinedByString:@"\n"];
    [allTags writeToFile:[outputFilePath stringByAppendingString:@"/evaluation/bestTagsCollected.txt"] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    
    return 0;
}