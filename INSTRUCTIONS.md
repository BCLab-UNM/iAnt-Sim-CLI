Get the Code
---

    git clone https://github.com/BCLab-UNM/AntBot-GA-CLI.git
    cd AntBot-GA-CLI
    git checkout tatiana

Compile the Code
---

Execute

    xcodebuild

From the AntBot-GA-CLI directory.

Running the Code
---

The basic command to run the GA (from the AntBot-GA-CLI directory):

    build/Release/AntBot-GA-CLI

There are a number of command line flags that control tag distribution, grid size, and other things.  To see a list of them with their default values, run:

    build/Release/AntBot-GA-CLI -h

Recommended flags for performing a single run and disabling evolution:

    build/Release/AntBot-GA-CLI -iters 1 -popSize 1 -genLimit 0 -noError

Data for all runs will be dumped to your Desktop in a folder named iAntSimulation.  Inside the folder for each run, there should be two text documents: tags.txt and pheromones.txt.  They contain comma separated matrices with tag and pheromone locations, respectively.  There is a matrix for each tick, and matrices are separated by blank lines.

Controlling Ant Behavior
---

The GA looks for a file on the desktop named `evolvedParameters.plist` to control initial colony behavior parameters.  You can find a sample `evolvedParameters.plist` file in the AntBot-GA-CLI folder.  Short summary of the parameters:

- `travelGiveupProbability` - Probability that ants will stop moving while in their departing state.  A higher value means that ants will tend to explore areas closer to the nest.
- `searchGiveupProbability` - Probability that ants will return to the nest while in the searching state.
- `uninformedSearchCorrelation` - Controls how many radians an ant will turn while performing an uninformed random walk.
- `informedSearchCorrelationDecayRate` - If an ant is informed about potential tags (either via pheromones or site fidelity), it will perform a more 'tight' random walk, decaying over time.  This parameter controls the rate of decay.
- `pheromoneDecayRate` - Controls pheromone exponential decay.  A value of 0 will disable pheromone decaying.
- `pheromoneLayingRate` - Controls how often pheromones will be laid (related to number of observed neighbors upon finding a tag).
- `siteFidelityRate` - Similar to pheromone rate, controls how often an ant will return to the same location as the last tag it found.
