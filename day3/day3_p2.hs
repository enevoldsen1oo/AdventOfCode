parseLine :: String -> String
parseLine = id

parseInput :: String -> [String]
parseInput content = map parseLine (lines content)

convert :: Char -> Char -> Integer
convert a b = read [a, b] :: Integer
getBiggest [x] = x
getBiggest (first:ls) = result
    where
        result = max first (getBiggest ls)

getCombs :: [Char] -> [Integer]
getCombs [_] = []
getCombs (x:xs) = sublist ++ xCombs
    where
        sublist = getCombs xs
        xCombs = [convert x y | y <- xs]

--findBig :: Char -> String -> Integer
findBig xs = getBiggest list
    where
        list = getCombs xs

-- Find maximum 2-digit number from consecutive character pairs
joltage :: String -> Integer
joltage [] = 0
joltage [_] = 0  -- Single character, can't make a pair
joltage lst = findBig lst

sumJolts lst = sum [joltage line | line <- lst]

showJolts lst = print [joltage line | line <- lst]
main :: IO ()
main = do
    putStrLn "-- Hello ---"
    putStrLn "Day 3 Part 1"
    content <- readFile "interv.txt"
    let parCon = parseInput content
    let result = sumJolts parCon
    putStrLn $ "Maximum: " ++ show result

-- 74
-- 42
-- 32
-- 77
-- 43
-- 87
-- = 355