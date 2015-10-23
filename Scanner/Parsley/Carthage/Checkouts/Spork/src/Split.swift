// You may NOT call next on a generator after it is split!!!

extension GeneratorType {
    func split() -> (ForkableGenerator<Element>, ForkableGenerator<Element>) {
        let parent = ForkableGenerator(bridgedFromGenerator: self)
        return (parent, parent.fork())
    }
}

extension ForkableGeneratorType {
    func split() -> (Self, Self) {
        return (self, fork())
    }
}
