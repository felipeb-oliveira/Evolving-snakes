class Neuron{
  float input;
  float output;
  public Neuron(){
    this.input = 0;
    this.output = 0;
  }
  
  public float process(float input){
    this.input = input;
    this.output = this.activationFunction(input);
    return this.output;
  }
  
  private float activationFunction(float x){
    // Logistic function
    return 1 / (1 + exp(-x)); 
  }
  
  public void draw(int x, int y){
    fill(0, 0, 255 - (255*this.output));
    ellipse(x, y, 40, 40);
    
    fill(255);
    textSize(16);
    textAlign(CENTER, CENTER);
    text(Float.toString(this.input), x, y);
  }
}

class Layer{
  ArrayList<Neuron> neurons;
  ArrayList<ArrayList<Float>> weights;
  
  public Layer(int numNeurons, int numInputs){
    // Initialize variables
    this.neurons = new ArrayList<Neuron>();
    this.weights = new ArrayList<ArrayList<Float>>();
    
    // Iterate neurons
    for(int i = 0; i < numNeurons; i++){
      // Add neuron
      this.neurons.add(new Neuron());
      
      // Add weights
      this.weights.add(new ArrayList<Float>());
      
      // Iterate inputs and add bias
      for(int j = 0; j < numInputs+1; j++){
        // Initialize weights as random
        this.weights.get(i).add(random(-10, 10));
      }
    }
  }
  
  public ArrayList<Float> feed(ArrayList<Float> inputs){
    // Output variable
    ArrayList<Float> out = new ArrayList<Float>();
    
    // Iterate neurons
    for(int i = 0; i < this.weights.size(); i++){
      float currIn = 0.0;
      
      // Iterate neuron inputs
      for(int j = 0; j < this.weights.get(i).size()-1; j++){
        
        // Add input multiplied by respective weight
        currIn += this.weights.get(i).get(j) * inputs.get(j);
      }
      
      // Add bias
      currIn += this.weights.get(i).get(this.weights.get(i).size()-1);
      
      // Process neuron and append result to output array
      out.add(this.neurons.get(i).process(currIn));
    }
    
    return out;
  }
  
  public void updateWeights(ArrayList<ArrayList<Float>> newWeights){
    this.weights = newWeights;  
  }
  
  public ArrayList<ArrayList<Float>> getWeights(){
    return this.weights;  
  }
}


class MultilayerPerceptron {
  ArrayList<Layer> layers;
  ArrayList<Integer> neuronsPerLayer;
  int numInputs;
  int fitness;
  
  public MultilayerPerceptron(int numInputs, ArrayList<Integer> neuronsPerLayer){
    // Init variables
    this.layers = new ArrayList<Layer>();
    this.neuronsPerLayer = neuronsPerLayer;
    this.numInputs = numInputs;
    
    // Add first layer
    layers.add(new Layer(neuronsPerLayer.get(0), numInputs));
    
    // Add other layers
    for(int i = 1; i < neuronsPerLayer.size(); i++) {
      layers.add(new Layer(neuronsPerLayer.get(i), neuronsPerLayer.get(i-1))); 
    }
  }
  
  public ArrayList<ArrayList<ArrayList<Float>>> getWeights(){
    ArrayList<ArrayList<ArrayList<Float>>> allWeights = new ArrayList<ArrayList<ArrayList<Float>>>();
    
    for(int i = 0; i < neuronsPerLayer.size(); i++){
      allWeights.add(this.layers.get(i).getWeights());  
    }
    
    return allWeights;
  }
  
  public void setWeights(ArrayList<ArrayList<ArrayList<Float>>> weights){
    for(int i = 0; i < neuronsPerLayer.size(); i++){
      this.layers.get(i).updateWeights(weights.get(i));  
    }
  }
  
  public int feed(ArrayList<Float> inputs){
    // Feed first layer
    ArrayList<Float> lastOutput = this.layers.get(0).feed(inputs);
    
    // Feed next layers with previous layer's output
    for(int i = 1; i < this.neuronsPerLayer.size(); i++){
      lastOutput = this.layers.get(i).feed(lastOutput);
    }
    
    // Get highest output index
    int index = 0;
    for(int i = 1; i < this.neuronsPerLayer.get(this.neuronsPerLayer.size()-1); i++){
      if(lastOutput.get(i) > lastOutput.get(index)){
        index = i;  
      }  
    }
    
    return index;
    
  }
  
  public void setFitness(int fit){
    // Store fitness
    this.fitness = fit;
  }
  
  public int getFitness(){
    return this.fitness;
  }
  
  public void draw(){
    
    
  }
}
