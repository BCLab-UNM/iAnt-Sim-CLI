#define NSLog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#import <Foundation/Foundation.h>
#import "GBCli.h"
#import "Controller.h"

int main(int argc, char * argv[]) {
    
    // Input file path
    NSString *inputFilePath = [@"~/Desktop" stringByExpandingTildeInPath];
    
    // Output file path
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_E/HH_mm_ss"];
    NSString *outputFilePath = [NSString stringWithFormat:@"%@/iAntSimulation/%@", inputFilePath, [dateFormatter stringFromDate:[NSDate date]]];
    
    // Number of simulation iterations
    int iterations = 10;
    
    // Instantiate controller
    Controller *controller = [[Controller alloc] initWithLogFile:outputFilePath];
    Simulation *simulation = [controller simulation];

    // Define arguments
    NSArray* arguments = @[
        @{
            @"header": @"Experiment Options",
            @"options": @[
                @{
                    @"name": @"iterations",
                    @"flag": @'i',
                    @"desc": @"Number of iterations"
                },
                
                @{
                    @"name": @"generationCount",
                    @"flag": @'g',
                    @"long": @"generations",
                    @"desc": @"Number of generations, or -1 to use evaluationLimit"
                },
                
                @{
                    @"name": @"evaluationLimit",
                    @"flag": @'l',
                    @"desc": @"Number of generations, or -1 to use generationCount"
                },
                
                @{
                    @"name": @"evaluationCount",
                    @"flag": @'e',
                    @"long": @"evaluations",
                    @"desc": @"Number of evaluations per individual."
                },
                
                @{
                    @"name": @"teamCount",
                    @"flag": @'p',
                    @"long": @"teams",
                    @"desc": @"Number of teams (population size)."
                },
                
                @{
                    @"name": @"robotCount",
                    @"flag": @'r',
                    @"long": @"robots",
                    @"desc": @"Number of robots per team."
                },
                
                @{
                    @"name": @"tickCount",
                    @"flag": @'t',
                    @"long": @"ticks",
                    @"desc": @"Number of ticks per evaluation.  One tick equals half a second."
                },
                
                @{
                    @"name": @"observedError",
                    @"type": @"flag",
                    @"long": @"error",
                    @"desc": @"Enable real-world error (disable with --no-error)."
                },
                
                @{
                    @"name": @"clusteringTagCutoff",
                    @"desc": @"Number of tags that must be discovered before EM is applied to reduce the random exploration region size."
                },
                
                @{
                    @"name": @"useTravel",
                    @"type": @"flag",
                    @"long": @"travel",
                    @"desc": @"Enable travel behavior (disable with --no-travel)."
                },
                
                @{
                    @"name": @"useGiveUp",
                    @"type": @"flag",
                    @"long": @"giveUp",
                    @"desc": @"Enable give up behavior during search (disable with --no-giveUp)."
                },
                
                @{
                    @"name": @"useSiteFidelity",
                    @"type": @"flag",
                    @"long": @"siteFidelity",
                    @"desc": @"Enable site fidelity behavior (disable with --no-siteFidelity)."
                },
                
                @{
                    @"name": @"usePheromone",
                    @"type": @"flag",
                    @"long": @"pheromone",
                    @"desc": @"Enable pheromone-following behavior (disable with --no-pheromone)."
                },
                
                @{
                    @"name": @"useInformedWalk",
                    @"type": @"flag",
                    @"long": @"informedWalk",
                    @"desc": @"Enable use of informed walk when searching a previously discovered location (disable with --no-informedWalk)."
                }
            ]
        },
        
        @{
            @"header": @"Environment Options",
            @"options": @[
                @{
                    @"name": @"tagCount",
                    @"flag": @'T',
                    @"long": @"tags",
                    @"desc": @"Number of tags distributed on the grid"
                },
                
                @{
                    @"name": @"numberOfClusteredPiles",
                    @"flag": @'P',
                    @"long": @"piles",
                    @"desc": @"Number of piles tags are distributed into."
                },
                
                @{
                    @"name": @"gridSize",
                    @"flag": @'s',
                    @"long": @"size",
                    @"desc": @"Size of the grid formatted as \"{width, height}\" (including quotation marks)."
                },
                
                @{
                    @"name": @"nest",
                    @"flag": @'n',
                    @"desc": @"Location of the nest on the grid formatted as \"{x, y}\" (including quotation marks)."
                }
            ]
        },
        
        @{
            @"header": @"Genetic Algorithm Options",
            @"options": @[
                @{
                    @"name": @"crossoverRate",
                    @"flag": @'c'
                },
                
                @{
                    @"name": @"mutationRate",
                    @"flag": @'m'
                },
                
                @{
                    @"name": @"crossoverOperator",
                    @"flag": @'C',
                    @"desc": @"0 for independent assortment, 1 for uniform crossover, 2 for one point crossover, 3 for two point crossover.",
                },
                
                @{
                    @"name": @"mutationOperator",
                    @"flag": @'M',
                    @"desc": @"0 for value-dependent variance mutation, 1 for decreasing variance mutation, 2 for fixed variance mutation"
                },
                
                @{
                    @"name": @"elitism",
                    @"desc": @"Enable elitism (disable with --no-elitism).",
                    @"type": @"flag"
                }
            ]
        },
        
        @{
            @"header": @"Other Options",
            @"options": @[
                @{
                    @"name": @"help",
                    @"flag": @'h',
                    @"desc": @"Print this.",
                    @"type": @"flag"
                },
                
                @{
                    @"name": @"version",
                    @"flag": @'v',
                    @"desc": @"Show version information.",
                    @"type": @"flag"
                }
            ]
        }
    ];
    
    // Arguments that are not properties in the Simulation
    NSArray* cliArguments = @[@"iterations", @"help", @"version", @"gridSize", @"nest"];
    
    GBOptionsHelper* helper = [[GBOptionsHelper alloc] init];
    helper.printHelpHeader = ^{ return @"Usage: %APPNAME [options...]"; };
    helper.printHelpFooter = ^{ return @"\nPart of the iAnt Project.  See https://github.com/BCLab-UNM for more information."; };
    helper.applicationVersion = ^{ return @"1.0"; };
    
    // Set up arguments
    NSDictionary* parameters = [simulation getParameters];
    GBSettings* defaults = [GBSettings settingsWithName:@"Default" parent: nil];
    [defaults setInteger:iterations forKey:@"iterations"];
    
    GBSettings* settings = [GBSettings settingsWithName:@"Input" parent:defaults];
    NSMutableDictionary* argumentAliases = [[NSMutableDictionary alloc] init]; // Convert between argument names and Simulation properties.
    for(NSDictionary* group in arguments) {
        [helper registerSeparator:group[@"header"]];
        
        NSArray* options = group[@"options"];
        for(NSDictionary* option in options) {
            char shortName = [option[@"flag"] charValue];
            shortName = shortName ? shortName : 0;
            
            NSString* longName = option[@"long"];
            longName = longName ? longName : option[@"name"];
            [argumentAliases setObject:option[@"name"] forKey:longName];
            
            GBOptionFlags flag = GBOptionOptionalValue;
            if([option[@"type"] isEqualToString:@"flag"]) {
                flag = GBOptionNoValue;
            }
            else if([option[@"type"] isEqualToString:@"required"]) {
                flag = GBOptionRequiredValue;
            }
            
            if([group[@"header"] isEqualToString:@"Other Options"]) {
                flag |= GBOptionNoPrint;
            }
            
            [helper registerOption:shortName long:longName description:option[@"desc"] flags:flag];
            
            if([parameters objectForKey:option[@"name"]]) {
                [defaults setObject:[parameters objectForKey:option[@"name"]] forKey:longName];
            }
        }
    }
    
    // Parse arguments
    GBCommandLineParser* parser = [[GBCommandLineParser alloc] init];
    [parser registerSettings:settings];
    [parser registerOptions:helper];
    [parser parseOptionsWithArguments:argv count:argc block:^(GBParseFlags flags, NSString* argument, id value, BOOL* stop) {
        switch(flags) {
            case GBParseFlagMissingValue:
                NSLog(@"Missing value for option %@", argument);
                break;
                
            case GBParseFlagUnknownOption:
                NSLog(@"Unknown option %@", argument);
                break;
                
            case GBParseFlagOption:
                if([argument hasPrefix:@"no-"]) {
                    argument = [argument stringByReplacingOccurrencesOfString:@"no-" withString:@""];
                }
                
                argument = [argumentAliases objectForKey:argument];
                if(argument) {
                    if([cliArguments indexOfObject:argument] == NSNotFound) {
                        [simulation setValue:value forKey:argument];
                    }
                    [settings setObject:value forKey:argument];
                }
                break;
        }
    }];
    
    // Help and version checks
    if([settings boolForKey:@"help"] == YES) {
        [helper printHelp];
        return 0;
    }
    else if([settings boolForKey:@"version"] == YES) {
        [helper printVersion];
        return 0;
    }
    
    // Special cases
    if([settings objectForKey:@"gridSize"]) {
        [simulation setGridSize:NSSizeFromString([settings objectForKey:@"gridSize"])];
    }
    
    if([settings objectForKey:@"nest"]) {
        [simulation setNest:NSPointFromString([settings objectForKey:@"nest"])];
    }
    else if([settings objectForKey:@"gridSize"]) {
        int x = floor([simulation gridSize].width / 2);
        int y = floor([simulation gridSize].height / 2);
        [simulation setNest:NSMakePoint(x, y)];
    }
    
    if([settings integerForKey:@"iterations"] > 0) {
        iterations = (int)[settings integerForKey:@"iterations"];
    }
    
    [helper printValuesFromSettings:settings];
    
    // User-specified evolved parameters
    NSString *parameterFilePath = [NSString stringWithFormat:@"%@/evolvedParameters.plist",inputFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:parameterFilePath]) {
        [simulation setParameterFile:parameterFilePath];
    }

    [controller start];
    
    // Write initialization parameters to file
    [simulation writeParametersToFile:[outputFilePath stringByAppendingString:@"/simulationParameters.plist"]];
    
    // Run iterations and find best overall team
    NSNumber* mostTags = @(0.);
    Team* bestTeam = [[Team alloc] init];
    NSMutableArray* bestTagsCollected;
    NSMutableArray* bestTimeToCompleteCollection;
    
    for(int i = 0; i < iterations; i++) {
        
        printf("Starting iteration %d\n", i);
        
        // Run sim
        NSMutableDictionary* data = [simulation run];
        NSMutableArray* tagsCollected = data[@"fitness"];
        NSMutableArray* timeToCompleteCollection = data[@"time"];
        
        // Record parameters of best performing team
        NSNumber* totalTagsCollected = [tagsCollected valueForKeyPath:@"@sum.floatValue"]; //sum over tags collected array
        if([totalTagsCollected compare:mostTags] == NSOrderedDescending) {
            mostTags = totalTagsCollected;
            bestTeam = [simulation averageTeam];
            bestTagsCollected = tagsCollected;
            bestTimeToCompleteCollection = timeToCompleteCollection;
        }
        
        // Write (averaged) parameters to file for later use
        NSMutableDictionary* meanParamters = [[simulation averageTeam] getParameters];
        [meanParamters writeToFile:[outputFilePath stringByAppendingString:[NSString stringWithFormat:@"/evaluation/evolvedParameters%d.plist", i]] atomically:YES];
        
        // Write tags collected array to file for analysis
        NSString* allTags = [tagsCollected componentsJoinedByString:@"\n"];
        [allTags writeToFile:[outputFilePath stringByAppendingString:[NSString stringWithFormat:@"/evaluation/tagsCollected%d.txt", i]] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
        
        // Write time to complete collection array to file for analysis
        NSString* allTime = [timeToCompleteCollection componentsJoinedByString:@"\n"];
        [allTime writeToFile:[outputFilePath stringByAppendingString:[NSString stringWithFormat:@"/evaluation/timeToCompleteCollection%d.txt", i]] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    }
    
    // Write best parameters to file for later use
    NSMutableDictionary* bestParameters = [bestTeam getParameters];
    [bestParameters writeToFile:[outputFilePath stringByAppendingString:@"/evaluation/bestEvolvedParameters.plist"] atomically:YES];
    
    // Write best tags collected array to file for analysis
    NSString* allTags = [bestTagsCollected componentsJoinedByString:@"\n"];
    [allTags writeToFile:[outputFilePath stringByAppendingString:@"/evaluation/bestTagsCollected.txt"] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    
    // Write best time to complete collection array to file for analysis
    NSString* allTime = [bestTimeToCompleteCollection componentsJoinedByString:@"\n"];
    [allTime writeToFile:[outputFilePath stringByAppendingString:@"/evaluation/bestTimeToCompleteCollection.txt"] atomically:YES encoding:NSASCIIStringEncoding error:NULL];
    
    return 0;
}
