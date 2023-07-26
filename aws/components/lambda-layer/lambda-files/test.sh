DIR="./panda-layer/python"
if [ -d "$DIR" ]; then
rm -rf $DIR
fi

pip3 install pandas --target $DIR