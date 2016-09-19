

# Libraries ---------------------------------------------------------------

library(RNeo4j)
library(data.table)
library(visNetwork)



# Initialisation ----------------------------------------------------------

graph = startGraph("http://localhost:7474/db/data", username = "neo4j", password = "0000")
clear(graph, input = F)

# acteurs :
persons = data.table(idPerson = 1:10, namePerson = LETTERS[1:10])

# films :
movies = data.table(idMovie = 1:10, nameMovie = paste("movie ", LETTERS[16:25]))

# roles :
roles = data.table(
  idPerson = c(1, 2, 2, 4, 5, 3),
  idMovie  = c(1, 2, 3, 2, 4, 6),
  role   = c("ACTED", "DIRECTED"))

data = merge(merge(roles, persons, by = "idPerson"), movies, by = "idMovie")

# Import ------------------------------------------------------------------

addConstraint(graph, "Person", "name")
addConstraint(graph, "Movie", "name")

query = "
MERGE (person:Person {name:{namePerson}})
MERGE (movie:Movie {name:{nameMovie}})
MERGE (person)-[:%s]->(movie)
"

tx = newTransaction(graph)
for(i in seq_len(nrow(data))){
  
  queryToAdd = sprintf(query, data[i, role])
  cat(queryToAdd)
  
  appendCypher(tx,
               queryToAdd,
               namePerson = data[i, namePerson],
               nameMovie  = data[i, nameMovie]
               )
}

commit(tx)


# Test visNetwork ---------------------------------------------------------


req_nodes = "
MATCH (n) 
RETURN
  ID(n) AS id,
  n.name AS label,
  LABELS(n)[0] AS group
"
res_nodes = cypher(graph, req_nodes)

req_relation = "
MATCH (n)-[r]->(m)
RETURN
  ID(n) AS from,
  ID(m) AS to,
  TYPE(r) AS label
"

res_relation = cypher(graph, req_relation)


visNetwork(res_nodes, res_relation) %>%
  visOptions(nodesIdSelection = T)






