# Evolving snakes
O projeto se propõe a desenvolver um sistema evolutivo que atualiza os pesos de uma rede neural Multilayer Perceptron, com o objetivo de atingir a maior pontuação possível no jogo _snake_.



## Vídeo explicativo
 - https://drive.google.com/file/d/1TVKZEUcXsYUw0liysbAioIkJL7dqj0qF/view?usp=sharing


## Funcionamento

### Regras do jogo
As regras do jogo são as mesmas regras conhecidas do famoso jogo _snake_, porém com o diferencial de um fator "fome", onde a cobra não pode ficar mais que uma quantidade de passos sem obter uma comida, se não ela morre. A regra foi criada principalmente para evitar que cobras evoluam para ficar rodando em _loop_ indefinidamente.

### Snake
A cobra foi tratada como um robô, onde ela não possui uma visão universal do campo. Os únicos dados que ela possui para interpretar são a distância para um obstáculo (paredes ou o próprio corpo) nas três direções principais (frente, esquerda, e direita), e a distância em X e Y para a comida (em relação à sua direção), totalizando 5 variáveis.


### Rede neural
A rede neural escolhida foi uma Multilayer Perceptron de duas camadas (desconsiderando os neurônios de entrada, que não tem processamento), consistindo em um hidden layer de 8 neurônios e um layer de saída com 3 neurônios (cada um representando uma direção que a cobra pode ir: seguir em frente, virar para esquerda, ou virar para direita). A entrada do sistema serão as 5 variáveis sensoriais da cobra:
  - Distância até obstáculo em frente
  - Distância até obstáculo à esquerda
  - Distância até obstáculo à direita
  - Distância até a comida em X (sendo X o vetor apontando para a esquerda da cobra)
  - Distância até a comida em Y (sendo Y o vetor apontando para a direita da cobra)

Com isso, possue-se um total de 64 parâmetros treináveis (40 pesos entre o layer de entrada e o hidden layer, e 24 entre o hidden layer e o layer de saída).

### Sistema evolutivo
O sistema evolutivo consiste em inicialmente gerar aleatóriamente uma população de 500 indivíduos, onde cada indivíduo é uma Multilayer Perceptron gerada com pesos aleatórios no range (-10,10). O jogo é controlado por um indivíduo, realizando a operação de _feedforward_ na MultilayerPerceptron pelos sensores da cobra, e utilizando sua saída como a próxima direção da cobra. Ao morrer, passa-se a vez para o próximo indivíduo.

No fim da geração, os melhores indivíduos são selecionados para se reproduzirem, gerando filhos que formarão a próxima geração. Os melhores indivíduos também são mantidos na próxima geração.

#### - Fitness
O desempenho de cada indivíduo é medido por uma função fitness, que possui como parâmetros sua pontuação no jogo e a quantidade de passos dados (que é resetada ao comer uma comida).

A função criada foi:
fitness = 200 * ((int) _score_^1.5)  +  100 * exp(-((_steps_-200)^2)) / 25000)

O primeiro termo da função é a pontuação elevada a 1.5 e multiplicada por 100, e o segundo termo é uma gaussiana com centro em 200 e _spread_ de 25000. A movivação da gaussiana foi que os indivíduos precisavam ser recompensados por sobreviverem (desviarem de obstáculos), tendo então um comportamento crescente até 200 passos. Porém, ao se passarem esses 200 passos sem obter comida (onde provavelmente o indivíduo está preso em um _loop_), e seu fitness será diminuído. Esse decaimento a partir de 200 passos também ajuda a criar indivíduos mais eficientes em ir atrás da comida.
O termo relativo à pontuação é exponencial pois as primeiras comidas obtidas não significavam muito como bom desempenho, já que foi observado que muitas cobras obtinham uma ou até duas comidas apenas ao acaso, e morrendo logo em seguida. Desse modo, foi criado um sistema que recompensa exploração e sobrevivência nas primeiras gerações, mas ainda mantendo comida como uma prioridade por ser um fator exponencial.

#### - Seleção
A seleção de melhores indivíduos é feita escolhendo os X melhores indivíduos, onde X é a raiz quadrada da quantidade de indivíduos por geração somada de um. Para cada reprodução, é escolhido um indivíduo aleatório dentre os melhores e um indivíduo aleatório entre a população inteira, formando um filho que entra para a próxima geração. Vale notar que algumas reproduções são obrigatóriamente feitas com o melhor indivíduo.

#### - Crossover
A reprodução é feita utilizando um dos diversos algorítmo de crossover: cada peso do indivíduo filho é gerado escolhendo o respectivo peso do pai ou da mãe (aleatoriamente). Deste modo, cada reprodução gera um filho com diversidade muito alta, não apenas obtendo funcionalidades do pai ou da mãe, mas como também criando comportamentos novos (representados por neurônios onde os pesos de entrada são misturados entre o pai e a mãe).

#### - Mutação
A mutação foi implementada como uma chance de se somar ou subtrair um fator durante o cálculo de cada peso durante a reprodução. Após realizar a média ponderada para encontrar cada um dos pesos do filho, existe uma chance baixa de ser somado um fator aleatório ao peso, no range (-10,10). Deste modo, seria possível obter pesos com valores acima do range inicial, que também é (-10, 10).
