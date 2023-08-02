DIR="./panda-layer/python"
if [ -d "$DIR" ]; then
rm -rf $DIR
fi

mkdir -p $DIR
pip3 install pandas --target $DIR

