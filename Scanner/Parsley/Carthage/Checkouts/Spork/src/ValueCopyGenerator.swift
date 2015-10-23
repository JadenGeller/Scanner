
// Automatically forks a generator on copy
struct ValueCopyGenerator<Element>: GeneratorType {
    private var backing: ForkableGenerator<Element>
    
    init(_ backing: ForkableGenerator<Element>) {
        self.backing = backing
    }
    
    // Note that it is illegal to call next on a generator after bridging it
    init<G: GeneratorType where G.Element == Element>(bridgedFromGenerator generator: G) {
        backing = ForkableGenerator(bridgedFromGenerator: generator)
    }
    
    mutating func next() -> Element? {
        if !isUniquelyReferencedNonObjC(&backing) { backing = backing.fork() }
        return backing.next()
    }
}
