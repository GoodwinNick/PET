import Foundation

class MulticastDelegate<T> {

    private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

    func add(_ delegateToAdd: T) {
        delegates.add(delegateToAdd as AnyObject)
    }

    func remove(_ delegateToRemove: T) {
        for delegate in delegates.allObjects {
            if delegate === delegateToRemove as AnyObject {
                delegates.remove(delegate)
            }
        }
    }

    func invoke(_ invocation: (T) -> Void) {
        for delegate in delegates.allObjects {
            invocation(delegate as! T)
        }
    }
}
