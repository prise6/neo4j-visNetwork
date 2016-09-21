

library(data.table)


# Datas -------------------------------------------------------------------


relations = data.table(
  from = c("A", "A", "B", "C"),
  to = c("C", "D", "B", "E"),
  label  = c("TYPE_1", "TYPE_1", "TYPE_2", "TYPE_3"),
  width  = sample(x = 1:10, size = 4, replace = T),
  hoverWidth = "0.5",
  `font.size` = "10",
  `font.align` = "middle",
  `font.strokeWidth` = "0",
  `color.highlight` = c("red", "red", "green", "blue"),
  `color.opacity` = 1
)


nodes = data.table(
  id = unique(c(relations$from, relations$to))
)
nodes$label = nodes$id
nodes$`font.size` = rep("15", nrow(nodes))
nodes$`shape` = rep("circle", nrow(nodes))
nodes$`size` = rep("25", nrow(nodes))



# Var globale -------------------------------------------------------------

choix_entity = nodes$id
names(choix_entity) = nodes$label

choix_relations = relations$label
names(choix_relations) = relations$label
