# executar os outros dois scripts
# processing.R
# series.R

# Basicamente desenvolvi funções para consultar o MongoDB
# recuperar as leituras e criar uma curva média (parametrizável)

# Agora, o foco é comparar diferentes dias e observar graficamente os padrões

# Dias da semana (weekdays) - normais, sem feriado

april_16 <- smoothed_data('2020-04-16', '2020-04-17', 0.3)
april_17 <- smoothed_data('2020-04-17', '2020-04-18', 0.3)
april_20 <- smoothed_data('2020-04-20', '2020-04-21', 0.3)
april_22 <- smoothed_data('2020-04-22', '2020-04-23', 0.3)
april_23 <- smoothed_data('2020-04-23', '2020-04-24', 0.3)
april_24 <- smoothed_data('2020-04-24', '2020-04-25', 0.3)
april_27 <- smoothed_data('2020-04-27', '2020-04-28', 0.3)
april_28 <- smoothed_data('2020-04-28', '2020-04-29', 0.3)
april_29 <- smoothed_data('2020-04-29', '2020-04-30', 0.3)
april_30 <- smoothed_data('2020-04-30', '2020-05-01', 0.3)

may_04 <- smoothed_data('2020-05-04', '2020-05-05', 0.3)
may_05 <- smoothed_data('2020-05-05', '2020-05-06', 0.3)
may_06 <- smoothed_data('2020-05-06', '2020-05-07', 0.3)
may_07 <- smoothed_data('2020-05-07', '2020-05-08', 0.3)
may_08 <- smoothed_data('2020-05-08', '2020-05-09', 0.3)
may_11 <- smoothed_data('2020-05-11', '2020-05-12', 0.3)
may_12 <- smoothed_data('2020-05-12', '2020-05-13', 0.3)
may_13 <- smoothed_data('2020-05-13', '2020-05-14', 0.3)
may_14 <- smoothed_data('2020-05-14', '2020-05-15', 0.3)
may_15 <- smoothed_data('2020-05-15', '2020-05-16', 0.3)

# os dados dos últimos 5 dias serão implementados quando encerrarem as medições

apr16 <- ggplot() + geom_line(data = april_16, mapping = aes(x = stamps, y = smoothed))
apr17 <- ggplot() + geom_line(data = april_17, mapping = aes(x = stamps, y = smoothed))
apr20 <- ggplot() + geom_line(data = april_20, mapping = aes(x = stamps, y = smoothed))
apr22 <- ggplot() + geom_line(data = april_22, mapping = aes(x = stamps, y = smoothed))
apr23 <- ggplot() + geom_line(data = april_23, mapping = aes(x = stamps, y = smoothed))
apr24 <- ggplot() + geom_line(data = april_24, mapping = aes(x = stamps, y = smoothed))
apr27 <- ggplot() + geom_line(data = april_27, mapping = aes(x = stamps, y = smoothed))
apr28 <- ggplot() + geom_line(data = april_28, mapping = aes(x = stamps, y = smoothed))
apr29 <- ggplot() + geom_line(data = april_29, mapping = aes(x = stamps, y = smoothed))
apr30 <- ggplot() + geom_line(data = april_30, mapping = aes(x = stamps, y = smoothed))
may04 <- ggplot() + geom_line(data = may_04, mapping = aes(x = stamps, y = smoothed))
may05 <- ggplot() + geom_line(data = may_05, mapping = aes(x = stamps, y = smoothed))
may06 <- ggplot() + geom_line(data = may_06, mapping = aes(x = stamps, y = smoothed))
may07 <- ggplot() + geom_line(data = may_07, mapping = aes(x = stamps, y = smoothed))
may08 <- ggplot() + geom_line(data = may_08, mapping = aes(x = stamps, y = smoothed))
may11 <- ggplot() + geom_line(data = may_11, mapping = aes(x = stamps, y = smoothed))
may12 <- ggplot() + geom_line(data = may_12, mapping = aes(x = stamps, y = smoothed))
may13 <- ggplot() + geom_line(data = may_13, mapping = aes(x = stamps, y = smoothed))
may14 <- ggplot() + geom_line(data = may_14, mapping = aes(x = stamps, y = smoothed))
may15 <- ggplot() + geom_line(data = may_15, mapping = aes(x = stamps, y = smoothed))

