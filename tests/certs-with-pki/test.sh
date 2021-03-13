

K=baz
MYMAP[$K]=quux       # Use a variable as key to put a value into an associative array
echo ${MYMAP[$K]}    # Use a variable as key to extract a value from an associative array
echo ${MYMAP[baz]}   # Obviously the value is accessible via the literal key

echo "---"


K=2
MYMAP[$K]=foo

K=3
MYMAP[$K]=booz

echo "---"
for i in ${MYMAP[@]}; do
    echo $i
done

echo "---"
for i in ${!MYMAP[@]}; do
    echo $i
done

