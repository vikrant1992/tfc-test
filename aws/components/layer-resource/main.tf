module "layer" {
    source = "../lambda-layer-module"
    script_path = "./lambda-files/test.sh"
    source_dir = "./panda-layer"

}