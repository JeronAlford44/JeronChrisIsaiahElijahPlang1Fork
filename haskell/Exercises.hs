module Exercises
    ( change,
      firstThenApply,
      powers,
      meaningfulLineCount,
      Shape(..),
      volume,
      surfaceArea,
      BST(Empty),
      insert,
      contains,
      size,
      inorder
    ) where

import qualified Data.Map as Map
import Data.Text (pack, unpack, replace)
import Data.List(isPrefixOf, find)
import Data.Char(isSpace)

change :: Integer -> Either String (Map.Map Integer Integer)
change amount
    | amount < 0 = Left "amount cannot be negative"
    | otherwise = Right $ changeHelper [25, 10, 5, 1] amount Map.empty
        where
          changeHelper [] remaining counts = counts
          changeHelper (d:ds) remaining counts =
            changeHelper ds newRemaining newCounts
              where
                (count, newRemaining) = remaining `divMod` d
                newCounts = Map.insert d count counts

-- Write your first then apply function here

firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply [] _ _ = Nothing
firstThenApply (x:xs) p f
    | p x = f <$> Just x
    | otherwise = firstThenApply xs p f

-- Write your infinite powers generator here

powers :: Integral a => a -> [a]
powers base = map (base^) [0..]

-- Write your line count function here

meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount path = do
    contents <- readFile path
    return $ length $ filter meaningfulLine $ lines contents
    where
        meaningfulLine line = not (all isSpace line) && not (isComment line)
        isComment line = case dropWhile isSpace line of
                          ('#':_) -> True
                          _       -> False


-- Write your shape data type here

data Shape
    = Sphere Double         
    | Box Double Double Double  
    deriving (Eq, Show)

volume :: Shape -> Double
volume (Sphere r) = (4/3) * pi * r^3
volume (Box w h d) = w * h * d

surfaceArea :: Shape -> Double
surfaceArea (Sphere r) = 4 * pi * r^2
surfaceArea (Box w h d) = 2 * (w * h + h * d + d * w)

-- Write your binary search tree algebraic type here

data BST a = Empty | Node a (BST a) (BST a) deriving Eq

insert :: Ord a => a -> BST a -> BST a
insert x Empty = Node x Empty Empty
insert x (Node y left right)
    | x < y     = Node y (insert x left) right
    | x > y     = Node y left (insert x right)
    | otherwise = Node y left right  

contains :: Ord a => a -> BST a -> Bool
contains _ Empty = False
contains x (Node y left right)
    | x < y     = contains x left
    | x > y     = contains x right
    | otherwise = True

size :: BST a -> Int
size Empty = 0
size (Node _ left right) = 1 + size left + size right

inorder :: BST a -> [a]
inorder Empty = []
inorder (Node x left right) = inorder left ++ [x] ++ inorder right

instance Show a => Show (BST a) where
    show Empty = "()"
    show (Node x Empty Empty) = "(" ++ show x ++ ")"
    show (Node x left Empty) = "(" ++ show left ++ show x ++ ")"
    show (Node x Empty right) = "(" ++ show x ++ show right ++ ")"
    show (Node x left right) = "(" ++ show left ++ show x ++ show right ++ ")"