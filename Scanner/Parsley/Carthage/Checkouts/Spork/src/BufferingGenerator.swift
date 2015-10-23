// Allows any generator (even one that normally has reference-like semantics) to be forked
final class BufferingGenerator<Element>: ForkableGeneratorType {
    private let state: SharedGeneratorBufferState<Element>
    
    // Note that it is illegal to call next on a generator after bridging it
    init<G: GeneratorType where G.Element == Element>(bridgedFromGenerator generator: G) {
        state = SharedGeneratorBufferState(backing: generator)
        state.registerListener(self)
    }
    
    private init(state: SharedGeneratorBufferState<Element>, offset: Int) {
        self.state = state
        state.setFallbehind(offset, forListener: self)
    }
    
    func next() -> Element? {
        defer { state.decrementFallbehind(forListener: self) }
        return peek()
    }
    
    func peek() -> Element? {
        return state.element(forListener: self)
    }
    
    func fork() -> BufferingGenerator<Element> {
        return BufferingGenerator(state: state, offset: state.getFallbehind(forListener: self)!)
    }
    
    deinit {
        state.deregisterListener(self)
    }
}

// Shared state that keeps elements in its buffer only if they'll be needed
private final class SharedGeneratorBufferState<Element> {
    private var generator: AnyGenerator<Element>
    private var buffer: [Element?] = [] // Rightmost values are the oldest
    
    init<G: GeneratorType where G.Element == Element>(backing: G) {
        generator = anyGenerator(backing)
    }
    
    // Represents negative buffer index of last requested element
    var listenerFallbehinds: [ObjectIdentifier : Int] = [:]
    
    var maxFallbehind: Int {
        return buffer.count - 1
    }
    
    typealias Listener = BufferingGenerator<Element>
    
    func getFallbehind(forListener listener: Listener) -> Int? {
        return listenerFallbehinds[ObjectIdentifier(listener)]
    }
    func setFallbehind(fallbehind: Int?, forListener listener: Listener, trimmingBuffer: Bool = true) {
        if let fallbehind = fallbehind {
            assert(fallbehind <= maxFallbehind, "Cannot set buffer fallbehind past that of disposed element.")
            listenerFallbehinds[ObjectIdentifier(listener)] = fallbehind
        } else {
            listenerFallbehinds.removeValueForKey(ObjectIdentifier(listener))
        }
        if trimmingBuffer { trimBuffer() } // Drop any elements that only this listener needed
    }
    
    func registerListener(listener: Listener) {
        setFallbehind(-1, forListener: listener)
    }
    
    func deregisterListener(listener: Listener) {
        setFallbehind(nil, forListener: listener)
    }
    
    func ensureBufferContainsElement(forListener listener: Listener) {
        // Request next element and ensure its in the buffer
        while getFallbehind(forListener: listener) < 0 {
            // Update offsets since we're shifting the buffer
            for (key, value) in listenerFallbehinds { listenerFallbehinds[key] = value + 1 }
            buffer.insert(generator.next(), atIndex: 0)
        }
    }
    
    func element(forListener listener: Listener) -> Element? {
        ensureBufferContainsElement(forListener: listener)
        return buffer[getFallbehind(forListener: listener)!]
    }
    
    func decrementFallbehind(forListener listener: Listener) {
        setFallbehind(getFallbehind(forListener: listener)! - 1, forListener: listener)
    }
    
    private func trimBuffer() {
        // Remove fully consumed buffer elements
        if let maxNecessaryFallbehind = listenerFallbehinds.values.maxElement() {
            while maxFallbehind > maxNecessaryFallbehind {
                buffer.removeLast()
            }
        }
    }
}

extension BufferingGenerator: Comparable {}

func ==<Element>(lhs: BufferingGenerator<Element>, rhs: BufferingGenerator<Element>) -> Bool {
    precondition(lhs.state === rhs.state)
    return lhs.state.getFallbehind(forListener: lhs) == rhs.state.getFallbehind(forListener: rhs)
}

func <<Element>(lhs: BufferingGenerator<Element>, rhs: BufferingGenerator<Element>) -> Bool {
    precondition(lhs.state === rhs.state)
    return lhs.state.getFallbehind(forListener: lhs) > rhs.state.getFallbehind(forListener: rhs)
}
