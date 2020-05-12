# executar os outros dois scripts
# processing.R
# series.R

# Basicamente desenvolvi funções para consultar o MongoDB
# recuperar as leituras e criar uma curva média (parametrizável)

# Agora, o foco é comparar diferentes dias e observar graficamente os padrões

data <- smoothed_data('2020-05-05', '2020-05-06', 0.3)

ggplot(data = data) + 
  geom_line(mapping = aes(x = stamps, y = watts)) + 
  geom_line(mapping = aes(x = stamps, y = smoothed), color = 'red')