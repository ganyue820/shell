###################################
#Version: 0.0.2
#Before Use: remove .svn file
#Usage: ./doOut dir 0 ,dir must be in same parant dir
#mean: copy encrypt file out
#Usage: ./doOut outdir/dir 1
#mean: recovery file to normal 
# h file and sh file whether PWD has include
###################################
#!/bin/bash

if [ ! $1 ];
then
	echo "first param is null"
    exit
fi

if [ ! -d $PWD/$1 ];then
	echo $1 "is not dir or unexist"
	exit
fi

if [ ! $2 ];
then
	echo "two param is null"
fi

PWDSAVE=$PWD

if [ $2 == 0 ];
then


OUTDIR=$PWD/outdir

fileTobin(){
all=`ls -a .`
for i in $all
do
  echo "=====>[$i]"
  if [ "$i"x == "."x ];then
	continue
  elif [ "$i"x == ".."x ];then
	continue
  fi

  if [ -d $i ];then
	  mkdir $OUTDIR/$i
	  OUTDIR=$OUTDIR/$i
	  cd $i
	  fileTobin 
	  cd ..
	  OUTDIR=${PWD/$PWDSAVE/$PWDSAVE\/outdir}
  else
  	  sfile=${i//./} 
	  cat $i > $OUTDIR/$sfile
	  echo $i >> $OUTDIR/bake
  fi
done
}

if [ -d  $PWD/outdir ];then
	rm -rf $PWD/outdir
fi
mkdir $OUTDIR

if [ -d $1 ]
then
	cd $1
	OUTDIR=$OUTDIR/$1
	mkdir $OUTDIR
	fileTobin 
fi

else

OUTDIR=$PWD
fileRecovery(){
all=`ls  .`
for i in $all
do
  if [ "$i"x == "."x ];then
    continue
  elif [ "$i"x == ".."x ];then
    continue
  fi 
  if [ -d $i ];then
	  cd $i
	  fileRecovery
	  cd ..
  else
 	  while read realfn
	  do
		 temp=$realfn
 		 if [[ ${temp//./} == $i ]];then
			mv $i $realfn
			echo "------->"$realfn
		 fi
	  done < bake   
 fi
done
}

if [[ $1 =~ "outdir" ]];then

cd $OUTDIR/$1
fileRecovery 
find $PWDSAVE/$1 -name bake |xargs rm -rf
else
	echo "dir error ./doOut outdir/xxxx 1"
fi
fi
