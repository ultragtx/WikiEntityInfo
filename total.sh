total=0
for x in `find ./ -name "*.rb"`;
do
	single=`cat $x|wc -l`
	total=$total+$single
done

for x in `find ./ -name "*.erb"`;
do
	single=`cat $x|wc -l`
	total=$total+$single
done

for x in `find ./ -name "*.java"`;
do
	single=`cat $x|wc -l`
	total=$total+$single
done
 
echo $total|bc