import Foundation
import QuartzCore

struct Route {
    let dest: Int
    let cost: Int
}

struct Node {
    var neighbours: [Route] = []
}

func readPlaces() -> [Node] {
    var result: [Node] = []
    if let data = NSString(contentsOfFile: "agraph", encoding: NSUTF8StringEncoding, error: nil) {
        let str = data as String
        
        str.enumerateLines {
            (line, stop) in
            result = Array(count: line.toInt() ?? 0, repeatedValue: Node())
            stop = true
        }
        str.enumerateLines {
            (line, stop) in
            let components = line.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if components.count < 2 { return }
            switch (components[0].toInt(), components[1].toInt(), components[2].toInt()) {
            case let (.Some(node), .Some(dest), .Some(cost)):
                result[node].neighbours.append(Route(dest: dest, cost: cost))
            default:
                break
            }
        }
    }
    return result
}

func getLongestPath(nodes: [Node], nodeId: Int, inout visited: [Bool]) -> Int {
    visited[nodeId] = true
    var max = 0
    for neighbour in nodes[nodeId].neighbours {
        if !visited[neighbour.dest] {
            let dist = neighbour.cost + getLongestPath(nodes, neighbour.dest, &visited)
            if dist > max {
                max = dist
            }
        }
    }
    visited[nodeId] = false
    return max
}

func getLongestPath(nodes: [Node]) -> Int {
    var visited = Array<Bool>(count: nodes.count, repeatedValue: false)
    return getLongestPath(nodes, 0, &visited)
}

let nodes = readPlaces()
let startTime = CACurrentMediaTime()
let length = getLongestPath(nodes)
let endTime = CACurrentMediaTime()
let ms = Int((endTime - startTime)*1000)
println("\(length) LANGUAGE Swift \(ms)")