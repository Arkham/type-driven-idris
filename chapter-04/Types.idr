module Types

data Direction = North | East | South | West

turnClockwise : Direction -> Direction
turnClockwise North = East
turnClockwise East = South
turnClockwise South = West
turnClockwise West = North

||| Represents shapes
data Shape = ||| A triangle, with its base length and height
             Triangle Double Double
           | ||| A rectangle, with its length and height
             Rectangle Double Double
           | ||| A circle, with its radius
             Circle Double
%name Shape shape, shape1, shape2

area : Shape -> Double
area (Triangle x y) = x * y / 2
area (Rectangle x y) = x * y
area (Circle x) = pi * x * x

data Picture = Primitive Shape
             | Combine Picture Picture
             | Rotate Double Picture
             | Translate Double Double Picture
%name Picture pic, pic1, pic2

pictureArea : Picture -> Double
pictureArea (Primitive shape) = area shape
pictureArea (Combine pic pic1) = pictureArea pic + pictureArea pic1
pictureArea (Rotate x pic) = pictureArea pic
pictureArea (Translate x y pic) = pictureArea pic

data Tree el = Empty
               | Node (Tree el) el (Tree el)
%name Tree tree, tree1

insert : Ord el => el -> Tree el -> Tree el
insert x Empty = Node Empty x Empty
insert x orig@(Node left y right) =
  case compare x y of
    LT => Node (insert x left) y right
    EQ => orig
    GT => Node left y (insert x right)

-- data BSTree : Type -> Type where
--   BSEmpty : Ord el => BSTree el
--   BSNode : Ord el => (left : BSTree el) -> (val : el) ->
--                    (right : BSTree el) -> BSTree el

-- insertBSTree : el -> BSTree el -> BSTree el
-- insertBSTree x BSEmpty = BSNode BSEmpty x BSEmpty
-- insertBSTree x orig@(BSNode left val right) =
--   case compare x val of
--     LT => BSNode (insertBSTree x left) val right
--     EQ => orig
--     GT => BSNode left val (insertBSTree x right)

-- Exercises

listToTree : Ord a => List a -> Tree a
listToTree [] = Empty
listToTree (x :: xs) = insert x (listToTree xs)

treeToList : Tree a -> List a
treeToList Empty = []
treeToList (Node tree x tree1) = treeToList tree ++ [ x ] ++ treeToList tree1

data Expr = Val Int
          | Add Expr Expr
          | Sub Expr Expr
          | Mult Expr Expr

evaluate : Expr -> Int
evaluate (Val x) = x
evaluate (Add x y) = evaluate x + evaluate y
evaluate (Sub x y) = evaluate x - evaluate y
evaluate (Mult x y) = evaluate x * evaluate y

maxMaybe : Ord a => Maybe a -> Maybe a -> Maybe a
maxMaybe Nothing Nothing = Nothing
maxMaybe Nothing (Just x) = Just x
maxMaybe (Just x) Nothing = Just x
maxMaybe (Just x) (Just y) = case x > y of
                                  False => Just y
                                  True => Just x

biggestTriangle : Picture -> Maybe Double
biggestTriangle (Primitive orig@(Triangle x y)) = Just (area orig)
biggestTriangle (Primitive (Rectangle x y)) = Nothing
biggestTriangle (Primitive (Circle x)) = Nothing
biggestTriangle (Combine pic pic1) = maxMaybe (biggestTriangle pic) (biggestTriangle pic1)
biggestTriangle (Rotate x pic) = biggestTriangle pic
biggestTriangle (Translate x y pic) = biggestTriangle pic

testPic1 : Picture
testPic1 = Combine (Primitive (Triangle 2 3))
                   (Primitive (Triangle 2 4))
testPic2 : Picture
testPic2 = Combine (Primitive (Rectangle 1 3))
                   (Primitive (Circle 4))
