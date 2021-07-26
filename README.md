# Evolving snakes
O projeto se propõe a desenvolver um sistema evolutivo que atualiza os pesos de uma rede neural Multilayer Perceptron, com o objetivo de atingir a maior pontuação possível no jogo _snake_.



## Vídeo explicativo
 - Em desenvolvimento



## Funcionamento

### Regras do jogo
As regras do jogo são as mesmas regras conhecidas do famoso jogo _snake_, porém com o diferencial de um fator "fome", onde a cobra não pode ficar mais que uma quantidade de passos sem obter uma comida, se não ela morre. A regra foi criada principalmente para evitar que cobras evoluam para ficar rodando em _loop_ indefinidamente.

### Snake
A cobra foi tratada como um robô, onde ela não possui uma visão universal do campo. Os únicos dados que ela possui para interpretar são a distância para um obstáculo (paredes ou o próprio corpo) nas quatro direções principais (cima, baixo, esquerda e direita), e a distância em X e Y para a comida, totalizando 6 variáveis.


### Rede neural
A rede neural escolhida foi uma Multilayer Perceptron de duas camadas (desconsiderando os neurônios de entrada, que não tem processamento), consistindo em um hidden layer de 8 neurônios e um layer de saída com 4 neurônios (cada um representando uma direção que a cobra pode ir: cima, baixo, esquerda, e direita). A entrada do sistema serão as 6 variáveis sensoriais da cobra:
  - Distância até obstáculo em cima
  - Distância até obstáculo embaixo
  - Distância até obstáculo na esquerda
  - Distância até obstáculo na direita
  - Distância até a comida em X
  - Distância até a comida em Y

Com isso, possue-se um total de 80 parâmetros treináveis (48 pesos entre o layer de entrada e o hidden layer, e 32 entre o hidden layer e o layer de saída).

### Sistema evolutivo
O sistema evolutivo consiste em inicialmente gerar aleatóriamente uma população de 500 indivíduos, onde cada indivíduo é uma Multilayer Perceptron gerada com pesos aleatórios no range (-10,10). O jogo é controlado por um indivíduo, realizando a operação de _feedforward_ na MultilayerPerceptron pelos sensores da cobra, e utilizando sua saída como a próxima direção da cobra. Ao morrer, passa-se a vez para o próximo indivíduo.

No fim da geração, os melhores indivíduos são selecionados para se reproduzirem, gerando filhos que formarão a próxima geração. Os melhores indivíduos também são mantidos na próxima geração.

#### Fitness
O desempenho de cada indivíduo é medido por uma função fitness, que possui como parâmetros sua pontuação no jogo e a quantidade de passos dados (que é resetada ao comer uma comida).

A função criada foi:
fitness = 100 * ((int) _score_^1.5)  +  250 * exp(-((_steps_-300)^2)) / 50000)

O primeiro termo da função é a pontuação elevada a 1.5 e multiplicada por 100, e o segundo termo é uma gaussiana com centro em 300 e _spread_ de 50000. A movivação da gaussiana foi que os indivíduos precisavam ser recompensados por sobreviverem (desviarem de obstáculos), tendo então um comportamento crescente até 300 passos. Porém, ao se passarem 300 passos sem obter comida, provavelmente o indivíduo está preso em um _loop_, e seu fitness será diminuído. Esse decaimento a partir de 300 passos também ajuda a criar indivíduos mais eficientes em ir atrás da comida.
O termo relativo à pontuação é exponencial pois as primeiras comidas obtidas não significavam muito como bom desempenho, já que foi observado que muitas cobras obtinham uma ou até duas comidas apenas ao acaso, e morrendo logo em seguida. Desse modo, foi criado um sistema que recompensa exploração e sobrevivência nas primeiras gerações, mas ainda mantendo comida como uma prioridade por ser um fator exponencial.

#### Seleção
A seleção de melhores indivíduos é feita escolhendo os X melhores indivíduos, onde X é a raiz quadrada da quantidade de indivíduos por geração somada de um. Para cada reprodução, são escolhidos dois indivíduos aleatórios dentre os melhores, formando um filho que entra para a próxima geração.

#### Crossover
A reprodução é feita utilizando um dos diversos algorítmo de crossover, o crossover por média: o indivíduo filho é gerado realizando uma média de cada peso do pai e da mãe. Porém, nesta implementação foi utilizada uma média ponderada, onde a ponderação é gerada aleatóriamente. Deste modo, cada reprodução pode fazer com que o filho "puxe" mais para o pai, para a mãe, ou um equilíbrio.

#### Mutação
A mutação foi implementada como uma chance de se somar ou subtrair um fator durante o cálculo de cada peso durante a reprodução. Após realizar a média ponderada para encontrar cada um dos pesos do filho, existe uma chance baixa de ser somado um fator aleatório ao peso, no range (-10,10). Deste modo, seria possível obter pesos com valores acima do range inicial, que também é (-10, 10).
