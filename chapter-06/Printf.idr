module Printf

data Format = Number Format
            | Str Format
            | Lit String Format
            | End

PrintfType : Format -> Type
PrintfType (Number fmt) = (i : Int) -> PrintfType fmt
PrintfType (Str fmt) = (str : String) -> PrintfType fmt
PrintfType (Lit str fmt) = PrintfType fmt
PrintfType End = String

printfFmt : (fmt : Format) -> (acc : String) -> PrintfType fmt
printfFmt (Number x) acc = \i => printfFmt x (acc ++ show i)
printfFmt (Str x) acc = \str => printfFmt x (acc ++ str)
printfFmt (Lit x y) acc = printfFmt y (acc ++ x)
printfFmt End acc = acc

toFormat : (xs : List Char) -> Format
toFormat [] = End
toFormat ('%' :: 'd' :: chars) = Number (toFormat chars)
toFormat ('%' :: 's' :: chars) = Str (toFormat chars)
toFormat ('%' :: chars) = Lit "%" (toFormat chars)
toFormat (c :: chars) = case toFormat chars of
                             Lit lit chars' => Lit (strCons c lit) chars'
                             fmt => Lit (strCons c "") fmt

printf : (fmt : String) -> PrintfType (toFormat (unpack fmt))
printf fmt = printfFmt _ ""
