import java.util.Arrays;
import java.util.List;
import java.util.Collections;

public char[] outputToChar = {'w', 'a', 's', 'd'};

class GeneticAlgorithm{
  ArrayList<MultilayerPerceptron> individuals;
  int numGenerations;
  int individualsPerGeneration;
  int generationBest;
  int bestFitness;
  int currFitness;
  Game game;
  float mutationRate;
  float predationChance;
  
  ArrayList<MultilayerPerceptron> population;
  
  int genIndex;
  int indIndex;
  
  public GeneticAlgorithm(int numGenerations, int individualsPerGeneration, float mutationRate, float predationChance){
    // Control variables
    this.numGenerations = numGenerations;
    this.individualsPerGeneration = individualsPerGeneration;
    this.predationChance = predationChance;

    // Game variable
    this.game = new Game(false, 0);
    
    // Fitness and index variables
    this.bestFitness = 0;
    this.genIndex = 0;
    this.indIndex = 0;
    
    // Individuals and population
    this.population = this.generateRandomPopulation();
    this.generationBest = 0;
    
    // Mutation rate
    this.mutationRate = mutationRate;
  }
  
  public Boolean runIndividual(MultilayerPerceptron individual){
    // Run game
    this.game.loop();
    this.currFitness = this.fitness(this.game);
    
    // Get sensors data
    ArrayList<Float> inputData = new ArrayList<Float>();
    ArrayList<Integer> gameData = game.getMLPData();
    for(int num : gameData){
      inputData.add((float) num);
    }
    
    // Set sensors array as MLP input
    int control = individual.feed(inputData);
    this.game.setControl(outputToChar[control]);
    
    // On game end
    if(this.game.hasEnded()){
      return true;
    }
    
    return false;
  }
  
  public ArrayList<MultilayerPerceptron> generatePopulation(ArrayList<MultilayerPerceptron> lastPopulation){
    ArrayList<MultilayerPerceptron> newPopulation = new ArrayList<MultilayerPerceptron>();
    ArrayList<MultilayerPerceptron> lastPopBests = this.getBests(lastPopulation);
    
    // Preserve bests
    for(MultilayerPerceptron ind : lastPopBests){
      newPopulation.add(ind);  
    }
    
    // Print last bests
    print("\nLast gen best fitnesses: ");
    for(MultilayerPerceptron ind : lastPopBests){
      print(ind.getFitness() + " ");
    }
    print("\n");
    
    // Add new individuals as mates from bests
    for(int i = (int) sqrt(this.individualsPerGeneration) + 1; i < lastPopulation.size(); i++){
      // Get two individuals randomly from the bests
      MultilayerPerceptron father = lastPopBests.get((int) random(0, lastPopBests.size()));
      MultilayerPerceptron mother = lastPopBests.get((int) random(0, lastPopBests.size()));
      
      // Mate and add child to population
      newPopulation.add(this.mate(father, mother));
    }
    
    return newPopulation;
  }
  
  public ArrayList<MultilayerPerceptron> generateRandomPopulation(){
    ArrayList<MultilayerPerceptron> population = new ArrayList<MultilayerPerceptron>();
    
    // Create individuals and append to population
    for(int i = 0; i < this.individualsPerGeneration; i++){
      // Create random individual
      population.add(new MultilayerPerceptron(6, new ArrayList<Integer>(Arrays.asList(8, 4))));
    }
    
    return population;
  }
  
  public ArrayList<MultilayerPerceptron> getBests(ArrayList<MultilayerPerceptron> pop){
    // Get bests
    ArrayList<MultilayerPerceptron> bests = new ArrayList<MultilayerPerceptron>();
    ArrayList<Integer> fitnessArray = new ArrayList<Integer>();
    
    // Create fitness array
    for(int i = 0; i < pop.size(); i++){
      fitnessArray.add(pop.get(i).getFitness());  
    }

    int bestIndex;
    
    for(int i = 0; i < (int) sqrt(this.individualsPerGeneration) + 1; i++){
      // Get best's index
      bestIndex = fitnessArray.indexOf(Collections.max(fitnessArray));
      // Remove best to get the next one after this iteration
      fitnessArray.set(bestIndex, 0);
      
      // Append individual to bests array
      bests.add(pop.get(bestIndex));
    }
    
    return bests;
  }
  
