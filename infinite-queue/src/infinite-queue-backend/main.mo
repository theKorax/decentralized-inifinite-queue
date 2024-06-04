import Iter "mo:base/Iter";
import Float "mo:base/Float";

actor QueueApp {

    // Define the queue type
    public type QueueType = {
        #Infinite;
        #Finite;
    };

    // Function to calculate probability of exactly n people in the system (Infinite Queue)
    public func probExactInfinite(num: Int, rho: Float): async Float {
        return (rho ** Float.fromInt(num)) * (1.0 - rho);
    };

    // Function to calculate the probability of at least n people in the system (Infinite Queue)
    public func probAtleastInfinite(num: Int, rho: Float): async Float {
        var summationRes: Float = 0.0;
        for (i in Iter.range(0, num - 1)) {
            summationRes += (rho ** Float.fromInt(i)) * (1.0 - rho);
        };
        return 1.0 - summationRes;
    };

    // Function to calculate the probability of at most n people in the system (Infinite Queue)
    public func probAtmostInfinite(num: Int, rho: Float): async Float {
        var summationRes: Float = 0.0;
        for (i in Iter.range(0, num)) {
            summationRes += (rho ** Float.fromInt(i)) * (1.0 - rho);
        };
        return summationRes;
    };

    // Function to calculate probability of exactly n people in the system (Finite Queue)
    public func probExactFinite(num: Int, rho: Float, N: Int): async Float {
        return (rho ** Float.fromInt(num)) * ((1.0 - rho) / (1.0 - (rho ** (Float.fromInt(N) + 1.0))));
    };

    // Function to calculate the probability of at least n people in the system (Finite Queue)
    public func probAtleastFinite(num: Int, rho: Float, N: Int): async Float {
        var summationRes: Float = 0.0;
        for (i in Iter.range(0, num - 1)) {
            summationRes += (rho ** Float.fromInt(i)) * ((1.0 - rho) / (1.0 - (rho ** (Float.fromInt(N) + 1.0))));
        };
        return 1.0 - summationRes;
    };

    // Function to calculate the probability of at most n people in the system (Finite Queue)
    public func probAtmostFinite(num: Int, rho: Float, N: Int): async Float {
        var summationRes: Float = 0.0;
        for (i in Iter.range(0, num)) {
            summationRes += (rho ** Float.fromInt(i)) * ((1.0 - rho) / (1.0 - (rho ** (Float.fromInt(N) + 1.0))));
        };
        return summationRes;
    };

    // Main function to calculate queue statistics for infinite queues
    public func calculateInfiniteQueue(arrivalRate: Float, serviceRate: Float): async (Float, Float, Float, Float) {
        let rho = arrivalRate / serviceRate;
        let Ls = rho / (1.0 - rho);
        let Lq = Ls - rho;
        let Ws = Ls / arrivalRate;
        let Wq = Lq / arrivalRate;
        return (Ls, Lq, Ws, Wq);
    };

    // Main function to calculate queue statistics for finite queues
    public func calculateFiniteQueue(N: Int, arrivalRate: Float, serviceRate: Float): async (Float, Float, Float, Float) {
        let rho = arrivalRate / serviceRate;
        let Ls = (rho * (1.0 + Float.fromInt(N) * (rho ** (Float.fromInt(N) + 1.0)) - (Float.fromInt(N) + 1.0) * (rho ** Float.fromInt(N)))) / ((1.0 - rho) * (1.0 - (rho ** (Float.fromInt(N) + 1.0))));
        let exactFinite = await probExactFinite(N, rho, N);
        let arrEff = arrivalRate * (1.0 - exactFinite);
        let Lq = Ls - (arrEff / serviceRate);
        let Ws = Ls / arrEff;
        let Wq = Lq / arrEff;
        return (Ls, Lq, Ws, Wq);
    };

    // Function to get the probability for infinite queue
    public func getProbabilityInfinite(option: Int, num: Int, rho: Float): async Float {
        switch (option) {
            case (1) { return await probExactInfinite(num, rho); };
            case (2) { return await probAtleastInfinite(num, rho); };
            case (3) { return await probAtmostInfinite(num, rho); };
            case(_){return 0.0;}
        };
        return 0.0;
    };



    // Function to get the probability for finite queue
    public func getProbabilityFinite(option: Int, num: Int, rho: Float, N: Int): async Float {
        switch (option) {
            case (1) { return await probExactFinite(num, rho, N); };
            case (2) { return await probAtleastFinite(num, rho, N); };
            case (3) { return await probAtmostFinite(num, rho, N); };
            case(_){return 0.0;};
        };
        return 0.0;
    };
}
