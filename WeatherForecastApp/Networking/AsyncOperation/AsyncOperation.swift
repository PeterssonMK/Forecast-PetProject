
import Foundation

class AsyncOperation: Operation {
    
    // custom enum with cases representing the state of operation (needed cuz KVO variables are read only)
    enum State: String {
        case ready, executing, finished
        
        // switch for KVO notifications
        fileprivate var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    // variable that will convey the current state of Operation (default = ready)
    // whenever state changes, we need convey this change to KVO
    var state = State.ready {
        willSet {
            
            //these methods used to notify about changes in KVO variables (isReady,isExecuting,isFinished)
            
            // at the change of state
            willChangeValue(forKey: newValue.keyPath) // notify kvo: changing to  ex: finished
            willChangeValue(forKey: state.keyPath)    // notify kvo: changing from  ex: executing
        }
        
            // after the change of state
        didSet {
            didChangeValue(forKey: oldValue.keyPath) // ex: executing
            didChangeValue(forKey: state.keyPath)     // ex: finished
        }
    }
}

extension AsyncOperation {
    
    // overriding the "KVO" variables as computed properties  with enum State attatched
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    override var isAsynchronous: Bool {
        return true
    }
    
    override func start() {         // note: can't use super.start since that would imply synchronous call of main (we want async)
        if isCancelled {
            state = .finished
            return
        }
        
        main() // asynchronous function, returns immediately => need to manually change state in next line
        state = .executing
    }
    
    override func cancel() {
        super.cancel()
        state = .finished           // manually chaning the state
    }
}
