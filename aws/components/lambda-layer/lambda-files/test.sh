DIR="./panda-layer"
if [ -d "$DIR" ]; then
rm -rf $DIR
fi

pip3 install pandas --target ./panda-layer
# zip -r ./panda-layer.zip ./panda-layer
# aws s3 cp ./panda-layer.zip s3://test-bucketvikrant/
