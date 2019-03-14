if [ "$1" != "" ]
then
    ns=$1
else
    echo "usage: go_vet.sh [namespace]"
    exit
fi

# this is a slightly less horrible version of 
# go_vet.sh, for use with just the `cmd` section
# of a Go project (can be `pkg` or anything in your
# imagination really). You can just do:
#
# go get whatever.io/whatever
# go_vet_less_horrible.sh whatever.io/whatever
#
# and it should Just Work(TM) 
# 
# void where prohibited 
# must be 18 years or older
# kids ask your parents' permission before using


for i in cmd/*
do
    if [ -d "$i" ]
    then
        echo "running $ns/$i"
        go vet $ns/$i 2>&1 | tee -a go_vet.log
    fi
done
