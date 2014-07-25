% randomly select an element from a list of cumulative probabilities
function result = roulette(cumlProb)
    r = rand;
    result = 0;

    for i = 1 : length(cumlProb)
        if r < cumlProb(i)
            result = i;
            return;
        end

        r = r - cumlProb(i);
    end
end