# Sábados, domingos e feriados  

april_18 <- smoothed_data('2020-04-18', '2020-04-19', 0.3)
april_19 <- smoothed_data('2020-04-19', '2020-04-20', 0.3)
april_21 <- smoothed_data('2020-04-21', '2020-04-22', 0.3)
april_25 <- smoothed_data('2020-04-25', '2020-04-26', 0.3)
april_26 <- smoothed_data('2020-04-26', '2020-04-27', 0.3)
may_01 <- smoothed_data('2020-05-01', '2020-05-02', 0.3)
may_02 <- smoothed_data('2020-05-02', '2020-05-03', 0.3)
may_03 <- smoothed_data('2020-05-03', '2020-05-04', 0.3)
may_09 <- smoothed_data('2020-05-09', '2020-05-10', 0.3)
may_10 <- smoothed_data('2020-05-10', '2020-05-11', 0.3)

apr18 <- ggplot() + geom_line(data = april_18, mapping = aes(x = stamps, y = smoothed))
apr19 <- ggplot() + geom_line(data = april_19, mapping = aes(x = stamps, y = smoothed))
apr21 <- ggplot() + geom_line(data = april_21, mapping = aes(x = stamps, y = smoothed))
apr25 <- ggplot() + geom_line(data = april_25, mapping = aes(x = stamps, y = smoothed))
apr26 <- ggplot() + geom_line(data = april_26, mapping = aes(x = stamps, y = smoothed))
may01 <- ggplot() + geom_line(data = may_01, mapping = aes(x = stamps, y = smoothed))
may02 <- ggplot() + geom_line(data = may_02, mapping = aes(x = stamps, y = smoothed))
may03 <- ggplot() + geom_line(data = may_03, mapping = aes(x = stamps, y = smoothed))
may09 <- ggplot() + geom_line(data = may_09, mapping = aes(x = stamps, y = smoothed))
may10 <- ggplot() + geom_line(data = may_10, mapping = aes(x = stamps, y = smoothed))

# construção da tabela consolidada de padrões

a16 <- transpose(april_16)
a17 <- transpose(april_17)
a18 <- transpose(april_18)
a19 <- transpose(april_19)
a20 <- transpose(april_20)
a21 <- transpose(april_21)
a22 <- transpose(april_22)
a23 <- transpose(april_23)
a24 <- transpose(april_24)
a25 <- transpose(april_25)
a26 <- transpose(april_26)
a27 <- transpose(april_27)
a28 <- transpose(april_28)
a29 <- transpose(april_29)
a30 <- transpose(april_30)
m01 <- transpose(may_01)
m02 <- transpose(may_02)
m03 <- transpose(may_03)
m04 <- transpose(may_04)
m05 <- transpose(may_05)
m06 <- transpose(may_06)
m07 <- transpose(may_07)
m08 <- transpose(may_08)
m09 <- transpose(may_09)
m10 <- transpose(may_10)
m11 <- transpose(may_11)
m12 <- transpose(may_12)
m13 <- transpose(may_13)
m14 <- transpose(may_14)
m15 <- transpose(may_15)

patterns <- rbind(a16,
                  a17,
                  a18,
                  a19,
                  a20,
                  a21,
                  a22,
                  a23,
                  a24,
                  a25,
                  a26,
                  a27,
                  a28,
                  a29,
                  a30,
                  m01,
                  m02,
                  m03,
                  m04,
                  m05,
                  m06,
                  m07,
                  m08,
                  m09,
                  m10,
                  m11,
                  m12,
                  m13,
                  m14,
                  m15)

# adicionando as datas observadas

dates <- c('2020-04-16','2020-04-17','2020-04-18','2020-04-19','2020-04-20',
           '2020-04-21','2020-04-22','2020-04-23','2020-04-24','2020-04-25',
           '2020-04-26','2020-04-27','2020-04-28','2020-04-29','2020-04-30',
           '2020-05-01','2020-05-02','2020-05-03','2020-05-04','2020-05-05',
           '2020-05-06','2020-05-07','2020-05-08','2020-05-09','2020-05-10',
           '2020-05-11','2020-05-12','2020-05-13','2020-05-14','2020-05-15')

patterns <- cbind(patterns, dates)
patterns <- as_tibble(patterns)

write.csv(patterns, './patterns.csv')









  