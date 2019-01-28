import pydot
import os
os.environ["PATH"] += os.pathsep + 'C:/Program Files (x86)/Graphviz2.38/bin/'

graph = pydot.Dot(graph_type='graph', strict=True, nodsep=2)

file = open("C:/scripts_power/txts/PG.txt","r")
DN = file.read().splitlines()
edge = pydot.Edge("DC=net","DC=consalud")
graph.add_edge(edge)

for linea in DN:
    elemento = linea.split(",")
    #del elemento[0]
    for a in range(len(elemento)-2):
        edge = pydot.Edge(elemento[a+1],elemento[a])
        graph.add_edge(edge)

graph.write_png('PG_consalud.png')
