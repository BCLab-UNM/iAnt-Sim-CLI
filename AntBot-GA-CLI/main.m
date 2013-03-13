//
//  main.m
//  AntBot-GA-CLI
//
//  Created by Joshua Hecker on 3/3/13.
//  Copyright (c) 2013 Joshua Hecker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Controller.h"
#import "Utilities.h"

NSString *FILE_PATH = @"~/Dropbox/School/Research/AntBot/Data/GA evolved parameters";
int NUM_ITERATIONS = 10;

int main(int argc, const char * argv[]) {
    //Instantiate controller
    Controller *controller = [[Controller alloc] initWithLogFile:FILE_PATH];
    Simulation *simulation = [controller simulation];
    
    [simulation setAntCount:6];
    [simulation setColonyCount:100];
    [simulation setGenerationCount:200];
    [simulation setTagCount:256];
    [simulation setDistributionClustered:0];
    [simulation setDistributionPowerlaw:1];
    [simulation setDistributionRandom:0];
    
    for (int i=0; i<NUM_ITERATIONS; i++) {
        //Run sim
        [simulation start];
    }
    
    return 0;
}