final class AnyForkableGenerator<Element>: ForkableGeneratorType {
    let _next: () -> Element?
    let _fork: () -> AnyForkableGenerator
    
    private init(next: () -> Element?, fork: () -> AnyForkableGenerator) {
        _next = next
        _fork = fork
    }
    
    func fork() -> AnyForkableGenerator<Element> {
        return _fork()
    }
    
    func next() -> Element? {
        return _next()
    }
}

func anyForkableGenerator<G: ForkableGeneratorType>(var base: G) -> AnyForkableGenerator<G.Element> {
    return AnyForkableGenerator(next: { base.next() }, fork: { anyForkableGenerator(base.fork()) })
}

func anyForkableGenerator<State, Element>(var state: State, duplicate: State -> State, next: inout State -> Element?) -> AnyForkableGenerator<Element> {
    return AnyForkableGenerator(next: { next(&state) }, fork: { anyForkableGenerator(duplicate(state), duplicate: duplicate, next: next) })
}