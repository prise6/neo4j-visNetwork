

library(data.table)

# connexion neo4j ---------------------------------------------------------

graph = startGraph("http://localhost:7474/db/data", username = "neo4j", password = "0000")
# clear(graph, input = F)
# importSample(graph, "movies", input = F)


# Nodes -------------------------------------------------------------------

req_nodes_Person = "
MATCH (n:Person) 
RETURN
  ID(n) AS id,
  n.name AS label,
  LABELS(n)[0] AS group
"

nodes_Person = data.table(cypher(graph, req_nodes_Person))

req_nodes_Movie = "
MATCH (n:Movie) 
RETURN
  ID(n) AS id,
  n.title AS label,
  LABELS(n)[0] AS group
"

nodes_Movie = data.table(cypher(graph, req_nodes_Movie))

nodes = rbindlist(list(nodes_Person, nodes_Movie))


# Relationship ------------------------------------------------------------

req_relation = "
MATCH (n:Person)-[r]->(m:Movie)
RETURN
  ID(n) AS from,
  ID(m) AS to,
  TYPE(r) AS label
LIMIT 30
"

relations = data.table(cypher(graph, req_relation))
# relations[, value := floor(runif(nrow(relations), min = 0, max = 10))]

# n = 20
# nodes <- data.table(id = 1:n, label = paste("Label", 1:n),
                    # group = sample(LETTERS[1:3], n, replace = TRUE))
# 
# relations <- data.table(id = 1:n, from = trunc(runif(n)*(n-1))+1,
                    # to = trunc(runif(n)*(n-1))+1)


# Var globale -------------------------------------------------------------

choix_person = nodes$id
names(choix_person) = nodes$label


