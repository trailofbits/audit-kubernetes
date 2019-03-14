if [ "$1" != "" ]
then
    ns=$1
else
    echo "usage: go_vet.sh [namespace]"
    exit
fi

for i in `find . -name "*.go" -exec dirname \{\} \; | uniq`
do
    if [ -d "$i" ]
    then
        echo "running $ns/$i"
        echo "go vet $ns/$i 2>&1 | tee -a go_vet.log" >> run_gv.sh
    fi
done