  public MultilayerPerceptron mate(MultilayerPerceptron father, MultilayerPerceptron mother){
    ArrayList<ArrayList<ArrayList<Float>>> newWeights = new ArrayList<ArrayList<ArrayList<Float>>>();
    
    // Chance to inherit neuron input weights from father
    float percentage = random(0,1);
    
    // Iterate layers
    for(int i = 0; i < father.getWeights().size(); i++) {
      newWeights.add(new ArrayList<ArrayList<Float>>());
      
      // Iterate neurons
      for (int j = 0; j < father.getWeights().get(i).size(); j++){
        newWeights.get(i).add(new ArrayList<Float>());
        
        // Iterate neuron inputs
        for (int k = 0; k < father.getWeights().get(i).get(j).size(); k++){
          //println(i, j, k);
          percentage = random(0,1);
          
          // Calculate average weight
          float weight = (father.getWeights().get(i).get(j).get(k) * (percentage)) + (mother.getWeights().get(i).get(j).get(k) * (1-percentage));
          //float weight = father.getWeights().get(i).get(j).get(k);
          
          // Mutation
          if(random(0, 1) < this.mutationRate){
            weight += random(-3, 3);
          }
          
          // Set new weight
          newWeights.get(i).get(j).add(k, weight);
        }
      }
    }
    
    // Create new individual and set weights
    MultilayerPerceptron result = new MultilayerPerceptron(6, new ArrayList<Integer>(Arrays.asList(8, 4)));
    result.setWeights(newWeights);
    
    return result;
  }
  
  public MultilayerPerceptron mutatedClone(MultilayerPerceptron father){
    ArrayList<ArrayList<ArrayList<Float>>> newWeights = new ArrayList<ArrayList<ArrayList<Float>>>();
    
    for(int i = 0; i < father.getWeights().size(); i++) {
      newWeights.add(new ArrayList<ArrayList<Float>>());
      
      for (int j = 0; j < father.getWeights().get(i).size(); j++){
        newWeights.get(i).add(new ArrayList<Float>());
        
        for (int k = 0; k < father.getWeights().get(i).get(j).size(); k++){
          //println(i, j, k);
          
          // Calculate average weight
          float weight = father.getWeights().get(i).get(j).get(k);
          
          // Mutation
          if(random(0, 1) < this.mutationRate){
            weight = +random(-10, 10);
          }
          
          // Set new weight
          newWeights.get(i).get(j).add(k, weight);
        }
      }
    }
    
    // Create new individual and set weights
    MultilayerPerceptron result = new MultilayerPerceptron(6, new ArrayList<Integer>(Arrays.asList(8, 4)));
    result.setWeights(newWeights);
    
    return result;
  }
  
  public void runGA(){
    // When run ends
    if(this.runIndividual(this.population.get(indIndex))){
      println("\tPerformance of individual " + Integer.toString(this.indIndex) + ": " + Integer.toString(this.fitness(this.game))); 
      
      // If beats high score
      if(this.fitness(this.game) > this.bestFitness){
        // Save individuals score and gene
        this.bestFitness = this.fitness(this.game);
        this.generationBest = indIndex;
      }
      
      // Save fitness
      this.population.get(indIndex).setFitness(this.fitness(this.game));
      
      // Restart game and update index
      this.game.restart();
      this.indIndex++;
      
      // If run all individuals, go to next generation
      if(this.indIndex >= this.individualsPerGeneration){
        // Update variables
        this.genIndex++;
        this.indIndex = 0;
        print("Generation best: " + Integer.toString(this.generationBest));
        
        // Update population
        this.population = this.generatePopulation(this.population);
        this.generationBest = 0;
        this.bestFitness = 0;
        
        // Check for predation
        if(random(0,1) < this.predationChance){
          // Generate random death chance
          float deathChance = random(0.1, 0.9);
          int deathCounter = 0;
           
          // Iterate individuals
          for(int i = 0; i < this.population.size(); i++){
            
            // If individual died
            if(random(0,1) < deathChance){
              
              // Replace by new random
              this.population.set(i, new MultilayerPerceptron(6, new ArrayList<Integer>(Arrays.asList(8, 4))));
              deathCounter++;
            }
          }
          
          println("\n PREDATION OCCURED!! " + Integer.toString(deathCounter) + " individuals died :c");
        }
        
        println("\nRunning genaration " + Integer.toString(this.genIndex));
      }
    }
  }
  
  public int fitness(Game game){
    // Gaussian function to calc steps: starts at 0.16 at x=0, get to peak (1) at x=300, and decays rapidly after that (to decrease fitness from snakes stuck in a loop) 
    float gauss = exp(-pow((game.getTickCounter()-300), 2)/ 50000);
    float stepsFitness = 250 * gauss;
    
    // Exponential function to score: 100 for one food eaten, 850 for two, 1560 for three, etc
    int foodFitness = 100* ((int) pow(game.getScore(), 1.5));
    
    
    return foodFitness + (int) stepsFitness;
    
  }
  
  public void draw(){
    this.game.draw();
    
    // Draw score
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(16);
    text("Generation best: " + Integer.toString(this.bestFitness), 40, 10);
    
    // Draw fitness
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(16);
    text("Current fitness: " + Integer.toString(this.currFitness), 250, 10);
    
    // Draw individual
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(16);
    text("Individual: " + Integer.toString(this.indIndex+1), 500, 10);
    
    // Draw generation
    fill(255);
    textAlign(LEFT, CENTER);
    textSize(16);
    text("Generation: " + Integer.toString(this.genIndex+1), 650, 10);
  }
  
}
